<script>
    import Node from "../components/Node.svelte";
    import { beforeUpdate, afterUpdate } from 'svelte';
	import { solution, painting, view, board, lastUpdate } from "../stores.js";
    
    let currentNode = null;

    solution.subscribe(sol => {
        if (sol) {
            currentNode = sol;
            painting.set(true);   
        }
    });

    function newBoard() {
        view.set("input");
        solution.set(null);
        board.set([1,2,3,4,5,6,7,8,0]);
        lastUpdate.set(null);
    }

    beforeUpdate(() => { painting.set(true); });
	afterUpdate(() => { painting.set(false); });
</script>

<div class="header">
    <h1>Solution</h1>
</div>
<div class="solution">
	<Node node={currentNode}/>
</div>
<div class="newboard">
    <button on:click={newBoard}>
        New Board
    </button>
</div>


<style>
.newboard {
    text-align: center;
    padding: 8px;
}
.header {
    padding: 18px;
    text-align: center;
}
.solution {
    overflow-x: scroll;
    display: flex;
    flex-direction: row;
    padding: 8px;
}
.solution > div {
    padding-right: 16px;
    margin-right: 0;
}
</style>