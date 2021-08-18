# -*- coding: utf-8 -*-
"""
    'color-boxes.py' Module Description
    This module defines code to run an example RESRTful API Server
    Module defines following APIs:
        GET     '/'                                - returns greetings string
        GET     '/box'                             - returns HTML list of boxes with number of balls in them
        GET     '/box/<string:color>'              - return number of balls in <color> box
        POST    '/box/<string:color>'              - create an empty box painted with <color>
        DELETE  '/box/<string:color>'              - remove box painted with <color>
        PUT     '/box/<string:color>/<int:balls>'  - update number of <balls> in box painted with <color>
"""

from flask import Flask, request

app = Flask(__name__)
boxes = {}

@app.route('/')
def hello_world() -> str:
    """
        Args:
            no arguments expected
        Returns:
            str: greetings message
    """
    return "Hello stranger!"

@app.route('/box', methods=['GET'])
def list_boxes() -> str:
    """
        Args:
            no arguments expected
        Returns:
            str: HTML list of all boxes and number of balls in them
    """
    response = "<p>Hello! We have following boxes here:</p>"
    response += "<ul>"
    for color, balls in boxes.items():
        response += "<li>{} has {} balls</li>".format(color,balls)
    response += "</ul>"
    return response

@app.route('/box/<string:color>', methods=['GET', 'POST', 'DELETE'])
def manage_box(color) -> str:
    """
        Args:
            str:color - create, delete a box of given color, or return numbers of balls in the box, if one exists
        Returns:
            str: message confirming operation or number of balls in a box
    """
    if request.method == 'POST':
        if color in boxes:
            return "Box '{}' already exists! Delete it first.".format(color)
        else:
            boxes[color] = 0
            return "Empty box '{}' created.".format(color)
    elif request.method == 'DELETE':
        if color in boxes:
            boxes.pop(color)
            return "Box '{}' deleted.".format(color)
        else:
            return "Cannot delete box '{}'. No such box.".format(color)
    elif request.method == 'GET':
        if color in boxes:
            return "Box '{}' contains {} balls.".format(color, boxes[color])
        else:
            return "No box '{}'! Create it first".format(color)

@app.route('/box/<string:color>/<int:balls>', methods=['PUT'])
def store_balls(color, balls) -> str:
    """
        Args:
            str:color, int:balls - update numbers of balls in the box, if exists
        Returns:
            str: message confirming operation
    """
    if color in boxes:
        boxes[color] = balls
        return "Box '{}' contains {} balls.".format(color, balls)
    else:
        return "No box '{}'! Create it first".format(color)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
