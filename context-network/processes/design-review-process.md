# Design Review Process

## Purpose
A structured process for reviewing RetroCase designs to verify both technical correctness and aesthetic fidelity to target patterns.

## Classification
- **Domain:** Processes
- **Stability:** Evolving
- **Abstraction:** Practical workflow
- **Confidence:** Established approach

## When to Use This Process

Use design review when:
- Creating a new shell or preset
- Modifying existing designs significantly
- Before committing designs to the repository
- When a design "looks wrong" but you're not sure why

## The Review Process

### Phase 1: Technical Review

**1.1 Code Quality**
- [ ] Module follows BOSL2 idioms (attachment system, diff/tag)
- [ ] Parameters are documented with types and ranges
- [ ] No hardcoded magic numbers (use named variables)
- [ ] Follows project naming conventions

**1.2 Render Verification**
```bash
# Render multiple views
./scripts/render.sh mydesign.scad front
./scripts/render.sh mydesign.scad iso
./scripts/render.sh mydesign.scad top
```

- [ ] All views render without errors
- [ ] No z-fighting or geometry artifacts
- [ ] Preview (F5) matches final render (F6)

**1.3 Dimensional Validation**
```openscad
// Add to module for verification output
echo(str("DIMENSIONS: ", width, " x ", height, " x ", depth));
echo(str("CORNER_RADIUS: ", corner_radius));
echo(str("WALL_THICKNESS: ", wall));
```

- [ ] Wall thickness is printable (≥2mm for FDM)
- [ ] Rounding doesn't exceed smallest dimension
- [ ] Opening allows intended hardware to fit

### Phase 2: Aesthetic Review

**2.1 Identify Target Pattern**

Document which aesthetic pattern the design targets:
```
Primary Pattern: [Braun Box | Olivetti Wedge | Space Age Sphere | Danish Slab]
Secondary Influence: [Optional]
Custom/Hybrid: [If not following standard pattern]
```

**2.2 Run Pattern Checklist**

Use the appropriate checklist from [`aesthetic-verification.md`](aesthetic-verification.md):
- Braun Box checklist
- Olivetti Wedge checklist
- Space Age Sphere checklist
- Danish Slab checklist

**2.3 Calculate Verification Metrics**

From [`../domains/design-language/parametric-patterns.md`](../domains/design-language/parametric-patterns.md):

| Pattern | Key Metrics |
|---------|-------------|
| Braun Box | W:H 1.2-2:1, D:H 0.6-1:1, radius 5-10% |
| Olivetti Wedge | Rake 12-25°, F:B height 0.3-0.5:1 |
| Space Age Sphere | Opening 40-60% of diameter |
| Danish Slab | W:H ≥3:1, height ≤100mm |

```openscad
// Add to verify pattern compliance
width_height_ratio = width / height;
echo(str("W:H RATIO: ", width_height_ratio));
assert(width_height_ratio >= 1.2 && width_height_ratio <= 2.0,
       "Width:Height ratio outside Braun Box range");
```

**2.4 Visual Comparison**

If reference images exist in `reference/`:
1. Open reference image alongside render
2. Compare proportions, curves, details
3. Note any significant deviations

### Phase 3: Integration Review

**3.1 Component Compatibility**
- [ ] Face plate fits correctly in opening
- [ ] Hardware mounting points align
- [ ] Magnet pockets accessible and aligned

**3.2 Print Orientation**
- [ ] Design can print without supports (preferred)
- [ ] If supports needed, removal won't damage visible surfaces
- [ ] Overhangs ≤45° where possible

**3.3 Assembly Verification**
- [ ] Face plate attaches/detaches smoothly
- [ ] Internal components have clearance
- [ ] Cable routing paths are clear

---

## Review Outcomes

### Pass
Design meets all technical and aesthetic criteria. Ready for commit.

### Pass with Notes
Design acceptable but with documented compromises:
- "Corner radius reduced for printability"
- "Hybrid style between Braun and Danish"

### Needs Revision
Document specific issues:
```
REVISION NEEDED:
- W:H ratio is 2.5:1, should be ≤2:1 for Braun Box
- Reduce width from 200mm to 180mm
```

### Requires Redesign
Fundamental issues that can't be fixed with parameter tweaks:
- Wrong pattern chosen for hardware requirements
- Proportions incompatible with intended aesthetic

---

## Quick Review Checklist

For fast reviews, verify these minimum criteria:

**Technical:**
- [ ] Renders without errors
- [ ] Wall thickness ≥2mm
- [ ] No rounding > dimension errors

**Aesthetic:**
- [ ] Target pattern documented
- [ ] Key ratio within valid range
- [ ] Visual impression matches pattern description

**Integration:**
- [ ] Face plate fits
- [ ] Printable orientation exists

---

## Recording Review Results

Document review in the design file header:

```openscad
/*
 * Design: braun_style_radio_shell
 * Pattern: Braun Box
 *
 * Review: 2025-12-22
 * - W:H ratio: 1.6:1 (valid: 1.2-2:1) ✓
 * - D:H ratio: 0.8:1 (valid: 0.6-1:1) ✓
 * - Corner radius: 8% (valid: 5-10%) ✓
 * - Printable without supports ✓
 *
 * Notes: Slightly wider than typical RT 20
 */
```

---

## Navigation

**Up:** [`index.md`](index.md) - Processes overview

**Related:**
- [`aesthetic-verification.md`](aesthetic-verification.md) - Pattern-specific checklists
- [`testing-rendering.md`](testing-rendering.md) - Render workflow
- [`code-review-checklist.md`](code-review-checklist.md) - Code quality checks
- [`../domains/design-language/parametric-patterns.md`](../domains/design-language/parametric-patterns.md) - Pattern definitions

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Process Guide
