# Magnetic Attachment System

## Purpose
Documentation of the magnet/steel disc attachment system used to connect faceplates to shells.

## Classification
- **Domain:** Hardware
- **Stability:** Established
- **Abstraction:** Specification and pattern
- **Confidence:** High

## System Overview

RetroCase uses a magnetic attachment system for connecting faceplates to shells:

- **Shell side:** Magnet pockets containing disc magnets
- **Faceplate side:** Steel disc pockets containing steel washers/discs
- **Connection:** Magnets attract steel discs, holding faceplate in place

## Why Magnets + Steel?

Using magnets paired with steel (rather than magnets paired with magnets) provides:

1. **No polarity matching** - Steel works regardless of magnet orientation
2. **Interchangeability** - Any faceplate fits any compatible shell
3. **Simpler assembly** - No need to track magnet polarities
4. **Cost savings** - Steel discs are cheaper than magnets

## Recommended Components

### Disc Magnets

| Size | Use Case | Pull Force |
|------|----------|------------|
| 6mm × 2mm | Small enclosures | ~0.5 kg |
| 8mm × 3mm | Standard enclosures | ~1 kg |
| 10mm × 3mm | Large enclosures | ~1.5 kg |

**Material:** Neodymium (N35-N52)
**Note:** Higher N-rating = stronger but more brittle

### Steel Discs

| Size | Matching Magnet |
|------|-----------------|
| 6mm × 1mm | 6mm magnet |
| 8mm × 1mm | 8mm magnet |
| 10mm × 1mm | 10mm magnet |

**Material:** Mild steel or stainless steel
**Note:** Stainless has slightly less attraction but won't rust

## Pocket Specifications

### Magnet Pocket (in shell lip)
```openscad
// Pocket dimensions
pocket_dia = magnet_dia + 0.3;  // Slight press fit
pocket_depth = magnet_depth + 0.1;  // Flush or slightly recessed

cyl(d=pocket_dia, h=pocket_depth, anchor=BOT);
```

### Steel Disc Pocket (in faceplate)
```openscad
// Pocket dimensions
pocket_dia = steel_dia + 0.3;  // Slight press fit
pocket_depth = steel_depth + 0.1;  // Flush or slightly recessed

cyl(d=pocket_dia, h=pocket_depth, anchor=BOT);
```

## Placement Guidelines

### Corner Placement
Standard four-corner pattern:
```
+--------+
| M    M |   M = mounting point
|        |
|        |
| M    M |
+--------+
```

### Inset Calculation
```openscad
inset = 12;  // mm from corner
corner_x = width/2 - inset;
corner_y = height/2 - inset;

pocket_positions = [
    [ corner_x,  corner_y],  // Top-right
    [-corner_x,  corner_y],  // Top-left
    [-corner_x, -corner_y],  // Bottom-left
    [ corner_x, -corner_y]   // Bottom-right
];
```

### Inset Guidelines
| Faceplate Width | Recommended Inset |
|-----------------|-------------------|
| < 80mm | 8-10mm |
| 80-150mm | 10-15mm |
| > 150mm | 15-20mm |

## Alignment Considerations

### Shell-Faceplate Alignment
Magnets and steel discs must align when faceplate is seated:
- Magnet pockets in shell lip
- Steel pockets on faceplate back
- Same inset distance from edges

### Tolerance
- Pockets should be 0.3mm larger than components
- This allows press-fit insertion
- Components should be slightly recessed (0.1mm) or flush

## Assembly Process

1. **Insert magnets into shell lip pockets**
   - Apply small amount of cyanoacrylate (super glue)
   - Press magnet flush or slightly below surface
   - Let cure

2. **Insert steel discs into faceplate pockets**
   - Apply small amount of cyanoacrylate
   - Press disc flush
   - Let cure

3. **Test fit**
   - Place faceplate on shell
   - Should snap into place magnetically
   - Should be removable with firm pull

## Design Considerations

### Pocket Depth in Shell Lip
```
lip_depth ≥ faceplate_thickness + steel_depth + clearance
```

### Pocket Position in Faceplate
```
// Steel pockets on back face (facing shell)
position(BOT)  // BOT = back of faceplate
```

### Pocket Position in Shell
```
// Magnet pockets in lip rebate (facing out)
// Position depends on lip implementation
```

## Troubleshooting

### Weak Hold
- Check magnet grade (N35 vs N52)
- Check alignment of pockets
- Check for plastic between magnet and steel
- Consider larger magnets

### Misalignment
- Verify inset values match between shell and faceplate
- Check corner radius doesn't interfere

### Hard to Remove
- Reduce to 3 magnets instead of 4
- Use smaller magnets
- Increase clearance slightly

## Navigation

**Up:** [`index.md`](index.md) - Hardware domain overview

**Related:**
- [`mounting-hardware.md`](mounting-hardware.md) - Other mounting solutions
- [`../faceplates/bezel-faceplates.md`](../faceplates/bezel-faceplates.md) - Faceplate steel pockets
- [`../../decisions/002-magnetic-closure-design.md`](../../decisions/002-magnetic-closure-design.md) - Why magnetic attachment

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Specification
