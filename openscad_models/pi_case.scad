use <screw_holes.scad>
use <screw_post.scad>
use <mounting_bracket.scad>

// These values can be changed within the OpenSCAD customiser
// Determines whether the top of the case is rendered ready for printing or in situ on the base.
print_positions = true;
// Determines whether to show the base.
show_base = true;
// Determines whether to show the cover.
show_cover = true;
// The diameter of the lip portion of the cable entry hole
lip_diameter = 26;
// The height of the lip portion of the cable entry hole
lip_height = 1.6;
// The diameter of the inner portion of the cable entry hole
inner_diameter = 28;

// Holes for M2 inserts to attach the pi to the case
module pi_holes(base_thickness) {
  translate([0, 0, base_thickness - 2.7]) {
    m2_insert_hole(); // Bottom left
    translate([11.4, 0, 0]) m2_insert_hole(); // Bottom right
    translate([0, 47, 0]) m2_insert_hole(); // Top left
    translate([11.4, 47, 0]) m2_insert_hole(); // Top right
  }
}

// Hook for cable ties, used for attaching the DC adapter breakout and relay to the case and cable management
module cable_tie_hook(top, base_thickness) {
  bottom = [top.x, top.y / 5, top.z];
  
  translate([0, 0, base_thickness]) {
    translate([0, 0, bottom.z]) cube(top); // Top of hook
    cube(bottom); // Lower part where the hook is attached to the casing
    translate([0, bottom.y * 4, 0]) cube(bottom); // Top part, as above
  }
}

module base(base, pi_holes_spacing, cable_tie_hook_top, pi_pico, base_thickness) {
  screw_post = [2 * base_thickness, 2 * base_thickness, 2 * base_thickness];
  mounting_bracket = [4 * base_thickness, 4 * base_thickness, 4 * base_thickness];
  pi_holes_y_translation = (base.y - 47) - (2 * base_thickness); // 47 is interval between the centre of the pi holes

  // Base
  difference() {
    cube(base);
    // Holes for pi pico (M3 inserts)
    translate([(base.x / 2) - (pi_holes_spacing.x / 2), pi_holes_y_translation, 0]) pi_holes(base_thickness);
  }

  // Left hook
  translate([(base.x / 2) - (cable_tie_hook_top.x / 2) - pi_pico.x, pi_holes_y_translation, 0]) cable_tie_hook(cable_tie_hook_top, base_thickness);
  // Right hook
  translate([(base.x / 2) - (cable_tie_hook_top.x / 2) + pi_pico.x, pi_holes_y_translation, 0]) cable_tie_hook(cable_tie_hook_top, base_thickness);

  // Left screw post
  translate([base_thickness, base.y - (3 * base_thickness), base_thickness]) screw_post(dimensions=screw_post, left_hole=true);
  // Right screw post
  translate([base.x - (3 * base_thickness), base.y - (3 * base_thickness), base_thickness]) screw_post(dimensions=screw_post, right_hole=true);

  // Mounting brackets
  mirror([0, 1, 0]) mounting_bracket(mounting_bracket, base_thickness); // Front left
  translate([base.x - mounting_bracket.x, 0, 0]) mirror([0, 1, 0]) mounting_bracket(mounting_bracket, base_thickness); // Front right
  translate([0, base.y, 0]) mounting_bracket(mounting_bracket, base_thickness); // Rear left
  translate([base.x - mounting_bracket.x, base.y, 0]) mounting_bracket(mounting_bracket, base_thickness); // Rear right
}

module front(dimensions, base_thickness) {
  translate([0, 0, base_thickness]) {
    difference() {
      cube(dimensions);

      // Cable hole
      translate([dimensions.x / 2, 0, dimensions.z / 2]) {
        translate([0, dimensions.y + lip_height, 0]) rotate([90, 0, 0]) cylinder(h=dimensions.y, d=inner_diameter);
        translate([0, lip_height + 1, 0]) rotate([90, 0, 0]) cylinder(h=lip_height + 2, d=lip_diameter);
      }

      // M3 insert holes
      translate([base_thickness, base_thickness, dimensions.z - 5.5]) m3_insert_hole(); // Left
      translate([dimensions.x - base_thickness, base_thickness, dimensions.z - 5.5]) m3_insert_hole(); // Right
    }
  }
}

module cover(front, base, base_thickness) {
  back = [front.x - (2 * base_thickness), base_thickness, front.z];

  module side() {
    translate([0, front.y, base_thickness]) {
      difference() {
        cube([base_thickness, base.y - front.y, front.z]); // Left side
        translate([base_thickness + 1, base.y - front.y - (2 * base_thickness), base_thickness]) rotate([0, -90, 0]) m3_hole();
      }
    }
  }

  // Top of the cover
  difference() {
    translate([0, 0, front.z + base_thickness]) cube(base);
    translate([base_thickness, base_thickness, front.z + base_thickness - 1]) m3_hole(); // Left hole
    translate([front.x - base_thickness, base_thickness, front.z + base_thickness - 1]) m3_hole(); // Right hole
  }

  // Left and right sides
  side(); // Left
  translate([base.x - base_thickness, 0, 0]) side();

  // Back part
  translate([base_thickness, base.y - base_thickness, base_thickness]) cube(back);
}

module pi_case() {
  $fn = 200;
  base_thickness = 5;
  pi_pico = [21, 51, 12]; // Pi pico dimensions, height includes soldered pin header
  base = [70, 120, base_thickness];
  front = [base.x, base_thickness * 2, 55]; 
  pi_holes_spacing = [11.4, 47, 0];
  cable_tie_hook_top = [15.7, 40.6, 5];

  // Base and front
  if(show_base) {
    base(base, pi_holes_spacing, cable_tie_hook_top, pi_pico, base_thickness);
    front(front, base_thickness);
  }

  // Cover
  if(show_cover) {
    if(print_positions) {
      translate([(2 * base.x) + base_thickness, 0, front.z + (2 * base_thickness)]) rotate([0, 180, 0]) cover(front, base, base_thickness);
    } else {
      cover(front, base, base_thickness);
    }
  }
}

pi_case();
