<script lang="ts">
	import GodotEditor from '$lib/components/GodotEditor.svelte';
	import { SHUFL_BOX } from '$lib/styles';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
</script>

<title>{data.name}</title>
<div class="fixed flex h-screen w-screen flex-col gap-4 p-4">
	<nav class="min-h-24 w-full {SHUFL_BOX}"></nav>
	<div class="flex h-full max-h-[calc(100vh-9rem)] flex-row gap-4">
		<main class="prose h-full w-md max-w-md min-w-md {SHUFL_BOX} overflow-y-auto">
			{@html data.html}
			<a href="/guide/{data.next}">
				<button
					class="w-full cursor-pointer rounded-md bg-blue-400 p-4 font-[Arvo] text-lg text-white underline"
				>
					Next Topic
				</button>
			</a>
		</main>
		<GodotEditor></GodotEditor>
	</div>
</div>
