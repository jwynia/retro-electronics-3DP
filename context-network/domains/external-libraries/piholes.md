# PiHoles Integration

## Purpose
PiHoles is a lightweight library specifically for Raspberry Pi mounting. Use it when you only need Pi mounting holes without NopSCADlib's full component library.

## Classification
- **Domain:** External Libraries
- **Stability:** Stable
- **Abstraction:** Integration reference
- **Confidence:** Established

## Location
`lib/PiHoles/PiHoles.scad`

## Basic Usage

```openscad
use <PiHoles/PiHoles.scad>

// Generate mounting holes for Pi 4 (same as 3B)
piHoles("3B", depth=5);

// Get hole positions as data
positions = piHoleLocations("3B");
// Returns: [[3.5, 3.5], [61.5, 3.5], [3.5, 52.5], [61.5, 52.5]]

// Get board dimensions
dims = piBoardDim("3B");
// Returns: [85, 56, 1.25]
```

## Supported Boards

| Board ID | Model | Size (mm) | Holes |
|----------|-------|-----------|-------|
| `"1B"` | Pi 1 Model B | 85 x 56 | 2 (non-standard) |
| `"1A+"` | Pi 1 Model A+ | 65 x 56 | 4 |
| `"1B+"` | Pi 1 Model B+ | 85 x 56 | 4 |
| `"2B"` | Pi 2 Model B | 85 x 56 | 4 |
| `"3A+"` | Pi 3 Model A+ | 65 x 56 | 4 |
| `"3B"` | Pi 3 Model B/B+ | 85 x 56 | 4 |
| `"Zero"` | Pi Zero/Zero W | 65 x 30 | 4 |

**Note:** Pi 4 and Pi 5 use the same hole pattern as Pi 3B - use `"3B"`.

## Available Functions

### piHoleLocations(board)
Returns array of `[x, y]` mounting hole positions.

```openscad
positions = piHoleLocations("3B");
// [[3.5, 3.5], [61.5, 3.5], [3.5, 52.5], [61.5, 52.5]]
```

### piBoardDim(board)
Returns `[length, width, thickness]` of PCB.

```openscad
dims = piBoardDim("3B");
// [85, 56, 1.25]
```

### piHoles(board, depth, preview)
Generates cylinder holes for mounting screws.

```openscad
piHoles("3B", depth=10, preview=true);
```

- `board` - Board identifier string
- `depth` - Hole depth in mm (default: 5)
- `preview` - Show ghost board preview (default: true)

### piBoard(board)
Renders a simple preview of the board shape.

```openscad
% piBoard("3B");  // Transparent preview
```

### piPosts(board, height, preview)
Generates snap-fit mounting posts.

```openscad
piPosts("3B", height=5, preview=true);
```

- `height` - Height from base to top of PCB
- `preview` - Show ghost board preview

## RetroCase Integration Patterns

### Pattern 1: Subtract Holes from Shell Floor
```openscad
include <BOSL2/std.scad>
use <PiHoles/PiHoles.scad>

difference() {
    // Shell floor
    cuboid([100, 70, 3], anchor=BOT);

    // Pi mounting holes, centered
    board_dims = piBoardDim("3B");
    translate([
        -board_dims[0]/2 + 7.5,  // Center X with margin
        -board_dims[1]/2 + 7,    // Center Y with margin
        0
    ])
    piHoles("3B", depth=4, preview=false);
}
```

### Pattern 2: Generate Standoff Positions
```openscad
use <PiHoles/PiHoles.scad>

module pi_standoffs(board, height=5) {
    for (pos = piHoleLocations(board)) {
        translate([pos[0], pos[1], 0])
            cylinder(d=6, h=height);  // Standoff base
    }
}
```

### Pattern 3: Size Shell to Fit Board
```openscad
use <PiHoles/PiHoles.scad>

board = "3B";
dims = piBoardDim(board);
margin = 10;

shell_width = dims[0] + margin * 2;
shell_height = dims[1] + margin * 2;
```

## PiHoles vs NopSCADlib

| Aspect | PiHoles | NopSCADlib |
|--------|---------|------------|
| Pi support | All models | RPI0, 3, 3A+, 4, Pico |
| Other boards | No | Arduino, ESP32, many more |
| Components | No | Connectors, displays, etc. |
| File size | ~3KB | ~15MB |
| Render time | Fast | Slower (detailed models) |
| Dependencies | None | Many internal |

**Use PiHoles when:**
- Only need Pi mounting
- Want minimal dependencies
- Need fast renders

**Use NopSCADlib when:**
- Need full PCB preview with connectors
- Need multiple board types
- Need connector dimensions for cutouts

## Coordinate System

PiHoles uses corner-origin coordinates:
- Origin at front-left corner of PCB
- X increases toward GPIO header
- Y increases toward USB ports (Pi 3/4)

```
    GPIO side (X=0 to 85)
    ┌─────────────────────┐
    │ ○              ○    │
Y   │                     │  USB/Ethernet
    │                     │  side
    │ ○              ○    │
    └─────────────────────┘
    Origin (0,0)
```

## Navigation

**Up:** [`index.md`](index.md) - External Libraries overview

**Related:**
- [`nopscadlib.md`](nopscadlib.md) - Full hardware library
- [`../hardware/`](../hardware/index.md) - RetroCase mounting patterns

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Integration Reference
