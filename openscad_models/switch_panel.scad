use <screw_holes.scad>
use <mounting_bracket.scad>

$fn = 50;

module switch_panel() {
  wall_thickness = 2;
  hood_height = 15;
  led_sleeve_height = 5;
  led_sleeve_diameter = 8;
  main_panel = [35, 20, 20];
  mounting_bracket = [20, 15, 20];
  switch_hole_radius = 3.75;
  switch_hole_position = [(main_panel.x / 4) * 3, main_panel.y / 2, main_panel.z - wall_thickness - 1];
  red_led_position = [(main_panel.x / 4) * 2, switch_hole_position.y, main_panel.z - led_sleeve_height];
  green_led_position = [(main_panel.x / 4) * 1, switch_hole_position.y, main_panel.z - led_sleeve_height];
  cable_hole_diameter = 6;

  difference() {
    main_panel(main_panel, wall_thickness);
    translate(switch_hole_position) cylinder(h=wall_thickness + 2, r=switch_hole_radius); // Switch hole
    translate([red_led_position.x, red_led_position.y, main_panel.z - wall_thickness - 1]) cylinder(h=wall_thickness + 2, d=led_sleeve_diameter); // Red LED hole
    translate([green_led_position.x, green_led_position.y, main_panel.z - wall_thickness - 1]) cylinder(h=wall_thickness + 2, d=led_sleeve_diameter); // Green LED hole
    
    // Cable hole
    translate([main_panel.x / 2, wall_thickness + 1, cable_hole_diameter / 2]) rotate([90, 0, 0]) cylinder(h=wall_thickness + 2, d=cable_hole_diameter);
    translate([(main_panel.x / 2) - (cable_hole_diameter / 2), -1, -1]) cube([cable_hole_diameter, wall_thickness + 2, (cable_hole_diameter / 2) + 1]);
  }  

  translate(red_led_position) LED_sleeve(led_sleeve_height, led_sleeve_diameter); // Red LED sleeve
  translate(green_led_position) LED_sleeve(led_sleeve_height, led_sleeve_diameter); // Green LED sleeve

  // Mounting brackets
  rotate([0, 0, 90]) mounting_bracket(mounting_bracket, 5);
  translate([main_panel.x, mounting_bracket.x, 0]) rotate([0, 0, -90]) mounting_bracket(mounting_bracket, 5);

  // Hood
  translate([0, 0, main_panel.z]) hood(main_panel, hood_height, wall_thickness);
}

module main_panel(main_panel, wall_thickness) {
  difference() {
    cube(main_panel);
    translate([wall_thickness, wall_thickness, -wall_thickness]) cube([main_panel.x - (2 * wall_thickness), main_panel.y - (2 * wall_thickness), main_panel.z]);
  }
}

module hood(main_panel, hood_height, wall_thickness) {
  hood_side = [[0, 0], 
            [0, main_panel.y],
            [hood_height, main_panel.y],
  ];

  difference() {
    translate([main_panel.x, 0, 0]) rotate([0, -90, 0]) linear_extrude(main_panel.x) polygon(hood_side);
    translate([wall_thickness, -wall_thickness, -1]) cube([main_panel.x - (2 * wall_thickness), main_panel.y, hood_height + 1]);
  }
}

module LED_sleeve(height, diameter) {
  difference() {
    cylinder(h=height, d=diameter); // Outer sleeve
    translate([0, 0, 1]) cylinder(h=height, d=diameter - 1.5); // Inner hole
    translate([0, 0, -1]) cylinder(h=height + 2, d=4); // Hole for leads
  }
}

switch_panel();
