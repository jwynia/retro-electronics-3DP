# Hardware Targets

## Purpose
Specifications for target hardware platforms - the electronics RetroCase is designed to house.

## Classification
- **Domain:** Planning
- **Stability:** Semi-stable (new boards added over time)
- **Abstraction:** Reference data
- **Confidence:** Established (measured dimensions)

## Raspberry Pi Family

### Raspberry Pi Zero / Zero W / Zero 2 W
| Dimension | Value |
|-----------|-------|
| Length | 65mm |
| Width | 30mm |
| Height | 5mm (board only) |
| Mounting holes | 58mm × 23mm pattern |
| Hole diameter | 2.75mm |
| USB | Micro-USB (x2) |
| HDMI | Mini-HDMI |

### Raspberry Pi 3 Model B / B+
| Dimension | Value |
|-----------|-------|
| Length | 85mm |
| Width | 56mm |
| Height | 17mm (with ports) |
| Mounting holes | 58mm × 49mm pattern |
| Hole diameter | 2.75mm |
| USB | USB-A (x4) |
| HDMI | Full-size HDMI |

### Raspberry Pi 4 Model B
| Dimension | Value |
|-----------|-------|
| Length | 85mm |
| Width | 56mm |
| Height | 17mm (with ports) |
| Mounting holes | 58mm × 49mm pattern |
| Hole diameter | 2.75mm |
| USB | USB-A (x2), USB-C power |
| HDMI | Micro-HDMI (x2) |

### Raspberry Pi 5
| Dimension | Value |
|-----------|-------|
| Length | 85mm |
| Width | 56mm |
| Height | ~20mm (with cooler) |
| Mounting holes | 58mm × 49mm pattern |
| Hole diameter | 2.75mm |
| USB | USB-A (x2), USB-C power |
| Power | USB-C (5V/5A recommended) |

## ESP32 Development Boards

### ESP32 DevKit V1 (30-pin)
| Dimension | Value |
|-----------|-------|
| Length | 52mm |
| Width | 28mm |
| Height | 8mm |
| Pin spacing | 25.4mm (1 inch) |
| Mounting holes | None (use clips) |

### ESP32-S3 DevKit
| Dimension | Value |
|-----------|-------|
| Length | 70mm |
| Width | 25mm |
| Height | 8mm |
| Mounting holes | None (use clips) |

### ESP32-C3 SuperMini
| Dimension | Value |
|-----------|-------|
| Length | 22mm |
| Width | 18mm |
| Height | 6mm |
| Mounting holes | None (very compact) |

## Arduino Boards

### Arduino Uno R3
| Dimension | Value |
|-----------|-------|
| Length | 68.6mm |
| Width | 53.4mm |
| Height | 15mm |
| Mounting holes | 4 holes (irregular pattern) |
| Hole positions | See diagram |

### Arduino Nano
| Dimension | Value |
|-----------|-------|
| Length | 45mm |
| Width | 18mm |
| Height | 8mm |
| Mounting holes | None (use clips) |

### Arduino Micro / Pro Micro
| Dimension | Value |
|-----------|-------|
| Length | 48mm / 33mm |
| Width | 18mm / 18mm |
| Height | 8mm |
| Mounting holes | None (use clips) |

## Display Panels

### Official Raspberry Pi 7" Touchscreen
| Dimension | Value |
|-----------|-------|
| Visible area | 155mm × 86mm |
| Total size | 194mm × 110mm |
| Mounting | 4 corner holes |
| Depth | ~20mm with driver board |

### 3.5" IPS Display (Various)
| Dimension | Value |
|-----------|-------|
| Visible area | ~76mm × 63mm |
| Total size | Varies by model |
| Interface | SPI or HDMI |
| Typical depth | 5-10mm |

### 5" HDMI Display
| Dimension | Value |
|-----------|-------|
| Visible area | ~108mm × 65mm |
| Total size | ~120mm × 75mm |
| Interface | HDMI |
| Depth | ~15mm |

## Audio Components

### 3" Full-Range Speaker
| Dimension | Value |
|-----------|-------|
| Diameter | 77mm (frame) |
| Mounting holes | ~66mm circle |
| Depth | ~30mm |
| Cutout | 65-70mm diameter |

### MAX98357A Amplifier
| Dimension | Value |
|-----------|-------|
| Length | 27mm |
| Width | 21mm |
| Height | 3mm |
| Mounting | Through-holes at corners |

### TPA3116D2 Amplifier Board
| Dimension | Value |
|-----------|-------|
| Length | ~60mm |
| Width | ~60mm |
| Height | ~25mm (with heatsink) |
| Mounting | 4 corner holes |

## Magnets and Hardware

### Disc Magnets (Recommended)
| Size | Pull Force | Use Case |
|------|------------|----------|
| 6mm × 2mm | ~0.5 kg | Small enclosures |
| 8mm × 3mm | ~1 kg | Standard |
| 10mm × 3mm | ~1.5 kg | Large enclosures |

### Steel Discs
Match magnet diameter, 1mm thickness typical.

### Self-Tapping Screws
| Size | Hole Diameter | Use |
|------|---------------|-----|
| M2 | 1.8-2.0mm | Small standoffs |
| M2.5 | 2.2-2.5mm | Standard standoffs |
| M3 | 2.7-3.0mm | Larger mounts |

## External Libraries

For precise mounting patterns:
- **NopSCADlib** - Comprehensive PCB library
- **PiHoles** - Raspberry Pi specific
- **SBC_Case_Builder** - Various SBC patterns

## Adding New Hardware

To add new hardware to this reference:
1. Measure actual board (not datasheet - tolerances vary)
2. Document all mounting hole positions
3. Note port locations and clearances
4. Add any special considerations
5. Update this file

## Navigation

**Up:** [`index.md`](index.md) - Planning overview

**Related:**
- [`module-roadmap.md`](module-roadmap.md) - Mounting modules
- [`preset-catalog.md`](preset-catalog.md) - Designs using this hardware
- [`../domains/hardware/mounting-hardware.md`](../domains/hardware/mounting-hardware.md) - Mounting patterns

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Reference Data
