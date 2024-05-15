#!/usr/bin/env python3

"""
watch_source utility script

* This script watches the code and documentation source directories for changes in .rst and .py files, and when a change is detected regenerates the associated documentation. 
* Saving in Vim seems to generate multiple modification events. Duplicate changes are ignored, a duplicate is determined to be the same event that occurred in less time than the value of 
_DUPLICATE_THRESHOLD in seconds, you may need to tune this value for your system depending on how long the documentation takes to generate.
* You should ensure that the associated venv for the repository is activated so that watchdog can be imported and the make scripts work properly.
"""

import time
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class Watcher:
    def __init__(self, directories, handler):
        self.observer = Observer()
        self.directories = directories
        self.handler = handler
        self.run()

    def run(self):
        for directory in self.directories:
            self.observer.schedule(self.handler, directory, recursive=True)
        self.observer.start()

        print(f"Watching {self.directories} for changes...")

        try:
            while True:
                time.sleep(1)
        finally:
            self.observer.unschedule_all()
            self.observer.stop()
            self.observer.join()

class DocsHandler(FileSystemEventHandler):
    _DUPLICATE_THRESHOLD = 0.8

    def __init__(self):
        self._last_event = {
            "time": 0,
            "event" : None
        }
    
    def _is_duplicate(self, event):
        change_time = time.perf_counter()
        is_duplicate = change_time - self._last_event["time"] < self._DUPLICATE_THRESHOLD and self._last_event["event"] == event

        self._last_event = {
            "time" : change_time,
            "event" : event
        }

        return is_duplicate

    def on_any_event(self, event):
        extensions = [".py", ".rst"]

        if os.path.splitext(event.src_path)[1] in extensions and not event.is_directory and not event.event_type in ["opened", "closed"] and not self._is_duplicate(event):
            print(f"{event.src_path} was {event.event_type}, regenerating documentation...")
            os.system("make clean html")

if __name__ == "__main__":
    watch_directories = [
        os.path.realpath(os.path.join(os.getcwd(), "../lib/dooropenerpico")),
        os.path.join(os.getcwd(), "source/")
    ]

    Watcher(watch_directories, DocsHandler())
