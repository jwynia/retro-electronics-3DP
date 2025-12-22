# Shells Domain

## Purpose
This domain covers shell generation patterns - the hollow enclosures that form the structural body of RetroCase designs. Shells are the primary 3D component that other elements (faceplates, hardware) attach to.

## Classification
- **Domain:** 3D Shell Generation
- **Stability:** Core (fundamental to project)
- **Abstraction:** Structural patterns
- **Confidence:** Established

## Documents

### [`monolithic-shells.md`](monolithic-shells.md)
**Single-Piece Shell Patterns**

Techniques for generating single-piece hollow shells using BOSL2's diff/tag system.

**Key topics:**
- Basic hollow shell creation
- Opening and lip generation
- Rake angle (forward tilt) implementation
- Edge rounding strategies

### [`shell-parameters.md`](shell-parameters.md)
**Shell Parameter Reference**

Complete reference for shell generation parameters.

**Key parameters:**
- Dimensional: `width`, `height`, `depth`
- Structural: `wall`, `corner_radius`, `rake_angle`
- Opening: `opening_width`, `opening_height`, `lip_depth`, `lip_width`

### [`locations.md`](locations.md)
**Code Location Index**

Maps shell concepts to actual implementation files.

## Shell Types

### Implemented
- **Monolithic Shell** - Single-piece hollow enclosure with optional opening
- **Wedge Shell** - Tapered enclosure with two taper styles (top/front)

### Planned
- **Split Shell** - Two-piece design with seam

## Key Patterns

### Hollowing Pattern
```openscad
diff()
cuboid([width, depth, height], rounding=corner_radius, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([width-wall*2, depth-wall*2, height], rounding=corner_radius-wall, anchor=TOP);
}
```

### Opening with Lip Pattern
```openscad
// Main opening (full depth)
tag("remove") attach(FWD)
    cuboid([opening_width, wall*2, opening_height], anchor=FWD);

// Lip rebate (partial depth)
tag("remove") attach(FWD)
    cuboid([opening_width+lip_width*2, lip_depth, opening_height+lip_width*2], anchor=FWD);
```

## Navigation

**Up:** [`../index.md`](../index.md) - Domains overview

**Related Domains:**
- [`../faceplates/`](../faceplates/index.md) - Faceplates attach to shells
- [`../hardware/`](../hardware/index.md) - Hardware mounts in shells

**Related Documents:**
- [`../../decisions/001-bosl2-attachment-system.md`](../../decisions/001-bosl2-attachment-system.md) - Why we use attachable()
- [`../../cross-domain/interface-contracts.md`](../../cross-domain/interface-contracts.md) - Shell-faceplate interface

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Domain Type:** Core structural domain
