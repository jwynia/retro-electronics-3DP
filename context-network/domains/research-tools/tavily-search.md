# Tavily Web Search

## Purpose
AI-optimized web search CLI for finding current information not available in local datasets.

## Classification
- **Domain:** Research Tools
- **Stability:** Stable
- **Abstraction:** Tool reference
- **Confidence:** Established

## Location
`scripts/research/tavily-cli.ts`

## Requirements
- **Runtime:** Deno
- **API Key:** `TAVILY_API_KEY` environment variable

## Basic Usage

```bash
# Simple search
deno task tavily "your search query"

# With AI-generated answer summary
deno task tavily "your search query" --answer

# Deeper search with more results
deno task tavily "your search query" --depth advanced --results 10

# Output as JSON for scripting
deno task tavily "your search query" --json
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--answer` | Include AI-generated answer summary | false |
| `--depth <level>` | Search depth: `basic` or `advanced` | basic |
| `--results <n>` | Number of results to return | 5 |
| `--topic <type>` | Topic: `general`, `news`, or `finance` | general |
| `--time <range>` | Time filter: `day`, `week`, `month`, `year` | none |
| `--include <domains>` | Only include these domains (comma-separated) | none |
| `--exclude <domains>` | Exclude these domains (comma-separated) | none |
| `--raw` | Include raw page content | false |
| `--json` | Output as JSON | false |

## RetroCase Use Cases

### Finding Current Library Updates
```bash
deno task tavily "BOSL2 OpenSCAD library 2024 updates" --answer
deno task tavily "NopSCADlib new features" --depth advanced
```

### Researching Design Trends
```bash
deno task tavily "retro electronics enclosure design 3D printing" --answer
deno task tavily "parametric OpenSCAD case design" --results 10
```

### Finding Existing Models
```bash
deno task tavily "Raspberry Pi case OpenSCAD parametric" --answer
deno task tavily "electronics enclosure STL GitHub" --results 10
```

### News and Updates
```bash
deno task tavily "3D printing news" --topic news --time week
deno task tavily "OpenSCAD development" --topic news
```

## When to Use Tavily

**Good for:**
- Current/recent information (last few months)
- News and updates
- Content not in Wikipedia/Stack Overflow
- AI-summarized overviews of topics
- Finding GitHub repos and recent projects

**Not ideal for:**
- Stable encyclopedic facts (use Kiwix/Wikipedia)
- Programming Q&A (use Kiwix/Stack Overflow)
- API documentation (use Kiwix/DevDocs)
- High-volume lookups (rate limited)

## Output Format

### Human-readable (default)
```
🔍 Search: "your query"

Found 5 results in 892ms

📝 AI Answer:
────────────────────────────────────────
[Summary of findings]
────────────────────────────────────────

1. Result Title
   https://example.com/page
   Snippet of content...
   Score: 0.892

2. ...
```

### JSON (--json)
```json
{
  "query": "your query",
  "answer": "AI-generated summary...",
  "results": [
    {
      "title": "Result Title",
      "url": "https://example.com/page",
      "content": "Full snippet...",
      "score": 0.892
    }
  ],
  "response_time": 892
}
```

## API Key Setup

1. Get API key from [tavily.com](https://tavily.com)
2. Set environment variable:
   ```bash
   export TAVILY_API_KEY="your-api-key"
   ```
3. Or add to `.env` file in project root

## Navigation

**Up:** [`index.md`](index.md) - Research Tools overview

**Related:**
- [`kiwix-datasets.md`](kiwix-datasets.md) - Local offline search (alternative)
- [`research-workflow.md`](research-workflow.md) - When to use which tool

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Tool Reference
