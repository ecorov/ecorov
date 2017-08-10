#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, time, math, struct, threading, urlparse, smbus 

from flup.server.fcgi import WSGIServer 
from MS5803  import MS5803
from BMP280  import BMP280
from MPU9250 import MPU9250


## Define camera control functions
def camera(cmd):
    with open("/var/www/FIFO", "w") as f:
        f.write("cmd")
        f.close()


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



## Define camera control functions
def camera(cmd):
    with open("/var/www/FIFO", "w") as f:
        f.write(cmd)
        f.close()

def app(environ, start_response):
  start_response("200 OK", [("Content-Type", "text/html")])
  Q = urlparse.parse_qs(environ["QUERY_STRING"])
  yield ('&nbsp;') # flup expects a string to be returned from this function
  if "cam" in Q:
    camera(Q["cam"][0])

WSGIServer(app).run()