// 17-googie-atomic.scad
// Demonstrates Googie-style atomic orbit decorations.
// Classic 1950s Bohr model / atomic age symbols.

$parent_modules = true;  // Prevent module test code from running

include <../modules/googie/atomic-orbit.scad>

// === LAYOUT CONFIGURATION ===
SPACING = 110;
COLS = 3;
ROWS = 2;

// Calculate scene bounds for centering
SCENE_WIDTH = (COLS - 1) * SPACING;
SCENE_HEIGHT = (ROWS - 1) * SPACING;

// Center offset
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = -SCENE_HEIGHT / 2;

// === RENDER ALL ATOMIC SYMBOLS ===
translate([CENTER_X, CENTER_Y, 0]) {

    // Row 0: 3D orbital variations

    // Classic 3-orbit atom
    translate([0 * SPACING, 0 * SPACING, 0])
    color("DeepSkyBlue")
    atomic_orbit(orbit_radius=40, nucleus_dia=14);

    // With visible electrons
    translate([1 * SPACING, 0 * SPACING, 0])
    color("Gold")
    atomic_orbit(
        orbit_radius = 38,
        nucleus_dia = 12,
        show_electrons = true,
        electron_dia = 7
    );

    // 2-orbit with starburst nucleus
    translate([2 * SPACING, 0 * SPACING, 0])
    color("Crimson")
    atomic_orbit(
        orbit_radius = 35,
        num_orbits = 2,
        nucleus_style = "starburst",
        nucleus_dia = 18
    );

    // Row 1: Flat/printable variations

    // Flat atomic symbol (good for thin signs)
    translate([0 * SPACING, 1 * SPACING, 0])
    color("LimeGreen")
    atomic_symbol_flat(radius=40, thickness=6);

    // 4-orbit complex atom
    translate([1 * SPACING, 1 * SPACING, 0])
    color("MediumOrchid")
    atomic_orbit(
        orbit_radius = 42,
        num_orbits = 4,
        ring_thick = 2.5,
        nucleus_dia = 10,
        eccentricity = 0.4
    );

    // Tight elliptical orbits
    translate([2 * SPACING, 1 * SPACING, 0])
    color("Coral")
    atomic_orbit(
        orbit_radius = 45,
        num_orbits = 3,
        eccentricity = 0.25,
        ring_thick = 3.5,
        show_electrons = true
    );
}
