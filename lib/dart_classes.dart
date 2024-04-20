import 'dart:math';

/// Constructors
/// By default, a constructor in a subclass calls the superclass's unamed, no-argument constructor.
/// The superclass's constructor is called at the beginning of the constructor body.
/// If an initializer list is also being used, it executes before the superclass is called.
/// The order of execution is as follows:
/// 1. initializer list
/// 2. superclass's no-arg constructor (this constructor must really be a no-arg one)
/// 3. main class's no-arg constructor (this constructor can be a regular unnamed one (with arguments))

class Person {
  // In the interface, but visible only in this library.
  String? _name;

  /// Generative constructor with initializing formal parameters.
  // Not in the interface, since this is a constructor.
  Person(this._name);

  String? get name => _name;

  // Named constructor.
  Person.fromJson(Map data) {
    print('[$data]: in Person');
  }

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name';
}

class Impostor implements Person {
  String get _name => '';

  String greet(String who) => 'Hi $who. Do you know who I am?';

  @override
  set _name(String? __name) {
    _name = '';
  }

  @override
  // TODO: implement name
  String? get name => throw UnimplementedError();
}

class Employee extends Person {
  Employee.fromJson(super.data) : super.fromJson() {
    print('in Employee');
  }

  /// Constructors are not inherited, which means that a superclass's named constructor is not inherited by a subclass.
  // If you want a subclass to be created with a named constructor defined in the superclass, one must implement
  //that constructor in the subclass.
  Employee(super._name);
}

class Point {
  final double x, y, distanceFromOrigin;
  // Sets the x and y instance variables before the constructor body runs.
  Point(this.x, this.y, this.distanceFromOrigin);

  // Named constructor.
  // Point.origin(x, y)
  //     : x = x,
  //       y = y,
  //       distanceFromOrigin = sqrt(x * x + y * y);
  // Point.origin(this.x, this.y) : distanceFromOrigin = sqrt(x * x + y * y);
  Point.origin(this.x, this.y)
      : distanceFromOrigin = Point.calculateDistanceFromOrigin(x, y);

  /// Constructors are not inherited, which means that a superclass's named constructor is not inherited by a subclass.
  // If you want a subclass to be created with a named constructor defined in the superclass, one must implement
  //that constructor in the subclass.

  // Initializer list sets instance variables before the constructor body runs.
  Point.fromJson(Map<String, double> json)
      : x = json['x']!,
        y = json['y']!,
        distanceFromOrigin =
            Point.calculateDistanceFromOrigin(json['x'], json['y']) {
    print('In Point.fromJson(): ($x, $y)');
  }

  /// Redirecting constructors
  /// Sometimes a constructor's only purpose is to redirect to another constructor in the same class.
  Point.alongXAxis(double x) : this(x, 0, x);

  // During development, one can valide inputs by using assert in the initializer list.
  Point.withAssert(this.x, this.y, this.distanceFromOrigin) : assert(x >= 0) {
    print('In Point.withAssert(): ($x, $y)');
  }

  /// Static methods (class methods) don't operate on an instance, and thus don't have access to this.
  /// They do, however, have access to static variables.
  static double distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }

  static double calculateDistanceFromOrigin(x, y) => sqrt(x * x + y * y);
  // Consider using top-level functions, instead of static methods, for common or widely used utilities and functionality.
}

/// Constant constructors
/// If the class produces objects that never change, one can make these objects compile-time constants.
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);
  final double x, y;

  const ImmutablePoint(this.x, this.y);
}

/// To do this, define a const constructor and make sure that all instance variables are final.

class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

class Vector2D {
  final double x, y;

  Vector2D(this.x, this.y);

  /// Super-initializer parameters cannot be positional if the super-constructor invocation alread has positional arguments,
  ///but they can always be named:
  Vector2D.named({required this.x, required this.y});
}

class Vector3D extends Vector2D {
  final double z;

  // Forwarding the x and y parameters to the default super constructor.
  Vector3D(super.x, super.y, this.z);

  // Forwarding the y parameter to the named super constructor.
  Vector3D.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}

/// GETTERS AND SETTERS
/// Getters and setters are special methods that provide read and write access to ana object's properties.
class Rectangle {
  double vertexX, vertexY, width, height;

  Rectangle(this.vertexX, this.vertexY, this.width, this.height);

  // Square(vertex, edge);

  // Define two calculated properties: right and bottom.
  double get right => vertexX + width;
  set right(double value) => vertexX = value - width;
  double get bottom => vertexY + height;
  set bottom(double value) => vertexY = value - height;
}

class Square extends Rectangle {
  Square(vertexX, vertexY, edge) : super(vertexX, vertexY, edge, edge);

  set edge(double value) {
    super.height = value;
    super.width = value;
  }
}

/// Factory constructors
/// One use the factory keyword when implementing a constructor that doesn't always create a new instance of its class.
/// (for example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype.
/// Another use case for factory constructors is initializing a final variable using logic that can't be handled in the
/// initializer list.)
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
