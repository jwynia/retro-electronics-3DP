# Module Roadmap

## Purpose
Planned modules and development priorities for RetroCase.

## Classification
- **Domain:** Planning
- **Stability:** Dynamic (updated frequently)
- **Abstraction:** Strategic
- **Confidence:** Evolving

## Current Status

### Implemented
| Module | Location | Status |
|--------|----------|--------|
| `shell_monolithic()` | `modules/shells/monolithic.scad` | Complete |
| `faceplate_bezel()` | `modules/faces/bezel.scad` | Complete |
| `faceplate_blank()` | `modules/faces/bezel.scad` | Complete |
| `profile_rounded_rect()` | `modules/profiles/basic.scad` | Complete |
| `profile_wedge()` | `modules/profiles/basic.scad` | Complete |
| `path_rounded_rect()` | `modules/profiles/basic.scad` | Complete |

### Partially Implemented
| Module | Location | Status |
|--------|----------|--------|
| Steel disc pockets | Inline in faceplates | Working, not standalone |

## Priority 1: Core Shells

### shell_wedge()
**Purpose:** Tapered shell with raked front face
**Why:** Classic retro electronics shape (Braun RT 20 style)
**Approach:** Use prismoid() or swept profile
**Dependencies:** None

### shell_split()
**Purpose:** Two-piece shell with seam
**Why:** Easier access to internals, better print orientation
**Approach:** Generate matching top/bottom halves
**Dependencies:** shell_monolithic() patterns

## Priority 2: Hardware

### magnet_pocket()
**Purpose:** Standalone magnet pocket generator
**Why:** Currently inline in faceplates; needs to be reusable
**Approach:** Simple attachable cylinder subtraction
**Dependencies:** None

### standoff()
**Purpose:** PCB mounting standoff
**Why:** Essential for mounting electronics
**Approach:** Hollow cylinder with screw hole
**Dependencies:** None

### heatset_boss()
**Purpose:** Heat-set insert mounting post
**Why:** Stronger threads for repeated assembly
**Approach:** Cylinder with correctly-sized hole
**Dependencies:** None

## Priority 3: Faceplates

### faceplate_grille()
**Purpose:** Speaker grille patterns
**Why:** Audio builds need speaker openings
**Approach:** Parametric hole patterns (grid, hex, slots)
**Dependencies:** None

### faceplate_controls()
**Purpose:** Control panel with standard hole patterns
**Why:** Knob/switch builds need positioned holes
**Approach:** Accept positions array, generate appropriate holes
**Dependencies:** None

## Priority 4: Profiles

### profile_compound()
**Purpose:** Multi-segment profile for complex sweeps
**Why:** Organic curves need more than basic shapes
**Approach:** Bezier or multi-arc construction
**Dependencies:** BOSL2 bezier functions

### profile_stepped()
**Purpose:** Profile with steps/ledges
**Why:** Internal mounting features
**Approach:** Polygon with calculated steps
**Dependencies:** None

## Priority 5: Advanced Shells

### shell_sleeve()
**Purpose:** Open-ended U-channel
**Why:** Braun-style design with separate front/back
**Approach:** Hollow prism without front/back faces
**Dependencies:** shell_monolithic() patterns

### shell_compound()
**Purpose:** Organic curves with different profiles
**Why:** 1970s flip clock aesthetic
**Approach:** offset_sweep() with complex paths
**Dependencies:** profile_compound()

## Research Needed

### Board-Specific Mounting
**Question:** How to integrate NopSCADlib/PiHoles?
**Approach:** Research library APIs, create adapter modules
**Blocker:** None, just needs investigation

### Ventilation Patterns
**Question:** Standard vent hole patterns?
**Approach:** Research thermal requirements, create parametric vents
**Blocker:** None

### Multi-Material Design
**Question:** How to handle two-color prints?
**Approach:** Generate separate bodies, document print process
**Blocker:** OpenSCAD workflow for multi-body

## Not Planned

These are explicitly out of scope:
- Product-specific complete designs (use presets instead)
- Non-retro aesthetics
- Injection molding optimization
- Metal fabrication patterns

## How to Propose New Modules

1. Create issue or discussion describing the module
2. Explain use case and target aesthetic
3. Identify dependencies and complexity
4. Get feedback before implementing

## Navigation

**Up:** [`index.md`](index.md) - Planning overview

**Related:**
- [`preset-catalog.md`](preset-catalog.md) - Complete designs using modules
- [`hardware-targets.md`](hardware-targets.md) - Hardware that needs mounting
- [`../domains/`](../domains/index.md) - Current implementations

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Roadmap
