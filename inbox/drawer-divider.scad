
/* [Drawer/Divider Parameters] */
// total height of each divider wall
drawer_depth = 50;
// internal drawer width (X-axis constraint)
drawer_width = 200;
// internal drawer length (Y-axis constraint)
drawer_length = 200;
// thickness of divider walls
divider_thickness = 3.5; // [1.5:.5:4]
// max length you can print (will auto split in horizontal dividers)
max_print_length = 250;

/* [Columns and Rows] */
// Number of columns
columns = 3; // [1:6]
// Number of rows
rows = 4;    // [1:6]

/* [Special Cell] */
// Column spanning of the first cell
colspan = 1; // [1:6]
// Row spanning of the first cell
rowspan = 2; // [1:6]


/* [Pattern Parameters] */
// which pattern to put on the dividers
pattern="honeycomb 🐝"; // [none 🛇, honeycomb 🐝, pill 💊]
// the thickness of the border around the pattern
pattern_border_thickness=2; // [1:8]

/* [Honeycomb 🐝 Pattern Parameters] */
// radius of each hexagon (tweak these to prevent overhangs on top row)
cell_radius = 3; // [3:0.1:10]
// spacing between adjacent hexagons
cell_gap = 1.4; // [1:0.1:10]


/* [Pill 💊 Pattern Parameters] */
// vertical spacing between pill rows
pill_vertical_gap = 4; // [3:10]
// horizontal spacing between adjacent pills
pill_horizontal_gap = 1; // [1:8]
// total height of each pill
pill_height = 8; // [1:17]
// radius of rounded ends (half pill width)
pill_radius = 1.5; // [.5:0.1:2]
// stagger offset between alternate rows
pill_offset = 5; // [0:5]


/* [Junction Parameters] */
// Junction block dimensions
// the thickness of the junction out from the divider center
junction_thickness = 9;      
// the width of the junction along the divider
junction_width     = 10;      
junction_height    = drawer_depth; // block's height in y
// tweak at if things are too loose or too big
dovetail_clearence   = 0.05; //[0:.01:.3]

// height of each tooth (cut depth, not 1:1 with size)
teeth_height = (junction_thickness+.6)*2 - divider_thickness -1;

////////////////////////////////////////////////////////////
// DOVETAIL LIBRARY (unchanged from hugokernel)
// see https://github.com/hugokernel/OpenSCAD_Dovetail
////////////////////////////////////////////////////////////

module dovetail_teeth(width, height, thickness) {
    offset = width / 3;
    translate([-width/2, -height/2, 1]) {
        linear_extrude(height = thickness) {
            polygon([
                [0, 0],
                [width, 0],
                [width - offset, height],
                [offset, height]
            ]);
        }
    }
}

module dovetail(width, teeth_count, teeth_height, teeth_thickness, clear = dovetail_clearence, male = true, debug = false) {
    y = ((width - 1 * 2 * clear) / 1) / 4;
    compensation = -0.1;
    teeth_width = y * 3;
   
    // echo(teeth_width);
    offset = teeth_width / 3;
    start_at = clear * 2 + teeth_width/2 - width/2 - clear;
   
    translate([0, 0, -teeth_thickness/2]) {
        if (debug) {
            translate([-width/2, 0, -width/2]) {
                %cube(size = [width, 0.01, width]);
            }
        }
        for (i = [-1 : 1 * 2 - 1]) {
            x = start_at + y/2 + (teeth_width - offset + clear) * i;
            if (i % 2) {
                x = x + 0.1;
                translate([x + compensation, -clear, 0]) {
                    rotate([0, 0, 180]) {
                        if (male == true) {
                            dovetail_teeth(teeth_width - clear, teeth_height - clear, teeth_thickness);
                        }
                    }
                }
            } else {
                translate([x, clear, 0]) {
                    if (male == false) {
                        dovetail_teeth(teeth_width - clear, teeth_height - clear, teeth_thickness);
                    }
                }
            }
        }
    }
}

module cutter(position, dimension, teeths, male = true, debug = false) {
    translate(position) {
        dovetail(dimension[0], teeths[0], teeths[1], dimension[2], teeths[2], male, debug);
        if (male) {
            translate([
                -dimension[0]/2,
                -(teeths[1]/2 - 0.1) - dimension[1],
                -dimension[2]/2
            ]) {
                cube(size = dimension, center = false);
            }
        } else {
            translate([
                -dimension[0]/2,
                teeths[1]/2 - 0.1,
                -dimension[2]/2
            ]) {
                cube(size = dimension, center = false);
            }
        }
    }
}

////////////////////////////////////////////////////////////
// UTILITY MODULES
////////////////////////////////////////////////////////////

// 2D rectangle
module rect(w, h) {
    square([w, h], center = false);
}

// Honeycomb pattern (fully staggered)
module honeycombPattern(w, h) {
    col_spacing = sqrt(3)*cell_radius + cell_gap;
    row_spacing = 1.5*cell_radius + cell_gap;
    // add some margin so partial cells still get cut out
    rows = ceil(h / row_spacing) + 2;
    cols = ceil(w / col_spacing) + 2;
   
    for (row = [0 : rows - 1]) {
        for (col = [0 : cols - 1]) {
            x = col*col_spacing + (row % 2)*(col_spacing/2);
            y = row*row_spacing;
            // no 'if' bc difference() handles clipping
            translate([x, y])
                polygon(points = [
                    [0, cell_radius],
                    [(sqrt(3)*cell_radius)/2, cell_radius/2],
                    [(sqrt(3)*cell_radius)/2, -cell_radius/2],
                    [0, -cell_radius],
                    [-(sqrt(3)*cell_radius)/2, -cell_radius/2],
                    [-(sqrt(3)*cell_radius)/2, cell_radius/2]
                ]);
        }
    }
}

module pillPattern(w, h) {
    // Calculate spacing
    x_spacing = pill_vertical_gap ;
    y_spacing = pill_height + pill_horizontal_gap;
   
    // Create the pattern
    intersection() {
        // Solid background
        square([w, h]);
       
        // Create the pattern of vertical pill-shaped holes
        for (col = [0:ceil(w/x_spacing)]) {
           
            y_offset = (col % 2) ?  pill_offset : 0;
         
            for (row = [0:ceil(h/y_spacing)*2]) {
                x = col * x_spacing;
                y = row * y_spacing;

                if (x < w && y < h) {                    
                    if (y+y_offset+pill_height - pill_horizontal_gap <= h && y+y_offset - pill_height >=0){
                        translate([x + pill_vertical_gap/2, y + y_offset])
                        pill_shape(pill_vertical_gap, pill_height, pill_radius);
                    }
                }
            }
        }
    }
}

// Helper module to create rounded pill shape
module pill_shape(width, height, radius) {
    hull() {
        translate([radius, -height/2 + radius])
            circle(r=radius, $fa=5, $fs=0.5);
        translate([radius, height/2 - radius])
            circle(r=radius, $fa=5, $fs=0.5);
    }
}


// Calculate equally spaced junctions for a divider
function equal_junction_positions(num_junctions, jwidth, total_length) =
    let(
        // Calculate space available for segments
        available_space = total_length - (num_junctions * jwidth),
        // Calculate segment length (all equal)
        segment_length = available_space / (num_junctions + 1),
        // Generate junction positions
        positions = [for (i = [1 : num_junctions])
                     i * segment_length + (i-1) * jwidth]
    )
    positions;

// Junction positions: evenly space junction blocks along x, including ends
function junction_positions(num_internal, jwidth, total_length) =
    let(
        total_junctions = num_internal + 2,
        gap = (total_length - total_junctions * jwidth) / (total_junctions - 1)
    )
    [ for (i = [0 : total_junctions - 1])
        i * (jwidth + gap)
    ];

// Base panel: full 2D shape with honeycomb cutout (borders preserved)
module base_panel_2d(len, ht) {
     union() {
        // create border frame
        difference() {
            rect(len, ht);
            translate([pattern_border_thickness, pattern_border_thickness])
                rect(len - 2*pattern_border_thickness, ht - 2*pattern_border_thickness);
        }
   
        difference() {
            rect(len, ht);
            translate([
                pattern_border_thickness,
                pattern_border_thickness
            ]){
                if (pattern=="pill 💊")
                    pillPattern((len - 2*pattern_border_thickness),(ht - 2*pattern_border_thickness));
               
                if (pattern=="honeycomb 🐝")
                    honeycombPattern((len - 2*pattern_border_thickness),(ht - 2*pattern_border_thickness));
            }
        }
    }
}

////////////////////////////////////////////////////////////
// JUNCTION BLOCKS (unchanged)
////////////////////////////////////////////////////////////

// Junction block with dovetail channel (female)
module junction_block_with_dovetail_channel_female() {
    single_tooth = [1, teeth_height, 0.2];

    difference() {
        // main block + side triangles
        rotate([90, 0, 0]) {
            union() {
                // the original rectangular block
                cube([junction_width, junction_thickness, junction_height], center = false);

                // left triangle
                  linear_extrude(height = junction_height)
                    polygon(points = [
                        [0, 0],                  // bottom corner
                        [-junction_width/6, junction_thickness],    // top corner
                        [junction_width, junction_thickness] // out to the left
                    ]);
                // right triangle
                linear_extrude(height = junction_height)
                    polygon(points = [
                        [junction_width, 0],
                        [junction_width+junction_width/6, junction_thickness],
                        [0, junction_thickness]
                    ]);
                
                  // bludge on the back
                linear_extrude(height = junction_height)
                    polygon(points = [
                        [junction_width/2,junction_thickness + divider_thickness/3],
                        [junction_width +junction_width/6, junction_thickness],
                        [-junction_width/6, junction_thickness]
                    ]);
            }
        }

        // the dovetail channel
        rotate([90, 0, 0]) {
            cutter(
                [0, 0, 0],
                [junction_width, junction_thickness, junction_height * 2],
                single_tooth,
                true
            );
        }
    }
}


// Junction block with dovetail (male)
module junction_block_with_dovetail_channel_male() {
    single_tooth = [1, teeth_height, .2 + dovetail_clearence];
   
    intersection() {
        rotate([90, 0, 0]) {
            cube([junction_width, junction_thickness, junction_height], center = false);
        }
        rotate([90, 0, 0]) {
            cutter(
                [0, 0, 0],
                [junction_width, junction_thickness, junction_height*2],
                single_tooth,
                true
            );
        }
    }
}

////////////////////////////////////////////////////////////
// DIVIDER MODULES (unchanged)
////////////////////////////////////////////////////////////

// Create a vertical divider with male dovetails at ends
module vertical_divider(height) {
    linear_extrude(height = divider_thickness)
        base_panel_2d(height, drawer_depth);
       
    // Add male dovetail at ends
    y = ((junction_width - 1 * 2 * dovetail_clearence) / 1) / 4;
    teeth_width = y * 3;
    offset = (junction_width - teeth_width) / 2;
   
    // Top end
    rotate([0, 270, 0]) {
        translate([
            -offset - teeth_width/2 + divider_thickness/2,
            drawer_depth,
            -(teeth_height-((.2 + dovetail_clearence)*3))/2
        ]) {
            junction_block_with_dovetail_channel_male();
        }
    }
   
    // Bottom end
    translate([height, 0, 0]) {
        rotate([0, 90, 0]) {
            translate([
                -offset - teeth_width/2 - divider_thickness/2,
                drawer_depth,
                -(teeth_height-((.2 + dovetail_clearence)*3))/2
            ]) {
                junction_block_with_dovetail_channel_male();
            }
        }
    }
}

// Create a horizontal divider segment with honeycomb pattern
module horizontal_divider_segment(length) {
    // Just the basic divider with honeycomb pattern, no junctions
    linear_extrude(height = divider_thickness)
        base_panel_2d(length, drawer_depth);
}


// helper function that takes a candidate split boundary (cand) and 
// adjusts it if it lies too close to any junction in the list jps.
// buf is the minimum allowed distance from a junction.
// if cand is within buf distance of any junction, it shifts the candidate 
// away (using the first junction found in proximity).
function adjust_boundary(cand, jps, buf) =
    let ( close = [ for (jp = jps) if (abs(cand - jp) < buf) jp ] )
    ( len(close) > 0 ) ?
         ( cand < close[0] ? close[0] - buf : close[0] + buf )
         : cand;

// module to create a horizontal divider with aligned junctions.
// this version splits the divider equally into sections (nsections)
// that are no longer than max_print_length. additionally, if a section 
// boundary (split) is within a defined distance (split_junction_buffer)
// of any junction, the boundary is shifted to avoid a conflict.
module horizontal_divider_with_aligned_junctions(total_length, junction_positions, borders_special_cell=false) {
    // if the divider fits within one print, process as usual
    if (total_length <= max_print_length) {
        // iterate over each segment (delimited by junctions) to draw the divider segments
        for (i = [0 : len(junction_positions)]) {
            start_pos = (i == 0) ? 0 : junction_positions[i-1] + junction_width;
            end_pos = (i == len(junction_positions)) ? total_length : junction_positions[i];
            if (end_pos > start_pos)
                translate([start_pos, 0, 0])
                    horizontal_divider_segment(end_pos - start_pos);
        }
        // add the female dovetail junctions along the divider
        for (pos = junction_positions) {
    
                translate([pos, drawer_depth, -junction_thickness + (divider_thickness + 1 - .6) / 2])
                    junction_block_with_dovetail_channel_female();
      
                rotate([180, 0, 0])
                translate([pos, 0, -junction_thickness - divider_thickness + (divider_thickness + 1 - .6) / 2])
                    junction_block_with_dovetail_channel_female();
        }
        // calculate male dovetail parameters
        y = ((junction_width - 1 * 2 * .2) / 1) / 4;
        teeth_width = y * 3;
        offset = (junction_width - teeth_width) / 2;
        // add male junction at the left end if necessary
        if (borders_special_cell == false)
            rotate([0, 270, 0])
                translate([ -offset - teeth_width/2 + divider_thickness/2, drawer_depth,
                           -(teeth_height - ((.2 + dovetail_clearence) * 3)) / 2 ])
                    junction_block_with_dovetail_channel_male();
        // add male junction at the right end
        translate([ total_length, 0, 0 ])
            rotate([0, 90, 0])
                translate([ -offset - teeth_width/2 - divider_thickness/2, drawer_depth,
                           -(teeth_height - ((.2 + dovetail_clearence) * 3)) / 2 ])
                    junction_block_with_dovetail_channel_male();
    } else {
        // parameter to set how close a section boundary can be to a junction
        split_junction_buffer = junction_width*2;  // tweak this value as needed

        // compute the number of equally spaced sections (each section will be <= max_print_length)
        nsections = ceil(total_length / max_print_length);
        base_section_length = total_length / nsections;

        // compute the boundaries for all sections.
        // the first and last boundaries remain fixed (0 and total_length),
        // intermediate boundaries are adjusted if too close to any junction.
        split_boundaries = [ for (i = [0 : nsections])
            ( i == 0 ) ? 0 : ( i == nsections ) ? total_length
            : adjust_boundary(i * base_section_length, junction_positions, split_junction_buffer)
        ];

        // loop over each section defined by the computed split boundaries
        for (s = [0 : len(split_boundaries) - 2]) {
            section_start = split_boundaries[s];
            section_end = split_boundaries[s+1];
            section_length = section_end - section_start;

            // filter junctions that fall within this section and convert them to local section coordinates
            section_junctions = [ for (jp = junction_positions)
                if (jp >= section_start && jp <= section_end)
                    jp - section_start
            ];

            // draw the divider segments for the current section using its local junction positions
            translate([section_start, 0, 0]) {
                for (i = [0 : len(section_junctions)]) {
                    start_pos = (i == 0) ? 0 : section_junctions[i-1] + junction_width;
                    end_pos = (i == len(section_junctions)) ? section_length : section_junctions[i];
                    if (end_pos > start_pos)
                        translate([start_pos, 0, 0])
                            horizontal_divider_segment(end_pos - start_pos - 1);
                }
                // add female dovetail junctions for this section (with blue and green orientations)
                for (pos = section_junctions) {
                    color("blue")
                        translate([ pos, drawer_depth, -junction_thickness + (divider_thickness + 1 - .6) / 2 ])
                            junction_block_with_dovetail_channel_female();
                    color("green")
                        rotate([180, 0, 0])
                        translate([ pos, 0, -junction_thickness - divider_thickness + (divider_thickness + 1 - .6) / 2 ])
                            junction_block_with_dovetail_channel_female();
                }
                // recalc male dovetail parameters for this section
                y = ((junction_width - 1 * 2 * .2) / 1) / 4;
                teeth_width = y * 3;
                offset = (junction_width - teeth_width) / 2;
                // add male junction at the left boundary of the section
                
                if (borders_special_cell==true && s != 0 || borders_special_cell==false){
                    rotate([0, 270, 0])
                        translate([ -offset - teeth_width/2 + divider_thickness/2, drawer_depth,
                                   (-(teeth_height - ((.2 + dovetail_clearence) * 3)) / 2) ])
                            junction_block_with_dovetail_channel_male();
                }
                
                 if (borders_special_cell==true && s == 0){
                     color("blue")
                        translate([ -junction_width/2, drawer_depth, -junction_thickness + (divider_thickness + 1 - .6) / 2 ])
                            junction_block_with_dovetail_channel_female();
                    color("green")
                        rotate([180, 0, 0])
                        translate([ -junction_width/2, 0, -junction_thickness - divider_thickness + (divider_thickness + 1 - .6) / 2 ])
                            junction_block_with_dovetail_channel_female();
                }

                // at the right boundary of the section:
                // if this is not the last section, add a rotated female junction to avoid splitting a junction
                if (section_end < total_length)
                    translate([section_length, 0, 0])
                        rotate([0, 90, 0])
                            translate([ -offset - teeth_width/2 - divider_thickness/2, 0,
                                      ((teeth_height - ((.2 + dovetail_clearence) * 3)) / 2) ])
                                rotate([180, 0, 0])
                                    junction_block_with_dovetail_channel_female();
                // else, for the last section add the male junction as usual
                else{
                    translate([section_length, 0, 0])
                        rotate([0, 90, 0])
                            translate([ -offset - teeth_width/2 - divider_thickness/2, drawer_depth,
                                       -(teeth_height - ((.2 + dovetail_clearence) * 3)) / 2 ])
                                junction_block_with_dovetail_channel_male();
                }
            }
        }
    }
}

// Create adaptable grid with special cell
module create_adaptable_grid() {
    // Add a junction gap parameter to visually separate connections
    junction_gap = 25;  // Size of gap between junctions (for display only)
   
    // Ensure colspan and rowspan don't exceed grid dimensions
    real_colspan = min(colspan, columns);
    real_rowspan = min(rowspan, rows);
   
    // Calculate cell dimensions (logical sizing)
    cell_width = drawer_width / columns;
    cell_height = drawer_length / rows;
    
    echo("cell_width",cell_width);
    echo("cell_height",cell_height);
   
    // Calculate special cell dimensions (logical)
    special_width = real_colspan * cell_width;
    special_height = real_rowspan * cell_height;
   
    // Function to calculate visual y positions with spacing gaps
    function visual_y(index) =
        (index == 0) ? 0 : // Shift first row up by half gap
        (index * cell_height );
   
    // Calculate logical positions for all dividers (unchanged)
    v_dividers_logical = [for (c = [1 : columns-1]) c * cell_width - junction_width/2];
    h_dividers_logical = [for (r = [1 : rows-1]) r * cell_height];
   
    // Get visual y positions of all horizontal dividers
    h_positions = [for (r = [0 : rows]) visual_y(r)];
   
    // Place horizontal dividers
    for (r = [1 : rows-1]) {
        visual_pos_y = visual_y(r);
       
        // Check if this divider crosses the special cell
        if (r < real_rowspan) {
            // This divider crosses the special cell, place a segment to the right of it
            if (real_colspan < columns) {  // Only if the special cell doesn't span all columns
                translate([real_colspan * cell_width, visual_pos_y + ((junction_gap * r)-junction_gap/2 + divider_thickness/2), 0]) {
                    rotate([90, 0, 0]) {
                       
                        // Use logical junction positions (not affected by junction_gap)
                        junctions = [for (c = [real_colspan : columns-1])
                                    (c - real_colspan) * cell_width - junction_width/2];
                       
                        horizontal_divider_with_aligned_junctions(
                            drawer_width - special_width,
                            junctions,
                            true
                        );
                    }
                }
            }
        } else {
            // This divider doesn't cross the special cell, place a full divider
            translate([0, visual_pos_y + ((junction_gap * r)-junction_gap/2 + divider_thickness/2), 0]) {
                rotate([90, 0, 0]) {
                    // Use logical junction positions (not affected by junction_gap)
                    horizontal_divider_with_aligned_junctions(
                        drawer_width,
                        v_dividers_logical
                    );
                }
            }
        }
    }
   
    // Place vertical dividers
    for (c = [1 : columns-1]) {
        logical_pos_x = c * cell_width;
       
        // Check if this divider crosses the special cell
        if (c < real_colspan) {
            // This divider crosses the special cell
            if (real_rowspan < rows) {  // Only if the special cell doesn't span all rows
                // Get positions for dividers after the special cell
                for (i = [real_rowspan : rows-1]) {
                    segment_start = h_positions[i];
                    segment_end = h_positions[i+1];
                    segment_height = segment_end - segment_start - ((rows-1)*divider_thickness)/rows;
                    
                    echo("segment_height", segment_height)
                   
                    // Place the vertical divider segment at logical x position
                    translate([logical_pos_x - divider_thickness/2, segment_start + junction_gap * i, 0]) {
                        rotate([90, 0, 90]) {
                            vertical_divider(segment_height);
                        }
                    }
                }
            }
        } else {
            // This divider doesn't cross the special cell
            // Place segments between each pair of horizontal dividers
            for (i = [0 : rows-1]) {
                segment_start = h_positions[i] ;
                segment_end = h_positions[i+1];
                segment_height = segment_end - segment_start - ((rows-1)*divider_thickness)/rows ;
                
                    echo("segment_height", segment_height)
               
                // Place the vertical divider segment at logical x position
                translate([logical_pos_x- divider_thickness/2, segment_start + junction_gap * i, 0]) {
                    rotate([90, 0, 90]) {
                        vertical_divider(segment_height);
                    }
                }
            }
        }
    }
}

// Render the grid
translate([-drawer_width/2, -drawer_length/2, 0])
    create_adaptable_grid();