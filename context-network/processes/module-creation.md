# Creating New Modules

## Purpose
Step-by-step process for creating new reusable modules in RetroCase.

## Classification
- **Domain:** Processes
- **Stability:** Stable
- **Abstraction:** Procedural
- **Confidence:** Established

## Before You Start

1. **Check if it exists** - Search existing modules first
2. **Identify the category** - Profile, shell, faceplate, or hardware?
3. **Review similar modules** - Copy patterns, not just code
4. **Read relevant BOSL2 docs** - Understand the functions you'll use

## Step 1: Create the File

### File Location

| Type | Location | Naming |
|------|----------|--------|
| Profile (2D) | `modules/profiles/` | `descriptive-name.scad` |
| Shell (3D) | `modules/shells/` | `shell-type.scad` |
| Faceplate | `modules/faces/` | `faceplate-type.scad` |
| Hardware | `modules/hardware/` | `component-name.scad` |

### File Header Template

```openscad
// [Module Name]
// Brief description of what this module does.

include <BOSL2/std.scad>

// Default values (if any)
_DEFAULT_PARAM = value;
```

## Step 2: Define the Module

### Basic Structure

```openscad
/**
 * Brief description.
 *
 * Arguments:
 *   param1 - Description (type, default)
 *   param2 - Description (type, default)
 *   anchor - BOSL2 anchor (default: CENTER)
 *   spin   - BOSL2 spin (default: 0)
 *   orient - BOSL2 orient (default: UP)
 */
module module_name(
    param1,
    param2 = default_value,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Implementation
}
```

### For Attachable Modules

```openscad
module my_shape(size, param, anchor=CENTER, spin=0, orient=UP) {
    width = size[0];
    height = size[1];
    depth = size[2];

    attachable(anchor, spin, orient, size=size) {
        // Your geometry
        diff()
        cuboid(size) {
            tag("remove")
            // ...
        }

        children();  // Required!
    }
}
```

## Step 3: Implement Geometry

### Use BOSL2 Patterns

```openscad
// Hollowing
diff()
outer_shape() {
    tag("remove")
    position(TOP)
    inner_shape();
}

// Positioning
parent_shape() {
    position(anchor)
    child_shape();
}
```

### Parameter Validation

```openscad
module my_module(size, wall) {
    assert(wall > 0, "wall must be positive");
    assert(size[0] > wall*2, "size too small for wall thickness");

    // Implementation
}
```

## Step 4: Add Preview/Test Code

At the bottom of the file:

```openscad
// === TEST / DEMO ===
if ($preview) {
    // Example usage
    module_name(
        param1 = typical_value,
        param2 = typical_value
    );
}
```

## Step 5: Create Example File

In `examples/`:

```openscad
// XX-descriptive-name.scad
// Demonstrates [module name] with typical usage.

include <../modules/category/module-file.scad>

// Example 1: Basic usage
module_name(param1, param2);

// Example 2: Variation
translate([offset, 0, 0])
module_name(param1, different_param2);
```

## Step 6: Render and Verify

```bash
# Render the example
./scripts/render.sh examples/XX-descriptive-name.scad

# Check the PNG
open test-renders/XX-descriptive-name.png
```

Verify:
- Geometry matches intent
- No BOSL2 errors
- Reasonable render time

## Step 7: Document in Header

Complete the documentation:

```openscad
/**
 * Creates a [description].
 *
 * This module [explain purpose and key features].
 *
 * Arguments:
 *   size       - [width, height, depth] outer dimensions
 *   wall       - wall thickness (default: 3)
 *   corner_r   - corner radius (default: 10)
 *   anchor     - BOSL2 anchor (default: BOT)
 *   spin       - BOSL2 spin (default: 0)
 *   orient     - BOSL2 orient (default: UP)
 *
 * Example:
 *   module_name([100, 80, 60], wall=3);
 */
```

## Step 8: Update Context Network

1. **Update domain location index** in `context-network/domains/[category]/locations.md`
2. **Create pattern documentation** if this introduces a new pattern
3. **Link from related documents** as appropriate

## Naming Conventions

### Modules

| Type | Pattern | Example |
|------|---------|---------|
| Profile | `profile_<name>` | `profile_wedge()` |
| Path function | `path_<name>` | `path_rounded_rect()` |
| Shell | `shell_<type>` | `shell_monolithic()` |
| Faceplate | `faceplate_<type>` | `faceplate_bezel()` |
| Hardware | `<component>_<variant>` | `magnet_pocket()` |

### Parameters

Follow [`../cross-domain/parameter-conventions.md`](../cross-domain/parameter-conventions.md).

## Checklist

Before considering a module complete:

- [ ] File in correct location
- [ ] Header documentation complete
- [ ] Uses BOSL2 patterns correctly
- [ ] Is attachable (if applicable)
- [ ] Has preview/test code
- [ ] Example file created
- [ ] Renders successfully
- [ ] Context network updated

## Navigation

**Up:** [`index.md`](index.md) - Processes overview

**Related:**
- [`development-workflow.md`](development-workflow.md) - Overall workflow
- [`../cross-domain/parameter-conventions.md`](../cross-domain/parameter-conventions.md) - Naming standards
- [`../domains/`](../domains/index.md) - Domain-specific patterns

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Process Documentation
