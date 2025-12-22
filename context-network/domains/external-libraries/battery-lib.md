# Battery Library

## Purpose
Provides battery dimensions and models for designing battery compartments and holders.

## Classification
- **Domain:** External Libraries
- **Stability:** Stable
- **Abstraction:** Direct usage
- **Confidence:** Established

## Library Location
`lib/battery_lib/` (git submodule)

**Source:** [github.com/kartchnb/battery_lib](https://github.com/kartchnb/battery_lib)

## Usage

```openscad
include <battery_lib/battery_lib.scad>

// Generate a battery model
BatteryLib_GenerateBatteryModel("AA");

// Get dimensions for designing holders
aa_diameter = BatteryLib_BodyDiameter("AA");
aa_height = BatteryLib_TotalHeight("AA");
```

## Supported Battery Types

### Tube Batteries
| Name | Diameter | Height | Common Use |
|------|----------|--------|------------|
| `"AAAA"` | 8.3mm | 42.5mm | Styluses, small devices |
| `"AAA"` | 10.5mm | 44.5mm | Remotes, small electronics |
| `"AA"` | 14.5mm | 50.5mm | Most common |
| `"C"` | 26.2mm | 50mm | Medium devices |
| `"D"` | 34.2mm | 61.5mm | Large devices |
| `"18650"` | 18.6mm | 65.2mm | Lithium rechargeable |
| `"21700"` | 21mm | 70mm | High capacity Li-ion |
| `"26650"` | 26.5mm | 65.4mm | Large Li-ion |

### Rectangle Batteries
| Name | W x L x H | Common Use |
|------|-----------|------------|
| `"9V"` | 26.5 x 17.5 x 48.5mm | 9V applications |

### Button/Coin Batteries
| Name | Diameter | Height |
|------|----------|--------|
| `"CR2032"` | 20mm | 3.2mm |
| `"CR2025"` | 20mm | 2.5mm |
| `"CR2016"` | 20mm | 1.6mm |
| `"CR1220"` | 12mm | 2mm |
| `"LR44"` / `"AG13"` | 11.6mm | 5.4mm |

## Key Functions

### Dimension Functions
```openscad
// Get body dimensions
d = BatteryLib_BodyDiameter("AA");      // 14.5
h = BatteryLib_BodyHeight("AA");        // 48.5
total_h = BatteryLib_TotalHeight("AA"); // 50.5 (includes terminals)

// Get terminal dimensions
anode_d = BatteryLib_AnodeDiameter("AA");
anode_h = BatteryLib_AnodeHeight("AA");

// Get envelope (bounding box)
env = BatteryLib_Envelope("9V");  // [26.5, 17.5, 48.5]
```

### Validation
```openscad
if (BatteryLib_BatteryNameIsValid("AA")) {
    // Safe to use
}

// Get battery type
type = BatteryLib_Type("CR2032");  // "button"
```

## RetroCase Integration

### Battery Compartment Module
```openscad
include <BOSL2/std.scad>
include <battery_lib/battery_lib.scad>

module battery_compartment(
    battery = "AA",
    count = 2,
    wall = 2,
    spring_allowance = 3  // Extra length for spring contacts
) {
    d = BatteryLib_BodyDiameter(battery);
    h = BatteryLib_TotalHeight(battery) + spring_allowance;

    inner_w = d + 1;  // Slight clearance
    inner_l = count * inner_w;

    diff()
    cuboid([inner_l + wall*2, inner_w + wall*2, h + wall], anchor=BOT) {
        tag("remove")
        position(TOP)
        cuboid([inner_l, inner_w, h + 0.1], anchor=TOP);
    }
}
```

### Retro Radio Battery Bay
```openscad
// Classic 4xAA compartment
module retro_battery_bay() {
    aa_d = BatteryLib_BodyDiameter("AA");
    aa_h = BatteryLib_TotalHeight("AA");

    // 2x2 arrangement
    for (x = [-1, 1], y = [-1, 1]) {
        translate([x * (aa_d + 2) / 2, y * (aa_d + 2) / 2, 0])
        cylinder(d = aa_d + 0.5, h = aa_h + 5, $fn = 32);
    }
}
```

## Comparison with NopSCADlib

| Feature | battery_lib | NopSCADlib |
|---------|-------------|------------|
| Battery models | Yes | Yes |
| Dimension functions | Extensive | Basic |
| Button cells | Yes | No |
| Spring contacts | No | Yes |
| Holder designs | No | No |

**Recommendation:** Use battery_lib for dimensions and compartment design, NopSCADlib for visualizing batteries with contacts in renders.

## Navigation

**Up:** [`index.md`](index.md) - External Libraries overview

**Related:**
- [`nopscadlib.md`](nopscadlib.md) - NopSCADlib battery contacts
- [`../../domains/hardware/`](../../domains/hardware/index.md) - Internal mounting

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Integration Guide
