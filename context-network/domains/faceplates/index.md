# Faceplates Domain

## Purpose
This domain covers face plate generation - the front panels that attach to shells. Faceplates include screen bezels, blank control panels, and grille patterns for speakers.

## Classification
- **Domain:** Face Plate Generation
- **Stability:** Core (fundamental to project)
- **Abstraction:** Structural patterns
- **Confidence:** Established

## Documents

### [`bezel-faceplates.md`](bezel-faceplates.md)
**Screen Bezel Patterns**

Face plates designed for screen mounting with proper bezels and mounting features.

**Key topics:**
- Bezel depth and edge design
- Screen opening specifications
- Corner radius coordination with shells
- Magnet pocket integration

### [`blank-faceplates.md`](blank-faceplates.md)
**Blank Control Panel Patterns**

Solid face plates for control panel builds with knobs, switches, and buttons.

**Key topics:**
- Blank panel generation
- Control cutout patterns
- Speaker grille integration
- Magnet pocket placement

### [`locations.md`](locations.md)
**Code Location Index**

Maps faceplate concepts to actual implementation files.

## Faceplate Types

### Implemented
- **Bezel Faceplate** - Screen mount with bezel edge
- **Blank Faceplate** - Solid panel for controls

### Planned
- **Grille Faceplate** - Speaker grille patterns
- **Mixed Faceplate** - Combined screen and controls

## Key Patterns

### Basic Faceplate with Magnet Pockets
```openscad
diff()
cuboid([width, depth, height], rounding=corner_radius, edges="Z", anchor=BOT) {
    // Screen opening
    tag("remove") attach(FWD)
        cuboid([screen_width, depth*2, screen_height], anchor=FWD);

    // Magnet pockets at corners
    tag("remove") position(TOP+LEFT+FWD)
        cyl(d=magnet_dia, h=magnet_depth, anchor=TOP);
    // ... repeat for other corners
}
```

### Attachment to Shell
Faceplates are designed to sit in the shell's lip rebate. The faceplate's outer dimensions match the shell's opening + lip_width on each side.

## Design Coordination

### Shell-Faceplate Interface
- Faceplate width = `opening_width + lip_width * 2`
- Faceplate height = `opening_height + lip_width * 2`
- Faceplate depth = `lip_depth`

### Magnet Placement
- Magnets in faceplate align with steel discs in shell
- Standard inset: `mounting_inset` from corners

## Navigation

**Up:** [`../index.md`](../index.md) - Domains overview

**Related Domains:**
- [`../shells/`](../shells/index.md) - Shells that faceplates attach to
- [`../hardware/`](../hardware/index.md) - Magnet pockets and mounting

**Related Documents:**
- [`../../decisions/002-magnetic-closure-design.md`](../../decisions/002-magnetic-closure-design.md) - Why magnetic attachment
- [`../../cross-domain/interface-contracts.md`](../../cross-domain/interface-contracts.md) - Shell-faceplate interface

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Domain Type:** Core structural domain
