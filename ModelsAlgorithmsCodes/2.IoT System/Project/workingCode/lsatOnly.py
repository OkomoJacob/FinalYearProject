'''Just collects Air temp and Humidity via DHT11 and displays it via terminal'''
import RPi.GPIO as GPIO
import datetime 
import dht11
import time

# initialize GPIO
GPIO.setwarnings(True)
GPIO.setmode(GPIO.BCM)

# read data using GPIO 17
instance = dht11.DHT11(pin=17)
print("Connecting to GPS...")
time.sleep(1)

try:
	while True:
	    result = instance.read()
	    if result.is_valid():
	        print("Last valid input: " + str(datetime.datetime.now()))
	        lsat = result.temperature
	        print("LSAT: %-3.1f °C " % lsat)
	        print("Humidity: %-3.1f %% \n" % result.humidity)

	    time.sleep(1)

except KeyboardInterrupt:
    print("Cleanup")
    GPIO.cleanup()