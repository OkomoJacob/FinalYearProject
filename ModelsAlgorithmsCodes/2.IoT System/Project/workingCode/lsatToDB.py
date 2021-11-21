'''Populates Excel sheet with Air Temperature data'''
# !/usr/bin/env python
# Import required libraries
from openpyxl import load_workbook #To manipulate spreadsheet
from datetime import date
import RPi.GPIO as GPIO
import datetime 
import dht11
import time

# initialize GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

# read data using GPIO pin 17
instance = dht11.DHT11(pin=17)
print("Connecting to GPS...")
time.sleep(1)

# Load data into workbook and select the sheet
wb = load_workbook('/home/pi/testEnv/lsatDb.xlsx')
sheet  = wb['Sheet1']

try:
    while True:
        result = instance.read()
        if result.is_valid():
            lsat = result.temperature
            today = date.today()
            now = datetime.datetime.now().time()
            print("Last valid Data Updated to DB: " + str(now))
            print("Temperature: %-3.1f C" % result.temperature)

            # Append data to sheet
            row = (today, now, lsat)
            sheet.append(row)

            # Save workbook
            wb.save('/home/pi/testEnv/lsatDb.xlsx')
            time.sleep(0.5)

except KeyboardInterrupt:
    #Confirm save 
    wb.save('/home/pi/testEnv/lsatDb.xlsx')
    print("Safe Exit")
    GPIO.cleanup()

