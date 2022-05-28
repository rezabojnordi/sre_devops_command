from flask import Flask, url_for
from flask import request
app = Flask(__name__)
@app.route('/hello')
def api_hello():
    if 'name' in request.args:
        return 'Hello ' + request.args['name']
    else:
        return 'Hello John Doe'
if __name__ == '__main__':
    app.run()


# curl 127.0.0.1:5000/hello
# curl 127.0.0.1:5000/hello?name=reza