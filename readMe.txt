cd;
sudo rm -R ecorov-master;  
sudo wget https://github.com/withr/ecorov/archive/master.zip; 
unzip master.zip; 

sudo chmod 777 -R ecorov-master/;
cd ecorov-master/; 







Steps:
 1. After burning Rasbian image into RPi's Micro SD card, enable the camera module and extent storage.
sudo raspi-config


Test: 
 cd; 
 sudo rm -R *;  
 sudo wget https://github.com/withr/RPiROV/archive/master.zip; 
 unzip master.zip; 
 sudo chmod 777 -R RPiROV-master/;
 cd RPiROV-master/; 
 ./simpleInstall.sh
 
 
 



 
 Git clone https://github.com/withr/RPiROV.git
git config remote.origin.url git@github.com:withr/RPiROV.git


