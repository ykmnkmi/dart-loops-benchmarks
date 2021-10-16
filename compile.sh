#! /bin/bash
dart compile kernel ./benchmark/benchmarks.dart -o ./benchmark/benchmarks.dill
dart compile jit-snapshot ./benchmark/benchmarks.dart -o ./benchmark/benchmarks.jit
dart compile exe ./benchmark/benchmarks.dart -o ./benchmark/benchmarks.exe
# dart2js --omit-implicit-checks --lax-runtime-type-to-string --trust-primitives --no-source-maps --server-mode ./benchmark/benchmarks.dart -o ./benchmark/benchmarks.js