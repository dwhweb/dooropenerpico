from dooropenerpico.dooropenerpicobase import DoorOpenerPicoBase
from umqtt.robust2 import MQTTClient
import network
from picozero import pico_led
import json
import uasyncio as asyncio
import time

class DoorOpenerPicoNetwork(DoorOpenerPicoBase):
    """
    Network subclass of :class:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase`, implements network and MQTT functionality.
    """
    def __init__(self, credentials, discovery_payload):
        """
        Initialises the wireless interface amd MQTT client, loads login credentials, discovery payload and configuration options, initialises board hardware devices, sets up networking and indicates the board has started by flashing the control panel LEDs alternately. 

        :param dict credentials: Wireless network and MQTT login credentials.
        :param dict discovery_payload: The discovery payload to be sent to the MQTT server.
        """
        self.nic = None
        self.mqtt_client = None
        self.credentials = credentials
        self.discovery_payload = discovery_payload
        self.config = self._load_config()
        
        self._init_hardware()
        self._network_setup()
        self._show_startup()
    
    def _network_setup(self):
        """
        Initialises MQTT topic variables, connects to the wifi and MQTT broker, publishes the MQTT discovery payload so Home Assistant can create a suitable entity and sets the availability of the door opener.
        """
        # MQTT topics
        self.discovery_topic = "homeassistant/cover/door_opener/config"
        self.state_topic = self.discovery_payload["state_topic"]
        self.command_topic = self.discovery_payload["command_topic"]
        self.availability_topic = self.discovery_payload["availability_topic"]

        # Connect to wifi and MQTT broker
        self.nic = network.WLAN(network.STA_IF)
        
        while True:
            self._connect_wifi()
                
            if self.nic.isconnected():
                self._connect_mqtt()
                if not self.mqtt_client.is_conn_issue():
                    break
            
            time.sleep(10)
        
        # Publish the autodiscovery payload so homeassistant can see the door opener
        discovery_payload = json.dumps(self.discovery_payload)
        self._print_debug("Publishing availability payload to MQTT broker...")
        self.mqtt_client.publish(self.discovery_topic, discovery_payload, True, 1)
        
        self._set_availability()
        
    def _connect_wifi(self):
        """
        Attempts to connect to the wireless access point specified in credentials.conf, displays an error if connection couldn't be established.
        """
        codes = {
                    -1 : "Connection failed.",
                    -2 : "No matching SSID found, could be down or out of range.",
                    -3 : "Authentication failure.",
                    0 : "Link is down.",
                    1 : "Connected to Wifi.",
                    2 : "Connected to Wifi, but no IP address.",
                    3 : "Connected to Wifi with an IP address."
                }
        
        pico_led.blink(on_time=0.5)
        self._print_debug(f"Connecting to {self.credentials['ssid']}...") 
        self.nic.active(False)
        self.nic.active(True)
        self.nic.config(pm=0xa11140) # Disables power saving mode, you can have connection issues if this is not disabled
        self.nic.connect(self.credentials["ssid"], self.credentials["wifi_password"])
        
        while((not self.nic.isconnected()) and self.nic.status() > 0):
            pass
        
        if(self.nic.isconnected()):
            pico_led.on()
            self._print_debug(f"Connected with IP address {self.nic.ifconfig()[0]}.")
        else:
            self._print_debug(f"Connection failed with the following error: {codes[self.nic.status()]}")

    def _connect_mqtt(self):
        """
        Connects to the MQTT broker specified in the credentials conf, subscribes to the command topic on connection. Displays an error message if connection was unsuccessful.
        """
        codes = {
                "0": "Connection accepted",
                "1": "Connection refused: level of MQTT protocol not supported by server.",
                "2": "Connection refused: client identifier not allowed by server.",
                "3": "Network connection successful but MQTT service is unavailable.",
                "4": "Data in username or password is malformed.",
                "5": "Client not authorized to connect.",
                "30": "Couldn't connect to server."
            }
        
        pico_led.blink(on_time=0.25)
        self._print_debug("Connecting to MQTT broker...")
        self.mqtt_client = MQTTClient(client_id="dooropenerpico", server=self.credentials["host"],
                                      user=self.credentials["username"], password=self.credentials["mqtt_password"])
        self.mqtt_client.set_callback(self._mqtt_command_dispatcher)
        self.mqtt_client.connect()
        
        if(not self.mqtt_client.is_conn_issue()):
            self.mqtt_client.subscribe(b"homeassistant/cover/door_opener/command")
            self._print_debug(f"MQTT connection to {self.credentials['host']}:{self.credentials['port']} established.")
            pico_led.on()
        else:
            code = str(self.mqtt_client.conn_issue[0])
            
            if code in codes:
                msg = f"{code}: {codes[code]}"
            else:
                msg = f"{code}: Unknown error"
                
            self._print_debug(f"MQTT connection encountered an error: {msg}")
    
    def _set_availability(self):
        """
        Publishes the availability of the door opener to the MQTT broker based on the current state of the door.
        """
        availability = str(self._check_state() != "error")
        self._print_debug(f"Publishing availability to MQTT broker as \"{availability}\"...")
        self.mqtt_client.publish(self.availability_topic, availability, True, 1)
    
    def _set_state(self, state):
        """
        Publishes the current state of the door to the MQTT broker and sets the LED activity appropriately. Overridden from :meth:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase._set_state`.

        :param str state: State to set, can be "open", "closed", "opening" or "closing".
        """
        self._print_debug(f"Publishing state to MQTT broker as \"{state}\"...")
        self.mqtt_client.publish(self.state_topic, state, True, 1)
        super()._set_state(state)
    
    def _show_error(self):
        """
        Signifies the door is in the error state, publishes the availability to the MQTT broker and flashes the red LED. Overridden from :meth:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase._show_error`.
        """
        self._set_availability()
        self._error_leds()
    
    def _force_open_or_closed(self, state):
        """
        Publishes the state of the door to the MQTT broker, then opens or closes the door, doesn't check the sensors first to determine whether to continue. Verifies the door successfully opened or closed, displays error otherwise. Overridden from :meth:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase._force_open_or_closed`.

        :param str state: The intended state of the door, can be "open" or "closed".

        """
        self._set_availability()
        super()._force_open_or_closed(state)
    
    def _mqtt_command_dispatcher(self, topic, payload, retained, duplicate):
        """
        Calls a given door function (open, close, force_open or force_close) when an applicable MQTT message is recieved.
        """
        self._print_debug(f"MQTT message \"{payload}\" recieved, calling function (if applicable)")

        if(payload == b"open"):
            super()._open()
        elif(payload == b"closed"):
            super()._close()
        elif(payload == b"force_open"):
            super()._force_open()
        elif(payload == b"force_closed"):
            super()._force_closed()
    
    async def _maintain_connections(self):
        """
        Coroutine, reconnects to the wifi and MQTT broker in the case of a connection issue.
        """
        while True:
            while True:
                if self.nic.isconnected() and not self.mqtt_client.is_conn_issue():
                    break
                
                if not self.nic.isconnected():
                    self._print_debug("Wifi connection dropped, attempting to reconnect...")
                    self._connect_wifi()
                    
                if self.nic.isconnected() and self.mqtt_client.is_conn_issue():
                    self._print_debug("MQTT broker connection dropped, attempting to reconnect...")
                    self._connect_mqtt()
                
                time.sleep(10)
            
            await asyncio.sleep(0)
    
    async def _check_msg(self):
        """
        Coroutine, checks if any MQTT messages have been recieved.
        """
        while True:
            self.mqtt_client.check_msg()
            await asyncio.sleep(0)
    
    async def _ping(self):
        """
        Coroutine, periodically pings the MQTT broker at the interval set in the config. Regular network activity is required to detect if there has been a connection issue.
        """
        while True:
            self._print_debug(f"Attempting to ping MQTT broker, ping interval {self.config['ping_interval']}s...")
            self.mqtt_client.ping()
            await asyncio.sleep(self.config["ping_interval"])
    
    def _get_event_loop(self):
        """
        Adds suitable methods to the event loop and returns it. Overridden from :meth:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase._get_event_loop` to add additional network related tasks.

        :return: The event loop.
        :rtype: class
        """
        event_loop = super()._get_event_loop()
        event_loop.create_task(self._switch_pressed())
        event_loop.create_task(self._maintain_connections())
        event_loop.create_task(self._check_msg())
        event_loop.create_task(self._ping())
        return event_loop
    
    def _get_conf_keys(self):
        """
        Returns the keys that should be present in the configuration file, overridden from :meth:`~dooropenerpico.dooropenerpicobase.DoorOpenerPicoBase._get_conf_keys`.

        :return: The list of keys
        :rtype: list
        """
        return (super()._get_conf_keys() + ["ping_interval"])
