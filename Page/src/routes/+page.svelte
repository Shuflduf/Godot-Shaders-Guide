<script>
	import GodotEditor from '$lib/components/GodotEditor.svelte';
	import VidSlider from '$lib/components/VidSlider.svelte';
</script>

<div class="flex h-[36rem] w-screen items-center justify-evenly">
	<div>
		<h1 class="font-[Arvo] text-5xl font-bold">Godot Shaders Guide</h1>
		<h2 class="text-lg italic">
			A free and interactive tutorial to learn the Godot shaders system
		</h2>
	</div>
	<img src="icon.png" class="w-80" alt="godot shaders icon" />
</div>

<div class="flex h-[26rem] w-screen items-center justify-evenly bg-slate-300">
	<div class="flex flex-col gap-2">
		<VidSlider src1="/after.webm" src2="/before.webm"></VidSlider>
		<!-- <video src="/after.webm" autoplay loop><track kind="captions" /></video> -->
		<!-- <video src="/before.webm" autoplay loop><track kind="captions" /></video> -->
		<p class="text-center font-[Arvo] italic">Hover me!</p>
	</div>
	<div>
		<h1 class="mb-2 text-center font-[Arvo] text-3xl font-bold">What are Godot shaders?</h1>
		<p class="max-w-2xl">
			Godot shaders are small programs written in Godot's shading language that run on the GPU to
			control how objects are rendered. They allow developers to create custom visual effects,
			materials, lighting, and post-processing by manipulating how surfaces, sprites, and 2D/3D
			objects appear in the engine. Shaders in Godot can be used for a wide range of effects, from
			simple color changes to complex animations, procedural textures, and dynamic lighting, giving
			artists and programmers fine-grained control over the look and feel of their games.
		</p>
	</div>
</div>
<!-- <div class="flex h-screen w-screen flex-col items-center justify-center gap-8"> -->
<!-- 	<h1 class="text-center text-3xl font-bold"> -->
<!-- 		LOOK ITS THE ICON.SVG FROM HIT GAME ENGINE GODOT GAME ENGINE -->
<!-- 	</h1> -->
<!-- <GodotEditor></GodotEditor> -->
<!-- </div> -->
