import { env } from '$env/dynamic/private';
import type { PageServerLoad } from './$types';
import { Client } from "@notionhq/client"
import { NotionToMarkdown } from "notion-to-md";
import { marked } from "marked";

export const load: PageServerLoad = async ({ params }) => {
  const notion = new Client({
    auth: env.NOTION_KEY
  })
  const n2m = new NotionToMarkdown({ notionClient: notion })

  const dbRes = await notion.databases.query({
    database_id: env.NOTION_DATABASE_ID,
    filter: {
      property: "ID",
      rich_text: { equals: params.id }
    }
  })
  const id = dbRes.results[0].id
  const blocks = await n2m.pageToMarkdown(id)
  const mdString = n2m.toMarkdownString(blocks).parent
  const html = marked.parse(mdString)
  console.log(html);

  return { html }
};
