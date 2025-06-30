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
	let started: boolean = $state(false);
	let loading: boolean = $state(false);

	const wasm = '/godot_exports/godot';
	const pck = '/godot_exports/godot.pck';

	async function start() {
		if (started) {
			return;
		}
		started = true;
		loading = true;
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
					'&': { height: '100%', minHeight: '380px' },
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
			onPrintError,
			onProgress
		});
		await engine.startGame();
		loading = false;
	}

	// onMount(async () => {
	// 	await start();
	// });

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

	function onProgress(current: number, total: number) {
		console.log(current, total);
	}
</script>

<button class="flex h-[400px] w-4xl max-w-4xl flex-row items-center justify-center" onclick={start}>
	{#if !started}
		<div class="flex h-full w-full items-center justify-center bg-slate-300 text-7xl">
			Start Engine
		</div>
	{:else}
		<canvas
			id="canvas"
			width="400"
			height="400"
			class="h-full w-[400px] flex-shrink-0 bg-red-500"
			bind:this={cnvs}
			>Loading
		</canvas>
		<div class="flex h-full max-h-full min-w-0 flex-1 flex-col">
			<div id="code-editor" class="min-h-0 flex-1 text-left"></div>
			<tt class="bg-[#1e1e2e] text-center text-white">
				Press esc before pressing tab to leave editor focus
			</tt>
		</div>
	{/if}
</button>
<!-- <textarea class="w-xl" bind:value={shaderText}></textarea> -->
