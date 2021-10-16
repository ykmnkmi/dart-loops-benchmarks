#! /bin/bash
echo "kernel"
dart ./benchmark/benchmarks.dill
echo "jit"
dart ./benchmark/benchmarks.jit
echo "aot"
./benchmark/benchmarks.exe
# echo "js"
# node ./benchmark/benchmarks.js