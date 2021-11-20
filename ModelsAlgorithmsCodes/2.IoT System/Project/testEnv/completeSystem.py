'''1. LSAT Starts here'''
import RPi.GPIO as GPIO
import dht11
import time
import datetime 
import time #to delay your LED, LSAT collection timing

#Set up your pins to use board numbering
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

ledPin = 7 #Use pin 12(GPIO18)
GPIO.setup(ledPin, GPIO.OUT)

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
	        print("Temperature: %-3.1f C" % result.temperature)
	        print("Humidity: %-3.1f %%" % result.humidity)

	    time.sleep(6)

except KeyboardInterrupt:
    print("Cleanup")
    GPIO.cleanup()


'''
2.System set to start working immediately on load
'''
# import RPi.GPIO as GPIO
# import time #to delay your LED

# #Set up your pins to use board numbering
# GPIO.setmode(GPIO.BOARD)
# GPIO.setwarnings(False)

# ledPin = 7 #Use pin 12(GPIO18)
# GPIO.setup(ledPin, GPIO.OUT)

print("Secure connection established")
time.sleep(2.5)
print("Connecting GPS...")
time.sleep(6)
print("Data collection start...")
#Flashing
# while True: #Run forever
def flash():
    while True:
        GPIO.output(ledPin, GPIO.HIGH)
        time.sleep(0.25)
          #  print("Going Off")
        GPIO.output(ledPin, GPIO.LOW)
        time.sleep(0.25)
flash()

"""sendToUSSD"""

# This code is correct and all is well.No bugs
import africastalking as at

sms_username = "myTrial"
sms_api_key = "c667670a2a2b2df9812f5421405d1dff0ba12544b502548eef5b2c5b147e5042"
at.initialize(sms_username,sms_api_key)
recepients = recipients = ['+254705583483']

def send_sms():
    sms = at.SMS
    response = sms.send([
        "Air Temperature: 23.08 °C.\
        Water Salinity Condition: NOT_SET.\
        Sensors Location: -1.09392, 37.01833. View Map: https://www.google.com/maps?q=-1.09392,37.01833.\
        System Power Level: 77%.\
        Water conditions: OK!"
     ], recepients)
    print(response)

def send_alerts(alert_boolean_in_fn):
        send_sms()
        global alert_boolean
        alert_boolean = True

# main meat execution    
send_sms()

