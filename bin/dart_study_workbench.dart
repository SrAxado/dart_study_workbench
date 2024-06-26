// import 'package:dart_study_workbench/dart_patterns.dart';
// import 'package:dart_study_workbench/dart_functions.dart';
// import 'package:dart_study_workbench/dart_classes.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:isolate';

import 'package:dart_study_workbench/dart_concurrency.dart';

extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;

  E get num => this;
}

main(List<String> arguments) async {
  // print('Hello world: ${dart_language_test.calculate()}!');
  // dart_syntaxBasicsAndTypes.syntaxAndTypes();
  // patternsStudy();
  // functionsStudy();

  // print(arguments);
  // assert(arguments.length == 2);
  // assert(int.parse(arguments[0]) == 1);
  // assert(arguments[1] == 'test');

  // var a = Point(2, 2);
  // var b = Point(4, 4);
  // var distance = Point.distanceBetween(a, b);
  // assert(2.8 < distance && distance < 2.9);
  // print(distance);

  // var employee = Person('Zé');
  // var employee = Employee('Zé dos baldes');
  // print(employee.name);

  // var logger = Logger('UI');
  // logger.log('Button clicked');
  // var logMap = {'name': 'UI'};
  // var loggerJson = Logger.fromJson(logMap);
  // print(loggerJson.name);

  // final v = Vector(2, 3);
  // final w = Vector(4, 1);

  // assert(v + w == Vector(6, 4));
  // assert(v - w == Vector(-2, 2));

  // var rect = Rectangle(3, 4, 20, 15);
  // print(rect.vertexX);
  // rect.right = 12;
  // print(rect.vertexX);

  // var coiso = E(4);
  // coiso = E.n(2);
  // coiso = E.m(5, "Hello!");
  // print(coiso);

  // print('coiso antes');
  // // Read some data.
  // // final fileData = readFileSync();
  // final fileData = await readFileAsync();
  // final jsonData = jsonDecode(fileData);
  // print('coiso');

  // // Use that data.
  // print('Number of JSON keys: ${jsonData.length}');

  // // Running an existing method in a new isolate
  // final jsonData2 = await Isolate.run(readFileAndParseJson);
  // // print('Coiso Isolate --> ${await Isolate.run(readFileAndParseJson)}');
  // print('Coiso Isolate --> ${jsonData2}');

  // // Sending closures with isolates
  // final jsonData3 = await Isolate.run(() async {
  //   final fileData = await File(filename).readAsString();
  //   final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  //   sleep(Duration(seconds: 2));
  //   return jsonData;
  // });
  // // The isolate may return a Future, but doesn't "run in parallel"
  // print('Before JSON_3');

  // print('Number of JSON_3 keys: ${jsonData3.length}');

  // final worker = Worker();
  // await worker.spawn();
  // await worker.parseJson('{"key":"value"}');

  final robustWorker = await RobustWorker.spawn();
  print(await robustWorker.parseJson('{"key": "value"}'));
  // print(await robustWorker.parseJson('"banana"'));
  // print(await robustWorker.parseJson('[true, false, null, 1, "string"]'));
  // print(await Future.wait(
  //     [robustWorker.parseJson('"yes"'), robustWorker.parseJson('"no"')]));
  robustWorker.close();
}
