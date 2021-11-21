'''
Checks if connection is secure and notifies via blinking LED
'''
import RPi.GPIO as GPIO
import time #to delay your LED

#Set up your pins to use GPIO numbering
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

ledPin = 4 #Use pin 7(GPIO 4)
GPIO.setup(ledPin, GPIO.OUT)

print("Connection Secure")
time.sleep(2.5)
print("Connecting GPS...")
time.sleep(6)
print("Data Ccollection Indicator Started...")
#Flashing
# while True: #Run forever
try:
    while True:
        GPIO.output(ledPin, GPIO.HIGH)
        time.sleep(0.25)
          #  print("Going Off")
        GPIO.output(ledPin, GPIO.LOW)
        time.sleep(0.25)

except KeyboardInterrupt:
    #Safe Exit
    print("Safe Exit")
    GPIO.cleanup()