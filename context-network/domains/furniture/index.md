# Furniture Domain

## Purpose

Parametric miniature furniture for home layout planning. Generates 3D-printable furniture pieces at configurable scales (1:12, 1:24, 1:48) with both retro (mid-century modern) and contemporary style variants.

## Classification

- **Domain:** Mini-Furniture Generation
- **Stability:** New (Phase 1 complete)
- **Abstraction:** Practical
- **Confidence:** Initial implementation

## Key Concepts

### Scale System

All furniture uses real-world dimensions internally, scaled at render time.

```openscad
FURNITURE_SCALE = 24;  // 1:24 default (half-inch scale)

// Scale helper functions
scale_dim(real_mm, scale)      // Single dimension
scale_dim2(real_mm, scale)     // 2D array [x, y]
scale_dim3(real_mm, scale)     // 3D array [x, y, z]
```

Common scales:
| Scale | Name | Use Case |
|-------|------|----------|
| 1:12 | Dollhouse | Detailed miniatures |
| 1:24 | Half-inch | Balance of detail and size |
| 1:48 | Quarter-inch | Compact planning boards |

### Style Variants

Two style modes controlled by `style` parameter:

| Element | Retro | Modern |
|---------|-------|--------|
| Legs | Tapered/splayed | Block or hidden |
| Arms | Rounded | Square/minimal |
| Cushions | Button-tufted | Flat, clean |
| Edges | Organic curves | Sharp, geometric |

```openscad
sofa(seats=3, style="retro");   // Mid-century modern
sofa(seats=3, style="modern");  // Contemporary
```

## Module Files

| File | Contents |
|------|----------|
| `furniture-constants.scad` | Scale system, real-world dimensions, style definitions |
| `furniture-utils.scad` | Helper modules: legs, cushions, handles, panels |
| `floor-plan.scad` | Grid, room outlines, door/window symbols |
| `living-room.scad` | Sofas, armchairs, coffee tables, bookcases, TV stands |

## Current Modules

### Living Room (`living-room.scad`)

| Module | Parameters | Description |
|--------|------------|-------------|
| `sofa()` | seats, style, color, scale | 2-4 seat sofa |
| `armchair()` | style, color, scale | Single armchair |
| `coffee_table()` | size, style, has_shelf, scale | Coffee table with optional shelf |
| `end_table()` | size, style, has_shelf, scale | Side/end table |
| `bookcase()` | units_wide, units_tall, style, scale | Modular bookcase |
| `tv_stand()` | size, style, cabinets, scale | Media console |

### Floor Plan (`floor-plan.scad`)

| Module | Parameters | Description |
|--------|------------|-------------|
| `floor_grid()` | size, grid_size, scale | Reference grid (1-foot squares) |
| `room_outline()` | size, wall_height, scale | Simple room walls |
| `room_with_openings()` | size, doors, windows, scale | Room with door/window openings |
| `door_symbol()` | width, swing, scale | Door swing arc |
| `window_symbol()` | width, scale | Window representation |

### Utilities (`furniture-utils.scad`)

| Module | Description |
|--------|-------------|
| `leg_tapered()` | Mid-century tapered leg |
| `leg_block()` | Modern square leg |
| `leg_hairpin()` | Hairpin wire leg |
| `leg_turned()` | Traditional turned leg |
| `furniture_leg()` | Style-based leg selector |
| `furniture_cushion()` | Seat cushion with optional tufting |
| `furniture_back_cushion()` | Back cushion with recline |
| `furniture_handle()` | Drawer/door handles |
| `furniture_panel()` | Flat panel (tabletop, shelf) |
| `furniture_frame()` | Rectangular frame |

## Examples

| Example | Description |
|---------|-------------|
| `22-furniture-scale-demo.scad` | Same furniture at 1:12, 1:24, 1:48 scales |
| `23-living-room-layout.scad` | Complete room layout with floor plan grid |

## Usage Pattern

```openscad
include <BOSL2/std.scad>
include <modules/furniture/furniture-constants.scad>
include <modules/furniture/floor-plan.scad>
include <modules/furniture/living-room.scad>

// Set scale for this layout
FURNITURE_SCALE = 24;

// Create floor plan
floor_grid(size=[4000, 3000]);
room_outline(size=[4000, 3000]);

// Place furniture
translate([0, 500, 0])
sofa(seats=3, style="retro");

translate([0, -200, 0])
coffee_table(style="retro");
```

## Standard Dimensions Reference

### Beds (mattress only)
| Size | Real (mm) | Real (inches) |
|------|-----------|---------------|
| Twin | 965 x 1905 | 38" x 75" |
| Full | 1372 x 1905 | 54" x 75" |
| Queen | 1524 x 2032 | 60" x 80" |
| King | 1930 x 2032 | 76" x 80" |

### Seating
| Dimension | Real (mm) |
|-----------|-----------|
| Sofa seat width (per seat) | 550 |
| Seat height | 450 |
| Sofa back height | 850 |

### Tables
| Type | Real (mm) |
|------|-----------|
| Coffee table | 1200 x 600 x 450 |
| Dining table (6-seat) | 1800 x 900 x 750 |
| Nightstand | 500 x 400 x 600 |

## Roadmap

### Phase 2: Bedroom & Dining
- `bedroom.scad` - bed(), nightstand(), dresser(), wardrobe()
- `dining.scad` - dining_table(), dining_chair()

### Phase 3: Kitchen & Bathroom
- `kitchen.scad` - refrigerator(), stove(), counter_section()
- `bathroom.scad` - bathtub(), toilet(), vanity()

### Phase 4: Office & Polish
- `office.scad` - desk(), office_chair()
- Complete floor plan example

## Navigation

**Up:** [`../index.md`](../index.md) - Domains overview

**Related:**
- [`../shells/index.md`](../shells/index.md) - Shell patterns (similar module structure)
- [`../../cross-domain/parameter-conventions.md`](../../cross-domain/parameter-conventions.md) - Parameter naming

## Metadata

- **Created:** 2025-01-07
- **Last Updated:** 2025-01-07
- **Document Type:** Domain Index
