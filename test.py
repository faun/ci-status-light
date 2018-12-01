#!/usr/bin/env python

from blinkt import set_pixel, set_brightness, show, clear

import time

clear()

set_pixel(1, 0, 255, 0)

show()

time.sleep(1)
