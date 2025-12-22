# ADR-002: Magnetic Closures Over Screws

## Status
**Accepted** - Project inception

## Context

Face plates need to attach to shells. Common approaches include:
1. **Threaded screws** - Traditional, secure, requires tools
2. **Snap-fit clips** - Tool-free, but can wear out or break
3. **Magnetic attachment** - Tool-free, durable, but requires hardware

RetroCase targets makers who want easy access to internals and the ability to swap face plates.

## Decision

**Use disc magnets paired with steel discs** for shell-to-faceplate attachment.

Configuration:
- **Shell side:** Magnet pockets in lip area (magnets glued in)
- **Faceplate side:** Steel disc pockets (steel discs glued in)
- **Standard placement:** Four corners, inset from edges

Magnet attracts steel, holding faceplate in place.

## Rationale

### Tool-Free Assembly
Users can remove faceplates with bare hands. No screwdrivers needed. This matches the retro aesthetic where devices had user-accessible components.

### Interchangeability
Steel discs work with any magnet orientation. Users can swap faceplates between shells without polarity concerns.

### Durability
Unlike snap clips, magnets don't wear out. The magnetic hold remains consistent over thousands of cycles.

### Aesthetic
No visible screw heads on the face. Clean, retro-appropriate appearance.

### Cost
Small disc magnets are inexpensive (~$0.10-0.30 each). Steel washers are even cheaper.

## Alternatives Considered

### Threaded Screws
- **Pro:** Very secure, widely understood
- **Con:** Requires tools for access
- **Con:** Visible screw heads on face
- **Con:** Threads can strip in plastic
- **Rejected:** Conflicts with tool-free access goal

### Magnet-to-Magnet
- **Pro:** Slightly stronger hold
- **Con:** Polarity must match (assembly complexity)
- **Con:** Risk of repulsion if installed wrong
- **Con:** Double the magnet cost
- **Rejected:** Steel is simpler and cheaper

### Snap-Fit Clips
- **Pro:** No additional hardware needed
- **Con:** Can break or wear out
- **Con:** Harder to design for 3D printing
- **Con:** May require specific orientations
- **Rejected:** Durability concerns

### Friction Fit
- **Pro:** Simplest design
- **Con:** Inconsistent due to printing tolerances
- **Con:** Wears out over time
- **Con:** Can be too tight or too loose
- **Rejected:** Too unreliable

## Consequences

### Positive
- Clean aesthetic (no visible hardware)
- Easy access to internals
- Faceplates are interchangeable
- Durable over many cycles
- Satisfying tactile feedback when attaching

### Negative
- Requires purchasing magnets and steel discs
- Assembly requires gluing hardware
- Magnetic fields may affect some electronics (rare)
- Extra design complexity for pocket placement

### Mitigation
- Document recommended magnet sources
- Specify pocket tolerances for reliable fit
- Note which electronics are magnet-sensitive
- Provide clear assembly instructions

## Specifications

### Recommended Magnets
| Size | Use Case |
|------|----------|
| 6mm × 2mm | Small enclosures |
| 8mm × 3mm | Standard enclosures |
| 10mm × 3mm | Large enclosures |

### Pocket Tolerances
- Diameter: magnet/steel + 0.3mm
- Depth: component + 0.1mm (flush fit)

## Related Decisions
- [[001-bosl2-attachment-system]] - Attachment points defined consistently
- [[004-design-language-constraints]] - Clean face is aesthetic requirement

## Navigation

**Up:** [`index.md`](index.md) - Decisions overview

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Category:** Hardware Design
- **Impact:** Shells, faceplates, hardware modules
