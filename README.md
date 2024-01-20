# vsd-hdp
VLSI Hardware Development program. This repository contains the entire flow from the RTL design to GDSII.

## Day 1
 * Create the GitHub repository.
 * Download and install VirtualBox.
 * Download and install Ubuntu 20.04. The VM configured with 8GB of RAM and 70 GB of storage.
   * Update and upgrade the Ubuntu to latest version of program.
     ```
     $ sudo apt-get update
     $ sudo apt-get upgrade
     ```
 * Install Git program `$ sudo apt-get install git`
 * Install Yosys
     ```
     $ git clone https://github.com/YosysHQ/yosys.git
     $ cd yosys
     $ sudo apt install make
     $ sudo apt-get install build-essential clang bison flex \
    libreadline-dev gawk tcl-dev libffi-dev git \
    graphviz xdot pkg-config python3 libboost-system-dev \
    libboost-python-dev libboost-filesystem-dev zlib1g-dev
     $ make config-gcc
     $ make
     $ sudo make install
     ```
  ![Yosys_install](https://github.com/pitman75/vsd-hdp/assets/12179612/7525dcc7-a00c-4932-9f53-110079a0adbf)
  
 * Install iverilog `$ sudo apt-get install iverilog`
  ![iverilog_install](https://github.com/pitman75/vsd-hdp/assets/12179612/934d85c3-262d-436e-b23d-4ce7bac61452)

 * Install GTKWave `$ sudo apt-get install gtkwave`
  ![GTKWave_install](https://github.com/pitman75/vsd-hdp/assets/12179612/aa926e90-c702-4b58-953a-c5f9ad9e1de0)

 * Install OpenSTA
     ```
     $ apt-get install cmake swig
     $ git clone https://github.com/The-OpenROAD-Project/OpenSTA.git
     $ cd OpenSTA
     $ mkdir build
     $ cd build
     $ cmake ..
     $ make
     ```
  ![OpenSTA_install](https://github.com/pitman75/vsd-hdp/assets/12179612/e4aebe41-848f-4de7-8bfa-333daf78f3e3)
  
 * Install NGSpice
     ```
     $ wget -c https://sourceforge.net/projects/ngspice/files/ng-spice-rework/old-releases/37/ngspice-37.tar.gz
     $ tar -xzf ngspice-37.tar.gz
     $ cd ngspice-37
     $ mkdir release
     $ cd release
     $ ../configure  --with-x --with-readline=yes --disable-debug
     $ make
     $ sudo make install
     ```
 * Install Magic
     ```
     $ sudo apt-get install m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev libncurses-dev
     $ git clone https://github.com/RTimothyEdwards/magic
     $ cd magic
     $ ./configure
     $ make
     $ sudo make install
     ```
  ![Magic_install](https://github.com/pitman75/vsd-hdp/assets/12179612/de7367c1-b028-4a45-b590-69cb242de9df)
  
 * Install OpenLANE
     ```
     $ sudo apt install -y build-essential python3 python3-venv python3-pip
     $ sudo apt install apt-transport-https ca-certificates curl software-properties-common
     $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
     $ echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     $ sudo apt-get update
     $ sudo apt install docker-ce docker-ce-cli containerd.io
     $ sudo docker run hello-world
     $ sudo usermod -aG docker $USER
     # After reboot
     $ docker run hello-world
     $ git clone https://github.com/The-OpenROAD-Project/OpenLane
     $ cd OpenLane
     $ make
     $ make test
     ```
![OpenLANE_install](https://github.com/pitman75/vsd-hdp/assets/12179612/1d0a7ef1-50bb-4c19-995e-2780761a74be)
