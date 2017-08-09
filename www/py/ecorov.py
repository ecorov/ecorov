#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, time, urlparse, smbus, math, threading, struct
from shutil import copyfile
from flup.server.fcgi import WSGIServer 
from MS5803  import MS5803
from BMP280  import BMP280
from MPU9250 import MPU9250


import RPi.GPIO as GPIO 
GPIO.setmode(GPIO.BCM)

## Define pins for devices
## Step motor
pinStp = 21
pinDir = 20
pinSlp = 26
## LED light
pinRlyLED = 19
## Brushless motors
pinLft = 27
pinRgt = 22
## 4-channels Relay
pinRlyLft1 = 12
pinRlyLft2 = 13
pinRlyRgt1 = 5
pinRlyRgt2 = 6
## Water sensor
pinWater = 4


## Initialize step motor
GPIO.setup (pinStp, GPIO.OUT)
GPIO.setup (pinDir, GPIO.OUT)
GPIO.setup (pinSlp, GPIO.OUT)
GPIO.output(pinSlp, False)
## Function for step motor
def stepMotor(step):
    GPIO.output(pinSlp, True)
    time.sleep(0.1)
    # Direction
    if step < 0:
        GPIO.output(pinDir, False)
    else:
        GPIO.output(pinDir, True)
    # step
    for i in range(1, int(abs(step) * 1.8 *100)):
        GPIO.output(pinStp, True)
        GPIO.output(pinStp, False)
        time.sleep(0.0001)
    GPIO.output(pinSlp, False)
    return

    
## Test LED 
GPIO.setup(pinRlyLED, GPIO.OUT)
time.sleep(1)
GPIO.cleanup(pinRlyLED)
GPIO.setup(pinRlyLED, GPIO.OUT)
time.sleep(1)
GPIO.cleanup(pinRlyLED)


## Initialize brushless motor
GPIO.setup(pinLft, GPIO.OUT)
GPIO.setup(pinRgt, GPIO.OUT)
propLft = GPIO.PWM(pinLft, 500)
propRgt = GPIO.PWM(pinRgt, 500)
propLft.start(50)
time.sleep(1.0)
propRgt.start(50)
time.sleep(1.0)



def app(environ, start_response):
    start_response("200 OK", [("Content-Type", "text/html")])
    i = urlparse.parse_qs(environ["QUERY_STRING"])
    yield ('&nbsp;') 
    #  url = "stp=-300&stp=50&lft=1050&rgt=1100&led=off"
    if "stp" in i:
        stepMotor(int(i["stp"][0]))    
    if "lft" in i:
    	spd = int(i["lft"][0])
    	if spd < -1020:
    	    GPIO.setup(pinRlyLft1, GPIO.OUT)
    	    GPIO.setup(pinRlyLft2, GPIO.OUT)
            time.sleep(0.1)
    	propLft.ChangeDutyCycle(abs(spd)/20)
    if "rgt" in i:
    	spd = int(i["rgt"][0])
    	if spd < -1020:
    	    GPIO.setup(pinRlyRgt1, GPIO.OUT)
    	    GPIO.setup(pinRlyRgt2, GPIO.OUT)
            time.sleep(0.1)
    	propRgt.ChangeDutyCycle(abs(spd)/20)
    if "led" in i:
        if i["led"][0] == "on":
            GPIO.setup(pinRlyLED, GPIO.OUT)
        else:
            GPIO.cleanup(pinRlyLED)

WSGIServer(app).run()

GPIO.cleanup()


