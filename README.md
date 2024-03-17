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

![dff_const3_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/3f1364cf-c978-4ee1-8c36-426a63f504f9)


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

### Sequential optimization for unused outputs

Sometimes we don't use all features of a verilog module. In this case an optimizer will remove unused part for safe space and power.

**Example 1, sequential unused outputs**

**Verilog snippet**

```
module counter_opt (input clk , input en, input reset , output q);
reg [3:0] count;
assign q = count[0];

always @(posedge clk ,posedge reset)
begin
	if(reset)
		count <= 4'b0000;
	else if(en)
		count <= count + 1;
end
endmodule
```

In the example only 1 bit of 4 used. We can optimize it. Let's see.

**Optimization Result**

![counter_opt](https://github.com/pitman75/vsd-hdp/assets/12179612/70705d07-b62f-4daa-908e-12123c3bd3a2)

An optimizer removed 3 DFFs and keep only one.

**Example 2, sequential unused outputs**

**Verilog snippet**

```
module counter_opt2 (input clk , input reset , output q);
reg [2:0] count;
assign q = (count[2:0] == 3'b100);

always @(posedge clk ,posedge reset)
begin
	if(reset)
		count <= 3'b000;
	else
		count <= count + 1;
end
endmodule
```

In the example all bits used. Let's see is it possible to optimize or not.

**Optimization Result**

![counter_opt2](https://github.com/pitman75/vsd-hdp/assets/12179612/2e8557ca-ec94-4d7c-b5a6-4b17d07e8bbc)

An optimizer keep all DFFs, no possible to remove anything.

## Day 4 - GLS, blocking vs non-blocking and Synthesis-Simulation mismatch

Main idea of the GLS is use the same testbench as for RTL simulation to evaluate behavior a verilog netlist under stimulus and compare that it's the same. Why it happens:

1. Errors in verilog code
2. Bad verilog style

**Example 1, ternary mux**

**Verilog snippet**

```
module ternary_operator_mux (input i0 , input i1 , input sel , output y);
    assign y = sel?i1:i0;
endmodule
```

**Testbench**

![ternary_mux_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/4bcc7f68-e466-40f2-a0f8-75e7908a426b)

**Internal structure**

![ternary_mux_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/45e1799b-852d-4320-9f37-73bc7b91446b)


**Netlist output**

```
/* Generated by Yosys 0.37+21 (git sha1 8649e3066, gcc 9.4.0-1ubuntu1~20.04.2 -fPIC -Os) */

module ternary_operator_mux(i0, i1, sel, y);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  input i0;
  wire i0;
  input i1;
  wire i1;
  input sel;
  wire sel;
  output y;
  wire y;
  sky130_fd_sc_hd__mux2_1 _4_ (
    .A0(_0_),
    .A1(_1_),
    .S(_2_),
    .X(_3_)
  );
  assign _0_ = i0;
  assign _1_ = i1;
  assign _2_ = sel;
  assign y = _3_;
endmodule
```

**GLS Simulation**

Syntax:
```
iverilog <verilog_model_path: ../mylib/verilog_model/primitives.v> <library_file_path: ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib> <netlist_file: module_netlist.v> <Testbench_file: tb_module.v>
./a.out
gtkwave tb_module.vcd
```

And for this example it's:

```
iverilog ../../my_lib/verilog_model/primitives.v ../../my_lib/verilog_model/sky130_fd_sc_hd.v ternary_operator_mux_net.v tb_ternary_operator_mux.v
```

**Testbench**

![ternary_mux_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/f5d432a3-23f3-4620-8b26-74c9d8de30e8)

**Comparison**

![ternary_mux_compare](https://github.com/pitman75/vsd-hdp/assets/12179612/68e6bad1-8fb3-4b27-b27b-8337a7b78892)

All right. Verilog RTL and Verilog netlist based on standart cells have same as behavior.

**Example 2, bad mux**

**Verilog snippet**

```
module bad_mux (input i0 , input i1 , input sel , output reg y);
always @ (sel)
begin
	if(sel)
		y <= i1;
	else 
		y <= i0;
end
endmodule
```

**Testbench**

![bad_mux_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/1a3b1929-9035-4b16-b4f5-94aafeaa8377)

**Internal structure**

![bad_mux_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/fdabb602-dd4b-4ceb-8329-4a479da121a6)

**Netlist output**

```
/* Generated by Yosys 0.37+21 (git sha1 8649e3066, gcc 9.4.0-1ubuntu1~20.04.2 -fPIC -Os) */

module bad_mux(i0, i1, sel, y);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  input i0;
  wire i0;
  input i1;
  wire i1;
  input sel;
  wire sel;
  output y;
  wire y;
  sky130_fd_sc_hd__mux2_1 _4_ (
    .A0(_0_),
    .A1(_1_),
    .S(_2_),
    .X(_3_)
  );
  assign _0_ = i0;
  assign _1_ = i1;
  assign _2_ = sel;
  assign y = _3_;
endmodule
```

**Testbench**

![bad_mux_netlist_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/23849d91-da9f-49ee-b8ea-958ca9d61ea4)

**Comparison**

![bad_mux_compare](https://github.com/pitman75/vsd-hdp/assets/12179612/028f5c56-2f65-4fb3-8c0d-367d2a4f9b08)

Mismatch behavior found. Rewrite Verilog RTL to fix it.

**Example 3, blocking statements**

**Verilog snippet**

```
module blocking_caveat (input a , input b , input  c, output reg d); 
reg x;
always @ (*)
begin
	d = x & c;
	x = a | b;
end
endmodule
```

**Testbench**

![blocking_caveat_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/0c1bdc95-cce2-4b09-91c6-ac24ec6ec469)

**Internal structure**

![blocking_caveat_struct](https://github.com/pitman75/vsd-hdp/assets/12179612/1cbe8f12-f3a4-4dbc-9e10-258bb481f4f4)

**Netlist output**

```
/* Generated by Yosys 0.37+21 (git sha1 8649e3066, gcc 9.4.0-1ubuntu1~20.04.2 -fPIC -Os) */

module blocking_caveat(a, b, c, d);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  wire _4_;
  input a;
  wire a;
  input b;
  wire b;
  input c;
  wire c;
  output d;
  wire d;
  sky130_fd_sc_hd__o21a_1 _5_ (
    .A1(_2_),
    .A2(_1_),
    .B1(_3_),
    .X(_4_)
  );
  assign _2_ = b;
  assign _1_ = a;
  assign _3_ = c;
  assign d = _4_;
endmodule
```

**Testbench**

![blocking_caveat_netlist_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/c21e555e-a790-45cf-82a1-fbfeb293afbd)

**Comparison**

![blocking_caveat_compare](https://github.com/pitman75/vsd-hdp/assets/12179612/cc2b75c2-2070-4940-a719-bc9353c3aac9)

Mismatch behavior found. Rewrite Verilog RTL to fix it.

## Day 5

The main idea of this day is: use more or less complex Verilog module to synthesis and test after synthes. How to it works with real cells.
Use a simple RISC-V core from there https://github.com/vinayrayapati/rv32i

**RTL simulation**

```
iverilog iiitb_rv32i.v iiitb_rv32i_tb.v
./a.out
gtkwave iiitb_rv32i.vcd rv32i.gtkw
```

![iiirv32i_rtl_waves-2](https://github.com/pitman75/vsd-hdp/assets/12179612/cb59bac3-6f67-4f91-9a42-97dddd289add)

**Generate netlist by Yosys**

```
read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog iiitb_rv32i.v
synth -top iiitb_rv32i
flatten
opt_clean -purge
dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
write_verilog iiitb_rv32i_net.v
```

**Netlist statistics**

```
14. Printing statistics.

=== iiitb_rv32i ===

   Number of wires:               5808
   Number of wire bits:           7620
   Number of public wires:          57
   Number of public wire bits:    1745
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:               7493
     sky130_fd_sc_hd__a2111oi_0      5
     sky130_fd_sc_hd__a211o_1        2
     sky130_fd_sc_hd__a211oi_1      27
     sky130_fd_sc_hd__a21boi_0       2
     sky130_fd_sc_hd__a21o_1        54
     sky130_fd_sc_hd__a21oi_1     1526
     sky130_fd_sc_hd__a221o_1        1
     sky130_fd_sc_hd__a221oi_1      10
     sky130_fd_sc_hd__a222oi_1     194
     sky130_fd_sc_hd__a22o_1         3
     sky130_fd_sc_hd__a22oi_1      504
     sky130_fd_sc_hd__a2bb2oi_1      2
     sky130_fd_sc_hd__a311oi_1       5
     sky130_fd_sc_hd__a31o_1         3
     sky130_fd_sc_hd__a31oi_1       34
     sky130_fd_sc_hd__a32oi_1        5
     sky130_fd_sc_hd__a41oi_1        7
     sky130_fd_sc_hd__and2_0        57
     sky130_fd_sc_hd__and3_1        51
     sky130_fd_sc_hd__and4_1         1
     sky130_fd_sc_hd__clkinv_1     100
     sky130_fd_sc_hd__dfrtp_1       32
     sky130_fd_sc_hd__dfxtp_1     1618
     sky130_fd_sc_hd__maj3_1        16
     sky130_fd_sc_hd__mux2_1        54
     sky130_fd_sc_hd__mux2i_1       53
     sky130_fd_sc_hd__mux4_2         3
     sky130_fd_sc_hd__nand2_1      669
     sky130_fd_sc_hd__nand2b_1      39
     sky130_fd_sc_hd__nand3_1       79
     sky130_fd_sc_hd__nand3b_1       9
     sky130_fd_sc_hd__nand4_1       15
     sky130_fd_sc_hd__nor2_1      1254
     sky130_fd_sc_hd__nor2b_1       18
     sky130_fd_sc_hd__nor3_1        67
     sky130_fd_sc_hd__nor3b_1        8
     sky130_fd_sc_hd__nor4_1        71
     sky130_fd_sc_hd__nor4b_1        1
     sky130_fd_sc_hd__o2111ai_1      2
     sky130_fd_sc_hd__o211a_1        1
     sky130_fd_sc_hd__o211ai_1      13
     sky130_fd_sc_hd__o21a_1        19
     sky130_fd_sc_hd__o21ai_0      547
     sky130_fd_sc_hd__o21ba_1        1
     sky130_fd_sc_hd__o21bai_1       1
     sky130_fd_sc_hd__o221ai_1       7
     sky130_fd_sc_hd__o22a_1         4
     sky130_fd_sc_hd__o22ai_1       33
     sky130_fd_sc_hd__o311a_1        1
     sky130_fd_sc_hd__o311ai_0       9
     sky130_fd_sc_hd__o31a_1         2
     sky130_fd_sc_hd__o31ai_1       19
     sky130_fd_sc_hd__o32a_1        19
     sky130_fd_sc_hd__o32ai_1        1
     sky130_fd_sc_hd__or2_0         20
     sky130_fd_sc_hd__or3_1         12
     sky130_fd_sc_hd__or3b_1         5
     sky130_fd_sc_hd__or4_1          6
     sky130_fd_sc_hd__xnor2_1      122
     sky130_fd_sc_hd__xor2_1        50
```

**Netlist simulation**

Try to simulate the netlist

```
iverilog ../lib/verilog_model/primitives.v ../lib/verilog_model/sky130_fd_sc_hd.v iiitb_rv32i_net.v iiitb_rv32i_tb.v
./a.out
gtkwave iiitb_rv32i.vcd rv32i.gtkw
```

And see very strange result

![iiirv32i_synth_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/31e2d3ba-8855-48fb-877d-a1698cc7d977)

All output signals have X output value. It's known bug with sky130's verilog model library well described there https://github.com/The-OpenROAD-Project/OpenLane/issues/518
A workaround is small modification of sky130's verilog model library and special options for simulation. Working workflow is here:

```
iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 ../lib/verilog_model/primitives.v ../lib/verilog_model/sky130_fd_sc_hd.v iiitb_rv32i_net.v iiitb_rv32i_tb.v
./a.out
gtkwave iiitb_rv32i.vcd rv32i.gtkw
```

Success!

![iiirv32i_synth_waves-2](https://github.com/pitman75/vsd-hdp/assets/12179612/452797c3-0e8e-4cdd-9e11-c71da2b0d1d9)

**Comparison RTL and netlist simulation**

![iiirv32i_rtl_synth_waves](https://github.com/pitman75/vsd-hdp/assets/12179612/fbf59120-911e-4ac9-abe3-329bd9ec7c99)

**Conclusion**

Functionality of Verilog RTL and generated netlist is the same.

## Day 6 Basic of STA

 - Logic Synthesis Flow by Design-Compiler from Synopsys
 - Basic Logic Synthesis knowledge introduction

```
* Logic Synthesis
    1. RTL+.LIB->Netlist(Gates)
    2. .LIB is collection of logic modules from same function but different strengeh/timing variation
        * Need Cells that work fast enough to meet required performance (setup-time)
        * Need Cells that work slow enough to avoid contamination (hold-time)
* Design Compiler
    1. SDC, synopsys design constraints, industry standard constraint for EDA automation
    2. .LIB, design library which contains the standard cell information
    3. .DB, same as .LIB for DC import related libraries
    4. .DDC, Synopsys's proprietary format for libraries
    5. SDC for timing-constraint, UPF for power-constraint
* Design(RTL) + Library (.DB) + SDC -> Verilog Netlist + DDC + Synthesis Reports
* Implementation Flow for ASIC
    `[RTL]->[SYN]->[DFT]->[FP]->[CTS]->[PnR]->[GDS]`
* DC Synthesis Flow:
    1. Read STD Cell/Tech .lib
    2. Read Design (Verilog/VHDL, Design .LIB)
    3. Read Design Constraints (SDC)
    4. Link the Design
    5. Synthesize the Design
    6. Generate Report and Analyze QoR
* Library Name : `sky130_fd_sc_hd_tt_025C_1v80.lib`
    * fd -> fundary, sc -> standard cell, hd->high-density, tt->typical-typical, 025C-> 25 degree temperature, 1v80->1.8V
* PVT -> Power/Voltage/Temerature
    * PVT corner -> typical/fast/slow
* DC Operation Flow
```

**Build a design**

```
    $dc_shell
    >read_verilog lab8.v
    >read_db sky130.db
    >set link_library {* sky130.db}
    >link
    >compile
    >write -f verilog -out lib8_net_sky130.v
    >write -f ddc -out lib8.ddc
```

**Open gate-level logic in Design Vision**

```
    $design_vision
    >start gui
    //---
    >read_ddc lab1.ddc
    //--- Use GTECH (gech.db) /standard.sldb
    >read_verlog lib1_net_sky130.v
```

**Start-up Script to set environment**

File-Name: `.synopsys_dc.setup`, put in home directory

**TCL Quick Reference**

```
    * set a [ expr $a + $b ]
    * if { cond } { true-stat } else { false-stat }
    * echo "hello world"
    * while { cond } { loop-stat }
    * for { init } {  cond } { end-op } { loop-stat }
    * foreach <var-name> <list-name> { statements }
    //DC only
    * foreach <var-name> <collection-name> { statements }
    * get_lib_cells */*and* > get collection
    * source script.tcl
```

**Set constrains for STA**

```
    * Max (Setup) and Min (Hold) delay constraints
    * Delay for Cells:
        1. Input Transition (Driving Slew-Rate)
        2. Output Load (Capcitance)
    * Timing Arc
        * Combinational Cell: input port to output port changes elasped time
        * Sequential Cell:
            1. Clock to Q -> DFF
            2. Clock to D + D to Q -> D-Latch (DLAT)
```

![lec-dc-sta01](https://github.com/pitman75/vsd-hdp/assets/12179612/f4bef8af-57c4-4dcc-a4af-4bb07c093d32)

**Timing-Path**

 - Start Point : 1. Input-Port 2. Clock Pin of Register
 - End Point : 1. Output-Port 2. D Pin of Register

![lec-dc-sta02](https://github.com/pitman75/vsd-hdp/assets/12179612/d248fe0a-f855-4772-81b3-0d0e1177c226)

**Timing-Path Constraint**

 - REG2REG: Clock Constraint
 - REG2OUT: Output External Delay + Clock Constraint
 - IN2REG: Input External Delay + Clock Constraint

![lec-dc-sta03](https://github.com/pitman75/vsd-hdp/assets/12179612/b7ea6e21-0578-4eca-aefe-021f1392ea06)

**IO Constraint**

 - Delay isn't ideal as zero -> Consider input transition and output load
 -  Rule of Thumb: 70% Eternal Delay, 30% Internal Delay from Clock constraint
    
**.LIB Timing**

 - `default_+max_transition` in ps
 - C_load = C_pin+C_net+SUM(C_input_cap) -> max capcitance limit
 - Add buffer to balance high fanout driving strength
    
**Delay Model Table**

 - X-Axis: Output Load (pf)
 - Y-Axis: Input Transition (ns)
    
**Unateness**
 -> If only 1-pin changes, if output pin has same behavior
 - Positive: AND, OR
 - Negative: NOT, NAND, NOR
 - Non: XOR, DFF

## Day 7 Advanced SDC contraints

 - Clock/Input/Output Constraint Details
 - Useful DC commands

**Constraint for Clock**

 - Before CTS, clock is an ideal network for Synthesis stage
 - Post-CTS generate real clock
    
**Clock Generation**

 - Oscillator
 - PLL
 - External Clock Source
        
**Real Clock : Ideal Clock + Jitter + Skew**

 - Jitter : physical world stochastic behavior
 - Skew : Routing topographical delay
    
**Clock Modeling**

 - Period
 - Source Latency
 - Clock Network Latency
 - Clock Skew
 - Jitter
    
Clock Skew+Jitter => Clock Uncertainty

Use Skew+Jitter pre STA simulationand **only** Jitter in post STA simulation.

Define `net` : connecting of two or more pins or ports in target design region

![lec-dc-sta04](https://github.com/pitman75/vsd-hdp/assets/12179612/78b46d3b-7eda-4c88-a752-40f77e3485ed)

**DC commands in/out**

```
    > get_ports *clk*;
    > get_ports * -filter "direction == in";
    > get_ports * -filter "direction == out";
    > get_clocks * -filter "period > 10";
    > get_attribute [ get_clocks my_clk ] period ;
    > get_attribute [ get_clocks my_clk ] is_generated ;
    > report_clocks my_clk ;
```

**Hierarchical/Physical Cell/PIn**

```
    > get_cells * -hier
    > get_attribute [ get_cells <cell-name> ] is_hierarchical
```

**Clock Constraint**

Uncertainty in different stage
 - Jitter+Skew for CTS
 - Jitter only for PnR

```
    > create_clock -name <clk-name> -period <time> [get_ports <clk-port>] ;
    > set_clock_latency <time> <clk-name>
    > create_clock -name <clk-name> -period <time> [get_ports <clk-port>] -wave { <rise-time-point> <fall-time-point> } ;
```

**Input IO modeling**

```
    > set_input_delay -max <time> -clock [get_clocks <clk-name>] [get_ports <port-name>] ;
    > set_input_delay -min <time> -clock [get_clocks <clk-name>] [get_ports <port-name>] ;
    > set_input_transition -max <unit> [get_ports <port-name>]
    > set_input_transition -min <unit> [get_ports <port-name>]
```

**Output IO modeling**

```
    > set_output_delay -max <time> -clock [get_clocks <clk_name>] [get_ports <port-name>]
    > set_output_delay -min <time> -clock [get_clocks <clk_name>] [get_ports <port-name>]
    > set_output_load -max <cap_unit> [get_ports <port-name>]
    > set_output_load -min <cap_unit> [get_ports <port-name>]
```

![lec-dc-sta05](https://github.com/pitman75/vsd-hdp/assets/12179612/e460ebd9-2d68-4899-8848-969ec4c9d982)

**DC shell lab**

```
    > get_cells/get_ports/get_nets/get_clocks/get_pins
    > all_connected <net-name>
    > regex <pattern> <expression> # return 1 when pattern match expression, otherwise 0
    > get_attribnute [get_pins <pin-name>] clock # report if this is clock pin
    > get_attribnute [get_pins <pin-name>] clocks # report clocks reach to this pin
    > current_design # report name of top module
    > report_clocks *
    > remove_clock <clk_name>
```

**Clock network modeling**

```
    > set_clock_latency -source <time> [get_clocks <clk_name>] # source latency (clock source)
    > set_clock_latency <time> [get_clocks <clk_name>] # network latency (to top module)
    > set_clock_uncertainty -setup <time> [get_clocks <clk_name>]
    > set_clock_uncertainty -hold <time> [get_clocks <clk_name>]
    > report_timing
    > report_timing -to <pin-name>
    > report_timing -to <pin-name> -delay min
    > report_timing -from <pin-name>
    > report_timing -verbose
    > report_port -verbose
    > report_timing -from <pin-name> -trans -net -cap -nosplit
    > report_timing -from <pin-name> -trans -net -cap -nosplit -delay_type min # Hold time
    > set_input_transition -max <amount> [get_ports <port-name>]
    > set_input_transition -min <amount> [get_ports <port-name>]
        # add input transition, input pin data arrival time is increased
    > set_load -max <amount> [get_ports <port-name>]
    > set_load -min <amount> [get_ports <port-name>]
        # add output load, output pin data arrival time is increased
```

**Generated Clock**

```
    > create_generated_clock -name <gen-clk-name> -master [get_clocks <base-clk>] -source [get_port <src-port>] -div 1 [get_ports <dst-port>]
    > reset_design # restart a new design
    > get_generated_clocks
```

**Constraint for pure combinational path from input to output port**
    1. set_max_latency
    2. virtual clock

![lec-dc-sta06](https://github.com/pitman75/vsd-hdp/assets/12179612/97685174-ee3b-4b96-95a6-4c7946419e78)

```
    > set_max_latency <time> -from [get_ports <input>] -to [get_ports <output>]
    > create_clock -name <vclk> -period <time> # if path has no clock definition point, virtual clock inferred

    > set_input_delay -max <time> -clock [get_clocks <vclk>] [get_ports <input>]
    > set_output_delay -max <time> -clock [get_clocks <vclk>] [get_ports <output>]
    > set_input_delay -max <time> -clock [get_clocks <vclk>] -clock_fall [get_ports <input>] # for virtual negedge sampling DFF
    > set_output_delay -max <time> -clock [get_clocks <vclk>] -clock_fall [get_ports <output>] # for virtual negedge sampling DFF
    
    > set_driving_cell -lib_cell <lib_cell_name> <ports>

    > all_inputs/all_outputs/all_clocks/all_registers
    > all_fanout -from <pin/port name> (-endpoints_only -flat)
    > all_fanin -to <pin/port name> (-endpoints_only -flat)
    > get_cells -of_objects [get_pins <pin-name>]
    > report_timing -to <output-port> -sig <unit> # report decimal number
```

**Multi-Clock Path with negedge**

```
> set_input_delay -max <time> -clock [get_clocks <clk>] [get_ports <input>] # input constrains for first clock with posedge
> set_input_delay -max <time> -clock [get_clocks <clk>] -clock_fall -add [get_ports <input>] # input constrains for second clock with negedge
> set_output_delay -max <time> -clock [get_clocks <clk>] [get_ports <output>] # output constrains for first clock with posedge
> set_output_delay -max <time> -clock [get_clocks <clk>] -clock_fall -add [get_ports <output>] # output constrains for second clock with negedge
```

## Day8 OpenSTA

**STA for simple example**

Let's do STA for good_mux.v from previouse lab. All constrains are only for example. Run `sta` in folder with Verilogs

```
% read_liberty ../../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
% read_verilog good_mux_netlist.v
% link_design good_mux
% current_design
% check_setup -verbose
% create_clock -period 10 -name clk
% set_input_delay -clock clk -max 3 [get_ports i0]
% set_input_delay -clock clk -max 3 [get_ports i1]
% set_input_delay -clock clk -max 3 [get_ports sel]
% set_input_delay -clock clk -min 1 [get_ports i0]
% set_input_delay -clock clk -min 1 [get_ports i1]
% set_input_delay -clock clk -min 1 [get_ports sel]
% set_input_transition -max 0.5 [get_ports i0]
% set_input_transition -max 0.5 [get_ports i1]
% set_input_transition -max 0.5 [get_ports sel]
% set_input_transition -min 0.1 [get_ports i0]
% set_input_transition -min 0.1 [get_ports i1]
% set_input_transition -min 0.1 [get_ports sel]
% set_output_delay -clock clk -max 5 [get_ports y]
% set_output_delay -clock clk -min 1 [get_ports y]
% report_checks
```

STA report is

```
% report_checks
Startpoint: i1 (input port clocked by clk)
Endpoint: y (output port clocked by clk)
Path Group: clk
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   0.00    0.00   clock network delay (ideal)
   3.00    3.00 v input external delay
   0.00    3.00 v i1 (in)
   0.45    3.45 v _4_/X (sky130_fd_sc_hd__mux2_1)
   0.00    3.45 v y (out)
           3.45   data arrival time

  10.00   10.00   clock clk (rise edge)
   0.00   10.00   clock network delay (ideal)
   0.00   10.00   clock reconvergence pessimism
  -5.00    5.00   output external delay
           5.00   data required time
---------------------------------------------------------
           5.00   data required time
          -3.45   data arrival time
---------------------------------------------------------
           1.55   slack (MET)
```

For more efficient work let's move constrains to a file `good_mux.sdc`

```
create_clock -period 10 -name clk
set_input_delay -clock clk -max 3 [get_ports i0]
set_input_delay -clock clk -max 3 [get_ports i1]
set_input_delay -clock clk -max 3 [get_ports sel]
set_input_delay -clock clk -min 1 [get_ports i0]
set_input_delay -clock clk -min 1 [get_ports i1]
set_input_delay -clock clk -min 1 [get_ports sel]
set_input_transition -max 0.5 [get_ports i0]
set_input_transition -max 0.5 [get_ports i1]
set_input_transition -max 0.5 [get_ports sel]
set_input_transition -min 0.1 [get_ports i0]
set_input_transition -min 0.1 [get_ports i1]
set_input_transition -min 0.1 [get_ports sel]
set_output_delay -clock clk -max 5 [get_ports y]
set_output_delay -clock clk -min 1 [get_ports y]
```

And use the file for STA

```
% read_liberty ../../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
Warning: ../../lib/sky130_fd_sc_hd__tt_025C_1v80.lib line 23, default_fanout_load is 0.0.
1
% read_verilog good_mux_netlist.v
1
% link_design good_mux
1
% current_design
good_mux
% check_setup -verbose
Warning: There are 3 input ports missing set_input_delay.
  i0
  i1
  sel
Warning: There is 1 output port missing set_output_delay.
  y
Warning: There is 1 unconstrained endpoint.
  y
0
% read_sdc good_mux.sdc
% check_setup -verbose
1
% report_checks
Startpoint: i1 (input port clocked by clk)
Endpoint: y (output port clocked by clk)
Path Group: clk
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   0.00    0.00   clock network delay (ideal)
   3.00    3.00 v input external delay
   0.00    3.00 v i1 (in)
   0.45    3.45 v _4_/X (sky130_fd_sc_hd__mux2_1)
   0.00    3.45 v y (out)
           3.45   data arrival time

  10.00   10.00   clock clk (rise edge)
   0.00   10.00   clock network delay (ideal)
   0.00   10.00   clock reconvergence pessimism
  -5.00    5.00   output external delay
           5.00   data required time
---------------------------------------------------------
           5.00   data required time
          -3.45   data arrival time
---------------------------------------------------------
           1.55   slack (MET)
```

Let's do `fanout` and `fanin` analysis. Use TCL is very good idea.

For `fanout` of the i0 input:

```
% foreach  my_in_ports [get_fanout -flat -endpoints_only -from i0] {
set port_name [get_full_name $my_in_ports];
puts $port_name;
}
y
```

For `fanout` of the i1 input:

```
% foreach  my_in_ports [get_fanout -flat -endpoints_only -from i1] {
set port_name [get_full_name $my_in_ports];
puts $port_name;
}
y
```

For `fanout` of the sel input:

```
% foreach  my_in_ports [get_fanout -flat -endpoints_only -from sel] {
set port_name [get_full_name $my_in_ports];
puts $port_name;
}
y
```

For `fanin` of the y output:

```
foreach  my_in_ports [get_fanin -flat -startpoints_only -to y] {
set port_name [get_full_name $my_in_ports];
puts $port_name;
}
i0
i1
sel
```

Done!

**STA for RV32I core**

First of all define constrains in a file `iiirv32i.sdc`

```
create_clock -period 10 -name clk {clk}
set_clock_latency -source -max 3 {clk}
set_clock_latency -source -min 1 {clk}
set_clock_transition -max 0.4 {clk}
set_clock_transition -min 0.1 {clk}
set_clock_uncertainty -setup 0.5 [get_clock clk]
set_clock_uncertainty -hold 0.2 [get_clock clk]
set_input_delay -max 3 [get_ports RN]
set_input_delay -min 1 [get_ports RN]
set_input_transition -max 0.5 [get_ports RN]
set_input_transition -min 0.1 [get_ports RN]
set_output_delay -clock clk -max 5 [get_ports NPC]
set_output_delay -clock clk -min 1 [get_ports NPC]
set_output_delay -clock clk -max 5 [get_ports WB_OUT]
set_output_delay -clock clk -min 1 [get_ports WB_OUT]
```

Load generated netlist and do STA

```
% read_liberty ../../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
Warning: ../../lib/sky130_fd_sc_hd__tt_025C_1v80.lib line 23, default_fanout_load is 0.0.
1
% read_verilog iiitb_rv32i_synth.v
1
% link_design iiitb_rv32i
1
% current_design
iiitb_rv32i
% read_sdc iiirv32i.sdc
% check_setup -verbose
1
% report_checks -path_delay min_max -fields {nets cap slew input_pins} -digits {4}
```

Min delay
![rv32i_bad_min](https://github.com/pitman75/vsd-hdp/assets/12179612/78f10a6e-88ff-447d-ba1c-b5f1f01d8d3e)

Max delay
![rv32i_bad_max](https://github.com/pitman75/vsd-hdp/assets/12179612/af493bb0-e113-4cf9-b7bd-4116b781f2e6)

The netlist is not working for target frequency (100MHz). Need to regenerate with right constrains.

Let's check fanout of biggest delay:

```
% foreach  my_in_ports [get_fanout -flat -endpoints_only -from _07596_/Y] {
set port_name [get_full_name $my_in_ports];
puts $port_name;
}
_13506_/D
_13507_/D
.........
_14400_/D
_14401_/D
```

Wow, the `_07596_/Y` drive 288 D inputs of registers! To be sure that it's right value let's check fanout of `_07609_/Y`

```
% foreach  my_in_ports [get_fanout -flat -endpoints_only -from _07609_/Y] {
set port_name [get_full_name $my_in_ports];
puts $port_name;
}
_13509_/D
```
It drives only one register.

## Day 9 - Fundamental N/P MOSFET Simulation

**N-MOS**

 - P-Substract, n+ Diffusion Region
 - Isolation Region (SiO2), PolySi or Metal Gate
 - 4-Terminal element, G (Gate), S (Source), D (Drain), B (Body)

**Threshold Voltage**

 - Vs=0, Vd=0, Vgs large enough to perform Strong Inversion point (Vt), diode B-S and B-D are off
 - Increase Vgs, electrons from n+ are drawn to the region under gate G as strong inversion
 - The conductivity of S-D path is modulated by Vgs strength
 - Add Vsb voltage, additional potential is required for strong inversion
 - Vto means threshold voltage at Vsb=0, a function of manufacturing process

**SPICE Simulation**

SPICE file: `day1_nfet_idvds_L2_W5.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=5 l=2

R1 n1 in 55

Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands

.op
.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2

.control

run
display
setplot dc1
.endc

.end
```

![NMOS_Id_Vds](https://github.com/pitman75/vsd-hdp/assets/12179612/0c651d1c-ce02-4c45-8038-41117044c737)

## Day 10 - Basics of NMOS Drain current (Id) vs Drain-to-source Voltage (Vds)

**Resistive Operation**

 - At Vgs>Vt condition with small Vds
 - Affect by Effective Channel Length
 - Currents in this condition
   - Drift Current, from the difference of potential voltage
   - Diffusion Current, from the difference of carrier concentration
 - Id = Kn'*(W/L)*((Vgs-Vt)*Vds-(Vds**2)/2) = Kn*((Vgs-Vt)*Vds-(Vds**2)/2)
   - Kn', as porocess transconductance
   - Kn=Kn'*(W/L), as gain factor
 - While (Vgs-Vt)>>Vds, Id ~= Kn*((Vgs-Vt)*Vds), linear function by Vds

**Saturation Region**

 - Pinch-Off from (Vgs-Vds)<=Vt, electron channel under the gate begins to disappear
 - Channel Voltage clamp to (Vgs-Vt)
   - Id(sat) = Kn((Vgs-Vt)*(Vgs-Vt)-((Vgs-Vt)**2)/2) = Kn/2*(Vgs-Vt)**2
 - Seems a perfect current source from equation, but affected by Vds in reality
   - Id(sat) = Kn/2*((Vgs-Vt)**2)*(1+lambda*Vds)

**SPICE Simulation**

SPICE File: `day2_nfet_idvds_L015_W039.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=0.39 l=0.15

R1 n1 in 55

Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands

.op
.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2

.control

run
display
setplot dc1
.endc

.end
```

SPICE File: `day2_nfet_idvgs_L015_W039.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=0.39 l=0.15

R1 n1 in 55

Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands

.op
.dc Vin 0 1.8 0.1 

.control

run
display
setplot dc1
.endc

.end
```

SPICE NMOS id/vds Diagram, small area but keep same ratio

![NMOS_Id_Vds_small](https://github.com/pitman75/vsd-hdp/assets/12179612/b55dfab0-4bb9-4af7-86f9-cfd6658e612f)

SPICE NMOS id/vgs Diagram

![NMOS_Id_Vgs_small](https://github.com/pitman75/vsd-hdp/assets/12179612/0a797c10-3a9a-4b1f-bf03-45482e3b16c0)

## Day 11 - Velocity Saturation and basics of CMOS inverter VTC

**Velocity Saturation Effect**

 - Long-Channel (>250nm)
 - Short-Channel (<250nm)
 - Id = Kn*((Vgt-Vmin)-(Vmin**2)/2)*(1+lambda*Vds)
 - Vmin = min(Vgt, Vds, Vd(Sat))

| Long-Chan. | Short-Chan. |
|------------|-------------|
| Cut-Off    | Cut-Off     |
| Resistive  | Resistive   |
|            | Vel-Sat     |
| Saturation | Saturation  |

**Voltage-Transfer Characteristics (VTC)**

 - Transistor
   - Switch Off when |Vgs|<|Vt|
   - Switch On when |Vgs|>|Vt|
 - CMOS inverter => NOT Gate, PMOS+NMOS

**Assume CMOS inverter in 0-2V range**

| Vin 	| Vout 	| PMOS 	| NMOS |
|-------|-------|-------|------|
| 0 	| 2 	| LIN 	| OFF  |
| ~0.5 	| ~1.5 	| LIN 	| SAT  |
| 1 	| 1 	| SAT 	| SAT  |
| ~1.5 	| ~0.5 	| SAT 	| LIN  |
| 2 	| 0 	| OFF 	| LIN  |

**Switching Threshold**

 - Vm, should near the middle of VTC on CMOS inverter
 - Vm = R*Vdd/(1+R), R=(Rp*(Wp/Lp)*Vdp)/(Rn*(Wn/Ln)*Vdn)

**Transition Delay**

 - Rise-Delay, Input 0 then Output 1
 - Fall-Delay, Input 1 then Output 0
 - Find balanced rise/fall delay based on fixed (Wp/Lp), search in variable (Wn/Ln)
 - From Device Physics, Ron(PMOS) ~= 2.5*Ron(NMOS)
 - Regular inverter/buffer preferred for data-path

**SPICE Simulation**

SPICE File: `day3_inv_vtc_Wp084_Wn036.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15

Cload out 0 50fF

Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands

.op

.dc Vin 0 1.8 0.01

.control
run
setplot dc1
display
.endc
.end
```

VTC from P/NMOS when PMOS bigger than NMOS

![NMOS-PMOS_vtc](https://github.com/pitman75/vsd-hdp/assets/12179612/b51e06de-8b72-41e0-ab6b-030f55764e27)

SPICE File: `day3_inv_tran_Wp084_Wn036.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15

Cload out 0 50fF

Vdd vdd 0 1.8V
Vin in 0 PULSE(0V 1.8V 0 0.1ns 0.1ns 2ns 4ns)

*simulation commands

.tran 1n 10n

.control
run
.endc
.end
```

Inverter Transient Analysis

![inverter_transient](https://github.com/pitman75/vsd-hdp/assets/12179612/0e70a3a5-6e99-4681-99d4-c76af74f6edd)

| ITEM       | TIME (ns) |
|------------|-----------|
| Rise-Delay |	0.35432  |
| Fall-Delay |	0.27345  |

## Day 12 - Noise Margine

**Noise Margin**

 - Preserve Noise Margin to against environmental noise

    NMH = VOH-VIH
    NML = VIL-VOL

![day14_lec_p1](https://github.com/pitman75/vsd-hdp/assets/12179612/06ca0356-2017-4841-bf3e-bee62848c172)

**SPICE Simulation**

SPICE File: `day4_inv_noisemargin_wp1_wn036.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=1 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15

Cload out 0 50fF

Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands

.op

.dc Vin 0 1.8 0.01

.control
run
setplot dc1
display
.endc
.end
```

Inverter Switching Transition Diagram

![noise_margin](https://github.com/pitman75/vsd-hdp/assets/12179612/b7a5452a-226f-4f22-9744-d472cf38f96a)

| ITEM 	| Voltage   |
|-------|-----------|
| VOH 	| 1.73273   |
| VOL 	| 0.098545  |
| VIH 	| 0.968707  |
| VIL 	| 0.76119   |
| NMH 	| 0.721623  |
| NML 	| 0.648545  |

## Day13 - Device variation robustness

**Power Supply Scaling**

    |Gain| = |Vout(VIH)-Vout(VIL)|/|VIH-VIL|
    
 - Advantage :
   - Increase in Gain (~50% improvement)
   - Reduction in Energy (~90% improvement, from Energy=1/2*C*Vdd**2)
 - Disadvantage :
   - Performance Impact on dymanic transition (increasing large delay)

**Process Variation**

 - Etching, layout shape variation, not expect rectangle formation
 - Oxide Thickness, not uniformly thickness on Oxide layer

**Device Variation**

 - Shift in Vm
 - Variation in NMH/NML
 - Operation of Gate is intact

**SPICE Simulation**

**Power variation** SPICE File: `day5_inv_supplyvariation_Wp1_Wn036.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=1 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15

Cload out 0 50fF

Vdd vdd 0 1.8V
Vin in 0 1.8V

.control

let powersupply = 1.8
alter Vdd = powersupply
	let voltagesupplyvariation = 0
	dowhile voltagesupplyvariation < 6
	dc Vin 0 1.8 0.01
	let powersupply = powersupply - 0.2
	alter Vdd = powersupply
	let voltagesupplyvariation = voltagesupplyvariation + 1
      end
 
plot dc1.out vs in dc2.out vs in dc3.out vs in dc4.out vs in dc5.out vs in dc6.out vs in xlabel "input voltage(V)" ylabel "output voltage(V)" title "Inveter dc characteristics as a function of supply voltage"

.endc
.end
```

Power-Supply Scaling

![inverter_supply_variation](https://github.com/pitman75/vsd-hdp/assets/12179612/4ed8730e-f32f-4a8d-a7ac-a16b6010a29a)

**Device variation** SPICE File: `day5_inv_devicevariation_wp7_wn042.spice`

```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description

XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15

Cload out 0 50fF

Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands

.control

    let nmoswidth = 0.36
    alter m.xm2.msky130_fd_pr__nfet_01v8 w = nmoswidth
    let pmoswidth = 1.2
    alter m.xm1.msky130_fd_pr__pfet_01v8 w = pmoswidth

    let widthVariation = 0
    dowhile widthVariation < 5
        echo "nmos width: $&nmoswidth u"
        echo "pmos width: $&pmoswidth u"
        *** dc analysis
        dc vin 0 1.8 0.01
        *** change to next env.
        let nmoswidth = nmoswidth + 0.32
        let pmoswidth = pmoswidth - 0.12
        alter @m.xm2.msky130_fd_pr__nfet_01v8[W] = nmoswidth
        alter @m.xm1.msky130_fd_pr__pfet_01v8[W] = pmoswidth
        let widthVariation = widthVariation + 1
    end

    plot dc1.out vs in dc2.out vs in dc3.out vs in dc4.out vs in dc5.out vs in xlabel "input voltage(V)" ylabel "output voltage(V)" title "Inveter dc characteristics as a function of P/NMOS width"

.endc

.end
```

Device Variation

![inverter_device_variation](https://github.com/pitman75/vsd-hdp/assets/12179612/0c0e502f-0263-42d8-a594-957295ae8f22)

## Day 13 - PVT Corner analysis

Main goal of PVT corner analysis is test netlist for robustness. All slacks would be positive.

Use TCL script `iiirv32i.tcl` to generate reports for each case of OpenPDK timing library.

```
read_liberty ../../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_n40C_1v76.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_n40C_1v44.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_n40C_1v40.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_n40C_1v35.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_n40C_1v28.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_100C_1v60.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ss_100C_1v40.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ff_n40C_1v76.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ff_n40C_1v65.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ff_100C_1v95.lib
#read_liberty ../../lib/sky130_fd_sc_hd__ff_100C_1v65.lib

read_verilog iiitb_rv32i_synth.v
link_design iiitb_rv32i
current_design
read_sdc iiirv32i.sdc
report_checks -path_delay min_max -fields {nets cap slew input_pins} -digits {4} > sta_out_rep1.txt
report_worst_slack -max -digits {4} > sta_out_rep2.txt
report_worst_slack -min -digits {4} > sta_out_rep3.txt
report_tns -digits {4} > sta_out_rep4.txt
report_wns -digits {4} > sta_out_rep5.txt
```

Run OpenSTA: `sta iiirv32i.tcl` , collect reports to separate folders and build comparison table.

PVT Corner Summary 

| PVT-CORNER | WNS | WHS | TNS |
|------------|-----|-----|-----|
| tt_025C_1v80 | -7.2783 | -1.8904 | -5797.6802 |
| ss_n40C_1v76 | -20.6129 | -1.7840 | -20072.2363 |
| ff_n40C_1v76 | -3.8892 | -1.9816 | -2424.3809 |
| ff_n40C_1v65 | -6.1646 | -1.9624 | -4556.0923 |
| ff_n40C_1v56 | -8.7303 | -1.9383 | -7174.8716 |
| ss_n40C_1v44 | -53.5627 | -1.2965 | -56196.5273 |
| ss_n40C_1v40 | -62.0164 | -1.1616 | -65340.0859 |
| ss_n40C_1v35 | -78.8979 | -0.9457 | -83697.0625 |
| ss_n40C_1v28 | -120.8575 | -0.4866 | -128631.1328 |
| ss_100C_1v40 | -32.4085 | -1.3567 | -34393.3789 |
| ss_100C_1v60 | -19.6810 | -1.6085 | -20061.1914 |
| ff_100C_1v65 | -3.9593 | -1.9751 | -2502.6108 |
| ff_100C_1v95 | -1.2924 | -2.0084 | -288.4185 |

Setup slack graph

![PVT_WNS_bad](https://github.com/pitman75/vsd-hdp/assets/12179612/ca7322fd-5345-4321-9060-51a2b6fb9050)

Hold slack graph

![PVT_WHS_bad](https://github.com/pitman75/vsd-hdp/assets/12179612/bca0a95a-13f6-41d4-8675-72ac145ef243)

## Day 14 - Inception of open-source EDA, OpenLANE and Sky130 PDK

**Package QFN-48**

 - Quad Flat No-lead
 - Package = Wire-Bond + Chip-Die
 - Chip-Die = Chip-Core + Pad-ring
 - Chip-Core = Foundry-IPs + Harden-Macros

**RISCV Architecture**

 - C/Cpp -> Binary Code -> Circuit in Layout

**From Software Application to Hardware**

 - App -> Compiler -> Assembler -> Application Binary Code (ELF or EXE)

**Operation-System, Hardware start Application Binary Code from OS fetch from storage device**

 - Handle IO driver Service
 - Memory Management
 - Low-Level System Interface (Program Loader)

### OpenLane Overview

**Digital ASIC Desgin: RTL IP's + EDA Tools + PDK Data**
    
PDK : Interface between FAB and the designer, Process Design Kit, include:
 - Process Design Rule: DRC, LVS, PEX
 - Device Models
 - Digital Standard Cell Libraries
 - I/O Libraries

Is 130nm Fast? Yes, Intel P4EE @3.46GHz (Q4'04)

**OpenLane ASIC Flow : (RTL+PDK) -> |SYN| -> |FP+PP| -> |Place| -> |CTS| -> |Route| -> |Sign-Off| -> (GDS-II)**

**SYN**: Synthesis, Convert RTL to circuit from Standard Cell Library (SCL)
 - Standard Cells have regular layout

**FP+PP**: Floor-Planning + Power-Planning
 - Floor-Planning : Partition the chip-die between different IPs, Macros, and I/O Pads
 - Power-Planning : Share VDD by multiple power pads to power rings/straps (use upper metal layer)

**Place**: Placement, place the std-cells on floorplan rows, aligned with the pitch
 - Global Place: IP/Macros may overlapped
 - Detailed Place: Align to rows/columns definition

**CTS**: Clock Tree Synthesis, create a clock distribution network
 - To deliver the clock to all sequential elements
 - With small intrinsic skew in practical, zero is hard to achieve
 - Usually a Tree structure (H, X, ...)

**Route**: Routing, Implement the interconnect using the available metal layers
 - Metal tracks from a routing grid
 - Divide and Conquer huge routing grid
 - Global Routing : Generate Routing Guides
 - Detailed Routing : Use the routing guides to implement the actual wires

**Sign-Off**:
 - Physical Verifications
    - Design Rules Checking (DRC)
    - Layout v.s. Schematic (LVS)
 - Timing Verifications
    - Static Timing Analysis (STA)

**OpenLane Introduction:**

 - Started as an Open-Source Flow for a True Open-Source Tape-Out Experiment (striVe)
 - Main-Goal: Produce a clean GDS-II with no human intervention flow clean means no LVS violations, no DRC violations, and no Timing violations
 - Can be used with harden Macros and Chips
 - Modes of operation: Autonomous or Interactive
 - Design Space Exploration, find the best setting of flow configuration
 - Feasible to be used for regression testing (CI)

**OpenLane ASIC Flow:**

 - Synthesis: yosys+abc
 - Post-Synth STA: OpenSTA
 - DFT Insertion: Fault DFT
 - FP + Place + Global-Route + CTS: OpenROAD
 - Fake Antenna(Ant.) Diode Insertion: OpenROAD
 - LEC: yosys
 - Detailed-Route: TritonRoute
 - Fack Ant. Diode Swapping Script
 - RC Extraction
 - Post-Route STA: OpenSTA
 - Physical Verification: Magic and netgen
 - GDS2 Streaming: Magic

**OpenROAD: Automated PnR (Place-and-Route)**

 - Floor/Power Planning
 - End Decoupling Capcitors and Tap-Cells insertion
 - Placement: Global and Detailed
 - Post Placement Optimization
 - Clock-Tree Synthesis (CTS)
 - Routing: Global and Detailed

**LEC (Logic Equivalence Check)**

Verify modified netlist
 - Post-CTS
 - Post-Placement Optimization

Formally confirm that the function didn't change after flow modifying the netlist

**Antenna Didoe: Antenna Rules Violation**

When a metal wire segment is fabricated, it can act as antenna, especially long-wire
 - Reactive ion etching causes charge to accumulate on wires
 - Transister gates can be damaged during fabrication

Solution:
 - Bridging attaches a higer layer bridge (Router awareness, hard to achieve)
 - Add antenna diode cell to leak away charges, which cell is provided by std-cell library

Preventive Apporach
 - Add a fake antenna diode next to every cell input after placement
 - Run the Antenna Checker (Magic) on the routed layout
 - If checker report a violation on cell input pin, replace the fake diode cell by a real one

**RC Extraction: DEF2SPEF**

DRC: Magic, and do SPICE extraction from layout

LVS: Magic and netgen, extracted spice v.s. verilog netlist

OpenLane Tutorial:
```
    sky130A/lib.ref/ -> process design libraries information
    sky130/lib.tech/ -> technology information for EDA-tools
```

To start work with OpenLANE just:
 - cd to home folder of OpenLANE
 - `make mount`

```
~/work/tools/OpenLane$ make mount
cd /home/user/work/tools/OpenLane && \
	docker run --rm -v /home/user:/home/user -v /home/user/work/tools/OpenLane:/openlane -v /home/user/work/tools/OpenLane/empty:/openlane/install -v /home/user/.volare:/home/user/.volare -e PDK_ROOT=/home/user/.volare -e PDK=sky130A  --user 1000:1000 -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/user/.Xauthority:/.Xauthority --network host --security-opt seccomp=unconfined -ti efabless/openlane:9dbd8b5ea2bd891bed4dcc97df5c7439083f0368-amd64
OpenLane Container (9dbd8b5):/openlane$ 
```

**Workflow:**

```
$ ./flow.tcl -interactive
% package require openlane 0.9
% prep -design picorv32a
$ run_synthesis
```

 - check result netlist: `runs/<date>_<time>/synthesis/<deisgn>.synthesis.v`
 - check synth-stat report: `/reports/synthesis/*.rpt`
 - check timing report: `/opensta_main.timing.rpt`

**Synthesis report**

```
=== picorv32a ===

   Number of wires:              16214
   Number of wire bits:          16596
   Number of public wires:        1475
   Number of public wire bits:    1857
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:              16494
     sky130_fd_sc_hd__a2111o_2       8
     sky130_fd_sc_hd__a211o_2      255
     sky130_fd_sc_hd__a211oi_2     134
     sky130_fd_sc_hd__a21bo_2      140
     sky130_fd_sc_hd__a21boi_2      40
     sky130_fd_sc_hd__a21o_2       420
     sky130_fd_sc_hd__a21oi_2      560
     sky130_fd_sc_hd__a221o_2      184
     sky130_fd_sc_hd__a221oi_2       3
     sky130_fd_sc_hd__a22o_2       392
     sky130_fd_sc_hd__a22oi_2      222
     sky130_fd_sc_hd__a2bb2o_2      30
     sky130_fd_sc_hd__a311o_2       12
     sky130_fd_sc_hd__a311oi_2       2
     sky130_fd_sc_hd__a31o_2       200
     sky130_fd_sc_hd__a31oi_2        8
     sky130_fd_sc_hd__a32o_2        39
     sky130_fd_sc_hd__a41o_2         2
     sky130_fd_sc_hd__and2_2       359
     sky130_fd_sc_hd__and2b_2      296
     sky130_fd_sc_hd__and3_2       367
     sky130_fd_sc_hd__and3b_2       68
     sky130_fd_sc_hd__and4_2       294
     sky130_fd_sc_hd__and4b_2       12
     sky130_fd_sc_hd__and4bb_2      20
     sky130_fd_sc_hd__buf_1       3037
     sky130_fd_sc_hd__buf_2         24
     sky130_fd_sc_hd__conb_1        41
     sky130_fd_sc_hd__dfxtp_2     1613
     sky130_fd_sc_hd__inv_2        142
     sky130_fd_sc_hd__mux2_2      1518
     sky130_fd_sc_hd__mux4_2        54
     sky130_fd_sc_hd__nand2_2      929
     sky130_fd_sc_hd__nand2b_2       4
     sky130_fd_sc_hd__nand3_2      180
     sky130_fd_sc_hd__nand3b_2      31
     sky130_fd_sc_hd__nand4_2       88
     sky130_fd_sc_hd__nand4b_2       2
     sky130_fd_sc_hd__nor2_2       753
     sky130_fd_sc_hd__nor2b_2        1
     sky130_fd_sc_hd__nor3_2        88
     sky130_fd_sc_hd__nor3b_2        9
     sky130_fd_sc_hd__nor4_2        23
     sky130_fd_sc_hd__o2111a_2       3
     sky130_fd_sc_hd__o211a_2      318
     sky130_fd_sc_hd__o211ai_2      79
     sky130_fd_sc_hd__o21a_2       275
     sky130_fd_sc_hd__o21ai_2      316
     sky130_fd_sc_hd__o21ba_2      174
     sky130_fd_sc_hd__o21bai_2      39
     sky130_fd_sc_hd__o221a_2       70
     sky130_fd_sc_hd__o22a_2        94
     sky130_fd_sc_hd__o22ai_2        5
     sky130_fd_sc_hd__o2bb2a_2      24
     sky130_fd_sc_hd__o2bb2ai_2      1
     sky130_fd_sc_hd__o311a_2       12
     sky130_fd_sc_hd__o311ai_2       1
     sky130_fd_sc_hd__o31a_2        21
     sky130_fd_sc_hd__o31ai_2        8
     sky130_fd_sc_hd__o32a_2        24
     sky130_fd_sc_hd__o41a_2         2
     sky130_fd_sc_hd__or2_2        501
     sky130_fd_sc_hd__or2b_2       208
     sky130_fd_sc_hd__or3_2        194
     sky130_fd_sc_hd__or3b_2        42
     sky130_fd_sc_hd__or4_2         63
     sky130_fd_sc_hd__or4b_2        16
     sky130_fd_sc_hd__or4bb_2       14
     sky130_fd_sc_hd__xnor2_2     1063
     sky130_fd_sc_hd__xor2_2       323

   Chip area for module '\picorv32a': 163017.596800
```
