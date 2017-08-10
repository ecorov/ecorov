Step 1: Burn image raspbian-jessie-lite (2017-05-05) into RPi. Create a file called "ssh" under "/boot" folder, and add " ip=192.168.8.8" to "cmdline.txt" under "/boot" folder.


Step 2: Access to RPi using SSH, and enable it to access internet, then update the system.


Step 3: Enable camera module, I2C interface, and expand filesystem to whole disk, then restart RPi. "sudo raspi-config"


Step 4: Install git, the clone this repository. 

sudo apt-get install -y git

git clone https://github.com/ecorov/ecorov.git


Step 5: run "install.sh" to install ecorov
sudo chmod 755 ecorov/install.sh
ecorov/install.sh


Restart the RPi to make sure everything works. 

sudo reboot