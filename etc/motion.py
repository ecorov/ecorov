import os, time 


thresh = 100
waittime = 1

s1 = os.path.getsize("/dev/shm/mjpeg/cam.jpg")
time.sleep(.1)
s2 = os.path.getsize("/dev/shm/mjpeg/cam.jpg")
time.sleep(.1)

if (abs(s1-s2) > thresh) {
  
} else {
  time.sleep(waittime)
}
