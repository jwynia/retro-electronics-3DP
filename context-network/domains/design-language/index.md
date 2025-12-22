# Design Language Domain

## Purpose
Reference documentation for the retro electronics design influences that inform RetroCase aesthetics. This includes specific designers, iconic products, and parametric patterns derived from them.

## Classification
- **Domain:** Design Language
- **Stability:** Stable (historical reference)
- **Abstraction:** Conceptual to practical
- **Confidence:** Established

## Design Philosophy

RetroCase draws from three primary aesthetic movements:

1. **German Functionalism** (Braun/Rams) - "Less but better"
2. **Italian Sculptural** (Olivetti/Bellini) - Expressive, wedge forms
3. **Space Age** (JVC/Weltron) - Spherical, futuristic

## Key Designers

| Designer | Company | Era | Signature Style |
|----------|---------|-----|-----------------|
| Dieter Rams | Braun | 1960s-90s | Minimal, grid-based, functional |
| Mario Bellini | Olivetti | 1960s-80s | Wedge shapes, sculptural forms |
| Ettore Sottsass | Olivetti | 1960s-80s | Bold color, playful geometry |
| Jacob Jensen | Bang & Olufsen | 1960s-90s | Linear, sleek Danish modern |
| Gino Valle | Solari Udine | 1960s | Flip mechanisms, clear displays |

→ [`designers.md`](designers.md)

## Iconic Products (Parametric Targets)

### Rectangular/Box Forms
| Product | Designer | Year | Key Features |
|---------|----------|------|--------------|
| Braun RT 20 | Dieter Rams | 1961 | Front grille, offset controls, wood/metal |
| Braun SK 4 | Rams/Gugelot | 1956 | Flat, transparent lid, "Snow White's Coffin" |
| Braun T 1000 | Dieter Rams | 1963 | Large dial, modular feel |

### Wedge Forms
| Product | Designer | Year | Key Features |
|---------|----------|------|--------------|
| Olivetti Divisumma 18 | Mario Bellini | 1973 | Rubber skin, wedge profile |
| Olivetti Logos 55 | Mario Bellini | 1960s | Dramatic wedge, integrated display |

### Spherical/Space Age
| Product | Company | Year | Key Features |
|---------|---------|------|--------------|
| JVC Videosphere | JVC | 1970 | Helmet shape, chain mount |
| Weltron 2001 | Weltron | 1970 | Ball form, integrated 8-track |
| Panasonic Panapet R-70 | Panasonic | 1970s | Ball radio, chain |

### Flip Clock Forms
| Product | Designer | Year | Key Features |
|---------|----------|------|--------------|
| Solari Cifra 3 | Gino Valle | 1966 | Split-flap display, minimal frame |
| Copal flip clocks | Various | 1970s | Integrated radio, rectangular |

→ [`iconic-products.md`](iconic-products.md)

## Parametric Pattern Library

Design patterns extracted from iconic products, ready for parametric implementation:

### Shell Profiles
| Pattern | Source | Parameters |
|---------|--------|------------|
| `profile_box` | Braun RT 20 | corner_radius, height, width |
| `profile_wedge` | Olivetti Divisumma | rake_angle, front_height, back_height |
| `profile_curved` | Space Age | curve_radius, bulge_amount |

### Grille Patterns
| Pattern | Source | Parameters |
|---------|--------|------------|
| `grille_slots` | Braun | slot_width, slot_spacing, rows |
| `grille_dots` | B&O | hole_diameter, grid_spacing |
| `grille_hex` | Various | hex_size, wall_thickness |

### Control Layouts
| Pattern | Source | Parameters |
|---------|--------|------------|
| `controls_offset` | Braun RT 20 | offset from center, grouping |
| `controls_centered` | Olivetti | symmetric, centered |
| `controls_side` | B&O | edge-aligned |

→ [`parametric-patterns.md`](parametric-patterns.md)

## Documents in This Domain

| Document | Purpose |
|----------|---------|
| [`designers.md`](designers.md) | Detailed designer profiles and principles |
| [`iconic-products.md`](iconic-products.md) | Product catalog with dimensions |
| [`parametric-patterns.md`](parametric-patterns.md) | Patterns for implementation |

## Navigation

**Up:** [`../index.md`](../index.md) - All domains

**Related:**
- [`../shells/`](../shells/index.md) - Shell implementation
- [`../faceplates/`](../faceplates/index.md) - Faceplate implementation
- [`../../decisions/004-design-language-constraints.md`](../../decisions/004-design-language-constraints.md) - Design constraints ADR

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Domain Index
