<script>
	import Board from "../components/Board.svelte";
    
    export let node;
    
    let board;

    if (node) board = node.board.flat();   
</script>

<div class="nodes">
    {#if node}
        {#if node.lastNode}
            <svelte:self node={node.lastNode} />
        {/if}
        {#if board}
            <Board board={board} size="small"></Board>
        {/if}
    {/if}
</div>

<style>
.nodes {
	margin-right: 16px;
    display: flex;
}
</style>