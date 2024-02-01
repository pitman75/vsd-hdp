`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 05:11:58 PM
// Design Name: 
// Module Name: writeback_stage
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Register writeback stage of RISC-V pipeline MCU
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module writeback_stage(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
    input [31:0] ALUResultW,
    input [31:0] ReadDataW,
    input [31:0] PCPlus4W,
    input  [1:0] ResultSrcW,
    
    // Output
    output [31:0] ResultW
    );
    
    mux_4to1_param  #(.WIDTH(32)) out_mux (
        // Inputs
        .control(ResultSrcW),
        .input_A(ALUResultW),
        .input_B(ReadDataW),
        .input_C(PCPlus4W),
        .input_D(32'hXXXXXXXX),
        
        // Outputs
        .output_MUX(ResultW)
    );
    
endmodule
