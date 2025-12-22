/**
 * Kiwix Client Library
 * 
 * Shared utilities for interacting with the Kiwix server.
 * Provides search, article fetching, and dataset catalog functions.
 */

// Kiwix server configuration
export const KIWIX_BASE_URL = "http://100.82.131.40:8080";

// Common dataset aliases for convenience
export const DATASET_ALIASES: Record<string, string> = {
  // Wikimedia
  "wikipedia": "wikipedia_en_all_maxi_2025-08",
  "wiki": "wikipedia_en_all_maxi_2025-08",
  "wiktionary": "wiktionary_en_all_nopic_2025-09",
  "dict": "wiktionary_en_all_nopic_2025-09",
  "wikisource": "wikisource_en_all_maxi_2025-09",
  "wikibooks": "wikibooks_en_all_maxi_2025-10",
  "wikiquote": "wikiquote_en_all_maxi_2025-09",
  "wikiversity": "wikiversity_en_all_maxi_2025-07",
  "wikivoyage": "wikivoyage_en_all_maxi_2025-09",
  "wikinews": "wikinews_en_all_maxi_2025-10",
  
  // Stack Exchange
  "stackoverflow": "stackoverflow.com_en_all_2023-11",
  "so": "stackoverflow.com_en_all_2023-11",
  "superuser": "superuser.com_en_all_2025-10",
  "su": "superuser.com_en_all_2025-10",
  "serverfault": "serverfault.com_en_all_2025-08",
  "sf": "serverfault.com_en_all_2025-08",
  "softwareengineering": "softwareengineering.stackexchange.com_en_all_2025-08",
  "se": "softwareengineering.stackexchange.com_en_all_2025-08",
  "music": "music.stackexchange.com_en_all_2025-10",
  "philosophy": "philosophy.stackexchange.com_en_all_2025-10",
  "cooking": "cooking.stackexchange.com_en_all_2025-07",
  "gardening": "gardening.stackexchange.com_en_all_2025-08",
  "writing": "writing.stackexchange.com_en_all_2025-08",
  "woodworking": "woodworking.stackexchange.com_en_all_2025-08",
  "crafts": "crafts.stackexchange.com_en_all_2025-08",
  "ai": "ai.stackexchange.com_en_all_2025-08",
  "engineering": "engineering.stackexchange.com_en_all_2025-08",
  "literature": "literature.stackexchange.com_en_all_2025-08",
  "outdoors": "outdoors.stackexchange.com_en_all_2025-08",
  "boardgames": "boardgames.stackexchange.com_en_all_2025-08",
  
  // DevDocs
  "deno": "devdocs_en_deno_2025-10",
  "rust": "devdocs_en_rust_2025-10",
  "react": "devdocs_en_react_2025-10",
  "react-native": "devdocs_en_react-native_2025-10",
  "postgresql": "devdocs_en_postgresql_2025-10",
  "postgres": "devdocs_en_postgresql_2025-10",
  "duckdb": "devdocs_en_duckdb_2025-10",
  "git": "devdocs_en_git_2025-10",
  "npm": "devdocs_en_npm_2025-10",
  "fastapi": "devdocs_en_fastapi_2025-10",
  "electron": "devdocs_en_electron_2025-10",
  "playwright": "devdocs_en_playwright_2025-10",
  "puppeteer": "devdocs_en_puppeteer_2025-10",
  "nushell": "devdocs_en_nushell_2025-10",
  "jq": "devdocs_en_jq_2025-10",
  "markdown": "devdocs_en_markdown_2025-10",
  
  // Other
  "gutenberg": "gutenberg_en_all_2023-08",
  "books": "gutenberg_en_all_2023-08",
  "ifixit": "ifixit_en_all_2025-06",
  "freecodecamp": "freecodecamp_en_all_2025-07",
  "fcc": "freecodecamp_en_all_2025-07",
};

export interface SearchResult {
  title: string;
  url: string;
  path: string;
  snippet: string;
  wordCount?: number;
  dataset: string;
}

export interface SearchResponse {
  query: string;
  dataset: string;
  totalResults: number;
  results: SearchResult[];
  responseTime: number;
}

export interface DatasetInfo {
  id: string;
  name: string;
  title: string;
  summary: string;
  language: string;
  articleCount: number;
  mediaCount: number;
  updated: string;
  category?: string;
  tags: string[];
}

/**
 * Resolve a dataset alias to its full ZIM name
 */
export function resolveDataset(nameOrAlias: string): string {
  const lower = nameOrAlias.toLowerCase();
  return DATASET_ALIASES[lower] || nameOrAlias;
}

/**
 * Search within a specific dataset
 */
export async function searchDataset(
  dataset: string,
  query: string,
  options: {
    start?: number;
    pageLength?: number;
  } = {}
): Promise<SearchResponse> {
  const resolvedDataset = resolveDataset(dataset);
  const start = options.start ?? 0;
  const pageLength = options.pageLength ?? 25;
  
  const url = new URL(`${KIWIX_BASE_URL}/search`);
  url.searchParams.set("content", resolvedDataset);
  url.searchParams.set("pattern", query);
  url.searchParams.set("start", start.toString());
  url.searchParams.set("pageLength", pageLength.toString());
  
  const startTime = Date.now();
  
  const response = await fetch(url.toString());
  if (!response.ok) {
    throw new Error(`Kiwix search failed (${response.status}): ${await response.text()}`);
  }
  
  const html = await response.text();
  const endTime = Date.now();
  
  // Parse search results from HTML
  const results = parseSearchResults(html, resolvedDataset);
  const totalMatch = html.match(/Results <b>\d+-\d+<\/b> of <b>([\d,]+)<\/b>/);
  const totalResults = totalMatch ? parseInt(totalMatch[1].replace(/,/g, ""), 10) : results.length;
  
  return {
    query,
    dataset: resolvedDataset,
    totalResults,
    results,
    responseTime: endTime - startTime,
  };
}

/**
 * Parse search results from Kiwix HTML response
 */
function parseSearchResults(html: string, dataset: string): SearchResult[] {
  const results: SearchResult[] = [];
  
  // Match each <li> in results
  const liRegex = /<li>\s*<a href="([^"]+)"[^>]*>\s*([^<]+)\s*<\/a>(?:.*?<cite>([^<]*)<\/cite>)?(?:.*?<div class="informations">([^<]*)<\/div>)?/gs;
  
  let match;
  while ((match = liRegex.exec(html)) !== null) {
    const path = match[1];
    const title = match[2].trim();
    const snippet = match[3]?.replace(/\.\.\./g, "...").trim() || "";
    const infoText = match[4] || "";
    
    // Parse word count from "X words"
    const wordMatch = infoText.match(/([\d,]+)\s+words/);
    const wordCount = wordMatch ? parseInt(wordMatch[1].replace(/,/g, ""), 10) : undefined;
    
    results.push({
      title,
      url: `${KIWIX_BASE_URL}${path}`,
      path: path.replace(/^\/content\/[^/]+\//, ""),
      snippet,
      wordCount,
      dataset,
    });
  }
  
  return results;
}

/**
 * Fetch an article's HTML content
 */
export async function fetchArticle(
  dataset: string,
  articlePath: string
): Promise<string> {
  const resolvedDataset = resolveDataset(dataset);
  const url = `${KIWIX_BASE_URL}/content/${resolvedDataset}/${articlePath}`;
  
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to fetch article (${response.status}): ${url}`);
  }
  
  return await response.text();
}

/**
 * Extract text content from article HTML
 */
export function extractTextFromHtml(html: string): string {
  // Remove scripts and styles
  let text = html.replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "");
  text = text.replace(/<style[^>]*>[\s\S]*?<\/style>/gi, "");
  
  // Remove navigation/header/footer sections common in Wikipedia
  text = text.replace(/<nav[^>]*>[\s\S]*?<\/nav>/gi, "");
  text = text.replace(/<header[^>]*>[\s\S]*?<\/header>/gi, "");
  text = text.replace(/<footer[^>]*>[\s\S]*?<\/footer>/gi, "");
  text = text.replace(/<!--[\s\S]*?-->/g, "");
  
  // Try to extract main content area
  const mainMatch = text.match(/<main[^>]*>([\s\S]*?)<\/main>/i) ||
                    text.match(/<div[^>]*id="mw-content-text"[^>]*>([\s\S]*?)<\/div>\s*<\/div>\s*<\/main>/i) ||
                    text.match(/<div[^>]*class="mw-parser-output"[^>]*>([\s\S]*?)<\/div>/i);
  
  if (mainMatch) {
    text = mainMatch[1];
  }
  
  // Convert common elements to text
  text = text.replace(/<h[1-6][^>]*>([^<]*)<\/h[1-6]>/gi, "\n\n## $1\n\n");
  text = text.replace(/<p[^>]*>/gi, "\n");
  text = text.replace(/<\/p>/gi, "\n");
  text = text.replace(/<br\s*\/?>/gi, "\n");
  text = text.replace(/<li[^>]*>/gi, "\n- ");
  text = text.replace(/<\/li>/gi, "");
  
  // Remove remaining HTML tags
  text = text.replace(/<[^>]+>/g, "");
  
  // Decode HTML entities
  text = text.replace(/&nbsp;/g, " ");
  text = text.replace(/&amp;/g, "&");
  text = text.replace(/&lt;/g, "<");
  text = text.replace(/&gt;/g, ">");
  text = text.replace(/&quot;/g, '"');
  text = text.replace(/&#(\d+);/g, (_, n) => String.fromCharCode(parseInt(n, 10)));
  
  // Clean up whitespace
  text = text.replace(/\n{3,}/g, "\n\n");
  text = text.replace(/[ \t]+/g, " ");
  text = text.trim();
  
  return text;
}

/**
 * Get list of all available datasets from the catalog
 */
export async function listDatasets(): Promise<DatasetInfo[]> {
  const url = `${KIWIX_BASE_URL}/catalog/v2/entries?count=100`;
  
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to fetch catalog (${response.status})`);
  }
  
  const xml = await response.text();
  return parseCatalog(xml);
}

/**
 * Parse OPDS catalog XML
 */
function parseCatalog(xml: string): DatasetInfo[] {
  const datasets: DatasetInfo[] = [];
  
  // Simple regex-based XML parsing for the entry elements
  const entryRegex = /<entry>([\s\S]*?)<\/entry>/g;
  let match;
  
  while ((match = entryRegex.exec(xml)) !== null) {
    const entry = match[1];
    
    const id = entry.match(/<id>urn:uuid:([^<]+)<\/id>/)?.[1] || "";
    const title = entry.match(/<title>([^<]+)<\/title>/)?.[1] || "";
    const name = entry.match(/<name>([^<]+)<\/name>/)?.[1] || "";
    const summary = entry.match(/<summary>([^<]+)<\/summary>/)?.[1]?.replace(/&amp;/g, "&") || "";
    const language = entry.match(/<language>([^<]+)<\/language>/)?.[1] || "";
    const articleCount = parseInt(entry.match(/<articleCount>(\d+)<\/articleCount>/)?.[1] || "0", 10);
    const mediaCount = parseInt(entry.match(/<mediaCount>(\d+)<\/mediaCount>/)?.[1] || "0", 10);
    const updated = entry.match(/<updated>([^<]+)<\/updated>/)?.[1] || "";
    const category = entry.match(/<category>([^<]+)<\/category>/)?.[1];
    const tagsStr = entry.match(/<tags>([^<]+)<\/tags>/)?.[1] || "";
    const tags = tagsStr.split(";").filter(t => t && !t.startsWith("_"));
    
    datasets.push({
      id,
      name,
      title,
      summary,
      language,
      articleCount,
      mediaCount,
      updated,
      category,
      tags,
    });
  }
  
  return datasets;
}

export { KIWIX_BASE_URL as baseUrl };
