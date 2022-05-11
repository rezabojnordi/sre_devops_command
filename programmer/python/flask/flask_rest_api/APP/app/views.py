from app import app
from flask import render_template
@app.route('/')
def index():
    return render_template("/public/index.html")


@app.route('/jinha')
def jinja():
    return render_template("/public/jinja.html")

@app.route('/about')
def about():
    return '<h1>About Page</h1>'

