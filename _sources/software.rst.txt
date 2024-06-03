Software requirements
=====================

I'd suggest the following software if you intend to build this project —

* `Git <https://git-scm.com/>`_ to clone the repository ready for deployment.
* Linux or some flavour of \*nix for running the code deployment Bash script for copying the microcontroller code to the Pi Pico — you can alternatively :ref:`deploy this manually <deploying-manually>`.
* `rshell <https://github.com/dhylands/rshell>`_ if you're using the code deployment script.
* `Thonny <https://thonny.org/>`_ as an IDE — even if you aren't likely to change any of the underlying code the console is invaluable for debugging purposes and Thonny also sets the RTC of the Pico on connection so you can determine *when* an issue happened.
* `OpenSCAD <https://openscad.org/>`_ for customising and exporting the 3D models ready for printing.
* `The Belfry OpenSCAD library v2 <https://github.com/BelfrySCAD/BOSL2>`_ is a required library for the 3D models.
* `PrusaSlicer <https://www.prusa3d.com/en/page/prusaslicer_424/>`_ is my preferred slicer, but Cura or similar would work just as well.
* `Home Assistant <https://www.home-assistant.io/>`_ for automating when the door opens or closes, if you don't care about network functionality and just want to use the switch you can omit this.
* `Mosquitto MQTT broker <https://mosquitto.org/>`_ installed as a Home Assistant add-on, you may already have this depending on what is running on your Home Assistant instance.
* `MQTT Explorer <https://mqtt-explorer.com/>`_ is useful for debugging MQTT issues.
