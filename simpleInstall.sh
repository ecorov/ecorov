# python-setuptools contains easy_install which will be used for installing RPIO
# lighttpd is light weight web server
# python-flup is a python library contains FastCGI
# python-dev contain "Python.h"

sudo apt-get install -y git python-flup lighttpd 
# Install RPIO. RPi 3 has problem to instalL RPIO, the solution is using the following repository.
cd; git clone https://github.com/metachris/RPIO.git --branch v2 --single-branch; cd RPIO
sudo python setup.py install; cd; sudo rm -R RPIO;

if [ ! -e /usr/bin/pythonRoot ]; then
  sudo cp /usr/bin/python2.7 /usr/bin/pythonRoot
  sudo chmod u+s /usr/bin/pythonRoot
fi
## Install finished. 



## update
sudo cp -r www/* /var/www/
sudo mkdir -p /var/www/media
sudo chown -R www-data:www-data /var/www

sudo cp -r bin/raspimjpeg /usr/bin/
sudo chmod 755 /usr/bin/raspimjpeg
sudo cp -r etc/raspimjpeg /var/www/
sudo chmod 644 /var/www/raspimjpeg

sudo cp -r etc/raspimjpeg /etc/
sudo chmod 644 /etc/raspimjpeg

if [ ! -e /var/www/FIFO ]; then
  sudo mknod /var/www/FIFO p
fi
sudo chmod 666 /var/www/FIFO
if [ ! -e /var/www/FIFO1 ]; then
  sudo mknod /var/www/FIFO1 p
fi
sudo chmod 666 /var/www/FIFO1
if [ ! -e /var/www/cam.jpg ]; then
  sudo ln -sf /dev/shm/mjpeg/cam.jpg /var/www/cam.jpg
fi

sudo mkdir -p /dev/shm/mjpeg
sudo chown www-data:www-data /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg

sudo cp etc/lighttpd/* /var/www/html
sudo chmod 755 -R /var/www/html
sudo cp etc/lighttpd.conf /etc/lighttpd/lighttpd.conf


sudo cp -r etc/rc.local /etc/
sudo chmod 755 /etc/rc.local


sudo chsh -s /bin/bash www-data









sudo cp -r bin/raspimjpeg /opt/vc/bin/
sudo chmod 755 /opt/vc/bin/raspimjpeg
if [ ! -e /usr/bin/raspimjpeg ]; then
  sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg
fi





if [ ! -e /var/www/FIFO ]; then
  sudo mknod /var/www/FIFO p
fi
sudo chmod 666 /var/www/FIFO

if [ ! -e /var/www/FIFO1 ]; then
  sudo mknod /var/www/FIFO1 p
fi
sudo chmod 666 /var/www/FIFO1

if [ ! -e /var/www/cam.jpg ]; then
  sudo ln -sf /run/shm/mjpeg/cam.jpg /var/www/cam.jpg
fi





cat etc/raspimjpeg/raspimjpeg.1 > etc/raspimjpeg/raspimjpeg
sudo cp -r etc/raspimjpeg/raspimjpeg /etc/
sudo chmod 644 /etc/raspimjpeg
if [ ! -e /var/www/raspimjpeg ]; then
  sudo ln -s /etc/raspimjpeg /var/www/raspimjpeg
fi

sudo cp etc/lighttpd/doStuff.py /var/www/html
sudo cp etc/lighttpd/MS5803.py /var/www/html
sudo cp etc/lighttpd/hmc5883l.py /var/www/html

sudo chmod 755 /var/www/html/doStuff.py
sudo chmod 755 /var/www/html/MS5803.py
sudo chmod 755 /var/www/html/hmc5883l.py



sudo cp etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf




sudo usermod -a -G video www-data
if [ -e /var/www/uconfig ]; then
  sudo chown www-data:www-data /var/www/uconfig
fi

## edit /etc/passwd to make www-data available
sudo chsh -s /bin/bash www-data



sudo killall raspimjpeg
sudo killall php
sudo killall motion
sudo mkdir -p /dev/shm/mjpeg
sudo chown www-data:www-data /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg
sleep 1;sudo su -c 'raspimjpeg > /dev/null &' www-data
sleep 1;sudo su -c 'php /var/www/schedule.php > /dev/null &' www-data
sudo /etc/init.d/lighttpd restart
echo "Started"

