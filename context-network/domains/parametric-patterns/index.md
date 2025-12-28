# Parametric OpenSCAD Patterns

## Purpose

Comprehensive reference of parametric design patterns extracted from production-quality OpenSCAD generators. Serves as both learning resource and practical pattern library for building parametric 3D models.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Semi-stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

This domain documents reusable patterns for parametric OpenSCAD design, extracted from real-world generators. Patterns are organized by category and include code snippets with source attribution.

## Pattern Categories

| Category | Document | Description |
|----------|----------|-------------|
| Customizer UI | [`customizer-ui.md`](customizer-ui.md) | Variable organization, widgets, validation, resolution presets |
| Advanced BOSL2 | [`bosl2-advanced.md`](bosl2-advanced.md) | grid_copies, path functions, sweep, regions |
| FDM Optimization | [`fdm-optimization.md`](fdm-optimization.md) | Teardrops, print orientation, rod splitting, tolerances |
| Parametric Architecture | [`parametric-architecture.md`](parametric-architecture.md) | Type dispatch, computed values, position arrays |
| Mechanical Joints | [`mechanical-joints.md`](mechanical-joints.md) | Threading, dovetails, snap-fits, hinges |
| Pattern Generation | [`pattern-generation.md`](pattern-generation.md) | Grids, textures, honeycomb, slats, mesh |
| External Sources | [`external-sources.md`](external-sources.md) | YAPP, Gridfinity Extended, Lighthouse patterns |

## Source Files

Patterns extracted from these inbox files:

| File | Key Patterns |
|------|--------------|
| `bracket-generator.scad` | Type dispatch, FDM optimization, screw holes |
| `cirkit-pods.scad` | Threading, textures, Customizer organization |
| `connector-generator.scad` | Position arrays, polymorphic shapes |
| `drawer-divider.scad` | Dovetails, honeycomb, print-size splitting |
| `grid-generator.scad` | 2D shape functions, grid_copies |
| `gridfinity-bins.scad` | Profile sweeps, height calculations |
| `grille-generator.scad` | Path-based holes, slat calculations |
| `jar-generator.scad` | Texture arrays, color libraries |
| `thread-generator.scad` | Thread types, rod splitting |

## Quick Reference

### When to Use Each Pattern

| Need | Pattern Category |
|------|-----------------|
| User-adjustable parameters | [Customizer UI](customizer-ui.md) |
| Distributing elements in grids | [BOSL2 Advanced](bosl2-advanced.md) |
| Print-friendly holes/overhangs | [FDM Optimization](fdm-optimization.md) |
| Multiple variants from one file | [Parametric Architecture](parametric-architecture.md) |
| Connecting parts together | [Mechanical Joints](mechanical-joints.md) |
| Decorative/functional textures | [Pattern Generation](pattern-generation.md) |

## Navigation

**Up:** [`../index.md`](../index.md) - All domains

**Related:**
- [`../bosl2-integration/`](../bosl2-integration/) - Core BOSL2 patterns
- [`../design-language/`](../design-language/) - Visual design patterns
- [`../../cross-domain/parameter-conventions.md`](../../cross-domain/parameter-conventions.md) - Naming standards

## Code Location Index

See [`locations.md`](locations.md) for mappings from pattern names to source file line numbers.

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Reference
