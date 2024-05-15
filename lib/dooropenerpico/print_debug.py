from machine import RTC

class Print_debug(object):
    """
    A utility class that allows you to print a debug message to the console with an optional timestamp. The RTC of the Pi Pico is set automatically by the Thonny IDE, if you are using it.
    """
    rtc = RTC() #: The realtime clock of the Pi Pico.
    print_timestamps = True #: Boolean; whether to print timestamps.
    
    @staticmethod
    def print_debug(message):
        """
        Prints a debug message, including an optional timestamp if `print_timestamps` is True.

        :param str message: The message to print.
        """
        if(Print_debug.print_timestamps):
            now = Print_debug.rtc.datetime()
            message = f"{now[0]}-{now[1]:02d}-{now[2]:02d} {now[4]:02d}:{now[5]:02d}:{now[6]:02d}: {message}"
        
        print(message)
