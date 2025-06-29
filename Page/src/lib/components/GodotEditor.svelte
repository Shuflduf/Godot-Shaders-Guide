<script lang="ts">
	import { basicSetup, EditorView } from 'codemirror';
	import { keymap } from '@codemirror/view';
	import { onMount } from 'svelte';
	import { indentWithTab } from '@codemirror/commands';
	import { catppuccinMocha } from '@catppuccin/codemirror';
	import { cpp } from '@codemirror/lang-cpp';
	import { linter, lintGutter } from '@codemirror/lint';

	class Error {
		line: number | null;
		message: string;

		constructor(line: number | null, message: string) {
			this.line = line;
			this.message = message;
		}
	}

	let cnvs = $state();
	let shaderText: string = $state('fuck you');
	let editor: EditorView | null = $state(null);
	let editorUpdateTimeout: number | null = null;
	let currentErrors: Error[] = $state([]);

	const wasm = '/godot_exports/godot';
	const pck = '/godot_exports/godot.pck';

	async function start() {
		shaderText = await (await fetch('/main.gdshader')).text();
		editor = new EditorView({
			doc: shaderText,
			parent: document.querySelector('#code-editor') as Element,
			extensions: [
				basicSetup,
				catppuccinMocha,
				lintGutter(),
				keymap.of([indentWithTab]),
				cpp(),
				linter(() =>
					currentErrors.map((e) => ({
						from: e.line !== null ? (editor as EditorView).state.doc.line(e.line).from : 0,
						to: e.line !== null ? (editor as EditorView).state.doc.line(e.line).to : 0,
						severity: 'error',
						message: e.message
					}))
				),
				EditorView.updateListener.of((update) => {
					if (update.docChanged) {
						if (editorUpdateTimeout) {
							clearTimeout(editorUpdateTimeout);
						}
						editorUpdateTimeout = setTimeout(safeUpdateShader, 100);
					}
				}),
				EditorView.theme({
					'&': { height: '100%', maxHeight: '400px', minHeight: '400px' },
					'.cm-scroller': { overflow: 'auto' }
				})
			]
		});

		// @ts-ignore
		const engine = new Engine({
			executable: wasm,
			mainPack: pck,
			canvas: cnvs,
			canvasResizePolicy: 0,
			onPrint,
			onPrintError
		});
		await engine.startGame();
	}

	onMount(async () => {
		await start();
	});

	function safeUpdateShader() {
		const updateShader = (window as any).updateShader as ((shader: string) => void) | undefined;
		if (updateShader) {
			currentErrors = [];
			updateShader(editor?.state.doc.toString() as string);
		}
	}

	let currentError: Error | null = null;
	function onPrintError(error: string) {
		console.error(error);
		if (error.startsWith('SHADER ERROR')) {
			currentError = new Error(null, error.slice(14));
		} else if (currentError != null && currentError.line == null) {
			console.log('DDDDDDDDD:', error.slice(35));
			currentError.line = parseInt(error.slice(35, -1));
			console.log('BBBBB:', currentError);
			currentErrors.push(currentError);
			currentError = null;
			console.log('CCCCCCCCC', currentErrors);
		}
	}

	function onPrint(text: string) {
		console.log('Godot:', text);
	}
</script>

<div class="flex flex-row">
	<canvas id="canvas" width="400" height="400" bind:this={cnvs}></canvas>
	<div class="flex h-[400] max-h-[400] flex-col">
		<div id="code-editor" class="h-full w-xl" style="height: 400px;"></div>
		<tt class="bg-[#1e1e2e] text-center text-white">
			Press esc before pressing tab to leave editor focus
		</tt>
	</div>
</div>
<!-- <textarea class="w-xl" bind:value={shaderText}></textarea> -->
