#!/usr/bin/python
import sys
from sense_hat import SenseHat

sense = SenseHat()
sense.clear()

def set_color(color):
    pixels = [color for _ in range(64)]
    sense.set_pixels(pixels)

red, green, blue = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
set_color([red, green, blue])
