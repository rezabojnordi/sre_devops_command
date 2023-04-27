import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def main():
    mysql.connector.connect(host='mysql', database='mysql',user='root',password='paswrd')

    return render_template('hello.html', color=fetchcolor())

if __name__== "__main__":
    app.run(host="0.0.0.0",port="8080")
