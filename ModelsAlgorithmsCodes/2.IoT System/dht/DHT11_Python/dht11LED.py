"""
Bugs bugs and bugs
"""
from signal import signal, SIGTERM, SIGHUP, pause
import RPi.GPIO as GPIO
import dht11
import time
import datetime

# initialize GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.cleanup()

def safe_exit(signum, frame):
    exit(1)

ledGreen = 40 #Use pin 12(GPIO18)
ledRed = 38   #Use pin 12(GPIO18)
GPIO.setup(ledGreen, GPIO.OUT)
GPIO.setup(ledRed, GPIO.OUT)

def flashGreen():
    while True:
        GPIO.output(ledGreen, GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(ledGreen, GPIO.LOW)
        time.sleep(0.5)

def flashRed():
    while True:
        GPIO.output(ledRed, GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(ledRed, GPIO.LOW)
        time.sleep(0.5)
        
signal(SIGTERM, safe_exit)
signal(SIGHUP, safe_exit)

instance = dht11.DHT11(pin = 7)
try:
    while True:
        # read data using pin 7
        result = instance.read()
        if result.is_valid():
            print("Last valid input: " + str(datetime.datetime.now()))
            print("\nTemperature: %-3.1f C" % result.temperature)
            print("Humidity: %-3.1f %%" % result.humidity)
                
            time.sleep(1)
            
            if result.temperature >= 27.4:
                flashRed()

            else:
                flashGreen()
            
except KeyboardInterrupt:
    print("Error: %d" % result.error_code)
    print("Cleanup")
    GPIO.cleanup()

