use <screw_holes.scad>

// Mounting bracket, used for door opener, switch panel and pico case
module mounting_bracket(dimensions, bottom_spacing) {
    bracket_points = [
      [0, 0],
      [-dimensions.z, 0],
      [0, dimensions.y]
    ];

    difference() {
      rotate([0, 90, 0]) linear_extrude(height=dimensions.x) polygon(bracket_points);
      translate([dimensions.x / 2, dimensions.y / 2, 0]) six_hole(bottom_spacing, dimensions.z);
    }
}
