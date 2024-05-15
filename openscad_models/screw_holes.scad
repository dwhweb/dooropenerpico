// Holes for old screws (2.5 x 16mm) that fit into the old opening rod
module old_hole(bottom_thickness, bracket_height) {
  translate([0, 0, bottom_thickness]) cylinder(d=6.3, h=bracket_height + 1); // Top portion of screw
  translate([0, 0, -1]) cylinder(d=3.2, h=bracket_height + 1); // Threaded part of screw
}

// Holes for 6x½ screws
module six_hole(bottom_thickness, bracket_height) {
  translate([0, 0, bottom_thickness]) cylinder(d=7, h=bracket_height + 1); // Top portion of screw
  translate([0, 0, -1]) cylinder(d=3.7, h=bracket_height + 1); // Threaded portion of screw
}

// Hole for M3 screws to pass through in cover and lid
module m3_hole(wall_thickness=5) {
  cylinder(h=wall_thickness + 2, d=3.4);
}

// Hole for M3 brass screw inserts
module m3_insert_hole() {
  cylinder(h=5.5 + 1, d=4.4);
}

// Hole for M2 brass screw inserts
module m2_insert_hole() {
  cylinder(h=2.7 + 1, d=3.1);
}

// Hole for reed switch screws
module reed_hole() {
  cylinder(h=7 + 1, d=2.7);
}

// Hole for the servo cable connector
module servo_hole(wall_thickness=5) {
  cylinder(h=wall_thickness + 2, d=8.5);
}

module cable_hole(dimensions) {
  difference() {
    cube(dimensions);

    // Cable hole
    translate([dimensions.x / 2, 0, dimensions.z / 2]) {
      translate([0, dimensions.y + 1.6, 0]) rotate([90, 0, 0]) cylinder(h=dimensions.y, d=28);
      translate([0, 1.6 + 1, 0]) rotate([90, 0, 0]) cylinder(h=1.6 + 2, d=26);
    }
  }
}

