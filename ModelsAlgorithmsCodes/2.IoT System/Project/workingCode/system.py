'''
System set to start working immediately on load
'''
import RPi.GPIO as GPIO
import time #to delay your LED

#Set up your pins to use board numbering
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

ledPin = 7 #Use pin 12(GPIO18)
GPIO.setup(ledPin, GPIO.OUT)

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
