import json
import sys
from dooropenerpico.print_debug import Print_debug
print_debug = Print_debug.print_debug

class Conf(object):
    """
    A utility class that allows you to retrieve and parse a conf file as JSON, or validate a given conf file.
    """
    @staticmethod
    def _get_conf(filename):
        """
        Tries to load and JSON parse a given filename.

        :param str filename: The conf filename to parse.
        :return: The parsed conf file, or None if the file can't be found.
        :rtype: dict or None
        """
        try:
            with open(filename) as conf:
                return json.load(conf)
        except OSError:
            return
    
    @staticmethod
    def _validate_conf(filename, keys):
        """
        Validates that a given configuration file exists, and contains the given keys with some associated value. Terminates the script if any of these checks fail.

        :param str filename: The conf filename to validate.
        :param dict keys: The list of keys to check for existence/associated value.

        :return: The parsed conf file.
        :rtype: dict
        """
        conf = Conf._get_conf(filename)
        
        if conf:
            for key in keys:
                if key in conf:
                    if conf[key] == None or conf[key] == "":
                        print_debug(f"Key {key} didn't have an associated value, halting...")
                        sys.exit(1)
                else:
                    print_debug(f"Couldn't find key {key}, halting...")
                    sys.exit(1)
                    
        else:
            print_debug(f"Couldn't find {filename}, halting...")
            sys.exit(1)
        
        return conf
