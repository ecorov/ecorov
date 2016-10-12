#!/bin/bash

sudo apt-get update
sudo apt-get install -y git python-flup lighttpd python-setuptools python-smbus cmake libjpeg8-dev python-dev

## Install raspimjpeg
sudo mkdir -p /var/www/media
sudo mknod /var/www/FIFO p
sudo chmod 666 /var/www/FIFO

sudo cp -r bin/raspimjpeg /opt/vc/bin/
sudo chmod 755 /opt/vc/bin/raspimjpeg
sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg

sudo cp -r etc/raspimjpeg /etc/
sudo chmod 644 /etc/raspimjpeg

sudo mkdir -p /dev/shm/mjpeg
sudo su -c 'raspimjpeg > /dev/null &' 

## Run at start 
sudo cp -r etc/rc.local /etc/
sudo chmod 755 /etc/rc.local

## lighttp & fastcgi
sudo cp -R www/* /var/www/html/
sudo cp etc/lighttpd.conf /etc/lighttpd/lighttpd.conf

if [ ! -e /usr/bin/pythonRoot ]; then
  sudo cp /usr/bin/python2.7 /usr/bin/pythonRoot
  sudo chmod u+s /usr/bin/pythonRoot
fi

sudo chmod 755 -R /var/www/html

# Install RPIO. RPi 3 has problem to instalL RPIO, the solution is using the following repository.
cd; 
git clone https://github.com/withr/RPIO-RPi3.git; 
cd RPIO-RPi3
sudo python setup.py install;

## Install mjpg-streamer
cd; sudo git clone https://github.com/withr/mjpg-streamer.git; 
cd mjpg-streamer; 
sudo make
sudo make install

cd /home/pi/mjpg-streamer
mjpg_streamer -i "input_file.so -d 0.1 -f /dev/shm/mjpeg -n cam.jpg" -o "output_http.so -w ./www -p 8080"&

echo "Install finished!"
 




