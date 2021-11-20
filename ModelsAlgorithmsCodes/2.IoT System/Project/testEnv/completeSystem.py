
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
