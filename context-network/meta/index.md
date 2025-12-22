# Meta - About This Context Network

## Purpose
This section contains information about the context network itself - how to maintain it, templates for creating new content, and tracking updates.

## Classification
- **Domain:** Meta-documentation
- **Stability:** Semi-stable (evolves with network practices)
- **Abstraction:** Procedural and structural
- **Confidence:** Established

## Meta Documents

### [`maintenance.md`](maintenance.md)
**Context Network Maintenance Procedures**

How to keep the context network current, organized, and valuable.

**Contains:**
- Update triggers and frequency
- Review processes
- Structural maintenance (keeping files small, well-linked)
- Discovery record creation procedures

### [`templates/`](templates/)
**Content Creation Templates**

Templates for creating new documents in the context network.

**Available templates:**
- [`category-index-template.md`](templates/category-index-template.md) - For category indexes
- [`item-template.md`](templates/item-template.md) - For individual content items
- [`location-index-template.md`](templates/location-index-template.md) - For code location indexes
- [`decision-template.md`](templates/decision-template.md) - For Architecture Decision Records

### [`updates/`](updates/)
**Update Tracking**

History of updates to the context network.

**Structure:**
- [`updates/index.md`](updates/index.md) - Main updates index

## Maintenance Philosophy

### The 3-Line Rule
If you read more than 3 lines of code to understand something, **record it** in the context network.

### Update Triggers
Update the context network when:
- Starting a new task
- Making architectural decisions
- Discovering new relationships between components
- Every 10-15 minutes of active work
- Finding important information in source files

### Atomic Note Principle
- One concept = one file
- 100-300 lines maximum per document
- Link extensively between related documents
- Use index/hub documents for navigation

### Hierarchical Organization
When content exceeds 1000 lines or 50KB, break it into:
1. Index file providing navigation
2. Category files for logical groupings
3. Individual item files with focused content

## Using Templates

### For New Domain Categories
Use [`templates/category-index-template.md`](templates/category-index-template.md)

### For New Content Items
Use [`templates/item-template.md`](templates/item-template.md)

### For Code Location Indexes
Use [`templates/location-index-template.md`](templates/location-index-template.md)

### For Architecture Decisions
Use [`templates/decision-template.md`](templates/decision-template.md)

## Navigation

**Up:** [`../discovery.md`](../discovery.md) - Main context network navigation

**Related:**
- Review [`maintenance.md`](maintenance.md) before making structural changes
- Use templates in [`templates/`](templates/) for consistent formatting
- Track changes in [`updates/`](updates/)

## Context Network Statistics

Current status:
- **Sections:** 6 (foundation, domains, processes, decisions, planning, cross-domain)
- **Domains:** 5 (shells, faceplates, hardware, profiles, bosl2-integration)
- **Templates:** 4
- **Last Updated:** 2025-12-21

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Section Type:** Meta-documentation collection
