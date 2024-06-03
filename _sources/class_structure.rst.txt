Class structure overview
========================

``main.py`` initially creates an instance of :class:`~dooropenerpico.dooropenerpico.DoorOpenerPico` which then instantiates one of three types of instance —

* :class:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase` (button functionality only) if ``credentials.conf`` (login credentials) or ``discovery.conf`` (Home Assistant discovery payload) can't be found.
* :class:`~dooropenerpico.dooropenerpicoweb.DoorOpenerPicoWeb` (web server) if the control panel button is held on startup.
* :class:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork` (Home Assistant/MQTT) otherwise.

These three classes have an inheritance relationship in terms of progressive enhancement as such —

.. inheritance-diagram:: dooropenerpico.dooropenerpicoweb
   :parts: 1

i.e. The majority of base functionality is implemented in :class:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase`, :class:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork` inherits from that and implements network/MQTT functionality, and :class:`~dooropenerpico.dooropenerpicoweb.DoorOpenerPicoWeb` inherits from that and implements web server functionality.

Aside from this, there are two utility classes —

* :class:`~dooropenerpico.conf.Conf` which is used to retrieve and validate ``.conf`` files.
* :class:`~dooropenerpico.print_debug.Print_debug` which is used to print debug messages to the console with an optional timestamp.
