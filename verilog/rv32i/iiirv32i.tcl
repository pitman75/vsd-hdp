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
