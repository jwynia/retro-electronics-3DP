include <BOSL2/std.scad>;
include <BOSL2/threading.scad>;

/**
 * Cirkit Pods v1.0
 * 
 * Author: Jason Koolman
 * 
 * Description:
 * This OpenSCAD script creates modular, parametric storage containers, 
 * known as Cirkit Pods. These containers feature customizable, threaded 
 * segments for various shapes and sizes with secure, screw-on connections. 
 * Stackable modules allow for versatile configurations to meet specific 
 * storage needs.
 * 
 * License:
 * This code is shared under the CC BY-NC-SA 4.0 license: 
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 * 
 * You are free to:
 * - Share: Copy and redistribute the material in any medium or format.
 * - Adapt: Remix, transform, and build upon the material.
 *
 * Under the following terms:
 * - Attribution: Credit the original author.
 * - NonCommercial: For non-commercial use only.
 * - ShareAlike: Derivatives must be shared under the same license.
 *
 * Contributions to enhance the code or design are greatly appreciated.
 * For commercial use, please contact the author.
 */

/* [Container] */

// Inner diameter of the container
Container_Diameter = 40;
// Height of the container body excluding the ring
Container_Height = 34;
// Wall thickness of the container excluding texture depth
Container_Wall = 2.2;
// Thickness of the container base
Container_Base = 3.4;
// Outer rounding radius for the container bottom
Container_Rounding = 10;
// Inner rounding radius for the container's hollow space
Container_Inner_Rounding = 4;
// Toggle teardrop rounding for better overhangs
Container_Teardrop = true;

assert(Container_Diameter >= 20, "Container_Diameter must be at least 20mm.");
assert(Container_Height > 5, "Container_Height must be greater than 5mm.");
assert(Container_Wall >= 1, "Container_Wall must be at least 1mm.");
assert(Container_Base >= 1, "Container_Base must be at least 1mm.");
assert(Container_Rounding >= 0, "Container_Rounding cannot be negative.");
assert(Container_Inner_Rounding >= 0, "Container_Inner_Rounding cannot be negative.");

/* [Texture] */

// Texture type for the container's surface pattern
Texture_Type = "Ribs"; // ["Ribs", "Diamonds", "Swirl", "Checkers", "Squares", "Triangles", "Bricks", "None"]
// Depth of texture pattern on container surface
Texture_Depth = 1.8;
// Custom texture size to override the default (e.g., "4,8")
Texture_Size = "";

assert(Texture_Depth >= 0, "Texture_Depth cannot be negative.");

/* [Ring] */

// Height of the ring section
Ring_Height = 10;
// Chamfer at the outer edges of the ring
Ring_Chamfer = 1;
// Height of the connected ring section
Ring_Connected_Height = 6;

assert(Ring_Height > 0, "Ring_Height must be greater than 0mm.");
assert(Ring_Chamfer >= 0, "Ring_Chamfer cannot be negative.");
assert(Ring_Connected_Height > 0, "Ring_Connection_Height must be greater than 0mm.");

/* [Thread] */

// Height of the threaded sections
Thread_Height = 7.8;
// Pitch (distance between threads) of the thread
Thread_Pitch = 3.8;
// Depth of the thread profile
Thread_Depth = 1;
// Flank angle of the threads
Thread_Flank_Angle = 45;
// Wall thickness of the threaded section
Thread_Wall = 1.4;
// Wall chamfer on the inside of the thread wall
Thread_Wall_Chamfer = 0.6;
// Use a blunt start for the thread
Thread_Blunt_Start = false;

assert(Thread_Height >= 4, "Thread_Height must be at least 4mm.");
assert(Thread_Pitch > 0.2, "Thread_Pitch is too small; it must be greater than 0.2 for practical threading.");
assert(Thread_Depth < (Thread_Pitch / 2), "Thread_Depth is too large relative to the pitch; it must be less than half the pitch to avoid interference.");
assert(Thread_Flank_Angle >= 15 && Thread_Flank_Angle <= 45, "Thread_Flank_Angle must be between 15 and 45 degrees for a trapezoidal thread.");
assert(Thread_Wall_Chamfer <= Thread_Wall, "Thread_Wall_Chamfer cannot exceed Thread_Wall thickness.");
assert(Thread_Height < Ring_Height - Thread_Wall, "Thread_Height is larger than the available ring height.");

/* [Render] */

// Minimum angle for a fragment in degrees
Face_Angle = 2; // [1:1:15]
// Minimum size of a fragment in mm
Face_Size = 0.2; // [0.1:0.1:1]
// Clearance for assembly tolerance with 3D Printing
Slop = 0.12;
// Toggle debug mode
Debug = false;

assert(Face_Angle >= 0 && Face_Angle <= 15, "Face_Angle must be greater than 0 and not exceed 15 for practical smoothness.");
assert(Face_Size > 0 && Face_Size <= 1, "Face_Size must be greater than 0 and no more than 1 mm to maintain model integrity.");
assert(Slop >= 0 && Slop <= 0.4, "Slop should be non-negative and no more than 0.4 mm to ensure proper thickness.");

// Apply settings globally
$fa = Face_Angle;
$fs = Face_Size;

/* [[Optional] Hole] */

// Outer diameter of the hole (can be added to a bottom and top)
Hole_Diameter = 20;
// Chamfer size for the edge of the hole
Hole_Chamfer = 1;

assert(Hole_Diameter > 0, "Hole_Diameter must be greater than 0mm.");
assert(Hole_Diameter < Container_Diameter, "Hole_Diameter must be less than Container_Diameter.");
assert(Hole_Chamfer >= 0, "Hole_Chamfer must be at least 0mm.");
assert(Hole_Chamfer <= Container_Base / 2, "Hole chamfer cannot exceed half of Container_Base.");

/* [[Optional] Text] */

// Text to be displayed (can be added to a bottom, top and lid)
Text = "CK";
// Size of the text in units
Text_Size = 16;
// Height (thickness) of the text
Text_Height = 1;
// Font used for rendering the text
Text_Font = "Liberation Sans:style=bold";
// Rotation of the text around the Z-axis in degrees
Text_Rotation = 0;

assert(Text_Size >= 6, "Text_Size must be at least 6.");
assert(Text_Height > 0, "Text_Height must be greater than 0mm.");

/* [[Optional] Tube] */

// Diameter of the tube (can be added to a connector)
Tube_Diameter = 12;
// Wall thickness of the tube
Tube_Wall = 3;
// Height of the tube
Tube_Height = 5;

assert(Tube_Diameter > 4, "Tube_Diameter must be greater than 4mm.");
assert(Tube_Wall >= 1, "Tube_Wall must be at least 1mm.");
assert(Tube_Height >= 1, "Tube_Height must be at least 1mm.");
assert(Tube_Wall < Tube_Diameter / 2, "Tube_Wall must be less than the tube radius.");

/* [[Model] Bottom] */

// Toggle rendering the bottom model
Render_Bottom = true;
// Toggle creating a hole in the bottom
Hole_Bottom = false;
// Toggle rendering text on the bottom
Text_Bottom = false;
// Color of the bottom
Color_Bottom = "#222222"; // color

/* [[Model] Top] */

// Toggle rendering the top model
Render_Top = true;
// Toggle creating a hole in the top
Hole_Top = false;
// Toggle rendering text on the top
Text_Top = false;
// Color of the top
Color_Top = "#222222"; // color

/* [[Model] Center] */

// Toggle rendering the center model
Render_Center = true;
// Color of the center model
Color_Center = "#222222"; // color

/* [[Model] Center Divider] */

// Toggle rendering the center divider
Render_Center_Divider = true;
// Color for the center divider
Color_Center_Divider = "#222222"; // color

/* [[Model] Connector] */

// Toggle rendering the connector
Render_Connector = true;
// Toggle adding a tube to the connector
Tube_Connector = true;
// Color of the connector
Color_Connector = "#222222"; // color

/* [[Model] Lid] */

// Toggle rendering the lid model
Render_Lid = true;
// Toggle creating a hole in the lid
Hole_Lid = false;
// Toggle rendering text on the lid
Text_Lid = true;
// Toggle adding a rope tube to the lid
Tube_Lid = false;
// Color of the lid
Color_Lid = "#222222"; // color


/* [Hidden] */

Container_Outer_Diameter = Container_Diameter + (Container_Wall * 2);
Thread_Diameter = Container_Diameter + (Thread_Depth * 2) + (Thread_Wall * 2);
Thread_Bridge = Thread_Wall + Thread_Depth;
Ring_Diameter = Container_Outer_Diameter + (Texture_Depth * 2) + (Ring_Chamfer * 2);

// Shift out to prevent two objects sharing the same face
Shift_Out = 0.01;  

// Constants
KEEP = "keep";
REMOVE = "remove";

/**
 * Creates a threaded rod with specified parameters.
 * @param internal - Boolean indicating if the thread is internal or external.
 * @param anchor - Anchor position for the thread.
 */
module create_threaded_rod(internal, anchor, orient, spin) {
    blunt = Thread_Blunt_Start;
    trapezoidal_threaded_rod(
        d = Thread_Diameter + (internal ? Slop * 2 : -Slop * 2),
        l = Thread_Height,
        pitch = Thread_Pitch,
        thread_depth = Thread_Depth,
        flank_angle = Thread_Flank_Angle,
        blunt_start = blunt,
        internal = internal,
        anchor = anchor,
        orient = orient,
        spin = spin,
        bevel2 = internal
            ? undef
            : blunt
            ? -Thread_Wall_Chamfer
            : 0,
    );
}

/**
 * Validates and extracts the texture size from the given string.
 * 
 * @param str - The input string representing the texture size (e.g., "4,8").
 * @return - An array [width, height] if the format is valid.
 */
function get_texture_size(str) = 
    let(parts = str_split(str, ","))
    len(parts) == 2
    ? [parse_int(parts[0]), parse_int(parts[1])]
    : assert(false, "Texture_Size must be in the format 'number,number' (e.g. '4,8')");


/**
 * Determines texture parameters based on the selected texture type.
 * @param type - The type of texture to apply.
 * @return - Array of parameters for the selected texture.
 */
function get_texture_params(type) =
    (type == "Ribs") ? [ "trunc_ribs", [4, 1], undef ] :
    (type == "Diamonds") ? [ "diamonds", [6, 6], "convex" ] :
    (type == "Swirl") ? [ "diamonds", [6, 3], "default" ] :
    (type == "Checkers") ? [texture("checkers", border=0.2), [8, 8], undef] :
    (type == "Triangles") ? [ "tri_grid", [6, 10], undef ] :
    (type == "Squares") ? [ "trunc_pyramids_vnf", [6, 6], "convex" ] :
    (type == "Bricks") ? [ "bricks_vnf", [10, 10], "default" ] :
    [ undef, undef, undef ];

/**
 * Conditionally renders a model with a specified color.
 * @param condition - Boolean to determine if the model should be rendered.
 * @param color_val - The color to apply if rendered.
 */
module render_model(condition, color_val) {
    if (condition) {
        color(color_val)
            children();
    }
}

/* Model modules */

// Creates the base container with texture and optional rounding
module model_base_container(rounded = true) {
    params = get_texture_params(Texture_Type);
    texture = params[0];
    texture_size = Texture_Size == "" ? params[1] : get_texture_size(Texture_Size);
    texture_style = params[2];
    round = rounded && Container_Rounding > 0;;

    up(round ? Texture_Depth : 0)
        cyl(
            h = round ? Container_Height - Texture_Depth : Container_Height,
            d = Container_Outer_Diameter,
            rounding1 = round ? Container_Rounding : undef,
            teardrop = Container_Teardrop,
            texture = texture,
            tex_size = texture_size,
            tex_depth = Texture_Depth,
            tex_style = texture_style,
            anchor = BOTTOM
        ) children();
}

// Generates the main container body with an optional hollow interior
module model_container(hollow = true) {
    difference() {
        union() {
            // Outer textured shell
            model_base_container(rounded = true);
            // Main container body
            cyl(
                h = Container_Height,
                d = Container_Outer_Diameter,
                rounding1 = Container_Rounding,
                teardrop = Container_Teardrop,
                anchor = BOTTOM
            ) children();
        }

        if (hollow) {
            // Hollow interior cutout, leaving a base thickness
            up(Container_Base)
                cyl(
                    h = Container_Height - Container_Base,
                    d = Container_Diameter,
                    rounding1 = Container_Inner_Rounding,
                    anchor = BOTTOM
                );
        }
    }
}

// Generates the external thread for a male connector
module model_external_thread(hollow = true) {
    difference() {
        create_threaded_rod(
            internal = false,
            orient = DOWN,
            spin = 180,
            anchor = TOP
        );            

        // Create a hollow cylinder with a chamfer at the top
        if (hollow) {
            cyl(
                d = Container_Diameter,
                h = Thread_Height,
                chamfer2 = -Thread_Wall_Chamfer,
                anchor = BOTTOM
            );
        }
    }
}

// Generates the internal thread for a female connector
module model_internal_thread(orient = DOWN, anchor) {
    difference() {
        cyl(
            h = Thread_Height,
            d = Thread_Diameter + Shift_Out,
            anchor = anchor,
            orient = orient
        );
        
        // Cut out internal thread from base shape
        create_threaded_rod(
            internal = true,
            orient = orient,
            anchor = anchor
        );
    }
}

// Generates a ring with optional hollow interior
module model_ring(hollow = true, connected = false) {
    height = connected ? Ring_Connected_Height : Ring_Height;

    difference() {
        cyl(
            h = height,
            d = Ring_Diameter,
            chamfer = Ring_Chamfer,
            anchor = BOTTOM
        ) children();

        if (hollow) {
            cyl(
                h = height,
                d = Container_Diameter,
                anchor = BOTTOM
            );
        }
    }
}

// Generates a ring with internal threading (requires parent diff)
module model_internal_threaded_ring() {
    model_ring(hollow = false) {
        // Internal thread with beveled chamfer
        tag(REMOVE) attach(TOP, TOP, inside = true)
            cyl(
                h = Thread_Height + Thread_Bridge,
                d = Thread_Diameter,
                chamfer1 = Thread_Bridge,
                chamfang1 = 50
            );

        tag(KEEP) position(TOP)
            model_internal_thread(orient = UP, anchor = TOP);
    }
}

// Generates a ring with external threading and optional hollow
module model_external_threaded_ring(hollow = true) {
    model_ring(connected = true, hollow = hollow) {
        position(TOP)
            model_external_thread(hollow = hollow);
    }
}

// Generates a ring internal and external threading (requires parent diff)
module model_hybrid_threaded_ring() {
    model_ring(hollow = false) {
        // Internal thread with beveled chamfer
        tag(REMOVE) attach(BOTTOM, TOP, inside = true)
            cyl(
                h = Thread_Height + Thread_Bridge,
                d = Thread_Diameter,
                chamfer1 = Thread_Bridge,
                chamfang1 = 50
            );

        tag(KEEP) position(BOTTOM)
            model_internal_thread(orient = DOWN, anchor = TOP);

        // External thread
        position(TOP)
            model_external_thread();
    }
}

// Generates a ring tube for rope or a keychain
module model_ring_tube() {
    tr = Tube_Diameter / 2;
    fwd((Ring_Diameter / 2) - Tube_Wall)
        diff()
            tube(
                or = tr,
                ir = tr - Tube_Wall,
                h = Tube_Height,
                anchor = BOTTOM+BACK,
                $fs = $fs * 3
            ) {
                tag(REMOVE) align(BACK, BOTTOM, overlap = Tube_Wall - Shift_Out * 2) model_ring(hollow=false);
            };
}

// Generates 3D text for the container base
module model_text() {
    down(Text_Height / 2)
        zrot(Text_Rotation)
            text3d(
                text = Text,
                h = Text_Height,
                font = Text_Font,
                size = Text_Size,
                anchor = CENTER,
                atype = "ycenter"
            );
}

// Generates a hole for the container base
module model_hole() {
    cyl(
        h = Container_Base + Shift_Out,
        d = Hole_Diameter,
        chamfer = -(Hole_Chamfer),
        anchor = BOTTOM
    );
}

/**
 * Renders the top segment with an external thread for attachment.
 */
module render_top() {
    diff()
    model_container() {
        position(TOP)
            model_external_threaded_ring();
        if (Hole_Top)
            tag(REMOVE) attach(BOTTOM, DOWN, inside = true) model_hole();
        if (Text_Top)
            tag(REMOVE) attach(BOTTOM) model_text();
    }
}

/**
 * Renders the bottom segment with an internal thread for closure.
 */
module render_bottom() {
    diff()
    zrot(2.7) // TODO: Aligns textures when assembled; consider alternative
    model_container() {
        position(TOP)
            model_internal_threaded_ring();
        if (Hole_Bottom)
            tag(REMOVE) attach(BOTTOM, DOWN, inside = true) model_hole();
        if (Text_Bottom)
            tag(REMOVE) attach(BOTTOM) model_text();
    }
}

/**
 * Renders a hollow center segment with internal and external threads.
 */
module render_center() {
    up(Ring_Height - Shift_Out)
    diff()
    model_base_container(rounded = false, hollow = false) {
        position(TOP)
            model_external_threaded_ring();
        attach(BOTTOM, DOWN)
            model_internal_threaded_ring();
        attach(BOTTOM, UP, inside = true)
            cyl(
                h = Container_Height,
                d = Container_Diameter,
                anchor = BOTTOM
            );
    }
}

/**
 * Renders a dividing center segment with internal and external threads.
 */
module render_center_divider() {
    height = (Container_Height + Thread_Height + Ring_Connected_Height);
    diff()
    yrot(180, cp = [0, 0, height / 2])
    model_base_container(rounded = false, hollow = false) {
        position(TOP)
            model_external_threaded_ring(hollow = false);
        attach(BOTTOM, DOWN)
            model_internal_threaded_ring();
        attach(BOTTOM, TOP, inside = true, shiftout = Shift_Out)
            cyl(
                d = Container_Diameter,
                h = height - Container_Base,
                rounding1 = Container_Inner_Rounding
            );
    }
}

/**
 * Renders a ring connector with both threads and an optional tube.
 */
module render_connector() {
    diff() {
        model_hybrid_threaded_ring();
    }
    if (Tube_Connector) {
        model_ring_tube();
    }
}

/**
 * Renders a lid with an external thread.
 */
module render_lid() {
    difference() {
        // Ring structure of the lid without hollowing
        diff() {
            model_ring(hollow = false) {
                position(TOP) model_external_thread();

                if (Text_Lid) {
                    tag(REMOVE) attach(BOTTOM) model_text();
                }
            }
        }

        // Hollow interior cutout
        up(Ring_Height)
            cyl(
                h = Ring_Height - Container_Base,
                d = Container_Diameter,
                rounding1 = Container_Inner_Rounding,
                orient = UP,
                anchor = TOP
            );

        // Center hole cutout
        if (Hole_Lid) model_hole();
    }

    if (Tube_Lid) model_ring_tube();
}

/**
 * Renders tubes and labels for various diameters.
 */
module debug_guide(h = Container_Base, wall = 1) {
    rd = Ring_Diameter;
    td = Container_Outer_Diameter + (Texture_Depth * 2);
    od = Container_Outer_Diameter;
    id = Container_Diameter;

    guides = [
        ["Ring diameter", rd, td, "coral"],
        ["Texture diameter", td, od, "orange"],
        ["Outer diameter", od, id, "gold"],
        ["Inner diameter", id, id, "white"]
    ];

    for (i = [0 : len(guides) - 1]) {
        guide = guides[i];

        color(guide[3])
            tube(h = h, od = guide[1], id = guide[2], anchor = BOTTOM);

        fwd(Container_Diameter + (i * 6))
            color(guide[3])
                text3d(
                    str(guide[0], ": ", guide[1], "mm"),
                    h = 0.2,
                    size = 3,
                    anchor = BOTTOM
                );
    }
}

/**
 * Renders an assembled model for debugging.
 * 
 * TODO: Make models attachable to allow for easier positioning.
 */
module debug_models() {
    bh = Container_Height + Ring_Height;
    rh = Ring_Height;
    th = Container_Height + Ring_Connected_Height;
    ch = Container_Height + Ring_Connected_Height + Ring_Height;

    render_bottom();

    up(bh + rh)
        yrot(180)
            color("lightgray") render_connector();
    
    up(bh + rh - Thread_Height)
        render_center_divider();

    up(bh + rh + th + ch)
        yrot(180)
            color("lightgray") render_top();

}

/**
 * Renders the debug view.
 */
module render_debug_view() {
    translate([-120, -120, 16]) frame_ref(16);
    back_half(s = 1000) debug_models();
    debug_guide();
}

/**
 * Arranges and renders models in a grid layout.
 */
module render_models() {
    grid = [for (i = [1:3]) Container_Outer_Diameter];

    ydistribute(sizes = grid, spacing = 20) {
        xdistribute(sizes = grid, spacing = 20) {
            render_model(Render_Connector, Color_Connector) render_connector();
            render_model(Render_Lid, Color_Lid) render_lid();
            render_model(Render_Center_Divider, Color_Center_Divider) render_center_divider();
        }
        xdistribute(sizes = grid, spacing = 20) {
            render_model(Render_Bottom, Color_Bottom) render_bottom();
            render_model(Render_Top, Color_Top) render_top();
            render_model(Render_Center, Color_Center) render_center();
        }
    }
}

// Render on screen
if (Debug) {
    render_debug_view();
} else {
    render_models();
}

