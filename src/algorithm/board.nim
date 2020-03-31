import constraints, errors

type
    BoardContent* = int8
    BoardLine* = array[BOARD_SIZE, BoardContent]
    Board* = array[BOARD_SIZE, BoardLine]
    Position* = object
        x*, y*: int8
    Direction* = enum
        North = 1, 
        West = 2,
        South = 3,
        East = 4

const GOAL_BOARD* = Board(
    [
        BoardLine(
            [
                BoardContent(1),
                BoardContent(2),
                BoardContent(3)
            ]
        ),
        BoardLine(
            [
                BoardContent(4),
                BoardContent(5),
                BoardContent(6)
            ]
        ),
        BoardLine(
            [
                BoardContent(7),
                BoardContent(8),
                BoardContent(0)
            ]
        )
    ]
)


proc validatePosition*(pos: Position): void =
    if pos.x > MAX_POSITION: raise newException(PositionOutOfBoundsError, "X(" & $(pos.x + 1) & ") is higher than board limit(" & $(MAX_POSITION + 1) & ")")
    if pos.x < MIN_POSITION: raise newException(PositionOutOfBoundsError, "X(" & $(pos.x + 1) & ") is lower than board limit(" & $(MIN_POSITION + 1) & ")") 
    if pos.y > MAX_POSITION: raise newException(PositionOutOfBoundsError, "Y(" & $(pos.x + 1) & ") is higher than board limit(" & $(MAX_POSITION + 1) & ")")
    if pos.y < MIN_POSITION: raise newException(PositionOutOfBoundsError, "Y(" & $(pos.x + 1) & ") is lower than board limit(" & $(MIN_POSITION + 1) & ")")

proc getPosition*(board: Board): Position =
    for lineIndex, boardLine in board:
        for columnIndex, boardContent in boardLine:
            if boardContent == 0:
                let pos = Position(x: columnIndex, y: lineIndex)
                validatePosition(pos)
                return pos

proc findNumberGoalPosition*(number: BoardContent): Position =
    for lineIndex, line in GOAL_BOARD:
        for columnIndex, content in line: 
            if number == content:
                return Position(x: columnIndex, y: lineIndex)

proc availableMoves*(board: Board): seq[Direction] =
    let pos = board.getPosition()
    var moves: seq[Direction] = @[]
    if pos.y > MIN_POSITION: moves.add(North)
    if pos.x < MAX_POSITION: moves.add(West)
    if pos.y < MAX_POSITION: moves.add(South)
    if pos.x > MIN_POSITION: moves.add(East)
    return moves

proc move*(board: Board, direction: Direction): Board =
    let currentPosition = board.getPosition()
    var moveToPosition = currentPosition
    case direction:
        of North:
            moveToPosition.y -= 1
        of West:
            moveToPosition.x += 1
        of South:
            moveToPosition.y += 1
        of East:
            moveToPosition.x -= 1
    validatePosition(moveToPosition)
    result = board
    result[currentPosition.y][currentPosition.x] = result[moveToPosition.y][moveToPosition.x]
    result[moveToPosition.y][moveToPosition.x] = BoardContent(0)

#number of misplaced Tiles:
proc hammingScore*(board: Board): int =
    result = 0
    for lineIndex, line in board:
        for columnIndex, content in line:
            if content != GOAL_BOARD[lineIndex][columnIndex]:
                result += 1

#distance between goal tiles and current
proc manhattanScore*(board: Board): int =
    result = 0
    for lineIndex, line in board:
        for columnIndex, content in line:
            let pos = findNumberGoalPosition(content)
            result += (abs(pos.x - columnIndex) + abs(pos.y - lineIndex))
