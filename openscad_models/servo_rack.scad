use <gear_generator.scad>
use <screw_holes.scad>
include <BOSL2/std.scad>

/* [Main options] */
// Minimum length of the toothed portion of the rack. Note that the actual length generated is approximately 2.5mm longer at default tooth sizes.
minimum_length = 310;
// Determines whether to include holes for 2.5 x 16mm screws in the centre of the bracket or alternatively generate 4 6x½ screw holes. 
centre_holes = true;

/* [Cutting options] */
// Determines whether rack should be cut using a dovetail joint.
dovetail_rack = true;

// Point at which the rack should be cut, this includes the dimensions of the bracket potion (40mm).
cut_length = 240;

// Cut portion x spacing out from the right hand portion of the rack 
cut_x = 10;

// Cut portion y spacing out from the x axis 
cut_y = 60;

// Slop value, i.e. tolerance value for the dovetail joint, see https://github.com/BelfrySCAD/BOSL2/wiki/constants.scad#constant-slop
$slop = 0.20; 

module servo_rack(mm_per_tooth=5, rack_teeth=30, height=15, top_width=10, bottom_width=15) {
  half_tooth_height = outer_radius(mm_per_tooth, rack_teeth, 0) - pitch_radius(mm_per_tooth, rack_teeth);
  top_rack_height = height / 3; // Height of the top section of the rack, with the teeth
  angled_section_height = top_rack_height * 2; // Height of the bottom angled section of the rack
  bottom_height = top_rack_height - 2 * half_tooth_height; // Bottom of the teeth
  rack_length = rack_length(mm_per_tooth, rack_teeth); // 5mm per tooth plus the last section of 2.5mm at default settings

  // Coords for angled section at bottom of rack
  top_left_x = (bottom_width - top_width) / 2;
  top_right_x = top_left_x + top_width;

  top_x_trans = 3 * (0.25 * mm_per_tooth); // Translation to move top part up to the x axis
  top_y_trans = (top_width / 2) + ((bottom_width - top_width) / 2); // Translation to move the top part to the middle of the angled section
  top_z_trans = half_tooth_height + bottom_height + angled_section_height; // Translation to move the top part on top of the angled section

  translate([top_x_trans, top_y_trans, top_z_trans]) rotate([90, 0, 0]) rack(mm_per_tooth, rack_teeth, top_width, top_rack_height);
  rotate([0, 90, 0]) linear_extrude(height=rack_length) rotate([0, 0, 90]) polygon([[0, 0], [top_left_x, angled_section_height], [top_right_x, angled_section_height], [bottom_width, 0]]);
}

// Fully assembled rack with bracket attached
module assembled_rack(bracket_dimensions = [40, 70, 20]) {
  rack_bottom_width = 15;
  mm_per_tooth = 5;
  rack_teeth = no_of_teeth(5, minimum_length); // Rack section of length minimum_length (default 310mm)
  rack_length = rack_length(mm_per_tooth, rack_teeth);

  servo_rack(mm_per_tooth=mm_per_tooth, rack_teeth=rack_teeth, bottom_width=rack_bottom_width);
  translate([rack_length, bracket_dimensions.y / 2 + rack_bottom_width / 2, 0]) rack_bracket(bracket_dimensions, 3);
}

// Rack cut at cut_length for gluing together after print, this is intended to be printed diagonally (at 45 degrees) on a 220mm x 220mm printer
module cut_rack(cut_length=cut_length, bracket=[40, 70, 20], teeth=no_of_teeth(5, minimum_length), bottom_width=15) {
  bounding_box = rack_bounding_box(rack_teeth=teeth, bracket_dimensions=bracket);
  left_length = bounding_box.y - cut_length; // Leftover length on the left hand side once the cut side is accounted for
  

  // Portion with bracket
  intersection() {
    translate([bottom_width / 2, -left_length, -bounding_box.z / 2]) rotate([0, 0, 90]) assembled_rack();
    rack_mask(bounding_box);
  }

  // Cut portion
  //translate([bottom_width + 0.5 * bottom_width, left_length + (0.25 * cut_length), 0]) 
  translate([bottom_width + cut_x, left_length + cut_y, 0]) 

  intersection() {
    translate([bottom_width / 2, -left_length, -bounding_box.z / 2]) rotate([0, 0, 90]) assembled_rack();
    rack_mask(bounding_box, inverse=true);
  }
}

module rack_mask(bounding_box, inverse=false) {
  partition_mask(l=bounding_box.x, w=bounding_box.y, h=bounding_box.z, cutpath="dovetail", cutsize=6, inverse=inverse);
}

module rack_bracket(dimensions, bottom_thickness) {
  $fn = 50;

  bracket_points = [
    [0, 0],
    [-dimensions.z, 0],
    [0, dimensions.x]
  ];

  difference() {
    rotate([0, 90, -90]) linear_extrude(height=dimensions.y) polygon(bracket_points);

    translate([dimensions.x / 2, -dimensions.y / 2, 0]) {
      // Generate with 2.5 x 16mm holes if parameter is set, otherwise generate all 6x½ holes
      if(centre_holes) {
        // Centre holes for old screws that fit into the existing opening rod, spaced at 10mm interval
        translate([0, 5, 0]) old_hole(bottom_thickness, dimensions.z);
        translate([0, -5, 0]) old_hole(bottom_thickness, dimensions.z);

        // New holes
        translate([0, -dimensions.y / 3.5, 0]) six_hole(bottom_thickness, dimensions.z);
        translate([0, dimensions.y / 3.5, 0]) six_hole(bottom_thickness, dimensions.z);
      } else {
        interval = (dimensions.y / 12);
        translate([0, interval * 5, 0]) old_hole(bottom_thickness, dimensions.z);
        translate([0, interval, 0]) old_hole(bottom_thickness, dimensions.z);
        translate([0, -interval, 0]) old_hole(bottom_thickness, dimensions.z);
        translate([0, -interval * 5, 0]) old_hole(bottom_thickness, dimensions.z);
      }
    } 
  }
}

// Tells you the minimum number of teeth you need for a rack with a given number of mm per tooth and a length, note that the resulting rack may be longer than the required length
function no_of_teeth(mm_per_tooth=5, length) = ceil((length - (0.5 * mm_per_tooth)) / mm_per_tooth);

// Tells you the exact length of a rack given the mm per tooth and number of rack teeth
function rack_length(mm_per_tooth, rack_teeth) = (mm_per_tooth * rack_teeth) + (0.5 * mm_per_tooth);

// Returns the bounding box of the rack, x and y are reversed for use with the BOSL2 library (bracket dimensions are also reversed)
function rack_bounding_box(mm_per_tooth=5, rack_teeth, height=15, bottom_width=15, bracket_dimensions) = [bracket_dimensions.y, rack_length(mm_per_tooth, rack_teeth) + bracket_dimensions.x, bracket_dimensions.z];

if(dovetail_rack) {
  cut_rack();
} else {
  assembled_rack();
}
