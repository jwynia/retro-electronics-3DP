# ADR-001: Using BOSL2's Attachment System Throughout

## Status
**Accepted** - Project inception

## Context

When building parametric OpenSCAD modules, positioning and orienting child shapes relative to parent shapes is a fundamental operation. There are two main approaches:

1. **Manual positioning** using `translate()`, `rotate()`, and manual coordinate calculations
2. **BOSL2's attachment system** using `attachable()`, `position()`, `attach()`, and anchor constants

The choice affects code maintainability, composability, and the learning curve for contributors.

## Decision

**All RetroCase modules use BOSL2's attachment system** rather than manual positioning.

This means:
- All reusable shapes use the `attachable()` wrapper
- Child positioning uses `position()` or `attach()` instead of `translate()`
- Boolean operations use `diff()` with `tag()` instead of raw `difference()`
- Anchor constants (`TOP`, `BOT`, `LEFT`, `RIGHT`, `FWD`, `BACK`) are used throughout

## Rationale

### Composability
Attachable modules can be freely combined. A faceplate can attach to any shell. Hardware can attach to any surface. This enables the modular design vision of RetroCase.

### Maintainability
Changes to parent dimensions automatically propagate correctly. No need to recalculate offsets when sizes change.

### Consistency
All modules follow the same patterns. Once a contributor learns the attachment system, they can understand and modify any module.

### BOSL2 is Required Anyway
We already depend on BOSL2 for its shape primitives (`cuboid`, `prismoid`, etc.) and rounding capabilities. Using the attachment system adds no additional dependency.

## Alternatives Considered

### Manual Positioning Throughout
- **Pro:** No BOSL2 learning curve for basic OpenSCAD users
- **Con:** Code becomes fragile and hard to maintain
- **Con:** Composability requires manual offset calculations
- **Rejected:** Maintenance burden outweighs familiarity benefit

### Hybrid Approach (Sometimes Manual, Sometimes Attached)
- **Pro:** Flexibility to use simpler approach when appropriate
- **Con:** Inconsistent codebase, harder to learn
- **Con:** Modules may not compose well if some aren't attachable
- **Rejected:** Consistency is more valuable than flexibility here

## Consequences

### Positive
- Modules compose naturally
- Code is self-documenting (anchor names are meaningful)
- Dimension changes are easier
- Consistent patterns throughout codebase

### Negative
- Contributors must learn BOSL2 attachment system
- More verbose for simple cases
- Some edge cases require understanding of anchor mechanics

### Mitigation
- Extensive BOSL2 documentation in `docs/bosl2/`
- Common patterns documented in context network
- Examples demonstrate correct usage
- Common mistakes documented with solutions

## Related Decisions
- [[002-magnetic-closure-design]] - Attachment points enable magnetic system
- [[003-module-organization]] - Module categories follow attachment patterns

## Navigation

**Up:** [`index.md`](index.md) - Decisions overview

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Category:** Architecture
- **Impact:** All modules
