// Face Plate Bezel Generator
// Creates face plates for screen/display mounting with magnetic attachment.

include <BOSL2/std.scad>

// Include hardware module (adjust path as needed)
// use <../hardware/magnet-pockets.scad>

// Default values
_FACEPLATE_THICKNESS = 4;
_FACEPLATE_CORNER_R = 8;
_BEZEL_WIDTH = 10;
_SCREEN_LIP = 1.5;
_SCREEN_DEPTH = 8;

/**
 * Creates a face plate with screen bezel opening.
 * Designed to fit into a shell's lip and hold a screen/display.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions (should match shell lip)
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - corner radius (default: 8)
 *   screen_size    - [width, height] of screen visible area
 *   screen_corner_r - corner radius for screen opening (default: 3)
 *   screen_depth   - how deep screen sits behind plate (default: 8)
 *   screen_lip     - lip width holding screen in place (default: 1.5)
 *   steel_pockets  - include steel pockets for magnetic mount (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 *   anchor         - BOSL2 anchor (default: BOT)
 *   spin           - BOSL2 spin (default: 0)
 *   orient         - BOSL2 orient (default: UP)
 */
module faceplate_bezel(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
    screen_size,
    screen_corner_r = 3,
    screen_depth = _SCREEN_DEPTH,
    screen_lip = _SCREEN_LIP,
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];
    screen_w = screen_size[0];
    screen_h = screen_size[1];
    
    // Viewing opening (smaller, goes through)
    view_w = screen_w - screen_lip * 2;
    view_h = screen_h - screen_lip * 2;
    
    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];
    
    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
            
            // Screen viewing opening (through hole)
            tag("remove")
            position(TOP)
            cuboid(
                [view_w, view_h, thickness + 1],
                rounding = screen_corner_r,
                edges = "Z",
                anchor = TOP
            );
            
            // Screen mounting pocket (on back, doesn't go through)
            tag("remove")
            position(BOT)
            cuboid(
                [screen_w, screen_h, screen_depth],
                rounding = screen_corner_r + 1,
                edges = "Z",
                anchor = BOT
            );
            
            // Steel disc pockets for magnetic attachment
            if (steel_pockets) {
                tag("remove")
                position(BOT)
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], 0])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                }
            }
        }
        
        children();
    }
}

/**
 * Creates a simple flat face plate without screen opening.
 * Useful for control panels or covers.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - corner radius (default: 8)
 *   steel_pockets  - include steel pockets (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 */
module faceplate_blank(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];
    
    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];
    
    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
            
            // Steel disc pockets
            if (steel_pockets) {
                tag("remove")
                position(BOT)
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], 0])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                }
            }
        }
        
        children();
    }
}

// === TEST / DEMO ===
if ($preview) {
    // Demo: Screen bezel face plate
    faceplate_bezel(
        size = [140, 95],
        thickness = 4,
        corner_r = 10,
        screen_size = [120, 68],
        screen_corner_r = 3,
        screen_depth = 8
    );
}
