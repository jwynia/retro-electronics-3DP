# Code Review Checklist

## Purpose
Pre-commit verification checklist for RetroCase contributions.

## Classification
- **Domain:** Processes
- **Stability:** Stable
- **Abstraction:** Procedural
- **Confidence:** Established

## Before Every Commit

Run through this checklist before committing changes.

## 1. Code Correctness

### BOSL2 Usage
- [ ] Uses `diff()` with `tag("remove")` (not raw `difference()`)
- [ ] Uses `position()` or `attach()` (not raw `translate()`)
- [ ] Edge specifications are correct (`TOP`, `"Z"`, etc.)
- [ ] Anchor constants spelled correctly
- [ ] No dot notation for array access (use `pos[0]` not `pos.x`)

### Module Structure
- [ ] Attachable modules use `attachable()` wrapper
- [ ] Attachable modules call `children()` at end
- [ ] Parameters have sensible defaults
- [ ] Parameter names follow conventions

### Geometry
- [ ] Wall thickness is consistent
- [ ] Rounding radii don't exceed half of dimensions
- [ ] No negative dimensions or impossible geometry
- [ ] Boolean operations produce valid (manifold) geometry

## 2. Render Verification

- [ ] Ran `./scripts/render.sh` on changed files
- [ ] Checked PNG output visually
- [ ] No BOSL2 warnings in console
- [ ] No BOSL2 errors in console
- [ ] Geometry matches intent

## 3. Documentation

### Header Comments
- [ ] Module has doc comment with description
- [ ] All parameters documented
- [ ] Parameter types and defaults noted
- [ ] Example usage included (optional but recommended)

### Context Network
- [ ] Updated location index if new code
- [ ] Created pattern documentation if new pattern
- [ ] Updated relevant domain documents
- [ ] Linked from related documents

## 4. Testing

- [ ] Preview code exists (`if ($preview) { ... }`)
- [ ] Example file created/updated in `examples/`
- [ ] Example demonstrates typical usage
- [ ] Example renders successfully

## 5. Naming and Organization

- [ ] File in correct directory
- [ ] File name is descriptive
- [ ] Module name follows pattern (`shell_`, `faceplate_`, etc.)
- [ ] Parameter names follow conventions
- [ ] Constants use `_UPPERCASE` with underscore prefix

## 6. No Regressions

- [ ] Existing examples still render
- [ ] No changes to public API without reason
- [ ] Existing modules still work

## Quick Check Commands

```bash
# Render all examples to verify nothing broke
./scripts/render.sh --all

# Check for common mistakes with grep
grep -r "difference()" modules/  # Should be empty (use diff())
grep -r "translate(\[" modules/  # Review each usage

# Render specific changed file
./scripts/render.sh modules/shells/my-new-shell.scad
```

## Review Questions

Ask yourself:

1. **Would a new contributor understand this code?**
   - Clear parameter names?
   - Adequate comments?
   - Follows established patterns?

2. **Does it work with the rest of RetroCase?**
   - Uses standard conventions?
   - Attachable for composability?
   - Matches existing style?

3. **Is it necessary?**
   - Doesn't duplicate existing functionality?
   - Adds real value?
   - Not over-engineered?

## Common Issues to Catch

| Issue | How to Check |
|-------|--------------|
| Missing `tag("remove")` | Geometry doesn't subtract |
| Wrong edge spec | Rounding in wrong places |
| Missing `children()` | Attachment doesn't work |
| Wrong anchor | Geometry in wrong position |
| Hardcoded values | Should be parameters |

## Navigation

**Up:** [`index.md`](index.md) - Processes overview

**Related:**
- [`development-workflow.md`](development-workflow.md) - Full workflow
- [`../domains/bosl2-integration/common-mistakes.md`](../domains/bosl2-integration/common-mistakes.md) - What to avoid
- [`../cross-domain/parameter-conventions.md`](../cross-domain/parameter-conventions.md) - Naming rules

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Process Documentation - Checklist
