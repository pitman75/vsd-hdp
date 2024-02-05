# read library
read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# read design
read_verilog -defer cpu_pipeline.v

# read hierarhy
hierarchy -top cpu_pipeline -libdir .

# generic synthesis
synth -top cpu_pipeline

# mapping to mycells.lib
dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
proc; opt
abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
flatten
# write synthesized design
write_verilog -noattr cpu_pipeline_net.v
