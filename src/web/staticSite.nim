import os
from webServer import byExtGetMimeType, StaticWebFile, registerStaticFile

proc getFiles(path: string, root: string = path): seq[StaticWebFile] =
    var files: seq[StaticWebFile]
    for dirFile in walkDir(path):
        if dirFile.kind == PathComponent.pcDir:
            for content in getFiles(dirFile.path, root):
                files.add(content)
        else:
            let mime = byExtGetMimeType(dirFile.path.splitFile.ext)
            let content = readFile(dirFile.path)

            let newStaticFile = StaticWebFile(
                mimeType: mime,
                content: content,
                path: dirFile.path.substr(root.len)
            )

            files.add(newStaticFile)

    return files

const staticWebFiles* = getFiles("web/public")

proc registerStaticFiles*() =
    for file in staticWebFiles:
        registerStaticFile(file)