"""
A skeleton program that i Usually start with.
"""
from signal import signal, SIGTERM, SIGHUP, pause
import RPi.GPIO as GPIO
import dht11
import time
import datetime

# initialize GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

def safe_exit(signum, frame):
    exit(1)
    
signal(SIGTERM, safe_exit)
signal(SIGHUP, safe_exit)

instance = dht11.DHT11(pin = 7)

try:
    while True:
        # read data using pin 7
        result = instance.read()
        if result.is_valid():
            print("Last valid input: \n" + str(datetime.datetime.now()))
            print("Temperature: %-3.1f C" % result.temperature)
            print("Humidity: %-3.1f %%" % result.humidity)
            
            time.sleep(1)
            if result.temperature >= 26:
                print("Temp. above Normal")
                time.sleep(1)
            
except KeyboardInterrupt:
    print("Error: %d" % result.error_code)
    print("Cleanup")
    GPIO.cleanup()
