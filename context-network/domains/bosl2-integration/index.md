# BOSL2 Integration Domain

## Purpose
This domain covers how RetroCase uses the BOSL2 library - the essential patterns, idioms, common mistakes, and best practices. **This is required reading before writing any OpenSCAD code.**

## Classification
- **Domain:** Library Integration
- **Stability:** Core (fundamental to all code)
- **Abstraction:** Patterns and guidelines
- **Confidence:** Established

## Documents

### [`attachment-system.md`](attachment-system.md)
**How We Use BOSL2 Attachments**

The attachment system is central to RetroCase. This document explains how we use `attachable()`, `position()`, `attach()`, and anchoring.

**Key topics:**
- Anchor constants (TOP, BOT, LEFT, RIGHT, FWD, BACK)
- Using `position()` for relative placement
- Using `attach()` for surface attachment
- Creating attachable modules

### [`diff-tagging.md`](diff-tagging.md)
**Geometric Operations with diff() and tag()**

How we use BOSL2's tag-based boolean operations instead of raw `difference()`.

**Key topics:**
- `diff()` wrapper usage
- `tag("remove")` for subtraction
- `tag("keep")` for preservation
- Multi-level nesting patterns

### [`common-mistakes.md`](common-mistakes.md)
**Pitfalls and Solutions**

A catalog of common BOSL2 mistakes and how to avoid them.

**Key topics:**
- Array access (no dot notation in OpenSCAD)
- Edge specifications
- Parameter misuse
- Rounding conflicts

### [`idioms.md`](idioms.md)
**BOSL2 Idioms This Project Uses**

Standard patterns we use throughout RetroCase.

**Key topics:**
- Hollowing pattern
- Positioning children pattern
- Subtracting attached shapes pattern
- Creating new attachables pattern

### [`boolean-operations.md`](boolean-operations.md)
**Preventing Z-Fighting in Boolean Operations**

Critical patterns for avoiding coincident surface artifacts when using `difference()` or `diff()/tag()`.

**Key topics:**
- The epsilon extension rule (0.01mm)
- Cavity patterns for shells
- Through-hole patterns
- Verification techniques

### [`locations.md`](locations.md)
**Code Location Index**

Maps BOSL2 concepts to actual usage in project files.

## Critical Knowledge

### BOSL2 is Required
All RetroCase modules depend on BOSL2. The library is included as a git submodule at `lib/BOSL2/`.

### Read Before Coding
Before writing any OpenSCAD module, read:
1. The relevant BOSL2 docs in `docs/bosl2/`
2. [`common-mistakes.md`](common-mistakes.md) in this domain
3. Similar examples in `examples/`

### Key BOSL2 Functions We Use
| Function | Purpose |
|----------|---------|
| `cuboid()` | Rounded box with anchoring |
| `prismoid()` | Tapered box with anchoring |
| `cyl()` | Cylinder with anchoring |
| `diff()` | Tag-based boolean difference |
| `position()` | Relative child positioning |
| `attach()` | Surface-aligned attachment |
| `offset_sweep()` | Profile-based extrusion |

## Quick Reference

### Anchor Constants
```
TOP, BOT (or BOTTOM)
LEFT, RIGHT
FWD (or FRONT), BACK
CENTER (default)
```

### Edge Specifications
```
edges = TOP         // All top edges
edges = "Z"         // All vertical edges
edges = TOP+RIGHT   // Single edge
edges = [TOP, BOT]  // Multiple edges
```

### Common Pattern
```openscad
diff()
cuboid([100, 80, 60], rounding=8, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([94, 74, 60], rounding=5, anchor=TOP);
}
```

## Navigation

**Up:** [`../index.md`](../index.md) - Domains overview

**Related:**
- [`../../docs/bosl2/`](../../docs/bosl2/) - BOSL2 API excerpts
- [`../../foundation/development-principles.md`](../../foundation/development-principles.md) - Development workflow
- [`../../decisions/001-bosl2-attachment-system.md`](../../decisions/001-bosl2-attachment-system.md) - Why attachable everywhere

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Domain Type:** Core integration domain
