// Example 10: Bezel Style Variations
// Demonstrates: Decorative frame styles for screen bezels
// Shows plain, industrial, deco, midcentury, braun, and crt styles.

include <BOSL2/std.scad>
use <../modules/faces/bezel.scad>

// Common bezel parameters
bezel_size = [100, 70];
screen_size = [70, 45];
bezel_thickness = 4;
bezel_corner_r = 8;
screen_corner_r = 3;

// Grid spacing
spacing_x = 115;
spacing_y = 90;

// === STYLE GALLERY ===

// Row 1: Plain and Industrial
translate([-spacing_x, spacing_y/2, 0]) {
    faceplate_bezel(
        size = bezel_size,
        thickness = bezel_thickness,
        corner_r = bezel_corner_r,
        screen_size = screen_size,
        screen_corner_r = screen_corner_r,
        style = "plain"
    );
    // Label
    translate([0, -bezel_size[1]/2 - 8, 0])
    color("gray")
    linear_extrude(0.5)
    text("Plain", size=8, halign="center", valign="top");
}

translate([0, spacing_y/2, 0]) {
    faceplate_bezel(
        size = bezel_size,
        thickness = bezel_thickness,
        corner_r = bezel_corner_r,
        screen_size = screen_size,
        screen_corner_r = screen_corner_r,
        style = "industrial"
    );
    // Label
    translate([0, -bezel_size[1]/2 - 8, 0])
    color("gray")
    linear_extrude(0.5)
    text("Industrial", size=8, halign="center", valign="top");
}

translate([spacing_x, spacing_y/2, 0]) {
    faceplate_bezel(
        size = bezel_size,
        thickness = bezel_thickness,
        corner_r = bezel_corner_r,
        screen_size = screen_size,
        screen_corner_r = screen_corner_r,
        style = "deco",
        style_options = [4, 1.0, 2.5]  // 4 steps, 1mm tall, 2.5mm inset
    );
    // Label
    translate([0, -bezel_size[1]/2 - 8, 0])
    color("gray")
    linear_extrude(0.5)
    text("Art Deco", size=8, halign="center", valign="top");
}

// Row 2: Mid-Century and Braun
translate([-spacing_x/2, -spacing_y/2, 0]) {
    faceplate_bezel(
        size = bezel_size,
        thickness = bezel_thickness,
        corner_r = bezel_corner_r,
        screen_size = screen_size,
        screen_corner_r = screen_corner_r,
        style = "midcentury",
        style_options = [5, 2.0]  // wider border, taller
    );
    // Label
    translate([0, -bezel_size[1]/2 - 8, 0])
    color("gray")
    linear_extrude(0.5)
    text("Mid-Century", size=8, halign="center", valign="top");
}

translate([spacing_x/2, -spacing_y/2, 0]) {
    faceplate_bezel(
        size = bezel_size,
        thickness = bezel_thickness,
        corner_r = bezel_corner_r,
        screen_size = screen_size,
        screen_corner_r = screen_corner_r,
        style = "braun",
        style_options = [3, 1.0]  // wider, taller border
    );
    // Label
    translate([0, -bezel_size[1]/2 - 8, 0])
    color("gray")
    linear_extrude(0.5)
    text("Braun", size=8, halign="center", valign="top");
}

// Row 3: CRT
translate([0, -spacing_y * 1.5, 0]) {
    faceplate_bezel(
        size = bezel_size,
        thickness = bezel_thickness,
        corner_r = bezel_corner_r,
        screen_size = [55, 35],  // smaller screen for more slope area
        screen_corner_r = screen_corner_r,
        style = "crt",
        style_options = [12, 45, 6, 12]  // slope_width, angle, height, scoop
    );
    // Label
    translate([0, -bezel_size[1]/2 - 8, 0])
    color("gray")
    linear_extrude(0.5)
    text("CRT", size=8, halign="center", valign="top");
}
