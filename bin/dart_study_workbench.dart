void main(List<String> arguments) {
  // print('Hello world: ${dart_language_test.calculate()}!');
  // dart_syntaxBasicsAndTypes.syntaxAndTypes();

  /// PATTERNS
  /// A pattern represents the shape of a set of values that it may match against actual values.
  /// 
  /// In general, a pattern may match a value, destructure a value, or both.
  /// -- MATCHING
  /// A pattern always tests against a value to determine if the value has the form you expect
  /// (you are checking if the value matches the pattern).
  
  /// CONSTANT PATTERN -- matches if the value is equal to the pattern's constant.
  const number = 0;
  switch (number) {
    // Constant pattern matches if 1 == number.
    case 1:
    print('one');
  }
  
  /// SUBPATTERNS -- outer and inner patterns
  /// Patterns match recursively on their subpatterns
  var obj;
  const a = 'a';
  const b = 'b';
  obj = [a, b];
  switch (obj) {
    // List pattern [a, b] matches obj first if obj is a list wih two fields,
    // then if its fields match the constant subpatterns 'a' and 'b'
    case [a, b]:
    print('$a, $b');
  }

  /// DESTRUCTURING
  /// When an object and pattern match, the pattern can then access the object's data
  /// and extract it in parts (destructures the object)
  var numList = [1, 2, 3];
  // List pattern [a, b, c] destructures the three elements from numList...
  var [c, d, e] = numList;
  // ... and assigns them to new variables.
  print("$c $d $e");

  // This case pattern matches and destructures a two-element list whose first element is 'a' or 'b'
  var list = ['b', 'coiso'];
  switch (list) {
    case['a' || 'b', var c]:
      print(c);
  }

  /// PLACES PATTERNS CAN APPEAR
  /// 
  /// Variable declaration
  /// Once the pattern is matched against the value on the right of the declaration,
  /// it destructures the value and binds it to new local variables
  // Declares new variables a, b and c.
  var (aVD, [bVD, cVD]) = ('str', [1, 2]);
  // A pattern variable declaration must start with either var or final, followed by a pattern.

  /// Variable assignment
  /// A variable assignment pattern falls on the left side of an assignment.
  /// First, it destructures the matched object, then it assigns the values to existing variables.
  var (aVA, bVA) = ('left', 'right');
  (bVA, aVA) = (aVA, bVA); // Swap.
  print('$aVA $bVA');

  /// Switch statements and expressions
  /// You can use any kind of pattern in a case clause.
  /// This applies to swith statements and expressions, as well as if-case statements.
  // obj = 1; // 1st case
  // obj = 2; // 2nd case
  obj = (3, 7); // 3rd case
  switch (obj) {
    // Matches if 1 == obj.
    case 1:
      print('one');
    // Matches if the value of obj is between the constant values of 'a' and 'b'.
    // case >= 1 && <= 3:
      // print('in range');
    // Matches if obj is a record with two fields, then assigns the fileds to a 'aSSE' and 'bSSE'.
    case (var aSSE, var bSSE):
      print('a = $aSSE, b = $bSSE');
    default:
  }

  /// Logical-or patterns are useful for having multiple cases share a body in switch expressions or statements
  // print(obj);
  var (aLOP, bLOP) = obj;
  var isPrimary = switch (aLOP) {
    1|| 2 || 7 => true, 
    _ => false
  };
  print(isPrimary);


  /// Switch statements can have multiple cases share a body without using logical-or patterns,
  /// but they are still uniquely useful for allowing multiple cases to share a guard
  var shape = Circle(3);

  switch (shape) {
    case Square(length: var s) || Circle(radius: var s) when s > 0:
      print('Non-empty symmetric shape');
  }

  /// Guard clauses evalute an arbitrary condition as part of a case
  /// (whitout exiting the switch if the condition is false (like using an if statement in the case body would cause))
  switch (obj) {
    // case (int aGC, int bGC):
    //   if (aGC >  bGC) print('First element greater');
      // If false, it prints nothing and exits the switch
    case (int aGC, int bGC) when aGC > bGC:
      // If false, prints nothing but proceeds to next case
      print('First element greater');
    case (int aGC, int bGC):
      print('First element not greater');
  }

  /// You can use patterns in for and for-in loops to iterate-over and destructure values in a collection.
  /// FOR and FOR-IN Loops
  Map<String, int> hist = {
    'a': 23,
    'b': 100,
  };

  for (var MapEntry(key: key, value: count) in hist.entries) {
    print('$key occurred $count times');
  }
  // print(hist.entries);
  // The object pattern checks that hist.entries has the named type MapEntry and then recurses into the named field subpatterns key and value. It calls the key getter and value getter on the MapEntry in each iteration and binds the results to local variables key and count, respectively.

  // Binding the result of a getter call to a variable of the same name can be simplified from something redundant like key: key to just :key
  for (var MapEntry(:key, value: count) in hist.entries) {
    print('$key occurred $count times');
  }

  /// USE CASES FOR PATTERNS
  /// 
  /// Destructuring multiple returns
  var info = {'name': 'John', 'age': 45};
  var infoFunctResult = (info['name'], info['age']);
  // Instead of
  // var name = infoFunctResult.$1;
  // var age = infoFunctResult.$2;
  // One can destructure the fields of a record that a function returns into local variables using: variable declaration, assignment pattern and record pattern as its subpattern:
  var (name, age) = infoFunctResult;
  // print('$name: $age');

  
  /// Destructuring class instances
  final Foo myFoo = Foo('one', 2);
  var Foo(:one, :two) = myFoo;
  print('one $one, two $two');

  /// Validating incoming JSON
  var json = {
    'user': ['Lily', 13]
  };

  var {'user': [nameJSON, ageJSON]} = json;
  print('name: $nameJSON, $ageJSON years old');

  if (json case {'user': [String name, int age]}) {
    print('User $name is $age years old');
  }

  /// Logical-and
  /// Subpatterns in a logical--and pattern can bind variaables, but the variables in each subpattern
  /// must not overlap, because they will both be boound if the pattern matches.
  // switch ((1, 2)) {
  //   // Error, both subpatterns attempt to bind 'b'
  //   // Error: 'b' is already declared in this scope.
  //   case (var a, var b) && (var b, var c):
  //     print('$a -- $b -- $c');
  // }

  /// Relational
  print(asciiCharType(23));

  /// Cast
  /// A cast pattern lets you insert a type cast in the middleof destructuruing, before passing the value to another subpattern
  (num, Object) record = (1, 's');
  var (i as int, s as String) = record;
  print('($i, $s)');
  ///  Cast patterns will throw if the value doesn't have the stated type.

  /// Null-check
  /// Null-check patterns match first if the value is not null and then match the inner pattern against that same value.
  /// To treat null values as match failures without throwing, use the null-check pattern.
  String? maybeString = 'nullable with base type String';
  switch (maybeString) {
    case var s?:
      // 's' has type non-nullable String here.
  }

  /// Null-assert
  /// Null-assert patterns match first if the object is not null, then on the value. They permit non-null values
  /// to flow through, but throw if the matched value is null.
  /// To ensure null values are not silently treated as match failures, use a null-assert pattern while matching
  List<String?> row = ['user', null];
  switch (row) {
    case ['user', var name]:
      // 'name' is a non-nullable string here.
  }
  // To eliminate null values from variable declaration patterns, use the null-assert pattern.
  (int?, int?) position = (2, 3);
  var (x!, y!) = position; // post operator ! - non-null assertion operator


  /// To match when the value is null, use the constant pattern null.
  /// 
  /// Contant
  /// 123, null, 'string, math.pi, SomeClass.constant, const Thing(1, 2), const (1+2)
  switch (number) {
    // Matches if 1 == number
    case 1: // ...
    case null: /// ...
  }

  /// Variable
  /// Variable patterns bind new variables to values that have been matched or destructured.
  switch ((1, 2)) {
    case (var a, var b):
      // 'a' and 'b' are in scope in the case body.
      print('($a, $b)');
    case (int a, String b):
      // Does not match -- will never match
      print('($a, $b)');

    /// identifier
    case (_, var b):
      /// wildcard identifier in any context: matches any value and discards it
      /// case [_, var y, _]: print('The middle element is $y');
      print('The second pair-element is $b');
  }

  /// Parenthesized (subpattern)
  /// Parentheses in a pattern let you control pattern precende and insert a lower-precedence pattern where a higher precedence one is expected.
  var (xP, yP, zP) = (true, true, false);
  print(xP || yP && zP); // prints true --> xP OR (yP && zP)
  print((xP || yP) && zP); // prints false --> (xP || yP) AND zP

  /// List [subpattern1, subpattern2]
  /// A list pattern matches values that implement List, and then recursively matches its subpatterns against the list's elements to destructure them by position
  switch (obj) {
    case (3, 7):
      print(obj);
    case [a, b]:
      print('$a, $b');
  }
  /// List patterns require that the number of elements in the pattern match the entire list.
  
  /// Rest element
  /// The use of a rest element as a place holder accounts for any number of elements in a list.
  /// List patterns can contain one rest element (...) which allows matching list of arbitratry lengths.
  var [aRe, bRe, ..., cRe, dRe] = [1, 2, 3, 4, 5, 6, 7];
  print('$aRe $bRe $cRe $dRe');

  /// A rest element can also have a supattern that collects elements that don't match the other supatterns in the list into a new list
  var [aR, bR, ...rest, cR, dR] = [1, 2, 3, 4, 5, 6, 7];
  print('$aR $bR $cR $dR -- $rest'); // 1 2 6 7 -- [3, 4, 5]

  /// Map {'key': subpattern1, someConst: supattern2}
  /// Map patterns match values that implement Map 
  /// and then recursively match its subpattterns agains the map's keys to destructure them.
  /// Map patterns don't require the pattern to match the entire map; a map ignores any keys that the map contains that aren't matched by the pattern.
  print({'key': 13});
  switch ({'key': 13}) {
    case {'chave': 13}:
      print('Match!!');
    case {'key': 13}:
      print('Middle case match!');
    case {null: _}:
      print('General Match!!');
  }
  
  /// Record (subpattern1, subpattern2) --- (x: subpattern1, y: subpattern2)
  /// Record patterns match a record and destructure its fields.
  /// Record patterns require that the pattern match the entire record!
  /// To destructure a record with named fields using a pattern, include the field names in the pattern
  var (myString: foo, myNumber: bar) = (myString: 'string', myNumber: 3);
  print('$foo -- $bar');

  /// The getter name can be ommited and inferred from the varable pattern or identifier pattern in the field subpattern.
  /// The following pairs are each equivalent
  /// 
  // Record pattern with variable subpatterns
  // var (untyped: untype, typed: int typed) = record;
  // var (:untyped, :int typed) = record;
  // 
  // switch (record) {
  //   case(untyped: var untyped, typed: int typed): // ...
  //   case (:var untyped, :int typed): // ...
  // }
  // 
  // Record with null-check and null-assert subpatterns
  // switch (record) {
      // case (checked: var checked?, asserted: var asserted!): // ...
      // case (:var checked?, :var asserted!): // ...
  // }
  // 
  // Record pattern with cast subpattern
  // var (untyped: untyped as int, typed: typed as String) = record;
  // var (:untyped as int, :typed as String) = record;

  /// Object
  /// Object patterns check the matched value agains a given named type to destructure data using getters on the object's properties.
  // switch (shape) {
  //   // Matches if shape is of type Rect and then against the properties of Rect.
  //   case Rect(width: var w, height: var h): // ...
  // }
  // 
  // The getter name can be omitted and inferred from the variable pattern and identifier pattern in the field subpattern
  // Bind new variables x an y to the values of Point's x an y properties
  // var Point(:x, :y) = Point(1, 2);
  /// Object patterns don't require the parttern to match the entire object.
  
}

class Foo {
  var one, two;
  Foo(this.one, this.two);
}

/// Algebraic data types
/// Instead of implementing the operation as an instance method for every type, keep the operation's variations in a single function that switches over the subtypes:
sealed class Shape{}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => 3.14 * r * r
};

/// Relational
String asciiCharType(int char) {
  const space = 32;
  const zero = 48;
  const nine = 57;

  return switch (char) {
    < space => 'control',
    == space => 'space',
    > space && < zero => 'punctuation',
    >= zero && <= nine => 'digit',
    _ => '',
  };
}