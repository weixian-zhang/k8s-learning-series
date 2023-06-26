from flask import Flask
import jsonpickle
from dto import Booking
from loguru import logger
from dotenv import load_dotenv
import os
from faker import Faker
import requests
import dto

faker = Faker()

#load config from .env
load_dotenv()

logFilePath = os.getenv('log_file_path')

logger.add(logFilePath, rotation="10 MB")  # Specify the log file path and rotation settings

app = Flask(__name__)

hmt_url = os.getenv('handymantracker_url')

@app.route('/health')
def health():
    return {
        'alive': True
    }


@app.route('/bookings/list')
def list_bookings():
    
    try: 
        logger.info('retrieving handyman list from handymantracker service')
        resp = requests.get(f'{hmt_url}/list')
        jResult = resp.json()
    except Exception as e:
        logger.error(f'error retrieving handyman list from handymantracker service: {str(e)}')
        return []
        
    bookings = []
    
    for h in jResult:
        longlat = faker.latlng()
        addr = faker.address()
        booking = Booking(addr, dto.LatLong(float(longlat[0]), float(longlat[1])), faker.date_time(), h)
        bookings.append(booking)
        
        
    bookingsJson = jsonpickle.dumps(bookings, unpicklable=False)
    
    return bookingsJson


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)