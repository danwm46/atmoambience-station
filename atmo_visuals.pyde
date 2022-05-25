################################################################################
# Big thanks to Aaron Penne for much of the math and setup for this program
# check out his work https://github.com/aaronpenne
################################################################################

import datetime
import string
import sys
from random import shuffle, seed
import math

import helper

################################################################################
# Global variables
################################################################################

random_seed = int(random(0, 10000))
random_seed = helper.get_seed(random_seed)
helper.set_seed(random_seed)

# Get time
timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')

# Parameters for draw speed
frame_rate = 30

################################################################################
# Knobs to turn
################################################################################

# Canvas size
w = 1600  # width
h = 900  # height


hu = 173
s = 92
b = 42

a_step = PI/400
angles = helper.range_float(0, TWO_PI+a_step, a_step)

currentLerpValue = 0
lerpStep = .00095

def getRandomColor():
    return color(random(255), random(255), b)

fromColor = getRandomColor()
toColor = getRandomColor()

################################################################################
# setup()
# function gets run once at start of program
################################################################################

def setup():
    # Sets size of canvas in pixels (must be first line)
    size(w, h, P3D)
    #fullScreen(P3D)

    # Sets resolution dynamically (affects resolution of saved image)
    pixelDensity(displayDensity())  # 1 for low, 2 for high

    # Sets color space to Hue Saturation Brightness with max values of HSB respectively
    colorMode(HSB, 360, 100, 100, 100)

    # Set the number of frames per second to display
    frameRate(frame_rate)
    
    background(hu, s, b)
    
    global img
    img = loadImage("Artboard_1.png")
    
    # Stops draw() from running in an infinite loop (should be last line)
    #noLoop()  # Comment to run draw() infinitely (or until 'count' hits limit)


################################################################################
# draw()
# function gets run repeatedly (unless noLoop() called in setup())
################################################################################

def draw():
    
    img.resize(w, h)
    
    # if frameCount == len(angles):
    #     sys.exit()
    count = (frameCount) % len(angles)
        
    camera_x, camera_y = helper.circle_points(w/2, h/2, 400, angles[count])
    camera(camera_x, camera_y, camera_x*1.5, camera_x, camera_y, 0, 0, 1, 0)
        
    currentLerpValue += lerpStep
    currentColor = lerpColor(fromColor, toColor, currentLerpValue)
    if currentLerpValue >= 1:
        global fromColor
        fromColor = currentColor
        global toColor
        toColor = getRandomColor()
        global currentLerpValue
        currentLerpValue = 0
            
    background(currentColor)
        
    background(img)
    
    stroke(0, 0, 0)
    fill_dark = 107

    translate(-500, -500, 950)
    for z in range(0, 13):
        fill_dark -= 8
        fill(0, 0, fill_dark)
        translate(200, 200, -500)
        for x in range(-3*w, 5*w, 2500):
            for y in range(-3*h, 5*h, 2500):
                line((x**2 - cos(y**3)),(y**3 - sin(x**2)), -(x**2 - cos(y**3)), -(y**3 - sin(x**2)))
                line((x**3 - cos(y**2)),(y**2 - sin(x**3)), -(x**3 - cos(y**2)), -(y**2 - sin(x**3)))  
            
    #helper.save_frame_timestamp('grid_lights', timestamp, random_seed)

    # Save memory by closing image, just look at it in the file system
    # if (w > 1000) or (h > 1000):
    #     exit()

################################################################################
# Functions
################################################################################

def mousePressed():
    helper.save_frame_timestamp('grid_lights', timestamp, random_seed)
