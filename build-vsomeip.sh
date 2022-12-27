apt-get update -y
apt-get install -y --no-install-recommends \
  sudo curl wget apt-transport-https gnupg \
  ca-certificates cmake\
  gcc build-essential git vim unzip openssh-server
sudo apt-get upgrade

# apt
sudo apt update -y
sudo apt upgrade -y


# ----------------------------
# Setup vsomeip
# ----------------------------

mkdir ~/dev

# Boost
sudo apt install libboost-all-dev -y

# libsystemd
sudo apt-get install libudev-dev libsystemd-dev -y

# Doxygen
sudo apt-get install doxygen -y

# graphviz
sudo apt install graphviz -y

# asciidoc
#RUN sudo apt install asciidoc -y

# RUN sudo chown ${username} ~ -R
# RUN sudo chmod 777 ~
# RUN sudo chmod 777 ~/dev

# dlt-daemon
cd ~/dev
git clone https://github.com/COVESA/dlt-daemon -b v2.18.8
cd ~/dev/dlt-daemon
mkdir build
cd ~/dev/dlt-daemon/build
cmake ..
make
sudo make install
sudo ldconfig



# vsomeip
cd ~/dev
git clone https://github.com/COVESA/vsomeip -b 3.1.20.3
cd ~/dev/vsomeip
mkdir build
cd ~/dev/vsomeip/build
cmake ..
make
sudo make install
sudo ldconfig


# vsomeip hello_world
cd ~/dev/vsomeip/build
cmake --build . --target hello_world && \
    cd ./examples/hello_world  && \
    make  
cd ~/dev/vsomeip/build/examples/hello_world

cp ../../../examples/hello_world/helloworld-local.json ../


VSOMEIP_CONFIGURATION=../helloworld-local.json \
    VSOMEIP_APPLICATION_NAME=hello_world_service \
    ./hello_world_service

VSOMEIP_CONFIGURATION=../helloworld-local.json \
     VSOMEIP_APPLICATION_NAME=hello_world_client \
     ./hello_world_client

