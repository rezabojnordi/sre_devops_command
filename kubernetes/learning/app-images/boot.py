from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"
@app.route("/video")
def video():
    return "Hello this is a Video streaming Service!"

@app.route("/photo")
def photo():
    return "Hello This is Photo service"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port="8000")

