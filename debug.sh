rm -rdf build
nim c --forceBuild:on --stackTrace:on --threads:on --lineTrace:on --checks:on --assertions:on -o:build/eight_puzzle_solver_debug src/main.nim
./build/eight_puzzle_solver_debug