<script lang="ts">
	let { src1, src2 }: { src1: string; src2: string } = $props();
	let w: number = $state(0);

	function onMouseMove(event: MouseEvent) {
		console.log(event);
		w = event.layerX;
	}

	function onMouseLeave(_: MouseEvent) {
		w = 360;
	}
</script>

<div
	class="relative h-[360px] w-[360px]"
	onmousemove={onMouseMove}
	onmouseleave={onMouseLeave}
	role="region"
>
	<video src={src2} loop autoplay class="absolute top-0 left-0 h-full w-full"
		><track kind="captions" /></video
	>
	<video
		src={src1}
		loop
		autoplay
		style="width: {w}px; transition: width 100ms;"
		class="absolute top-0 left-0 float-left h-[360px] overflow-hidden object-cover object-left"
		><track kind="captions" /></video
	>
</div>
