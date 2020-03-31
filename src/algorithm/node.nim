import board, sequtils, algorithm, asyncfutures

type
    Node* = ref object
        board*: Board
        lastNode*: Node
        hammingScore*: int
        manhattanScore*: int
        depth*: int
        move*: Direction
    UpdateClient* = object
        currentNode*: Node
        openNodes*: int
        traversedNodes*: int

proc score(node: Node): int =
    return 
        node.manhattanScore + 
        node.depth

proc sortByScore(nodeA: Node, nodeB: Node): int =
    let scoreA = score(nodeA)
    let scoreB = score(nodeB)
    if scoreA < scoreB:
        return -1
    elif scoreA > scoreB:
        return 1
    else:
        return 0

proc createRootNode(board: Board): Node =
    return Node(
        board: board,
        depth: 0,
        hammingScore: -1,
        manhattanScore: -1
    )
proc openNodesFrom(node: Node): seq[Node] = 
    var nodes: seq[Node]
    for direction in node.board.availableMoves():
        var b: Board = node.board.move(direction)
        nodes.add(Node(
            board: b,
            lastNode: node,
            hammingScore: b.hammingScore(),
            manhattanScore: b.manhattanScore(),
            depth: node.depth + 1,
            move: direction
        ))
    return nodes

proc checkGoal(node: Node): bool = 
    return node.hammingScore == 0 and node.manhattanScore == 0
            
proc toJson*(node: Node): string =
    if node == nil:
        return "null"
    return 
        "{\n" &
            "\"board\": " & ($node.board) & ", \n" &
            "\"hammingScore\": " & ($node.hammingScore) & ", \n" &
            "\"manhattanScore\": " & ($node.manhattanScore) & ", \n" &
            "\"depth\": " & ($node.depth) & ", \n" &
            (if int(node.move) != 0: "\"move\": \"" & $node.move & "\", \n" else: "") &
            "\"lastNode\": " & toJson(node.lastNode) & "\n" &
        "}"

proc solve*(board: Board, updateChannel: proc(obj: UpdateClient, last: Future[void] = nil): Future[void]): Future[string] =
    let asyncF = newFuture[string]("solve")
    let rootNode: Node = createRootNode(board)
    var traversedNodes: seq[Node]
    var openNodes: seq[Node] = @[rootNode]
    var lastUpdate: Future[void] = nil
    while true:
        let currentNode = openNodes[openNodes.low()]

        if checkGoal(currentNode):
            asyncF.complete(toJson(currentNode))
            break
        
        lastUpdate = updateChannel(
            UpdateClient(
                currentNode: currentNode,
                openNodes: openNodes.len,
                traversedNodes: traversedNodes.len
            ), lastUpdate
        )

        let nodes = openNodesFrom(currentNode)
        traversedNodes.add(currentNode)
        openNodes.del(openNodes.low())
        for node in nodes:
            let openNodesSameBoard = openNodes.filterIt(it.board == node.board)
            if openNodesSameBoard.len > 0:
                if openNodesSameBoard.filterIt(score(it) > score(node)).len > 0:
                    openNodes.add(node)
                    openNodes.keepItIf(it.board != node.board or score(it) <= score(node))
            else:
                openNodes.add(node)

            let traversedNodesSameBoard = traversedNodes.filterIt(it.board == node.board)
            if traversedNodesSameBoard.len > 0 and traversedNodesSameBoard.filterIt(it.depth > node.depth).len > 0:
                traversedNodes.keepItIf(it.board != node.board or score(it) != score(node))
        openNodes.sort(sortByScore)
        if openNodes.len == 0:
            asyncF.fail(newException(Exception, ""))
    return asyncF
    


