from flask import Flask
import jsonpickle
from dto import Booking

app = Flask(__name__)

@app.route('/health')
def health():
    return {
        'alive': True
    }


@app.route('/bookings')
def list_bookings():
    bookings = [
        Booking('Jane', 19, 'Jane is a good person'),
        Booking('Heidi', 17, 'Heidi is a good person'),
        Booking('Sonya', 18, 'Sonya is a good person'),
    ]
    return jsonpickle.dumps(bookings, unpicklable=False)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)