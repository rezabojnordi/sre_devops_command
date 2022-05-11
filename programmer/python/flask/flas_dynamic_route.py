from flask import Flask
app = Flask(__name__)

@app.route("/")
def index():
    return "Reza Bojnordi"

@app.route("/<name>")
def print(name):
    return 'Welcome, {}'.format(name)

if __name__ == '__main':
    app.run(debug=True)
    