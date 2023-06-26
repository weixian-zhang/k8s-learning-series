from enum import Enum
from typing import List

class HandymanSkill(Enum):
    plumbing = 'plumbing'
    electrical = 'electrical'
    carpentry = 'carpentry'
    painting = 'painting'
    gardening = 'gardening'
    general_fixing = 'general fixing'
    lockpick = 'lockpick'



class Handyman:
    def __init__(self, name, phone, skillsets) -> None:
        self.name = name
        self.phone  =  phone
        self.skillsets = skillsets
	
 
class Booking:
    def __init__(self, address, latlong, schedule, handyman):
        self.address = address
        self.latlong = latlong
        self.schedule = schedule
        self.handyman = handyman

class LatLong:
    def __init__(self, lat, long):
        self.lat = lat
        self.long = long

