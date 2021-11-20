#Working code
import RPi.GPIO as GPIO
import time #to delay your LED

#Set up your pins to use board numbering
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

ledPin = 7 #Use pin 12(GPIO18)
GPIO.setup(ledPin, GPIO.OUT)

""""""
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
