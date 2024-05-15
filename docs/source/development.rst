Development
===========
I'm open to contributions to the project if you have something in mind that you feel has general interest, but bear in mind that I created this project for my own personal use and don't want to make any major changes that make it less useful to me — open a `Github issue <https://github.com/dwhweb/dooropenerpico/issues>`_ or send an email to **dooropenerpico at dwhweb dot org** if you have something in mind.

Cloning the repository
----------------------
Once you've cloned the repository, there is a pre-commit hook that you should activate to prevent you accidentally committing wifi/MQTT credentials to the repository —

.. code:: bash

   git clone https://www.github.com/dwhweb/dooropenerpico.git
   git config --local core.hooksPath .githooks/

Development requirements
------------------------
The requirements in ``requirements.txt`` actually pertain to working on the Sphinx documentation rather than being anything to do with MicroPython. As such, you want to create a venv, activate it and install the requirements —

.. code:: bash

   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt

Working on the documentation
----------------------------
Once you've activated your venv, there is a script ``watch_source.py`` which will monitor the ``lib/dooropenerpico/`` and ``docs/source/`` directories in ``docs/`` and run ``make clean html`` automatically when any ``.py`` or ``.rst`` files change —

.. code:: bash

   source .venv/bin/activate
   cd docs
   ./watch_source.py

Extensive API documentation is detailed in the next section.
