
sudo apt-get update
sudo apt-get install -y git 

cd; [ -d ecorov ] && sudo rm -R ecorov
sudo git clone https://github.com/withr/ecorov.git; 
sudo chmod 755 -R ecorov/; cd ecorov; ./install.sh
 
 
 

Run above commands to install rov frame work.
