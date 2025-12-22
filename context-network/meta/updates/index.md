# Context Network Updates

## Purpose
Tracking significant updates to the RetroCase context network.

## Classification
- **Domain:** Meta
- **Stability:** Dynamic (appended frequently)
- **Abstraction:** Historical record
- **Confidence:** Factual

## Recent Updates

### 2025-12-22: Knurling and Battery Libraries Added

**Scope:** Additional component libraries for knobs and battery compartments

**Added:**
- `lib/knurled-openscad/` - Knurled surface library (git submodule)
- `lib/battery_lib/` - Battery dimensions library (git submodule)
- `context-network/domains/external-libraries/knurled-openscad.md` - Integration guide
- `context-network/domains/external-libraries/battery-lib.md` - Integration guide

**Modified:**
- `.gitmodules` - Added two new submodules
- `scripts/setup.sh` - Verifies new libraries
- `README.md` - Updated dependencies list
- `context-network/domains/external-libraries/index.md` - Added library entries

**Libraries:**
- knurled-openscad: `https://github.com/smkent/knurled-openscad.git`
- battery_lib: `https://github.com/kartchnb/battery_lib.git`

**Use Cases:**
- Knurled knobs for potentiometers and controls
- Battery compartment design (AA, AAA, 18650, coin cells)

**Status:** Complete

---

### 2025-12-22: BOSL2 Converted to Git Submodule

**Scope:** Library dependency management

**Modified:**
- `.gitmodules` - Added BOSL2 as third submodule
- `scripts/setup.sh` - Updated to initialize and verify all three libraries
- `context-network/foundation/architecture.md` - Updated setup documentation

**All Libraries Now Submodules:**
- BOSL2: `https://github.com/BelfrySCAD/BOSL2.git`
- NopSCADlib: `https://github.com/nophead/NopSCADlib.git`
- PiHoles: `https://github.com/daprice/PiHoles.git`

**Benefit:** Repository is now self-contained. New clones get all dependencies via `git submodule update --init --recursive`

**Status:** Complete

---

### 2025-12-22: Aesthetic Verification Process Added

**Scope:** Design review and aesthetic verification processes

**Added:**
- `processes/aesthetic-verification.md` - Pattern-specific verification checklists
- `processes/design-review-process.md` - Complete design review workflow

**Modified:**
- `domains/design-language/parametric-patterns.md` - Added verification criteria tables to all patterns
- `processes/index.md` - Added new process entries

**Key Content:**
- Verification criteria tables for Braun Box, Olivetti Wedge, Space Age Sphere, Danish Slab
- Pattern-specific visual and dimensional checklists
- Three-phase review process: Technical → Aesthetic → Integration
- Quick review checklist for fast verification
- Review result recording format

**Status:** Complete

---

### 2025-12-22: Design Language Domain Added

**Scope:** Design reference documentation for retro electronics aesthetics

**Added:**
- `domains/design-language/index.md` - Domain overview with design philosophy
- `domains/design-language/designers.md` - Profiles of Dieter Rams, Mario Bellini, Jacob Jensen, etc.
- `domains/design-language/parametric-patterns.md` - Implementation patterns for shells, grilles, controls

**Modified:**
- `discovery.md` - Added design-language domain and "I need design inspiration" entry
- `domains/index.md` - Added design-language domain

**Key Content:**
- Designer profiles with signature styles and key products
- Iconic product catalog (Braun RT 20, Olivetti Divisumma 18, JVC Videosphere, etc.)
- Parametric patterns: Braun Box, Olivetti Wedge, Space Age Sphere, Danish Slab
- Grille patterns: horizontal slots, dot matrix, honeycomb
- Preset definitions for implementation targets

**Status:** Complete

---

### 2025-12-22: External Libraries Added

**Scope:** Added NopSCADlib and PiHoles as git submodules

**Added:**
- `lib/NopSCADlib/` - Hardware components library (git submodule)
- `lib/PiHoles/` - Raspberry Pi mounting library (git submodule)
- `domains/external-libraries/index.md` - Domain overview
- `domains/external-libraries/nopscadlib.md` - NopSCADlib integration guide
- `domains/external-libraries/piholes.md` - PiHoles integration guide

**Modified:**
- `foundation/architecture.md` - Updated library dependencies section
- `domains/index.md` - Added external-libraries domain
- `discovery.md` - Added external-libraries to navigation

**Libraries Installed:**
- NopSCADlib: PCB definitions (RPI0, RPI3, RPI4, Arduino, ESP32), connectors, hardware
- PiHoles: Lightweight Pi mounting hole positions and board dimensions

**Status:** Complete

---

### 2025-12-21: Research Tools Domain Added

**Scope:** New domain for research CLI tools

**Added:**
- `domains/research-tools/index.md` - Domain overview and quick decision guide
- `domains/research-tools/tavily-search.md` - Tavily web search documentation
- `domains/research-tools/kiwix-datasets.md` - Kiwix local datasets documentation
- `domains/research-tools/research-workflow.md` - Research workflow guidance

**Modified:**
- `discovery.md` - Added research-tools to navigation and domains list
- `domains/index.md` - Added research-tools domain entry

**Tools Documented:**
- Tavily CLI (`scripts/research/tavily-cli.ts`) - AI-optimized web search
- Kiwix CLI (`scripts/kiwix/`) - Local offline datasets (Wikipedia, Stack Overflow, DevDocs, etc.)

**Status:** Complete

---

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
