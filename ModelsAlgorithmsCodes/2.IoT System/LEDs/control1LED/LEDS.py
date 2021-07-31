from gpiozero import LED
blue = LED(4)
i = 6
if i > 5:
    blue.on()
    pass