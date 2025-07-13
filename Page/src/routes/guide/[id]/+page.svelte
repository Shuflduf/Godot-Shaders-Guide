<script lang="ts">
	import GodotEditor from '$lib/components/GodotEditor.svelte';
	import { SHUFL_BOX } from '$lib/styles';
	import { onMount } from 'svelte';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	let contentBox: HTMLElement;

	function scrollToTop() {
		contentBox.scrollTo({
			top: 0,
			behavior: 'smooth'
		});
	}

	function onNavScroll(e: WheelEvent) {
		e.preventDefault();
		(e.currentTarget as HTMLElement).scrollLeft += e.deltaY;
	}

	onMount(() => {
		setInterval(ensureHead, 1000);
	});

	function ensureHead() {
		document.title = data.name ? data.name : 'Shaders Guide';

		const favicon = document.querySelector("link[rel~='icon']") as HTMLLinkElement | null;
		if (favicon) {
			favicon.parentNode?.removeChild(favicon);
		}

		const newFavicon = document.createElement('link');
		newFavicon.rel = 'icon';
		newFavicon.href = '/favicon.png';
		document.head.appendChild(newFavicon);
	}
</script>

<div class="fixed flex h-screen w-screen flex-col gap-4 p-4">
	<div class="flex gap-4">
		<a href="/" aria-label="Home">
			<img src="/icon.png" class="w-16" alt="icon" />
		</a>
		<nav
			class="min-h-16 w-full {SHUFL_BOX} flex items-center gap-16 overflow-x-scroll px-8 whitespace-nowrap"
			onwheel={onNavScroll}
		>
			{#each data.guides as guide}
				<a
					href="/guide/{guide.id}"
					class="font-[Arvo] text-xl text-blue-500 transition hover:text-blue-400">{guide.name}</a
				>
			{/each}
		</nav>
	</div>
	<div class="flex h-full max-h-[calc(100vh-7rem)] flex-row gap-4">
		<main
			class="prose h-full w-md max-w-md min-w-md {SHUFL_BOX} overflow-y-auto"
			bind:this={contentBox}
		>
			{@html data.html}
			<a href="/guide/{data.next}">
				<button
					class="w-full cursor-pointer rounded-md bg-blue-400 p-4 font-[Arvo] text-lg text-white underline"
					onclick={scrollToTop}
				>
					Next Topic
				</button>
			</a>
		</main>
		<GodotEditor></GodotEditor>
	</div>
</div>
