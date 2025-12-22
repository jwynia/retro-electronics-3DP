# ADR-004: Braun/Rams Aesthetic Boundaries

## Status
**Accepted** - Project inception

## Context

RetroCase could support any aesthetic - modern, industrial, ornate, etc. However, a coherent design language makes the library more useful and the outputs more visually consistent.

The question is: what aesthetic constraints should RetroCase modules follow?

## Decision

**Constrain the design language** to a specific set of influences:

1. **Braun/Dieter Rams** - Clean geometry, functional minimalism
2. **1970s Japanese electronics** - Warm materials, integrated speakers
3. **Space Age/Atomic design** - Tapered forms, organic curves

Modules should produce outputs that look like they could have come from these eras.

## Rationale

### Coherent Visual Identity
All RetroCase outputs look like they belong together. Users can combine shells and faceplates freely and get harmonious results.

### Design Guidance
Constraints are liberating. By limiting the aesthetic, design decisions become easier. "Does this look like a Braun product?" is a clear test.

### Target Audience Alignment
RetroCase targets makers who appreciate retro aesthetics. This is the look they want.

### Timeless Quality
The Braun/Rams aesthetic has aged well. Designs from the 1960s-70s still look modern. This gives RetroCase outputs longevity.

## Specific Guidelines

### Geometry
- **Rounded corners** everywhere (no sharp edges)
- **Consistent radii** within a design
- **Tapered forms** are encouraged (wedge shapes)
- **Grid-based layouts** for controls

### Proportions
- **Horizontal orientation** preferred for table-top devices
- **Generous bezels** around screens
- **Balanced weight** (not top-heavy)

### Not Allowed
- Sharp 90-degree edges
- Excessive ornamentation
- Aggressive angles (except controlled rake)
- Visible screw heads on face

## Aesthetic Reference Points

### Braun Products
- RT 20 radio (Hans Gugelot, 1961)
- T 1000 world receiver (Dieter Rams, 1963)
- SK 4 record player (Dieter Rams, 1956)

### Japanese Electronics
- JVC Video Sphere (1970)
- Sanyo RP-1900 radio (1970s)
- Panasonic flip clocks (various)

### Space Age
- Weltron 2001 (1970)
- JVC Videosphere (1970)
- Early Apple products (pre-1985)

## Alternatives Considered

### No Aesthetic Constraints
- **Pro:** Maximum flexibility
- **Con:** Inconsistent outputs
- **Con:** No design guidance
- **Rejected:** Core value of RetroCase is the aesthetic

### Modern/Industrial Aesthetic
- **Pro:** Popular current style
- **Con:** Doesn't differentiate from other case generators
- **Con:** Not what "retro" suggests
- **Rejected:** Conflicts with project name and purpose

### Multiple Aesthetic Modes
- **Pro:** Broader appeal
- **Con:** Complexity explosion
- **Con:** Modules might not compose across modes
- **Rejected:** Better to do one aesthetic well

## Consequences

### Positive
- Strong visual identity
- Clear design guidance
- Outputs work together
- Appeals to target audience

### Negative
- Not suitable for all use cases
- May feel limiting to some users
- Aesthetic is somewhat subjective

### Mitigation
- Document the aesthetic clearly with examples
- Provide reference images in `reference/`
- Allow users to fork and modify for different aesthetics

## Implementation Notes

### Parameter Ranges
Some parameters have implicit limits:
- `corner_radius` - typically 5-15mm (no sharp corners)
- `rake_angle` - typically 5-20° (subtle tilt)
- Wall thickness - sufficient for visual solidity

### Visual Testing
When reviewing modules, ask:
- "Would Dieter Rams approve?"
- "Could this sit next to a Braun radio?"
- "Does it have the right 'weight'?"

## Related Decisions
- [[002-magnetic-closure-design]] - Clean faces fit aesthetic
- [[003-module-organization]] - All modules share this aesthetic

## Navigation

**Up:** [`index.md`](index.md) - Decisions overview

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Category:** Design Philosophy
- **Impact:** All visual design, parameter ranges, documentation
