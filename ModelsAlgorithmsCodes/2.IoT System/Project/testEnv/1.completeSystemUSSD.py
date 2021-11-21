'''1. LSAT Starts here'''
import africastalking as at
import RPi.GPIO as GPIO
import datetime
import dht11
import time #To delay your LED, LSAT collection timing

#Initialize Africastalking
sms_username = "myTrial"
sms_api_key = "c667670a2a2b2df9812f5421405d1dff0ba12544b502548eef5b2c5b147e5042"
at.initialize(sms_username,sms_api_key)
recepients = recipients = ['+254705583483']

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

# main meat execution    
try:
    while True:
        GPIO.output(ledPin, GPIO.HIGH)
        time.sleep(0.25)
        #  print("Going Off")
        GPIO.output(ledPin, GPIO.LOW)
        time.sleep(0.25)
        
        result = instance.read()
        lsat = result.temperature
        if result.is_valid():
            print("Last valid input: " + str(datetime.datetime.now()))
            print("LSAT: %-3.1f °C\n" % lsat)
            
        def send_sms():
            sms = at.SMS
            response = sms.send("Tm f'{lsat} C", recepients)
            print(response)
            
        # main meat execution    
        if lsat >= 30:
            send_sms()
            
except KeyboardInterrupt:
    print("Cleanup")
    GPIO.cleanup()
