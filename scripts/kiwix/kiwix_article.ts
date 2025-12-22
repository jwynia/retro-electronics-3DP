/**
 * Kiwix Article Fetcher CLI
 * 
 * Fetch and display full articles from the local Kiwix dataset server.
 * Supports extracting clean text content from Wikipedia, Stack Exchange, and other sources.
 * 
 * Usage:
 *   bun run scripts/kiwix/kiwix_article.ts "Article_Name" --dataset wikipedia
 *   bun run scripts/kiwix/kiwix_article.ts "Moog_synthesizer" -d wiki
 *   bun run scripts/kiwix/kiwix_article.ts "typescript-generic-constraints" -d stackoverflow
 */

import {
  fetchArticle,
  extractTextFromHtml,
  resolveDataset,
  searchDataset,
  KIWIX_BASE_URL,
} from "./lib/client.ts";

interface ArticleOptions {
  path: string;
  dataset: string;
  html: boolean;
  json: boolean;
  search: boolean;
  maxLength?: number;
}

// Runtime compatibility - get command line args
const getArgs = (): string[] => {
  // Bun
  if (typeof Bun !== "undefined") {
    return Bun.argv.slice(2);
  }
  // Deno
  if (typeof Deno !== "undefined") {
    return Deno.args;
  }
  // Node
  return process.argv.slice(2);
};

function printHelp() {
  console.log(`
Kiwix Article Fetcher - Retrieve articles from offline datasets

Usage:
  deno task kiwix:article "Article_Path" [options]

Options:
  --dataset, -d <name>  Dataset to fetch from (default: wikipedia)
  --html                Output raw HTML instead of extracted text
  --json                Output as JSON object
  --search              Treat path as search query, fetch first result
  --max <chars>         Maximum output length (default: no limit)
  --help, -h            Show this help

Article Path:
  For Wikipedia, use underscores for spaces: "Moog_synthesizer"
  Path is the part after /content/{dataset}/ in URLs

Examples:
  deno task kiwix:article "Moog_synthesizer" -d wikipedia
  deno task kiwix:article "Brian_Eno" -d wiki
  deno task kiwix:article "ambient music" -d wiki --search
  deno task kiwix:article "Albuquerque,_New_Mexico" -d wiki --max 5000
`);
}

async function fetchAndDisplay(options: ArticleOptions): Promise<void> {
  let articlePath = options.path;
  const resolvedDataset = resolveDataset(options.dataset);
  
  // If search mode, find the article first
  if (options.search) {
    console.error(`Searching for "${options.path}" in ${options.dataset}...`);
    const searchResult = await searchDataset(resolvedDataset, options.path, {
      pageLength: 1,
    });
    
    if (searchResult.results.length === 0) {
      throw new Error(`No articles found matching "${options.path}"`);
    }
    
    articlePath = searchResult.results[0].path;
    console.error(`Found: ${searchResult.results[0].title}`);
    console.error(`Path: ${articlePath}\n`);
  }
  
  // Fetch the article
  const html = await fetchArticle(resolvedDataset, articlePath);
  
  if (options.json) {
    const text = extractTextFromHtml(html);
    const output = {
      dataset: resolvedDataset,
      path: articlePath,
      url: `${KIWIX_BASE_URL}/content/${resolvedDataset}/${articlePath}`,
      contentLength: text.length,
      content: options.maxLength ? text.slice(0, options.maxLength) : text,
      truncated: options.maxLength ? text.length > options.maxLength : false,
    };
    console.log(JSON.stringify(output, null, 2));
    return;
  }
  
  if (options.html) {
    let output = html;
    if (options.maxLength) {
      output = html.slice(0, options.maxLength);
      if (html.length > options.maxLength) {
        output += "\n\n[TRUNCATED]";
      }
    }
    console.log(output);
    return;
  }
  
  // Default: extract and display text
  let text = extractTextFromHtml(html);
  
  if (options.maxLength && text.length > options.maxLength) {
    text = text.slice(0, options.maxLength) + "\n\n[TRUNCATED]";
  }
  
  console.log(text);
}

// Main CLI
if (import.meta.main) {
  const args = getArgs();
  
  if (args.includes("--help") || args.includes("-h") || args.length === 0) {
    printHelp();
    process.exit(0);
  }
  
  // Parse arguments
  const options: ArticleOptions = {
    path: "",
    dataset: "wikipedia",
    html: false,
    json: false,
    search: false,
  };
  
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    
    if ((arg === "--dataset" || arg === "-d") && args[i + 1]) {
      options.dataset = args[++i];
    } else if (arg === "--html") {
      options.html = true;
    } else if (arg === "--json") {
      options.json = true;
    } else if (arg === "--search") {
      options.search = true;
    } else if (arg === "--max" && args[i + 1]) {
      options.maxLength = parseInt(args[++i], 10);
    } else if (!arg.startsWith("-")) {
      options.path = arg;
    }
  }
  
  if (!options.path) {
    console.error("Error: No article path provided\n");
    printHelp();
    process.exit(1);
  }
  
  try {
    await fetchAndDisplay(options);
  } catch (error) {
    console.error("Error:", error instanceof Error ? error.message : error);
    process.exit(1);
  }
}

export { fetchArticle, extractTextFromHtml };
