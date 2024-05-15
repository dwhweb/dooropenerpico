module mock_servo_horn(diameter=19.5, body_height=2, hole_diameter=1.5, rear_diameter=8.7, rear_height=1.7, centre_hollow_diameter=5.5) {
  total_height = body_height + rear_height;
  holes_height = total_height + 2;

    difference() {
      cylinder(d=diameter, h=body_height); // Main body
      translate([0, 0, -1]) cylinder(d=hole_diameter, h=holes_height); // Centre hole
    }

    difference() {
      translate([0, 0, body_height]) cylinder(d=rear_diameter, h=rear_height); // Raised rear section
      translate([0, 0, 0.2]) cylinder(d=centre_hollow_diameter, h=total_height + 1); // Centre hollow, 0.2 is best guess thickness of front of horn inside hollow
    }
}

mock_servo_horn();
