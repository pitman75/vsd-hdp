`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 05:04:28 PM
// Design Name: 
// Module Name: memory_stage
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Memory stage of RISC-V pipeline MCU
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory_stage(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
    input [31:0] ALUResultM,
    input [31:0] WriteDataM,
    input  [4:0] RdM,
    input [31:0] PCPlus4M,
    input        MemWriteM,
    
    // Output
    output [31:0] ALUResultW,
    output [31:0] ReadDataW,
    output [31:0] PCPlus4W,
    output  [4:0] RdW
    );
    
    wire [31:0] lc_ReadDataM;
    
    ram #(.RAM_SIZE(200), .RAM_INIT_FILE("ram_init_blank.mem")) ram_1 (
        // Input
        .clk(clk),
        .write_enable(MemWriteM),
        .addr({{24{1'b0}}, ALUResultM[7:0]}),
        .write_data(WriteDataM),
    
        // Output
        .read_data(lc_ReadDataM)
    );
    
    reg_rst_param #(.WIDTH(32)) reg_ALUResultM (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(ALUResultM),
        
        // Outputs
        .read_data(ALUResultW)
    );
    
    reg_rst_param #(.WIDTH(32)) reg_ReadDataM (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(lc_ReadDataM),
        
        // Outputs
        .read_data(ReadDataW)
    );
    
    reg_rst_param #(.WIDTH(32)) reg_PCPlus4M (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(PCPlus4M),
        
        // Outputs
        .read_data(PCPlus4W)
    );
    
    reg_rst_param #(.WIDTH(5)) reg_RdM (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(RdM),
        
        // Outputs
        .read_data(RdW)
    );

endmodule
