void functionsStudy() {
  /// Functions are objects and a type, Function.
  /// This means that functions can be assigned to variables or passed as arguments to other functions.
  List<bool> _nobleGases = [];

  bool isNoble(int atomicNumber) {
    return _nobleGases[atomicNumber] != null;
  }

  /// Although Effective Dart recommends type annotations for public APIs, the function still works if you omit the types.

  /// For functions that contain just one expression, we can use a shorthand syntax
  bool isNobleShortSyntax(int atomicNumber) =>
      _nobleGases[atomicNumber] != null;

  /// The => syntax is a shothand for { return expr; }.
  /// The => notation is sometimes referred to as arrow syntax.

  /// Parameters
  /// Named parameteres are optional unless they're explicitly marked as required.
  /// Use {param1, param2, ...} to specify named parameters.
  /// If you don't provide a default value or mark a named parameter as required, their types must be nullable as their default value will be null
  void enableFlags({bool? bold, bool? hidden}) {}

  /// When calling a function, one can specify named arguments using paramName: value
  enableFlags(bold: true, hidden: false);

  /// To define a default value for a named parameter besides null, use = to specify a default value.
  /// The specified value must be a compile-time constant.
  void enableFlags2({bool bold = false, bool hidden = false}) {}

  // bold will be true; hidden will be false
  enableFlags2(bold: true);

  /// If one wants a named parameter to be mandatory, annotate them with required
  // const ScrollBar({super.key, required Widget child}) {};
  // If someone tries to create a ScrollBar withour specifying the child argument, then the analyzer reports an issue.

  /// A parameter marked as required can still be nullable
  // const ScrollBar({super.key, required Widget? child});

  /// Optional positional parameters
  /// Wrapping a set of function parameters in [] marks them as optiional positional parameters.
  /// If you don't provide a default value, their types must be nullable as their default value will be null.
  String say(String from, String msg, [String? device]) {
    var result = '$from says $msg';
    if (device != null) {
      result = '$result with a $device';
    }
    return result;
  }

  assert(say('Bob', 'Howdy') == 'Bob says Howdy');
  assert(say('Bob', 'Howdy', 'smoke signal') ==
      'Bob says Howdy with a smoke signal');

  /// To define a default value for an optional positional parameter besides null, use = to specify a default value.
  /// The specified value must be a compile-time constant.
  String say2(String from, String msg, [String device = 'carrier pigeon']) {
    var result = '$from says $msg with a $device';
    return result;
  }

  /// The main function
  /// Every app must have a top-level main() function, which serves as the entrypoint to the app. The main() function return void
  ///and has an optional List<String> parameter for arguments.

  /// Functions as first-class objects
  /// You can pass a function as a parameter to another function
  void printElement(int element) {
    print(element);
  }

  var list = [1, 2, 3];
  list.forEach(printElement);

  /// One can also assign a function to a variable
  var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
  assert(loudify('hello') == '!!! HELLO !!!');

  /// Lexical closures
  /// A closure is a function object that has access to variables in its lexical scope, even when the function is used outside
  ///of its original scope.
  /// Functions can close over variables defined in surrounding scopes. In the following example, makeAdder() captures the variable addBy.
  /// Wherever the returned functions goes, it remembers addBy

  // Returns a function that adds [addBy] to the function's argument
  Function makeAdder(int addBy) {
    return (int i) => addBy + i;
  }

  var add2 = makeAdder(2);
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);

  /// Functions and Methods
  // void foo() {}; // A top-level function

  // class A {
  //   static void bar() {} // A static method
  //   void baz() {} //An instance method
  // }
}
