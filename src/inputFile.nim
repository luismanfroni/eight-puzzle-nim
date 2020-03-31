import os, strutils
import types


proc processArguments*(): string =
    if paramCount() == 0:
        var e: ref IOError
        new(e)
        e.msg = "No file argument found"
        raise e
    else:
        return paramStr(1)

proc getFileLines*(filePath: string): seq[string] =
    try:
        return readFile(filePath).split("\n")
    except IOError:
        echo "Could not load file (", filePath, ")!"
        raise

proc linesToBoard*(lines: seq[string]): Board =
    var lineIndex = 0
    var board: Board
    for line in lines:
        var boardLine: BoardLine

        var index = 0
        for character in line:
            boardLine[index] = int8(parseInt($character))
            index += 1
        board[lineIndex] = boardLine
        lineIndex = lineIndex + 1;

    return board