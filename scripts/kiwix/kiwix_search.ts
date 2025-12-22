/**
 * Kiwix Search CLI
 * 
 * Search the local Kiwix dataset server for information across Wikipedia,
 * Stack Exchange, DevDocs, and other reference datasets.
 * 
 * Usage:
 *   bun run scripts/kiwix/kiwix_search.ts "your query"
 *   bun run scripts/kiwix/kiwix_search.ts "your query" --dataset wikipedia
 *   bun run scripts/kiwix/kiwix_search.ts "your query" --dataset stackoverflow --results 10
 * 
 * Available dataset aliases:
 *   wikipedia, wiki, stackoverflow, so, superuser, music, deno, rust, etc.
 *   Use --list to see all available datasets.
 */

import {
  searchDataset,
  listDatasets,
  resolveDataset,
  DATASET_ALIASES,
  type SearchResult,
} from "./lib/client.ts";

interface SearchOptions {
  query: string;
  dataset: string;
  results: number;
  start: number;
  json: boolean;
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
Kiwix Search CLI - Search offline reference datasets

Usage:
  deno task kiwix:search "search query" [options]

Options:
  --dataset, -d <name>  Dataset to search (default: wikipedia)
  --results, -n <num>   Number of results (default: 10)
  --start, -s <num>     Starting offset for pagination (default: 0)
  --json                Output as JSON
  --list                List all available datasets
  --aliases             Show dataset aliases
  --help, -h            Show this help

Dataset Aliases:
  wiki, wikipedia       English Wikipedia (18.6M articles)
  so, stackoverflow     Stack Overflow (30M Q&A)
  su, superuser         Super User
  music                 Music Stack Exchange
  deno, rust, react     DevDocs documentation
  gutenberg, books      Project Gutenberg

Examples:
  deno task kiwix:search "Brian Eno ambient music"
  deno task kiwix:search "typescript discriminated union" -d stackoverflow
  deno task kiwix:search "modes melodic minor" -d music
  deno task kiwix:search "Albuquerque history" -d wiki -n 20
  deno task kiwix:search "Deno.serve" -d deno
`);
}

function printAliases() {
  console.log("\nDataset Aliases:\n");
  
  const grouped: Record<string, string[]> = {};
  for (const [alias, dataset] of Object.entries(DATASET_ALIASES)) {
    if (!grouped[dataset]) {
      grouped[dataset] = [];
    }
    grouped[dataset].push(alias);
  }
  
  for (const [dataset, aliases] of Object.entries(grouped)) {
    console.log(`  ${aliases.join(", ")}`);
    console.log(`    -> ${dataset}\n`);
  }
}

async function printDatasetList() {
  console.log("\nFetching available datasets...\n");
  
  try {
    const datasets = await listDatasets();
    
    // Group by category
    const byCategory: Record<string, typeof datasets> = {};
    for (const ds of datasets) {
      const cat = ds.category || "other";
      if (!byCategory[cat]) {
        byCategory[cat] = [];
      }
      byCategory[cat].push(ds);
    }
    
    for (const [category, items] of Object.entries(byCategory)) {
      console.log(`\n## ${category.toUpperCase()}\n`);
      for (const ds of items.sort((a, b) => b.articleCount - a.articleCount)) {
        const articles = ds.articleCount.toLocaleString();
        console.log(`  ${ds.name}`);
        console.log(`    ${ds.title} - ${articles} articles`);
      }
    }
    
    console.log(`\nTotal: ${datasets.length} datasets\n`);
  } catch (error) {
    console.error("Error fetching datasets:", error instanceof Error ? error.message : error);
    process.exit(1);
  }
}

function formatResult(result: SearchResult, index: number): string {
  const lines = [
    `${index + 1}. ${result.title}`,
    `   ${result.url}`,
  ];
  
  if (result.snippet) {
    // Clean up snippet for display
    const snippet = result.snippet
      .replace(/\s+/g, " ")
      .trim()
      .slice(0, 200);
    lines.push(`   ${snippet}${result.snippet.length > 200 ? "..." : ""}`);
  }
  
  if (result.wordCount) {
    lines.push(`   ${result.wordCount.toLocaleString()} words`);
  }
  
  return lines.join("\n");
}

// Main CLI
if (import.meta.main) {
  const args = getArgs();
  
  // Handle special flags first
  if (args.includes("--help") || args.includes("-h") || args.length === 0) {
    printHelp();
    process.exit(0);
  }
  
  if (args.includes("--list")) {
    await printDatasetList();
    process.exit(0);
  }
  
  if (args.includes("--aliases")) {
    printAliases();
    process.exit(0);
  }
  
  // Parse arguments
  const options: SearchOptions = {
    query: "",
    dataset: "wikipedia",
    results: 10,
    start: 0,
    json: false,
  };
  
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    
    if ((arg === "--dataset" || arg === "-d") && args[i + 1]) {
      options.dataset = args[++i];
    } else if ((arg === "--results" || arg === "-n") && args[i + 1]) {
      options.results = parseInt(args[++i], 10);
    } else if ((arg === "--start" || arg === "-s") && args[i + 1]) {
      options.start = parseInt(args[++i], 10);
    } else if (arg === "--json") {
      options.json = true;
    } else if (!arg.startsWith("-")) {
      options.query = arg;
    }
  }
  
  if (!options.query) {
    console.error("Error: No search query provided\n");
    printHelp();
    process.exit(1);
  }
  
  try {
    const resolvedDataset = resolveDataset(options.dataset);
    const response = await searchDataset(resolvedDataset, options.query, {
      start: options.start,
      pageLength: options.results,
    });
    
    if (options.json) {
      console.log(JSON.stringify(response, null, 2));
    } else {
      console.log(`\nSearch: "${response.query}" in ${options.dataset}`);
      console.log(`Found ${response.totalResults.toLocaleString()} results in ${response.responseTime}ms\n`);
      
      if (response.results.length === 0) {
        console.log("No results found.\n");
      } else {
        for (const [i, result] of response.results.entries()) {
          console.log(formatResult(result, options.start + i));
          console.log();
        }
        
        if (response.totalResults > options.start + response.results.length) {
          const nextStart = options.start + response.results.length;
          console.log(`More results available. Use --start ${nextStart} to see next page.\n`);
        }
      }
    }
  } catch (error) {
    console.error("Error:", error instanceof Error ? error.message : error);
    process.exit(1);
  }
}

export { searchDataset, type SearchOptions };
