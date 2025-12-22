# Processes - Development Workflows

## Purpose
This section documents the workflows, procedures, and processes used when developing RetroCase. These are the "how-to" guides for common development tasks.

## Classification
- **Domain:** Process and workflow documentation
- **Stability:** Semi-stable (evolves with tooling)
- **Abstraction:** Procedural and practical
- **Confidence:** Established

## Available Processes

### [`development-workflow.md`](development-workflow.md)
**The Core Development Cycle**

The fundamental Read → Write → Render → Verify workflow that underpins all RetroCase development.

**When to use:** Before writing any code, review this workflow

**Key topics:**
- Reading BOSL2 docs before coding
- Writing code with proper patterns
- Rendering and verifying output
- Debugging render failures

### [`module-creation.md`](module-creation.md)
**Creating New Modules**

Step-by-step process for creating new reusable modules in RetroCase.

**When to use:** Before creating any new `.scad` module file

**Key topics:**
- Module naming conventions
- Parameter design
- Documentation requirements
- Integration with examples

### [`testing-rendering.md`](testing-rendering.md)
**Testing and Rendering**

How to use the `render.sh` script, interpret output, and validate designs.

**When to use:** When testing changes or creating production renders

**Key topics:**
- Using `render.sh` with different presets
- Camera angle selection
- Output interpretation
- STL export procedures

### [`code-review-checklist.md`](code-review-checklist.md)
**Pre-Commit Verification**

Checklist to run through before committing changes.

**When to use:** Before every git commit

**Key topics:**
- Code correctness verification
- Documentation completeness
- Test coverage
- Context network updates

## Process Usage Patterns

### For New Contributors
1. Read [`development-workflow.md`](development-workflow.md) completely
2. Skim [`module-creation.md`](module-creation.md) for structure
3. Keep [`code-review-checklist.md`](code-review-checklist.md) handy

### For Specific Tasks
- **Creating a new shell:** → [`module-creation.md`](module-creation.md) + [`../domains/shells/`](../domains/shells/index.md)
- **Testing changes:** → [`testing-rendering.md`](testing-rendering.md)
- **Debugging render issues:** → [`development-workflow.md#debugging`](development-workflow.md)

### For Code Review
1. Use [`code-review-checklist.md`](code-review-checklist.md)
2. Verify adherence to [`development-workflow.md`](development-workflow.md)
3. Check context network has been updated

## Relationship to Foundation

**Foundation** documents explain *what* and *why*.
**Processes** documents explain *how*.

For example:
- **Foundation:** "We use BOSL2's attachment system" (what/why)
- **Processes:** "Here's how to use `position()` and `attach()` correctly" (how)

## Navigation

**Up:** [`../discovery.md`](../discovery.md) - Main context network navigation

**Related Sections:**
- [`../foundation/development-principles.md`](../foundation/development-principles.md) - Core principles behind these processes
- [`../domains/`](../domains/index.md) - Domain-specific technical details
- [`../cross-domain/`](../cross-domain/index.md) - Standards and conventions

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Section Type:** Process documentation collection
