# Kiwix CLI Scripts

Command-line tools for querying the local Kiwix dataset server, which hosts Wikipedia, Stack Exchange, DevDocs, and 50+ other reference datasets.

## Server Details

- **URL:** http://100.82.131.40:8080/
- **Host:** Windows Desktop (via Tailscale)
- **Total Datasets:** 52
- **Total Articles:** 100M+

## Available Commands

### Search: `bun run scripts/kiwix/kiwix_search.ts`

Search across any dataset in the Kiwix library.

```bash
# Search Wikipedia (default)
bun run scripts/kiwix/kiwix_search.ts "Brian Eno ambient music"

# Search Stack Overflow
bun run scripts/kiwix/kiwix_search.ts "typescript discriminated union" -d stackoverflow

# Search Music Stack Exchange
bun run scripts/kiwix/kiwix_search.ts "modes of melodic minor" -d music

# Search with more results
bun run scripts/kiwix/kiwix_search.ts "synthesizer" -d wiki -n 20

# Output as JSON for scripting
bun run scripts/kiwix/kiwix_search.ts "Albuquerque" -d wiki --json

# List all available datasets
bun run scripts/kiwix/kiwix_search.ts --list

# Show dataset aliases
bun run scripts/kiwix/kiwix_search.ts --aliases
```

**Options:**
- `--dataset, -d <name>` - Dataset to search (default: wikipedia)
- `--results, -n <num>` - Number of results (default: 10)
- `--start, -s <num>` - Pagination offset
- `--json` - Output as JSON
- `--list` - List all available datasets
- `--aliases` - Show dataset alias shortcuts

### Fetch Article: `bun run scripts/kiwix/kiwix_article.ts`

Retrieve full article content from any dataset.

```bash
# Fetch a Wikipedia article by path
bun run scripts/kiwix/kiwix_article.ts "Moog_synthesizer" -d wikipedia

# Search and fetch first result
bun run scripts/kiwix/kiwix_article.ts "ambient music" -d wiki --search

# Get raw HTML
bun run scripts/kiwix/kiwix_article.ts "Brian_Eno" -d wiki --html

# Limit output length
bun run scripts/kiwix/kiwix_article.ts "Albuquerque,_New_Mexico" -d wiki --max 5000

# Output as JSON
bun run scripts/kiwix/kiwix_article.ts "Synthesizer" -d wiki --json
```

**Options:**
- `--dataset, -d <name>` - Dataset to fetch from (default: wikipedia)
- `--search` - Treat path as search query, fetch first result
- `--html` - Output raw HTML instead of extracted text
- `--json` - Output as JSON object
- `--max <chars>` - Maximum output length

## Dataset Aliases

For convenience, common datasets have short aliases:

| Alias | Dataset |
|-------|---------|
| `wiki`, `wikipedia` | English Wikipedia |
| `so`, `stackoverflow` | Stack Overflow |
| `su`, `superuser` | Super User |
| `sf`, `serverfault` | Server Fault |
| `se`, `softwareengineering` | Software Engineering SE |
| `music` | Music: Practice & Theory SE |
| `philosophy` | Philosophy SE |
| `cooking` | Cooking SE (Seasoned Advice) |
| `gardening` | Gardening & Landscaping SE |
| `writing` | Writing SE |
| `ai` | Artificial Intelligence SE |
| `deno` | Deno DevDocs |
| `rust` | Rust DevDocs |
| `react` | React DevDocs |
| `postgres` | PostgreSQL DevDocs |
| `gutenberg`, `books` | Project Gutenberg |
| `ifixit` | iFixit Repair Guides |

Run `bun run scripts/kiwix/kiwix_search.ts --aliases` for the complete list.

## Use Cases

### Research Workflow (Reverb Drift Podcast)

```bash
# Research an artist
bun run scripts/kiwix/kiwix_search.ts "Brian Eno" -d wiki -n 5
bun run scripts/kiwix/kiwix_article.ts "Brian_Eno" -d wiki --max 10000

# Find synthesis techniques
bun run scripts/kiwix/kiwix_search.ts "granular synthesis" -d wiki
bun run scripts/kiwix/kiwix_search.ts "ambient music production" -d music

# Look up quotes
bun run scripts/kiwix/kiwix_search.ts "Brian Eno quotes" -d wikiquote
```

### Quick Lookups

```bash
# Dictionary lookup
bun run scripts/kiwix/kiwix_search.ts "synthesizer" -d wiktionary

# Code patterns
bun run scripts/kiwix/kiwix_search.ts "React useEffect cleanup" -d stackoverflow

# API reference
bun run scripts/kiwix/kiwix_search.ts "Deno.serve" -d deno
```

### Integration with Other Tools

```bash
# Pipe to other commands
bun run scripts/kiwix/kiwix_search.ts "Albuquerque" -d wiki --json | jq '.results[0]'

# Use in scripts
ARTICLE=$(bun run scripts/kiwix/kiwix_article.ts "Moog_synthesizer" -d wiki --json)
```

## Library Usage

The scripts export functions for use in other TypeScript code:

```typescript
import { searchDataset, fetchArticle, extractTextFromHtml } from "./scripts/kiwix/lib/client.ts";

// Search
const results = await searchDataset("wikipedia", "synthesizer");
console.log(results.totalResults, "results found");

// Fetch article
const html = await fetchArticle("wikipedia", "Moog_synthesizer");
const text = extractTextFromHtml(html);
```

## Documentation

Full documentation: [Datasets Domain](../../context-network/domains/datasets/index.md)
