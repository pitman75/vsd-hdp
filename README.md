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

   
