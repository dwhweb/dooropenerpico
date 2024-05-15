use <screw_holes.scad>

// Screw posts, can have holes in the left, right or rear for brass M3 inserts for attaching the cover to the base
module screw_post(dimensions, left_hole=false, right_hole=false, rear_hole=false) {
    difference() {
      cube(dimensions);

      if(left_hole) {
        translate([-1, dimensions.y / 2, dimensions.z / 2]) rotate([0, 90, 0]) m3_insert_hole();
      }

      if(right_hole) {
        translate([dimensions.x - 5.5, dimensions.y / 2, dimensions.z / 2]) rotate([0, 90, 0]) m3_insert_hole();
      }

      if(rear_hole) {
        translate([dimensions.x / 2, dimensions.y - 5.5, dimensions.z / 2]) rotate([-90, 0, 0]) m3_insert_hole();
      }
    }
}
