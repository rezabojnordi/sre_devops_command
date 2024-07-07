from flask import Flask
from time import sleep
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    sleep(10)
    app.run()
