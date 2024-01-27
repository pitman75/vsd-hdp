# vsd-hdp
VLSI Hardware Development program. This repository contains the entire flow from the RTL design to GDSII.

## Day 0 - Prepare software
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
     $ sudo apt-get install cmake swig
     $ git clone https://github.com/The-OpenROAD-Project/OpenSTA.git
     $ cd OpenSTA
     $ mkdir build
     $ cd build
     $ cmake ..
     $ make
     $ sudo make install
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

## Day 1 - Introduction to Verilog RTL Design and Synthesis

Introduction to Verilog RTL Design and Synthesis.

RTL design is checked for adherence to spec by simulating the design. The design is a verilog code(or a set of verilog codes) which has the intended functionality to meet the requirements.

Test bench is the setup to apply stimulus (test_vectors) to the design to check its functionality. A testbench may generate VCD file for human eyes checking procedure or use predefined stimulus and results for automatic checking procedure. For complex cases like CPU's test and verification a testbench is a very complex solution.

**Implementation example:**

 * The Design and Test bench are the inputs to the simulator which generates a VCD file (Value Change Dump). This is then processed by GTKWave to obtain the waveform which would enable us to verify the functionality.
 * The verilog design and the library files were cloned from : https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop.git
 * The Design we are using to test is a 2X1 Multiplexer. File name is good_mux.v and test bench is tb_good_mux.v

**Usage:**
```
iverilog design_top_file.v testbench.v
./a.out
gtkwave testbench_output.vcd 
```

**Simple example:**
```
iverilog good_mux.v tb_good_mux.v
./a.out
gtkwave tb_good_mux.vcd
```
![good_mux_testbench](https://github.com/pitman75/vsd-hdp/assets/12179612/fe4a56be-0f3e-46d7-a242-97d378d3b771)

**Yosys Synthesis:**

Yosys transforms RTL verilog source to gate-level netlist and map the netlist to silicon's factory logic primitives library.

**Usage:**
```
$ yosys
yosys> read_liberty -lib ../path_of_library_file/silicon_library.lib
yosys> read_verilog design_top_file.v
yosys> synth -top top_module_name
yosys> abc -liberty ../path_of_library_file/silicon_library.lib
yosys> show
```

For the lab it's:
```
$ yosys
yosys> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> read_verilog good_mux.v
yosys> synth -top good_mux
yosys> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> show
```

**Synthesis to actual design:**

![yosys_god_mux](https://github.com/pitman75/vsd-hdp/assets/12179612/b5632545-fe3a-49aa-a8fd-eb26a4595ff9)

**Netlist Generation:**

Yosys can generate netlist with detailed information about result by command `write_verilog good_mux_netlist.v` it's very usefull for debugging and issues solving. But for now we want to generate netlist without any additional remarks.

```
yosys> write_verilog -noattr good_mux_netlist.v
```

![good_mux_netlist](https://github.com/pitman75/vsd-hdp/assets/12179612/5f7ede79-e65c-4b87-88da-c3fcd6aba7e6)

## Day 2 - Timing libs, hierarchical vs flat synthesis and efficient flop coding styles

Introduction to library file - notation and naming.

 1. What information is seen in a .lib file and how is it written and how to understand this. The .lib (library) file consists of all the information on the electrical behaviour of the std silicon cells used in the Chip design. It includes area, power for various standard cells and delays.
 2. Different flavours are used as per the requirement of operation as in slow, medium or fast.
 3. Combinational logic delay in logic path determines the speed of operation of digital logic circuits.
 4. We have to consider setup time, and hold time and what happens if there are any violations (negative slack).
 5. Difference between faster and slower cells and where to use which one. This selection of specific cells means that there are synthesis constraints.
 6. What is PVT (Process-Voltage-Temperature) and what variations or how the libs will be characterised to model the PVTs.
 7. Hierarchical model and the flat model, differences in synthesis.
 8. Flip-flops and how to utilise.

Read and synthesys _multiple_modules.v_ by default result will be done in hierarhy manner

![multiple_modules_hier](https://github.com/pitman75/vsd-hdp/assets/12179612/b7d18dc0-3dc2-4387-92f0-82e19a9c6405)

![multiple_modules_hier_verilog](https://github.com/pitman75/vsd-hdp/assets/12179612/d0573624-931a-43db-aa95-8f505060dd81)

Sometimes switch synthesys to flat manner is very usefull. To switch to flat manner just do it: 

`yousys> flatten`

![multiple_modules_flat](https://github.com/pitman75/vsd-hdp/assets/12179612/0f91685d-6b0e-4658-8b54-26d0fd28be8b)

![multiple_modules_flat_verilog](https://github.com/pitman75/vsd-hdp/assets/12179612/20b07812-04f5-41d1-a2a2-f33a7c414e8c)

For huge design or design with same as submodules it possible to syntesys only submodules by command: 

`yosys> synth -top submodule_name`

![multiple_modules_subm1](https://github.com/pitman75/vsd-hdp/assets/12179612/935a8189-a113-4046-81ae-e860c693a3aa)

Let's play with some sort of D flip-flops (DFF). There are can be:

 * with asynchronous reset
 * with asynchronous set
 * with synchronous reset
 * other

### DFF with asynchronous reset

**Verilog snippet for this DFF**

```
module dff_asyncres ( input clk ,  input async_reset , input d , output reg q );
always @ (posedge clk , posedge async_reset)
begin
	if(async_reset)
		q <= 1'b0;
	else	
		q <= d;
end
endmodule
```

**Waveform**

![dff_asyncres_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/7af5e499-1ef7-4718-a778-9b61acf2789e)

**Synthesys**

Checking for synthesis, here we would specify the library for the dff using dfflibmap command. In this case, everything is in the same library, there is not much change noticed in the paths. In general workflow is:

```
yosys> read_liberty -lib ../path_of_library_file/library.lib
yosys> read_verilog design_verilog_file.v
yosys> synth -top module_name
yosys> dfflibmap -liberty ../path_of_library_file/library.lib
yosys> abc -liberty ../path_of_library_file/library.lib
yosys> show 
```

For DFF with async reset commands are there:

```
$ yosys
yosys> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> read_verilog dff_asyncres.v
yosys> synth -top dff_asyncres
yosys> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> show
```

![dff_asyncres_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/e21c7e43-7770-404d-b2a4-5ef1e2bbe877)

### DFF with asynchronous set

**Verilog snippet for this DFF**

```
module dff_async_set ( input clk ,  input async_set , input d , output reg q );
always @ (posedge clk , posedge async_set)
begin
	if(async_set)
		q <= 1'b1;
	else	
		q <= d;
end
endmodule
```

**Waveform**

![dff_asyncset_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/2ddc25bd-d0a8-418d-a81d-4e2a430a610f)

**Synthesys**

![dff_asyncset_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/1c4375ea-c6ce-47c0-a838-f3b4bbdd572a)

### DFF with synchronous reset

**Verilog snippet for this DFF**

```
module dff_syncres ( input clk , input async_reset , input sync_reset , input d , output reg q );
always @ (posedge clk )
begin
	if (sync_reset)
		q <= 1'b0;
	else	
		q <= d;
end
endmodule
```

**Waveform**

![dff_syncres_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/d091fbf5-2348-4736-b773-ea783831e47a)

**Synthesys**

![dff_syncres_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/86f07b1a-68ba-429a-8d5f-02ed37cd5a59)

### Optimize logic for special cases

Let's see two special cases with multiplication and how to Yosys syntesis its.

**Multiplication to 2**

**Verilog snippet**

```
module mul2 (input [2:0] a, output [3:0] y);
	assign y = a * 2;
endmodule
```

**Synthesis**

![mult2_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/33a6e74c-7dda-4314-91ca-0f364c6ae58e)

**Verilog after synthesis**

![mult2_net](https://github.com/pitman75/vsd-hdp/assets/12179612/6509c063-c30b-4f4a-80ae-854b12e1328a)

**Multiplication to 9**

**Verilog snippet**

```
module mult8 (input [2:0] a , output [5:0] y);
	assign y = a * 9;
endmodule
```

**Synthesis**

![mult9_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/0e01b1ce-92ed-4a21-be9a-2cc00d149a58)

**Verilog after synthesis**

![mult9_net](https://github.com/pitman75/vsd-hdp/assets/12179612/ade903fe-03e9-4846-bed4-5e4d68736142)

## Day 3 - Combinational and sequential optimizations

1. Area and power savings are achieved when we perform combinational and Sequential optimisations.
2. The combinational optimisations are Constant propagation and Boolean optmisation.
3. The Sequential optimisations are categorised as Basic (Sequential constant propagation) and Advanced (State optimisation, Retiming, Sequential logic cloning). 

### Combinational logic optimizations

**Example 1, sequential logic optimization**

**Verilog snippet**

```
module opt_check (input a , input b , input c , output y1, output y2);
wire a1;
assign y1 = a?b:0;
assign y2 = ~((a1 & b) | c);
assign a1 = 1'b0;
endmodule
```

**Usage**

For logic optomization workflow process must have additional command `opt_clean -purge` i.e. full workflow is:

```
$ yosys
yosys> read_liberty -lib ../path_of_library_file/silicon_library.lib
yosys> read_verilog design_top_file.v
yosys> synth -top top_module_name
yosys> opt_clean -purge
yosys> abc -liberty ../path_of_library_file/silicon_library.lib
yosys> show
```

For the example it's:

```
$ yosys
yosys> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> read_verilog opt_check.v
yosys> synth -top opt_check
yosys> opt_clean -purge
yosys> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> show
```

**Result**

![opt-1](https://github.com/pitman75/vsd-hdp/assets/12179612/0eadd6bb-46bf-41a8-9080-e292dd52a19f)

**Example 2, sequential logic optimization**

**Verilog snippet**

```
module opt_check2 (input a , input b , output y);
	assign y = a?1:b;
endmodule
```

**Result**

![opt-2](https://github.com/pitman75/vsd-hdp/assets/12179612/77747353-fded-466a-8c5f-74fe59e692b0)

**Example 3, sequential logic optimization**

**Verilog snippet**

```
module opt_check3 (input a , input b, input c , output y);
	assign y = a?(c?b:0):0;
endmodule
```

**Result**

![opt-3](https://github.com/pitman75/vsd-hdp/assets/12179612/04dd3e57-e732-43b6-b9e4-1ee6e07a3d67)

**Example 4, sequential logic optimization**

**Verilog snippet**

```
module opt_check4 (input a , input b , input c , output y);
 assign y = a?(b?(a & c ):c):(!c);
endmodule
```

**Result**

![opt-4](https://github.com/pitman75/vsd-hdp/assets/12179612/4796b7ad-0db5-4503-99d4-4820779d3922)

**Logic optimization Verilog RTL with submodules**

For designes with submodules (must of designes) we should add special command for convertion hierarhical design to flat. Because an optimizer can do optimization only inside one module. In this case our workflow extends to:

```
$ yosys
yosys> read_liberty -lib ../path_of_library_file/silicon_library.lib
yosys> read_verilog design_top_file.v
yosys> synth -top top_module_name
yosys> flatten
yosys> opt_clean -purge
yosys> abc -liberty ../path_of_library_file/silicon_library.lib
yosys> show
```

**Example 1, sequential logic optimization with submodules**

**Verilog snippet**

```
module sub_module1(input a , input b , output y);
 assign y = a & b;
endmodule

module sub_module2(input a , input b , output y);
 assign y = a^b;
endmodule

module multiple_module_opt(input a , input b , input c , input d , output y);
wire n1,n2,n3;

sub_module1 U1 (.a(a) , .b(1'b1) , .y(n1));
sub_module2 U2 (.a(n1), .b(1'b0) , .y(n2));
sub_module2 U3 (.a(b), .b(d) , .y(n3));

assign y = c | (b & n1); 

endmodule
```

**Usage**

```
$ yosys
yosys> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> read_verilog multiple_module_opt.v
yosys> synth -top multiple_module_opt
yosys> flatten
yosys> opt_clean -purge
yosys> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> show
```

**Result**

![opt_module-1](https://github.com/pitman75/vsd-hdp/assets/12179612/c9bce227-ca10-47dc-b027-00ba3d2ba6c4)

**Example 2, sequential logic optimization with submodules**

**Verilog snippet**

```
module sub_module(input a , input b , output y);
 assign y = a & b;
endmodule

module multiple_module_opt2(input a , input b , input c , input d , output y);
wire n1,n2,n3;

sub_module U1 (.a(a) , .b(1'b0) , .y(n1));
sub_module U2 (.a(b), .b(c) , .y(n2));
sub_module U3 (.a(n2), .b(d) , .y(n3));
sub_module U4 (.a(n3), .b(n1) , .y(y));

endmodule
```

**Result**

![opt_module-2](https://github.com/pitman75/vsd-hdp/assets/12179612/5c73a5e7-4a92-46d5-99c4-429cdf1d12e1)

### Sequential logic optimizations

Sometimes a verilog RTL code may generate DFF with sequential constant and some of them we may replace to wires with static values. There are some examples with replacement and without.

_Don't forget to use additional command for DFF_

General workflow is:

```
yosys> read_liberty -lib ../path_of_library_file/library.lib
yosys> read_verilog design_verilog_file.v
yosys> synth -top module_name
yosys> dfflibmap -liberty ../path_of_library_file/library.lib
yosys> abc -liberty ../path_of_library_file/library.lib
yosys> show 
```

**Example 1, DFF sequential constant**

**Verilog snippet**

```
module dff_const1(input clk, input reset, output reg q);
always @(posedge clk, posedge reset)
begin
	if(reset)
		q <= 1'b0;
	else
		q <= 1'b1;
end
endmodule
```

**Testbench**

![dff_const1_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/bee91be6-4c05-4f9e-bd35-de833beb35b1)

**Usage**

```
$ yosys
yosys> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> read_verilog dff_const1.v
yosys> synth -top dff_const1
yosys> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> show
```

**Result**

![dff_const1_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/85075b64-d129-48af-8014-1bb5a7d2dbbf)


Why it has DFF? Because 1'b1 rised from 0'b1 only on posedge by clock.

**Example 2, DFF sequential constant**

**Verilog snippet**

```
module dff_const2(input clk, input reset, output reg q);
always @(posedge clk, posedge reset)
begin
	if(reset)
		q <= 1'b1;
	else
		q <= 1'b1;
end
endmodule
```

**Testbench**

![dff_const2_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/bbcddec9-c93f-497a-8a7d-56f0ad5da7e0)

As we see, state of **Q** never changed.

**Result**

![dff_const2_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/d4e30792-d48d-4939-9078-d299ca3b91fe)


**Example 3, DFFs chain sequential constant**

**Verilog snippet**

```
module dff_const3(input clk, input reset, output reg q);
reg q1;

always @(posedge clk, posedge reset)
begin
	if(reset)
	begin
		q <= 1'b1;
		q1 <= 1'b0;
	end
	else
	begin
		q1 <= 1'b1;
		q <= q1;
	end
end
endmodule
```

**Testbench**

![dff_const3_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/4d0b08d5-b2e3-45b7-a7a4-e9701822201c)

**Result**

![dff_const4_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/a9ffa8c8-5ca7-4fc2-8273-9276ea2fac81)

**Example 4, DFFs chain sequential constant**

**Verilog snippet**

```
module dff_const4(input clk, input reset, output reg q);
reg q1;

always @(posedge clk, posedge reset)
begin
	if(reset)
	begin
		q <= 1'b1;
		q1 <= 1'b1;
	end
	else
	begin
		q1 <= 1'b1;
		q <= q1;
	end
end
endmodule
```

**Testbench**

![dff_const4_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/ffc9aa07-8f8b-45a5-86b2-f968e0b16998)

The **q** all time is 1'b1, we can simplify it.

**Result**

![dff_const4_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/4f525fce-fec6-4c65-bc69-1e5a9b84e503)

**Example 5, DFFs chain sequential constant**

**Verilog snippet**

```
module dff_const5(input clk, input reset, output reg q);
reg q1;

always @(posedge clk, posedge reset)
begin
	if(reset)
	begin
		q <= 1'b0;
		q1 <= 1'b0;
	end
	else
	begin
		q1 <= 1'b1;
		q <= q1;
	end
end
endmodule
```

**Testbench**

![dff_const5_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/48a11259-0363-4f8f-afde-e5c1e505c187)

**Result**

![dff_const5_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/883d6b59-6b28-4ce3-9176-0ec7710b4d88)

