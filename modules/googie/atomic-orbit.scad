// Googie Atomic Orbit
// Parametric atomic/Bohr model decorations for Googie-style signs.
// Classic 1950s atomic age symbol.

include <BOSL2/std.scad>

// Default values
_DEFAULT_ORBIT_RADIUS = 40;
_DEFAULT_RING_THICK = 3;
_DEFAULT_NUCLEUS_DIA = 15;

/**
 * Creates a single orbital ring (ellipse in 3D).
 *
 * Arguments:
 *   radius      - Orbit radius (mm)
 *   ring_thick  - Thickness of the ring tube (mm)
 *   eccentricity - Ellipse ratio (1=circle, 0.5=elongated)
 *   tilt        - Tilt angle around X axis (degrees)
 *   rotation    - Rotation around Z axis (degrees)
 */
module orbit_ring(
    radius = _DEFAULT_ORBIT_RADIUS,
    ring_thick = _DEFAULT_RING_THICK,
    eccentricity = 0.3,
    tilt = 60,
    rotation = 0
) {
    rotate([0, 0, rotation])
    rotate([tilt, 0, 0])
    scale([1, eccentricity, 1])
    rotate_extrude(angle=360, $fn=48)
    translate([radius, 0, 0])
    circle(d=ring_thick, $fn=16);
}

/**
 * Creates an electron (small sphere) positioned on an orbit.
 *
 * Arguments:
 *   orbit_radius - Radius of the orbit
 *   electron_dia - Diameter of the electron sphere
 *   position     - Angle position on orbit (degrees)
 *   eccentricity - Must match the orbit's eccentricity
 *   tilt         - Must match the orbit's tilt
 *   rotation     - Must match the orbit's rotation
 */
module electron(
    orbit_radius,
    electron_dia = 6,
    position = 0,
    eccentricity = 0.3,
    tilt = 60,
    rotation = 0
) {
    rotate([0, 0, rotation])
    rotate([tilt, 0, 0])
    scale([1, eccentricity, 1])
    rotate([0, 0, position])
    translate([orbit_radius, 0, 0])
    // Counteract the scale to keep electron spherical
    scale([1, 1/eccentricity, 1])
    sphere(d=electron_dia, $fn=16);
}

/**
 * Creates a complete atomic orbit symbol.
 *
 * The classic atomic age motif: a nucleus surrounded by
 * elliptical electron orbits at various angles.
 *
 * Arguments:
 *   orbit_radius   - Radius of orbits (mm)
 *   ring_thick     - Thickness of orbit rings (mm)
 *   nucleus_dia    - Diameter of central nucleus (mm)
 *   nucleus_style  - "sphere", "starburst", or "none"
 *   num_orbits     - Number of orbital rings (1-4)
 *   eccentricity   - How elliptical the orbits are (0.3-1.0)
 *   show_electrons - Add electron spheres on orbits
 *   electron_dia   - Size of electron spheres (mm)
 *   anchor         - BOSL2 anchor (default: CENTER)
 *   spin           - BOSL2 spin (default: 0)
 *   orient         - BOSL2 orient (default: UP)
 *
 * Example:
 *   atomic_orbit();  // Classic 3-orbit atom
 *   atomic_orbit(num_orbits=2, show_electrons=true);
 */
module atomic_orbit(
    orbit_radius = _DEFAULT_ORBIT_RADIUS,
    ring_thick = _DEFAULT_RING_THICK,
    nucleus_dia = _DEFAULT_NUCLEUS_DIA,
    nucleus_style = "sphere",
    num_orbits = 3,
    eccentricity = 0.35,
    show_electrons = false,
    electron_dia = undef,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Validate
    assert(orbit_radius > 0, "orbit_radius must be positive");
    assert(num_orbits >= 1 && num_orbits <= 4, "num_orbits must be 1-4");

    // Electron size defaults
    _electron_dia = is_undef(electron_dia) ? ring_thick * 2 : electron_dia;

    // Orbit configurations: [tilt, rotation, electron_position]
    orbit_configs = [
        [70, 0, 45],      // First orbit
        [70, 60, 160],    // Second orbit (rotated 60°)
        [70, 120, 280],   // Third orbit (rotated 120°)
        [30, 45, 90],     // Fourth orbit (different tilt)
    ];

    // Size for attachable (approximate bounding sphere)
    size = [orbit_radius * 2, orbit_radius * 2, orbit_radius * 2];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Nucleus
            if (nucleus_style == "sphere") {
                sphere(d=nucleus_dia, $fn=24);
            } else if (nucleus_style == "starburst") {
                // Small starburst as nucleus
                linear_extrude(height=ring_thick, center=true)
                star_2d(points=8, outer_r=nucleus_dia/2, inner_r=nucleus_dia/4);
            }
            // "none" = no nucleus

            // Orbital rings
            for (i = [0:min(num_orbits, 4)-1]) {
                config = orbit_configs[i];
                orbit_ring(
                    radius = orbit_radius,
                    ring_thick = ring_thick,
                    eccentricity = eccentricity,
                    tilt = config[0],
                    rotation = config[1]
                );

                // Electrons
                if (show_electrons) {
                    electron(
                        orbit_radius = orbit_radius,
                        electron_dia = _electron_dia,
                        position = config[2],
                        eccentricity = eccentricity,
                        tilt = config[0],
                        rotation = config[1]
                    );
                }
            }
        }
        children();
    }
}

/**
 * Simple 2D star for nucleus (helper).
 */
module star_2d(points=8, outer_r=10, inner_r=5) {
    polygon([
        for (i = [0:points*2-1])
        let(
            angle = i * 180 / points,
            r = i % 2 == 0 ? outer_r : inner_r
        )
        [r * cos(angle), r * sin(angle)]
    ]);
}

/**
 * Creates a flat/2D atomic symbol (for signs, logos).
 * All orbits in same plane, just rotated.
 */
module atomic_symbol_flat(
    radius = 40,
    ring_thick = 3,
    nucleus_dia = 12,
    num_orbits = 3,
    thickness = 5,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    size = [radius * 2, radius * 2, thickness];

    attachable(anchor, spin, orient, size=size) {
        linear_extrude(height=thickness, center=true) {
            // Nucleus
            circle(d=nucleus_dia, $fn=24);

            // Orbits as ellipses
            for (i = [0:num_orbits-1]) {
                rotate([0, 0, i * 180 / num_orbits])
                difference() {
                    scale([1, 0.35])
                    circle(r=radius, $fn=48);

                    scale([1, 0.35])
                    circle(r=radius - ring_thick, $fn=48);
                }
            }
        }
        children();
    }
}

/**
 * Simplified atom with just rings (no 3D tilt).
 * Good for thinner signs where full 3D doesn't print well.
 */
module atomic_rings_simple(
    radius = 40,
    ring_thick = 4,
    nucleus_dia = 15,
    thickness = 5,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    size = [radius * 2.2, radius * 2.2, thickness];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Central disc
            cylinder(h=thickness, d=nucleus_dia, center=true, $fn=24);

            // Three flat elliptical rings at different rotations
            for (angle = [0, 60, 120]) {
                rotate([0, 0, angle])
                rotate([90, 0, 0])
                rotate_extrude(angle=360, $fn=48)
                translate([radius * 0.5, 0, 0])
                scale([1.8, 1, 1])
                circle(d=ring_thick, $fn=12);
            }
        }
        children();
    }
}


// === TEST / DEMO ===
// Only runs when this file is opened directly, not when included
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;

    // Classic 3-orbit atom
    atomic_orbit();

    // With electrons
    translate([100, 0, 0])
    atomic_orbit(orbit_radius=35, show_electrons=true, electron_dia=8);

    // Flat symbol for signs
    translate([0, 100, 0])
    atomic_symbol_flat(radius=35, thickness=6);

    // 2-orbit variant
    translate([100, 100, 0])
    atomic_orbit(num_orbits=2, orbit_radius=30, nucleus_style="starburst");
}
