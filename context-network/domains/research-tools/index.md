# Research Tools Domain

## Purpose
Documentation for CLI research tools that help gather information for RetroCase development. These tools provide access to web search and local offline datasets.

## Classification
- **Domain:** Research Tools
- **Stability:** Stable (tool interfaces)
- **Abstraction:** Practical usage
- **Confidence:** Established

## Available Tools

### 1. Kiwix Local Datasets
**Location:** `scripts/kiwix/`

Search 52 offline datasets including Wikipedia (18.6M articles), Stack Overflow (30M Q&A), DevDocs, and more. Fast, no rate limits, works offline.

**Commands:**
- `kiwix_search.ts` - Search across datasets
- `kiwix_article.ts` - Fetch full article content

**Best for:** Encyclopedic facts, code Q&A, API documentation, established knowledge

→ [`kiwix-datasets.md`](kiwix-datasets.md)

### 2. Tavily Web Search
**Location:** `scripts/research/tavily-cli.ts`

AI-optimized web search via Tavily API. Returns high-quality results with optional AI-generated summaries.

**Requires:** `TAVILY_API_KEY` environment variable

**Best for:** Current information, news, content not in local datasets, emerging topics

→ [`tavily-search.md`](tavily-search.md)

## Quick Decision Guide

| Need | Use | Example |
|------|-----|---------|
| OpenSCAD syntax help | Kiwix (SO) | `kiwix_search "openscad module parameters" -d so` |
| BOSL2 library patterns | Kiwix (SO) | `kiwix_search "BOSL2 attachable" -d so` |
| Retro design history | Kiwix (Wiki) | `kiwix_search "Braun design Dieter Rams" -d wiki` |
| Electronics concepts | Kiwix (Wiki) | `kiwix_search "PCB mounting standoff" -d wiki` |
| Latest library updates | Tavily | `tavily "BOSL2 openscad 2024 updates"` |
| Current 3D printing news | Tavily | `tavily "parametric enclosure design" --topic news` |
| API documentation | Kiwix (DevDocs) | `kiwix_search "Deno.serve" -d deno` |

## When to Use Each

### Prefer Kiwix When:
- Looking up encyclopedic facts
- Searching programming Q&A (Stack Overflow)
- Checking API documentation
- Need fast, offline access
- Researching established/stable topics

### Prefer Tavily When:
- Need current/recent information
- Searching for news or updates
- Looking for content not in Kiwix datasets
- Need AI-summarized answers
- Researching emerging topics

## Documents in This Domain

| Document | Purpose |
|----------|---------|
| [`kiwix-datasets.md`](kiwix-datasets.md) | Kiwix usage, datasets, aliases |
| [`tavily-search.md`](tavily-search.md) | Tavily usage, options, API setup |
| [`research-workflow.md`](research-workflow.md) | Research patterns for RetroCase |

## Navigation

**Up:** [`../index.md`](../index.md) - All domains

**Related:**
- [`../bosl2-integration/`](../bosl2-integration/index.md) - BOSL2 library (research target)
- [`../../processes/development-workflow.md`](../../processes/development-workflow.md) - When to research

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain Index
