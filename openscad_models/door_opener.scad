use <gear_generator.scad>
use <servo_rack.scad>
use <mock_servo_assembly.scad>
use <door_opener_cover.scad>
use <mounting_bracket.scad>
use <servo_post.scad>
use <screw_post.scad>

// Rendering control, these values show in the OpenSCAD customiser.
// Show the cover in position to print, or in situ on the model.
print_positions = true; 
// Show the main base assembly.
show_base = true;
// Show the cover.
show_cover = true;
// Show a mock servo in position on the base.
show_mock_servo = false;
// Show an example rack.
show_rack = false;
// Height of the door, used to determine where the bottom of the rack is so it can be attached to the door.
door_height = 20;

module door_opener() {
  $fn = 100;
  wall_thickness = 5; // Thickness of base and outer walls
  mm_per_tooth = 5;
  rack_teeth = 30;
  back_spacing = 3 * wall_thickness; // Space between the back of the opener and the right hand side of the rack
  rack_height = 15;
  rack_top_width = 10;
  rack_bottom_width = 15;
  rack_tooth_height = 2 * (outer_radius(mm_per_tooth, rack_teeth, 0) - pitch_radius(mm_per_tooth, rack_teeth));
  rack_gap_tolerance = 0.5; // Tolerance for the gap the rack sits in
  servo_post_adjustment = 2; // Extra 2mm adjustment so the servo gear lines up properly with the rack, done by eye
  cover_top_clearance = 10; // Clearance between the top of the servo posts and the top of the cover (the gear needs a little extra room to move)

  // Part size definitions
  servo_post = [10, 6, 26.4];
  front_base = [70, 40, wall_thickness];
  rear_base = [front_base.x, rack_bottom_width + back_spacing + servo_post_adjustment + servo_post.y, (rack_height - rack_tooth_height) + door_height];
  screw_posts = [2 * wall_thickness, 2 * wall_thickness, 2 * wall_thickness];
  mounting_brackets = [4 * wall_thickness, 4 * wall_thickness, 4 * wall_thickness];
  cover_height = rear_base.z - wall_thickness + servo_post.z + cover_top_clearance; // Height of the cover at the tallest point

  // Rack translations
  rack_translation = [0, rear_base.y - rack_bottom_width - back_spacing, door_height];
  rack_gap_translation = [-1, rack_translation.y - (rack_gap_tolerance / 2), rack_translation.z - (rack_gap_tolerance / 2)]; // Translation including gap tolerance, for the gap the rack sits in


  if(show_base) {
    // Front section
    cube(front_base);

    // Front mounting brackets
    mirror([0, 1, 0]) mounting_bracket(dimensions=mounting_brackets, bottom_spacing=wall_thickness); // Bottom left
    translate([front_base.x - mounting_brackets.x, 0, 0]) mirror([0, 1, 0]) mounting_bracket(dimensions=mounting_brackets, bottom_spacing=wall_thickness); // Bottom Right

    // Front screw posts
    translate([wall_thickness, wall_thickness, wall_thickness]) screw_post(screw_posts, left_hole=true);
    translate([front_base.x - screw_posts.x - wall_thickness, wall_thickness, wall_thickness]) screw_post(screw_posts, right_hole=true);

    // Rear mounting brackets
    translate([0, front_base.y + rear_base.y, 0]) mounting_bracket(dimensions=mounting_brackets, bottom_spacing=wall_thickness); // Top left
    translate([front_base.x - mounting_brackets.x, front_base.y + rear_base.y, 0]) mounting_bracket(dimensions=mounting_brackets, bottom_spacing=wall_thickness); // Top right

    // Rack section (rear)
    translate([0, front_base.y, 0]) {
      // Main body
      difference() {
        cube(rear_base);
        translate(rack_gap_translation) servo_rack(top_width=rack_top_width + rack_gap_tolerance, bottom_width=rack_bottom_width + rack_gap_tolerance, height=rack_height + rack_gap_tolerance, rack_teeth=14);
      }

      // Servo posts
      translate([(rear_base.x - 60) / 2, rack_translation.y - servo_post.y - servo_post_adjustment, rear_base.z]) {
        servo_post(servo_post);
        translate([50, 0, 0]) servo_post(servo_post);
      }

      // Rear screw posts
      translate([wall_thickness, rear_base.y - screw_posts.y - wall_thickness, rear_base.z]) screw_post(screw_posts, rear_hole=true);
      translate([rear_base.x - screw_posts.x - wall_thickness, rear_base.y - screw_posts.y - wall_thickness, rear_base.z]) screw_post(screw_posts, rear_hole=true);

      // Example rack
      if(show_rack) {
        color("blue") translate(rack_translation) servo_rack(top_width=rack_top_width, bottom_width=rack_bottom_width, height=rack_height);
      }

      // Mock servo assembly
      if(show_mock_servo) {
        translate([(rear_base.x - 60) / 2 + (servo_post.x - 7), rack_translation.y - servo_post.y - servo_post_adjustment, rear_base.z + (servo_post.z - 19.5)]) mock_servo_assembly();
      }
    }
  }

  if(show_cover) {
    if(print_positions) {
      translate([(2 * front_base.x) + 10, 0, cover_height + (2 * wall_thickness)]) rotate([0, 180, 0]) door_opener_cover(cover_height, wall_thickness, rear_base, servo_post, front_base, screw_posts, (rack_top_width + rack_gap_tolerance), rack_gap_translation, rack_top_width, rack_bottom_width, rack_gap_tolerance);
    } else {
      door_opener_cover(cover_height, wall_thickness, rear_base, servo_post, front_base, screw_posts, (rack_top_width + rack_gap_tolerance), rack_gap_translation, rack_top_width, rack_bottom_width, rack_gap_tolerance);
    }
  }
}

door_opener();
