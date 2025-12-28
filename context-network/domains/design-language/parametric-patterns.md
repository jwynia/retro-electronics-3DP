# Parametric Patterns

## Purpose
Concrete parametric patterns derived from iconic products, ready for OpenSCAD implementation.

## Classification
- **Domain:** Design Language
- **Stability:** Evolving (grows with implementation)
- **Abstraction:** Implementation guide
- **Confidence:** Established concepts, evolving code

## Shell Profiles

### Pattern: Braun Box
**Source:** Braun RT 20, SK 4
**Character:** Clean rectangular with subtle rounding

```
Parameters:
  width: 150-200mm (typical radio)
  height: 80-120mm
  depth: 60-100mm
  corner_radius: 8-15mm (consistent all edges)
  wall: 3mm

Profile:
  ┌────────────────────┐
  │                    │  ← corner_radius
  │                    │
  │                    │
  └────────────────────┘
```

**Verification Criteria:**
| Criterion | Valid Range | Formula |
|-----------|-------------|---------|
| Width:Height ratio | 1.2:1 to 2:1 | `width / height` |
| Depth:Height ratio | 0.6:1 to 1:1 | `depth / height` |
| Corner radius ratio | 5-10% | `corner_r / min(width, height, depth)` |

**Implementation Notes:**
- Use `cuboid()` with `rounding` parameter
- All corners same radius for Braun authenticity
- Front face often has grille area

### Pattern: Olivetti Wedge
**Source:** Divisumma 18, Logos 55
**Character:** Raked front face, thinner at front

```
Parameters:
  width: 180-250mm
  front_height: 30-50mm
  back_height: 80-120mm
  depth: 200-300mm
  rake_angle: 10-25° (calculated from heights)
  corner_radius: 15-25mm (larger, softer)

Profile (side view):
        ┌───────────────┐
       ╱                │
      ╱                 │  ← back_height
     ╱                  │
    ╱                   │
   └────────────────────┘
   ↑ front_height
```

**Verification Criteria:**
| Criterion | Valid Range | Formula |
|-----------|-------------|---------|
| Rake angle | 12-25° | `atan2(back_height - front_height, depth)` |
| Front:Back height ratio | 0.3:1 to 0.5:1 | `front_height / back_height` |
| Corner radius ratio | 8-15% | `corner_r / min(width, front_height)` |
| Depth:Back height ratio | 1.5:1 to 2.5:1 | `depth / back_height` |

**Implementation Notes:**
- Use `prismoid()` for tapered shape
- Larger corner radii than Braun
- Display angle typically 20-30°

### Pattern: Space Age Sphere
**Source:** JVC Videosphere, Weltron 2001
**Character:** Spherical or elliptical pod

```
Parameters:
  diameter: 200-350mm
  opening_angle: 90-150° (visor width)
  opening_height: 40-60% of diameter
  stand_style: chain | pedestal | integrated

Profile (front view):
       ╭──────────╮
      ╱            ╲
     │  ┌──────┐   │  ← visor opening
     │  │      │   │
      ╲ └──────┘  ╱
       ╰────────╯
```

**Verification Criteria:**
| Criterion | Valid Range | Formula |
|-----------|-------------|---------|
| Sphericity | 0.8:1 to 1.2:1 | `max_dim / min_dim` (for ellipsoid) |
| Opening arc | 90-150° | `opening_angle` |
| Opening height ratio | 40-60% | `opening_height / diameter` |
| Opening width ratio | 60-85% | `opening_width / diameter` |

**Implementation Notes:**
- Use `sphere()` or `ellipsoid()` with `difference()` for opening
- Consider print orientation (may need split)
- Chain mount: small hole at top

### Pattern: Danish Slab
**Source:** Bang & Olufsen Beolit, Beosystem
**Character:** Thin, wide, horizontal

```
Parameters:
  width: 300-500mm
  height: 60-100mm (thin!)
  depth: 150-250mm
  corner_radius: 3-8mm (subtle)

Profile:
  ┌──────────────────────────────────┐
  │                                  │  ← very thin
  └──────────────────────────────────┘
```

**Verification Criteria:**
| Criterion | Valid Range | Formula |
|-----------|-------------|---------|
| Width:Height ratio | ≥3:1 | `width / height` |
| Maximum height | ≤100mm | `height` |
| Corner radius ratio | 0-5% | `corner_r / height` |
| Depth:Width ratio | 0.3:1 to 0.6:1 | `depth / width` |

**Implementation Notes:**
- Horizontal proportions (width >> height)
- Subtle or no corner rounding
- Often stacked/modular

---

## Grille Patterns

### Pattern: Braun Horizontal Slots
**Source:** RT 20, most Braun radios

```
Parameters:
  slot_width: 2-3mm
  slot_height: 40-60% of grille area
  slot_spacing: 4-6mm center-to-center
  end_margin: 15-25mm from edges

Pattern:
  ═══════════════════════
  ═══════════════════════
  ═══════════════════════
  ═══════════════════════
```

**Implementation:**
```openscad
module grille_slots(width, height, slot_w=2.5, spacing=5, rows) {
    slot_h = height / (rows + 1);
    for (i = [1:rows]) {
        translate([0, 0, i * slot_h])
        cuboid([width - 30, slot_w, slot_w], anchor=CENTER);
    }
}
```

### Pattern: Dot Matrix
**Source:** Bang & Olufsen, some Sony

```
Parameters:
  hole_diameter: 2-4mm
  grid_spacing: 5-8mm
  pattern: square | hex

Pattern (hex):
   ○ ○ ○ ○ ○ ○ ○
    ○ ○ ○ ○ ○ ○
   ○ ○ ○ ○ ○ ○ ○
```

### Pattern: Hex Honeycomb
**Source:** Various speaker grilles

```
Parameters:
  hex_size: 5-10mm (flat-to-flat)
  wall_thickness: 1-2mm
```

---

## Control Layouts

### Pattern: Braun Offset
**Source:** RT 20
**Character:** Controls grouped to one side

```
  ┌─────────────────────────────┐
  │ ══════════════  ◉ ○ ○      │
  │ ══════════════  ○ ○        │
  │ ══════════════             │
  └─────────────────────────────┘
       grille        controls
```

### Pattern: Olivetti Centered
**Source:** Divisumma
**Character:** Symmetric, display above controls

```
  ┌───────────────────────┐
  │     [ DISPLAY ]       │
  │  ○ ○ ○ ○    ○ ○ ○ ○   │
  │  ○ ○ ○ ○    ○ ○ ○ ○   │
  │  ○ ○ ○ ○    ○ ○ ○ ○   │
  └───────────────────────┘
```

### Pattern: Side Panel
**Source:** B&O, some Japanese
**Character:** Controls on side face

```
     front        side
  ┌────────┐    ┌─────┐
  │        │    │ ◉   │
  │        │    │ ─── │
  │        │    │ ○   │
  └────────┘    └─────┘
```

---

## Presets to Implement

Priority presets based on design patterns:

### Preset: "Braun Radio"
```
shell_type: box
profile: braun_box
grille: horizontal_slots
controls: offset
corner_radius: 12mm
colors: white/grey/aluminum
```

### Preset: "Olivetti Calculator"
```
shell_type: wedge
profile: olivetti_wedge
rake_angle: 18°
controls: centered_display
corner_radius: 20mm
colors: cream/grey/yellow
```

### Preset: "Space Pod"
```
shell_type: sphere
opening: visor
mount: chain | pedestal
colors: white/orange/black
```

### Preset: "Flip Clock"
```
shell_type: thin_box
display: large_centered
frame: minimal_bezel
depth: 60-80mm
```

### Preset: "Danish Module"
```
shell_type: slab
proportions: wide_low
grille: dots
corner_radius: 5mm
stackable: true
```

## Navigation

**Up:** [`index.md`](index.md) - Design Language overview

**Related:**
- [`designers.md`](designers.md) - Designer backgrounds
- [`../../planning/preset-catalog.md`](../../planning/preset-catalog.md) - Preset implementation plans
- [`../shells/`](../shells/index.md) - Shell modules
- [`../parametric-patterns/`](../parametric-patterns/index.md) - OpenSCAD parametric patterns (extracted from Makerworld models)
- [`../parametric-patterns/pattern-generation.md`](../parametric-patterns/pattern-generation.md) - 2D pattern generation (honeycomb, textures)

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Implementation Guide
