import 'package:hive/hive.dart';

class DStack<E> extends HiveObject {
  final List<E> _stack;
  DStack.empty() : _stack = <E>[];

  void push(E value) => _stack.add(value);

  int get length => _stack.length;

  void clear() {
    _stack.clear();
  }

  E pop() => _stack.removeLast();

  E get peek => _stack.last;

  bool get isEmpty => _stack.isEmpty;

  bool get isNotEmpty => _stack.isNotEmpty;

  @override
  String toString() => _stack.toString();
}
