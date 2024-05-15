use <mounting_bracket.scad>
use <screw_holes.scad>

// These values can be changed within the OpenSCAD customiser
// Determines whether to render a taller (20mm) or shorter (14mm) height mounting block for the reed switch
short = false;
// The height of a tall mounting block
tall_height = 20;
// The height of a short mounting block
short_height = 14;

module reed_switch_mount(short) {
  $fn = 50;

  // Render a shorter reed switch mount for the right hand side of the door, since that is higher
  if(short) {
    reed_switch_mount_helper(short_height);
  } else {
    reed_switch_mount_helper(tall_height);
  }
}

module reed_switch_mount_helper(door_height) {
  main_body = [27, 13.5, door_height];
  mounting_bracket = [13.5, 15, door_height]; 

  // Main body
  difference() {
    cube(main_body);
    translate([4.5, 3, main_body.z - 7]) reed_hole();
    translate([main_body.x - 4.5, 3, main_body.z - 7]) reed_hole();
  }

  // Mounting brackets
  rotate([0, 0, 90]) mounting_bracket(mounting_bracket, 5);
  translate([main_body.x, mounting_bracket.x, 0]) rotate([0, 0, -90]) mounting_bracket(mounting_bracket, 5);
}

reed_switch_mount(short);
