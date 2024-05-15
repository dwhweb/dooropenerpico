Troubleshooting and known issues
================================

General suggestions
-------------------

* A laptop or another machine running Thonny is essential for debugging issues when setting up the door opener. I personally have a Raspberry Pi Zero 2W running VNC that I can connect to and check the console output.
* Wireless signal strength was a fairly consistent source of issues for me early on until I set up an additional wireless access point in a mesh configuration. The MQTT client library used is to some extent resilient to connection issues and attempts to maintain the connection but having a strong signal to start with will save you some frustration.

Known issues
------------

* LED pulsing on open/close is deliberately disabled when the door opener is running in web server mode as this results in a crash due to the limited stack size of the Pico. I've raised other issues with the underlying ``picozero`` library used in the project that haven't been addressed, so I'm unsure if this can be rectified.
* I feel this project is pushing at the limits of the capabilities of the Pico in terms of resources, being implemented in a polymorphic object-oriented manner and making extensive use of third party libraries. I had to cross-compile the libraries into native bytecode to allow everything to fit into memory, and the project would probably benefit from a rewrite in a lower level language such as C (no plans currently to do that).
