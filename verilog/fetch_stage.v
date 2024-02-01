`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 04:26:42 PM
// Design Name: 
// Module Name: fetch_stage
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Fetch stage of RISC-V pipeline MCU 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fetch_stage(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
    input [31:0] PCTargetE,
    input        PCSrcE,
    input        StallF,        // Stall to read flash
    input        StallD,        // Stall to read data
    input        FlushD,        // Flush data
    
    // Outputs
    output [31:0] InstrD,       // Instructions
    output [31:0] PCPlus4D,     // PC+4 address
    output [31:0] PCD           // PC address
    );

    wire [31:0] lc_PCPlus4F;
    wire [31:0] lc_PCF_dot;
    wire [31:0] lc_PCF;
    wire [31:0] lc_InstrF;
    wire        lc_rst_FlushD;
    
    assign lc_rst_FlushD = rst | FlushD;

    mux_2to1_param #(.WIDTH(32)) in_mux (
        // Inputs
        .control(PCSrcE),
        .input_A(lc_PCPlus4F),
        .input_B(PCTargetE),
        
        // Outputs
        .output_MUX(lc_PCF_dot)
    );
    
    pc_register_nwen #(.RESET_ADDRESS(0)) pc_reg (
        // Inputs
        .clk(clk),
        .rst(rst),
        .nwen(StallF),
        .new_pc_value(lc_PCF_dot),
        
        // Outputs
        .pc_value(lc_PCF)
    );
    
    assign lc_PCPlus4F = lc_PCF + 4;
    
    reg_nwen_rst_param #(.WIDTH(32)) pcd_reg (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushD),
        .nwrite_enable(StallD),
        .write_data(lc_PCF),
        
        // Outputs
        .read_data(PCD)
    );
    
    reg_nwen_rst_param #(.WIDTH(32)) pcdplus4_reg (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushD),
        .nwrite_enable(StallD),
        .write_data(lc_PCPlus4F),
        
        // Outputs
        .read_data(PCPlus4D)
    );
    
    reg_nwen_rst_param #(.WIDTH(32)) instf_reg (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushD),
        .nwrite_enable(StallD),
        .write_data(lc_InstrF),
        
        // Outputs
        .read_data(InstrD)
    );
    
    // Test long for 21 commands (page 543)
    rom_tb_01 #(.ROM_SIZE(100), .ROM_INIT_FILE("rom_init.mem")) rom_prog (
        // Input
        .addr(lc_PCF),

        // Output
        .data(lc_InstrF)
    );

endmodule
