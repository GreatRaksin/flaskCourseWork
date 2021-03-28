from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import psycopg2
from config import Config

try:
    conn = psycopg2.connect(database='postgres', user='postgres',
                            password='root', host='localhost')
    print('connected')
    cursor = conn.cursor()
except ConnectionError as C:
    print('unable to connect', C)

app = Flask(__name__)
app.config.from_object(Config)
app.config['SQLALCHEMY_DATABASE_URI'] = 'https://localhost/postgres'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

from routes import *

if __name__ == '__main__':
    app.run(port=8080)
