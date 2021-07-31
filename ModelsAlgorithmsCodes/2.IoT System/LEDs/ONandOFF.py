import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(18,GPIO.OUT)
# Line 8 and 11 not compulsory

print "LED on"
GPIO.output(18,GPIO.HIGH)   #Turn LED on
time.sleep(1)
print "LED off"
GPIO.output(18,GPIO.LOW)    #Turn LED off