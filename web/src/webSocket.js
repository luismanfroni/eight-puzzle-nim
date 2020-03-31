const commandRegex = /([\w\d]+?):([\d\D\s\S]*)/im;
import { board, lastUpdate, solution, view } from "./stores";
export default class Server {
    constructor() {
        this.ws = new WebSocket("ws://localhost:9001/ws");
        this.ws.onmessage = this.switchAction.bind(this);
    }
    switchAction(p) {
        const command = matchCommand(p.data);
        let action = this["on" + command.action];
        action.bind(this)(command.content);
    }
    onBoard(content) {
        let newBoard = (JSON.parse(content) || [[1,2,3],[4,5,6],[7,8,0]]).flat();
        board.set(newBoard)
    }
    onSolved(content) {
        let node = JSON.parse(content);
        solution.set(node);
        view.set("done");
    }
    onUpdate(content) {
        let updatedContent = JSON.parse(content);
        lastUpdate.set(updatedContent);
    }
    sendInput(board = [1,2,3,4,5,6,7,8,0]) {
        this.ws.send(
            `input:${board[0]}${board[1]}${board[2]}\n` +
            `${board[3]}${board[4]}${board[5]}\n` +
            `${board[6]}${board[7]}${board[8]}`
        );
    }
    sendStart() {
        this.ws.send(`start:`);
    }
}


function matchCommand(str = "") {
    var matches = str.match(commandRegex);
    if (matches && matches.length >= 2) {
        let content = matches[2] || "";
        return {
            action: firstLetterUpperCase(matches[1]),
            content
        }
    }
    return {
        action: ""
    };
}

function firstLetterUpperCase(str = "") {
    return str.length > 0 ? 
        str[0].toUpperCase() + str.substr(1) : 
        ""
}