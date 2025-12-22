# Architecture - How RetroCase is Structured

## Purpose
This document describes the technical architecture of RetroCase: how the codebase is organized, how modules interact, and how BOSL2 integration works.

## Classification
- **Domain:** Technical architecture
- **Stability:** Semi-stable (evolves with major changes)
- **Abstraction:** Structural
- **Confidence:** Established

## Environment Requirements

### Required Software
- **OpenSCAD 2021.x or later** - The rendering engine
- **BOSL2 library** - Included as git submodule in `lib/BOSL2/`

### Setup
```bash
./scripts/setup.sh
```

This script:
1. Checks for OpenSCAD installation
2. Initializes the BOSL2 submodule
3. Creates required directories
4. Runs a test render

## Directory Structure

```
retrocase/
├── CLAUDE.md              # Agent workflow guide (minimal)
├── AGENTS.md              # Matches CLAUDE.md
├── README.md              # User-facing documentation
├── .context-network.md    # Context network discovery
├── context-network/       # All planning/architecture docs
├── lib/
│   └── BOSL2/             # BOSL2 library (git submodule)
├── scripts/
│   ├── setup.sh           # Environment setup
│   └── render.sh          # Render test script
├── docs/
│   └── bosl2/             # BOSL2 API excerpts
├── examples/              # Known-working complete examples
├── modules/               # Reusable modules (the library)
│   ├── profiles/          # 2D cross-section generators
│   ├── shells/            # 3D shell generators
│   ├── faces/             # Face plate generators
│   └── hardware/          # Mounting, pockets, standoffs
├── presets/               # Pre-configured complete designs
├── reference/             # Design inspiration images
└── test-renders/          # Output from render script
```

## Module Organization

Modules are organized by function, not by use case or product:

### `modules/profiles/` - 2D Generators
Generate 2D cross-sections for sweep operations.

**Naming:** `profile_<name>()`, `path_<name>()`

**Examples:**
- `profile_rounded_rect()` - Rounded rectangle
- `profile_wedge()` - Trapezoidal cross-section
- `path_rounded_rect()` - Path for offset_sweep

### `modules/shells/` - 3D Shell Generators
Generate hollow 3D enclosures.

**Naming:** `shell_<type>()`

**Examples:**
- `shell_monolithic()` - Single-piece hollow shell

### `modules/faces/` - Face Plate Generators
Generate front panels that attach to shells.

**Naming:** `faceplate_<type>()`

**Examples:**
- `faceplate_bezel()` - Screen bezel
- `faceplate_blank()` - Control panel

### `modules/hardware/` - Hardware Components
Generate mounting features and hardware pockets.

**Naming:** `magnet_pocket()`, `standoff()`, etc.

**Examples:**
- Magnet pockets
- Steel disc pockets
- PCB standoffs

## BOSL2 Integration Strategy

All RetroCase modules are built on BOSL2. This provides:

### Consistent Anchoring
Every shape has anchor points. `TOP`, `BOT`, `LEFT`, `RIGHT`, `FWD`, `BACK`.

### Attachment System
Children attach to parents using `position()` and `attach()`.

### Tag-Based Booleans
Use `diff()` with `tag("remove")` instead of raw `difference()`.

### Attachable Modules
All major modules use `attachable()` to expose anchor points.

See [`../domains/bosl2-integration/`](../domains/bosl2-integration/index.md) for detailed patterns.

## External Library Dependencies

### Required
- **BOSL2** - Core dependency, included as submodule

### Optional
- **NopSCADlib** - PCB definitions (Pi, Arduino, ESP32)
- **SBC_Case_Builder** - Board mounting patterns
- **PiHoles** - Raspberry Pi mounting hole positions

Core shell/face generation works without optional dependencies.

## Build and Render Infrastructure

### `scripts/render.sh`
Renders OpenSCAD files to PNG for verification.

**Usage:**
```bash
# Single file
./scripts/render.sh examples/01-basic-rounded-box.scad

# With camera preset
./scripts/render.sh examples/01-basic-rounded-box.scad front

# All examples
./scripts/render.sh --all
```

**Camera presets:** `default`, `front`, `top`, `iso`, `right`, `back`

### `scripts/setup.sh`
Environment initialization script.

## Module Interface Contracts

### Shell ↔ Faceplate Interface
- Shells expose an `opening` with a `lip_rebate`
- Faceplates fit into the lip rebate
- Dimensions: faceplate = opening + (lip_width × 2)

### Hardware ↔ Shell/Faceplate Interface
- Magnet pockets in faceplates
- Steel disc pockets in shell lips
- Aligned at `mounting_inset` from corners

See [`../cross-domain/interface-contracts.md`](../cross-domain/interface-contracts.md) for details.

## Navigation

**Up:** [`index.md`](index.md) - Foundation overview

**Related:**
- [`project-definition.md`](project-definition.md) - What RetroCase is
- [`development-principles.md`](development-principles.md) - How we develop
- [`../domains/`](../domains/index.md) - Domain-specific details
- [`../cross-domain/`](../cross-domain/index.md) - Interface contracts and conventions

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Foundation - Architecture
