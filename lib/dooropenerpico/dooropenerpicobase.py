import time
import uasyncio as asyncio
from picozero import Button, PWMLED, Servo, DigitalOutputDevice
from dooropenerpico.print_debug import Print_debug
from dooropenerpico.conf import Conf

class DoorOpenerPicoBase:
    """
    Base class for the door opener, superclass of :class:`~dooropenerpico.dooropenerpiconetwork.DoorOpenerPicoNetwork` and :class:`~dooropenerpico.dooropenerpicoweb.DoorOpenerPicoWeb`.
    """
    def __init__(self):
        """
        Loads configuration options, initialises board hardware devices and indicates the board has started by flashing the control panel LEDs alternately.
        """
        self.config = self._load_config()
        
        self._init_hardware()
        self._show_startup()
    
    def _print_debug(self, message):
        """
        Prints a given debug message to the console (including date/time if enabled), wrapper around :meth:`~dooropenerpico.print_debug.Print_debug.print_debug`.

        :param str message: The message to print.
        """
        return Print_debug.print_debug(message)

    def _init_hardware(self):
        """
        Initialises the door opener hardware such as switches, LEDs, the servo and the relay.
        """
        self.switch = Button(15)
        self.left_reed = Button(12, bounce_time=self.config["left_reed_bounce_time"])
        self.right_reed = Button(11, bounce_time=self.config["right_reed_bounce_time"])
        self.green_led = PWMLED(13);
        self.red_led = PWMLED(14);
        self.servo = Servo(pin=10, min_pulse_width=0.0005, max_pulse_width=0.0025) # Pulse width floats are actually in seconds i.e. 500-2500 microseconds from the datasheet
        self.relay = DigitalOutputDevice(9)
    
    def _show_startup(self):
        """
        Signifies successful startup by flashing the LEDs alternately and printing to the console, sets the door state and starts the main event loop.
        """
        self._startup_leds()
        self._set_state(self._check_state())
        self._print_debug("Door opener started.")
        self._loop()
    
    def _show_error(self):
        """
        Signifies the door is in the error state, flashes the red LED. Overridden in subclasses.
        """
        self._error_leds()

    def _check_state(self):
        """
        Checks the state of the reed switches, the left and right switches have to be mutually exclusively activated for the state to be determined as open or closed.

        :return: The current state of the door as indicated by the sensors, can be "open", "closed" or "error".
        :rtype: str
        """
        if self.left_reed.is_pressed and not self.right_reed.is_pressed:
            return "open"

        if not self.left_reed.is_pressed and self.right_reed.is_pressed:
            return "closed"

        return "error"
    
    def _set_state(self, state):
        """
        Sets the LED activity appropriately, overridden in subclasses.

        :param str state: State to set, can be "open", "closed", "opening" or "closing".
        """
        self._clear_leds()

        if state == "opening":
            self.red_led.pulse(fade_in_time=self.config["pulse_time"], fade_out_time=self.config["pulse_time"])
        elif state == "closing":
            self.green_led.pulse(fade_in_time=self.config["pulse_time"], fade_out_time=self.config["pulse_time"])
        elif state == "open":
            self.red_led.value = self.config["led_brightness"]
        elif state == "closed":
            self.green_led.value = self.config["led_brightness"]
        
    def _startup_leds(self, on_time=0.5, loops=2):
        """
        Indicates that the door opener has started by flashing the green and red LEDs alternately.

        :param float on_time: The time that each LED is on for, in seconds.
        :param int loops: The number of times that the green and red LED should alternately flash (e.g. 2 means green -> red -> green -> red).
        """
        self._clear_leds()
        
        for _ in range(loops):
            self.green_led.value = 1
            time.sleep(on_time)
            self.green_led.value = 0
            self.red_led.value = 1
            time.sleep(on_time)
            self.red_led.value = 0
    
    def _clear_leds(self):
        """
        Turns off all the LEDs.
        """
        self.red_led.value = 0
        self.green_led.value = 0
    
    def _error_leds(self):
        """
        Blinks the red LED to indicate that the door could not successfully open or close.
        """
        self._clear_leds()
        self.red_led.blink()
 
    def _wait_for_reed(self, reed, timeout=0):
        """
        Returns either when the given reed switch is pressed, or when the timeout is reached.
        
        :param Button reed: A Button instance representing the relevant reed switch (left or right).
        :param float timeout: Time after which the method returns if the reed is not yet activated, in seconds.
        """
        start = time.ticks_ms()
        timeout = timeout * 1000
        
        while(time.ticks_diff(time.ticks_ms(), start) < timeout): # Can't just use standard comparison
            if reed.is_closed:
                return
        
        return
    
    def _stop_servo(self):
        """
        Sets the servo to the stop position, stops the servo and disables the power relay that supplies the servo with power.
        """
        self.servo.mid()
        self.servo.off()
        self.relay.off()
    
    def _force_open_or_closed(self, state):
        """
        Opens or closes the door, doesn't check the sensors first to determine whether to continue. Verifies the door opened or closed, displays error otherwise.

        :param str state: The intended state of the door, can be "open" or "closed".
        """
        error_dict = {"open" : "open", "closed" : "close"} # So the error message reads properly
        
        def _movement_helper(state, speed, cushion_time, cushion_speed, reed):
            """
            Helper function, does the opening or closing
            """
            self._set_state(state)
            self.servo.value = speed
            time.sleep(cushion_time)
            self.servo.value = cushion_speed
            self._wait_for_reed(reed, (self.config["timeout"] - cushion_time))
            
        self.relay.on()

        if(state == "open"):
            _movement_helper("opening", self.config["open_speed"], self.config["cushion_open_time"], self.config["cushion_open_speed"], self.left_reed)
        elif(state == "closed"):
            _movement_helper("closing", self.config["close_speed"], self.config["cushion_close_time"], self.config["cushion_close_speed"], self.right_reed)

        self._stop_servo()

        if(self._check_state() == state):
            self._set_state(state)

            if state == "closed":
                self._print_debug("Door closed.")
            elif state == "open":
                self._print_debug("Door opened.")
        else:
            self._error_leds()
            self._print_debug(f"Attempted to {error_dict[state]} door unsuccessfully.")

    def _force_open(self):
        """
        Opens the door, doesn't check the sensors first to determine whether to continue.
        """
        self._force_open_or_closed("open")

    def _force_closed(self):
        """
        Closes the door, doesn't check the sensors first to determine whether to continue.
        """
        self._force_open_or_closed("closed")
    
    def _open(self):
        """
        Opens the door if it is closed, or shows an error otherwise.
        """
        if(self._check_state() == "closed"):
            self._force_open()
        else:
            self._show_error()
            self._print_debug("Couldn't open the door, it was either already open or in the error state.")

    def _close(self):
        """
        Closes the door. Checks the sensors to determine that the door is actually open first, notifies with an error otherwise.
        """
        if(self._check_state() == "open"):
            self._force_closed()
        else:
            self._show_error()
            self._print_debug("Couldn't close the door, it was either already closed or in the error state.")
    
    def _toggle_door(self):
        """
        Toggles the door open or closed based on the state that the sensors report.
        """
        state = self._check_state()

        if(state == "open"):
            self._close()
        elif(state == "closed"):
            self._open()
   
    async def _switch_pressed(self):
        """
        Coroutine, checks if the door switch is pressed, checks that the door is open or closed and if so toggles the state, otherwise indicates an error with LEDs and a message.
        """
        while True:
            if self.switch.is_pressed:
                state = self._check_state()

                if(state == "open"):
                    self._print_debug("Switch pressed, door open, closing...")
                elif(state == "closed"):
                    self._print_debug("Switch pressed, door closed, opening...")
                else:
                    self._error_leds()
                    self._print_debug(f"Switch pressed, can't open or close the door as it is currently in the {state} state.")

                self._toggle_door()
                
            await asyncio.sleep(0)

    def _loop(self):
        """
        Gets the main event loop and runs it forever.
        """
        event_loop = self._get_event_loop()
        event_loop.run_forever()
    
    def _get_event_loop(self):
        """
        Adds suitable methods to the event loop and returns it. Overridden with additional tasks (network specific, web server specific) in subclasses.

        :return: The event loop.
        :rtype: class
        """
        event_loop = asyncio.get_event_loop()
        event_loop.create_task(self._switch_pressed())
        return event_loop
        
    
    def _debug(self):
        """
        Prints out the state of the door opener, useful for debugging.
        """
        self._print_debug(f"Left reed: {self.left_reed.is_pressed}")
        self._print_debug(f"Right reed: {self.right_reed.is_pressed}")
        self._print_debug(f"State: {self._check_state()}")
    
    def _get_conf_keys(self):
        """
        Returns the keys that should be present in the configuration file, this method is overridden with additional keys in subclasses.

        :return: The list of keys.
        :rtype: list
        """
        return [
            "pulse_time",
            "led_brightness",
            "timeout",
            "cushion_open_time",
            "cushion_close_time",
            "open_speed",
            "close_speed",
            "cushion_open_speed",
            "cushion_close_speed",
            "left_reed_bounce_time",
            "right_reed_bounce_time"
        ]
    
    def _load_config(self):
        """
        Validates the config file exists, contains the right keys with associated values, checks some assertions and returns the parsed config file.

        :return: The parsed conf file.
        :rtype: dict
        """
        config = Conf._validate_conf("/lib/dooropenerpico/config.conf", self._get_conf_keys())
        
        assert config["cushion_open_time"] < config["timeout"], "Config error: cushion_open_time must be less than timeout (The door must slow before the open attempt times out.)"
        assert config["cushion_close_time"] < config["timeout"], "Config error: cushion_close_time must be less than timeout (The door must slow before the close attempt times out.)"
        
        return config
