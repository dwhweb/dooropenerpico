Bill of materials
-----------------

General suggestions
^^^^^^^^^^^^^^^^^^^


* I'm assuming you have basic soldering and electronics equipment like a soldering iron, solder, flux, multimeter, side cutters, wire strippers and so on.
* A laptop is pretty much essential to customise and debug the Pico when it is mounted.
* I have a mains extension reel, DC adapters and the Pico case in a plastic box with suitable holes for cable ingress to protect everything from the elements, you'll likely need something similar. 
* For the sake of expediency I'd suggest you pick up a set of assorted M2 and M3 screws and a few bags of mixed dupont jumper cables with both male and female ends. 
* I used the individual wires within Cat5 network cable for splicing purposes as I have a lot of that spare, but I've suggested wires of the correct colours, which would be nicer. Obviously any low gauge copper wire would be suitable.
* Making small labels for the wires with a label printer makes things a lot easier, if you happen to have one.
* As you're likely to be doing a fair amount of splicing, assorted sizes of heatshrink will keep your connections tidy.
* You'll need approximately 357g of filament in total — you can likely get away with printing most of the project in PLA if you really want to, but I'd suggest you print at least the servo gear and servo rack in PETG due to the better tensile strength of that material.
* It's worth checking out whether you have sufficient wireless coverage with your router/access point to communicate reliably with the Pico. I had to buy an additional access point and set up a wireless mesh but this is obviously dependent on where your Pico is located.
* The vast majority of these parts were sourced from Ebay, but you'll likely find the parts relatively easily from the usual Chinese retailers like Aliexpress.
* Some of the choices of parts (such as imperial screws and the cable grommet) aren't necessarily the best choices and were only used because I had them to hand — feel free to substitute if you have something better that you think will work.

Door opener
^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Item
     - Quantity
     - Notes
   * - PETG filament
     - 125g
     - You'll need approximately 125g of filament for the door opener base and cover at 15% infill.
   * - M3 brass screw inserts
     - 4
     - These should be inserted into the holes at the front and back of the door opener with a soldering iron.
   * - M3x12 screw (countersunk)
     - 4
     - Attaches the servo to the case posts.
   * - M3x10 screw (flat head)
     - 4
     - Attaches the cover to the base.
   * - M3 nuts
     - 4
     - For attaching the servo to the case posts.
   * - 6 x ½ screw (imperial)
     - 4
     - For mounting the door opener to the coop. I used these because I had them lying around, use the closest metric equivalent (3x12mm) if you can't find them.
   * - Brown/red/orange dupont cable (male)
     - 3
     - For connecting to the servo, it doesn't really matter what sex the other end is as you'll be cutting and splicing with other cables.
   * - Orange dupont cable (female)
     - 1
     - Servo PWM signal wire, connects to the Pico, this should be spliced to the orange male dupont wire (you'll likely have a longer section of wire spliced between the two)
   * - Orange copper wire
     - 1
     - Splice between the orange male and female dupont cables.
   * - Brown copper wire
     - 1
     - Solder to the brown male dupont cable (Servo -) and connect the other end to the negative screw terminal of the DC connector.
   * - Red copper wire
     - 1
     - Solder to the red male dupont cable (Servo +) and connect the other end to the COM (Common) screw terminal of the relay.
   * - Silicone grease (optional)
     - 1
     - Use for lubricating the channel the opening rod is in for easier actuation.
   * - Feetech FS5109R continuous rotation servo
     - 1
     - Most full size RC car servos use a similar form factor, so you might be able to use something else if you can't find this specific servo. The important things are that the servo is continuous rotation, can supply enough torque for the weight of your door and has a metal hub and gears. Cheaper plastic versions will get mashed up pretty quickly.


Raspberry Pi Pico case
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Item
     - Quantity
     - Notes
   * - PETG filament
     - 147g
     - You'll need approximately 147g of filament at 15% infill, including supports under the raised portions where the female DC connector and relay portions are attached to the case.
   * - Raspberry Pi Pico W
     - 1
     - N/A
   * - 20 pin header
     - 2
     - For the Pico, the colour coded versions that the Pi hut supplies are nice. You could alternatively get a board with the headers pre-soldered.
   * - M2 brass screw inserts
     - 4
     - Insert these into the holes in the base with a soldering iron.
   * - M2 x 6 screw, flat head
     - 4
     - Attaches the Pico to the centre of the case.
   * - M3 brass screw inserts
     - 4
     - Insert these into the holes in the top of the wall on the base and the holes on the sides of the small posts at the front of the base with a soldering iron.
   * - M3 x 10 screw, flat head
     - 4
     - For attaching the cover to the base.
   * - Small cable ties
     - 4
     - For attaching the DC connector and relay to the raised sections in the bottom of the case, these need to be fairly thin for the cover to fit on properly.
   * - 5.5 x 2.5mm right angled male to female DC extension cable
     - 1
     - For attaching internally to the DC connector, potentially optional if the connector on the end of your DC adapter fits inside the case.
   * - 5.5 x 2.5mm 6V 4A DC adapter
     - 1
     - For powering the servo, stall current for the FS5109R is around 2A at 6V but the servo accepts a range of voltages so you'd probably be fine with a more common 5V adapter.
   * - 5.5 x 2.5mm female DC connector with screw terminals
     - 1
     - Connects to the relay, servo - and Pico ground.
   * - 3.3V/5V 10A Relay Module
     - 1
     - Completely isolates the power supply from the servo when deactivated, 5V versions of the relay are quite common but you need to ensure you get a version that can use the 3.3v output from the Pico.
   * - Micro USB cable, 1m
     - 1
     - For powering/debugging the Pico.
   * - 5V DC USB AC adapter
     - 1
     - The Pico sips power, so any 5V adapter will likely work. You could potentially power the Pico from the 6V DC adapter with a suitable buck converter or similar, but I've kept it separate for easy code debugging.
   * - 30mm cable grommet
     - 1
     - For the hole the cables enter the case through. The one I used I had lying around, and I'm unsure if commercially available ones are exactly the same dimensions in terms of lip size so you might need to adjust this in the OpenSCAD model.
   * - Purple dupont cable (Female)
     - 1
     - For the relay signal connection.
   * - Black dupont cable (Female)
     - 2
     - For the relay ground, the other should be used for connecting the - side of the DC connector to a ground on the Pico.
   * - Red dupont cable (Female)
     - 1
     - For the relay 3v supply.
   * - Red copper wire
     - 1
     - Connects the + side of the DC connector to the NO connector on the relay.


Reed switch mounts
^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Item
     - Quantity
     - Notes
   * - PETG filament
     - 12g
     - You'll need approximately 12g of filament at 15% infill.
   * - 6 x ½ screw (imperial)
     - 4
     - For fixing the reed switch mounting blocks to the coop.
   * - 2.5 x 10mm screw, flat head
     - 8
     - In my case these came with the reed switches, hopefully you shouldn't need to buy them. For fixing the reed switches to the mounting blocks, and their matching magnets to the door.
   * - MC-38 wired magnetic door/window sensor
     - 2
     - The reed switch and magnet pairs, one pair for the left position (open) and one for the right position (closed).
   * - Black dupont cable (female)
     - 2
     - For the ground side of the reed switches.
   * - White dupont cable (female)
     - 2
     - For the positive side of the reed switches.
   * - Black copper wire
     - 2
     - For splicing between the ground side of the reed switches and the black dupont cables.
   * - White copper wire
     - 2
     - For splicing between the positive side of the reed switches and the white dupont cables.


Servo gear
^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Item
     - Quantity
     - Notes
   * - PETG filament
     - 5g
     - You'll need approximately 5g of filament at 15% infill.
   * - 20mm diameter 25T circular aluminium servo horn
     - 1
     - You'll probably get a plastic version with your servo but you need a metal horn due to the forces involved.
   * - Two part epoxy
     - 1
     - For gluing the servo horn into the centre of the servo gear, you could alternatively use superglue or any adhesive you trust to attach plastic to aluminium.
   * - M3x8 screw (countersunk)
     - 1
     - For attaching the servo gear to the hub of the servo, if you have a screw supplied with your servo that might be suitable.


Servo rack
^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Item
     - Quantity
     - Notes
   * - PETG filament
     - 54g
     - I'd suggest you use a higher infill for the rack, as that is where the majority of force is applied. For a 310mm rack (default, bracket not included) at 25% infill you'll need approximately 54g.
   * - 6 x ½ screw (imperial)
     - 2
     - For mounting the rack bracket to the door, the two outer holes in the bracket.
   * - 2.5 x 16mm Screw (metric, optional)
     - 2
     - These are for the two centre holes on the opening rod, they came with my coop and the holes on the rack line up with existing holes on my door for the original manual opening rod. As you're unlikely to have the same screws, the OpenSCAD model has an option to use all 6x½ holes instead if you'd prefer.
   * - Two part epoxy
     - 1
     - The rack is so long as to be printed in two parts and joined together; the epoxy is for gluing together at the dovetail joint where the two pieces join.
   * - Sandpaper
     - 1
     - When the two parts of the rack are glued together you'll likely find that they aren't totally level and hitch at the join when moving in the door opener channel. You should sand the join to ensure the rack moves freely.


Switch panel
^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Item
     - Quantity
     - Notes
   * - PETG filament
     - 14g
     - You'll need approximately 14g of filament at 15% infill with supports.
   * - Red 5mm LED
     - 1
     - N/A
   * - Green 5mm LED
     - 1
     - N/A
   * - 7mm momentary SPST switch
     - 1
     - N/A
   * - 330Ω resistor
     - 2
     - For the LEDs.
   * - Cat5 patch cable
     - 1
     - I used a single patch cable as a way of keeping cabling to the switch panel neat, you can use single wires for the red LED +, green LED + and switch + and tie all the ground wires together for connection to a single pin on the Pico.
   * - Red dupont cable (female)
     - 1
     - For the red LED.
   * - Green dupont cable (female)
     - 1
     - For the green LED
   * - White dupont cable (female)
     - 1
     - For the switch +
   * - Black dupont cable (female)
     - 1
     - For the common ground (red LED, green LED and switch)
   * - Two part epoxy
     - 1
     - For gluing the red and green LEDs in place.
   * - Cable staples
     - 12
     - For securing the patch cable and any other cables to the coop.
