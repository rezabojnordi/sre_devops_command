from pydoc import describe
from flask import Flask,jsonify
from flasgger import Swagger,swag_from

app = Flask(__name__)

# swagger = Swagger(app)

template = {
    "swagger": "2.0",
    "info":{
        "title": "Zoo API",
        "description": "API for zoo data.",
        "contact":{
            "responsibleOrganization": " ZooCorp",
            "responsibleDeveloper": "ZooDev",
            "email": "zoo@zoo.com",
            "url": "www.zoo.com",
        },
        "termsofService":"http://zoom.com/terms",
        "version": "0.0.1",
    },
    "hosts":"zoo.com",
    "basePath":"/api",
    "schemes": [ "http","https"],
    "operationId": "getmyzoo"
}

swagger = Swagger(app,template = template)

@app.route("/")
def base():
    return "hello world"


@app.route("/animals/<type>")
@swag_from("docs/animals.yml")
def get_info(type):
    zoo = {
    "4legs":["cat","dog","horse"],
    "2legs":["chocken","duck","monkey"]}

    if type == "all":
        result = zoo
    else:
        result = zoo.get(type)
    
    return jsonify(result)



if __name__ == "__main__":
    app.run(debug=True)