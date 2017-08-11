#!/usr/bin/python
# -*- coding: utf-8 -*-

## Basic libraries
import sys, time, math, struct


##############################
## PWM signal
from RPIO import PWM 
PWM.set_loglevel(PWM.LOG_LEVEL_ERRORS)
pwm = PWM.Servo(pulse_incr_us=1)
## Brushless motors
pinPropLft = 27
pinPropRgt = 22
## Relay signal input
pinRlyLft1 = 12
pinRlyLft2 = 13
pinRlyRgt1 = 5
pinRlyRgt2 = 6
## Initialize
pwm.set_servo(pinPropLft, 1000)
time.sleep(1)
pwm.set_servo(pinPropRgt, 1000)
time.sleep(1)

  

##############################
## Step motor
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
## pins
pinStp = 21
pinDir = 20
pinSlp = 26
#3 setup pin as out & initialize as low level 
GPIO.setup(pinStp, GPIO.OUT, initial=0)
GPIO.setup(pinDir, GPIO.OUT, initial=0)
GPIO.setup(pinSlp, GPIO.OUT, initial=0)
## Function for step motor
def stepMotor(step):
    GPIO.output(pinSlp, 1) ## wakeup
    time.sleep(0.1)
    # Direction
    if step < 0:
        GPIO.output(pinDir, 0)
    else:
        GPIO.output(pinDir, 1)
    # step
    for i in range(1, int(abs(step) * 1.8 *100)):
        GPIO.output(pinStp, 1)
        GPIO.output(pinStp, 0)
        time.sleep(0.0001)
    GPIO.output(pinSlp, 0) ## sleep
    return


#############################
## LED light
pinLED = 19
GPIO.setup(pinLED, GPIO.OUT, initial=1) ## Low level will trigger the relay   
GPIO.output(pinLED, 0)
time.sleep(1)
GPIO.output(pinLED, 1)
    
    

##############################
## For reading sensor data
import time, threading, smbus, ctypes
from shutil import copyfile
from MS5803  import MS5803
from BMP280  import BMP280
from MPU9250 import MPU9250

## BMP280
def readBMP280():
    thread = threading.currentThread() 
    bmp280 = BMP280()
    while getattr(thread, "do_run", True):
        thread.data =  bmp280.readAll()
        thread.mbar = thread.data['mbar']
        thread.temp = thread.data['temp']
        with open("/var/www/js/sensor_rov_pres.html", "w") as f:
            f.write("ROV pressure: " + str(int(thread.mbar)))
            f.close()
        with open("/var/www/js/sensor_rov_temp.html", "w") as f:
            f.write("ROV temperature: " + str(int(thread.temp)))
            f.close()
        time.sleep(0.5)

tReadBMP280 = threading.Thread(target=readBMP280)
tReadBMP280.start()
# tReadBMP280.do_run = False

# MPU9250
def readMPU9250():
    thread = threading.currentThread() 
    mpu9250 = MPU9250()
    while getattr(thread, "do_run", True):
        thread.data =  mpu9250.readMagnet()
        with open("/var/www/js/sensor_rov_heading.html", "w") as f:
            f.write("ROV heading: " + str(int(thread.data)))
            f.close()
        time.sleep(0.5)

tReadMPU9250 = threading.Thread(target=readMPU9250)
tReadMPU9250.start()
# tReadMPU9250.do_run = False

# MS5803
def readMS5803():
    thread = threading.currentThread()   
    ms5803 = MS5803() 
    while getattr(thread, "do_run", True):
        thread.data = ms5803.read()
        thread.mbar = thread.data['mbar']
        thread.temp = thread.data['temp']
        with open("/var/www/js/sensor_water_pres.html", "w") as f:
            f.write("Water pressure: " + str(int(thread.mbar)))
            f.close()
        with open("/var/www/js/sensor_water_temp.html", "w") as f:
            f.write("Water temperature: " + str(int(thread.temp)))
            f.close()
        time.sleep(0.5)

tReadMS5803 = threading.Thread(target=readMS5803)
tReadMS5803.start()
# tReadMS5803.do_run = False



#####################################
## Define camera control functions
def camera(cmd):
    with open("/var/www/FIFO", "w") as f:
        f.write(cmd)
        f.close()

        
########################################
## fastcgi-python server
from flup.server.fcgi import WSGIServer 
import urlparse
## app
def app(environ, start_response):
  start_response("200 OK", [("Content-Type", "text/html")])
  Q = urlparse.parse_qs(environ["QUERY_STRING"])
  yield ('&nbsp;') # flup expects a string to be returned from this function
  if "cam" in Q:
    camera(Q["cam"][0])

WSGIServer(app).run()
