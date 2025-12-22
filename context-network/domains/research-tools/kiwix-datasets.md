# Kiwix Local Datasets

## Purpose
Search local offline reference datasets including Wikipedia, Stack Exchange, DevDocs, and 50+ other sources. Fast, no rate limits, works offline.

## Classification
- **Domain:** Research Tools
- **Stability:** Stable
- **Abstraction:** Tool reference
- **Confidence:** Established

## Location
`scripts/kiwix/`

## Server
- **URL:** http://100.82.131.40:8080/
- **Host:** Windows Desktop (via Tailscale)
- **Total Datasets:** 52
- **Total Articles:** 100M+

## Commands

### Search: `kiwix_search.ts`
Search across any dataset in the library.

```bash
# Search Wikipedia (default)
bun run scripts/kiwix/kiwix_search.ts "your query"

# Search specific dataset
bun run scripts/kiwix/kiwix_search.ts "your query" -d stackoverflow

# More results
bun run scripts/kiwix/kiwix_search.ts "your query" -d wiki -n 20

# JSON output
bun run scripts/kiwix/kiwix_search.ts "your query" --json

# List all datasets
bun run scripts/kiwix/kiwix_search.ts --list

# Show aliases
bun run scripts/kiwix/kiwix_search.ts --aliases
```

### Fetch Article: `kiwix_article.ts`
Retrieve full article content.

```bash
# Fetch by path
bun run scripts/kiwix/kiwix_article.ts "Article_Title" -d wikipedia

# Search and fetch first result
bun run scripts/kiwix/kiwix_article.ts "search query" -d wiki --search

# Limit output length
bun run scripts/kiwix/kiwix_article.ts "Article" -d wiki --max 5000

# Get raw HTML
bun run scripts/kiwix/kiwix_article.ts "Article" -d wiki --html
```

## Dataset Aliases

| Alias | Dataset | Content |
|-------|---------|---------|
| `wiki`, `wikipedia` | English Wikipedia | 18.6M articles |
| `so`, `stackoverflow` | Stack Overflow | 30M Q&A |
| `su`, `superuser` | Super User | System admin Q&A |
| `sf`, `serverfault` | Server Fault | Server Q&A |
| `se`, `softwareengineering` | Software Engineering SE | Dev practices |
| `music` | Music Stack Exchange | Music theory |
| `philosophy` | Philosophy SE | Philosophy Q&A |
| `cooking` | Cooking SE | Recipes, techniques |
| `gardening` | Gardening SE | Plants, landscaping |
| `writing` | Writing SE | Writing craft |
| `ai` | AI Stack Exchange | AI/ML Q&A |
| `deno` | Deno DevDocs | Deno API docs |
| `rust` | Rust DevDocs | Rust API docs |
| `react` | React DevDocs | React API docs |
| `postgres` | PostgreSQL DevDocs | PostgreSQL docs |
| `gutenberg`, `books` | Project Gutenberg | Public domain books |
| `ifixit` | iFixit | Repair guides |
| `wiktionary` | Wiktionary | Dictionary |
| `wikiquote` | Wikiquote | Quotations |

## RetroCase Use Cases

### OpenSCAD Help
```bash
# Boolean operations
bun run scripts/kiwix/kiwix_search.ts "openscad difference union" -d so

# Module parameters
bun run scripts/kiwix/kiwix_search.ts "openscad module children" -d so

# BOSL2 patterns
bun run scripts/kiwix/kiwix_search.ts "BOSL2 attachable" -d so
```

### Retro Design Research
```bash
# Design history
bun run scripts/kiwix/kiwix_search.ts "Braun design Dieter Rams" -d wiki
bun run scripts/kiwix/kiwix_article.ts "Dieter_Rams" -d wiki --max 10000

# Specific products
bun run scripts/kiwix/kiwix_search.ts "Braun RT 20 radio" -d wiki
bun run scripts/kiwix/kiwix_search.ts "1970s consumer electronics" -d wiki
```

### Electronics References
```bash
# PCB mounting
bun run scripts/kiwix/kiwix_search.ts "PCB standoff mounting" -d wiki
bun run scripts/kiwix/kiwix_search.ts "heat set insert" -d so

# Raspberry Pi
bun run scripts/kiwix/kiwix_search.ts "Raspberry Pi GPIO" -d wiki
bun run scripts/kiwix/kiwix_search.ts "Raspberry Pi enclosure" -d so
```

### API Documentation
```bash
# Deno APIs
bun run scripts/kiwix/kiwix_search.ts "Deno.serve" -d deno
bun run scripts/kiwix/kiwix_article.ts "Deno.serve" -d deno --search

# TypeScript
bun run scripts/kiwix/kiwix_search.ts "discriminated union" -d so
```

## Search Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--dataset` | `-d` | Dataset to search | wikipedia |
| `--results` | `-n` | Number of results | 10 |
| `--start` | `-s` | Pagination offset | 0 |
| `--json` | | Output as JSON | false |
| `--list` | | List all datasets | |
| `--aliases` | | Show dataset aliases | |

## Article Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--dataset` | `-d` | Dataset to fetch from | wikipedia |
| `--search` | | Treat path as search query | false |
| `--html` | | Output raw HTML | false |
| `--json` | | Output as JSON | false |
| `--max` | | Maximum output chars | unlimited |

## When to Use Kiwix

**Good for:**
- Encyclopedic facts and history
- Programming Q&A (Stack Overflow)
- API documentation (DevDocs)
- Established/stable information
- High-volume lookups (no rate limits)
- Offline access

**Not ideal for:**
- Current/recent information
- News and updates
- Topics not covered by datasets
- AI-summarized overviews

## Navigation

**Up:** [`index.md`](index.md) - Research Tools overview

**Related:**
- [`tavily-search.md`](tavily-search.md) - Web search (alternative)
- [`research-workflow.md`](research-workflow.md) - When to use which tool

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Tool Reference
