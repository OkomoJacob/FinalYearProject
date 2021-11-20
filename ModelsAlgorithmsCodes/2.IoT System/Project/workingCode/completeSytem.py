'''1. LSAT Starts here'''
import RPi.GPIO as GPIO
import dht11
import time
import datetime 
import time #to delay your LED, LSAT collection timing

# initialize GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

ledPin = 4 #Use pin 7 (GPIO 4)
GPIO.setup(ledPin, GPIO.OUT)

# read dht11 data using GPIO pin 17
instance = dht11.DHT11(pin=17)
# The Real Guy
print("Secure connection established")
time.sleep(2.5)
print("Connecting to GPS...")
time.sleep(6)
print("LSAT collection start...")
#Flashing
#while True: #Run forever
     
try:
    while True:
        GPIO.output(ledPin, GPIO.HIGH)
        time.sleep(0.25)
        #  print("Going Off")
        GPIO.output(ledPin, GPIO.LOW)
        time.sleep(0.25)
        
        result = instance.read()
        if result.is_valid():
            print("Last valid input: " + str(datetime.datetime.now()))
            print("LSAT: %-3.1f C\n" % result.temperature)

except KeyboardInterrupt:
    print("Cleanup")
    GPIO.cleanup()
