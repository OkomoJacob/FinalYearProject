'''1. LSAT Starts here'''
# !/usr/bin/env python
# Import required libraries
from openpyxl import load_workbook #To manipulate spreadsheet
import africastalking as at
from datetime import date
import RPi.GPIO as GPIO
import datetime
import dht11
import time #to delay your LED, LSAT collection timing

#Initialize Africastalking Messaging API
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
print("Connection Secured!")
time.sleep(2.5)
print("Connecting to GPS...")
time.sleep(6)
print("LSAT collection start...")
#Flashing
#while True: #Run forever

# Load data into workbook and select the sheet
wb = load_workbook('/home/pi/testEnv/lsatDb.xlsx')
sheet  = wb['Sheet1']

try:
    while True:
        GPIO.output(ledPin, GPIO.HIGH)
        time.sleep(0.25)
        #  print("Going Off")
        GPIO.output(ledPin, GPIO.LOW)
        time.sleep(0.25)
        
        result = instance.read()
        if result.is_valid():
            lsat = result.temperature
            today = date.today()
            now = datetime.datetime.now().time()
            
            print("Last LSAT Updated: " + str(datetime.datetime.now()))
            print("Lake Surface Air Temp: %-3.1f °C\n" % lsat)
        
            # Append data to sheet
            row = (today, now, lsat)
            sheet.append(row)

            # Save workbook
            wb.save('/home/pi/testEnv/lsatDb.xlsx')
            time.sleep(0.5)
            
        def send_sms():
            sms = at.SMS
            response = sms.send([
                    "LSAT anormally detected!\n \
                    Lake Surf_Air Temp: %-3.1f °C and rising\n Water Salinity: NOT_SET.\
                    Sensors Location: -1.0945, 37.0171.\nView Map: https://www.google.com/maps?q=-1.09392,37.01833.\
                    System Power Level: 79 PerCnt\
                    Water conditions: Needs Inspection!" % lsat
                    ], recepients)
            print(response)
            
        # main meat execution    
        if lsat == 28.6:
            send_sms()    
except KeyboardInterrupt:
    #Confirm save 
    wb.save('/home/pi/testEnv/lsatDb.xlsx')
    print("Safe Exit")
    GPIO.cleanup()
