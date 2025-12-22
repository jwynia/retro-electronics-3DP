// Monolithic Shell Generator
// Creates a single-piece hollow shell with configurable opening and lip.

include <BOSL2/std.scad>

// Default values
_SHELL_WALL = 3;
_SHELL_CORNER_RADIUS = 10;
_SHELL_LIP_DEPTH = 3;
_SHELL_LIP_INSET = 1.5;

/**
 * Creates a monolithic (single-piece) shell with hollow interior
 * and optional front opening with rebated lip for face plate.
 *
 * Arguments:
 *   size        - [width, height, depth] outer dimensions
 *   wall        - wall thickness (default: 3)
 *   corner_r    - corner rounding radius (default: 10)
 *   opening     - [width, height] of front opening, or undef for no opening
 *   opening_r   - corner radius for opening (default: 5)
 *   lip_depth   - depth of lip rebate for face plate (default: 3)
 *   lip_inset   - inset of lip from outer edge (default: 1.5)
 *   anchor      - BOSL2 anchor (default: BOT)
 *   spin        - BOSL2 spin (default: 0)
 *   orient      - BOSL2 orient (default: UP)
 */
module shell_monolithic(
    size,
    wall = _SHELL_WALL,
    corner_r = _SHELL_CORNER_RADIUS,
    opening = undef,
    opening_r = 5,
    lip_depth = _SHELL_LIP_DEPTH,
    lip_inset = _SHELL_LIP_INSET,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];
    depth = size[2];
    
    // Calculated dimensions
    inner_w = width - wall * 2;
    inner_h = height - wall * 2;
    inner_r = max(1, corner_r - wall);
    
    lip_w = width - lip_inset * 2;
    lip_h = height - lip_inset * 2;
    lip_r = max(1, corner_r - lip_inset);
    
    has_opening = !is_undef(opening);
    
    attachable(anchor, spin, orient, size=size) {
        diff()
        cuboid(size, rounding=corner_r, anchor=CENTER) {
            
            // Main cavity
            tag("remove")
            position(TOP)
            cuboid(
                [inner_w, inner_h, depth - wall],
                rounding = inner_r,
                anchor = TOP
            );
            
            // Lip rebate (if we have an opening)
            if (has_opening) {
                tag("remove")
                position(TOP)
                cuboid(
                    [lip_w, lip_h, lip_depth + 0.01],
                    rounding = lip_r,
                    anchor = TOP
                );
            }
            
            // Front opening (if specified)
            if (has_opening) {
                tag("remove")
                position(FWD)
                cuboid(
                    [opening[0], wall + 1, opening[1]],
                    rounding = opening_r,
                    edges = "Y",
                    anchor = FWD
                );
            }
        }
        
        children();
    }
}

// === TEST / DEMO ===
if ($preview) {
    // Basic shell with opening
    shell_monolithic(
        size = [150, 100, 80],
        wall = 3,
        corner_r = 12,
        opening = [120, 70],
        opening_r = 5
    );
}
