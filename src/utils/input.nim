import ../algorithm/board, strutils

proc linesToBoard*(lines: seq[string]): Board =
    var lineIndex = 0
    var board: Board
    for line in lines:
        var boardLine: BoardLine

        var index = 0
        for character in line:
            if character == ' ':
                boardLine[index] = 0
            else:
                boardLine[index] = int8(parseInt($character))
            index += 1
        board[lineIndex] = boardLine
        lineIndex = lineIndex + 1;

    return board