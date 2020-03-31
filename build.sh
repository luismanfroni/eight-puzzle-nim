rm -rdf build
nim c --forceBuild:on --stackTrace:off --lineTrace:off --checks:off --assertions:off --opt:speed -o:build/eight_puzzle_solver -d:release src/main.nim 