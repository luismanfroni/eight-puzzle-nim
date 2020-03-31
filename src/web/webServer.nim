import mimetypes, asyncdispatch, asynchttpserver, tables
from httpcore import HttpMethod, HttpHeaders

type
    WebServerResponse* = object
        code: HttpCode
        content: string
        headers: HttpHeaders
    WebServerPaths = Table[string, proc(req: Request): Future[void]]
    StaticWebFile* = object
        mimeType*: string
        content*: string
        path*: string

proc byExtGetMimeType*(s: string): string =
    return newMimeTypes().getMimetype(s)

var paths: WebServerPaths

proc registerPath*(path: string, action: proc(req: Request): Future[void]) =
    paths[path] = action

proc staticFileRespond(file: StaticWebFile, req: Request) {.async.} =
    echo "staticFileRespond ", file.path
    await req.respond(Http200, file.content, {"Content-Type": file.mimeType}.newHttpHeaders)

proc registerStaticFile*(file: StaticWebFile) =
    registerPath(file.path, proc(req: Request){.async.} = await staticFileRespond(file, req))

proc serverCallBacks(request: Request) {.async, gcsafe.} =
    let requestPath = request.url.path
    echo "serverCallBacks ", requestPath
    if paths.contains(requestPath):
        await paths[requestPath](request)
    else:
        if ["", "/", "/index"].contains(requestPath):
            await request.respond(Http302, "", {"Location": "/index.html"}.newHttpHeaders)
        else:
            await request.respond(Http404, "<h1><b>Error 404: Page not found!</b></h1>")

proc startServer*(port: int = 9001) = 
    var server = newAsyncHttpServer()
    try:
        echo "Starting server! http://localhost:", port, "/"
        waitFor server.serve(Port(port), serverCallBacks)
    except:
        echo "Error! ", getCurrentExceptionMsg()