# Testing and Rendering

## Purpose
How to use the render script, interpret output, and validate designs.

## Classification
- **Domain:** Processes
- **Stability:** Stable
- **Abstraction:** Procedural
- **Confidence:** Established

## The Render Script

Location: `scripts/render.sh`

### Basic Usage

```bash
# Render a single file
./scripts/render.sh path/to/file.scad

# Output goes to test-renders/file.png
```

### Camera Presets

```bash
./scripts/render.sh file.scad [preset]
```

| Preset | Description | Best For |
|--------|-------------|----------|
| `default` | Isometric view | General inspection |
| `front` | Front face | Opening/faceplate |
| `top` | Top-down | Footprint, layout |
| `right` | Right side | Profile, depth |
| `iso` | Alternative isometric | Different angle |
| `back` | Back view | Rear features |

### Batch Rendering

```bash
# Render all examples
./scripts/render.sh --all

# Output goes to test-renders/ with matching filenames
```

## Script Options

```bash
./scripts/render.sh [options] file.scad [camera]

Options:
  --all         Render all files in examples/
  --stl         Export STL instead of PNG
  --size WxH    Image size (default: 800x600)
```

## Output Location

All renders go to `test-renders/`:

```
test-renders/
├── 01-basic-rounded-box.png
├── 02-wedge-shell.png
├── ...
└── my-module.png
```

## STL Export

For production/printing:

```bash
# Using render script
./scripts/render.sh --stl file.scad

# Or directly with OpenSCAD
openscad -o output.stl file.scad
```

## Interpreting Results

### Good Render

- Clean geometry with no artifacts
- Proper corner rounding (consistent, no flat spots)
- Correct wall thickness (visible in section views)
- Openings properly placed and sized
- No "inside-out" faces (color issues)

### Problem Indicators

| Symptom | Likely Cause |
|---------|--------------|
| Missing geometry | Failed diff() or tag issue |
| Inverted colors | Geometry facing wrong way |
| Artifacts/glitches | Non-manifold geometry |
| Flat corners | Rounding radius too small |
| Render timeout | Geometry too complex |

## Console Output

Watch for messages during render:

### Warnings
```
ECHO: "WARNING: ..."
```
Usually non-fatal but worth investigating.

### Errors
```
ERROR: ...
```
Render will fail or produce incorrect output.

### Common Messages

| Message | Meaning |
|---------|---------|
| "Normalized tree" | Normal processing message |
| "Union" / "Difference" | Boolean operation summary |
| "WARNING: No geometry" | Empty result (problem!) |
| "ERROR: Parameter" | Wrong function call |

## Preview Mode

For quick iteration in OpenSCAD:

```openscad
// At bottom of file
if ($preview) {
    // Quick preview geometry
    my_module(...);
}
```

Press F5 for preview (fast), F6 for full render (slow but accurate).

## Test Patterns

### Include Test Geometry

```openscad
if ($preview) {
    // Show module
    my_shell(...);

    // Reference dimensions
    %cuboid([100, 100, 100], anchor=BOT);

    // Show anchors
    #show_anchors();
}
```

### Cross-Section View

```openscad
if ($preview) {
    intersection() {
        my_shell(...);
        // Cut plane
        translate([0, 0, 0])
        cuboid([1000, 1000, 1000], anchor=BACK);
    }
}
```

## Validation Checklist

After rendering, verify:

- [ ] Overall dimensions correct
- [ ] Wall thickness consistent
- [ ] Corners rounded properly
- [ ] Openings positioned correctly
- [ ] No boolean operation failures
- [ ] No inverted faces
- [ ] Geometry is manifold (watertight)

## Performance Tips

### Slow Renders

- Reduce `$fn` for development (`$fn=16`)
- Use `$preview` to skip complex geometry
- Simplify curves temporarily

### Fast Iteration

```openscad
// Fast preview values
$fn = $preview ? 16 : 64;
```

## Navigation

**Up:** [`index.md`](index.md) - Processes overview

**Related:**
- [`development-workflow.md`](development-workflow.md) - Overall workflow
- [`../foundation/architecture.md`](../foundation/architecture.md) - Script locations

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Process Documentation
