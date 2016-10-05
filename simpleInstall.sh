# python-setuptools contains easy_install which will be used for installing RPIO
# lighttpd is light weight web server
# python-flup is a python library contains FastCGI
# python-dev contain "Python.h"

sudo apt-get install -y git python-flup lighttpd 
# Install RPIO. RPi 3 has problem to instalL RPIO, the solution is using the following repository.
cd; git clone https://github.com/metachris/RPIO.git --branch v2 --single-branch; cd RPIO
sudo python setup.py install; cd; sudo rm -R RPIO;

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

# sudo cp etc/sudoers.d/RPiROV /etc/sudoers.d/
# sudo chmod 440 /etc/sudoers.d/RPiROV

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
sudo cp etc/lighttpd/* /var/www/html
sudo chmod 755 /var/www/html/*


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



sudo killall raspimjpeg
sudo mkdir -p /dev/shm/mjpeg
sudo chown www-data:www-data /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg
sleep 1;sudo su -c 'raspimjpeg > /dev/null &' www-data
sleep 1;sudo su -c 'php /var/www/schedule.php > /dev/null &' www-data


sudo /etc/init.d/lighttpd restart
echo "Started"
