<script lang="ts">
	// const engine = new Engine({});
	const cnvs = document.querySelector('#canvas');
	const wasm = '/godot_exports/godot';
	const pck = '/godot_exports/godot.pck';
	const engine = new Engine({
		executable: wasm,
		mainPack: pck,
		canvas: cnvs,
		canvasResizePolicy: 0
	});
	engine.startGame();
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://svelte.dev/docs/kit">svelte.dev/docs/kit</a> to read the documentation</p>
<canvas id="canvas"></canvas>
