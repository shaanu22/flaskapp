import json
import requests
from flask import Flask, Response


app = Flask(__name__)

@app.route('/hello', methods=['GET'])
def hello():
    return Response("{hello world}", mimetype='application/json')

