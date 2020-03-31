<script>
    export let board, size = "small";
</script>

<div class="board {size} board_wrapper">
    <div class="board_container">
        {#each board as content, i}
            <div class="board_item board_item_{i}">{content}</div>
        {/each}
    </div>
</div>

<style>
.board_wrapper {
    display: block;
}
.board_container{
    font-family: "Ubuntu", "Roboto";
    display: flex;
    flex-wrap: wrap;
}
.small.board {
    border: 2px solid;
    width: 126px;
    height: 126px;
    font-size: 26px;
}
.small.board .board_item {
    width: 32px;
    height: 32px;
    text-align: center;
    margin: 5px;
}
</style>