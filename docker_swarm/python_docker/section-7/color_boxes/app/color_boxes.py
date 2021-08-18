# -*- coding: utf-8 -*-
"""
    'color_boxes.py' Module Description
    This module defines code to run an example RESTful API Server
    Module defines following APIs:
        GET     '/'                                - returns greetings string
        GET     '/box'                             - returns HTML list of boxes
                                                     with number of balls in them
        GET     '/box/<string:color>'              - return number of balls in a box
        POST    '/box/<string:color>'              - create an empty box with color
        DELETE  '/box/<string:color>'              - remove box with color
        PUT     '/box/<string:color>/<int:balls>'  - update number of balls in box with color
"""

from flask import Flask, request, Response, jsonify
from boxes_db import db_list_boxes, db_create_box, db_get_box, db_update_box, db_delete_box

APP = Flask(__name__)

@APP.route('/')
def hello_world() -> Response:
    """
        Args:
            no arguments expected
        Returns:
            Response: HTTP 200 with greetings message
    """
    response = "Hello stranger!"
    status_code = 200 # OK
    return Response(response, status_code)

@APP.route('/box', methods=['GET'])
def list_boxes() -> Response:
    """
        Args:
            no arguments expected
        Returns:
            Response: HTTP status code 200 and JSON with dictionary representing all boxes
    """
    response = db_list_boxes()
    status_code = 200
    return APP.make_response((jsonify(response), status_code, {'Content-Type': 'application/json'}))

@APP.route('/box/<string:color>', methods=['GET'])
def get_box(color: str) -> Response:
    """
        Args:
            str:color - color attribute of box to get

        Returns:
            Response: HTTP status code 200 (OK) or 404 (not found) and
                      JSON with dictionary representing box with color
    """
    exists, balls = db_get_box(color)
    if exists:
        response = { color : balls }
        status_code = 200 # OK
    else:
        response = {}
        status_code = 404 # Not found
    return APP.make_response((jsonify(response), status_code, {'Content-Type': 'application/json'}))

@APP.route('/box/<string:color>', methods=['POST', 'DELETE'])
def manage_box(color: str) -> Response:
    """
        Args:
            str:color - color attribute of the box to manage
            str:request.method - POST=create, DELETE=delete a box of given color

        Returns:
            Response: HTTP status code 200 (OK), 400 (bad create) or 404 (bad delete) and
                      text message confirming status of operation
    """
    if request.method == 'POST': # Create new box
        if db_create_box(color):
            response = "<p>Empty box <b>{}</b> created.</p>".format(color)
            status_code = 200 # OK
        else:
            response = "<p>Box <b>{}</b> already exists! Delete it first.</p>".format(color)
            status_code = 400 # Bad request
    elif request.method == 'DELETE': # Delete existing box
        if db_delete_box(color):
            response = "<p>Box <b>{}</b> deleted.</p>".format(color)
            status_code = 200 # OK
        else:
            response = "<p>Cannot delete box <b>{}</b>! No such box.</p>".format(color)
            status_code = 404 # Not found
    return APP.make_response((response, status_code, {'Content-Type': 'text/html'}))

@APP.route('/box/<string:color>/<int:balls>', methods=['PUT'])
def store_balls(color: str, balls: int) -> Response:
    """
        Args:
            str:color, int:balls - update numbers of balls in the box, if exists
        Returns:
            Response: HTTP status code 200 (OK) or 404 (box not found)
                      and text message confirming status of operation
    """
    if db_update_box(color, balls):
        response = "<p>Box <b>{}</b> contains {} balls.<p>".format(color, balls)
        status_code = 200 # OK
    else:
        response = "<p>No box <b>{}</b>! Create it first</p>".format(color)
        status_code = 404 # Not found
    return APP.make_response((response, status_code, {'Content-Type': 'text/html'}))

if __name__ == '__main__':
    APP.run(debug=True, host='0.0.0.0')
