#!/usr/bin/env python
import sys
import time
import random
import yaml
from sense_hat import SenseHat
import numpy as np
from download_worker import DownloadWorker

sense = SenseHat()
sense.clear()

config = yaml.load(open('config.yml'))
api_token = str(config['BUILDKITE_API_KEY'])

msleep = lambda x: time.sleep(x / 1000.0)

def random_pixels():
    return [random_color() for _ in range(64)]

def random_color():
    return [random.randint(0, 255) for _ in range(3)]

def crazy_colors(pixels):
    pixels = pixels[7:-1]
    for _ in range(8):
        pixels.append(random_color())
    set_colors(pixels)

def pad_colors(colors):
    length = len(colors)
    if (length is 64):
        return colors
    else:
        npad = 64 - len(colors)
        empty_pixels = [black() for _ in range(npad)]
        padded = empty_pixels + colors
        return padded

def set_colors(colors):
    sense.set_pixels(pad_colors(colors))
    return True

def red():
    return (255, 0, 0)

def green():
    return (0, 255, 0)

def blue():
    return (0, 0, 255)

def yellow():
    return (255, 255, 0)

def white():
    return (255, 255, 255)

def black():
    return (0, 0, 0)

def brown():
    return (165, 42, 42)

def purple():
    return (128, 0, 128)

def pink():
    return (255, 192, 203)

def orange():
    return (255, 125, 61)

def grey():
    return (50, 50, 50)

def state_to_color(color):
    return {
        'passed': green(),
        'canceled': yellow(),
        'failed': red(),
        'running': white(),
        'scheduled': pink(),
        'blocked': purple(),
        'canceling': orange(),
        'skipped': brown(),
        'not_run': black(),
        'finished': grey(),
    }[color]

def translate_build_state_colors(build_states):
    return [state_to_color(color) for color in build_states]

def reset_colors():
    colors = [[0 for _ in range(3)] for _ in range(64)]
    set_colors(colors)
    return True

def main(Loading):
    urls = config['urls'][:8]
    worker = DownloadWorker(api_token)

    colors = []
    for url in urls:
        print('Queueing {}'.format(url))
        if Loading:
            crazy_colors(random_pixels()) 
        states = worker.fetch_first_eight_build_states(url)
        print('States: {}'.format(states))
        colors = translate_build_state_colors(states) + colors
        print('Done')
        msleep(200)
    set_colors(colors)
    msleep(30000)
    main(False)
    print('DONE')

if __name__ == "__main__":
    try:
        main(True)

    except KeyboardInterrupt:
        reset_colors()
        sys.exit(0)

    except OSError:
        e = sys.exc_info()[0]
        print("Quitting... {}".format(e))
        reset_colors()
        sys.exit(1)
