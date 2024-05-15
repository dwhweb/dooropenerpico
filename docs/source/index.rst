.. include:: global.rst

.. toctree::
   :hidden:
   :maxdepth: 5
   
   Project overview <self>
   video
   skills
   software
   bom
   printing
   wiring
   deployment
   usage
   troubleshooting
   development
   api
   licencing
   contacts

dooropenerpico documentation
============================

Project overview
----------------

The purpose of this project is to create a door opener which can open and close the door to a chicken coop. It consists of —

- Python code written to run on a Raspberry Pi Pico W (hereafter referred to as the Pico).
- Various OpenSCAD models which can be customised and exported to .stl files for 3D printing.

The door can be toggled by pressing a button, and is integrated with `Home Assistant <https://www.home-assistant.io>`_ as an MQTT entity and as such can be automated (for example, to open at sunrise). The microcontroller can also be optionally started with a web server for setup and debugging purposes by holding the button at startup.

On startup, the microcontroller will attempt to establish a connection to the wireless SSID specified within ``/lib/dooropenerpico/credentials.conf``, then attempt to connect to the MQTT server also specified within that file. The onboard LED will blink to notify that this is happening, and will go solid when a connection is established. Following this, the green and red LEDs on the control panel will light in an alternating fashion twice to signify the board has successfully started. Most functions and actions the board takes are logged to the console for easy debugging in Thonny or your IDE of choice.

The door opener can operate without network functionality (button actuation only) by simply omitting ``credentials.conf`` if required.

The files for this project in terms of MicroPython code and OpenSCAD models can be found in the repository on `Github <https://www.github.com/dwhweb/dooropenerpico>`_.

.. note:: 
   I built this project for my own personal use and as such it is likely not suited to your purposes without some minor customisation, but the code and models were created with this in mind and this is covered in more depth in the sections to follow. 

.. tip::
   If you intend on building the project, I suggest you scan the documentation in its entirety before you start so you have a better appreciation of how the various parts (hardware and software) fit together.

.. warning::
   In case it isn't obvious, no warranty is expressed or implied. I am not responsible for any harm that might come to you, your chickens, the fabric of spacetime, etc.

|CC BY 4.0|
