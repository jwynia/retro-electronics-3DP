include <BOSL2/std.scad>;
include <BOSL2/threading.scad>;

/**
 * Thread Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.0  
 *
 * Description:
 * This OpenSCAD script generates a variety of fully parametric  
 * threaded rods and nuts with customizable options using BOSL2.
 *
 * License:
 * This script is shared under the CC BY-NC-SA 4.0 license:  
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 */
    
/* [🌀️ Thread] */

// Thread type.
Thread = "triangular"; // [triangular: Triangular, trapezoidal: Trapezoidal, acme: ACME, buttress: Buttress, square: Square]

// Major thread diameter.
Diameter = 12;

// Thread pitch (distance per turn).
Pitch = 1.5;

// Number of thread starts.
Starts = 1;

// Apply a truncated blunt start.
Blunt_Start = "both"; // [none: None, top: Top, bottom: Bottom, both: Both ends]

// Unthreaded section length after blunt start.
End_Length = 0;

// Use left-handed threads?
Left_Handed = false;

/* [🔩 Rod] */

// Length of the rod.
Rod_Length = 30;

// Bevel type for rod thread ends.
Rod_Bevel = "none"; // [none: None, top: Top, bottom: Bottom, both: Both ends]

// Split the rod for increased strength when printing.
Rod_Split = false;

/* [⭕ Nut] */

// Across-flats width of the nut.
Nut_Width = 18;

// Thickness of the nut.
Nut_Thickness = 8;

// Shape of the nut.
Nut_Shape = "hex"; // [hex: Hex, square: Square]

// Bevel of the nut edges.
Nut_Bevel = "auto"; // [auto: Auto, none: None, inside: Inside, outside: Outside, both: Inside & Outside]

// Additional spacing for 3D printing fit.
Nut_Clearance = 0.12; // [0:0.01:0.25]

// Keep the nut bottom flat (disable bottom bevel).
Nut_Flush = false;

/* [📷 Render] */

// Models to render.
Display = "all"; // [all: Rod & Nut, rod: Rod, nut: Nut]

// Render resolution to control detail level.
Resolution = 3; // [4: Ultra, 3: High, 2: Medium, 1: Low]

// Color of the models.
Color = "#e2dede"; // color

// Determine face angle and size based on resolution
Face = (Resolution == 4) ? [1, 0.1]
    : (Resolution == 3) ? [2, 0.15]
    : (Resolution == 2) ? [2, 0.2]
    : [4, 0.4];

$fa = Face[0];
$fs = Face[1];

/* [Hidden] */

All_Visible = Display == "all";
Rod_Visible = All_Visible || Display == "rod";
Nut_Visible = All_Visible || Display == "nut";
Spacing = 16;

Nut_WAF = max(Diameter, Nut_Width);
Nut_Inner_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "outside" ? false
    : true;
Nut_Outer_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "inside" ? false
    : true;
    
Rod_Bevel_Top = Rod_Bevel == "none" || Rod_Bevel == "bottom" ? false : true;
Rod_Bevel_Bottom = Rod_Bevel == "none" || Rod_Bevel == "top" ? false : true;

Blunt_Start_Top = Blunt_Start == "none" || Blunt_Start == "bottom" ? false : true;
Blunt_Start_Bottom = Blunt_Start == "none" || Blunt_Start == "top" ? false : true;

// Render
generate();

module generate() {
    if (Thread == "triangular") {
        triangular_thread();
    } else if (Thread == "trapezoidal") {
        trapezoidal_thread();
    } else if (Thread == "acme") {
        acme_thread();
    } else if (Thread == "buttress") {
        buttress_thread();
    } else if (Thread == "square") {
        square_thread();
    }
}

/**
 * Returns the thread depth based on type and pitch.
 *
 * @param thread    Type of thread.
 * @param pitch     Pitch of the thread.
 */
function get_thread_depth(thread, pitch) =
    thread == "triangular"  ? cos(30) * 5/8 :
    thread == "trapezoidal" ? pitch / 2 :
    thread == "acme"        ? pitch / 2 :
    thread == "buttress"    ? pitch * 3 / 4 :
    thread == "square"      ? pitch / 2 :
    undef;
    
/**
 * Render the rod.
 */
module render_rod() {
    if (Rod_Visible) {
        color(Color)
        left(Nut_Visible ? Diameter / 2 + Spacing / 2 : 0) {
            if (Rod_Split) {
                $rod_anchor = TOP;
                // Front half
                xrot(-90)
                down(0.1)
                front_half(s = Rod_Length * 2) {
                    children();
                }
                // Back half
                xrot(90)
                down(0.1)
                back_half(s = Rod_Length * 2) {
                    children();
                }
                // Bridge halves
                cube([Diameter * 3 / 4, 0.24, 0.24], anchor = BOTTOM+CENTER);
            } else {
                $rod_anchor = BOTTOM;
                children();
            }
        }
    }
}

/**
 * Render the nut.
 */
module render_nut() {
    if (Nut_Visible) {
        $slop = Nut_Clearance;
        color(Color)
        right(Rod_Visible ? Nut_WAF / 2 + Spacing / 2 : 0) {
            children();
        }
    }
}

/**
 * Creates a standard ISO/UTS triangular threaded rod and nut.
 *
 * These threads are close to triangular, with a 60 degree thread angle.
 */
module triangular_thread() {
    render_rod() {
        threaded_rod(
            d = Diameter,
            l = Rod_Length,
            pitch = Pitch,
            left_handed = Left_Handed,
            starts = Starts,
            bevel1 = Rod_Bevel_Bottom,
            bevel2 = Rod_Bevel_Top,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = $rod_anchor
        );
    }
    render_nut()
        threaded_nut(
            nutwidth = Nut_WAF,
            id = Diameter,
            h = Nut_Thickness,
            pitch = Pitch,
            left_handed = Left_Handed,
            shape = Nut_Shape,
            starts = Starts,
            bevel = Nut_Outer_Bevel,
            bevel1 = Nut_Flush ? false : undef,
            ibevel = Nut_Inner_Bevel,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = BOTTOM
        );
}

/**
 * Generates an ISO 2904 trapezoidal threaded rod and nut.
 *
 * These threads have a 30 degree flank angle.
 */
module trapezoidal_thread() { 
    render_rod()
        trapezoidal_threaded_rod(
            d = Diameter,
            l = Rod_Length,
            pitch = Pitch,
            left_handed = Left_Handed,
            starts = Starts,
            bevel1 = Rod_Bevel_Bottom,
            bevel2 = Rod_Bevel_Top,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            thread_angle = 30,
            anchor = $rod_anchor
        );
    render_nut()
        trapezoidal_threaded_nut(
            nutwidth = Nut_WAF,
            id = Diameter,
            h = Nut_Thickness,
            pitch = Pitch,
            left_handed = Left_Handed,
            shape = Nut_Shape,
            starts = Starts,
            bevel = Nut_Outer_Bevel,
            bevel1 = Nut_Flush ? false : undef,
            ibevel = Nut_Inner_Bevel,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            thread_angle = 30,
            anchor = BOTTOM
        );
}

/**
 * Creates an ANSI B1.5 ACME trapepzoidal threaded rod and nut.
 *
 * These threads have a 29 degree flank angle.
 */
module acme_thread() {
    render_rod()
        acme_threaded_rod(
            d = Diameter,
            l = Rod_Length,
            pitch = Pitch,
            left_handed = Left_Handed,
            starts = Starts,
            bevel1 = Rod_Bevel_Bottom,
            bevel2 = Rod_Bevel_Top,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = $rod_anchor
        );
    render_nut()
        acme_threaded_nut(
            nutwidth = Nut_WAF,
            id = Diameter,
            h = Nut_Thickness,
            pitch = Pitch,
            left_handed = Left_Handed,
            shape = Nut_Shape,
            starts = Starts,
            bevel = Nut_Outer_Bevel,
            bevel1 = Nut_Flush ? false : undef,
            ibevel = Nut_Inner_Bevel,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = BOTTOM
        );
}

/**
 * Creates a buttress threaded rod and nut.
 *
 * These threads have a 45 degree flank angle.
 */
module buttress_thread() {
    render_rod()
        buttress_threaded_rod(
            d = Diameter,
            l = Rod_Length,
            pitch = Pitch,
            left_handed = Left_Handed,
            starts = Starts,
            bevel1 = Rod_Bevel_Bottom,
            bevel2 = Rod_Bevel_Top,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = $rod_anchor
        );
    render_nut()
        buttress_threaded_nut(
            nutwidth = Nut_WAF,
            id = Diameter,
            h = Nut_Thickness,
            pitch = Pitch,
            left_handed = Left_Handed,
            shape = Nut_Shape,
            starts = Starts,
            bevel = Nut_Outer_Bevel,
            bevel1 = Nut_Flush ? false : undef,
            ibevel = Nut_Inner_Bevel,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = BOTTOM
        );
}

/**
 * Creates a square threaded rod and nut.
 */
module square_thread() {
    render_rod()
        square_threaded_rod(
            d = Diameter,
            l = Rod_Length,
            pitch = Pitch,
            left_handed = Left_Handed,
            starts = Starts,
            bevel1 = Rod_Bevel_Bottom,
            bevel2 = Rod_Bevel_Top,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = $rod_anchor
        );
    render_nut()
        trapezoidal_threaded_nut(
            thread_angle = 0,
            nutwidth = Nut_WAF,
            id = Diameter,
            h = Nut_Thickness,
            pitch = Pitch,
            left_handed = Left_Handed,
            shape = Nut_Shape,
            starts = Starts,
            bevel = Nut_Outer_Bevel,
            bevel1 = Nut_Flush ? false : undef,
            ibevel = Nut_Inner_Bevel,
            blunt_start1 = Blunt_Start_Bottom,
            blunt_start2 = Blunt_Start_Top,
            end_len = End_Length,
            anchor = BOTTOM
        );
}
