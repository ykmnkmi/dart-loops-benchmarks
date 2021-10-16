Write-Output "kernel"
dart .\benchmark\benchmarks.dill
Write-Output "jit"
dart .\benchmark\benchmarks.jit
Write-Output "aot"
.\benchmark\benchmarks.exe
Write-Output "js"
node .\benchmark\benchmarks.js