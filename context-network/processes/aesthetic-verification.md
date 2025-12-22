# Aesthetic Verification Process

## Purpose
A systematic approach to verify that RetroCase designs achieve their intended retro aesthetic.

## Classification
- **Domain:** Processes
- **Stability:** Evolving
- **Abstraction:** Practical workflow
- **Confidence:** Established approach, criteria evolving

## The Problem

We can render PNGs and view them, but need a way to verify:
1. Does this look like the intended design pattern?
2. Are the proportions correct for the aesthetic?
3. Would this pass as "authentically retro"?

## Verification Approach

### 1. Measurable Criteria (Objective)
Each design pattern has quantifiable parameters that can be checked:

| Criterion | How to Verify |
|-----------|---------------|
| Proportions (W:H:D ratio) | Calculate from dimensions |
| Corner radius ratio | radius / smallest_dimension |
| Rake angle | Measure from profile |
| Grille coverage | grille_area / face_area |

### 2. Visual Comparison (Subjective)
Compare renders against reference images:

```
┌──────────────┬──────────────┐
│  Reference   │   Render     │
│    Image     │   Output     │
└──────────────┴──────────────┘
```

### 3. Checklist Review (Structured)
Pattern-specific checklists (see below)

---

## Pattern Checklists

### Braun Box Pattern

**Dimensions Check:**
- [ ] Width:Height ratio between 1.2:1 and 2:1
- [ ] Depth:Height ratio between 0.6:1 and 1:1
- [ ] Corner radius 5-10% of smallest dimension

**Visual Check:**
- [ ] Corners appear "subtle but present" (not sharp, not bulbous)
- [ ] Overall impression: "calm", "organized", "functional"
- [ ] No decorative elements beyond functional ones

**Grille Check (if present):**
- [ ] Horizontal slots, not vertical
- [ ] Slot spacing appears even
- [ ] Grille doesn't dominate the face (40-60% coverage max)

**Control Layout (if present):**
- [ ] Controls grouped logically
- [ ] Clear visual hierarchy
- [ ] Adequate spacing between elements

---

### Olivetti Wedge Pattern

**Dimensions Check:**
- [ ] Rake angle between 12° and 25°
- [ ] Front height ≤ 50% of back height
- [ ] Corner radius 8-15% of smallest dimension (larger than Braun)

**Visual Check:**
- [ ] Profile clearly "leans forward"
- [ ] Surfaces flow into each other (no harsh transitions)
- [ ] Overall impression: "sculptural", "organic", "inviting"

**Display Angle (if present):**
- [ ] Screen tilted 15-30° toward viewer
- [ ] Display feels "presented" not "flat"

---

### Space Age Sphere Pattern

**Dimensions Check:**
- [ ] Shape is clearly spherical or elliptical
- [ ] Opening is "visor-like" (90-150° arc)
- [ ] Opening height 40-60% of diameter

**Visual Check:**
- [ ] Feels like a "pod" or "helmet"
- [ ] Overall impression: "futuristic", "playful", "self-contained"
- [ ] No sharp edges visible

**Mount Check:**
- [ ] Mount style matches era (chain, pedestal, or integrated)
- [ ] Mount doesn't visually compete with sphere

---

### Danish Slab Pattern

**Dimensions Check:**
- [ ] Width:Height ratio ≥ 3:1 (distinctly horizontal)
- [ ] Overall height < 100mm (thin profile)
- [ ] Corner radius ≤ 5% of height (subtle or sharp)

**Visual Check:**
- [ ] Horizontal emphasis is unmistakable
- [ ] Overall impression: "sleek", "premium", "understated"
- [ ] Could plausibly stack with other units

---

## Verification Workflow

### Step 1: Identify Target Pattern
Before rendering, document which pattern(s) the design targets:
```
Target: Braun Box
Secondary influence: None
```

### Step 2: Render Multiple Views
```bash
./scripts/render.sh mydesign.scad front
./scripts/render.sh mydesign.scad iso
./scripts/render.sh mydesign.scad top
```

### Step 3: Run Checklist
Go through the pattern checklist above, checking each item.

### Step 4: Compare to Reference (if available)
If reference images exist in `reference/`:
1. Open reference image
2. Open render
3. Compare proportions, curves, details

### Step 5: Document Issues
If checklist items fail, document:
- What failed
- How to fix (parameter adjustment)
- Whether it's a fundamental design issue or tweakable

---

## Adding Reference Images

To improve verification, add reference images to `reference/`:

### Finding Images
```bash
# Search for product images
deno run --allow-net --allow-env scripts/research/tavily-cli.ts \
  "Braun RT 20 radio high resolution" --results 5

# Check Wikipedia for product photos (often CC licensed)
# Note: Verify licensing before adding to repo
```

### Image Organization
```
reference/
├── braun-box/
│   ├── rt20-front.jpg
│   ├── rt20-side.jpg
│   └── sk4-perspective.jpg
├── olivetti-wedge/
│   ├── divisumma18-side.jpg
│   └── logos55-front.jpg
└── space-age/
    ├── videosphere-front.jpg
    └── weltron-side.jpg
```

### Image Naming
`product-view-detail.jpg`
- `rt20-front.jpg`
- `divisumma18-side-profile.jpg`

---

## Automated Checks (Future)

Potential automated verification:

### Proportion Extraction
```openscad
// Add to any module for verification output
echo(str("WIDTH_HEIGHT_RATIO=", width/height));
echo(str("CORNER_RADIUS_RATIO=", corner_r/min(width,height)));
echo(str("RAKE_ANGLE=", rake_angle));
```

### Render Script Enhancement
```bash
# Future: render.sh --verify pattern
# Outputs: render + checklist results
```

---

## When Verification Fails

If a design doesn't match the aesthetic:

1. **Parameter Adjustment** - Try adjusting radii, angles, proportions
2. **Pattern Mismatch** - Maybe it's actually a different pattern
3. **Hybrid Design** - Document it as intentionally mixing patterns
4. **New Pattern** - If it's coherent but different, document as new pattern

---

## Navigation

**Up:** [`index.md`](index.md) - Processes overview

**Related:**
- [`../domains/design-language/parametric-patterns.md`](../domains/design-language/parametric-patterns.md) - Pattern definitions
- [`testing-rendering.md`](testing-rendering.md) - Render workflow
- [`code-review-checklist.md`](code-review-checklist.md) - Code review (includes aesthetic check)

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Process Guide
