![Chicken](./docs/source/_images/chicken.svg) 

# dooropenerpico

## Project overview

The purpose of this project is to create a door opener which can open and close the door to a chicken coop. It consists of —

- Python code written to run on a Raspberry Pi Pico W (hereafter referred to as the Pico).
- Various OpenSCAD models which can be customised and exported to .stl files for 3D printing.

The door can be toggled by pressing a button, and is integrated with Home Assistant as an MQTT entity and as such can be automated (for example, to open at sunrise). The microcontroller can also be optionally started with a web server for setup and debugging purposes by holding the button at startup.

On startup, the microcontroller will attempt to establish a connection to the wireless SSID specified within `/lib/dooropenerpico/credentials.conf`, then attempt to connect to the MQTT server also specified within that file. The onboard LED will blink to notify that this is happening, and will go solid when a connection is established. Following this, the green and red LEDs on the control panel will light in an alternating fashion twice to signify the board has successfully started. Most functions and actions the board takes are logged to the console for easy debugging in Thonny or your IDE of choice.

The door opener can operate without network functionality (button actuation only) by simply omitting `credentials.conf` if required.

## Documentation

Extensive documentation detailing how to build this project can be found [here](https://dwhweb.github.io/dooropenerpico).

## Licensing and acknowledgements

Unless otherwise noted for constituent parts, this project is shared under the terms of of the [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) licence. Please attribute **dwhweb** in any derivative works.

[![License: CC BY 4.0](https://licensebuttons.net/l/by/4.0/80x15.png)](https://creativecommons.org/licenses/by/4.0/)

The wiring diagram incorporates an .svg of the pinout of the Pico, which is the property of Raspberry Pi Ltd and is licenced under the terms of the [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) licence, consequently the diagram is also shared under the terms of this licence.

The dooropenerpico project incorporates the following software, libraries and resources. If I've somehow missed you out, please get in touch —

- [Chicken image by Vecteezy](https://www.vecteezy.com/vector-art/6046486-chicken-logo-cartoon-character-cute-cartoon-rooster-chicken-gives-thumbs-up-vector-logo-illustrationt) (modified)
- The [Microdot](https://github.com/miguelgrinberg/microdot) library
- The [Picozero](https://github.com/RaspberryPiFoundation/picozero) library
- The [Public Domain Involute Parameterized Gears](https://www.thingiverse.com/thing:5505) library (modified to fix some minor issues)
- The [Umqtt.robust2](https://github.com/fizista/micropython-umqtt.robust2) library

The following software, libraries or resources were also used when creating this project —

- The [Belfry OpenSCAD library v2](https://github.com/BelfrySCAD/BOSL2)
- The [Furo theme](https://github.com/pradyunsg/furo)
- [Git](https://git-scm.com/)
- [Home Assistant](https://www.home-assistant.io/)
- [LunarVim](https://www.lunarvim.org/)
- [MicroPython](https://micropython.org/)
- [Mosquitto MQTT broker](https://mosquitto.org/)
- [MQTT Explorer](https://mqtt-explorer.com/)
- [OpenSCAD](https://openscad.org/)
- [PrusaSlicer](https://www.prusa3d.com/en/page/prusaslicer_424/)
- [Python](https://www.python.org/)
- [Rshell](https://github.com/dhylands/rshell)
- [Sphinx](https://www.sphinx-doc.org/en/master/)
- [Thonny](https://thonny.org/)
- The [Watchdog](https://github.com/gorakhargosh/watchdog) library

Thanks to the wider open source community for making projects like this possible and for creating fantastic things that we use every day.

## Contacts

Errors and omissions are likely and there are undoubtedly aspects of the project which are obvious to me but need clarification and improvement. You can contact me via email regarding this project at **dooropenerpico at dwhweb dot org**, or in the case of bugs raise a [Github issue](https://github.com/dwhweb/dooropenerpico/issues).
