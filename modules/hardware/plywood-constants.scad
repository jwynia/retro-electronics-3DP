// Plywood and Sheet Material Constants
// Actual thickness values for common nominal sizes.
// US plywood nominal sizes differ from actual thickness!

// === US NOMINAL PLYWOOD (actual measurements in mm) ===
// Standard softwood plywood from big-box stores

PLY_1_8 = 3.2;    // 1/8" nominal = ~1/8" actual (3.2mm)
PLY_1_4 = 5.5;    // 1/4" nominal = 7/32" actual (5.5mm)
PLY_3_8 = 8.7;    // 3/8" nominal = 11/32" actual (8.7mm)
PLY_1_2 = 11.9;   // 1/2" nominal = 15/32" actual (11.9mm)
PLY_5_8 = 15.1;   // 5/8" nominal = 19/32" actual (15.1mm)
PLY_3_4 = 18.3;   // 3/4" nominal = 23/32" actual (18.3mm)

// === METRIC PLYWOOD (actual measurements in mm) ===
// Baltic birch and metric sheet goods

PLY_3MM = 3;
PLY_4MM = 4;
PLY_6MM = 6;
PLY_9MM = 9;
PLY_12MM = 12;
PLY_15MM = 15;
PLY_18MM = 18;

// === MDF (Medium Density Fiberboard) ===
// MDF is usually close to nominal size

MDF_1_4 = 6.35;   // 1/4" = 6.35mm
MDF_1_2 = 12.7;   // 1/2" = 12.7mm
MDF_3_4 = 19.05;  // 3/4" = 19.05mm

// === HARDBOARD / MASONITE ===

HARDBOARD_1_8 = 3.2;   // 1/8" standard
HARDBOARD_1_4 = 6.35;  // 1/4" standard

// === HELPER FUNCTION ===

/**
 * Converts fractional inches to mm for custom thicknesses.
 *
 * Arguments:
 *   numerator   - Top of fraction (e.g., 11 for 11/32)
 *   denominator - Bottom of fraction (e.g., 32 for 11/32)
 *
 * Example:
 *   my_ply = inches_to_mm(11, 32);  // 11/32" = 8.73mm
 */
function inches_to_mm(numerator, denominator) =
    (numerator / denominator) * 25.4;

/**
 * Returns actual plywood thickness for a given nominal size.
 * Use when you know the nominal size but need the actual.
 *
 * Arguments:
 *   nominal_inches - Nominal size as decimal (0.25, 0.375, 0.5, 0.75)
 *
 * Example:
 *   thickness = ply_actual(0.375);  // Returns 8.7 for 3/8"
 */
function ply_actual(nominal_inches) =
    nominal_inches == 0.125 ? PLY_1_8 :
    nominal_inches == 0.25 ? PLY_1_4 :
    nominal_inches == 0.375 ? PLY_3_8 :
    nominal_inches == 0.5 ? PLY_1_2 :
    nominal_inches == 0.625 ? PLY_5_8 :
    nominal_inches == 0.75 ? PLY_3_4 :
    nominal_inches * 25.4;  // Fallback: assume actual = nominal

// === DEFAULT THICKNESS ===
// Common default for general use

PLY_DEFAULT = PLY_3_8;  // 3/8" nominal is common for small cases
