# -*- coding: utf-8 -*-
"""
    'flask_example.py' Module Description
    This module defines code to run an example webserver
    Module defines functions corresponding to following paths:
        '/'              - hello_world function returns greetings string
"""

from flask import Flask, request
from flask import __version__ as fv

app = Flask(__name__)

@app.route('/')
def hello_world() -> str:
    """
        Args:
            no arguments expected
        Returns:
            str: greetings message
        Note:
            uses 'request' global variable from flask module to read HTTP REST query parameters.
            if query parameter with key 'name' has no value, than uses 'World' as default
    """
    name = request.args.get("name", "World")
    return "Hello, {}!".format(name)

@app.route('/version')
def version() -> str:
    """
        Args:
            no arguments expected
        Returns:
            str: Flask Version
    """
    return "Flask Version is {}".format(fv)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
