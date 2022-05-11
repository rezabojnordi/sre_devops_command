from flask import Flask, json, request, url_for
app = Flask(__name__)

import logging
file_handler = logging.FileHandler('app.log')
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)

@app.route('/hello', methods = ['GET'])
def api_hello():
    app.logger.info('informing')
    app.logger.warning('warning')
    app.logger.error('screaming bloody murder!')
    
    return "check your logs\n"


#curl -v -u "admin:secret" http://127.0.0.1:5000/secrets

if __name__ == '__main__':
    app.run()

