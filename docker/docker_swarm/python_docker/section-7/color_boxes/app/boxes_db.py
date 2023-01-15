# -*- coding: utf-8 -*-
"""
    'boxes_db.py' Module Description
    This module defines code to handle Database operations for Color Boxes.

    Module code creates or opens SQLite3 Database.
    Database file path is read from Environment Variable DATABASE_URL,
    if not present, then default is 'boxes_db.sqlite3'
    There are no checks or exception handling for Database read or write errors.

    Module defines ColorBox class.

    Module defines following functions:
        db_list_boxes       - returns a dictionary representing boxes existing in Database
        db_get_box          - returns number of balls in a box
        db_create_box       - creates a box with 0 balls
        db_delete_box       - deletes a box
        db_update_box       - updates number of balls in a box
"""
import os
from typing import Dict
from sqlalchemy import create_engine, Column, String, Integer, Sequence
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

# Create Engine
DATABASE_URL = os.getenv('DATABASE_URL', default='sqlite:///boxes_db.sqlite3')
ENGINE = create_engine(DATABASE_URL)

# Create session
SESSION_CLASS = sessionmaker(bind=ENGINE)
SESSION = SESSION_CLASS()

BASE = declarative_base()

class ColorBox(BASE):
    """
    Class definition to declare Database Table and its Columns.
    Each row in the Table represents one color box and number of balls in the box.

    Attributes:
        __tablename__ (str) : name of Database Table
        id (int)            : unique id, primary key
        color (str)         : color of the box
        balls (int)         : number of balls in the box
    """
    __tablename__ = 'boxes'
    id = Column(Integer, Sequence('boxes_seq'), primary_key=True)
    color = Column(String(50))
    balls = Column(Integer)

# Intialize (create or open) Database
BASE.metadata.create_all(ENGINE)

# Module functions

def db_list_boxes() -> Dict[str, int]:
    """
    Lists boxes existing in Database

    Args:
        None
    Returns: Dictionary representing boxes in database
    """
    boxes = {}
    for row in SESSION.query(ColorBox).all():
        boxes[row.color] = row.balls
    return boxes

def db_get_box(color: str) -> (bool, int):
    """
    Get number of balls in a box

    Args:
        color (str)     : color of the box to check
    Returns:
        status (bool)   : True if box of requested color exists in Database, False otherwise
        balls (int)     : Number of balls in the box, 0 if box doesn't exist
    """
    for row in SESSION.query(ColorBox).filter(ColorBox.color == color):
        balls = row.balls
        status = True
        break
    else:
        balls = 0
        status = False
    return status, balls

def db_update_box(color: str, balls: int) -> bool:
    """
    Update number of balls in a box

    Args:
        color (str)     : color of the box to update
        balls (int)     : new number of balls in the box
    Returns:
        status (bool)   : True if box of requested color exists in Database, False otherwise
    """
    for row in SESSION.query(ColorBox).filter(ColorBox.color == color):
        row.balls = balls
        SESSION.commit()
        status = True
        break
    else:
        status = False
    return status

def db_create_box(color: str) -> bool:
    """
    Create a new box with given color

    Args:
        color (str)     : color of the box to create
    Returns:
        status (bool)   : True if new box has got created,
                          False if box with given color already exists in Database
    """
    if SESSION.query(ColorBox).filter(ColorBox.color == color).count() > 0:
        status = False
    else:
        box = ColorBox(color=color, balls=0)
        SESSION.add(box)
        SESSION.commit()
        status = True
    return status

def db_delete_box(color: str) -> bool:
    """
    Delete a box with given color

    Args:
        color (str)     : color of the box to delete
    Returns:
        status (bool)   : True if box has been deleted, False otherwise
    """
    for row in SESSION.query(ColorBox).filter(ColorBox.color == color):
        SESSION.delete(row)
        status = True
        break
    else:
        status = False
    return status
