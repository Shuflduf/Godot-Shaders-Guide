<script>
	import StartingButton from '$lib/components/StartingButton.svelte';
	import VidSlider from '$lib/components/VidSlider.svelte';
	import { onMount } from 'svelte';
	import { fly, slide } from 'svelte/transition';

	let loaded = $state(false);

	onMount(() => {
		loaded = true;
	});
</script>

<div class="flex h-[36rem] w-screen items-center justify-evenly">
	{#if loaded}
		<div>
			<h1 class="font-[Arvo] text-5xl font-bold" transition:fly={{ duration: 1000, y: 50 }}>
				Godot Shaders Guide
			</h1>
			<h2 class="mb-8 text-lg italic" transition:fly={{ duration: 1000, y: 50, delay: 100 }}>
				A free and interactive tutorial to learn the Godot shaders system
			</h2>
			<StartingButton></StartingButton>
		</div>
		<img
			src="icon.png"
			class="w-80 transition hover:scale-105"
			alt="godot shaders icon"
			transition:slide={{ duration: 1000, axis: 'x' }}
		/>
	{/if}
</div>

<div class="absolute -left-20 -z-20 h-[34rem] w-[200vw] rotate-3 bg-slate-300 shadow-md"></div>
<div class="relative flex h-[30rem] w-screen items-center justify-evenly pb-16">
	{#if loaded}
		<div class="flex flex-col gap-2" transition:fly={{ duration: 1000, x: 400, delay: 800 }}>
			<VidSlider src1="/after.webm" src2="/before.webm"></VidSlider>
			<!-- <video src="/after.webm" autoplay loop><track kind="captions" /></video> -->
			<!-- <video src="/before.webm" autoplay loop><track kind="captions" /></video> -->
			<p class="text-center font-[Arvo] italic">Hover me!</p>
		</div>
		<div transition:fly={{ duration: 1000, x: 400, delay: 900 }}>
			<h1 class="mb-2 text-center font-[Arvo] text-3xl font-bold">What are Godot shaders?</h1>
			<p class="max-w-2xl">
				Godot shaders are small programs written in Godot's shading language that run on the GPU to
				control how objects are rendered. They allow developers to create custom visual effects,
				materials, lighting, and post-processing by manipulating how surfaces, sprites, and 2D/3D
				objects appear in the engine. Shaders in Godot can be used for a wide range of effects, from
				simple color changes to complex animations, procedural textures, and dynamic lighting,
				giving artists and programmers fine-grained control over the look and feel of their games.
			</p>
		</div>
	{/if}
</div>
<div class="flex h-[26rem] w-screen items-center justify-evenly pb-16">
	<div class="flex flex-col items-center">
		<h1 class="mb-2 text-center font-[Arvo] text-3xl font-bold">Guide Contents</h1>
		<ul class="list-disc">
			<li>Explanation of Shaders</li>
			<li>Godot's Shading Language</li>
			<li>Texture Sampling</li>
			<li>Procedural Effects</li>
			<li>Post-Processing</li>
			<li>Integration with Godot Scripts</li>
		</ul>
		<StartingButton></StartingButton>
	</div>
	<img
		src="/guide.png"
		class="h-[350px] shadow-md transition hover:scale-105 hover:shadow-lg"
		alt="guide"
	/>
</div>
<div class="absolute top-[60rem] -left-20 -z-10 h-[30rem] w-[200vw] -rotate-3 bg-slate-400"></div>
<div class="relative h-20 w-screen scale-y-200 bg-slate-400"></div>
<!-- <div class="flex h-screen w-screen flex-col items-center justify-center gap-8"> -->
<!-- 	<h1 class="text-center text-3xl font-bold"> -->
<!-- 		LOOK ITS THE ICON.SVG FROM HIT GAME ENGINE GODOT GAME ENGINE -->
<!-- 	</h1> -->
<!-- <GodotEditor></GodotEditor> -->
<!-- </div> -->
