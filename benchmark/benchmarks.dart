import 'dart:math' show pow;

import 'package:benchmark_harness/benchmark_harness.dart';

@pragma('dart2js:noInline')
@pragma('vm:never-inline')
num work(int value) {
  return pow(value, 3);
}

void main(List<String> arguments) {
  var n = arguments.isEmpty ? 3000 : int.parse(arguments.first);
  var list = List<int>.generate(n, (i) => i);

  WhileUncached(list).report();
  WhileCached(list).report();
  WhileReversed(list).report();
  ForUncached(list).report();
  ForCached(list).report();
  ForReversed(list).report();
  ForIn(list).report();
  ForEach(list).report();
  MapList(list).report();
  ListGenerate(list).report();
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

  @override
  void exercise() {
    for (var i = 0; i < 10; i++) {
      run();
    }
  }
}

class WhileUncached extends Benchmark {
  const WhileUncached(this.list) : super('while uncached');

  final List<int> list;

  @override
  void run() {
    var count = 0;

    while (count < list.length) {
      work(list[count]);
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

    while (count < length) {
      work(list[count]);
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

    while (count >= 0) {
      work(list[count]);
      count--;
    }
  }
}

class ForUncached extends Benchmark {
  const ForUncached(this.list) : super('for uncached');

  final List<int> list;

  @override
  void run() {
    for (var i = 0; i < list.length; i++) {
      work(list[i]);
    }
  }
}

class ForCached extends Benchmark {
  const ForCached(this.list) : super('for cached');

  final List<int> list;

  @override
  void run() {
    var length = list.length;

    for (var i = 0; i < length; i++) {
      work(list[i]);
    }
  }
}

class ForReversed extends Benchmark {
  const ForReversed(this.list) : super('for reversed');

  final List<int> list;

  @override
  void run() {
    for (var i = list.length - 1; i >= 0; i--) {
      work(list[i]);
    }
  }
}

class ForIn extends Benchmark {
  const ForIn(this.list) : super('for in');

  final List<int> list;

  @override
  void run() {
    for (var element in list) {
      work(element);
    }
  }
}

class ForEach extends Benchmark {
  const ForEach(this.list) : super('for each');

  final List<int> list;

  @override
  void run() {
    list.forEach((element) {
      work(element);
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

class ListGenerate extends Benchmark {
  const ListGenerate(this.list) : super('list generate');

  final List<int> list;

  @override
  void run() {
    List<num>.generate(list.length, (index) => work(list[index]));
  }
}
