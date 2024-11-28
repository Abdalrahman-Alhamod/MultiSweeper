class DStack<E> {
  final List<E> _stack;

  DStack.empty() : _stack = <E>[];

  int? _capacity;

  DStack.emptyWithCapacity([this._capacity]) : _stack = <E>[];

  void push(E value) {
    if (_capacity != null && _stack.length >= _capacity!) {
      throw StateError('Stack overflow: Capacity $_capacity reached');
    }
    _stack.add(value);
  }

  int get length => _stack.length;

  void clear() {
    _stack.clear();
  }

  E pop() {
    if (_stack.isEmpty) {
      throw StateError('Stack underflow: The stack is empty');
    }
    return _stack.removeLast();
  }

  E get peek {
    if (_stack.isEmpty) {
      throw StateError('Stack is empty, cannot peek');
    }
    return _stack.last;
  }

  bool get isEmpty => _stack.isEmpty;

  bool get isNotEmpty => _stack.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DStack<E> &&
          runtimeType == other.runtimeType &&
          _stack == other._stack;

  @override
  int get hashCode => _stack.hashCode;

  @override
  String toString() => _stack.toString();

  Map<String, dynamic> toJson(
    Object Function(E value) toJsonE,
  ) =>
      {
        'stack': _stack.map((e) => (toJsonE(e))).toList(),
      };

  factory DStack.fromJson(
      Map<String, dynamic> json, E Function(dynamic json) fromJson) {
    return DStack<E>.empty()
      .._stack.addAll((json['stack'] as List<dynamic>).map((e) => fromJson(e)));
  }
}
