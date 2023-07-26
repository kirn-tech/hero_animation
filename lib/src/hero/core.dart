import 'package:flutter/foundation.dart';

typedef MapFunction<R, S> = R Function(S source);

class ValueNotifierMapper<S, R> extends ValueNotifier<R> {
  final ValueListenable<S> _source;
  final MapFunction<R, S> _map;

  ValueNotifierMapper({
    required ValueListenable<S> source,
    required MapFunction<R, S> map,
    required R initialValue,
  })  : _source = source,
        _map = map,
        super(initialValue) {
    source.addListener(_sourceListener);
  }

  void _sourceListener() {
    value = _map(_source.value);
  }

  @override
  void dispose() {
    _source.removeListener(_sourceListener);
    super.dispose();
  }
}

extension ValueNotifierSetter<T> on ValueNotifier<T> {
  void setValue(T? newValue) {
    if (newValue == null) {
      return;
    }
    value = newValue;
  }
}
