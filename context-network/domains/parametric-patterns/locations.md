# Pattern Code Locations

## Purpose

Maps extracted patterns to specific source files and line numbers for reference and verification.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Dynamic
- **Abstraction:** Reference
- **Confidence:** Established

## Inbox Files

| File | Lines | Description |
|------|-------|-------------|
| `inbox/bracket-generator.scad` | 612 | Multi-type brackets, FDM optimization |
| `inbox/cirkit-pods.scad` | 718 | Threaded containers, textures |
| `inbox/connector-generator.scad` | 296 | Multi-arm connectors |
| `inbox/drawer-divider.scad` | 650 | Dovetails, honeycomb |
| `inbox/grid-generator.scad` | 199 | 2D shapes, grid_copies |
| `inbox/gridfinity-bins.scad` | 699 | Profile sweeps, tabs |
| `inbox/grille-generator.scad` | 431 | Path holes, slats, mesh |
| `inbox/jar-generator.scad` | 890 | Textures, threading |
| `inbox/thread-generator.scad` | 385 | Thread types, rod splitting |

---

## Customizer UI Patterns

| Pattern | File | Lines |
|---------|------|-------|
| Emoji section headers | bracket-generator.scad | 22-95 |
| Basic section headers | cirkit-pods.scad | 33-86 |
| Optional sections `[[Optional]]` | cirkit-pods.scad | 124-148 |
| Hidden section | bracket-generator.scad | 96-103 |
| Dropdown with labels | bracket-generator.scad | 25 |
| Range sliders `[min:step:max]` | bracket-generator.scad | 37-40 |
| Array parameters | bracket-generator.scad | 48-51 |
| Color picker | bracket-generator.scad | 94 |
| Extended color list | jar-generator.scad | 28-29 |
| Resolution presets | thread-generator.scad | 79-91 |
| Assert validation | cirkit-pods.scad | 50-55, 98-118 |
| Relationship validation | cirkit-pods.scad | 100-103 |
| Both-ends control | thread-generator.scad | 34-48, 111-112 |
| Stagger options | bracket-generator.scad | 54 |

---

## BOSL2 Advanced Patterns

| Pattern | File | Lines |
|---------|------|-------|
| grid_copies with inside clipping | grid-generator.scad | 92-133 |
| grid_copies with stagger | grille-generator.scad | 186-220 |
| Path functions returning shapes | grid-generator.scad | 118-133 |
| path_sweep2d for profiles | grille-generator.scad | 342-365 |
| path_sweep for inserts | grille-generator.scad | 375-404 |
| resample_path for holes | grille-generator.scad | 255-280 |
| pointlist_bounds sizing | grid-generator.scad | 140-148 |
| region() operations | grid-generator.scad | 162-175 |
| Profile sweep walls | gridfinity-bins.scad | 219-260 |
| skin() operations | bracket-generator.scad | 500-520 |

---

## FDM Optimization Patterns

| Pattern | File | Lines |
|---------|------|-------|
| FDM rotation for print orientation | bracket-generator.scad | 111-113 |
| Teardrop screw holes | bracket-generator.scad | 123 |
| Rod splitting with bridge | thread-generator.scad | 148-174 |
| Teardrop rounding | jar-generator.scad | 83-89 |
| Slop/clearance constants | cirkit-pods.scad | 112 |
| Support structure generation | bracket-generator.scad | 74-83 |

---

## Parametric Architecture Patterns

| Pattern | File | Lines |
|---------|------|-------|
| Type dispatch `if Type ==` | bracket-generator.scad | 110-179 |
| Thread type dispatch | thread-generator.scad | 117-135 |
| Function-based config lookup | cirkit-pods.scad | 283-291 |
| Position arrays for arms | connector-generator.scad | 121-140 |
| String parsing for angles | connector-generator.scad | 156-175 |
| Computed values from params | cirkit-pods.scad | 180-195 |
| Multi-part render toggles | cirkit-pods.scad | 600-650 |
| Display visibility flags | thread-generator.scad | 95-97 |

---

## Mechanical Joint Patterns

| Pattern | File | Lines |
|---------|------|-------|
| Trapezoidal threaded rod | cirkit-pods.scad | 399-436 |
| Internal vs external threads | cirkit-pods.scad | 244-263 |
| Thread slop calculation | thread-generator.scad | 180-210 |
| Dovetail teeth polygon | drawer-divider.scad | 67-95 |
| Dovetail male/female | drawer-divider.scad | 97-143 |
| Junction block calculation | drawer-divider.scad | 222-243 |
| Bevel control patterns | thread-generator.scad | 101-112 |

---

## Pattern Generation Patterns

| Pattern | File | Lines |
|---------|------|-------|
| Honeycomb 2D staggered | drawer-divider.scad | 155-195 |
| Pill pattern 2D | drawer-divider.scad | 197-218 |
| Texture arrays for cyl() | jar-generator.scad | 68-80 |
| Texture style dispatch | jar-generator.scad | 91-180 |
| Responsive texture sizing | jar-generator.scad | 96-97 |
| Slat center calculation | grille-generator.scad | 219-254 |
| Mesh pattern generation | grille-generator.scad | 186-220 |
| Flower shape function | grille-generator.scad | 406-420 |
| Print-size splitting | drawer-divider.scad | 280-350 |
| Boundary adjustment | drawer-divider.scad | 250-278 |

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Reference
