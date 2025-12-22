# Project Definition - What is RetroCase?

## Purpose
RetroCase is a parametric OpenSCAD library for generating retro-styled electronics enclosures. It provides modular, composable components for creating custom cases with a cohesive retro aesthetic.

## Classification
- **Domain:** Project identity and vision
- **Stability:** Stable (core identity)
- **Abstraction:** Conceptual
- **Confidence:** Established

## Vision Statement

Create a library that enables makers and designers to produce custom electronics enclosures that look like they belong in a 1970s living room or office - clean, functional, and timelessly styled.

## Design Language

RetroCase draws from three distinct but compatible aesthetic traditions:

### Braun/Dieter Rams
- Clean, geometric forms
- Consistent corner radii throughout
- Functional minimalism
- Grid-based layouts
- Muted, sophisticated colors

### 1970s Japanese Consumer Electronics
- JVC, Sanyo, Panasonic design language
- Flip clocks and table radios
- Warm plastics (cream, orange, brown)
- Integrated speaker grilles
- Bold number displays

### Space Age/Atomic Design
- Tapered, wedge-shaped forms
- Organic curves and fillets
- Bold color accents
- Forward-facing angles (rake)
- Sculptural presence

## Primary Use Cases

### Screen-Centric Builds
Enclosures designed around a display panel as the primary interface.

**Examples:**
- LCD panel frames
- Phone docking stations
- Tablet stands
- Raspberry Pi displays
- Retro clock displays

### Control Panel Builds
Enclosures with physical controls as the primary interface.

**Examples:**
- Amplifier housings
- Control consoles
- MIDI controller cases
- Home automation panels
- Radio receiver cases

### Internal Mounting
Enclosures designed to house specific electronics.

**Target hardware:**
- Raspberry Pi (Zero, 3, 4, 5)
- ESP32 development boards
- Arduino Uno/Nano
- Audio amplifier modules
- Custom PCBs

## Key Principles

### Parametric First
Every module accepts parameters for customization. No magic numbers. Users can adapt any design to their specific needs.

### Composability
Modules work together. A shell from one design can accept faceplates from another. Hardware mounting is standardized.

### BOSL2 Foundation
Built entirely on BOSL2's attachment system. This provides consistent anchoring, positioning, and geometric operations across all modules.

### Magnetic Attachment
Face plates attach to shells using disc magnets paired with steel discs. This enables:
- Tool-free assembly
- Easy component access
- Swappable face plates
- No alignment hassle (magnets self-center)

### Print-Ready Output
Designs are optimized for FDM 3D printing:
- Appropriate minimum wall thicknesses
- Printable overhangs
- Support-minimizing orientations
- Reasonable corner radii

## Target Audience

### Primary
- Makers building custom electronics enclosures
- Designers who appreciate retro aesthetics
- OpenSCAD users familiar with parametric design

### Secondary
- Prop makers and cosplayers
- Retro computing enthusiasts
- Product designers prototyping concepts

## What RetroCase Is NOT

- A general-purpose CAD library (use BOSL2 directly)
- A case generator for specific products (we're parametric, not product-specific)
- An STL file repository (we provide code, not pre-made models)

## Navigation

**Up:** [`index.md`](index.md) - Foundation overview

**Related:**
- [`architecture.md`](architecture.md) - How RetroCase is structured
- [`development-principles.md`](development-principles.md) - How we develop
- [`../decisions/004-design-language-constraints.md`](../decisions/004-design-language-constraints.md) - Aesthetic boundaries ADR

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Foundation - Project Identity
