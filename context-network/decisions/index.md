# Decisions - Architecture Decision Records

## Purpose
This section contains Architecture Decision Records (ADRs) documenting significant architectural and design choices made in RetroCase. Each ADR explains what decision was made, why it was made, and what alternatives were considered.

## Classification
- **Domain:** Architectural decision documentation
- **Stability:** Static (ADRs are immutable once written)
- **Abstraction:** Conceptual and strategic
- **Confidence:** Established

## Decision Records

### [`001-bosl2-attachment-system.md`](001-bosl2-attachment-system.md)
**Using BOSL2's Attachment System Throughout**

**Status:** Accepted
**Date:** Project inception

**Decision:** All modules use BOSL2's `attachable()` system rather than manual `translate()` and `rotate()` operations.

**Impact:** Shells, faceplates, hardware modules

### [`002-magnetic-closure-design.md`](002-magnetic-closure-design.md)
**Magnetic Closures Over Screws**

**Status:** Accepted
**Date:** Project inception

**Decision:** Use disc magnets paired with steel discs for face plate attachment rather than threaded screws.

**Impact:** Faceplate design, hardware modules, aesthetic considerations

### [`003-module-organization.md`](003-module-organization.md)
**Module Organization by Function**

**Status:** Accepted
**Date:** Project inception

**Decision:** Organize modules into profiles/, shells/, faces/, and hardware/ rather than by product or use case.

**Impact:** Directory structure, module naming, documentation organization

### [`004-design-language-constraints.md`](004-design-language-constraints.md)
**Braun/Rams Aesthetic Boundaries**

**Status:** Accepted
**Date:** Project inception

**Decision:** Constrain design language to Braun/Dieter Rams aesthetics, 1970s Japanese electronics, and Space Age/Atomic design influences.

**Impact:** Shell shapes, parameter ranges, preset designs

## Recent Decisions

### Latest: 004-design-language-constraints.md
**Date:** Project inception
**Category:** Design Philosophy

Established the aesthetic boundaries for RetroCase designs, focusing on retro minimalism.

## Decision Record Format

Each ADR follows this structure:

```markdown
# ADR-XXX: [Title]

## Status
[Accepted | Rejected | Superseded | Deprecated]

## Context
[What is the issue we're facing?]

## Decision
[What did we decide?]

## Rationale
[Why did we make this choice?]

## Alternatives Considered
[What other options did we evaluate?]

## Consequences
[What are the implications of this decision?]

## Related Decisions
[Links to related ADRs]
```

## Navigation Patterns

### For Understanding Architecture
Read decisions in chronological order (001 → 004) to understand how the architecture evolved.

### For Specific Topics
Use the index above to find decisions by topic or impact area.

### When Making New Decisions
1. Review existing decisions for precedent
2. Check for related or conflicting decisions
3. Create a new ADR following the template

## Navigation

**Up:** [`../discovery.md`](../discovery.md) - Main context network navigation

**Related Sections:**
- [`../foundation/architecture.md`](../foundation/architecture.md) - Current architectural state
- [`../foundation/project-definition.md`](../foundation/project-definition.md) - Project vision that guides decisions
- [`../planning/`](../planning/index.md) - Future decisions in planning

## Creating New Decision Records

See [`../meta/templates/decision-template.md`](../meta/templates/decision-template.md) for the ADR template.

Number decisions sequentially (005, 006, etc.).

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Section Type:** Decision record collection
- **Total Decisions:** 4
