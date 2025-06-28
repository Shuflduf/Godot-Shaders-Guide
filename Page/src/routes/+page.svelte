<script lang="ts">
	import { onMount } from 'svelte';

	let cnvs = $state();
	const wasm = '/godot_exports/godot';
	const pck = '/godot_exports/godot.pck';
	onMount(async () => {
		// @ts-ignore
		const engine = new Engine({
			executable: wasm,
			mainPack: pck,
			canvas: cnvs,
			canvasResizePolicy: 0,
			onPrint
		});
		await engine.startGame();
		window.onclick = () => updateShader('AAAAAAAAA');
	});

	// function updateShader(newShader: string) {
	// 	console.log('JS', newShader);
	// 	return newShader;
	// }
	let updateShader: any = undefined;

	function onPrint(text: string) {
		console.log('Godot:', text);
	}
</script>

<div class="flex h-screen w-screen flex-col items-center justify-center gap-8">
	<h1 class="text-center text-3xl font-bold">
		LOOK ITS THE ICON.SVG FROM HIT GAME ENGINE GODOT GAME ENGINE
	</h1>
	<canvas id="canvas" width="400" height="400" bind:this={cnvs}></canvas>
</div>
