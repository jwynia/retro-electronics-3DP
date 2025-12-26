# RetroCase Context Network - Navigation Guide

## Welcome

This is the main navigation hub for the RetroCase context network. The context network contains all planning, architecture, design decisions, and coordination information for the RetroCase parametric OpenSCAD library project.

## Quick Navigation by Purpose

### I want to understand the project
→ Start at [`foundation/project-definition.md`](foundation/project-definition.md)

### I'm about to write code
→ Read [`foundation/development-principles.md`](foundation/development-principles.md) first

### I need BOSL2 help
→ See [`domains/bosl2-integration/index.md`](domains/bosl2-integration/index.md)

### I'm creating a new module
→ Follow [`processes/module-creation.md`](processes/module-creation.md)

### I need to look something up
→ See [`domains/research-tools/index.md`](domains/research-tools/index.md)

### I need design inspiration
→ See [`domains/design-language/index.md`](domains/design-language/index.md)

### I want to know where code lives
→ Check location indexes in each domain (e.g., [`domains/shells/locations.md`](domains/shells/locations.md))

### I need to understand an architectural decision
→ Browse [`decisions/index.md`](decisions/index.md)

### I'm planning new features
→ See [`planning/module-roadmap.md`](planning/module-roadmap.md)

## Context Network Structure

### Foundation - Core Project Knowledge
[`foundation/index.md`](foundation/index.md)

Essential understanding of what RetroCase is, how it's architected, and fundamental development principles.

**Key documents:**
- [`project-definition.md`](foundation/project-definition.md) - What is RetroCase?
- [`architecture.md`](foundation/architecture.md) - How is it structured?
- [`development-principles.md`](foundation/development-principles.md) - How do we work?

### Domains - Specialized Knowledge Areas
[`domains/index.md`](domains/index.md)

Deep knowledge organized by technical domain.

**Available domains:**
- [`shells/`](domains/shells/index.md) - Shell generation patterns and techniques
- [`faceplates/`](domains/faceplates/index.md) - Face plate designs and mounting
- [`hardware/`](domains/hardware/index.md) - Magnetic attachment, standoffs, mounting
- [`profiles/`](domains/profiles/index.md) - 2D profile generation
- [`bosl2-integration/`](domains/bosl2-integration/index.md) - BOSL2 library usage patterns
- [`gridfinity/`](domains/gridfinity/overview.md) - Gridfinity modular storage integration
- [`research-tools/`](domains/research-tools/index.md) - Web search and local dataset tools
- [`external-libraries/`](domains/external-libraries/index.md) - NopSCADlib, PiHoles integration
- [`design-language/`](domains/design-language/index.md) - Retro design references and patterns

### Processes - How We Work
[`processes/index.md`](processes/index.md)

Documented workflows and procedures for development.

**Key processes:**
- [`development-workflow.md`](processes/development-workflow.md) - Read → Write → Render → Verify
- [`module-creation.md`](processes/module-creation.md) - Creating new modules
- [`testing-rendering.md`](processes/testing-rendering.md) - Testing and rendering

### Decisions - Why We Made These Choices
[`decisions/index.md`](decisions/index.md)

Architecture Decision Records (ADRs) documenting key choices and their rationale.

### Planning - Where We're Going
[`planning/index.md`](planning/index.md)

Roadmaps, planned features, and future directions.

### Cross-Domain - Connections and Standards
[`cross-domain/index.md`](cross-domain/index.md)

Standards and conventions that apply across multiple domains.

### Meta - About This Context Network
[`meta/index.md`](meta/index.md)

Information about the context network itself, including templates and maintenance procedures.

## Navigation Patterns

### For Learning (Top-Down)
1. Start with [`foundation/project-definition.md`](foundation/project-definition.md)
2. Read [`foundation/architecture.md`](foundation/architecture.md)
3. Explore specific domains of interest
4. Read decision records to understand rationale

### For Implementing (Task-Based)
1. Read [`foundation/development-principles.md`](foundation/development-principles.md)
2. Check relevant domain's `locations.md` for existing code
3. Review related decision records
4. Follow process documentation for your task

### For Problem-Solving
1. Check domain-specific documentation
2. Review related decision records for context
3. Consult process documentation for workflows
4. Check location indexes to find relevant code

## How to Use Location Indexes

Every domain contains a `locations.md` file that maps concepts to actual code files:

```
## [Concept Name]
- **What**: Brief explanation
- **Where**: `path/to/file.scad:line-range`
- **Related**: [[other-concepts]]
```

This helps you quickly find the implementation of any concept.

## Maintenance

When working on this project:
- **Update the context network** as you discover new information
- **Create discovery records** when you find important code patterns
- **Link extensively** between related documents
- **Follow the 3-line rule**: If you read >3 lines to understand something, record it

See [`meta/maintenance.md`](meta/maintenance.md) for details.

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Purpose:** Main navigation hub for RetroCase context network
