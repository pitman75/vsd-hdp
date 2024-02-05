#!/bin/bash

iverilog cpu_pipeline.v alu_stage.v control_pipeline.v decode_stage.v fetch_stage.v hazard_pipeline.v memory_stage.v writeback_stage.v alu.v imm_ext_multi.v mux_2to1_param.v mux_4to1_param.v pc_register_nwen.v ram.v reg_nwen_rst_param.v reg_rst_param.v registers_file.v rom_tb_01.v tb_cpu_pipeline.v 
./a.out
gtkwave tb_cpu_pipeline.vcd cpu_pipeline_tb.gtkw
