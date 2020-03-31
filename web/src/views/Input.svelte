<script>
	import Board from "../components/Board.svelte";
	import { board, view } from "../stores.js";
	
    export let server;
    let currentBoard;
	let fileError = "";
    
    board.subscribe(value => currentBoard = value);

	function handleFile({target}) {
		let file = target.files[0];
		if (file) {
			file.text().then(t => {
				let boardFile = t.replace(/\n/gi, "").split("").map(Number);
				if (boardFile.filter(i => i in [1,2,3,4,5,6,7,8,0]).length == 9) {
					board.set(boardFile);
				} else {
					fileError = "File not respecting board patterns!";
				}
			}).catch(err => {
				fileError = "File error! " + err;
			});
		} else {
			fileError = "No file found!";
		}
	}

	function submit() {
        view.set("running");
		server.sendInput(currentBoard);
		server.sendStart();
    }
    
    function handleKeydown({key}) {
        const on = {
            ArrowUp: function(i) {
                if ((i / 3) >= 1) {
                    let lastContent = currentBoard[i - 3];
                    currentBoard[i - 3] = 0;
                    currentBoard[i] = lastContent;
                }
            },
            ArrowRight: function(i) {
                if ((i % 3) < 2) {
                    let lastContent = currentBoard[i + 1];
                    currentBoard[i + 1] = 0;
                    currentBoard[i] = lastContent;
                }
            },
            ArrowDown: function(i) {
                if ((i / 3) < 2) {
                    let lastContent = currentBoard[i + 3];
                    currentBoard[i + 3] = 0;
                    currentBoard[i] = lastContent;
                }
            },
            ArrowLeft: function(i) {
                if ((i % 3) > 0) {
                    let lastContent = currentBoard[i - 1];
                    currentBoard[i - 1] = 0;
                    currentBoard[i] = lastContent;
                }
            }
        };
        let action = on[key];
        if (action) {
            let spaceIndex = currentBoard.indexOf(0);
            action(spaceIndex);
        }
    }

</script>

<svelte:window on:keydown={handleKeydown}/>
<div class="header">
    <h1>Input</h1>
    <h3>Insert file or change board with arrow keys</h3>
</div>
<div class="container">
	<div class="steps_column">
		<Board board={currentBoard} size="small"></Board>
	</div>
	<div>
		<input type="file" accept="text/plain,.txt" on:input={handleFile} />
	</div>
	<div>
		<button on:click={submit}>
			Send
		</button>
	</div>
</div>

<style>
.header {
    padding: 18px;
    text-align: center;
}
.container {
	width: 400px;
    margin: auto;
    text-align: center;	
}
.container > div {
    padding: 12px;
}
.steps_column {
	justify-content: center;
	display: flex;
}
.steps_column > * { 
	padding: 34px;
}
</style>