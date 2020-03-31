import ws, asyncdispatch, asynchttpserver, strutils, ../utils/input, ../algorithm/board, ../algorithm/node
from webServer import registerPath

var connections = newSeq[WebSocket]()

proc webSocket(req: Request) {.async, gcsafe.} =

    try:
        var ws = await newWebSocket(req)
        var board: Board
        while ws.readyState == Open:
            let packet = await ws.receiveStrPacket()
            if packet.startsWith("input:"):
                let lines = packet.substr(6).split("\n")
                board = linesToBoard(lines)
                asyncCheck ws.send("board:" & $board)
            elif packet.startsWith("board:"):
                asyncCheck ws.send("board:" & $board)
            elif packet.startsWith("start:"):
                
                let updateClient = proc(obj: UpdateClient, last: Future[void] = nil): Future[void] =
                    let r = newFuture[void]("updateClient")
                    if last != nil and not last.finished:
                        waitFor last
                        r.complete
                        return r
                    waitFor ws.send("update:" & 
                        "{\n" &
                            "\"openNodes\": " & $obj.openNodes & ",\n" &
                            "\"traversedNodes\": " & $obj.traversedNodes & ",\n" &
                            "\"currentNode\": " & toJson(obj.currentNode) & "\n" &
                        "}"
                    )
                    r.complete
                    return r

                let solution = await solve(board, updateClient)
                asyncCheck ws.send("solved:" & $solution)
            else:
                asyncCheck ws.send("ping")
    except WebSocketError:
        echo "socket closed:", getCurrentExceptionMsg()
    
proc registerWebSockets*() = 
    registerPath("/ws", webSocket)