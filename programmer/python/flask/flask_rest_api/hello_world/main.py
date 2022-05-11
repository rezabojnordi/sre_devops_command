from flask import Flask, request, jsonify
from flask_restful import Resource, Api

app = Flask(__name__)

api = Api(app)
names = {"reza":{"age":30,"job":"student"},
        "bill":{"age":40,"job":"teacher"}}
class Hello(Resource):
    def get(self,name):
        return names[name]
    
    # def post(self):
    #     return {"data": "POST"}
        
api.add_resource(Hello, '/<string:name>')

if __name__ == '__main__':
    app.run(debug=True)
    
