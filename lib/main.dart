import 'dart:math' show Random, pow;

import 'package:benchmark_harness/benchmark_harness.dart';

T unsafeCast<T>(dynamic value) {
  return value;
}

@pragma('dart2js:noInline')
@pragma('vm:no-inline')
int work(int value) {
  return unsafeCast<int>(pow(value, 3));
}

void main() {
  var random = Random();
  var n = 3 + random.nextInt(1);
  var list = List<int>.generate(1000000 * n, (i) => i);

  WhileUncached(list).report();
  WhileCached(list).report();
  WhileReversed(list).report();
  ForUncached(list).report();
  ForCached(list).report();
  ForReversed(list).report();
  ForIn(list).report();
  ForEach(list).report();
  MapList(list).report();
}

class Emitter implements ScoreEmitter {
  const Emitter();

  @override
  void emit(String name, double value) {
    print('${value.toStringAsFixed(4).padLeft(12)}\t$name');
  }
}

class Benchmark extends BenchmarkBase {
  const Benchmark(String name) : super(name, emitter: const Emitter());
}

class WhileUncached extends Benchmark {
  const WhileUncached(this.list) : super('while uncached');

  final List<int> list;

  @override
  void run() {
    var count = 0;
    var eachElement = 0;

    while (count < list.length) {
      eachElement = work(list[count]);
      count++;
    }
  }
}

class WhileCached extends Benchmark {
  const WhileCached(this.list) : super('while cached');

  final List<int> list;

  @override
  void run() {
    var count = 0;
    var length = list.length;
    var eachElement = 0;

    while (count < length) {
      eachElement = work(list[count]);
      count++;
    }
  }
}

class WhileReversed extends Benchmark {
  const WhileReversed(this.list) : super('while reversed');

  final List<int> list;

  @override
  void run() {
    var count = list.length - 1;
    var eachElement = 0;

    while (count >= 0) {
      eachElement = work(list[count]);
      count--;
    }
  }
}

class ForUncached extends Benchmark {
  const ForUncached(this.list) : super('for uncached');

  final List<int> list;

  @override
  void run() {
    var eachElement = 0;

    for (var i = 0; i < list.length; i++) {
      eachElement = work(list[i]);
    }
  }
}

class ForCached extends Benchmark {
  const ForCached(this.list) : super('for cached');

  final List<int> list;

  @override
  void run() {
    var length = list.length;
    var eachElement = 0;

    for (var i = 0; i < length; i++) {
      eachElement = work(list[i]);
    }
  }
}

class ForReversed extends Benchmark {
  const ForReversed(this.list) : super('for reversed');

  final List<int> list;

  @override
  void run() {
    var eachElement = 0;

    for (var i = list.length - 1; i >= 0; i--) {
      eachElement = work(list[i]);
    }
  }
}

class ForIn extends Benchmark {
  const ForIn(this.list) : super('for in');

  final List<int> list;

  @override
  void run() {
    var eachElement = 0;

    for (var element in list) {
      eachElement = work(element);
    }
  }
}

class ForEach extends Benchmark {
  const ForEach(this.list) : super('for each');

  final List<int> list;

  @override
  void run() {
    var eachElement = 0;

    list.forEach((element) {
      eachElement = work(element);
    });
  }
}

class MapList extends Benchmark {
  const MapList(this.list) : super('map list');

  final List<int> list;

  @override
  void run() {
    list.map((element) => work(element)).toList();
  }
}
