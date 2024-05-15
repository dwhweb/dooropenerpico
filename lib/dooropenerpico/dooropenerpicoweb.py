from dooropenerpico.dooropenerpiconetwork import DoorOpenerPicoNetwork
import uasyncio as asyncio
import json
import time
from microdot_asyncio import Microdot, send_file
from microdot_asyncio_websocket import with_websocket

class DoorOpenerPicoWeb(DoorOpenerPicoNetwork):
    """
    Web subclass of :class:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork`, implements web server functionality.
    """
    def __init__(self, credentials, discovery_payload):
        """
        Initialises the wireless interface amd MQTT client, loads login credentials, discovery payload and configuration options, initialises board hardware devices, sets up networking (including the web server) and indicates the board has started by flashing the control panel LEDs alternately. 

        :param dict credentials: Wireless network and MQTT login credentials.
        :param dict discovery_payload: The discovery payload to be sent to the MQTT server.
        """
        super().__init__(credentials, discovery_payload)
        
    def _network_setup(self):
        """
        Initialises MQTT topic variables, connects to the wifi and MQTT broker, publishes the MQTT discovery payload so Home Assistant can create a suitable entity, sets the availability of the door opener and sets up the web server. Overridden from :meth:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork._network_setup`.
        """
        super()._network_setup()
        self._web_setup()
    
    def _web_setup(self):
        """
        Initialises the webserver and all associated routes, also sets up the websocket route and sets up method dispatchers for any websocket messages recieved.
        """
        self.web_server = Microdot()
        
        @self.web_server.route("/")
        async def index(request):
            return send_file(f"/lib/dooropenerpico/web/index.html")
        
        # index.js, index.css etc
        @self.web_server.route("/<re:index\..+:filename>")
        async def index(request, filename):
            return send_file(f"/lib/dooropenerpico/web/{filename}")
        
        @self.web_server.route('/ws')
        @with_websocket
        async def ws(request, ws):
            while True:
                message = await ws.receive()
                self._print_debug(f"Websocket message recieved: {message}")
                
                if message == "left-button":
                    self.relay.on()
                    self.servo.value = self.config["left_speed"]
                if message == "right-button":
                    self.relay.on()
                    self.servo.value = self.config["right_speed"]
                if message == "stop-button":
                    self.servo.mid()
                    self.servo.off()
                if message == "force-open-button":
                    self._force_open()
                if message == "force-closed-button":
                    self._force_open_or_closed("closed")
                if message == "time-button":
                    await self._time_actuation(ws)
                if message == "relay-button":
                    self.relay.toggle()
                if message == "red-led-button":
                    self.red_led.toggle()
                if message == "green-led-button":
                    self.green_led.toggle()
                if message == "refresh-button":
                    await self._send_state(ws)
    
    async def _send_state(self, socket, time=None, time_error=False):
        """
        Sends the current state of the door opener via websocket connection.

        :param WebSocket socket: The websocket connection to use.
        :param float time: The time taken to actuate the door (if applicable).
        :param str time_error: Error message to indicate the door couldn't actuate (if applicable).
        """
        await socket.send(json.dumps({
            "door-state": f"{self._check_state()}",
            "switch-state": f"{self.switch.is_pressed}",
            "left-reed-state": f"{self.left_reed.is_pressed}",
            "right-reed-state": f"{self.right_reed.is_pressed}",
            "relay-state": f"{self.relay.is_active}",
            "red-led-state": f"{self.red_led.is_active}",
            "green-led-state": f"{self.green_led.is_active}",
            "time-state": time,
            "time-error": time_error
        }))
                
    def _get_event_loop(self):
        """
        Adds suitable methods to the event loop and returns it. Overridden from :meth:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork._get_event_loop` to add a web server task.

        :return: The event loop.
        :rtype: class
        """
        event_loop = super()._get_event_loop()
        event_loop.create_task(self.web_server.run(port=80, debug=True))
        return event_loop
    
    async def _time_actuation(self, socket):
        """
        Finds the amount of time the door takes to open or close and sends the result via websocket connection, useful for tuning reed switch timeout values.

        :param WebSocket socket: The websocket connection to use.
        """
        current_state = self._check_state()
        opposite_state = { "open" : "closed", "closed" : "open" }
        
        if(current_state == "error"):
            await self._send_state(socket=socket, time_error="Couldn't time the door as it is currently in the error state.")
            return
        
        tick = time.ticks_ms()
        self._force_open_or_closed(opposite_state[current_state])
        tock = time.ticks_ms()
        duration = time.ticks_diff(tock, tick) / 1000

        if(self._check_state() == opposite_state[current_state]):
            await self._send_state(socket=socket, time=duration)
        else:
            await self._send_state(socket=socket, time_error="Couldn't time the door as it didn't successfully open or close.")
    
    def _get_conf_keys(self):
        """
        Returns the keys that should be present in the configuration file, overridden from :meth:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork._get_conf_keys`.

        :return: The list of keys.
        :rtype: list
        """
        return (super()._get_conf_keys() + ["left_speed", "right_speed"])
    
    def _set_state(self, state):
        """
        Publishes the door state to the MQTT broker and sets LED activity appropriately (only in the case of the door being open or closed). Overrides :meth:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork._set_state`.

        This overridden method is a workaround and has the whole state setting procedure as trying to set LED to pulse while the web server is running with multiple super() calls results in recursion limit problems (stack size isn't big enough and results in a crash). Don't refactor this.

        :param str state: State to set, can be "open", "closed", "opening" or "closing".
        """
        self._print_debug(f"Publishing state to MQTT broker as \"{state}\"...")
        self.mqtt_client.publish(self.state_topic, state, True, 1)
        
        self._clear_leds()
        
        if state == "opening":
            #self.red_led.pulse(fade_in_time=self.config["pulse_time"], fade_out_time=self.config["pulse_time"])
            pass
        elif state == "closing":
            #self.green_led.pulse(fade_in_time=self.config["pulse_time"], fade_out_time=self.config["pulse_time"])
            pass
        elif state == "open":
            self.red_led.value = self.config["led_brightness"]
        elif state == "closed":
            self.green_led.value = self.config["led_brightness"]
        
        
