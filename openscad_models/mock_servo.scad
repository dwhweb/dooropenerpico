$fn = 50;

module mock_servo() {
  mock_servo = [40, 38, 19.5];
  bracket = [7, 2.5, 19.5];

  translate([0, -bracket.y, 0]) bracket(bracket); // Left bracket
  translate([(bracket.x * 2) + mock_servo.x, -bracket.y, 0]) mirror([1, 0, 0]) bracket(bracket); // Right bracket
  translate([bracket.x, 6, 0]) { // 6mm from front to bracket
    translate([0, -mock_servo.y, 0]) cube(mock_servo);
    color("white") translate([10, 0, mock_servo.z / 2]) rotate([-90, 0, 0]) cylinder(h=8, d=5.3); // Horn mount
  }
}

module bracket(bracket) {
  line = [7, 1.6, 1];
  hole_diameter = 4;

    difference() {
      cube(bracket); // Main body
      translate([bracket.x / 4, bracket.y + 1, (bracket.z / 4) * 3]) rotate([90, 0, 0]) cylinder(h=bracket.y + 2, d=hole_diameter); // Top hole
      translate([bracket.x / 4, bracket.y + 1, bracket.z / 4]) rotate([90, 0, 0]) cylinder(h=bracket.y + 2, d=hole_diameter); // Bottom hole
    }

    translate([0, bracket.y, (bracket.z / 2) - (line.z / 2)]) cube(line); // Raised line
}

mock_servo();
