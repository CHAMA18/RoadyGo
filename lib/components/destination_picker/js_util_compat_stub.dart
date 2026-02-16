dynamic get globalThis => null;

T? getProperty<T>(dynamic object, Object property) => null;

void setProperty(dynamic object, Object property, Object? value) {}

dynamic callMethod(dynamic object, String method, List<dynamic> args) => null;

dynamic callConstructor(dynamic constructor, List<dynamic> args) => null;

dynamic newObject() => <String, dynamic>{};

F allowInterop<F extends Function>(F f) => f;
