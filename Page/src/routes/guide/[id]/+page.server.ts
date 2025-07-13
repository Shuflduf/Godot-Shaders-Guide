import { env } from '$env/dynamic/private';
import type { PageServerLoad } from './$types';
import { Client } from "@notionhq/client"
import { NotionToMarkdown } from "notion-to-md";
import { marked } from "marked";

const cache: Record<string, { lastEdited: string, data: any }> = {};

export const load: PageServerLoad = async ({ params }) => {
  const notion = new Client({
    auth: env.NOTION_KEY
  });
  const n2m = new NotionToMarkdown({ notionClient: notion });

  const dbRes = await notion.databases.query({
    database_id: env.NOTION_DATABASE_ID,
    filter: {
      property: "ID",
      rich_text: { equals: params.id }
    }
  });
  const page = dbRes.results[0] as any;
  const props = page.properties;
  const lastEdited = page.last_edited_time;

  if (cache[params.id] && cache[params.id].lastEdited === lastEdited) {
    return cache[params.id].data;
  }

  const name = props["Name"].title[0].text.content;
  const next = props["Next"].rich_text[0].text.content;
  const id = page.id;
  const blocks = await n2m.pageToMarkdown(id);
  const mdString = `# ${name}\n ${n2m.toMarkdownString(blocks).parent}`;
  const html = marked.parse(mdString);

  const guidesRes = await notion.databases.query({
    database_id: env.NOTION_DATABASE_ID,
    sorts: [
      {
        property: "ID",
        direction: "ascending"
      }
    ]
  })
  const guides = guidesRes.results.map((g) => {
    return { name: g.properties.Name.title[0].plain_text, id: g.properties.ID.rich_text[0].plain_text }
  })
  console.log(guides);

  const data = { html, name, next, guides };

  cache[params.id] = { lastEdited, data };
  return data;
};
