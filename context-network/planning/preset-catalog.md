# Preset Catalog

## Purpose
Catalog of planned pre-configured complete designs for the `presets/` directory.

## Classification
- **Domain:** Planning
- **Stability:** Dynamic
- **Abstraction:** Product-level
- **Confidence:** Evolving

## What Are Presets?

Presets are complete, ready-to-use designs that combine:
- A specific shell configuration
- Matching faceplate(s)
- Hardware mounting for specific boards
- Documented print settings

Users can render and print presets directly, or use them as starting points for customization.

## Planned Presets

### Flip Clock Display

**Purpose:** Retro flip clock aesthetic for digital displays
**Target Hardware:**
- Raspberry Pi Zero W
- 3.5" IPS display
- Optional speaker

**Shell:** Wedge with ~15° rake
**Faceplate:** Bezel with large display opening
**Aesthetic:** JVC/Panasonic flip clock inspired

**Status:** Planned

---

### Table Radio

**Purpose:** Desktop speaker/radio enclosure
**Target Hardware:**
- ESP32 with audio codec
- 3" full-range speaker
- Rotary encoder + buttons

**Shell:** Monolithic with speaker grille area
**Faceplate:** Grille pattern + control holes
**Aesthetic:** Braun RT 20 inspired

**Status:** Planned

---

### Pi Display Stand

**Purpose:** Angled display for desk use
**Target Hardware:**
- Raspberry Pi 3/4/5
- Official 7" touchscreen
- Power from rear

**Shell:** Wedge with 30° angle
**Faceplate:** Bezel fitting 7" screen
**Aesthetic:** Clean, minimal

**Status:** Planned

---

### MIDI Controller

**Purpose:** Compact MIDI controller enclosure
**Target Hardware:**
- Arduino Micro/Pro Micro
- Rotary encoders (4)
- Buttons (8-16)
- OLED display (optional)

**Shell:** Low-profile monolithic
**Faceplate:** Control panel layout
**Aesthetic:** Vintage synthesizer

**Status:** Planned

---

### Amplifier Enclosure

**Purpose:** Desktop audio amplifier
**Target Hardware:**
- TPA3116/TDA7498 amp board
- Volume knob
- Input selector
- Power LED

**Shell:** Vented monolithic
**Faceplate:** Minimal controls + power indicator
**Aesthetic:** Braun-inspired

**Status:** Planned

---

### ESP32 Project Box

**Purpose:** General-purpose IoT enclosure
**Target Hardware:**
- ESP32 DevKit
- Various sensors/displays
- USB power

**Shell:** Compact monolithic
**Faceplate:** Customizable (blank with options)
**Aesthetic:** Retro tech

**Status:** Planned

## Preset File Structure

Each preset includes:
```
presets/flip-clock/
├── flip-clock.scad       # Main file with all components
├── shell.scad            # Shell configuration
├── faceplate.scad        # Faceplate configuration
├── hardware.scad         # Board mounting
├── README.md             # Print settings, BOM, assembly
└── renders/              # Reference images
    ├── assembled.png
    ├── exploded.png
    └── print-orientation.png
```

## Prioritization

| Preset | Priority | Reason |
|--------|----------|--------|
| Pi Display Stand | High | Common use case, good demo |
| Flip Clock Display | High | Iconic retro aesthetic |
| ESP32 Project Box | Medium | Versatile, popular board |
| Table Radio | Medium | Demonstrates audio features |
| Amplifier Enclosure | Medium | Audio enthusiast appeal |
| MIDI Controller | Lower | Niche but distinctive |

## Design Requirements

All presets must:
1. Use only RetroCase modules (no inline geometry)
2. Be fully parametric (board dimensions as variables)
3. Include complete documentation
4. Render without errors
5. Be printable without supports (preferred)
6. Follow the Braun/Rams aesthetic

## Contributing Presets

To propose a new preset:
1. Identify target hardware with exact dimensions
2. Sketch the aesthetic concept
3. List required modules (existing or planned)
4. Estimate complexity
5. Document in this catalog before implementing

## Navigation

**Up:** [`index.md`](index.md) - Planning overview

**Related:**
- [`module-roadmap.md`](module-roadmap.md) - Modules presets depend on
- [`hardware-targets.md`](hardware-targets.md) - Hardware specifications
- [`../foundation/project-definition.md`](../foundation/project-definition.md) - Target use cases

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Catalog
