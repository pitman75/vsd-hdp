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
