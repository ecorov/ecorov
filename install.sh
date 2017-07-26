#!/bin/bash

sudo apt-get install -y python-flup lighttpd python-setuptools python-smbus cmake libjpeg8-dev python-dev

## Install raspimjpeg
sudo mkdir -p /var/www/media

if [ ! -e /var/www/FIFO ]; then
  sudo mknod /var/www/FIFO p
fi
sudo chmod 666 /var/www/FIFO

sudo cp -r bin/raspimjpeg /opt/vc/bin/
sudo chmod 755 /opt/vc/bin/raspimjpeg
if [ ! -e /usr/bin/raspimjpeg ]; then
  sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg
fi

sudo cp -r etc/raspimjpeg /etc/
sudo chmod 644 /etc/raspimjpeg

sudo killall raspimjpeg
sudo mkdir -p /dev/shm/mjpeg
sudo su -c 'raspimjpeg > /dev/null &' 

## Run at start 
sudo cp -r etc/rc.local /etc/
sudo chmod 755 /etc/rc.local

## lighttp & fastcgi
sudo cp -R www/* /var/www/html/
sudo cp -r etc/lighttpd.conf /etc/lighttpd/lighttpd.conf

if [ ! -e /usr/bin/pythonRoot ]; then
  sudo cp /usr/bin/python2.7 /usr/bin/pythonRoot
  sudo chmod u+s /usr/bin/pythonRoot
fi

sudo chmod 755 -R /var/www/html

# Install RPIO. RPi 3 has problem to instalL RPIO, the solution is using the following repository.
cd; 
if [ -d RPIO-RPi3 ]; then
  sudo rm -R RPIO-RPi3
fi
git clone https://github.com/ecorov/RPIO-RPi3.git; 
cd RPIO-RPi3
sudo python setup.py install;

## Install mjpg-streamer
cd; 
if [ -d mjpg-streamer ]; then
  sudo rm -R mjpg-streamer
fi
sudo git clone https://github.com/ecorov/mjpg-streamer.git; 
cd mjpg-streamer; 
sudo make
sudo make install

if [ ! -e /usr/bin/mjpg-streamer ]; then
  sudo ln -s mjpg-streamer /usr/bin/mjpg-streamer
fi

cd /home/pi/mjpg-streamer
mjpg_streamer -i "input_file.so -d 0.05 -f /dev/shm/mjpeg -n cam.jpg" -o "output_http.so -w ./www -p 8080"&

echo "Install finished!"
 




