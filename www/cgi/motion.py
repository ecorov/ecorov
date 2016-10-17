import os, time
from subprocess import call
 
thresh = 100


while True:
    state = open("/var/www/status_mjpeg.txt", 'r').read()
    while (state == "md_ready"):
        s1 = os.path.getsize("/dev/shm/mjpeg/cam.jpg")
        time.sleep(.1)
        s2 = os.path.getsize("/dev/shm/mjpeg/cam.jpg")
        if (abs(s1-s2) > thresh):
            call(" echo 'ca 1' >/var/www/FIFO", shell=True)
            print "ca 0"
        else:
            time.sleep(.1)
            s1 = os.path.getsize("/dev/shm/mjpeg/cam.jpg")
            time.sleep(.1)
            s2 = os.path.getsize("/dev/shm/mjpeg/cam.jpg")
            if (abs(s1-s2) < thresh):
                call(" echo 'ca 0' >/var/www/FIFO", shell=True)
                print "ca 0"
    time.sleep(1)
    print "pass"
