# Domains - Specialized Knowledge Areas

## Purpose
This section organizes technical knowledge by domain. Each domain represents a distinct area of functionality in RetroCase, with its own patterns, techniques, and implementation details.

## Classification
- **Domain:** Technical implementation knowledge
- **Stability:** Dynamic (grows with new features)
- **Abstraction:** Detailed and structural
- **Confidence:** Established (core domains) to Evolving (newer domains)

## Available Domains

### [`bosl2-integration/`](bosl2-integration/index.md)
**BOSL2 Library Usage Patterns**

How RetroCase uses the BOSL2 library, including common patterns, idioms, and pitfalls. **Essential reading before writing OpenSCAD code.**

**Contains:**
- Attachment system usage
- Diff/tag geometric operations
- Common mistakes and solutions
- Project-specific BOSL2 idioms

### [`shells/`](shells/index.md)
**Shell Generation Patterns**

Techniques and patterns for generating hollow enclosures - the core structural component of RetroCase designs.

**Contains:**
- Monolithic shell patterns
- Split shell approaches
- Shell parameter reference
- Code location index

### [`faceplates/`](faceplates/index.md)
**Face Plate Designs**

Face plate generation patterns including screen bezels, blank control panels, and grille patterns.

**Contains:**
- Bezel face plate patterns
- Blank face plate patterns
- Magnetic attachment integration
- Code location index

### [`hardware/`](hardware/index.md)
**Mounting and Attachment Hardware**

Magnetic attachment systems, standoffs, screw pockets, and internal mounting solutions.

**Contains:**
- Magnetic attachment specifications
- Standoff and mounting patterns
- Hardware pocket generation
- Code location index

### [`profiles/`](profiles/index.md)
**2D Profile Generation**

2D profile patterns used with `offset_sweep()` and other path-based operations.

**Contains:**
- Profile generation patterns
- Common profile shapes
- Path generation techniques
- Code location index

### [`research-tools/`](research-tools/index.md)
**Research and Reference Tools**

CLI tools for gathering information during development - web search and local offline datasets.

**Contains:**
- Kiwix local dataset search (Wikipedia, Stack Overflow, DevDocs)
- Tavily web search (current information, news)
- Research workflow guidance
- When to use each tool

### [`external-libraries/`](external-libraries/index.md)
**External OpenSCAD Libraries**

Integration documentation for external libraries that provide hardware components, PCB definitions, and mounting patterns.

**Contains:**
- NopSCADlib (PCBs, connectors, hardware)
- PiHoles (Raspberry Pi mounting)
- Integration patterns and usage

### [`design-language/`](design-language/index.md)
**Retro Design Reference**

Reference documentation for the industrial designers and iconic products that inform RetroCase aesthetics.

**Contains:**
- Designer profiles (Dieter Rams, Mario Bellini, etc.)
- Iconic product catalog (Braun RT 20, Olivetti Divisumma, JVC Videosphere)
- Parametric patterns derived from classic designs

## Domain Structure Pattern

Each domain follows a consistent structure:

```
domain-name/
├── index.md           # Overview and navigation
├── [topic].md         # Topic-specific documents
└── locations.md       # Code location index
```

## Navigation Guidance

### For Learning a Domain
1. Start with the domain's `index.md`
2. Read topic documents that interest you
3. Check `locations.md` to see actual implementations

### For Finding Code
1. Go directly to the domain's `locations.md`
2. Find the concept you're looking for
3. Follow file paths to actual code

### For Understanding Patterns
1. Read the relevant topic document
2. Check examples referenced in the document
3. Review related decision records

## Cross-Domain Connections

Domains are interconnected. See [`../cross-domain/`](../cross-domain/index.md) for:
- Parameter naming conventions across domains
- Module dependency relationships
- Interface contracts between domains

## Navigation

**Up:** [`../discovery.md`](../discovery.md) - Main context network navigation

**Related Sections:**
- [`../foundation/`](../foundation/index.md) - Foundational project knowledge
- [`../processes/`](../processes/index.md) - Development workflows
- [`../cross-domain/`](../cross-domain/index.md) - Cross-cutting concerns

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Section Type:** Domain knowledge collection
