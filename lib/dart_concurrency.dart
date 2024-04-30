import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:async';

const String filename = './lib/with_keys.json';

String readFileSync() {
  final file = File(filename);
  final contents = file.readAsStringSync();
  return contents.trim();
}

Future<String> readFileAsync() async {
  final file = File(filename);
  final contents = await file.readAsString();

  sleep(Duration(seconds: 3));

  return contents.trim();
}

Future<Map<String, dynamic>> readFileAndParseJson() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;

  sleep(Duration(seconds: 1));

  return jsonData;
}

// Sending multiple messages between isolates with ports
// --- Basic ports example ---
class Worker {
  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();

  /// Worker.spawn is where one groups the code for creating the worker isolate and ensuring it can receive and send messages.
  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  /// Worker._handleResponsesFromIsolate tells the main isolate how to handle messages sent from the worker isolate
  ///back to te main isolate.
  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

  /// Worker._startRemoteIsolate is like the "main" method for the worker isolate.
  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      if (message is String) {
        final transformed = jsonDecode(message);
        port.send(transformed);
      }
    });
  }

  /// Worker.parseJson is responsible for sending messages to the worker isolate.
  /// It also needs to ensure that messages can be sent before the isolate is fully set up.
  Future<void> parseJson(String message) async {
    await _isolateReady.future; // Send future object back to client.
    _sendPort.send(message);
  }
}

/// --- Robust ports example ---
class RobustWorker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Future<Object?> parseJson(String message) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));
    return await completer.future;
  }

  static Future<RobustWorker> spawn() async {
    //Functionality to create a new Worker object with a connection to a spawned isolate.

    /// By creating a RawReceivePort first and then a ReceivePort, we're able to add a new callback to ReceivePort.listen later on.
    /// Conversely, if one would implemente ReceivePort straight away, one would only be able to add one listener,
    ///because ReceivePort implements Stream, rather than BroadcastStream.
    ///
    /// Effectively, this allows to separate isolate start-up logic from the logic that handles receiving messages
    /// after setting up communication is complete.

    // Create a receive port and add its initial message handler.
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    // Spawn the isolate.
    // Attempts to spawn a worker isolate; if spawing worker isolate fails, close the receive port.
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    // awaits the connection.future and destructure the send and receive ports from the record it returns.
    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    // Returns an instance of RobustWorker by calling its private constructor and passing in the ports from that completer.
    // return RobustWorker._(sendPort, receivePort);
    return RobustWorker._(receivePort, sendPort);

    /// RobustWorker.spawn acts as an asynchronous static constructor for this class
    /// and is the only way to create an instance of RobustWorker.
    /// This simplifies the API, making the code that creates an instance of RobustWorker cleaner.

    // throw UnimplementedError();
  }

  // RobustWorker._(this._commands, this._responses) {
  RobustWorker._(this._responses, this._commands) {
    // Initialize main isolate receive port listener.
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // Handle messages sent back from the worker isolate.
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;
    if (message is RemoteError) {
      // throw message;
      completer.completeError(response!);
    } else {
      // print(message);
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
    // ) async {
  ) {
    // Handle messages sent back from the worker isolate.
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, String jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    // Initialize worker isolate's ports.
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
      print('--- Port closed ---');
    }
  }
}
