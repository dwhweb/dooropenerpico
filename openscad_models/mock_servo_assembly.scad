use <servo_gear.scad>
use <mock_servo_horn.scad>
use <mock_servo.scad>

$fn = 50;

module mock_servo_assembly() {
  bracket_spacing = 6; // Space between the edge of the main body of the servo and the bracket
  horn_mount_height = 8; // Height of the horn mount cylinder
  horn_mount_spacing = 10; // Space between the edge of the main body of the servo and the centre of the horn mount
  horn_main_height = 2; // Main body height only, not the rear section of the servo horn
  mock_servo = [40, 38, 19.5]; // Mock servo dimensions
  bracket = [7, 2.5, 19.5]; // Mock servo bracket dimensions
  gear_hole_bottom = 10 - 3.7 - 2; // Gear thickness - servo horn thickness - an extra 2mm

  color("white") translate([bracket.x + horn_mount_spacing, gear_hole_bottom + bracket_spacing + horn_mount_height + horn_main_height, mock_servo.z / 2]) rotate([90, 0, 0]) servo_gear(); 
  translate([bracket.x + horn_mount_spacing, bracket_spacing + horn_mount_height + horn_main_height, mock_servo.z / 2]) rotate([90, 0, 0]) mock_servo_horn();
  color("grey") mock_servo();
}

mock_servo_assembly();
