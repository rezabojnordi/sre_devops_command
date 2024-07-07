from flask import Flask, json, request, url_for
app = Flask(__name__)

from functools import wraps

def check_auth(username, password):
    return username == 'admin' and password == 'secret'

def authenticate():
    message = {'message': "Authenticate."}
    resp = jsonify(message)

    resp.status_code = 401
    resp.headers['WWW-Authenticate'] = 'Basic realm="Example"'

    return resp

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth: 
            return authenticate()

        elif not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwargs)

    return decorated
@app.route('/secrets')
@requires_auth
def api_hello():
    return "Shhh this is top secret spy stuff!"


#curl -v -u "admin:secret" http://127.0.0.1:5000/secrets

if __name__ == '__main__':
    app.run()


# curl -H "Content-type: application/json" -X POST http://127.0.0.1:5000/messages -d '{"message":"Hello Data"}'

# curl -H "Content-type: application/octet-stream" -X POST http://127.0.0.1:5000/messages --data-binary @message.bin