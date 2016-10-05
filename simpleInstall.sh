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


sudo cp -r www/* /var/www/
sudo mkdir -p /var/www/media
sudo chown -R www-data:www-data /var/www


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

# modify "sudo nano /etc/apache2/sites-enabled/000-default.conf ":  "DocumentRoot /var/www "
sudo cp -r etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
sudo /etc/init.d/apache2 restart


sudo cp etc/sudoers.d/RPiROV /etc/sudoers.d/
sudo chmod 440 /etc/sudoers.d/RPiROV

sudo cp -r bin/raspimjpeg /opt/vc/bin/
sudo chmod 755 /opt/vc/bin/raspimjpeg
if [ ! -e /usr/bin/raspimjpeg ]; then
  sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg
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

if [ ! -e /usr/bin/pythonRoot ]; then
  sudo cp /usr/bin/python2.7 /usr/bin/pythonRoot
  sudo chmod u+s /usr/bin/pythonRoot
fi

sudo cp etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf



cat etc/rc_local_run/rc.local.1 > etc/rc_local_run/rc.local
sudo cp -r etc/rc_local_run/rc.local /etc/
sudo chmod 755 /etc/rc.local

sudo usermod -a -G video www-data
if [ -e /var/www/uconfig ]; then
  sudo chown www-data:www-data /var/www/uconfig
fi

## edit /etc/passwd to make www-data available
sudo chsh -s /bin/bash www-data


