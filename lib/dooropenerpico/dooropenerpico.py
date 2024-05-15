import json
from picozero import Button
from dooropenerpico.dooropenerpicobase import DoorOpenerPicoBase
from dooropenerpico.dooropenerpicoweb import DoorOpenerPicoWeb
from dooropenerpico.dooropenerpiconetwork import DoorOpenerPicoNetwork
from dooropenerpico.print_debug import Print_debug
from dooropenerpico.conf import Conf

class DoorOpenerPico:
    """Initialisation class, creates some kind of DoorOpenerPico instance."""
    def __init__(self):
        """
        Instantiates either :class:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase`, :class:`~dooropenerpico.dooropenerpicoweb.DoorOpenerPicoWeb` or :class:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork`.

        * Creates a :class:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase` instance (button functionality only) if a credentials or discovery payload conf file can't be found.
        * Otherwise, creates a :class:`~dooropenerpico.dooropenerpicoweb.DoorOpenerPicoWeb` (web server) instance if the button is held on startup.
        * Otherwise, creates a :class:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork` (Home assistant/MQTT) instance.
        """
        self.switch = Button(15)
        credentials_path = "/lib/dooropenerpico/credentials.conf"
        discovery_path = "/lib/dooropenerpico/discovery.conf"
        credentials = self._get_conf(credentials_path)
        discovery_payload = self._get_conf(discovery_path)
        
        if not credentials:
            self._print_debug(f"{credentials_path} not found, starting without network functionality...")
            dooropener = DoorOpenerPicoBase()
        elif not discovery_payload:
            self._print_debug(f"{discovery_path} was not found for Home Assistant autoconfiguration, starting without network functionality...")
            dooropener = DoorOpenerPicoBase()
        else:
            if(self.switch.is_pressed):
                self._print_debug("Switch held on startup, starting with network and web server functionality...")
                dooropener = DoorOpenerPicoWeb(credentials, discovery_payload)
            else:
                self._print_debug("Starting with network functionality...")
                dooropener = DoorOpenerPicoNetwork(credentials, discovery_payload)
    
    def _print_debug(self, message):
        """
        Prints a given debug message to the console (including date/time if enabled), wrapper around :meth:`~dooropenerpico.print_debug.Print_debug.print_debug`.

        :param str message: The message to print.
        """
        return Print_debug.print_debug(message)
        
    def _get_conf(self, filename):
        """
        Loads and parses the given filename as JSON, wrapper around :meth:`~dooropenerpico.conf.Conf._get_conf`.

        :param str filename: The conf filename to parse.
        :return: The parsed conf file, or None if the file can't be found.
        :rtype: dict or None
        """
        return Conf._get_conf(filename)
