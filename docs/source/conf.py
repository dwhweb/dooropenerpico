import pathlib
import sys

# Code path for autodoc
sys.path.insert(0, pathlib.Path(pathlib.Path(__file__).parents[2], "lib").resolve().as_posix())

# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
project = 'dooropenerpico'
copyright = '2024 CC-BY-4.0, dwhweb'
author = 'dwhweb'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
extensions = [
        "sphinx.ext.autodoc",
        "sphinx.ext.autosummary",
        "sphinx.ext.inheritance_diagram",
        "sphinxcontrib.youtube"
]

# Packages to mock as they're Micropython specific and Sphinx can't import them
autodoc_mock_imports = ["picozero", "uasyncio", "machine", "umqtt", "network", "microdot_asyncio", "microdot_asyncio_websocket"]

autodoc_default_options = {
        "members": True,
        "private-members": True,
        "undoc-members": False
}

add_module_names = False
toc_object_entries_show_parents = "hide"

templates_path = ['_templates']
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
html_theme = 'furo'
html_static_path = ['_static']
html_css_files = [
        "css/custom.css"
]

# Furo options
html_logo = "_images/chicken.svg"
