#!/bin/bash
cd;

## Install lighttpd web-server and flup
sudo apt-get install -y lighttpd python-flup python-smbus 
# use new configure file
sudo cp ecorov/etc/lighttpd.conf /etc/lighttpd/lighttpd.conf
# Delet the default server document 
sudo rm -R /var/www/html
# Copy new web-server related documents together with Python scripts 
sudo cp -r ecorov/www/* /var/www/
sudo chmod 755 /var/www/py/ecorov.py


##Install RPIO from source.
git clone https://github.com/ecorov/RPIO-RPi3.git; 
cd RPIO-RPi3
sudo apt-get install -y python-dev python-setuptools
sudo python setup.py install;
cd;

# Copy raspimjpeg and make it available for system path.
sudo cp ecorov/bin/raspimjpeg /opt/vc/bin/raspimjpeg 
sudo chmod 755 /opt/vc/bin/raspimjpeg
sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg
# Copy the configure file for raspimjpeg
sudo cp ecorov/etc/raspimjpeg /etc/raspimjpeg 
sudo chmod 644 /etc/raspimjpeg
# raspimjpeg need a FIFO: First In First Out
sudo mkdir -p /var/www/media 
sudo mknod /var/www/FIFO p
sudo chmod 666 /var/www/FIFO
# Creat a folder in memory (so more efficient) for store the recorded images.
sudo mkdir -p /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg
# start recording 
sudo su -c 'raspimjpeg > /dev/null &' 
# You should see the led of camera start to light. 
# To stop raspimjpeg, using command "sudo killall raspimjpeg"


# The following libraries needed for compilation of mjpg-streamer
sudo apt-get install -y cmake libjpeg8-dev
# Download and compile mjpg-streamer
sudo git clone https://github.com/ecorov/mjpg-streamer.git
cd mjpg-streamer; 
# Start to compile
sudo make && sudo make install
# Create a soft link, to enable system to call mjpg-streamer
sudo ln -s mjpg-streamer/mjpg-streamer /usr/bin/mjpg-streamer
# Start streaming
mjpg_streamer -i "input_file.so -d 0.05 -f /dev/shm/mjpeg -n cam.jpg" -o "output_http.so -w ./www -p 8080"&
cd;

## Enable to start recoding and streaming, etc. when start RPi.
sudo cp ecorov/etc/rc.local /etc/rc.local
sudo chmod 755 /etc/rc.local

## Change mode of Python to enable it run script as root.
sudo chmod u+s /usr/bin/python
  
# Restart lighttpd server
sudo /etc/init.d/lighttpd restart
