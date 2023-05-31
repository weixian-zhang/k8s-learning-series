from flask import Flask
import jsonpickle
from dto import Booking
from loguru import logger
from dotenv import load_dotenv
import os

#load config from .env
load_dotenv()

logFilePath = os.getenv('log_file_path')

logger.add(logFilePath, rotation="10 MB")  # Specify the log file path and rotation settings

app = Flask(__name__)

@app.route('/health')
def health():
    return {
        'alive': True
    }


@app.route('/bookings')
def list_bookings():
    bookings = [
        Booking('Pete', 'all sorts of repair work'),
        Booking('Harry', 'all sorts of repair work'),
        Booking('Sonya', 'all sorts of repair work'),
    ]
    bookingsJson = jsonpickle.dumps(bookings, unpicklable=False)
    
    logger.info(f'bookings: {bookingsJson}')
    
    return bookingsJson


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)