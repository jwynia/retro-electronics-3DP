# Research Workflow

## Purpose
Guide for using research tools effectively during RetroCase development.

## Classification
- **Domain:** Research Tools
- **Stability:** Stable
- **Abstraction:** Process guidance
- **Confidence:** Established

## Decision Tree

```
What do I need to find?
│
├─ Programming/code help?
│  └─ Use Kiwix → Stack Overflow (-d so)
│
├─ API documentation?
│  └─ Use Kiwix → DevDocs (-d deno, -d rust, etc.)
│
├─ Encyclopedic facts/history?
│  └─ Use Kiwix → Wikipedia (-d wiki)
│
├─ Current news/updates?
│  └─ Use Tavily → --topic news
│
├─ Recent library changes?
│  └─ Use Tavily → web search with year
│
├─ Design inspiration/history?
│  ├─ Historical: Kiwix → Wikipedia
│  └─ Current trends: Tavily
│
└─ Not sure where to find it?
   └─ Try Kiwix first, then Tavily if not found
```

## RetroCase Research Scenarios

### Scenario 1: BOSL2 Function Help

**Goal:** Understand how to use a BOSL2 function

```bash
# Step 1: Search Stack Overflow for usage examples
bun run scripts/kiwix/kiwix_search.ts "BOSL2 cuboid rounding" -d so

# Step 2: If not found, check for OpenSCAD general patterns
bun run scripts/kiwix/kiwix_search.ts "openscad rounding edges" -d so

# Step 3: If still stuck, search web for recent discussions
deno task tavily "BOSL2 cuboid rounding edges 2024" --answer
```

### Scenario 2: Retro Design Research

**Goal:** Research a specific retro design style

```bash
# Step 1: Get encyclopedic background from Wikipedia
bun run scripts/kiwix/kiwix_search.ts "Braun design products" -d wiki
bun run scripts/kiwix/kiwix_article.ts "Braun_(company)" -d wiki --max 8000

# Step 2: Research the designer
bun run scripts/kiwix/kiwix_article.ts "Dieter_Rams" -d wiki --max 8000

# Step 3: Find current design discussions
deno task tavily "Dieter Rams design principles modern application" --answer
```

### Scenario 3: Electronics Mounting

**Goal:** Find standard mounting patterns for a component

```bash
# Step 1: Check Wikipedia for standards
bun run scripts/kiwix/kiwix_search.ts "PCB mounting hole spacing" -d wiki

# Step 2: Search Stack Overflow for practical advice
bun run scripts/kiwix/kiwix_search.ts "Raspberry Pi mounting holes" -d so

# Step 3: Find specific dimensions
bun run scripts/kiwix/kiwix_search.ts "M2.5 standoff PCB" -d so
```

### Scenario 4: Finding Existing OpenSCAD Libraries

**Goal:** Find libraries that might already solve a problem

```bash
# Step 1: Search for existing solutions
deno task tavily "OpenSCAD parametric enclosure library GitHub" --answer

# Step 2: Search for specific features
deno task tavily "NopSCADlib Raspberry Pi mount" --results 10

# Step 3: Check for BOSL2 solutions
bun run scripts/kiwix/kiwix_search.ts "BOSL2 electronics enclosure" -d so
```

### Scenario 5: 3D Printing Parameters

**Goal:** Find optimal print settings for enclosures

```bash
# Step 1: General knowledge from Wikipedia
bun run scripts/kiwix/kiwix_search.ts "FDM 3D printing wall thickness" -d wiki

# Step 2: Practical advice from forums
bun run scripts/kiwix/kiwix_search.ts "3D print enclosure wall thickness" -d so

# Step 3: Current best practices
deno task tavily "3D printing enclosure best practices 2024" --answer
```

## Research Best Practices

### Start Local, Then Go Web
1. **First:** Check Kiwix (fast, no rate limits)
2. **Then:** If not found or need current info, use Tavily

### Use the Right Dataset
| Topic | Best Dataset |
|-------|--------------|
| Code syntax | Stack Overflow (`-d so`) |
| Design history | Wikipedia (`-d wiki`) |
| API usage | DevDocs (`-d deno`, etc.) |
| Current trends | Tavily (web) |

### Capture Findings
When you find useful information:
1. Record it in the context network
2. Create a discovery record if significant
3. Link to related concepts

### Verify Information
- Cross-reference between sources
- Check dates for currency
- Prefer official documentation for APIs

## Common Queries Reference

### OpenSCAD/BOSL2
```bash
bun run scripts/kiwix/kiwix_search.ts "openscad [topic]" -d so
bun run scripts/kiwix/kiwix_search.ts "BOSL2 [function]" -d so
deno task tavily "BOSL2 [topic] example" --answer
```

### Electronics
```bash
bun run scripts/kiwix/kiwix_search.ts "[component] mounting" -d wiki
bun run scripts/kiwix/kiwix_search.ts "[board] enclosure" -d so
```

### Design
```bash
bun run scripts/kiwix/kiwix_article.ts "[Designer_Name]" -d wiki
bun run scripts/kiwix/kiwix_search.ts "[era] electronics design" -d wiki
```

## Navigation

**Up:** [`index.md`](index.md) - Research Tools overview

**Related:**
- [`kiwix-datasets.md`](kiwix-datasets.md) - Kiwix tool reference
- [`tavily-search.md`](tavily-search.md) - Tavily tool reference
- [`../../processes/development-workflow.md`](../../processes/development-workflow.md) - When research fits in workflow

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Process Guide
