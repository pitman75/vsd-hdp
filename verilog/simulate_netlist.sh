#!/bin/bash
iverilog  -DFUNCTIONAL -DUNIT_DELAY=#1 ../lib/verilog_model/primitives.v ../lib/verilog_model/sky130_fd_sc_hd.v cpu_pipeline_net.v tb_cpu_pipeline.v
./a.out
gtkwave tb_cpu_pipeline.vcd cpu_pipeline_tb.gtkw
