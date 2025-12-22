# Context Network Updates

## Purpose
Tracking significant updates to the RetroCase context network.

## Classification
- **Domain:** Meta
- **Stability:** Dynamic (appended frequently)
- **Abstraction:** Historical record
- **Confidence:** Factual

## Recent Updates

### 2025-12-21: BOSL2 Lessons from Example Rendering

**Scope:** BOSL2 integration documentation

**Modified:**
- `domains/bosl2-integration/common-mistakes.md` - Added two new common mistakes:
  - Rounding radius larger than dimension (causes assertion errors)
  - diff() preview artifacts with overlapping remove volumes
- `domains/bosl2-integration/diff-tagging.md` - Added "Known Limitation" section about preview artifacts

**Fixed:**
- `examples/03-hollow-shell-with-lip.scad` - Added `edges="Z"` to fix rounding > dimension error
- `examples/04-shell-with-cutout.scad` - Rewrote to use `difference()` instead of `diff()` to avoid preview artifacts

**Key Lessons:**
1. Always check `rounding <= smallest_affected_dimension`
2. Use `edges="Z"` when rounding shapes that will have boolean ops on non-vertical faces
3. Prefer `difference()` over `diff()` for complex boolean operations with overlapping removes

**Status:** Complete

---

### 2025-12-21: Initial Context Network Creation

**Scope:** Complete network setup

**Added:**
- `.context-network.md` discovery file
- `context-network/discovery.md` main navigation
- Foundation section (project-definition, architecture, development-principles)
- Domains section (shells, faceplates, hardware, profiles, bosl2-integration)
- Processes section (development-workflow, testing-rendering, module-creation, code-review-checklist)
- Decisions section (4 ADRs: BOSL2 attachment, magnetic closure, module organization, design language)
- Planning section (module-roadmap, preset-catalog, hardware-targets)
- Cross-domain section (parameter-conventions, module-dependencies, interface-contracts)
- Meta section (maintenance, templates, this updates log)

**Migrated from:**
- CLAUDE.md (now minimal pointer)
- README.md (design philosophy content)

**Status:** Complete initial setup

---

## Update Log Format

When adding updates, use this format:

```markdown
### YYYY-MM-DD: [Brief Title]

**Scope:** [What areas were affected]

**Added:**
- [New documents created]

**Modified:**
- [Existing documents changed]

**Removed:**
- [Documents deleted or archived]

**Reason:** [Why this update was made]

**Status:** [Complete | In Progress | Reverted]

---
```

## Major Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.0 | 2025-12-21 | Initial context network creation |

## Navigation

**Up:** [`../index.md`](../index.md) - Meta overview

**Related:**
- [`../maintenance.md`](../maintenance.md) - When to update

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Update Log
