"""
Description: This code demonstrates how to use Raspberry Pi to blink multiple patterns using multiple LEDs.  
"""

from signal import signal, SIGTERM, SIGHUP, pause #
from gpiozero import LED, Button                  #
from threading import Thread                      #For safe running of continuos threading loops
from time import sleep                            #For controling how fast or slow the pattern moves around
from random import randrange                      #To randomly activate and change the patterns(Within the specified range) of blink when button pressed

# 4 Patterns are assigned as Binary digits, (0) off, 1(on)
pattern = (
                [1, 0, 0, 0],
                [1, 1, 0, 0],
                [1, 1, 1, 0],
                [1, 1, 1, 1],
            )
#Assign the LEDs in and index are call them  using their numerical indices
#The numbers in bracket show GPIO pins, check the diagram in the images folder above
leds = (LED(4), LED(17), LED(27), LED(22))
button = Button(16)

is_running = True
delay = 0.1

index = 0
led_in = 3
led_out = 0

def safe_exit(signum, frame):
    exit(1)

"""
Main guy, an infinite loop
"""
def show_pattern():
    while is_running:
        for id in range(4):
            leds[id].value = pattern[index][id]

        token = pattern[index].pop(led_out)
        pattern[index].insert(led_in, token)

        sleep(delay)
"""Change the pattern when the button is pressed"""
def change_direction():
    global led_in, led_out, index
    #Swap the starting and ending LEDS(i.e pattern)
    led_in, led_out = led_out, led_in

    while True: #Avoid repeating a pattern before all patterns are played.
        new_index = randrange(0, len(pattern))
        
        if new_index != index:
            index = new_index
            break
try:

    signal(SIGTERM, safe_exit)
    signal(SIGHUP, safe_exit)

    button.when_pressed = change_direction
    index = randrange(0, len(pattern))

    worker = Thread(target=show_pattern, daemon=True)
    worker.start()

    pause()

except KeyboardInterrupt:
    pass

finally: #stopss the display, or change the pattern
    is_running = False
    sleep(1.5*delay)
    
    # Deactivate the GPIOs as a standard practice.  
    for id in range(4):
        leds[id].close()
