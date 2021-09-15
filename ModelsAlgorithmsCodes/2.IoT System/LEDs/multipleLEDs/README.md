### Explanation of the Code
The python file is called `4LEDs,py` and it is located in this directory

This is a step by step explanation of how the code works
#### Built With
- Raspberry PI
- Jumper wires
- 4 LEDs
- Breadboard(Optional though very recommended)

`from gpiozero import LED`

The first line tells the Python interpreter (the thing that runs the Python code) that it will be using a ‘library’ that will tell it how to work with the LED to toggle the 4 leds on and off

`import time`

The [time python library](https://pypi.org/project/time/) is used when doing anythin time-dependant.
e.g turn our LED after some time then off after some time again, on and off, timely.

`GPIO.setmode(GPIO.BCM)`

Each GPIO pin on the Raspberry Pi has several different names, so set mode to tell the program which naming convention is to be used.Here we're using the [GPIO.BCM](https://raspi.tv/2013/rpi-gpio-basics-4-setting-up-rpi-gpio-numbering-systems-and-inputs)

`led.on()`

This turns the GPIO pin ‘on’. What this actually means is that the pin is made to provide power of 3.3volts.  This is enough to turn the LED in our circuit on.

`time.sleep(time)`

Pauses the Python program for 1 second


`led.off()`

This turns the GPIO pin ‘off’. 
- What this actually means is that the pin is made to provide power of 3.3volts.
- This is enough to turn the LED in our circuit on.


This turns the GPIO pin ‘off’, meaning that the pin is no longer supplying any power.
