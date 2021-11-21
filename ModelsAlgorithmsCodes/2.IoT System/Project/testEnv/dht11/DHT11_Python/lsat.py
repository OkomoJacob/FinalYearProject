import RPi.GPIO as GPIO
import dht11
import time
import datetime 

# initialize GPIO
GPIO.setwarnings(True)
GPIO.setmode(GPIO.BCM)

# read data using GPIO pin 17
instance = dht11.DHT11(pin=17)
print("Connecting to GPS...")
time.sleep(1)

try:
	while True:
	    result = instance.read()
	    if result.is_valid():
	        print("Last valid input: " + str(datetime.datetime.now()))
	        lsat = result.temperature
	        print("LSAT: %-3.1f °C \n" % lsat)
	        #print("Humidity: %-3.1f %%" % result.humidity)

	    time.sleep(1)

except KeyboardInterrupt:
    print("Cleanup")
    GPIO.cleanup()