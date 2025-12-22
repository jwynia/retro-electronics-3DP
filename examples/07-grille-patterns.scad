// Example 07: Speaker Grille Patterns
// Demonstrates: Creating perforated patterns for speaker grilles
// Shows circular grid, slot, and hexagonal patterns.

include <BOSL2/std.scad>

// Panel parameters
panel_width = 100;
panel_height = 80;
panel_thickness = 3;
panel_corner_radius = 5;

// Grille area (inset from edges)
grille_margin = 10;
grille_width = panel_width - grille_margin * 2;
grille_height = panel_height - grille_margin * 2;

// === PATTERN MODULES ===

// Circular perforation grid
module perf_grid(w, h, hole_dia=4, spacing=6) {
    cols = floor(w / spacing);
    rows = floor(h / spacing);
    offset_x = (w - (cols - 1) * spacing) / 2;
    offset_y = (h - (rows - 1) * spacing) / 2;
    
    translate([-w/2 + offset_x, -h/2 + offset_y, 0])
    for (x = [0 : cols-1], y = [0 : rows-1]) {
        translate([x * spacing, y * spacing, 0])
        cylinder(d=hole_dia, h=panel_thickness + 1, $fn=16);
    }
}

// Horizontal slot pattern
module slot_grid(w, h, slot_width=20, slot_height=2, spacing=5) {
    rows = floor(h / spacing);
    offset_y = (h - (rows - 1) * spacing) / 2;
    
    translate([0, -h/2 + offset_y, 0])
    for (y = [0 : rows-1]) {
        translate([0, y * spacing, 0])
        cube([slot_width, slot_height, panel_thickness + 1], center=true);
    }
}

// Hexagonal pattern
module hex_grid(w, h, cell_size=8, wall=1.5) {
    hex_h = cell_size;
    hex_w = cell_size * sqrt(3) / 2;
    spacing_x = (hex_w + wall) * 2;
    spacing_y = (hex_h + wall) * 0.75;
    
    cols = floor(w / spacing_x) + 1;
    rows = floor(h / spacing_y) + 1;
    
    intersection() {
        cube([w, h, panel_thickness + 2], center=true);
        
        translate([0, 0, 0])
        for (y = [0 : rows-1]) {
            x_offset = (y % 2) * spacing_x / 2;
            translate([-w/2 + x_offset, -h/2 + y * spacing_y, 0])
            for (x = [0 : cols-1]) {
                translate([x * spacing_x, 0, 0])
                cylinder(d=cell_size, h=panel_thickness + 1, $fn=6);
            }
        }
    }
}

// === DEMO PANELS ===

// Panel with circular perforation
translate([-120, 0, 0])
diff()
cuboid([panel_width, panel_height, panel_thickness], 
       rounding=panel_corner_radius, 
       edges="Z", 
       anchor=BOT) {
    tag("remove")
    up(panel_thickness/2)
    perf_grid(grille_width, grille_height, hole_dia=4, spacing=6);
}

// Panel with slot pattern
translate([0, 0, 0])
diff()
cuboid([panel_width, panel_height, panel_thickness], 
       rounding=panel_corner_radius, 
       edges="Z", 
       anchor=BOT) {
    tag("remove")
    up(panel_thickness/2)
    slot_grid(grille_width, grille_height, slot_width=60, slot_height=2, spacing=5);
}

// Panel with hexagonal pattern
translate([120, 0, 0])
diff()
cuboid([panel_width, panel_height, panel_thickness], 
       rounding=panel_corner_radius, 
       edges="Z", 
       anchor=BOT) {
    tag("remove")
    up(panel_thickness/2)
    hex_grid(grille_width, grille_height, cell_size=8, wall=1.5);
}
