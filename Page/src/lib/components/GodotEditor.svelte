<script lang="ts">
	import { basicSetup, EditorView } from 'codemirror';
	import { keymap } from '@codemirror/view';
	import { indentWithTab } from '@codemirror/commands';
	import { catppuccinMocha } from '@catppuccin/codemirror';
	import { cpp } from '@codemirror/lang-cpp';
	import { linter, lintGutter } from '@codemirror/lint';
	import { SHUFL_BOX } from '$lib/styles';
	import { onMount } from 'svelte';

	class Error {
		line: number | null;
		message: string;

		constructor(line: number | null, message: string) {
			this.line = line;
			this.message = message;
		}
	}

	let loadingThings: boolean = $state(false);
	let cnvs = $state();
	let shaderText: string = $state('fuck you');
	let editor: EditorView | null = $state(null);
	let editorUpdateTimeout: number | null = null;
	let currentErrors: Error[] = $state([]);
	let started: boolean = $state(false);
	let loading: boolean = $state(false);
	let uniforms: ShaderUniform[] = $state([]);
	let uniformValues: { [key: string]: any } = $state({});
	let defaultUniformValues: { [key: string]: any } = $state({});

	const wasm = '/godot_exports/godot';
	const pck = '/godot_exports/godot.pck';

	async function start() {
		if (started) {
			return;
		}
		started = true;
		loading = true;
		loadingThings = true;
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
		safeUpdateShader();
		loading = false;
		loadingThings = false;
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
			currentError.line = parseInt(error.slice(35, -1));
			currentErrors.push(currentError);
			currentError = null;
		}
	}

	function onPrint(text: string) {
		console.log('Godot:', text);
		if (text.startsWith('UNIFORMS: ')) {
			const newUniforms: ShaderUniform[] = JSON.parse(text.slice(10));
			// uniformValues = {};
			defaultUniformValues = {};
			newUniforms.forEach((u) => {
				let val = u.value;
				let type = u.type;
				if (u.value) {
					if (type.startsWith('vec')) {
						// # History
						// const vals = val.slice(5, -1);
						// const val_arr = JSON.parse(`[${vals}]`);
						// const val_arr = (val as string).split(', ');
						// const val_arr = JSON.parse(val);
						const val_arr = val;
						val = Object.fromEntries(
							val_arr.map((v: string, i: number) => [['x', 'y', 'z', 'w'][i], v])
						);

						console.log(val);
					}
					if (!uniformValues[u.name]) {
						uniformValues[u.name] = val;
					}
					defaultUniformValues[u.name] = val;
				}
				if (type.startsWith('vec') && !uniformValues[u.name]) {
					uniformValues[u.name] = {};
					const dims = ['x', 'y', 'z', 'w'];
					dims.forEach((dim) => {
						uniformValues[u.name][dim] = null;
					});
				}
			});

			uniforms = newUniforms;
			console.log('wtf', uniforms);
			console.log('VALLLL:', uniformValues);
		}
		text = '';
	}

	function onProgress(current: number, total: number) {
		console.log(current, total);
	}

	async function genFileData(file: File) {
		return {
			type: file.type,
			bytes: Array.from(await file.bytes())
		};
	}

	function safeUpdateUniforms(data: any, uniformName: string, type: string) {
		console.log(uniformName, type, JSON.stringify(data));
		const updateUniforms = (window as any).updateUniforms as ((uniforms: any) => void) | undefined;
		if (updateUniforms) {
			loadingThings = true;
			updateUniforms(
				JSON.stringify({
					type,
					uniformName,
					data
				})
			);
		}
	}
</script>

<div class="flex w-full flex-col overflow-auto rounded-md">
	<button
		class="flex h-12 w-full cursor-pointer flex-row items-center justify-center bg-slate-300 text-xl"
		onclick={start}
	>
		{#if !started}
			Start Engine
		{/if}
	</button>
	{#if started}
		<div class="flex flex-1 flex-col overflow-y-auto">
			<div class="flex max-h-[400px] flex-row">
				<canvas id="canvas" width="400" height="400" class="bg-red-500" bind:this={cnvs}></canvas>
				<div class="flex h-full flex-1 flex-col">
					<!-- if you remove min-h-0 it doesnt work for some reason -->
					<div id="code-editor" class="min-h-0 flex-1 text-left"></div>
					<tt class="bg-[#1e1e2e] text-center text-white">
						Press esc before pressing tab to leave editor focus
					</tt>
				</div>
			</div>

			<div class="mt-4 flex flex-1 flex-row flex-wrap gap-4 overflow-y-scroll">
				{#each uniforms as u}
					<div class="flex {SHUFL_BOX} h-16 flex-row items-center gap-4">
						{u.name}
						{#if uniformValues[u.name] && defaultUniformValues[u.name] && defaultUniformValues[u.name] != uniformValues[u.name]}
							<button onclick={(uniformValues[u.name] = defaultUniformValues[u.name])}>R</button>
						{/if}
						{#if u.type == 'float' || u.type == 'int'}
							<input
								type="number"
								class="w-24 rounded-md border px-4 py-2"
								placeholder={u.type}
								step="1"
								bind:value={uniformValues[u.name]}
								oninput={(e: any) => safeUpdateUniforms(Number(e.target.value), u.name, u.type)}
							/>
						{:else if u.type == 'sampler2D'}
							<input
								type="file"
								accept=".jpg,.png,.svg,.tga,.webp"
								class="w-24 rounded-md border px-4 py-2"
								oninput={async (e: any) => {
									// console.log(e.target.files[0]);
									uniformValues[u.name] = e.target.files[0];
									safeUpdateUniforms(await genFileData(e.target.files[0]), u.name, u.type);
								}}
							/>
							{#if uniformValues[u.name]}
								<img
									src={uniformValues[u.name] ? URL.createObjectURL(uniformValues[u.name]) : ''}
									class="h-10 w-10 rounded-md object-cover"
									alt="{u.name} texture"
								/>
							{/if}
						{:else if u.type.startsWith('vec') && [2, 3, 4].includes(Number(u.type.at(-1)))}
							{#each ['x', 'y', 'z', 'w'].slice(0, Number(u.type.at(-1))) as dim}
								<input
									type="number"
									placeholder={dim}
									class="w-24 rounded-md border px-4 py-2"
									bind:value={uniformValues[u.name][dim]}
									oninput={(e: any) => {
										console.log(uniformValues[u.name]);
										safeUpdateUniforms(
											{ dimension: dim, value: Number(e.target.value) },
											u.name,
											u.type
										);
									}}
								/>
							{/each}
						{/if}
					</div>
				{/each}
			</div>
		</div>
	{/if}
</div>
<!-- <textarea class="w-xl" bind:value={shaderText}></textarea> -->
