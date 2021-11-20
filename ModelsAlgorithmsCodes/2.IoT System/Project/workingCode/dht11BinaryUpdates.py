# This code works as clean as Heaven
import RPi.GPIO as GPIO
import dht11
import time
import datetime

# initialize GPIO
GPIO.setwarnings(True)
GPIO.setmode(GPIO.BCM)

# read data using pin GPIO 17 (pin 11)
instance = dht11.DHT11(pin=17)

try:
        while True:
            result = instance.read()
            if result.is_valid():
                print("Last valid input: " + str(datetime.datetime.now()))

                print("Temperature: %-3.1f C" % result.temperature)
