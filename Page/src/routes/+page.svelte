<script lang="ts">
	import { basicSetup, EditorView } from 'codemirror';
	import { keymap } from '@codemirror/view';
	import { onMount } from 'svelte';
	import { indentWithTab } from '@codemirror/commands';
	import { javascript } from '@codemirror/lang-javascript';
	import { catppuccinMocha } from '@catppuccin/codemirror';
	import { cpp } from '@codemirror/lang-cpp';

	let cnvs = $state();
	let shaderText: string = $state('fuck you');
	let editor: EditorView | null = $state(null);
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
		shaderText = await (await fetch('/main.gdshader')).text();
		editor = new EditorView({
			doc: shaderText,
			parent: document.querySelector('#code-editor') as Element,
			extensions: [
				basicSetup,
				catppuccinMocha,
				keymap.of([indentWithTab]),
				cpp(),
				EditorView.theme({
					'&': { height: '100%', maxHeight: '400px', minHeight: '400px' },
					'.cm-scroller': { overflow: 'auto' }
				})
			]
		});
	});

	function safeUpdateShader() {
		const updateShader = (window as any).updateShader as ((shader: string) => void) | undefined;
		if (updateShader) {
			let res = updateShader(editor?.state.doc.toString() as string);
			console.log(res);
		}
	}

	// function updateShader(newShader: string) {
	// 	console.log('JS', newShader);
	// 	return newShader;
	// }

	function getShaderText(): string {
		return shaderText;
	}

	function onPrint(text: string) {
		console.log('Godot:', text);
	}
</script>

<div class="flex h-screen w-screen flex-col items-center justify-center gap-8">
	<h1 class="text-center text-3xl font-bold">
		LOOK ITS THE ICON.SVG FROM HIT GAME ENGINE GODOT GAME ENGINE
	</h1>
	<button onclick={safeUpdateShader}>DO THE</button>
	<div class="flex flex-row">
		<canvas id="canvas" width="400" height="400" bind:this={cnvs}></canvas>
		<div class="flex h-[400] max-h-[400] flex-col">
			<div id="code-editor" class="w-xl h-full" style="height: 400px;"></div>
			<p>Press esc before pressing tab to leave editor focus</p>
		</div>
		<!-- <textarea class="w-xl" bind:value={shaderText}></textarea> -->
	</div>
</div>
