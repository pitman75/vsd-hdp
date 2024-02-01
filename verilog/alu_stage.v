`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 04:50:35 PM
// Design Name: 
// Module Name: alu_stage
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: ALU stage of RISC-V pipeline MCU 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_stage(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
    input [31:0] RD1E,
    input [31:0] RD2E,
    input [31:0] PCE,
    input  [4:0] RdE,
    input [31:0] ImmExtE,
    input [31:0] PCPlus4E,
    input [31:0] ResultW,
    input [31:0] ALUResultM_back,
    input        ALUSrcE,
    input  [2:0] ALUControlE,
    input  [1:0] ForwardAE,
    input  [1:0] ForwardBE,
    
    
    // Output
    output [31:0] ALUResultM,
    output [31:0] WriteDataM,
    output [31:0] PCTargetE,
    output [31:0] PCPlus4M,
    output  [4:0] RdM,
    output        ZeroE
    );
    
    wire [31:0] lc_SrcAE;
    wire [31:0] lc_SrcBE;
    wire [31:0] lc_WriteDataE;
    wire [31:0] lc_ALUResultE;
    wire  [3:0] lc_ALUFlagsE;
    
    assign PCTargetE = PCE + ImmExtE;
    
    mux_4to1_param #(.WIDTH(32)) src_ae_mux (
        // Inputs
        .control(ForwardAE),
        .input_A(RD1E),
        .input_B(ResultW),
        .input_C(ALUResultM_back),
        .input_D(32'hXXXXXXXX),
        
        // Outputs
        .output_MUX(lc_SrcAE)
    );
    
    mux_4to1_param #(.WIDTH(32)) src_be_dot_mux (
        // Inputs
        .control(ForwardBE),
        .input_A(RD2E),
        .input_B(ResultW),
        .input_C(ALUResultM_back),
        .input_D(32'hXXXXXXXX),
        
        // Outputs
        .output_MUX(lc_WriteDataE)
    );
    
    mux_2to1_param #(.WIDTH(32)) src_be_mux (
        // Inputs
        .control(ALUSrcE),
        .input_A(lc_WriteDataE),
        .input_B(ImmExtE),
        
        // Outputs
        .output_MUX(lc_SrcBE)
    );
    
    alu alu_1 (
        // Input
        .input_a(lc_SrcAE),
        .input_b(lc_SrcBE),
        .alu_control(ALUControlE),
    
        // Output
        .result(lc_ALUResultE),
        .flags(lc_ALUFlagsE)
    );
    
    assign ZeroE = lc_ALUFlagsE[2];
    
    reg_rst_param #(.WIDTH(32)) reg_ALUResultE (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(lc_ALUResultE),
        
        // Outputs
        .read_data(ALUResultM)
    );

    reg_rst_param #(.WIDTH(32)) reg_WriteDataE (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(lc_WriteDataE),
        
        // Outputs
        .read_data(WriteDataM)
    );
    
    reg_rst_param #(.WIDTH(5)) reg_RdE (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(RdE),
        
        // Outputs
        .read_data(RdM)
    );
    
    reg_rst_param #(.WIDTH(32)) reg_PCPlus4E (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(PCPlus4E),
        
        // Outputs
        .read_data(PCPlus4M)
    );
    
endmodule
