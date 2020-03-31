<script>
	import Server from "./webSocket.js";
	import Input from "./views/Input.svelte";
	import Running from "./views/Running.svelte";
	import Done from "./views/Done.svelte";
	import { view } from "./stores.js";

	let server = new Server;
	let currentView = Input;
	let availableViews = {
		"input": Input,
		"running": Running,
		"done": Done
	};

	view.subscribe(newView => {
		if (newView in availableViews) {
			currentView = availableViews[newView];
		}
	});
</script>

<div class="container">
	<svelte:component this={currentView} server={server}/>
</div>

<style>
.container {
	width: 100%;
	height: 100%;	
}
</style>