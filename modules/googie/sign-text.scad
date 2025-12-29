// Googie Sign Text
// Text generation for Googie-style signs.
// Supports standalone printing or attachment to signs.

include <BOSL2/std.scad>

// === DEFAULT FONTS ===
// Recommended fonts for Googie signs (install from Google Fonts)
FONT_ATOMIC = "Atomic Age";        // Classic 1950s car nameplate style
FONT_BUNGEE = "Bungee";            // Bold urban signage
FONT_PACIFICO = "Pacifico";        // Retro script
FONT_FASCINATE = "Fascinate";      // Art deco display
FONT_FUTURA = "Futura Bold";       // Classic mid-century geometric

// Fallback system fonts
FONT_ARIAL_BLACK = "Arial Black";
FONT_IMPACT = "Impact";
FONT_SIGNPAINTER = "SignPainter-HouseScript";

// Default
_DEFAULT_FONT = "Futura Bold";
_DEFAULT_SIZE = 20;
_DEFAULT_DEPTH = 4;


/**
 * Creates standalone 3D text for separate printing.
 * Can be printed separately and glued to signs.
 *
 * Arguments:
 *   text_str     - The text string to render
 *   size         - Font size / letter height (mm)
 *   depth        - Extrusion depth (mm)
 *   font         - Font name (default: Futura Bold)
 *   backing      - Add thin backing plate for easier handling
 *   backing_thick - Backing plate thickness (mm)
 *   backing_margin - Extra margin around text on backing (mm)
 *   halign       - Horizontal alignment: "left", "center", "right"
 *   valign       - Vertical alignment: "bottom", "center", "top"
 *   anchor       - BOSL2 anchor (default: CENTER)
 *   spin         - BOSL2 spin (default: 0)
 *   orient       - BOSL2 orient (default: UP)
 */
module sign_text(
    text_str,
    size = _DEFAULT_SIZE,
    depth = _DEFAULT_DEPTH,
    font = _DEFAULT_FONT,
    backing = false,
    backing_thick = 1,
    backing_margin = 2,
    halign = "center",
    valign = "center",
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Estimate text width (rough approximation)
    // Actual width depends on font, but ~0.6 * size * len is reasonable
    est_width = len(text_str) * size * 0.65;
    est_height = size;
    total_depth = backing ? depth + backing_thick : depth;

    size_vec = [est_width, est_height, total_depth];

    attachable(anchor, spin, orient, size=size_vec) {
        union() {
            // Main text
            translate([0, 0, backing ? backing_thick : 0])
            linear_extrude(height = depth)
            text(text_str, size = size, font = font, halign = halign, valign = valign);

            // Optional backing plate
            if (backing) {
                // Get approximate bounds for backing
                translate([0, 0, backing_thick/2])
                cube([est_width + backing_margin * 2, est_height + backing_margin * 2, backing_thick], center = true);
            }
        }
        children();
    }
}

/**
 * Creates text sized to fit a specific width.
 * Useful for fitting text to sign bodies.
 */
module sign_text_fit(
    text_str,
    target_width,
    depth = _DEFAULT_DEPTH,
    font = _DEFAULT_FONT,
    backing = false,
    backing_thick = 1,
    halign = "center",
    valign = "center"
) {
    // Estimate size needed to fit target width
    // This is approximate - actual fit depends on font metrics
    char_count = len(text_str);
    est_size = target_width / (char_count * 0.65);

    sign_text(
        text_str = text_str,
        size = est_size,
        depth = depth,
        font = font,
        backing = backing,
        backing_thick = backing_thick,
        halign = halign,
        valign = valign
    );
}

/**
 * Creates individual letter pieces for multi-color printing.
 * Each letter is a separate object that can be printed/painted separately.
 */
module sign_text_letters(
    text_str,
    size = _DEFAULT_SIZE,
    depth = _DEFAULT_DEPTH,
    font = _DEFAULT_FONT,
    spacing = 0,          // Extra spacing between letters (0 = normal)
    backing = true,       // Individual backings recommended for separate letters
    backing_thick = 1,
    backing_margin = 1
) {
    char_width = size * 0.65;  // Approximate character width

    for (i = [0 : len(text_str) - 1]) {
        char = text_str[i];
        if (char != " ") {  // Skip spaces
            translate([i * (char_width + spacing), 0, 0])
            sign_text(
                text_str = char,
                size = size,
                depth = depth,
                font = font,
                backing = backing,
                backing_thick = backing_thick,
                backing_margin = backing_margin,
                halign = "center",
                valign = "center"
            );
        }
    }
}

/**
 * Creates text with outline effect (hollow letters).
 * Good for LED channel letters or distinctive signs.
 */
module sign_text_outline(
    text_str,
    size = _DEFAULT_SIZE,
    depth = _DEFAULT_DEPTH,
    font = _DEFAULT_FONT,
    wall = 2,            // Outline wall thickness
    halign = "center",
    valign = "center"
) {
    linear_extrude(height = depth)
    difference() {
        // Outer text
        offset(delta = wall/2)
        text(text_str, size = size, font = font, halign = halign, valign = valign);

        // Inner cutout
        offset(delta = -wall/2)
        text(text_str, size = size, font = font, halign = halign, valign = valign);
    }
}

/**
 * Creates text as a cutting tool (for inset text on signs).
 * Use with difference() to cut text into a sign body.
 */
module sign_text_cutter(
    text_str,
    size = _DEFAULT_SIZE,
    depth = 2,           // How deep to cut
    font = _DEFAULT_FONT,
    halign = "center",
    valign = "center"
) {
    // Slightly oversized for clean boolean operations
    translate([0, 0, -0.01])
    linear_extrude(height = depth + 0.02)
    text(text_str, size = size, font = font, halign = halign, valign = valign);
}

/**
 * Creates arced/curved text (for circular signs).
 */
module sign_text_arc(
    text_str,
    size = _DEFAULT_SIZE,
    depth = _DEFAULT_DEPTH,
    font = _DEFAULT_FONT,
    radius = 50,         // Arc radius
    arc_angle = 180,     // Total arc span in degrees
    halign = "center"
) {
    char_count = len(text_str);
    angle_per_char = arc_angle / max(char_count - 1, 1);
    start_angle = halign == "center" ? 90 + arc_angle/2 :
                  halign == "left" ? 90 + arc_angle :
                  90;

    for (i = [0 : char_count - 1]) {
        char = text_str[i];
        angle = start_angle - i * angle_per_char;

        rotate([0, 0, angle])
        translate([radius, 0, 0])
        rotate([0, 0, -90])
        linear_extrude(height = depth)
        text(char, size = size, font = font, halign = "center", valign = "center");
    }
}


// === COMPLETE SIGN WITH TEXT ===

/**
 * Creates a sign body with text applied.
 * Convenience module combining sign body and text.
 */
module sign_with_text(
    text_str,
    sign_size = [100, 50, 6],
    text_size = 15,
    font = _DEFAULT_FONT,
    text_style = "raised",  // "raised", "inset", "through"
    text_depth = 2,
    sign_style = "rect",    // "rect", "oval", "arrow"
    corner_radius = 3
) {
    difference() {
        union() {
            // Sign body
            if (sign_style == "rect") {
                linear_extrude(height = sign_size[2])
                offset(r = corner_radius)
                offset(r = -corner_radius)
                square([sign_size[0], sign_size[1]], center = true);
            } else if (sign_style == "oval") {
                linear_extrude(height = sign_size[2])
                scale([1, sign_size[1]/sign_size[0]])
                circle(d = sign_size[0], $fn = 48);
            } else if (sign_style == "arrow") {
                arrow_depth = sign_size[0] * 0.15;
                linear_extrude(height = sign_size[2])
                polygon([
                    [-sign_size[0]/2, -sign_size[1]/2],
                    [-sign_size[0]/2, sign_size[1]/2],
                    [sign_size[0]/2 - arrow_depth, sign_size[1]/2],
                    [sign_size[0]/2, 0],
                    [sign_size[0]/2 - arrow_depth, -sign_size[1]/2]
                ]);
            }

            // Raised text
            if (text_style == "raised") {
                translate([0, 0, sign_size[2]])
                linear_extrude(height = text_depth)
                text(text_str, size = text_size, font = font, halign = "center", valign = "center");
            }
        }

        // Inset or through-cut text
        if (text_style == "inset") {
            translate([0, 0, sign_size[2] - text_depth])
            linear_extrude(height = text_depth + 0.1)
            text(text_str, size = text_size, font = font, halign = "center", valign = "center");
        } else if (text_style == "through") {
            translate([0, 0, -0.1])
            linear_extrude(height = sign_size[2] + 0.2)
            text(text_str, size = text_size, font = font, halign = "center", valign = "center");
        }
    }
}


// === PLACEMENT JIG ===

/**
 * Creates a placement jig for aligning individual letters when gluing.
 * The jig has POCKETS (not through-holes) that match the bottom portion
 * of each letter. A solid floor keeps the jig as one connected piece.
 *
 * Arguments:
 *   text_str     - The text string (same as used for letters)
 *   size         - Font size (must match the letters being placed)
 *   font         - Font name (must match the letters)
 *   jig_height   - Height of the jig (how much of letter bottom to capture)
 *   jig_depth    - Depth/thickness of the jig
 *   tolerance    - Extra clearance around letter pockets (mm)
 *   base_width   - Width of base rail below pockets
 *   floor_thick  - Floor thickness below pockets (keeps jig connected)
 *   end_stops    - Add end stops for positioning against sign edge
 *   stop_height  - Height of end stops
 */
module sign_text_jig(
    text_str,
    size = _DEFAULT_SIZE,
    font = _DEFAULT_FONT,
    jig_height = 0,         // 0 = auto (1/3 of text size)
    jig_depth = _DEFAULT_DEPTH,
    tolerance = 0.3,
    base_width = 3,
    floor_thick = 1.2,      // Floor thickness (keeps jig connected)
    end_stops = true,
    stop_height = 5
) {
    // Auto-calculate jig height if not specified
    actual_jig_height = jig_height > 0 ? jig_height : size / 3;

    // Estimate text width
    est_width = len(text_str) * size * 0.65;
    total_height = actual_jig_height + base_width;
    pocket_depth = jig_depth - floor_thick;  // Leave floor for connectivity

    difference() {
        union() {
            // Main jig body - base rail plus letter capture area
            linear_extrude(height = jig_depth)
            translate([0, -base_width/2, 0])
            square([est_width + tolerance * 2, total_height], center = false);

            // End stops (optional)
            if (end_stops) {
                // Left stop
                translate([-tolerance, -base_width, 0])
                cube([tolerance + 1, total_height + base_width, jig_depth + stop_height]);

                // Right stop
                translate([est_width + tolerance - 1, -base_width, 0])
                cube([tolerance + 1, total_height + base_width, jig_depth + stop_height]);
            }
        }

        // Cut POCKETS for letter shapes (not through - leave floor)
        translate([est_width/2 + tolerance, actual_jig_height/2, floor_thick])
        linear_extrude(height = pocket_depth + 0.1)
        offset(delta = tolerance)  // Add clearance around letters
        text(text_str, size = size, font = font, halign = "center", valign = "center");
    }
}

/**
 * Creates a jig for individual letter placement with per-letter notches.
 * Better for letters that will be printed completely separately.
 */
module sign_text_letter_jig(
    text_str,
    size = _DEFAULT_SIZE,
    font = _DEFAULT_FONT,
    jig_height = 0,
    jig_depth = _DEFAULT_DEPTH,
    tolerance = 0.3,
    base_width = 3,
    floor_thick = 1.2,      // Floor thickness (keeps jig connected)
    dividers = true,        // Add dividers between letter slots
    divider_width = 1
) {
    actual_jig_height = jig_height > 0 ? jig_height : size / 3;
    char_width = size * 0.65;
    total_width = len(text_str) * (char_width + (dividers ? divider_width : 0));
    total_height = actual_jig_height + base_width;
    pocket_depth = jig_depth - floor_thick;

    difference() {
        union() {
            // Base rail
            linear_extrude(height = jig_depth)
            translate([0, -base_width, 0])
            square([total_width, total_height + base_width], center = false);

            // Dividers between letters (raised walls)
            if (dividers) {
                for (i = [0 : len(text_str)]) {
                    translate([i * (char_width + divider_width), -base_width, 0])
                    cube([divider_width, total_height + base_width, jig_depth + size/4]);
                }
            }
        }

        // Cut POCKETS for each letter shape (not through - leave floor)
        for (i = [0 : len(text_str) - 1]) {
            char = text_str[i];
            if (char != " ") {
                translate([
                    i * (char_width + divider_width) + divider_width + char_width/2,
                    actual_jig_height/2,
                    floor_thick
                ])
                linear_extrude(height = pocket_depth + 0.1)
                offset(delta = tolerance)
                text(char, size = size, font = font, halign = "center", valign = "center");
            }
        }
    }
}

/**
 * Generates both the letters AND the matching jig as a set.
 * Use render_part parameter to select which to export.
 */
module sign_text_with_jig(
    text_str,
    size = _DEFAULT_SIZE,
    depth = _DEFAULT_DEPTH,
    font = _DEFAULT_FONT,
    jig_style = "continuous",  // "continuous" or "individual"
    render_part = "both",      // "letters", "jig", or "both"
    letter_spacing = 0,
    tolerance = 0.3
) {
    // Letters
    if (render_part == "letters" || render_part == "both") {
        sign_text_letters(
            text_str = text_str,
            size = size,
            depth = depth,
            font = font,
            spacing = letter_spacing,
            backing = false
        );
    }

    // Jig (offset to side if showing both)
    jig_offset = render_part == "both" ? [0, -size * 1.5, 0] : [0, 0, 0];

    if (render_part == "jig" || render_part == "both") {
        translate(jig_offset)
        if (jig_style == "continuous") {
            sign_text_jig(
                text_str = text_str,
                size = size,
                font = font,
                jig_depth = depth,
                tolerance = tolerance
            );
        } else {
            sign_text_letter_jig(
                text_str = text_str,
                size = size,
                font = font,
                jig_depth = depth,
                tolerance = tolerance
            );
        }
    }
}


// === TEST / DEMO ===
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;

    // Standalone text
    sign_text("CAFE", font = "Atomic Age", size = 25);

    // Text with backing plate
    translate([0, 50, 0])
    sign_text("DINER", font = "Bungee", size = 20, backing = true);

    // Individual letters
    translate([0, 100, 0])
    sign_text_letters("OPEN", font = "Futura Bold", size = 18);

    // Outline text
    translate([120, 0, 0])
    sign_text_outline("EAT", font = "Arial Black", size = 30, wall = 3);

    // Complete sign with text
    translate([120, 60, 0])
    sign_with_text("MOTEL", sign_size = [80, 35, 5], text_size = 12, font = "Atomic Age");
}
