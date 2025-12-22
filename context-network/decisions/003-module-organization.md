# ADR-003: Module Organization by Function

## Status
**Accepted** - Project inception

## Context

OpenSCAD libraries can be organized in several ways:
1. **By function** - profiles/, shells/, faces/, hardware/
2. **By product** - flip-clock/, radio/, tablet-stand/
3. **By complexity** - basic/, advanced/, experimental/
4. **Flat structure** - all modules in one directory

The organization affects discoverability, reusability, and maintenance.

## Decision

**Organize modules by function**, not by product or use case.

Directory structure:
```
modules/
├── profiles/    # 2D cross-section generators
├── shells/      # 3D hollow enclosures
├── faces/       # Face plate generators
└── hardware/    # Mounting, pockets, standoffs
```

## Rationale

### Maximizes Reusability
A shell designed for a "flip clock" might work perfectly for a "radio." By organizing by function, users naturally discover reusable components.

### Clear Responsibilities
Each directory has a clear purpose:
- `profiles/` → 2D shapes
- `shells/` → 3D enclosures
- `faces/` → front panels
- `hardware/` → mounting features

### Matches Mental Model
Users think "I need a shell" or "I need a faceplate," not "I need a flip-clock-style thing." Function-based organization matches this.

### Reduces Duplication
Product-based organization leads to similar code in multiple places (each product has its own shell, face, etc.). Function-based organization centralizes patterns.

### Scales Better
Adding a new product means combining existing modules. Adding a new function means one new directory, not one new module per product.

## Alternatives Considered

### By Product
```
modules/
├── flip-clock/
├── radio/
├── tablet-stand/
```
- **Pro:** Easier to find "complete" designs
- **Con:** Similar code duplicated across products
- **Con:** Hard to mix-and-match components
- **Rejected:** Limits composability

### By Complexity
```
modules/
├── basic/
├── intermediate/
├── advanced/
```
- **Pro:** Progressive learning path
- **Con:** Subjective boundaries (what's "basic"?)
- **Con:** Doesn't help find specific functionality
- **Rejected:** Not useful for finding components

### Flat Structure
```
modules/
├── shell-monolithic.scad
├── shell-wedge.scad
├── faceplate-bezel.scad
...
```
- **Pro:** Everything in one place
- **Con:** Becomes unwieldy as library grows
- **Con:** No logical grouping
- **Rejected:** Doesn't scale

## Consequences

### Positive
- Clear, intuitive organization
- Modules are naturally reusable
- Easy to find functionality
- Scales as library grows

### Negative
- Complete "products" aren't in one place
- Users must understand composition model
- May be less intuitive for beginners expecting products

### Mitigation
- `presets/` directory contains complete, ready-to-use designs
- Examples show how to combine modules
- Documentation explains the composition model

## Related Decisions
- [[001-bosl2-attachment-system]] - Modules compose via attachments
- [[004-design-language-constraints]] - All modules share aesthetic

## Navigation

**Up:** [`index.md`](index.md) - Decisions overview

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Category:** Architecture
- **Impact:** Directory structure, documentation, user experience
