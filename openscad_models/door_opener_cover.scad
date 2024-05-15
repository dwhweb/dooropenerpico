use <screw_holes.scad>

module side(wall_thickness, front_base, cover_height, screw_posts, rear_base, cover_height, rack_gap_translation, rack_bottom_width, rack_top_width, rack_gap_tolerance) {
  //Front
  translate([0, wall_thickness, 0]) {
    difference() {
      cube([wall_thickness, front_base.y - wall_thickness, cover_height]);
      translate([-1, screw_posts.y / 2, screw_posts.z / 2]) rotate([0, 90, 0]) m3_hole();
    }
  }

  //Back
  translate([0, front_base.y, rear_base.z - wall_thickness]) {
    difference() {
      cube([wall_thickness, rear_base.y, cover_height - rear_base.z + wall_thickness]);
      translate([-1, rack_gap_translation.y + ((rack_bottom_width - rack_top_width) / 2), -1]) cube([wall_thickness + 2, rack_top_width + rack_gap_tolerance, 5 + 1]);
    }
  }
}

module door_opener_cover(cover_height, wall_thickness, rear_base, servo_post, front_base, screw_posts, rack_top_width, rack_gap_translation, rack_top_width, rack_bottom_width, rack_gap_tolerance) {
  back = [front_base.x - (2 * wall_thickness), wall_thickness, cover_height - rear_base.z + wall_thickness]; // Back dimensions

  translate([0, 0, wall_thickness]) {
    // Front
    difference() {
      cube([rear_base.x, wall_thickness, cover_height]);
      translate([10, wall_thickness + 1, cover_height - 20]) rotate([90, 0, 0]) servo_hole();
    }

    // Left and right sides
    side(wall_thickness, front_base, cover_height, screw_posts, rear_base, cover_height, rack_gap_translation, rack_bottom_width, rack_top_width, rack_gap_tolerance);
    translate([front_base.x - wall_thickness, 0, 0]) side(wall_thickness, front_base, cover_height, screw_posts, rear_base, cover_height, rack_gap_translation, rack_bottom_width, rack_top_width, rack_gap_tolerance);

    // Back
    translate([wall_thickness, front_base.y + rear_base.y - wall_thickness, rear_base.z - wall_thickness]) {
      difference() {
        cube(back);
        translate([screw_posts.x / 2, -1, screw_posts.z / 2]) rotate([-90, 0, 0]) m3_hole();
        translate([back.x - (screw_posts.x / 2), -1, screw_posts.z / 2]) rotate([-90, 0, 0]) m3_hole();
      }
    }

    // Top
    translate([0, 0, cover_height]) cube([front_base.x, front_base.y + rear_base.y, wall_thickness]);
  } 
}
