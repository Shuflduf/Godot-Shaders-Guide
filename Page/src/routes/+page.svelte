<script lang="ts">
	import { onMount } from 'svelte';

	// const engine = new Engine({});
	let cnvs = $state();
	const wasm = '/godot_exports/godot';
	const pck = '/godot_exports/godot.pck';
	onMount(async () => {
		console.log(cnvs);
		const engine = new Engine({
			executable: wasm,
			mainPack: pck,
			canvas: cnvs,
			canvasResizePolicy: 0
		});
		await engine.startGame();
	});
</script>

<div class="flex h-screen w-screen flex-col items-center justify-center gap-8">
	<h1 class="text-center text-3xl font-bold">
		LOOK ITS THE ICON.SVG FROM HIT GAME ENGINE GODOT GAME ENGINE
	</h1>
	<canvas id="canvas" width="400" height="400" bind:this={cnvs}></canvas>
</div>
