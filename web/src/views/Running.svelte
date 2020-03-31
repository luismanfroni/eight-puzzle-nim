<script>
    import Node from "../components/Node.svelte";
    import { beforeUpdate, afterUpdate } from 'svelte';
	import { lastUpdate, painting } from "../stores.js";
    
    let currentNode = null;
    let openNodes = 0;
    let traversedNodes = 0;
    lastUpdate.subscribe(update => {
        if (update) {
            currentNode = update.currentNode;
            openNodes = update.openNodes;
            traversedNodes = update.traversedNodes;
            painting.set(true);
        }
    });

    beforeUpdate(() => { painting.set(true); });
	afterUpdate(() => { painting.set(false); });
</script>

<div class="header">
    <h1>Running ...</h1>
    <h3>Open Nodes: {openNodes}</h3>
    <h3>Traversed Nodes: {traversedNodes}</h3>
</div>
<div class="running">
    <Node node={currentNode}></Node>
</div>

<style>
.header {
    width: 100%;
    padding: 18px;
    text-align: center;
}
.running {
    overflow-x: scroll;
    display: flex;
    flex-direction: row;
    padding: 8px;
}
</style>