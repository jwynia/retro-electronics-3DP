# Development Workflow

## Purpose
The detailed Read → Write → Render → Verify workflow for RetroCase development.

## Classification
- **Domain:** Processes
- **Stability:** Stable
- **Abstraction:** Procedural
- **Confidence:** Established

## The Core Cycle

```
┌─────────┐    ┌─────────┐    ┌──────────┐    ┌──────────┐
│  READ   │ → │  WRITE  │ → │  RENDER  │ → │  VERIFY  │
└─────────┘    └─────────┘    └──────────┘    └──────────┘
     ↑                                              │
     └──────────────── (if wrong) ─────────────────┘
```

Every code change follows this cycle. Don't skip steps.

## Phase 1: READ

Before writing any code, understand what exists.

### 1.1 Read BOSL2 Documentation

For the functions you'll use, check `docs/bosl2/`:

```bash
# Available BOSL2 docs
docs/bosl2/shapes3d.md      # cuboid, prismoid, cyl
docs/bosl2/attachments.md   # position, attach, anchors
docs/bosl2/rounding.md      # edge rounding options
docs/bosl2/common-pitfalls.md  # mistakes to avoid
```

**Look for:**
- Function signatures and parameters
- Edge specification syntax
- Anchor constant names
- Rounding behavior differences

### 1.2 Check Existing Examples

Find working code similar to what you need:

```bash
ls examples/
# 01-basic-rounded-box.scad
# 02-wedge-shell.scad
# 03-hollow-shell-with-lip.scad
# ...
```

Open relevant examples in OpenSCAD and preview them.

### 1.3 Understand Module Responsibility

Ask yourself:
- Is this a **profile** (2D) → goes in `modules/profiles/`
- Is this a **shell** (3D enclosure) → goes in `modules/shells/`
- Is this a **faceplate** → goes in `modules/faces/`
- Is this **hardware** → goes in `modules/hardware/`

Check the context network for existing patterns in that category.

## Phase 2: WRITE

Now write your code, following established patterns.

### 2.1 Use BOSL2 Patterns

**DO:**
```openscad
diff()
cuboid(size, rounding=r, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid(inner_size, anchor=TOP);
}
```

**DON'T:**
```openscad
difference() {
    cuboid(size);
    translate([0, 0, wall])
    cuboid(inner_size);
}
```

### 2.2 Make Modules Attachable

If your module is a reusable shape:

```openscad
module my_module(size, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor, spin, orient, size=size) {
        // Your geometry here
        children();
    }
}
```

### 2.3 Follow Naming Conventions

See [`../cross-domain/parameter-conventions.md`](../cross-domain/parameter-conventions.md)

- Use standard parameter names
- Follow module naming patterns
- Document parameters in header comments

## Phase 3: RENDER

Generate visual output to verify your code.

### 3.1 Use the Render Script

```bash
./scripts/render.sh modules/shells/myshell.scad
```

Output goes to `test-renders/` as PNG.

### 3.2 Choose Camera Angle

```bash
# Available presets
./scripts/render.sh file.scad default  # Isometric
./scripts/render.sh file.scad front    # Front view
./scripts/render.sh file.scad top      # Top-down
./scripts/render.sh file.scad right    # Right side
./scripts/render.sh file.scad iso      # Alternative iso
```

### 3.3 Check Console Output

Watch for BOSL2 warnings and errors:
```
ECHO: "WARNING: ..."
ERROR: ...
```

These often indicate the exact problem.

## Phase 4: VERIFY

Look at the rendered output critically.

### 4.1 Visual Checks

- Does the overall shape match intent?
- Are corners rounded correctly (not too much, not too little)?
- Is hollowing correct (proper wall thickness)?
- Are openings in the right place and size?
- Do attachment points look correct?

### 4.2 Dimensional Checks

In OpenSCAD preview, use the measuring tool or add test geometry:

```openscad
// Temporary: Add reference cube
%cuboid([100, 100, 100], anchor=BOT);
```

### 4.3 If Wrong, Diagnose

Don't change code randomly. Follow the debugging process.

## Debugging Process

When output doesn't match intent:

### Step 1: Check BOSL2 Errors

Look at console output. Common issues:
- "Unknown parameter" → wrong parameter name
- "Expected number" → incorrect type
- Geometry warnings → invalid boolean operation

### Step 2: Simplify

Comment out parts until you find the issue:

```openscad
diff()
cuboid(size) {
    // tag("remove") position(TOP) inner_cavity();
    // tag("remove") position(FWD) opening();
    tag("remove") position(TOP) lip_rebate();  // Test just this
}
```

### Step 3: Visualize Anchors

Use `show_anchors()` to see attachment points:

```openscad
cuboid(50)
    show_anchors();
```

### Step 4: Check Edge Specs

Edge specification is the most common mistake:

```openscad
// These are DIFFERENT
edges = TOP       // All 4 edges on top face
edges = "Z"       // All 4 vertical edges
edges = TOP+FWD   // Single edge
```

### Step 5: Verify Tags

Missing tags = geometry not subtracted:

```openscad
// WRONG: No tag
diff()
cuboid(50) {
    position(TOP) cyl(d=20, h=10, anchor=BOT);  // Not subtracted!
}

// RIGHT: Has tag
diff()
cuboid(50) {
    tag("remove") position(TOP) cyl(d=20, h=10, anchor=BOT);
}
```

## Navigation

**Up:** [`index.md`](index.md) - Processes overview

**Related:**
- [`../foundation/development-principles.md`](../foundation/development-principles.md) - Core principles
- [`testing-rendering.md`](testing-rendering.md) - Rendering details
- [`../domains/bosl2-integration/common-mistakes.md`](../domains/bosl2-integration/common-mistakes.md) - Avoid these

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Process Documentation
