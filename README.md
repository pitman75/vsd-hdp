# vsd-hdp
VLSI Hardware Development program. This repository contains the entire flow from the RTL design to GDSII.

## Day 0 - Prepare software
<details>
<summary>details...</summary>
	
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

</details>

## Day 1 - Introduction to Verilog RTL Design and Synthesis

<details>
<summary>details...</summary>
 
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

</details>

## Day 2 - Timing libs, hierarchical vs flat synthesis and efficient flop coding styles

<details>
	<summary>details...</summary>
	
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

</details>

## Day 3 - Combinational and sequential optimizations

<details>
<summary>details...</summary>

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

</details>

## Day 4 - GLS, blocking vs non-blocking and Synthesis-Simulation mismatch

<details>
<summary>details...</summary>

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

</details>

## Day 5 - Netlist simulation

<details>
<summary>details...</summary>
	
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

<details>
	<summary>Netlist statistics</summary>

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
</details>

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

</details>

## Day 6 - Basic of STA

<details>
<summary>details...</summary>
	
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

</details>

## Day 7 - Advanced SDC contraints

<details>
<summary>details...</summary>
	
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

</details>

## Day 8 - OpenSTA

<details>
<summary>details...</summary>
	
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

</details>

## Day 9 - Fundamental N/P MOSFET Simulation

<details>
<summary>details...</summary>
	
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

</details>

## Day 10 - Basics of NMOS Drain current (Id) vs Drain-to-source Voltage (Vds)

<details>
<summary>details...</summary>
	
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

</details>

## Day 11 - Velocity Saturation and basics of CMOS inverter VTC

<details>
<summary>details...</summary>
	
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

</details>

## Day 12 - Noise Margine

<details>
<summary>details...</summary>
	
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

</details>

## Day 13 - Device variation robustness

<details>
<summary>details...</summary>
	
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

</details>

## Day 14 - PVT Corner analysis

<details>
<summary>details...</summary>
	
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

</details>

## Day 15 - Inception of open-source EDA, OpenLANE and Sky130 PDK

<details>
<summary>details...</summary>
	
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
 - docker

**Workflow:**

```
$ ./flow.tcl -interactive
% package require openlane 0.9
% prep -design picorv32a
% run_synthesis
```

**Synthesis result**

![picorv32a_synth_1](https://github.com/pitman75/vsd-hdp/assets/12179612/1d864d97-86ce-4ae1-a9dc-a2fbeda13635)

**STA result**

![picorv32a_sta_1](https://github.com/pitman75/vsd-hdp/assets/12179612/e509e0c4-ad06-419b-a762-e8afb12d5bc2)

STA violations found.

 - check result netlist: `runs/<date>_<time>/synthesis/<deisgn>.synthesis.v`
 - check synth-stat report: `/reports/synthesis/*.rpt`
 - check timing report: `/opensta_main.timing.rpt`

</details>

## Day 16 - Understand importance of good floorplan vs bad floorplan and introduction to library cells

<details>
<summary>details...</summary>
	
### Floorplan and placement

**Utilization Factor and Aspect**

 - Utilization Factor = (Area Occupied by Netlist)/(Total Area of the Core)
 - Aspect Ratio = (Height of Core)/(Width of Core)

**Pre-placed cells, i.e. Hard-Macro or Block-Box Cells**

 - Arrangement of these IP's in a chip is referred as Floor-Planning
 - Define location of pre-placed cells

**De-coupling Capacitors**

 - Alleviate voltage-drop from circuit switches to currput noise-margin limitation
 - De-couples main voltage supplier to responsible cells
 - Replenish the decoupling capcitor after circuit switches

**Power-Planning**

 - De-coupling limitation: single voltage source may leakage through multiple de-coupling region
 - Solution: multiple voltage source, i.e. power mesh

**Pin-Placement**

 - Place pins near the target/source macro/std-cells

**Floorplan workflow**

```
$ ./flow.tcl -interactive
% package require openlane 0.9
% prep -design picorv32a
% run_synthesis
% run_floorplan
```

![floorplan_log](https://github.com/pitman75/vsd-hdp/assets/12179612/b6ca966b-35ee-47b5-ba09-79b64a1f4e52)

results in `<design>/runs/<date>_<time>/logs`
 - `/floorplan/ioPlacer.log`
 - `/config.tcl`
 - '/result/floorplan/<design>.floorplan.def' DIEAREA

Magic open DEF file by command:

```
$ magic -T sky130A.tech lef read .../merged.lef def read .../<design>.floorplan.def
```

![magic_io_cells](https://github.com/pitman75/vsd-hdp/assets/12179612/2cfdbb78-e5da-4334-b1ca-be6dba90e7cd)


**Bind netlist with physical cells**

 - Get cell actual layout
 - Get Cell actual timing

**Optimize Placement**

 - Estimate wire length and capcitance, then insert buffer (repeater) to adjust timing
 - Quick Timing Analysis with ideal clocks

**Placement workflow**

```
$ ./flow.tcl -interactive
% package require openlane 0.9
% prep -design picorv32a
% run_synthesis
% run_floorplan
% run_placement
```

![picorv32a_placement_log](https://github.com/pitman75/vsd-hdp/assets/12179612/5997a886-4cd4-44b3-80c5-75a1b2b311ae)

Magic open DEF file by command:

```
$ magic -T sky130A.tech lef read .../merged.lef def read .../<design>.placement.def
```

Fullview of the chip layout

![picorv32a_placement_fullview](https://github.com/pitman75/vsd-hdp/assets/12179612/5604ff30-5fd9-48a0-ad7e-8fbae863142c)

Zoom to the chip

![picorv32a_placement_detailview](https://github.com/pitman75/vsd-hdp/assets/12179612/77cbc992-4bfb-4d55-957b-be3d5e73487e)

### Cell-Design Flow

Analysis different function, size, Vt lead to corresponding delay, power, area
 - Cell-Design Input: PDKs
   - DRC & LVS rules (Tech-File)
   - SPICE models (SPICE parameters)
   - User-Defined Spec.
      - Cell-Height(Width)
      - Supply Voltage
      - Metal Layers
      - Pin Location
      - Drawn Gate-Length

 - Cell-Deisgn Steps:
   - Circuit Design:
     - Circuit Function
     - PMOS/NMOS Modelling
   - Layout Design:
     - Desire PMOS/NMOS network graph
     - Apply Euler's Path (Go-Through Once) and stick diagram
   - Characterization
     - Extract to SPICE netlist from layout information
     - Software: GUNA
     - Timing Threshold Definitions(for Buffer):
       - slew_low_rise
       - slew_high_rise
       - slew_low_fall
       - slew_high_fall
       - in_rise
       - in_fall
       - out_rist
       - out_fall
     - Propagation Delay:
       - Rise: out_rise-in_rise
       - Fall: out_fall-in_fall
     - Transition Time:
       - Rise: slew_high_rise-slew_low_rise
       - Fall: slew_low_fall-slew_high_fall
         
 - Cell-Design Output:
    - CDL (Circuit Description Language)
    - GDS-II, LEF, Extraced SPICE Netlist
    - Timing, Noise, Power, .libs, Function

</details>

## Day 17 - Design and characterize one library cell using Magic Layout tool and ngspice

<details>
<summary>details...</summary>
	
1. CMOS Process Introduction
2. Cell-Design for SPICE Extration


**OpenLane Operation**

Change IO pins place mode

make io-placer stack as std-cells

```
% set ::env(FP_IO_MODE) 2
% run floorplan
```

### 16-Mask CMOS Process

 - Select a substract (P-type, high resistivity (5~50ohms), doping level(10**13 cm**2), orientation(100))
   - Substract doping should be less than well doping
  
 - Create active region for transistors
   - ~40nm of SiO2 + ~80nm of Si3N4 + ~1um Photo-Resist
   - Mask1 + UV-Light
   - Washed out + Si3N4 Etched
   - Photo-Resist Chemically Removed, residue SI3N4and SiO2
   - Placed in oxidation furnace, field of SiO2 is grownn for isolation area
     - LOCOS, local oxidation of silicon
   - Si3N4 stripped by using hot phosphoric acid
 
 - N-Well and P-Well Formation
   - Photo-Resist + Mask2 + UV-Light + Wash-OUt
   - Ion Implantation (Boron, ~200KeV), formating P-Well + Si3N4 etched
   - Photo-Resist + Mask3 + UV-Light + Wash-Out
   - Ion Implantation (Phosphorous, ~400KeV), formating N-Well + Si3N4 etched
   - High Temperature Furnace, drive-in diffusion

 - Formation of Gate (Na(doping concentration), Cox(oxide capcitance)) -> Control Vt
   - Photo-Resist + Mask4
   - Ion Implantation (Boron, ~60KeV) on P-Well Region (P-Layer)
   - Photo-Resist + Mask5
   - Ion Implantation (Arsenic) on N-Well Region (N-Layer)
   - Origional Oxide etched/stripped by using dilute hydrofluoric (HF) solution
   - Re-grown high quality oxide layer (~10um thin), remove defected by process
   - ~0.4um polysilicon layer
   - Photo-Resist + Mask6 to mark Gate area
   - Wash-Out polysilicon with UV-Light

 - Lightly Doped Drain (LDD) Formation
   - Photo-Resist + Mask7, Phosphorous(lightly doped) in P-Well to form N-implant region around Gate
   - Photo-Resist + Mask8, Boron(lightly doped) in N-Well to form P-implant region around Gate
   - ~0.1um Si3N4 or SiO2 + Plasma anisotropic etching, add side-wall spacer

 - Source and Drain Formation
   - Photo-Resist + Mask9, Arsenic(75KeV, N+ implant) in P-Well Region, enhance LDD region
   - Photo-Resist + Mask10, Boron(50KeV, P+ implant) in N-Well Region, enhance LDD region
   - High Temperature furnace, high temperature annealing

 - Form contacts and interconnections (local)
   - Etch thin oxide in HF Solution
   - Deposit titanium(very low resistance) on wafer surface, using sputtering
     - sputtering: Argon(Ar+) gas to smash Ti to spreading on substrate
   - Wafer heated at about 650~700 C-degree, with N2 ambient for 60 secs, result low resistant TiSi2 (low resistant from SiO2 on Gate) and TiN (local-layer)
   - Photo-Resist + Mask11, form local TiN connections
   - TiN is etched using RCA cleaning, form required local connections under mask11
 - Higher Level Metal Formation
   - 1um of SiO2, which doped with phosphorous or boron, deposited on wafer surface
   - Chemical mechanical polishing (CMP) technique for planarizing wafer surface
   - Photo-Resist + Mask12, etch vertical contact path to local TiN
   - Aluminum (Al) layer deposition
   - Photo-Resist + Mask13, then Plasma-Etch Al layer
   - SiO2 surface deposit + Mask14 for contact holes + TiN with Tungsten + Al-layer
   - repeat to Mask15, final with dielectric (Si3N4) to protect the chip
   - Use Mask16 to etch contact hole to bond-wire connect pin

### Lab on Extracting SPICE form Layout

Clone Git repo to working folder `git clone https://github.com/nickson-jose/vsdstdcelldesign`

Open inverter cell design 'magic -T ./libs/sky130A.tech sky130_inv.mag &'

![sky130_inv](https://github.com/pitman75/vsd-hdp/assets/12179612/8a3b91a9-7137-441c-b284-6c9e69e4ed5c)


Technology LEF: only available metal layer, via/contact information and DRC for placer and router. To characterize we need information about capacitance, resistance, etc. Extract SPICE in magic tkcon:

 - `% extract all` to create and extract parameters and write to a sky130_inv.ext file
 - `% ext2spice cthresh 0 rthresh 0` to extract parasitic parameters
 - `% ext2spice` to write spice file sky130_inv.spice

![sky130_inv_extract_spice](https://github.com/pitman75/vsd-hdp/assets/12179612/2302f146-3c9d-4393-b8f0-b010bd581e73)

Modify SPICE file for simulation

**remove or comment**

 - `.subckt ...` line
 - `.ends` line

**change scale**

 - `.option scale=1000` -> `scale=0.01u`

**add model library**

 - `.include ./libs/pshort.lib`
 - `.include ./libs/nshort.lib`

**modify model name**

 - `pshort` -> `pshort_model.0`
 - `nshort` -> `nshort_model.0`

**add VDD/GND/Vin**

 - `VDD VPWR 0 3.3V`
 - `VSS VGND 0 0V`
 - `Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)`

**add analysis command**

```
    .tran 1n 20n
    .control
    run
    .endc
    .end
```

**increase load capacitance***

 - `C3 Y VGND 0.279f` -> `C3 Y VGND 20f`

![sky130_inv_spice](https://github.com/pitman75/vsd-hdp/assets/12179612/df191746-ab03-4126-960c-eac0bb571a58)

**perform ngspice simulation**

```
  $ ngspice sky130_inv.spice
  > plot y vs tims a
```

![sky130_inv_transient](https://github.com/pitman75/vsd-hdp/assets/12179612/9bbaba92-99a0-4ccd-9085-a5a296260fec)


**Result**

 - Rise time: 450ps
 - Fall time: 143.84ps
 - Propogation rise delay: 303.93ps
 - Propogation fall delay: 121ps


### Magic DRC
        
 - Website: opencircuitdesign.com/magic/
 - Technology File: Magic Technology File Format
   - DRC section
   - Cifoutput section
 - Lab-File: http://opencircuitdesign.com/open_pdks/archive/drc_test.tgz

`$ magic -d XR`

"Open" -> "met3.mag", errors in SkyWater SKY130 Process Design Rules, Periphery Rules
fix poly.9 error => poly and polyres are too close
reload magic tech file
`% tech load sky130A.tech`

</details>

## Day 18 - Pre-layout timing analysis and importance of good clock tree

<details>
<summary>details...</summary>

### Add custom cell to a design

**Convert grid info to track info**

 - LEF file: reduced GDS information, only contains ports(power, ground, input, output) for digital PnR flow.
 - Guide-Line
   - input/output port must line-up on the intersection of horizontal/vertical tracks
   - width/height of standard cell should be multiple of horizontal/vertical pitch

 - pdks/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info
   - li1 X 0.23 0.46 # Horizontal Track(0.23) Pitch(0.46)
   - li1 Y 0.17 0.34 # Vertical   Track(0.17) Pitch(0.34)
 - adjust magic grid display
   - `% grid 0.46um 0.34um 0.23um 0.17um`

**Set label for ports, class and use**

 - Select area locali for input/output ports and metal1 for power/ground and add label with properties
 - Add class
 - Add use

![set_port_class_use](https://github.com/pitman75/vsd-hdp/assets/12179612/46ee3fb1-eb0d-4641-8dfe-3855fdd9194c)

**Generate a LEF file**

 - `% lef write`

![lef_write](https://github.com/pitman75/vsd-hdp/assets/12179612/3117e7ca-dcae-4bff-8cd4-a1ff8d8b6c65)

The LEF file content
 
![lef_file](https://github.com/pitman75/vsd-hdp/assets/12179612/df99f278-6bda-4b24-968e-33940675319e)

**Include new cell in synthesis*

 - copy sky130_vsdinv.lef to picorv32a/src
 - copy timing libs (sky130_fd_sc_hd__fast/slow/typical.lib) to picorv32a/src
 - modify config.tcl
   - add custom timing libraries
   - add import lef command
  
![config_tcl_with_new_cell](https://github.com/pitman75/vsd-hdp/assets/12179612/fa5b2013-6104-48aa-b8b1-84fdbf927ed0)

Prepare picorv32a design with our new cell

![add_cell_prep_design_merge_lef](https://github.com/pitman75/vsd-hdp/assets/12179612/b06d3d9d-73d9-4b9b-9a59-a2acfdb86767)

Synthesis picorv32a design with our new cell

![add_cell_synthesis](https://github.com/pitman75/vsd-hdp/assets/12179612/7683d6ec-ac63-4e9e-a0df-cc009d4da844)

Bingo! Our new cell exist in the design.

### Introduction to delay tables

 - Power Aware CTS -> Apply clock-gating cells to disable circuit switching while gated
 - Observation:
   - At every level, each node driving same load
   - Identical buffer at same level
 - Practical:
   - Apply delay table to adjust buffer performance to meet timing
 - If input-slew/output-load in the middle of table elements, derive result by linear approximation

### Synthesis/Floorpla/Placement with custom cell

**Fix slack from new vsdinv cell**

The design has big negative slack violation. Let's fix it.

 - Read synthesis strategy `echo $::env(SYNTH_STRATEGY)` -> `AREA 0`
 - Change to delay optimization `set ::env(SYNTH_STRATEGY) "DELAY 1"`
 - Read synthesis buffering option `echo $::env(SYNTH_BUFFERING)` -> `1` it's OK
 - Read synthesis sizing option `echo $::env(SYNTH_SIZING)` -> '0' disabled.
 - Enable sizing for cells `set ::env(SYNTH_SIZING) 1`
 - Read synthesis driving cell option `echo $::env(SYNTH_DRIVING_CELL)` -> `sky130_fd_sc_hd__inv_8` it's OK

 Start synthesis and compare result

 ![synt_with_custom_after_optimization](https://github.com/pitman75/vsd-hdp/assets/12179612/c28a18eb-6c37-4af6-aa62-7296cb7de0f4)

 After optimization the result looks acceptable. But I found bad define of period for the core. It should be 80ns for 12.5MHz but wrote 12.5ns for 83MHz. Fix it and determine how to change szie of the chip area and number of our invertos when we use some optimization strategy.

The chip area vs synthesis strategy

![chiparea_vs_strategy](https://github.com/pitman75/vsd-hdp/assets/12179612/75d2b8e4-82a6-47f3-926c-327896b863e3)

How many custom inverters vs synthesis strategy

![invertors_vs_strategy](https://github.com/pitman75/vsd-hdp/assets/12179612/e6dda213-decd-4266-9cfb-6304b90c733b)

Small size of a chip area will reduce cost. New configurate file is:

![config_fix_freq_area_optimization](https://github.com/pitman75/vsd-hdp/assets/12179612/5f3b4e91-6e88-4236-b0ee-55b07f90b5c1)

Lets build a chip

**Workflow:**

```
$ ./flow.tcl -interactive
% package require openlane 0.9
% prep -design picorv32a
% run_synthesis
% run_floorplan
```

The floorplan process generate an error and exit from the process.

![floorplan_error](https://github.com/pitman75/vsd-hdp/assets/12179612/6503fc82-5aea-4c19-840c-ad16ea1522df)

No any macro defined for the design. To mitigate that error I use floorplan/placement workflow without macro placement:

```
$ ./flow.tcl -interactive
% package require openlane 0.9
% prep -design picorv32a
% run_synthesis
% init_floorplan
% place_io
% global_placement_or
% detailed_placement
% tap_decap_or
% detailed_placement
```

![floorplan_skip_macro_result](https://github.com/pitman75/vsd-hdp/assets/12179612/c6412678-b751-4f58-a254-f9bd04cc975a)

Done. I have a chip layout. Let's see it by a command

`~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/runs/25-03_15-10/results/placement$ magic -T /home/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.lef def read picorv32a.placement.def &`

The chip layout is:

![vsdinv_chip_layout_all](https://github.com/pitman75/vsd-hdp/assets/12179612/57407996-99f6-4109-8725-6c4dca755a8d)

VSD_inv custom cell in the chip

![vsdinv_in_the_chip](https://github.com/pitman75/vsd-hdp/assets/12179612/6973212c-2f81-4c77-a161-7ec87a32eee1)

### Timing Analysis (Ideal Clock)

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/3eb68a76-245f-4bfb-b91f-19741181e447)

 - Skew: Physical buffer unbalance between sequential logics
 - Td1: Clock-Net to launch FF clock-pin delay
 - Td2: Clock-Net to capture FF clock-pin delay
 - H: capture FF hold-time
 - Setup Analysis: (Tc+Td1) < (T+Td2-Ts-Tsu)
 - Slack (setup) : Data Require Time (T+Td2-Ts-Tsu) - Data Arrival Time (Tc+Td1)
 - Hold Analysis: (Tc+Td1) > (H + Td2)
 - Slack (hold) : Data Arrival Time (Tc+Td1) - Data Require Time (H + Td2)

Let's do an example for STA and fine tune of design. Clock of this design will be higher than in previouse. Set clock period to 12ns (~83.4MHz) and synthesis strategy as `DELAY 1`. Synthesis and do CTS of the design.

Fast picorv32a configuration file

![fast_12ns_picorv32a_config](https://github.com/pitman75/vsd-hdp/assets/12179612/41b3b0c5-016c-4f88-883b-8512bdf7c4f6)

<details>
	<summary>Synthesis report</summary>

```
28. Printing statistics.

=== picorv32a ===

   Number of wires:              22757
   Number of wire bits:          23139
   Number of public wires:        1565
   Number of public wire bits:    1947
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:              23037
     sky130_fd_sc_hd__a2111o_2       7
     sky130_fd_sc_hd__a2111oi_2      1
     sky130_fd_sc_hd__a211o_2       48
     sky130_fd_sc_hd__a211oi_2       7
     sky130_fd_sc_hd__a21bo_2       44
     sky130_fd_sc_hd__a21boi_2     125
     sky130_fd_sc_hd__a21o_2       582
     sky130_fd_sc_hd__a21oi_2     1078
     sky130_fd_sc_hd__a221o_2       82
     sky130_fd_sc_hd__a221oi_2       4
     sky130_fd_sc_hd__a22o_2       226
     sky130_fd_sc_hd__a22oi_2      305
     sky130_fd_sc_hd__a2bb2o_2      24
     sky130_fd_sc_hd__a2bb2oi_2     17
     sky130_fd_sc_hd__a311o_2       17
     sky130_fd_sc_hd__a31o_2        95
     sky130_fd_sc_hd__a31oi_2       95
     sky130_fd_sc_hd__a32o_2        41
     sky130_fd_sc_hd__a32oi_2       15
     sky130_fd_sc_hd__a41o_2        11
     sky130_fd_sc_hd__a41oi_2        5
     sky130_fd_sc_hd__and2_2       492
     sky130_fd_sc_hd__and2b_2       23
     sky130_fd_sc_hd__and3_2       411
     sky130_fd_sc_hd__and3b_2        7
     sky130_fd_sc_hd__and4_2        76
     sky130_fd_sc_hd__and4b_2        3
     sky130_fd_sc_hd__buf_1       1646
     sky130_fd_sc_hd__buf_2         12
     sky130_fd_sc_hd__conb_1        42
     sky130_fd_sc_hd__dfxtp_2     1613
     sky130_fd_sc_hd__inv_2         97
     sky130_fd_sc_hd__mux2_1      1224
     sky130_fd_sc_hd__mux2_2       902
     sky130_fd_sc_hd__mux4_1       221
     sky130_fd_sc_hd__nand2_2     3394
     sky130_fd_sc_hd__nand2b_2       2
     sky130_fd_sc_hd__nand3_2     2128
     sky130_fd_sc_hd__nand3b_2     317
     sky130_fd_sc_hd__nor2_2      1887
     sky130_fd_sc_hd__nor2b_2       10
     sky130_fd_sc_hd__nor3_2        61
     sky130_fd_sc_hd__nor3b_2        7
     sky130_fd_sc_hd__o2111a_2      15
     sky130_fd_sc_hd__o2111ai_2     74
     sky130_fd_sc_hd__o211a_2      338
     sky130_fd_sc_hd__o211ai_2     249
     sky130_fd_sc_hd__o21a_2       156
     sky130_fd_sc_hd__o21ai_2     1040
     sky130_fd_sc_hd__o21ba_2       17
     sky130_fd_sc_hd__o21bai_2     151
     sky130_fd_sc_hd__o221a_2       44
     sky130_fd_sc_hd__o221ai_2      11
     sky130_fd_sc_hd__o22a_2        38
     sky130_fd_sc_hd__o22ai_2      264
     sky130_fd_sc_hd__o2bb2a_2      25
     sky130_fd_sc_hd__o2bb2ai_2    323
     sky130_fd_sc_hd__o311a_2        3
     sky130_fd_sc_hd__o311ai_2       2
     sky130_fd_sc_hd__o31a_2        14
     sky130_fd_sc_hd__o31ai_2        4
     sky130_fd_sc_hd__o32a_2        12
     sky130_fd_sc_hd__o32ai_2        2
     sky130_fd_sc_hd__or2_2        387
     sky130_fd_sc_hd__or2b_2        28
     sky130_fd_sc_hd__or3_2         64
     sky130_fd_sc_hd__or3b_2        10
     sky130_fd_sc_hd__or4_2         70
     sky130_fd_sc_hd__or4b_2         3
     sky130_fd_sc_hd__xnor2_2       36
     sky130_fd_sc_hd__xor2_2        86
     sky130_vsdinv                2167

   Chip area for module '\picorv32a': 209179.369600

tns -266.36
wns -2.95
```
</details>

Define STA workflow in a file `pre_sta.tcl`

```
set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um
read_liberty -max ~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/src/sky130_fd_sc_hd__slow.lib
read_liberty -min ~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/src/sky130_fd_sc_hd__fast.lib
read_verilog ~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis.v
link_design picorv32a
read_sdc ~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/src/picorv32a_synth.sdc
report_checks -path_delay min_max -fields {slew trans net cap input_pin} -digits {4} > sta_out_report.txt
report_worst_slack -max -digits {4} > sta_out_slack_max.txt
report_worst_slack -min -digits {4} > sta_out_slack_min.txt
report_tns -digits {4} > sta_out_tns.txt
report_wns -digits {4} > sta_out_wns.txt 
```

Define STA constrains in a file `picorv32a_synth.sdc`

```
set ::env(CLOCK_PORT) clk
set ::env(CLOCK_PERIOD) 12.000
set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_8
set ::env(SYNTH_DRIVING_CELL_PIN) Y
set ::env(SYNTH_CAP_LOAD) 17.65

create_clock [get_ports $::env(CLOCK_PORT)] -name $::env(CLOCK_PORT) -period $::env(CLOCK_PERIOD)

set IO_PCT 0.2
set input_delay_value [expr $::env(CLOCK_PERIOD) * $IO_PCT]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $IO_PCT]
puts "\[INFO\]: Setting input delay to : $input_delay_value"
puts "\[INFO\]: Setting output delay to: $output_delay_value"

set clk_indx [lsearch [all_inputs] [get_port $::env(CLOCK_PORT)]]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx]
set all_inputs_wo_clk_rst $all_inputs_wo_clk

set_input_delay $input_delay_value -clock [get_clocks $::env(CLOCK_PORT)] $all_inputs_wo_clk_rst
set_output_delay $output_delay_value -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]

set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
set_load $cap_load [all_outputs]
```

<details>
	<summary>STA report</summary>

```
Startpoint: _42991_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _42991_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: min

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                    0.0000    0.0000    0.0000 ^ _42991_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.0259    0.1814    0.1814 ^ _42991_/Q (sky130_fd_sc_hd__dfxtp_2)
     2    0.0039                                 cpuregs[0][0] (net)
                    0.0259    0.0000    0.1814 ^ _24201_/A (sky130_fd_sc_hd__buf_1)
                    0.0244    0.0445    0.2259 ^ _24201_/X (sky130_fd_sc_hd__buf_1)
     1    0.0017                                 _02835_ (net)
                    0.0244    0.0000    0.2259 ^ _42991_/D (sky130_fd_sc_hd__dfxtp_2)
                                        0.2259   data arrival time

                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                              0.0000    0.0000   clock reconvergence pessimism
                                        0.0000 ^ _42991_/CLK (sky130_fd_sc_hd__dfxtp_2)
                             -0.0176   -0.0176   library hold time
                                       -0.0176   data required time
-------------------------------------------------------------------------------------
                                       -0.0176   data required time
                                       -0.2259   data arrival time
-------------------------------------------------------------------------------------
                                        0.2435   slack (MET)


Startpoint: _42923_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _42703_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                    0.0000    0.0000    0.0000 ^ _42923_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    1.0128    1.3053    1.3053 ^ _42923_/Q (sky130_fd_sc_hd__dfxtp_2)
    39    0.1286                                 cpu_state[3] (net)
                    1.0128    0.0000    1.3053 ^ _42093_/S (sky130_fd_sc_hd__mux2_1)
                    8.5238    6.5575    7.8628 ^ _42093_/X (sky130_fd_sc_hd__mux2_1)
   161    0.6287                                 _00357_ (net)
                    8.5238    0.0000    7.8628 ^ _42583_/S0 (sky130_fd_sc_hd__mux4_1)
                    0.1783    2.5088   10.3715 v _42583_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0013                                 _00361_ (net)
                    0.1783    0.0000   10.3715 v _42586_/A1 (sky130_fd_sc_hd__mux4_1)
                    0.1429    1.1427   11.5142 v _42586_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0018                                 _00365_ (net)
                    0.1429    0.0000   11.5142 v _42088_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.1312    0.7029   12.2172 v _42088_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0042                                 _00370_ (net)
                    0.1312    0.0000   12.2172 v _21611_/B (sky130_fd_sc_hd__nand2_2)
                    0.1121    0.1593   12.3765 ^ _21611_/Y (sky130_fd_sc_hd__nand2_2)
     3    0.0095                                 _18852_ (net)
                    0.1121    0.0000   12.3765 ^ _26224_/B2 (sky130_fd_sc_hd__o221a_2)
                    0.0684    0.3728   12.7493 ^ _26224_/X (sky130_fd_sc_hd__o221a_2)
     1    0.0015                                 _01718_ (net)
                    0.0684    0.0000   12.7493 ^ _41953_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0701    0.2078   12.9571 ^ _41953_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 _01719_ (net)
                    0.0701    0.0000   12.9571 ^ _26231_/A1_N (sky130_fd_sc_hd__a2bb2o_2)
                    0.0757    0.5162   13.4733 v _26231_/X (sky130_fd_sc_hd__a2bb2o_2)
     1    0.0021                                 _04118_ (net)
                    0.0757    0.0000   13.4733 v _26232_/C1 (sky130_fd_sc_hd__a311o_2)
                    0.0816    0.5646   14.0379 v _26232_/X (sky130_fd_sc_hd__a311o_2)
     1    0.0015                                 _01720_ (net)
                    0.0816    0.0000   14.0379 v _41548_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.1000    0.6111   14.6490 v _41548_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0016                                 _21109_ (net)
                    0.1000    0.0000   14.6490 v _42703_/D (sky130_fd_sc_hd__dfxtp_2)
                                       14.6490   data arrival time

                    0.0000   12.0000   12.0000   clock clk (rise edge)
                              0.0000   12.0000   clock network delay (ideal)
                              0.0000   12.0000   clock reconvergence pessimism
                                       12.0000 ^ _42703_/CLK (sky130_fd_sc_hd__dfxtp_2)
                             -0.3058   11.6942   library setup time
                                       11.6942   data required time
-------------------------------------------------------------------------------------
                                       11.6942   data required time
                                      -14.6490   data arrival time
-------------------------------------------------------------------------------------
                                       -2.9549   slack (VIOLATED)
```
</details>

Reduce fanout option to 4, new `config.tcl` is:

```
set ::env(DESIGN_NAME) "picorv32a"

set ::env(VERILOG_FILES) "./designs/picorv32a/src/picorv32a.v"
set ::env(SDC_FILE) "./designs/picorv32a/src/picorv32a.sdc"

set ::env(CLOCK_PERIOD) "12.000"
set ::env(CLOCK_PORT) "clk"

set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set ::env(LIB_SYNTH) "$::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/sky130_fd_sc_hd__typical.lib"
set ::env(LIB_FASTEST) "$::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/sky130_fd_sc_hd__fast.lib"
set ::env(LIB_SLOWEST) "$::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/sky130_fd_sc_hd__slow.lib"
set ::env(LIB_TYPICAL) "$::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/sky130_fd_sc_hd__typical.lib"

set ::env(EXTRA_LEFS) [glob $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/*.lef]

set ::env(SYNTH_STRATEGY) "DELAY 1"
set ::env(SYNTH_SIZING) 1
set ::env(SYNTH_MAX_FANOUT) 4

set filename $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
} 
```

<details>
	<summary>STA report</summary>

```
Startpoint: _42991_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _42991_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: min

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                    0.0000    0.0000    0.0000 ^ _42991_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.0259    0.1814    0.1814 ^ _42991_/Q (sky130_fd_sc_hd__dfxtp_2)
     2    0.0039                                 cpuregs[0][0] (net)
                    0.0259    0.0000    0.1814 ^ _24201_/A (sky130_fd_sc_hd__buf_1)
                    0.0244    0.0445    0.2259 ^ _24201_/X (sky130_fd_sc_hd__buf_1)
     1    0.0017                                 _02835_ (net)
                    0.0244    0.0000    0.2259 ^ _42991_/D (sky130_fd_sc_hd__dfxtp_2)
                                        0.2259   data arrival time

                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                              0.0000    0.0000   clock reconvergence pessimism
                                        0.0000 ^ _42991_/CLK (sky130_fd_sc_hd__dfxtp_2)
                             -0.0176   -0.0176   library hold time
                                       -0.0176   data required time
-------------------------------------------------------------------------------------
                                       -0.0176   data required time
                                       -0.2259   data arrival time
-------------------------------------------------------------------------------------
                                        0.2435   slack (MET)


Startpoint: _42923_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _42703_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                    0.0000    0.0000    0.0000 ^ _42923_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    1.0128    1.3053    1.3053 ^ _42923_/Q (sky130_fd_sc_hd__dfxtp_2)
    39    0.1286                                 cpu_state[3] (net)
                    1.0128    0.0000    1.3053 ^ _42093_/S (sky130_fd_sc_hd__mux2_1)
                    8.5238    6.5575    7.8628 ^ _42093_/X (sky130_fd_sc_hd__mux2_1)
   161    0.6287                                 _00357_ (net)
                    8.5238    0.0000    7.8628 ^ _42583_/S0 (sky130_fd_sc_hd__mux4_1)
                    0.1783    2.5088   10.3715 v _42583_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0013                                 _00361_ (net)
                    0.1783    0.0000   10.3715 v _42586_/A1 (sky130_fd_sc_hd__mux4_1)
                    0.1429    1.1427   11.5142 v _42586_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0018                                 _00365_ (net)
                    0.1429    0.0000   11.5142 v _42088_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.1312    0.7029   12.2172 v _42088_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0042                                 _00370_ (net)
                    0.1312    0.0000   12.2172 v _21611_/B (sky130_fd_sc_hd__nand2_2)
                    0.1121    0.1593   12.3765 ^ _21611_/Y (sky130_fd_sc_hd__nand2_2)
     3    0.0095                                 _18852_ (net)
                    0.1121    0.0000   12.3765 ^ _26224_/B2 (sky130_fd_sc_hd__o221a_2)
                    0.0684    0.3728   12.7493 ^ _26224_/X (sky130_fd_sc_hd__o221a_2)
     1    0.0015                                 _01718_ (net)
                    0.0684    0.0000   12.7493 ^ _41953_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0701    0.2078   12.9571 ^ _41953_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 _01719_ (net)
                    0.0701    0.0000   12.9571 ^ _26231_/A1_N (sky130_fd_sc_hd__a2bb2o_2)
                    0.0757    0.5162   13.4733 v _26231_/X (sky130_fd_sc_hd__a2bb2o_2)
     1    0.0021                                 _04118_ (net)
                    0.0757    0.0000   13.4733 v _26232_/C1 (sky130_fd_sc_hd__a311o_2)
                    0.0816    0.5646   14.0379 v _26232_/X (sky130_fd_sc_hd__a311o_2)
     1    0.0015                                 _01720_ (net)
                    0.0816    0.0000   14.0379 v _41548_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.1000    0.6111   14.6490 v _41548_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0016                                 _21109_ (net)
                    0.1000    0.0000   14.6490 v _42703_/D (sky130_fd_sc_hd__dfxtp_2)
                                       14.6490   data arrival time

                    0.0000   12.0000   12.0000   clock clk (rise edge)
                              0.0000   12.0000   clock network delay (ideal)
                              0.0000   12.0000   clock reconvergence pessimism
                                       12.0000 ^ _42703_/CLK (sky130_fd_sc_hd__dfxtp_2)
                             -0.3058   11.6942   library setup time
                                       11.6942   data required time
-------------------------------------------------------------------------------------
                                       11.6942   data required time
                                      -14.6490   data arrival time
-------------------------------------------------------------------------------------
                                       -2.9549   slack (VIOLATED) 
```
</details>



One common reason could a large output slew for a net due to large capacitance load/ fanout which the synthesis tool could not optimize further. In this case a cell drives more cells then we can upsize that cell so that slack can be reduced. For upsizing we have to replace that cell with a more drive strength cell to reduce the delay using the replace_cell command.

```
Syntax : replace_cell instance lib_cell
Example: replace_cell _44195_ sky130_fd_sc_hd__inv_4
       where, _44195_ is the instance name of the cell to be replaced
              sky130_fd_sc_hd__inv_4 is the upsized std cell version
```

To check if the violation has been resolved: `report_checks -from  -to  -through  -path_delay max`
Example: `report_checks -from _50144_ -to _50075_ -through _44195_ -path_delay min_max`

Slack reduced but not enought. Also I see huge load for one element. It's _42093_. It should drive 161 input. Wow. Synthesis strategy is "DELAY 1" doesn't work properly with option SYNTH_MAX_FANOUT. To reduce slack mannualy we replace some cells to bugger version.

![cell_replacement](https://github.com/pitman75/vsd-hdp/assets/12179612/8f6bdbc0-4881-479e-8e6e-c84469d48474)

<details>
	<summary>STA report</summary>
	
```
Startpoint: _42991_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _42991_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: min

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                    0.0000    0.0000    0.0000 ^ _42991_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.0259    0.1814    0.1814 ^ _42991_/Q (sky130_fd_sc_hd__dfxtp_2)
     2    0.0039                                 cpuregs[0][0] (net)
                    0.0259    0.0000    0.1814 ^ _24201_/A (sky130_fd_sc_hd__buf_1)
                    0.0244    0.0445    0.2259 ^ _24201_/X (sky130_fd_sc_hd__buf_1)
     1    0.0017                                 _02835_ (net)
                    0.0244    0.0000    0.2259 ^ _42991_/D (sky130_fd_sc_hd__dfxtp_2)
                                        0.2259   data arrival time

                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                              0.0000    0.0000   clock reconvergence pessimism
                                        0.0000 ^ _42991_/CLK (sky130_fd_sc_hd__dfxtp_2)
                             -0.0176   -0.0176   library hold time
                                       -0.0176   data required time
-------------------------------------------------------------------------------------
                                       -0.0176   data required time
                                       -0.2259   data arrival time
-------------------------------------------------------------------------------------
                                        0.2435   slack (MET)


Startpoint: _44218_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _44144_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                    0.0000    0.0000    0.0000   clock clk (rise edge)
                              0.0000    0.0000   clock network delay (ideal)
                    0.0000    0.0000    0.0000 ^ _44218_/CLK (sky130_fd_sc_hd__dfxtp_4)
                    0.5063    0.9988    0.9988 ^ _44218_/Q (sky130_fd_sc_hd__dfxtp_4)
    33    0.1118                                 latched_stalu (net)
                    0.5063    0.0000    0.9988 ^ _42119_/S (sky130_fd_sc_hd__mux2_4)
                    0.0834    0.6879    1.6867 v _42119_/X (sky130_fd_sc_hd__mux2_4)
     2    0.0040                                 _00293_ (net)
                    0.0834    0.0000    1.6867 v _42118_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.0969    0.6282    2.3149 v _42118_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0014                                 _00294_ (net)
                    0.0969    0.0000    2.3149 v _25347_/B (sky130_fd_sc_hd__and2_2)
                    0.0659    0.3947    2.7095 v _25347_/X (sky130_fd_sc_hd__and2_2)
     1    0.0018                                 _00295_ (net)
                    0.0659    0.0000    2.7095 v _41409_/A0 (sky130_fd_sc_hd__mux2_2)
                    0.1819    0.6554    3.3649 v _41409_/X (sky130_fd_sc_hd__mux2_2)
     7    0.0216                                 _02560_ (net)
                    0.1819    0.0000    3.3649 v _25880_/A (sky130_fd_sc_hd__and2_2)
                    0.0888    0.4246    3.7895 v _25880_/X (sky130_fd_sc_hd__and2_2)
     2    0.0064                                 _20882_ (net)
                    0.0888    0.0000    3.7895 v _25881_/B (sky130_fd_sc_hd__nor2_2)
                    0.2376    0.2283    4.0179 ^ _25881_/Y (sky130_fd_sc_hd__nor2_2)
     2    0.0110                                 _20883_ (net)
                    0.2376    0.0000    4.0179 ^ _25889_/A1 (sky130_fd_sc_hd__a31o_2)
                    0.1385    0.4224    4.4403 ^ _25889_/X (sky130_fd_sc_hd__a31o_2)
     2    0.0110                                 _20888_ (net)
                    0.1385    0.0000    4.4403 ^ _25897_/B1 (sky130_fd_sc_hd__o21a_2)
                    0.0762    0.2789    4.7192 ^ _25897_/X (sky130_fd_sc_hd__o21a_2)
     1    0.0047                                 _20894_ (net)
                    0.0762    0.0000    4.7192 ^ _25898_/B1 (sky130_fd_sc_hd__a21oi_2)
                    0.1770    0.0876    4.8068 v _25898_/Y (sky130_fd_sc_hd__a21oi_2)
     2    0.0122                                 _20895_ (net)
                    0.1770    0.0000    4.8068 v _25903_/B (sky130_fd_sc_hd__nor2_2)
                    0.2353    0.2624    5.0692 ^ _25903_/Y (sky130_fd_sc_hd__nor2_2)
     3    0.0108                                 _20898_ (net)
                    0.2353    0.0000    5.0692 ^ _25917_/A2 (sky130_fd_sc_hd__o21bai_2)
                    0.1405    0.2010    5.2702 v _25917_/Y (sky130_fd_sc_hd__o21bai_2)
     2    0.0087                                 _20910_ (net)
                    0.1405    0.0000    5.2702 v _25926_/A1 (sky130_fd_sc_hd__a21oi_2)
                    0.2441    0.3002    5.5704 ^ _25926_/Y (sky130_fd_sc_hd__a21oi_2)
     2    0.0094                                 _20917_ (net)
                    0.2441    0.0000    5.5704 ^ _25935_/A2 (sky130_fd_sc_hd__o21ai_2)
                    0.1072    0.1882    5.7586 v _25935_/Y (sky130_fd_sc_hd__o21ai_2)
     2    0.0087                                 _20924_ (net)
                    0.1072    0.0000    5.7586 v _25944_/A1 (sky130_fd_sc_hd__a21oi_2)
                    0.2416    0.2838    6.0424 ^ _25944_/Y (sky130_fd_sc_hd__a21oi_2)
     2    0.0092                                 _20931_ (net)
                    0.2416    0.0000    6.0424 ^ _25953_/B2 (sky130_fd_sc_hd__o22ai_2)
                    0.1464    0.2081    6.2505 v _25953_/Y (sky130_fd_sc_hd__o22ai_2)
     2    0.0087                                 _20938_ (net)
                    0.1464    0.0000    6.2505 v _25962_/A1 (sky130_fd_sc_hd__a21oi_2)
                    0.1843    0.2548    6.5053 ^ _25962_/Y (sky130_fd_sc_hd__a21oi_2)
     2    0.0059                                 _20945_ (net)
                    0.1843    0.0000    6.5053 ^ _25964_/B2 (sky130_fd_sc_hd__o22ai_2)
                    0.1293    0.1758    6.6810 v _25964_/Y (sky130_fd_sc_hd__o22ai_2)
     3    0.0070                                 _20947_ (net)
                    0.1293    0.0000    6.6810 v _25974_/A1 (sky130_fd_sc_hd__a21oi_2)
                    0.2635    0.3110    6.9921 ^ _25974_/Y (sky130_fd_sc_hd__a21oi_2)
     3    0.0105                                 _20955_ (net)
                    0.2635    0.0000    6.9921 ^ _25984_/B2 (sky130_fd_sc_hd__o22ai_2)
                    0.1289    0.2047    7.1968 v _25984_/Y (sky130_fd_sc_hd__o22ai_2)
     3    0.0070                                 _20963_ (net)
                    0.1289    0.0000    7.1968 v _25994_/A1 (sky130_fd_sc_hd__a21oi_2)
                    0.2635    0.3109    7.5076 ^ _25994_/Y (sky130_fd_sc_hd__a21oi_2)
     3    0.0105                                 _20971_ (net)
                    0.2635    0.0000    7.5076 ^ _26004_/B2 (sky130_fd_sc_hd__o22ai_2)
                    0.1289    0.2047    7.7123 v _26004_/Y (sky130_fd_sc_hd__o22ai_2)
     3    0.0070                                 _20979_ (net)
                    0.1289    0.0000    7.7123 v _26015_/A1 (sky130_fd_sc_hd__a21oi_2)
                    0.2635    0.3109    8.0232 ^ _26015_/Y (sky130_fd_sc_hd__a21oi_2)
     3    0.0105                                 _20988_ (net)
                    0.2635    0.0000    8.0232 ^ _26025_/B2 (sky130_fd_sc_hd__o22ai_2)
                    0.1539    0.2225    8.2457 v _26025_/Y (sky130_fd_sc_hd__o22ai_2)
     3    0.0098                                 _20996_ (net)
                    0.1539    0.0000    8.2457 v _26044_/B1 (sky130_fd_sc_hd__a22oi_2)
                    0.2412    0.2527    8.4984 ^ _26044_/Y (sky130_fd_sc_hd__a22oi_2)
     2    0.0059                                 _21011_ (net)
                    0.2412    0.0000    8.4984 ^ _26046_/B2 (sky130_fd_sc_hd__o22ai_2)
                    0.1648    0.2236    8.7220 v _26046_/Y (sky130_fd_sc_hd__o22ai_2)
     4    0.0111                                 _21013_ (net)
                    0.1648    0.0000    8.7220 v _26068_/B1 (sky130_fd_sc_hd__a22oi_2)
                    0.2443    0.2588    8.9808 ^ _26068_/Y (sky130_fd_sc_hd__a22oi_2)
     2    0.0060                                 _21031_ (net)
                    0.2443    0.0000    8.9808 ^ _26109_/A2 (sky130_fd_sc_hd__o2111ai_2)
                    0.1981    0.2845    9.2652 v _26109_/Y (sky130_fd_sc_hd__o2111ai_2)
     1    0.0043                                 _21064_ (net)
                    0.1981    0.0000    9.2652 v _26111_/A (sky130_fd_sc_hd__nand2_2)
                    0.1501    0.2072    9.4724 ^ _26111_/Y (sky130_fd_sc_hd__nand2_2)
     4    0.0148                                 _21066_ (net)
                    0.1501    0.0000    9.4724 ^ _26149_/D1 (sky130_fd_sc_hd__o2111ai_2)
                    0.2086    0.2301    9.7026 v _26149_/Y (sky130_fd_sc_hd__o2111ai_2)
     1    0.0043                                 _21096_ (net)
                    0.2086    0.0000    9.7026 v _26151_/A (sky130_fd_sc_hd__nand2_2)
                    0.1769    0.2320    9.9346 ^ _26151_/Y (sky130_fd_sc_hd__nand2_2)
     4    0.0183                                 _21098_ (net)
                    0.1769    0.0000    9.9346 ^ _26153_/A (sky130_fd_sc_hd__nand2_2)
                    0.1146    0.1634   10.0980 v _26153_/Y (sky130_fd_sc_hd__nand2_2)
     3    0.0100                                 _21100_ (net)
                    0.1146    0.0000   10.0980 v _26154_/B_N (sky130_fd_sc_hd__nor2b_2)
                    0.0584    0.3178   10.4158 v _26154_/Y (sky130_fd_sc_hd__nor2b_2)
     1    0.0022                                 _01672_ (net)
                    0.0584    0.0000   10.4158 v _42136_/A1 (sky130_fd_sc_hd__mux2_4)
                    0.0749    0.4550   10.8708 v _42136_/X (sky130_fd_sc_hd__mux2_4)
     1    0.0017                                 _01673_ (net)
                    0.0749    0.0000   10.8708 v _42589_/A1 (sky130_fd_sc_hd__mux4_2)
                    0.1362    0.9731   11.8439 v _42589_/X (sky130_fd_sc_hd__mux4_2)
     1    0.0018                                 _01674_ (net)
                    0.1362    0.0000   11.8439 v _42137_/A0 (sky130_fd_sc_hd__mux2_2)
                    0.0927    0.5500   12.3939 v _42137_/X (sky130_fd_sc_hd__mux2_2)
     1    0.0022                                 _02527_ (net)
                    0.0927    0.0000   12.3939 v _21782_/A2 (sky130_fd_sc_hd__o211a_2)
                    0.0638    0.4379   12.8318 v _21782_/X (sky130_fd_sc_hd__o211a_2)
     1    0.0016                                 _03988_ (net)
                    0.0638    0.0000   12.8318 v _44144_/D (sky130_fd_sc_hd__dfxtp_2)
                                       12.8318   data arrival time

                    0.0000   12.0000   12.0000   clock clk (rise edge)
                              0.0000   12.0000   clock network delay (ideal)
                              0.0000   12.0000   clock reconvergence pessimism
                                       12.0000 ^ _44144_/CLK (sky130_fd_sc_hd__dfxtp_2)
                             -0.2908   11.7092   library setup time
                                       11.7092   data required time
-------------------------------------------------------------------------------------
                                       11.7092   data required time
                                      -12.8318   data arrival time
-------------------------------------------------------------------------------------
                                       -1.1226   slack (VIOLATED) 
```
</details>

Fixing timing violations by ECOs is an iterative cyclical process.

The slack is negative but it will be fixed in PnR. Let's write changed netlist to the file `picorv32a.synthesis.v` :

`write_verilog ~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis.v`


### Clock Tree Synthesis (CTS):

 - Clock Tree Synthesis(CTS) is a process which makes sure that the clock gets distributed evenly to all sequential elements in a design.
 - The goal of CTS is to minimize the clock latency and skew.
 - H-tree calculates the path from all flops and connects the clock to the midpoint of the flops.
 - Buffers (with equal rise and fall time) are added on the H-tree path. The CTS run adds clock buffers, so buffer delays are taken into consideration, and the analysis now deals with real clocks.
 - Setup and hold time slacks can be then analyzed in the post-CTS STA analysis using OpenROAD.
 - All critical (as shielding all is sometimes not possible) clock nets are shielded to prevent coupling with other components, and hence reducing potential of a glitch.
 - A glitch is a serious problem as it can reset memory system and can lead to incorrect functionality in the whole system activity.
 - Crosstalk leads to exponential delta skew, and this is another reason shielding nets is important.

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/60459354-0b76-4eee-beb6-054521db5b7b)

After replacement synthesis file by new fine tuned netlist let's do that workflow for floorplaning, placement and generating clock three:

```
% init_floorplan
% place_io
% global_placement_or
% detailed_placement
% tap_decap_or
% detailed_placement
% run_cts
```

<details>
	<summary>Triton CST report and chip layout image</summary>

```
Startpoint: _43421_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _42902_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

Fanout     Cap    Slew   Delay    Time   Description
-----------------------------------------------------------------------------
                  0.00    0.00    0.00   clock clk (rise edge)
                          0.00    0.00   clock network delay (ideal)
                  0.00    0.00    0.00 ^ _43421_/CLK (sky130_fd_sc_hd__dfxtp_2)
                  0.35    0.83    0.83 ^ _43421_/Q (sky130_fd_sc_hd__dfxtp_2)
     4    0.04                           pcpi_mul.rs2[18] (net)
                  0.35    0.01    0.84 ^ _23438_/A (sky130_fd_sc_hd__buf_1)
                  0.66    0.67    1.51 ^ _23438_/X (sky130_fd_sc_hd__buf_1)
     6    0.04                           _19876_ (net)
                  0.66    0.00    1.51 ^ _23439_/A (sky130_fd_sc_hd__buf_1)
                  0.74    0.81    2.32 ^ _23439_/X (sky130_fd_sc_hd__buf_1)
     6    0.04                           _19877_ (net)
                  0.74    0.00    2.32 ^ _23440_/A (sky130_fd_sc_hd__buf_1)
                  1.04    1.03    3.35 ^ _23440_/X (sky130_fd_sc_hd__buf_1)
     6    0.06                           _19878_ (net)
                  1.04    0.00    3.35 ^ _30533_/A1 (sky130_fd_sc_hd__a22o_2)
                  0.11    0.67    4.02 ^ _30533_/X (sky130_fd_sc_hd__a22o_2)
     2    0.01                           _07986_ (net)
                  0.11    0.00    4.02 ^ _30536_/B1 (sky130_fd_sc_hd__a22o_2)
                  0.19    0.38    4.40 ^ _30536_/X (sky130_fd_sc_hd__a22o_2)
     2    0.02                           _07989_ (net)
                  0.19    0.00    4.40 ^ _30540_/B (sky130_fd_sc_hd__nand3_2)
                  0.20    0.23    4.63 v _30540_/Y (sky130_fd_sc_hd__nand3_2)
     2    0.01                           _07993_ (net)
                  0.20    0.00    4.63 v _30541_/A (sky130_vsdinv)
                  0.28    0.30    4.94 ^ _30541_/Y (sky130_vsdinv)
     3    0.02                           _07994_ (net)
                  0.28    0.00    4.94 ^ _30854_/B (sky130_fd_sc_hd__nand3_2)
                  0.41    0.45    5.39 v _30854_/Y (sky130_fd_sc_hd__nand3_2)
     6    0.03                           _08306_ (net)
                  0.41    0.00    5.39 v _30896_/A (sky130_fd_sc_hd__and3_2)
                  0.12    0.59    5.98 v _30896_/X (sky130_fd_sc_hd__and3_2)
     3    0.01                           _08348_ (net)
                  0.12    0.00    5.98 v _30897_/C (sky130_fd_sc_hd__nor3_2)
                  0.83    0.66    6.64 ^ _30897_/Y (sky130_fd_sc_hd__nor3_2)
     6    0.03                           _08349_ (net)
                  0.83    0.00    6.64 ^ _30898_/B2 (sky130_fd_sc_hd__o22ai_2)
                  0.35    0.55    7.19 v _30898_/Y (sky130_fd_sc_hd__o22ai_2)
     6    0.03                           _08350_ (net)
                  0.35    0.00    7.19 v _31189_/A2 (sky130_fd_sc_hd__a31oi_2)
                  0.32    0.48    7.67 ^ _31189_/Y (sky130_fd_sc_hd__a31oi_2)
     2    0.01                           _08640_ (net)
                  0.32    0.00    7.67 ^ _31192_/B (sky130_fd_sc_hd__nand3_2)
                  0.34    0.41    8.08 v _31192_/Y (sky130_fd_sc_hd__nand3_2)
     5    0.02                           _08643_ (net)
                  0.34    0.00    8.08 v _31506_/B1 (sky130_fd_sc_hd__a22oi_2)
                  0.24    0.33    8.42 ^ _31506_/Y (sky130_fd_sc_hd__a22oi_2)
     1    0.01                           _08956_ (net)
                  0.24    0.00    8.42 ^ _31508_/B (sky130_fd_sc_hd__nand3_2)
                  0.35    0.40    8.82 v _31508_/Y (sky130_fd_sc_hd__nand3_2)
     5    0.03                           _08958_ (net)
                  0.35    0.00    8.82 v _31811_/A2_N (sky130_fd_sc_hd__o2bb2ai_2)
                  0.12    0.38    9.19 v _31811_/Y (sky130_fd_sc_hd__o2bb2ai_2)
     2    0.01                           _09260_ (net)
                  0.12    0.00    9.19 v _31812_/B1 (sky130_fd_sc_hd__a21oi_2)
                  0.34    0.34    9.53 ^ _31812_/Y (sky130_fd_sc_hd__a21oi_2)
     2    0.02                           _09261_ (net)
                  0.34    0.00    9.53 ^ _31816_/A (sky130_fd_sc_hd__nor2_2)
                  0.12    0.23    9.76 v _31816_/Y (sky130_fd_sc_hd__nor2_2)
     3    0.02                           _09265_ (net)
                  0.12    0.00    9.76 v _32435_/C (sky130_fd_sc_hd__nand3_2)
                  0.09    0.14    9.89 ^ _32435_/Y (sky130_fd_sc_hd__nand3_2)
     1    0.00                           _09882_ (net)
                  0.09    0.00    9.89 ^ _32437_/A (sky130_fd_sc_hd__nand3_2)
                  0.17    0.17   10.07 v _32437_/Y (sky130_fd_sc_hd__nand3_2)
     2    0.01                           _09884_ (net)
                  0.17    0.00   10.07 v _33861_/A1 (sky130_fd_sc_hd__a21oi_2)
                  0.30    0.36   10.43 ^ _33861_/Y (sky130_fd_sc_hd__a21oi_2)
     1    0.01                           _11304_ (net)
                  0.30    0.00   10.43 ^ _33863_/B (sky130_fd_sc_hd__nand3_2)
                  1.26    1.08   11.51 v _33863_/Y (sky130_fd_sc_hd__nand3_2)
     6    0.10                           _11306_ (net)
                  1.27    0.04   11.55 v _36624_/A1 (sky130_fd_sc_hd__a21boi_2)
                  0.46    0.81   12.36 ^ _36624_/Y (sky130_fd_sc_hd__a21boi_2)
     4    0.02                           _14059_ (net)
                  0.46    0.00   12.36 ^ _37807_/A2 (sky130_fd_sc_hd__o21bai_2)
                  0.22    0.34   12.70 v _37807_/Y (sky130_fd_sc_hd__o21bai_2)
     3    0.02                           _15238_ (net)
                  0.22    0.00   12.70 v _38358_/A1 (sky130_fd_sc_hd__a21boi_2)
                  0.32    0.40   13.10 ^ _38358_/Y (sky130_fd_sc_hd__a21boi_2)
     2    0.01                           _15787_ (net)
                  0.32    0.00   13.10 ^ _38599_/A2 (sky130_fd_sc_hd__o21ai_2)
                  0.14    0.21   13.31 v _38599_/Y (sky130_fd_sc_hd__o21ai_2)
     1    0.01                           _16027_ (net)
                  0.14    0.00   13.31 v _38600_/B (sky130_fd_sc_hd__xnor2_2)
                  0.21    0.35   13.66 v _38600_/Y (sky130_fd_sc_hd__xnor2_2)
     1    0.02                           _02666_ (net)
                  0.21    0.00   13.66 v _42902_/D (sky130_fd_sc_hd__dfxtp_2)
                                 13.66   data arrival time

                  0.00   12.00   12.00   clock clk (rise edge)
                          0.00   12.00   clock network delay (ideal)
                          0.00   12.00   clock reconvergence pessimism
                                 12.00 ^ _42902_/CLK (sky130_fd_sc_hd__dfxtp_2)
                         -0.35   11.65   library setup time
                                 11.65   data required time
-----------------------------------------------------------------------------
                                 11.65   data required time
                                -13.66   data arrival time
-----------------------------------------------------------------------------
                                 -2.02   slack (VIOLATED)


wns -3.70
tns -445.97
Clock clk
Latency      CRPR       Skew
_43777_/CLK ^
   5.63
_42724_/CLK ^
   1.45      0.00       4.18

[INFO]: Clock Tree Synthesis was successful
[INFO]: Changing layout from /openLANE_flow/designs/picorv32a/runs/fastpico/results/placement/picorv32a.placement.def to /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
[INFO]: Writing Verilog...
[INFO]: current step index: 10
OpenROAD 0.9.0 1415572a73
This program is licensed under the BSD-3 license. See the LICENSE file for details.
Components of this program may be licensed under more restrictive licenses which must be honored.
Notice 0: Reading LEF file:  /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged_unpadded.lef
Notice 0:     Created 13 technology layers
Notice 0:     Created 25 technology vias
Notice 0:     Created 441 library cells
Notice 0: Finished LEF file:  /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged_unpadded.lef
Notice 0: 
Reading DEF file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
Notice 0: Design: picorv32a
Notice 0:     Created 409 pins.
Notice 0:     Created 29628 components and 182841 component-terminals.
Notice 0:     Created 23403 nets and 80327 connections.
Notice 0: Finished DEF file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
[INFO]: Changing netlist from /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis.v to /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis_cts.v
[INFO]: Taking a Screenshot of the Layout Using Klayout...
[INFO]: current step index: 11
Using Techfile: /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/klayout/sky130A.lyt
Using layout file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
[INFO] Reading tech file: /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/klayout/sky130A.lyt
[INFO] Reading Layout file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
[INFO] Writing out PNG screenshot '/openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def.png'
Done
```

![picorv32a cts def](https://github.com/pitman75/vsd-hdp/assets/12179612/bb5b0ecb-8772-45ee-afaa-1af48c8d354c)

</details>

As we see slack is negative but it to be fixed after routing.

### Timing analysis with real clocks using OpenSTA

**Setup timing analysis (single clock, real clock scenario):**

 - Network clk goes through real wires and buffers, which cause delays. D (combinational delay)+ delta1 (time for clk to reach launch flop) < [T (period) + delta2 (time for clk to reach capture flop)]- S (setup: D to clk delay in capture flop) - SU (Setup uncertainty).
 - delta1-delta2 is known as skew (difference in time the clk reaches the two flops).
 - D+delta1 = data arrival time,
 - T+delta2-S-SU = data required time
 - Slack = data required time - data arrival time => slack should be +ve.

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/90483f3b-93ff-441e-a1b0-9f2988903d1a)

**Hold Timing Analysis using Real Clocks**

Hold timing analysis (single clock, ideal scenario):

 - D > H (hold time: clk to Q in capture flop) + HU (hold uncertainty).

Hold timing analysis (single clock, real clock scenario):

 - D + delta1 > H (hold time: clk to Q in capture flop) + delta2 + HU
 - The left hand side is called data arrival time while right hand side is called data required time.
 - In this case, slack = data arrival time - data required time, and slack here should be +ve too.

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/ae693afe-e3a5-4238-91c5-0466eac3d58e)


 - Delta1 and delta2 need to be identified for both setup and hold time analysis.
 - Delta1/delta2 = sum of RC wire delays on path + sum of buffer delays on the path.
 - The difference is that del1 goes to launch flop, while delta2 goes to capture flop (see picture below to understand the difference).

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/3fdf4115-9f48-4d9b-bc60-b325b5beb766)

In OpenLANE, clock tree synthesis is carried out using TritonCTS tool. CTS should always be done after the floorplanning and placement as the CTS is carried out on a placement.def file that is created during placement stage.

If the design produces any setup timing violaions in the analysis, it can be eliminated or reduced using techniques as follows:

 - Increase the clock period (Not always possible as generally operating frequency is freezed in the specifications)
 - Scaling the buffers (Causes increase in design area)
 - Restricting the maximum fan-out of an element.

### Steps to analyze timing with real clocks (Post-CTS STA) using OpenSTA

In OpenRoad, the timing analysis is performed by creating a db file using the LEF and DEF files of the design.

A db creation is a one-time process (unless the def changes). To create the db, invoke OpenRoad from within the OpenLANE shell using openroad. Then from within the OpenRoad shell execute the following commands:

```
% openroad
% read_lef /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged.lef
% read_def /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
% write_db picorv32a_cts.db
```

STA workflow:

```
% read_db picorv32a_cts.db
% read_verilog /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis_cts.v
% read_liberty $::env(LIB_SYNTH_COMPLETE)
% link_design picorv32a
% read_sdc /openLANE_flow/designs/picorv32a/src/picorv32a.sdc
% set_propagated_clock [all_clocks]
% report_checks -path_delay min_max -fields {slew trans net cap input_pin} -format full_clock_expanded -digits 4
```

 - Be sure to perform the timing analysis with the correct library file which was used for CTS (which was the LIB_SYNTH_COMPLETE or the LIB_TYPICAL in our case).
 - Note: for now, CTS does not support multi-corner optimization.

**Steps to observe impact of bigger CTS buffers on setup and hold timing**

 - Modify the CTS_CLK_BUFFER_LIST variable to exclude the sky130_fd_sc_hd__clkbuf_1 cell and re-run CTS again.

Read CTS_CLK_BUFFER_LIST 

```
% echo $::env(CTS_CLK_BUFFER_LIST)
sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8
```

Set update list by cutting one element from the list (`sky130_fd_sc_hd__clkbuf_1` is removed).

```
% set ::env(CTS_CLK_BUFFER_LIST) [lreplace $::env(CTS_CLK_BUFFER_LIST) 0 0]
sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8
```

- Be sure to modify the CURRENT_DEF variable to point to the DEF file after placement before triggering the CTS run.

```
% set ::env(CURRENT_DEF) /openLANE_flow/designs/picorv32a/runs/fastpico/results/placement/picorv32a.placement.def
% run_cts
```

<details>
	<summary>OpenSTA after CTS</summary>

```
% report_checks -path_delay min_max -fields {slew trans net cap input_pin} -format full_clock_expanded -digits 4
Startpoint: _46729_ (rising edge-triggered flip-flop clocked by core_clock)
Endpoint: _46694_ (rising edge-triggered flip-flop clocked by core_clock)
Path Group: core_clock
Path Type: min

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                              0.0000    0.0000   clock core_clock (rise edge)
                              0.0000    0.0000   clock source latency
                    0.0000    0.0000    0.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    0.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0286    0.0943    0.0943 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0046                                 clknet_0_clk (net)
                    0.0286    0.0000    0.0943 ^ clkbuf_1_0_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0818    0.1761 ^ clkbuf_1_0_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_1_0_0_clk (net)
                    0.0264    0.0000    0.1761 ^ clkbuf_1_0_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    0.2673 ^ clkbuf_1_0_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_1_0_1_clk (net)
                    0.0379    0.0000    0.2673 ^ clkbuf_2_0_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0851    0.3524 ^ clkbuf_2_0_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_2_0_0_clk (net)
                    0.0264    0.0000    0.3524 ^ clkbuf_2_0_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    0.4437 ^ clkbuf_2_0_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_2_0_1_clk (net)
                    0.0379    0.0000    0.4437 ^ clkbuf_3_1_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0953    0.5391 ^ clkbuf_3_1_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_3_1_0_clk (net)
                    0.0379    0.0000    0.5391 ^ clkbuf_4_3_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.3973    0.3436    0.8827 ^ clkbuf_4_3_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
    10    0.0729                                 clknet_4_3_0_clk (net)
                    0.3973    0.0000    0.8827 ^ clkbuf_leaf_153_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0428    0.2132    1.0958 ^ clkbuf_leaf_153_clk/X (sky130_fd_sc_hd__clkbuf_16)
     6    0.0113                                 clknet_leaf_153_clk (net)
                    0.0428    0.0000    1.0958 ^ _46729_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.0273    0.2990    1.3949 ^ _46729_/Q (sky130_fd_sc_hd__dfxtp_2)
     1    0.0020                                 alu_add_sub[5] (net)
                    0.0273    0.0000    1.3949 ^ _45238_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.0340    0.1021    1.4970 ^ _45238_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 alu_out[5] (net)
                    0.0340    0.0000    1.4970 ^ _46694_/D (sky130_fd_sc_hd__dfxtp_2)
                                        1.4970   data arrival time

                              0.0000    0.0000   clock core_clock (rise edge)
                              0.0000    0.0000   clock source latency
                    0.0000    0.0000    0.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    0.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0286    0.0943    0.0943 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0046                                 clknet_0_clk (net)
                    0.0286    0.0000    0.0943 ^ clkbuf_1_0_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0818    0.1761 ^ clkbuf_1_0_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_1_0_0_clk (net)
                    0.0264    0.0000    0.1761 ^ clkbuf_1_0_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    0.2673 ^ clkbuf_1_0_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_1_0_1_clk (net)
                    0.0379    0.0000    0.2673 ^ clkbuf_2_0_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0851    0.3524 ^ clkbuf_2_0_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_2_0_0_clk (net)
                    0.0264    0.0000    0.3524 ^ clkbuf_2_0_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    0.4437 ^ clkbuf_2_0_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_2_0_1_clk (net)
                    0.0379    0.0000    0.4437 ^ clkbuf_3_0_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0953    0.5391 ^ clkbuf_3_0_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_3_0_0_clk (net)
                    0.0379    0.0000    0.5391 ^ clkbuf_4_0_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.6807    0.5358    1.0748 ^ clkbuf_4_0_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
    16    0.1263                                 clknet_4_0_0_clk (net)
                    0.6807    0.0000    1.0748 ^ clkbuf_leaf_127_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0558    0.2658    1.3406 ^ clkbuf_leaf_127_clk/X (sky130_fd_sc_hd__clkbuf_16)
     9    0.0169                                 clknet_leaf_127_clk (net)
                    0.0558    0.0000    1.3406 ^ _46694_/CLK (sky130_fd_sc_hd__dfxtp_2)
                              0.0000    1.3406   clock reconvergence pessimism
                             -0.0275    1.3132   library hold time
                                        1.3132   data required time
-------------------------------------------------------------------------------------
                                        1.3132   data required time
                                       -1.4970   data arrival time
-------------------------------------------------------------------------------------
                                        0.1838   slack (MET)


Startpoint: _46875_ (rising edge-triggered flip-flop clocked by core_clock)
Endpoint: _46655_ (rising edge-triggered flip-flop clocked by core_clock)
Path Group: core_clock
Path Type: max

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                              0.0000    0.0000   clock core_clock (rise edge)
                              0.0000    0.0000   clock source latency
                    0.0000    0.0000    0.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    0.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0286    0.0943    0.0943 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0046                                 clknet_0_clk (net)
                    0.0286    0.0000    0.0943 ^ clkbuf_1_1_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0818    0.1761 ^ clkbuf_1_1_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_1_1_0_clk (net)
                    0.0264    0.0000    0.1761 ^ clkbuf_1_1_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    0.2673 ^ clkbuf_1_1_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_1_1_1_clk (net)
                    0.0379    0.0000    0.2673 ^ clkbuf_2_3_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0851    0.3524 ^ clkbuf_2_3_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_2_3_0_clk (net)
                    0.0264    0.0000    0.3524 ^ clkbuf_2_3_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    0.4437 ^ clkbuf_2_3_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_2_3_1_clk (net)
                    0.0379    0.0000    0.4437 ^ clkbuf_3_7_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0953    0.5391 ^ clkbuf_3_7_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_3_7_0_clk (net)
                    0.0379    0.0000    0.5391 ^ clkbuf_4_15_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.6388    0.5074    1.0464 ^ clkbuf_4_15_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
    15    0.1184                                 clknet_4_15_0_clk (net)
                    0.6388    0.0000    1.0464 ^ clkbuf_leaf_169_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0470    0.2504    1.2968 ^ clkbuf_leaf_169_clk/X (sky130_fd_sc_hd__clkbuf_16)
     4    0.0075                                 clknet_leaf_169_clk (net)
                    0.0470    0.0000    1.2968 ^ _46875_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.7191    0.7941    2.0909 ^ _46875_/Q (sky130_fd_sc_hd__dfxtp_2)
    41    0.1442                                 cpu_state[3] (net)
                    0.7191    0.0000    2.0909 ^ _46045_/S (sky130_fd_sc_hd__mux2_1)
                    5.6858    4.1793    6.2702 ^ _46045_/X (sky130_fd_sc_hd__mux2_1)
   161    0.6590                                 _00357_ (net)
                    5.6858    0.0000    6.2702 ^ _46535_/S0 (sky130_fd_sc_hd__mux4_1)
                    0.1110    0.8760    7.1462 v _46535_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0014                                 _00361_ (net)
                    0.1110    0.0000    7.1462 v _46538_/A1 (sky130_fd_sc_hd__mux4_1)
                    0.0794    0.5039    7.6501 v _46538_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0018                                 _00365_ (net)
                    0.0794    0.0000    7.6501 v _46040_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.0659    0.3104    7.9606 v _46040_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0042                                 _00370_ (net)
                    0.0659    0.0000    7.9606 v _23636_/B (sky130_fd_sc_hd__nand2_2)
                    0.0703    0.0902    8.0508 ^ _23636_/Y (sky130_fd_sc_hd__nand2_2)
     3    0.0096                                 _20732_ (net)
                    0.0703    0.0000    8.0508 ^ _28794_/B2 (sky130_fd_sc_hd__o221a_2)
                    0.0359    0.1673    8.2181 ^ _28794_/X (sky130_fd_sc_hd__o221a_2)
     1    0.0016                                 _01718_ (net)
                    0.0359    0.0000    8.2181 ^ _45905_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0423    0.1026    8.3207 ^ _45905_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 _01719_ (net)
                    0.0423    0.0000    8.3207 ^ _28803_/A1_N (sky130_fd_sc_hd__a2bb2o_2)
                    0.0409    0.2552    8.5759 v _28803_/X (sky130_fd_sc_hd__a2bb2o_2)
     1    0.0020                                 _04569_ (net)
                    0.0409    0.0000    8.5759 v _28804_/C1 (sky130_fd_sc_hd__a311o_2)
                    0.0481    0.2893    8.8652 v _28804_/X (sky130_fd_sc_hd__a311o_2)
     1    0.0015                                 _01720_ (net)
                    0.0481    0.0000    8.8652 v _45500_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0498    0.2670    9.1322 v _45500_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 _23085_ (net)
                    0.0498    0.0000    9.1322 v _46655_/D (sky130_fd_sc_hd__dfxtp_2)
                                        9.1322   data arrival time

                              5.0000    5.0000   clock core_clock (rise edge)
                              0.0000    5.0000   clock source latency
                    0.0000    0.0000    5.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    5.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0286    0.0943    5.0943 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0046                                 clknet_0_clk (net)
                    0.0286    0.0000    5.0943 ^ clkbuf_1_1_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0818    5.1761 ^ clkbuf_1_1_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_1_1_0_clk (net)
                    0.0264    0.0000    5.1761 ^ clkbuf_1_1_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    5.2673 ^ clkbuf_1_1_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_1_1_1_clk (net)
                    0.0379    0.0000    5.2673 ^ clkbuf_2_3_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0264    0.0851    5.3524 ^ clkbuf_2_3_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     1    0.0023                                 clknet_2_3_0_clk (net)
                    0.0264    0.0000    5.3524 ^ clkbuf_2_3_1_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0913    5.4437 ^ clkbuf_2_3_1_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_2_3_1_clk (net)
                    0.0379    0.0000    5.4437 ^ clkbuf_3_7_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.0379    0.0953    5.5391 ^ clkbuf_3_7_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
     2    0.0046                                 clknet_3_7_0_clk (net)
                    0.0379    0.0000    5.5391 ^ clkbuf_4_14_0_clk/A (sky130_fd_sc_hd__clkbuf_2)
                    0.5130    0.4221    5.9612 ^ clkbuf_4_14_0_clk/X (sky130_fd_sc_hd__clkbuf_2)
    12    0.0947                                 clknet_4_14_0_clk (net)
                    0.5130    0.0000    5.9612 ^ clkbuf_leaf_182_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0495    0.2372    6.1984 ^ clkbuf_leaf_182_clk/X (sky130_fd_sc_hd__clkbuf_16)
     8    0.0150                                 clknet_leaf_182_clk (net)
                    0.0495    0.0000    6.1984 ^ _46655_/CLK (sky130_fd_sc_hd__dfxtp_2)
                              0.0000    6.1984   clock reconvergence pessimism
                             -0.1139    6.0845   library setup time
                                        6.0845   data required time
-------------------------------------------------------------------------------------
                                        6.0845   data required time
                                       -9.1322   data arrival time
-------------------------------------------------------------------------------------
                                       -3.0477   slack (VIOLATED)
```

</details>

We will be able to see the setup and hold slacks having some amount of improvement, but do note that this comes with a potentially large area & power penalty due to the larger clock buffers used.

Commands to know the skews:

```
% report_clock_skew -hold
Clock core_clock
Latency      CRPR       Skew
_46977_/CLK ^
   1.61
_47199_/CLK ^
   0.94      0.00       0.67
```

```
% report_clock_skew -setup
Clock core_clock
Latency      CRPR       Skew
_46977_/CLK ^
   1.61
_47199_/CLK ^
   0.94      0.00       0.67
```

Command to insert clock buffer

```
% set ::env(CTS_CLK_BUFFER_LIST) [linsert $::env(CTS_CLK_BUFFER_LIST) 0 sky130_fd_sc_hd__clkbuf_1]
sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8
```

</details>

## Day 19 - RTL2GDS using TritonRoute and OpenSTA

<details>
<summary>details...</summary>

### Introduction to Maze Routing and Lees Algorithm

 - In an ASIC flow, PDN generation is part of floorplan. In OpenLane, however, this is not the case and PDN must be generated after CTS and post-CTS STA analysis.
 - During routing, algorithm tries to find the best possible connection between points. One such algorithm is maze routing also known as Lee's algorithm.
 - This algorithm, find the minimum distance between points by a. creating a routing grid, b. labels source and target points, c. labels edge grids of source point as 1 (horizontal and vertical), then labels unlabeled edge grids of those grids as 2 and so on and so forth until we hit the target grid, d. Now all enumarated pathes in order that take from source to target grid are identified as options, e. L shaped routes (if found) would be chosen, otherwise any other identified option is chosen (the lower the number of pins found the better).

Example of routing by Lee's alghoritm

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/c8d7f719-654f-4338-bc10-441840b9b27b)

### Design Rules Check (DRC)

 - DRC are rules that need to be followed when routing.
 - Some rules define: minimum wire width, minimum wire pitch (distance between two wires from midpoints), and minimum wire spacing (distance between two wires from inner points).
 - One violation is signal short when two wires meet: to solve it, one wire is put on another metal layer
 - Via width (inner square width)
 - Via spacing (from inner close sides).
 - etc.

 Over 10K rules used to DRC for physical design.

**Parasitic Extraction**

 - SPEF format for wire's RC information

### Power Distribution Network and Routing

To generate right power distribution networks as depicted below used command `gen_pdn`

![изображение](https://github.com/pitman75/vsd-hdp/assets/12179612/ffd32978-9586-4b58-894f-a30b733d1af8)

PDN result:

```
% gen_pdn
[INFO]: Generating PDN...
[INFO]: current step index: 12
OpenROAD 0.9.0 1415572a73
This program is licensed under the BSD-3 license. See the LICENSE file for details.
Components of this program may be licensed under more restrictive licenses which must be honored.
Notice 0: Reading LEF file:  /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged_unpadded.lef
Notice 0:     Created 13 technology layers
Notice 0:     Created 25 technology vias
Notice 0:     Created 441 library cells
Notice 0: Finished LEF file:  /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged_unpadded.lef
Notice 0: 
Reading DEF file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
Notice 0: Design: picorv32a
Notice 0:     Created 409 pins.
Notice 0:     Created 31837 components and 195129 component-terminals.
Notice 0:     Created 25384 nets and 84289 connections.
Notice 0: Finished DEF file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def
[INFO] [PDNG-0016] Power Delivery Network Generator: Generating PDN
[INFO] [PDNG-0016]   config: /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/openlane/common_pdn.tcl
[INFO] [PDNG-0008] Design Name is picorv32a
[INFO] [PDNG-0009] Reading technology data
[INFO] [PDNG-0011] ****** INFO ******
Type: stdcell, grid
    Stdcell Rails
      Layer: met1 -  width: 0.480  pitch: 2.720  offset: 0.000 
    Straps
      Layer: met4 -  width: 1.600  pitch: 153.600  offset: 16.320 
      Layer: met5 -  width: 1.600  pitch: 153.180  offset: 16.650 
    Connect: {met4 met5} {met1 met4}
Type: macro, macro_1
    Macro orientation: R0 R180 MX MY R90 R270 MXR90 MYR90
    Straps
    Connect: {met4_PIN_ver met5}
[INFO] [PDNG-0012] **** END INFO ****
[INFO] [PDNG-0013] Inserting stdcell grid - grid
[INFO] [PDNG-0015] Writing to database
[WARNING PSM-0016] Voltage pad location (vsrc) file not specified, defaulting pad location to checkerboard pattern on core area.
[WARNING PSM-0017] X direction bump pitch is not specified, defaulting to 140um.
[WARNING PSM-0018] Y direction bump pitch is not specified, defaulting to 140um.
[WARNING PSM-0019] Voltage on net VPWR is not explicitly set.
[WARNING PSM-0022] Using voltage 0.000V for VDD network.
[INFO PSM-0026] Creating G matrix.
[INFO PSM-0028] Extracting power stripes on net VPWR.
[WARNING PSM-0030] Vsrc location at (5.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (5.400um, 27.290um).
[WARNING PSM-0030] Vsrc location at (145.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (145.800um, 27.290um).
[WARNING PSM-0030] Vsrc location at (285.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 27.290um).
[WARNING PSM-0030] Vsrc location at (425.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 27.290um).
[WARNING PSM-0030] Vsrc location at (565.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 27.290um).
[WARNING PSM-0030] Vsrc location at (285.520um, 150.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 180.470um).
[WARNING PSM-0030] Vsrc location at (425.520um, 150.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 180.470um).
[WARNING PSM-0030] Vsrc location at (565.520um, 150.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 180.470um).
[WARNING PSM-0030] Vsrc location at (565.520um, 290.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 333.650um).
[WARNING PSM-0030] Vsrc location at (5.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (5.400um, 486.830um).
[WARNING PSM-0030] Vsrc location at (145.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (145.800um, 486.830um).
[WARNING PSM-0030] Vsrc location at (285.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 486.830um).
[WARNING PSM-0030] Vsrc location at (425.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 486.830um).
[WARNING PSM-0030] Vsrc location at (565.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 486.830um).
[WARNING PSM-0030] Vsrc location at (285.520um, 570.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 640.010um).
[WARNING PSM-0030] Vsrc location at (425.520um, 570.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 640.010um).
[WARNING PSM-0030] Vsrc location at (565.520um, 570.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 640.010um).
[INFO PSM-0031] Number of nodes on net VPWR = 20897.
[INFO PSM-0037] G matrix created sucessfully.
[INFO PSM-0040] Connection between all PDN nodes established in net VPWR.
[WARNING PSM-0016] Voltage pad location (vsrc) file not specified, defaulting pad location to checkerboard pattern on core area.
[WARNING PSM-0017] X direction bump pitch is not specified, defaulting to 140um.
[WARNING PSM-0018] Y direction bump pitch is not specified, defaulting to 140um.
[WARNING PSM-0019] Voltage on net VGND is not explicitly set.
[WARNING PSM-0021] Using voltage 0.000V for ground network.
[INFO PSM-0026] Creating G matrix.
[INFO PSM-0028] Extracting power stripes on net VGND.
[WARNING PSM-0030] Vsrc location at (5.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (5.400um, 103.880um).
[WARNING PSM-0030] Vsrc location at (145.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (145.800um, 103.880um).
[WARNING PSM-0030] Vsrc location at (285.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 103.880um).
[WARNING PSM-0030] Vsrc location at (425.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 103.880um).
[WARNING PSM-0030] Vsrc location at (565.520um, 10.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 103.880um).
[WARNING PSM-0030] Vsrc location at (285.520um, 150.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 103.880um).
[WARNING PSM-0030] Vsrc location at (425.520um, 150.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 103.880um).
[WARNING PSM-0030] Vsrc location at (565.520um, 150.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 103.880um).
[WARNING PSM-0030] Vsrc location at (565.520um, 290.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 257.060um).
[WARNING PSM-0030] Vsrc location at (5.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (5.400um, 410.240um).
[WARNING PSM-0030] Vsrc location at (145.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (145.800um, 410.240um).
[WARNING PSM-0030] Vsrc location at (285.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 410.240um).
[WARNING PSM-0030] Vsrc location at (425.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 410.240um).
[WARNING PSM-0030] Vsrc location at (565.520um, 430.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 410.240um).
[WARNING PSM-0030] Vsrc location at (285.520um, 570.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (286.200um, 563.420um).
[WARNING PSM-0030] Vsrc location at (425.520um, 570.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (426.600um, 563.420um).
[WARNING PSM-0030] Vsrc location at (565.520um, 570.880um) and size =10.000um, is not located on a power stripe. Moving to closest stripe at (567.000um, 563.420um).
[INFO PSM-0031] Number of nodes on net VGND = 19658.
[INFO PSM-0037] G matrix created sucessfully.
[INFO PSM-0040] Connection between all PDN nodes established in net VGND.
[INFO]: PDN generation was successful.
[INFO]: Changing layout from /openLANE_flow/designs/picorv32a/runs/fastpico/results/cts/picorv32a.cts.def to /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/floorplan/12-pdn.def
```

For routing use settings by default and execite a command `run_routing` but I have an error

![Design congestion too high](https://github.com/pitman75/vsd-hdp/assets/12179612/84731805-5053-4276-b889-38451bf548d5)

That error happens whenthe TritonRouter can't route a chip. Let's reduce utilization factor. New options for lib are:

![new_lib_config](https://github.com/pitman75/vsd-hdp/assets/12179612/4a4e2537-e411-439e-98d7-d79e1828adcb)

When we change configuration of project or libs we should restart all process from start top apply changes. From `run_synthesis` to `gen_pdn` done all stages.

<details>
<summary>Routing result</summary>

```
complete detail routing
total wire length = 1827751 um
total wire length on LAYER li1 = 983 um
total wire length on LAYER met1 = 724095 um
total wire length on LAYER met2 = 739805 um
total wire length on LAYER met3 = 269376 um
total wire length on LAYER met4 = 93062 um
total wire length on LAYER met5 = 428 um
total number of vias = 223663
up-via summary (total 223663):

-------------------------
 FR_MASTERSLICE         0
            li1     87208
           met1    116329
           met2     17316
           met3      2802
           met4         8
-------------------------
                   223663

cpu time = 01:15:56, elapsed time = 00:19:38, memory = 961.41 (MB), peak = 1008.89 (MB)

post processing ...

Runtime taken (hrt): 1201.18
[INFO]: No DRC violations after detailed routing.
[INFO]: Changing layout from /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/routing/14-addspacers.def to /openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def
[INFO]: Taking a Screenshot of the Layout Using Klayout...
[INFO]: current step index: 17
Using Techfile: /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/klayout/sky130A.lyt
Using layout file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def
[INFO] Reading tech file: /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/klayout/sky130A.lyt
[INFO] Reading Layout file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def
[INFO] Writing out PNG screenshot '/openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def.png'
Done
[INFO]: Screenshot taken.
[INFO]: Running SPEF Extraction...
[INFO]: current step index: 18
Start parsing LEF file...
Parsing LEF file done.
Start parsing DEF file...
Parsing DEF file done.

Parameters Used:
Edge Capacitance Factor: 1.0
Wire model: L 

RC Extraction is done
Start writing SPEF file
Writing SPEF is done
[INFO]: Running Static Timing Analysis...
[INFO]: current step index: 19
OpenSTA 2.3.0 38b40303a8 Copyright (c) 2019, Parallax Software, Inc.
License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>

This is free software, and you are free to change and redistribute it
under certain conditions; type `show_copying' for details. 
This program comes with ABSOLUTELY NO WARRANTY; for details type `show_warranty'.
Warning: /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis_preroute.v line 84435, module sky130_fd_sc_hd__tapvpwrvgnd_1 not found.  Creating black box for PHY_624.
Warning: /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis_preroute.v line 96086, module sky130_fd_sc_hd__fill_2 not found.  Creating black box for FILLER_0_27.
Warning: /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis_preroute.v line 96276, module sky130_fd_sc_hd__fill_1 not found.  Creating black box for FILLER_1_7.
create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period $::env(CLOCK_PERIOD)
set input_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
puts "\[INFO\]: Setting output delay to: $output_delay_value"
[INFO]: Setting output delay to: 2.4000000000000004
puts "\[INFO\]: Setting input delay to: $input_delay_value"
[INFO]: Setting input delay to: 2.4000000000000004
set_max_fanout $::env(SYNTH_MAX_FANOUT) [current_design]
set clk_indx [lsearch [all_inputs] [get_port $::env(CLOCK_PORT)]]
#set rst_indx [lsearch [all_inputs] [get_port resetn]]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx]
#set all_inputs_wo_clk_rst [lreplace $all_inputs_wo_clk $rst_indx $rst_indx]
set all_inputs_wo_clk_rst $all_inputs_wo_clk
# correct resetn
set_input_delay $input_delay_value  -clock [get_clocks $::env(CLOCK_PORT)] $all_inputs_wo_clk_rst
#set_input_delay 0.0 -clock [get_clocks $::env(CLOCK_PORT)] {resetn}
set_output_delay $output_delay_value  -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]
# TODO set this as parameter
set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
[INFO]: Setting load to: 0.01765
set_load  $cap_load [all_outputs]
tns -266.37
wns -7.36
[INFO]: Calculating Runtime From the Start...
[INFO]: Routing completed for picorv32a/30-03_03-55 in 0h24m51s
```

</details>

Use `openroad` to STA for routed design

```
% openroad
% read_lef /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged.lef
Notice 0: Reading LEF file:  /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged.lef
Notice 0:     Created 13 technology layers
Notice 0:     Created 25 technology vias
Notice 0:     Created 441 library cells
Notice 0: Finished LEF file:  /openLANE_flow/designs/picorv32a/runs/fastpico/tmp/merged.lef
% echo $::env(CURRENT_DEF)
/openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def
% read_def $::env(CURRENT_DEF)
Notice 0: 
Reading DEF file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def
Notice 0: Design: picorv32a
Notice 0:     Created 431 pins.
Notice 0:     Created 89783 components and 420032 component-terminals.
Notice 0:     Created 2 special nets and 0 connections.
Notice 0:     Created 25455 nets and 85354 connections.
Notice 0: Finished DEF file: /openLANE_flow/designs/picorv32a/runs/fastpico/results/routing/picorv32a.def
% write_db picorv32a_routing.db
% read_db picorv32a_routing.db
% read_verilog /openLANE_flow/designs/picorv32a/runs/fastpico/results/synthesis/picorv32a.synthesis_preroute.v
% read_liberty $::env(LIB_SYNTH_COMPLETE)
1
% link_design picorv32a
[WARNING ORD-1000] LEF master sky130_fd_sc_hd__fill_2 has no liberty cell.
[WARNING ORD-1000] LEF master sky130_fd_sc_hd__fill_1 has no liberty cell.
[WARNING ORD-1000] LEF master sky130_fd_sc_hd__tapvpwrvgnd_1 has no liberty cell.
% read_sdc /openLANE_flow/designs/picorv32a/src/picorv32a.sdc
% set_propagated_clock [all_clocks]
% report_checks -path_delay min_max -fields {slew trans net cap input_pin} -format full_clock_expanded -digits 4
Startpoint: _46864_ (rising edge-triggered flip-flop clocked by core_clock)
Endpoint: _46680_ (rising edge-triggered flip-flop clocked by core_clock)
Path Group: core_clock
Path Type: min

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                              0.0000    0.0000   clock core_clock (rise edge)
                              0.0000    0.0000   clock source latency
                    0.0000    0.0000    0.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    0.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0283    0.0941    0.0941 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0044                                 clknet_0_clk (net)
                    0.0283    0.0000    0.0941 ^ clkbuf_1_1_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0388    0.0697    0.1638 ^ clkbuf_1_1_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_1_1_0_clk (net)
                    0.0388    0.0000    0.1638 ^ clkbuf_1_1_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0910    0.2548 ^ clkbuf_1_1_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_1_1_1_clk (net)
                    0.0635    0.0000    0.2548 ^ clkbuf_2_3_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0390    0.0811    0.3359 ^ clkbuf_2_3_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_2_3_0_clk (net)
                    0.0390    0.0000    0.3359 ^ clkbuf_2_3_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0911    0.4270 ^ clkbuf_2_3_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_2_3_1_clk (net)
                    0.0635    0.0000    0.4270 ^ clkbuf_3_7_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0987    0.5257 ^ clkbuf_3_7_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_3_7_0_clk (net)
                    0.0635    0.0000    0.5257 ^ clkbuf_4_15_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0988    0.6245 ^ clkbuf_4_15_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_4_15_0_clk (net)
                    0.0635    0.0000    0.6245 ^ clkbuf_5_31_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.3975    0.3291    0.9536 ^ clkbuf_5_31_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     5    0.0335                                 clknet_5_31_0_clk (net)
                    0.3975    0.0000    0.9536 ^ clkbuf_leaf_117_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0412    0.2112    1.1648 ^ clkbuf_leaf_117_clk/X (sky130_fd_sc_hd__clkbuf_16)
     5    0.0094                                 clknet_leaf_117_clk (net)
                    0.0412    0.0000    1.1648 ^ _46864_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.0273    0.2984    1.4632 ^ _46864_/Q (sky130_fd_sc_hd__dfxtp_2)
     1    0.0020                                 pcpi_mul.rd[57] (net)
                    0.0273    0.0000    1.4632 ^ _45776_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.0404    0.1086    1.5718 ^ _45776_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0025                                 _02000_ (net)
                    0.0404    0.0000    1.5718 ^ _29310_/A2 (sky130_fd_sc_hd__a221o_2)
                    0.0259    0.1269    1.6987 ^ _29310_/X (sky130_fd_sc_hd__a221o_2)
     1    0.0016                                 _02006_ (net)
                    0.0259    0.0000    1.6987 ^ _45525_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0340    0.0988    1.7975 ^ _45525_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 _23102_ (net)
                    0.0340    0.0000    1.7975 ^ _46680_/D (sky130_fd_sc_hd__dfxtp_2)
                                        1.7975   data arrival time

                              0.0000    0.0000   clock core_clock (rise edge)
                              0.0000    0.0000   clock source latency
                    0.0000    0.0000    0.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    0.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0283    0.0941    0.0941 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0044                                 clknet_0_clk (net)
                    0.0283    0.0000    0.0941 ^ clkbuf_1_0_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0388    0.0697    0.1638 ^ clkbuf_1_0_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_1_0_0_clk (net)
                    0.0388    0.0000    0.1638 ^ clkbuf_1_0_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0910    0.2548 ^ clkbuf_1_0_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_1_0_1_clk (net)
                    0.0635    0.0000    0.2548 ^ clkbuf_2_1_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0390    0.0811    0.3359 ^ clkbuf_2_1_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_2_1_0_clk (net)
                    0.0390    0.0000    0.3359 ^ clkbuf_2_1_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0911    0.4270 ^ clkbuf_2_1_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_2_1_1_clk (net)
                    0.0635    0.0000    0.4270 ^ clkbuf_3_2_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0738    0.1059    0.5329 ^ clkbuf_3_2_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     3    0.0053                                 clknet_3_2_0_clk (net)
                    0.0738    0.0000    0.5329 ^ clkbuf_4_5_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0636    0.1015    0.6344 ^ clkbuf_4_5_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_4_5_0_clk (net)
                    0.0636    0.0000    0.6344 ^ clkbuf_5_11_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    1.1007    0.8135    1.4479 ^ clkbuf_5_11_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
    12    0.0947                                 clknet_5_11_0_clk (net)
                    1.1007    0.0000    1.4479 ^ clkbuf_leaf_234_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0614    0.2914    1.7393 ^ clkbuf_leaf_234_clk/X (sky130_fd_sc_hd__clkbuf_16)
     6    0.0113                                 clknet_leaf_234_clk (net)
                    0.0614    0.0000    1.7393 ^ _46680_/CLK (sky130_fd_sc_hd__dfxtp_2)
                              0.0000    1.7393   clock reconvergence pessimism
                             -0.0268    1.7126   library hold time
                                        1.7126   data required time
-------------------------------------------------------------------------------------
                                        1.7126   data required time
                                       -1.7975   data arrival time
-------------------------------------------------------------------------------------
                                        0.0850   slack (MET)


Startpoint: _46875_ (rising edge-triggered flip-flop clocked by core_clock)
Endpoint: _46670_ (rising edge-triggered flip-flop clocked by core_clock)
Path Group: core_clock
Path Type: max

Fanout       Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------------
                              0.0000    0.0000   clock core_clock (rise edge)
                              0.0000    0.0000   clock source latency
                    0.0000    0.0000    0.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    0.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0283    0.0941    0.0941 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0044                                 clknet_0_clk (net)
                    0.0283    0.0000    0.0941 ^ clkbuf_1_0_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0388    0.0697    0.1638 ^ clkbuf_1_0_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_1_0_0_clk (net)
                    0.0388    0.0000    0.1638 ^ clkbuf_1_0_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0910    0.2548 ^ clkbuf_1_0_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_1_0_1_clk (net)
                    0.0635    0.0000    0.2548 ^ clkbuf_2_1_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0390    0.0811    0.3359 ^ clkbuf_2_1_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_2_1_0_clk (net)
                    0.0390    0.0000    0.3359 ^ clkbuf_2_1_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0911    0.4270 ^ clkbuf_2_1_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_2_1_1_clk (net)
                    0.0635    0.0000    0.4270 ^ clkbuf_3_3_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0987    0.5257 ^ clkbuf_3_3_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_3_3_0_clk (net)
                    0.0635    0.0000    0.5257 ^ clkbuf_4_6_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0988    0.6245 ^ clkbuf_4_6_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_4_6_0_clk (net)
                    0.0635    0.0000    0.6245 ^ clkbuf_5_12_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.7604    0.5788    1.2033 ^ clkbuf_5_12_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     9    0.0650                                 clknet_5_12_0_clk (net)
                    0.7604    0.0000    1.2033 ^ clkbuf_leaf_220_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0463    0.2545    1.4578 ^ clkbuf_leaf_220_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0038                                 clknet_leaf_220_clk (net)
                    0.0463    0.0000    1.4578 ^ _46875_/CLK (sky130_fd_sc_hd__dfxtp_2)
                    0.7190    0.7938    2.2517 ^ _46875_/Q (sky130_fd_sc_hd__dfxtp_2)
    41    0.1442                                 cpu_state[3] (net)
                    0.7190    0.0000    2.2517 ^ _46045_/S (sky130_fd_sc_hd__mux2_1)
                    5.6858    4.1793    6.4310 ^ _46045_/X (sky130_fd_sc_hd__mux2_1)
   161    0.6590                                 _00357_ (net)
                    5.6858    0.0000    6.4310 ^ _46445_/S0 (sky130_fd_sc_hd__mux4_1)
                    0.1110    0.8760    7.3070 v _46445_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0014                                 _00758_ (net)
                    0.1110    0.0000    7.3070 v _46448_/A1 (sky130_fd_sc_hd__mux4_1)
                    0.0794    0.5039    7.8109 v _46448_/X (sky130_fd_sc_hd__mux4_1)
     1    0.0018                                 _00769_ (net)
                    0.0794    0.0000    7.8109 v _46025_/A1 (sky130_fd_sc_hd__mux2_1)
                    0.0658    0.3103    8.1212 v _46025_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0042                                 _00775_ (net)
                    0.0658    0.0000    8.1212 v _23576_/A (sky130_fd_sc_hd__nor2_2)
                    0.1616    0.1738    8.2950 ^ _23576_/Y (sky130_fd_sc_hd__nor2_2)
     5    0.0126                                 cpuregs_rs1[15] (net)
                    0.1616    0.0000    8.2950 ^ _29126_/A (sky130_fd_sc_hd__nand2_2)
                    0.0435    0.0519    8.3468 v _29126_/Y (sky130_fd_sc_hd__nand2_2)
     1    0.0023                                 _04801_ (net)
                    0.0435    0.0000    8.3468 v _29127_/C1 (sky130_fd_sc_hd__o221a_2)
                    0.0392    0.1100    8.4568 v _29127_/X (sky130_fd_sc_hd__o221a_2)
     1    0.0015                                 _01914_ (net)
                    0.0392    0.0000    8.4568 v _45815_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0496    0.2640    8.7208 v _45815_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0016                                 _01915_ (net)
                    0.0496    0.0000    8.7208 v _29135_/B1 (sky130_fd_sc_hd__o2bb2a_2)
                    0.0492    0.2604    8.9813 v _29135_/X (sky130_fd_sc_hd__o2bb2a_2)
     1    0.0041                                 _04809_ (net)
                    0.0492    0.0000    8.9813 v _29136_/C1 (sky130_fd_sc_hd__o221ai_2)
                    0.1222    0.0486    9.0299 ^ _29136_/Y (sky130_fd_sc_hd__o221ai_2)
     1    0.0016                                 _01916_ (net)
                    0.1222    0.0000    9.0299 ^ _45515_/A0 (sky130_fd_sc_hd__mux2_1)
                    0.0421    0.1320    9.1619 ^ _45515_/X (sky130_fd_sc_hd__mux2_1)
     1    0.0017                                 _23091_ (net)
                    0.0421    0.0000    9.1619 ^ _46670_/D (sky130_fd_sc_hd__dfxtp_2)
                                        9.1619   data arrival time

                              5.0000    5.0000   clock core_clock (rise edge)
                              0.0000    5.0000   clock source latency
                    0.0000    0.0000    5.0000 ^ clk (in)
     1    0.0079                                 clk (net)
                    0.0000    0.0000    5.0000 ^ clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0283    0.0941    5.0941 ^ clkbuf_0_clk/X (sky130_fd_sc_hd__clkbuf_16)
     2    0.0044                                 clknet_0_clk (net)
                    0.0283    0.0000    5.0941 ^ clkbuf_1_1_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0388    0.0697    5.1638 ^ clkbuf_1_1_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_1_1_0_clk (net)
                    0.0388    0.0000    5.1638 ^ clkbuf_1_1_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0910    5.2548 ^ clkbuf_1_1_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_1_1_1_clk (net)
                    0.0635    0.0000    5.2548 ^ clkbuf_2_2_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0390    0.0811    5.3359 ^ clkbuf_2_2_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     1    0.0022                                 clknet_2_2_0_clk (net)
                    0.0390    0.0000    5.3359 ^ clkbuf_2_2_1_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0911    5.4270 ^ clkbuf_2_2_1_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_2_2_1_clk (net)
                    0.0635    0.0000    5.4270 ^ clkbuf_3_4_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0987    5.5257 ^ clkbuf_3_4_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_3_4_0_clk (net)
                    0.0635    0.0000    5.5257 ^ clkbuf_4_8_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.0635    0.0988    5.6245 ^ clkbuf_4_8_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     2    0.0044                                 clknet_4_8_0_clk (net)
                    0.0635    0.0000    5.6245 ^ clkbuf_5_17_0_clk/A (sky130_fd_sc_hd__clkbuf_1)
                    0.5793    0.4541    6.0785 ^ clkbuf_5_17_0_clk/X (sky130_fd_sc_hd__clkbuf_1)
     7    0.0492                                 clknet_5_17_0_clk (net)
                    0.5793    0.0000    6.0785 ^ clkbuf_leaf_179_clk/A (sky130_fd_sc_hd__clkbuf_16)
                    0.0467    0.2424    6.3209 ^ clkbuf_leaf_179_clk/X (sky130_fd_sc_hd__clkbuf_16)
     5    0.0094                                 clknet_leaf_179_clk (net)
                    0.0467    0.0000    6.3209 ^ _46670_/CLK (sky130_fd_sc_hd__dfxtp_2)
                              0.0000    6.3209   clock reconvergence pessimism
                             -0.0579    6.2630   library setup time
                                        6.2630   data required time
-------------------------------------------------------------------------------------
                                        6.2630   data required time
                                       -9.1619   data arrival time
-------------------------------------------------------------------------------------
                                       -2.8989   slack (VIOLATED)

% report_clock_skew -hold
Clock core_clock
Latency      CRPR       Skew
_47838_/CLK ^
   1.77
_47660_/CLK ^
   1.02      0.00       0.76

% report_clock_skew -setup
Clock core_clock
Latency      CRPR       Skew
_47838_/CLK ^
   1.77
_47660_/CLK ^
   1.02      0.00       0.76
```

![picorv32a def](https://github.com/pitman75/vsd-hdp/assets/12179612/13937a1d-487a-4a73-8f06-104920239fd7)

Let's check that our custom cell vsdinv exist in the layout:

![routed_vsdinv_in_chip](https://github.com/pitman75/vsd-hdp/assets/12179612/cf693fb8-f942-405c-bbdb-c11693052435)

Yes, it is.

Conclusion: The design should be improved to met STA.

</details>

## Day 20 - Physical Design of project

<details>
	<summary>details...</summary>

New version of an OpenLANE was installed in Day 0.

### Adding Designs

To add a new design, the following command creates a configuration file for your design:

```
# JSON Configuration File
./flow.tcl -design <design_name> -init_design_config -add_to_designs
```

Or for TCL version use

```
# Tcl Configuration File
./flow.tcl -design <design_name> -init_design_config -add_to_designs -config_file config.tcl
```

This will create the following directory structure: 

```
designs/<design_name>
├── config.json (or config.tcl)
```

**IMPORTANT NOTE**: The <design_name> must match the top-level module name of your design exactly. Otherwise, OpenLane will throw an error (at least by the run_synthesis stage).

It is recommended to place the verilog files of the design in a src directory inside the folder of the design as following:

```
designs/<design_name>
├── config.tcl
├── src
│   ├── design.v
```

Fine tune config file for the project:

```
set ::env(DESIGN_NAME) {iiitb_rv32i}
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "10.0"

set ::env(FP_PDN_MULTILAYER) {1}

set ::env(QUIT_ON_SYNTH_CHECKS) 0
set ::env(BASE_SDC_FILE) "$::env(DESIGN_DIR)/src/iiirv32i.sdc"
set ::env(PNR_SDC_FILE) "$::env(DESIGN_DIR)/src/iiirv32i_post_cts.sdc"
set ::env(SIGNOFF_SDC_FILE) "$::env(DESIGN_DIR)/src/iiirv32i_post_cts.sdc" 

set ::env(SYNTH_STRATEGY) "DELAY 1"
set ::env(SYNTH_SIZING) 1

set ::env(OUTPUT_CAP_LOAD) 17.65
set ::env(MAX_TRANSITION_CONSTRAINT) 1.2
set ::env(MAX_FANOUT_CONSTRAINT) 4

set tech_specific_config "$::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl"
if { [file exists $tech_specific_config] == 1 } {
    source $tech_specific_config
}
```

Constrains to STA of the project `iiirv32i.sdc` for synthesis stage is:

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
set_output_delay -clock clk -max 3 [get_ports NPC]
set_output_delay -clock clk -min 0.5 [get_ports NPC]
set_output_delay -clock clk -max 3 [get_ports WB_OUT]
set_output_delay -clock clk -min 0.5 [get_ports WB_OUT]
```

Constrains to STA of the project `iiirv32i_post_cts.sdc` for PnR/Signoff stage is:

```
create_clock -period 10 -name clk {clk}
set_clock_transition -max 0.4 {clk}
set_clock_transition -min 0.1 {clk}
set_clock_uncertainty -setup 0.2 [get_clock clk]
set_clock_uncertainty -hold 0.1 [get_clock clk]
set_propagated_clock [all_clocks]
set_input_delay -max 3 [get_ports RN]
set_input_delay -min 1 [get_ports RN]
set_input_transition -max 0.5 [get_ports RN]
set_input_transition -min 0.1 [get_ports RN]
set_output_delay -clock clk -max 3 [get_ports NPC]
set_output_delay -clock clk -min 0.5 [get_ports NPC]
set_output_delay -clock clk -max 3 [get_ports WB_OUT]
set_output_delay -clock clk -min 0.5 [get_ports WB_OUT]
```

### Running the flow for the design

To run the automated flow: 

```
./flow.tcl -design <design_name>
```

To run the flow interactively

```
$ ./flow.tcl -interactive
```

Let's build an ASIC in fully automated mode by command:

```
./flow.tcl -design iiitb_rv32i
```

**Result**

```
OpenLane Container (9dbd8b5):/openlane$ ./flow.tcl -design iiitb_rv32i
OpenLane 9dbd8b5ea2bd891bed4dcc97df5c7439083f0368
All rights reserved. (c) 2020-2023 Efabless Corporation and contributors.
Available under the Apache License, version 2.0. See the LICENSE file for more details.

[INFO]: Using configuration in 'designs/iiitb_rv32i/config.tcl'...
[INFO]: PDK Root: /home/dimon/.volare
[INFO]: Process Design Kit: sky130A
[INFO]: Standard Cell Library: sky130_fd_sc_hd
[INFO]: Optimization Standard Cell Library: sky130_fd_sc_hd
[INFO]: Run Directory: /openlane/designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04
[INFO]: Saving runtime environment...
[INFO]: Preparing LEF files for the nom corner...
[INFO]: Preparing LEF files for the min corner...
[INFO]: Preparing LEF files for the max corner...
[INFO]: Running linter (Verilator) (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/synthesis/linter.log)...
[INFO]: 0 errors found by linter
[WARNING]: 19 warnings found by linter
[STEP 1]
[INFO]: Running Synthesis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/synthesis/1-synthesis.log)...
[STEP 2]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/synthesis/2-sta.log)...
[STEP 3]
[INFO]: Running Initial Floorplanning (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/floorplan/3-initial_fp.log)...
[INFO]: Floorplanned with width 424.12 and height 421.6.
[STEP 4]
[INFO]: Running IO Placement (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/floorplan/4-io.log)...
[STEP 5]
[INFO]: Running Tap/Decap Insertion (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/floorplan/5-tap.log)...
[INFO]: Power planning with power {VPWR} and ground {VGND}...
[STEP 6]
[INFO]: Generating PDN (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/floorplan/6-pdn.log)...
[STEP 7]
[INFO]: Running Global Placement (skip_io) (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/6-global_skip_io.log)...
[STEP 8]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/8-gpl_sta.log)...
[STEP 9]
[INFO]: Running IO Placement (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/9-io.log)...
[STEP 10]
[INFO]: Running Global Placement (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/9-global.log)...
[STEP 11]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/11-gpl_sta.log)...
[STEP 12]
[INFO]: Running Placement Resizer Design Optimizations (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/12-resizer.log)...
[STEP 13]
[INFO]: Running Detailed Placement (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/13-detailed.log)...
[STEP 14]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/placement/14-dpl_sta.log)...
[STEP 15]
[INFO]: Running Clock Tree Synthesis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/cts/15-cts.log)...
[STEP 16]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/cts/16-cts_sta.log)...
[STEP 17]
[INFO]: Running Placement Resizer Timing Optimizations (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/cts/17-resizer.log)...
[STEP 18]
[INFO]: Running Global Routing Resizer Design Optimizations (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/18-resizer_design.log)...
[STEP 19]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/19-rsz_design_sta.log)...
[STEP 20]
[INFO]: Running Global Routing Resizer Timing Optimizations (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/20-resizer_timing.log)...
[STEP 21]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/21-rsz_timing_sta.log)...
[STEP 22]
[INFO]: Running Global Routing (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/22-global.log)...
[INFO]: Starting antenna repair iteration 1 with 1 violations...
[INFO]: [Iteration 1] Reduced antenna violations (1 -> 0)
[STEP 23]
[INFO]: Writing Verilog (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/22-global_write_netlist.log)...
[STEP 24]
[INFO]: Running Single-Corner Static Timing Analysis (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/24-grt_sta.log)...
[STEP 25]
[INFO]: Running Fill Insertion (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/25-fill.log)...
[STEP 26]
[INFO]: Running Detailed Routing (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/26-detailed.log)...
[INFO]: No Magic DRC violations after detailed routing.
[STEP 27]
[INFO]: Checking Wire Lengths (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/routing/27-wire_lengths.log)...
[STEP 28]
[INFO]: Running SPEF Extraction at the min process corner (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/28-parasitics_extraction.min.log)...
[STEP 29]
[INFO]: Running Multi-Corner Static Timing Analysis at the min process corner (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/29-rcx_mcsta.min.log)...
[STEP 30]
[INFO]: Running SPEF Extraction at the max process corner (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/30-parasitics_extraction.max.log)...
[STEP 31]
[INFO]: Running Multi-Corner Static Timing Analysis at the max process corner (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/31-rcx_mcsta.max.log)...
[STEP 32]
[INFO]: Running SPEF Extraction at the nom process corner (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/32-parasitics_extraction.nom.log)...
[STEP 33]
[INFO]: Running Multi-Corner Static Timing Analysis at the nom process corner (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/33-rcx_mcsta.nom.log)...
[WARNING]: VSRC_LOC_FILES was not given a value, which may make the results of IR drop analysis inaccurate. If you are not integrating a top-level chip for manufacture, you may ignore this warning, otherwise, see the documentation for VSRC_LOC_FILES.
[STEP 34]
[INFO]: Creating IR Drop Report (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/34-irdrop.log)...
[STEP 35]
[INFO]: Running Magic to generate various views...
[INFO]: Streaming out GDSII with Magic (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/35-gdsii.log)...
[INFO]: Generating MAGLEF views...
[INFO]: Generating lef with Magic (/openlane/designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/35-lef.log)...
[STEP 36]
[INFO]: Streaming out GDSII with KLayout (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/36-gdsii-klayout.log)...
[STEP 37]
[INFO]: Running XOR on the layouts using KLayout (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/37-xor.log)...
[INFO]: No XOR differences between KLayout and Magic gds.
[STEP 38]
[INFO]: Running Magic Spice Export from LEF (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/38-spice.log)...
[STEP 39]
[INFO]: Writing Powered Verilog (logs: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/39-write_powered_def.log, designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/39-write_powered_verilog.log)...
[STEP 40]
[INFO]: Writing Verilog (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/39-write_powered_verilog.log)...
[STEP 41]
[INFO]: Running LVS (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/41-lvs.lef.log)...
[STEP 42]
[INFO]: Running Magic DRC (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/42-drc.log)...
[INFO]: Converting Magic DRC database to various tool-readable formats...
[INFO]: No Magic DRC violations after GDS streaming out.
[STEP 43]
[INFO]: Running KLayout DRC (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/43-drc-klayout.log)...
[INFO]: No KLayout DRC violations after GDS streaming out.
[STEP 44]
[INFO]: Running OpenROAD Antenna Rule Checker (log: designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/logs/signoff/44-arc.log)...
[INFO]: Saving current set of views in 'designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/results/final'...
[INFO]: Saving runtime environment...
[INFO]: Generating final set of reports...
[INFO]: Created manufacturability report at 'designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/reports/manufacturability.rpt'.
[INFO]: Created metrics report at 'designs/iiitb_rv32i/runs/RUN_2024.04.09_03.57.04/reports/metrics.csv'.
[INFO]: There are no max slew, max fanout or max capacitance violations in the design at the Typical corner.
[INFO]: There are no hold violations in the design at the Typical corner.
[INFO]: There are no setup violations in the design at the Typical corner.
[SUCCESS]: Flow complete.
[INFO]: Note that the following warnings have been generated:
[WARNING]: 19 warnings found by linter
[WARNING]: VSRC_LOC_FILES was not given a value, which may make the results of IR drop analysis inaccurate. If you are not integrating a top-level chip for manufacture, you may ignore this warning, otherwise, see the documentation for VSRC_LOC_FILES.
```

The flow completed without any issues.

### STA for post-synthesis and post-routing. 

For the STA we will use special TCL script `iiirv32i_post_cts.tcl`:

```
read_liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_n40C_1v76.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_n40C_1v44.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_n40C_1v40.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_n40C_1v35.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_n40C_1v28.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_100C_1v60.lib
#read_liberty ./lib/sky130_fd_sc_hd__ss_100C_1v40.lib
#read_liberty ./lib/sky130_fd_sc_hd__ff_n40C_1v76.lib
#read_liberty ./lib/sky130_fd_sc_hd__ff_n40C_1v65.lib
#read_liberty ./lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
#read_liberty ./lib/sky130_fd_sc_hd__ff_100C_1v95.lib
#read_liberty ./lib/sky130_fd_sc_hd__ff_100C_1v65.lib

read_verilog ../runs/RUN_2024.04.09_03.57.04/results/final/verilog/gl/iiitb_rv32i.v
link_design iiitb_rv32i
current_design
read_spef ../runs/RUN_2024.04.09_03.57.04/results/final/spef/iiitb_rv32i.spef
read_sdc ../runs/RUN_2024.04.09_03.57.04/results/final/sdc/iiitb_rv32i.sdc
report_checks -path_delay min_max -fields {nets cap slew input_pins} -digits {4} > sta_out_min-max.txt
report_worst_slack -max -digits {4} > sta_out_worst-max.txt
report_worst_slack -min -digits {4} > sta_out_worst-min.txt
report_tns -digits {4} > sta_out_tns.txt
report_wns -digits {4} > sta_out_wns.txt
exit
```

In that script the OpenSTA read powered netlist, SPEFs file and final constraints file for analysis.

**STA report for Setup and typical process/voltage(1.8V)**

```
Startpoint: _14399_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _14463_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

      Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------
                       0.0000    0.0000   clock clk (rise edge)
                       0.8373    0.8373   clock network delay (propagated)
             0.1226    0.0000    0.8373 ^ _14399_/CLK (sky130_fd_sc_hd__dfxtp_1)
   0.0153    0.0788    0.3670    1.2044 v _14399_/Q (sky130_fd_sc_hd__dfxtp_1)
                                          ID_EX_B[18] (net)
             0.0788    0.0008    1.2051 v _10474_/A (sky130_fd_sc_hd__buf_1)
   0.0150    0.0918    0.1559    1.3611 v _10474_/X (sky130_fd_sc_hd__buf_1)
                                          _04036_ (net)
             0.0918    0.0003    1.3614 v _10746_/A (sky130_fd_sc_hd__nor3_2)
   0.0285    0.4914    0.4617    1.8231 ^ _10746_/Y (sky130_fd_sc_hd__nor3_2)
                                          _04308_ (net)
             0.4914    0.0015    1.8245 ^ _10749_/A (sky130_fd_sc_hd__nand4_4)
   0.0303    0.2179    0.2395    2.0640 v _10749_/Y (sky130_fd_sc_hd__nand4_4)
                                          _04311_ (net)
             0.2179    0.0020    2.0660 v _10771_/D (sky130_fd_sc_hd__nor4_1)
   0.0137    0.6028    0.5192    2.5852 ^ _10771_/Y (sky130_fd_sc_hd__nor4_1)
                                          _04333_ (net)
             0.6028    0.0003    2.5855 ^ _10779_/A (sky130_fd_sc_hd__buf_1)
   0.0137    0.1679    0.2330    2.8185 ^ _10779_/X (sky130_fd_sc_hd__buf_1)
                                          _04341_ (net)
             0.1679    0.0002    2.8186 ^ _10786_/A (sky130_fd_sc_hd__dlymetal6s2s_1)
   0.0207    0.2214    0.2488    3.0674 ^ _10786_/X (sky130_fd_sc_hd__dlymetal6s2s_1)
                                          _04348_ (net)
             0.2214    0.0008    3.0683 ^ _11048_/A2 (sky130_fd_sc_hd__a22oi_2)
   0.0089    0.0797    0.1325    3.2008 v _11048_/Y (sky130_fd_sc_hd__a22oi_2)
                                          _04609_ (net)
             0.0797    0.0003    3.2011 v _11281_/A0 (sky130_fd_sc_hd__mux2_1)
   0.0021    0.0516    0.2824    3.4835 v _11281_/X (sky130_fd_sc_hd__mux2_1)
                                          _04840_ (net)
             0.0516    0.0001    3.4835 v _11283_/A0 (sky130_fd_sc_hd__mux2_1)
   0.0201    0.1342    0.3729    3.8565 v _11283_/X (sky130_fd_sc_hd__mux2_1)
                                          _04842_ (net)
             0.1342    0.0006    3.8571 v _11290_/A2 (sky130_fd_sc_hd__o22a_1)
   0.0242    0.1401    0.3188    4.1758 v _11290_/X (sky130_fd_sc_hd__o22a_1)
                                          _04849_ (net)
             0.1401    0.0015    4.1774 v _11291_/B2 (sky130_fd_sc_hd__o2bb2a_1)
   0.0037    0.0576    0.3169    4.4942 v _11291_/X (sky130_fd_sc_hd__o2bb2a_1)
                                          _04850_ (net)
             0.0576    0.0001    4.4944 v _11302_/A2 (sky130_fd_sc_hd__a211o_1)
   0.0288    0.1547    0.4096    4.9039 v _11302_/X (sky130_fd_sc_hd__a211o_1)
                                          _04861_ (net)
             0.1547    0.0020    4.9060 v _11321_/A (sky130_fd_sc_hd__nand3_1)
   0.0122    0.1470    0.1731    5.0791 ^ _11321_/Y (sky130_fd_sc_hd__nand3_1)
                                          _04880_ (net)
             0.1470    0.0006    5.0797 ^ _11353_/B1 (sky130_fd_sc_hd__a22o_2)
   0.0432    0.2244    0.2980    5.3777 ^ _11353_/X (sky130_fd_sc_hd__a22o_2)
                                          _01523_ (net)
             0.2244    0.0015    5.3792 ^ _14463_/D (sky130_fd_sc_hd__dfxtp_1)
                                 5.3792   data arrival time

                      10.0000   10.0000   clock clk (rise edge)
                       0.7395   10.7395   clock network delay (propagated)
                      -0.2000   10.5395   clock uncertainty
                       0.0000   10.5395   clock reconvergence pessimism
                                10.5395 ^ _14463_/CLK (sky130_fd_sc_hd__dfxtp_1)
                      -0.0910   10.4485   library setup time
                                10.4485   data required time
-------------------------------------------------------------------------------
                                10.4485   data required time
                                -5.3792   data arrival time
-------------------------------------------------------------------------------
                                 5.0693   slack (MET) 
```

**STA report for Hold and typical process/voltage(1.8V)**

```
Startpoint: _13907_ (rising edge-triggered flip-flop clocked by clk)
Endpoint: _14453_ (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: min

      Cap      Slew     Delay      Time   Description
-------------------------------------------------------------------------------
                       0.0000    0.0000   clock clk (rise edge)
                       0.7588    0.7588   clock network delay (propagated)
             0.0872    0.0000    0.7588 ^ _13907_/CLK (sky130_fd_sc_hd__dfxtp_1)
   0.0062    0.0408    0.3210    1.0799 v _13907_/Q (sky130_fd_sc_hd__dfxtp_1)
                                          IF_ID_NPC[25] (net)
             0.0408    0.0002    1.0801 v _14453_/D (sky130_fd_sc_hd__dfxtp_1)
                                 1.0801   data arrival time

                       0.0000    0.0000   clock clk (rise edge)
                       0.7865    0.7865   clock network delay (propagated)
                       0.1000    0.8865   clock uncertainty
                       0.0000    0.8865   clock reconvergence pessimism
                                 0.8865 ^ _14453_/CLK (sky130_fd_sc_hd__dfxtp_1)
                      -0.0341    0.8524   library hold time
                                 0.8524   data required time
-------------------------------------------------------------------------------
                                 0.8524   data required time
                                -1.0801   data arrival time
-------------------------------------------------------------------------------
                                 0.2276   slack (MET) 
```

**Setup slack graph**

![iiitb_rv32a-STA-setup](https://github.com/pitman75/vsd-hdp/assets/12179612/14cb580a-3fcf-4026-8320-98741566e456)


**Hold slack graph**

![iiitb_rv32a-STA-hold](https://github.com/pitman75/vsd-hdp/assets/12179612/75540079-c1be-40e5-b55d-d2b577feb102)


For typical process and typical voltage 1.8V we acheive right values for hold/setup slack. Both are positive.

**Power**

```
===========================================================================
 report_power
============================================================================
======================= Fastest Corner ===================================

Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             9.54e-03   1.78e-03   5.28e-08   1.13e-02  48.3%
Combinational          3.18e-03   4.96e-03   4.56e-08   8.14e-03  34.7%
Clock                  1.47e-03   2.52e-03   1.97e-08   3.99e-03  17.0%
Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
----------------------------------------------------------------
Total                  1.42e-02   9.27e-03   1.18e-07   2.35e-02 100.0%
                          60.5%      39.5%       0.0%

======================= Slowest Corner ===================================

Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             6.46e-03   1.18e-03   2.31e-05   7.66e-03  48.1%
Combinational          2.30e-03   3.28e-03   3.91e-05   5.61e-03  35.2%
Clock                  1.06e-03   1.60e-03   1.57e-06   2.66e-03  16.7%
Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
----------------------------------------------------------------
Total                  9.82e-03   6.05e-03   6.38e-05   1.59e-02 100.0%
                          61.6%      38.0%       0.4%

======================= Typical Corner ===================================

Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             8.26e-03   1.50e-03   4.22e-08   9.76e-03  48.3%
Combinational          2.86e-03   4.18e-03   3.16e-08   7.05e-03  34.9%
Clock                  1.29e-03   2.11e-03   1.61e-08   3.40e-03  16.8%
Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
----------------------------------------------------------------
Total                  1.24e-02   7.79e-03   8.99e-08   2.02e-02 100.0%
                          61.4%      38.6%       0.0%
```

**Final report**

 - TotalCells: 23256
 - CoreArea_um^2: 178808.992
 - DIEAREA_mm^2 : 0.194174539625
 - Final_Util: 53.9892
 - wire_length: 400328

ASIC chip looks like

![iiitb_rv32i](https://github.com/pitman75/vsd-hdp/assets/12179612/ec83d25e-8046-4bb1-8379-edd93a7f672d)

Inside the ASIC

![iiitb_rv32i_inside](https://github.com/pitman75/vsd-hdp/assets/12179612/d07a3a61-e2d8-4df0-9388-c6d1391616c5)


</details>
