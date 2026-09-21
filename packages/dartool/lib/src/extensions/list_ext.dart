import '../list_util.dart';
import 'dart:collection';

extension ListX<T> on List<T> {
  List<List<T>> partition(int n) => ListUtil.partition<T>(this, n);

  List<T> insertSafe(int index, T item) {
    ListUtil.insertSafe<T>(this, index, item);
    return this;
  }

  T? removeAtSafe(int index, {T Function()? orElse}) =>
      ListUtil.removeAtSafe<T>(this, index, orElse: orElse);

  List<T> get shuffled => ListUtil.shuffled<T>(this);

  List<T> get reversedCopy => ListUtil.reversed<T>(this);

  T elementAtOrElse(int index, T Function(int index) orElse) =>
      ListUtil.elementAtOrElse<T>(this, index, orElse);

  T? firstOrNull(bool Function(T) test) => ListUtil.firstOrNull<T>(this, test);

  T? lastOrNull(bool Function(T) test) => ListUtil.lastOrNull<T>(this, test);

  int indexWhereOrNull(bool Function(T) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return i;
    }
    return -1;
  }

  List<T> sortBy(Comparator<T> compare) {
    sort(compare);
    return this;
  }

  List<T> sortByAsc<R extends Comparable<R>>(R Function(T element) keyOf) {
    sort((a, b) => keyOf(a).compareTo(keyOf(b)));
    return this;
  }

  List<T> sortByDesc<R extends Comparable<R>>(R Function(T element) keyOf) {
    sort((a, b) => keyOf(b).compareTo(keyOf(a)));
    return this;
  }

  List<T> distinct() => LinkedHashSet<T>.of(this).toList();

  bool all(bool Function(T) test) {
    for (final e in this) {
      if (!test(e)) return false;
    }
    return true;
  }

  bool anyOf(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return true;
    }
    return false;
  }
}
