"""
Debug More
"""
# import the rpi system and Adafruit_DHT library
#!/usr/bin/python

from signal import signal, SIGTERM, SIGHUP, pause
import RPi.GPIO as GPIO
import sys
import Adafruit_DHT
import time
import datetime

# initialize GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

def safe_exit(signum, frame):
    exit(1)
    
signal(SIGTERM, safe_exit)
signal(SIGHUP, safe_exit)
print("Sensor Connected")
try:
    while True:
        # read data using pin 7
        humidity, temperature = Adafruit_DHT.read_retry(11, 4)
        if humidity is not None and temperature is not None:   ## if we get a reading from the sensor
            print("Last valid input: \n" + str(datetime.datetime.now()))
            print('Temp: {0:0.1f} C  Humidity: {1:0.1f} %'.format(temperature, humidity))
            
            time.sleep(1)
            if temperature >= 26:
                print("Temp. above Normal")
                time.sleep(1)
            
except KeyboardInterrupt:
    print("Error: %d" % result.error_code)
    print("Cleanup")
    GPIO.cleanup()
