# python-setuptools contains easy_install which will be used for installing RPIO
# lighttpd is light weight web server
# python-flup is a python library contains FastCGI
# python-dev contain "Python.h"

sudo apt-get install -y git python-setuptools python-flup lighttpd 

# Install RPIO. RPi 3 has problem to instalL RPIO, the solution is using the following repository.
cd; git clone https://github.com/metachris/RPIO.git --branch v2 --single-branch; cd RPIO
sudo python setup.py install; cd; sudo rm -R RPIO;

cd; 
sudo rm -R *;  
sudo wget https://github.com/withr/ecorov/archive/master.zip; 
unzip master.zip; 
sudo chmod 777 -R ecorov-master/;
cd ecorov-master/; 

sudo killall raspimjpeg
sudo rm /var/www/*

sudo cp -r www/* /var/www/
sudo mkdir -p /var/www/media

## pipe for raspimjpeg to read command;
if [ ! -e /var/www/FIFO ]; then
  sudo mknod /var/www/FIFO p
fi
sudo chmod 666 /var/www/FIFO



## raspimjpeg binary program;
sudo cp -r bin/raspimjpeg /opt/vc/bin/
sudo chmod 755 /opt/vc/bin/raspimjpeg
if [ ! -e /usr/bin/raspimjpeg ]; then
  sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg
fi

## raspimjpeg config file;
sudo cp -r etc/raspimjpeg /etc/
sudo chmod 644 /etc/raspimjpeg


## web server and python control files;
sudo cp etc/lighttpd/* /var/www/html
sudo chmod 755 /var/www/html/*
if [ ! -e /usr/bin/pythonRoot ]; then
  sudo cp /usr/bin/python2.7 /usr/bin/pythonRoot
  sudo chmod u+s /usr/bin/pythonRoot
fi
sudo cp etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf


## Automatically start when start RPi;
sudo cp -r etc/rc.local /etc/
sudo chmod 755 /etc/rc.local

## Start raspimjpeg;
sudo mkdir -p /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg
sudo su -c 'raspimjpeg > /dev/null &' 
