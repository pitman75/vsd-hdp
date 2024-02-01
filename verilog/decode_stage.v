`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 04:36:56 PM
// Design Name: 
// Module Name: decode_stage
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Decode stage of RISC-V pipeline MCU 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module decode_stage(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
    input [31:0] InstrD,        // Instructions
    input [31:0] PCD,
    input [31:0] PCPlus4D,
    input [31:0] ResultW,       // Write back to register result of operation
    input  [4:0] RdW,           // Address of a register for writing result
    input        RegWriteW,     // Enable write a register
    input  [1:0] ImmSrcD,       // Immediate data decode mode
    input        FlushE,        // Flush Execute stage

    // Outputs
    output  [4:0] Rs1D,
    output  [4:0] Rs2D,
    output [31:0] RD1E,
    output [31:0] RD2E,
    output [31:0] PCE,
    output  [4:0] Rs1E,
    output  [4:0] Rs2E,
    output  [4:0] RdE,
    output [31:0] ImmExtE,
    output [31:0] PCPlus4E
    );
    
    wire  [4:0] lc_RdD;
    wire [31:0] lc_RD1D;
    wire [31:0] lc_RD2D;
    wire [31:0] lc_ImmExtD;
    wire        lc_rst_FlushE;
    
    assign lc_rst_FlushE = rst | FlushE;
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign lc_RdD = InstrD[11:7];
    
    registers_file #(.REGISTERS_INIT_FILE("registers_file_init_blank.mem")) reg_file (
    // Input
    .clk(clk),
    .write_en_3(RegWriteW),
    .read_addr_1(InstrD[19:15]),
    .read_addr_2(InstrD[24:20]),
    .write_addr_3(RdW),
    .write_data_3(ResultW),

    // Output
    .read_data_1(lc_RD1D),
    .read_data_2(lc_RD2D)
  );

  imm_ext_multi imm_ext_multi_1 (
    // Input
    .in_data(InstrD[31:7]),
    .imm_src(ImmSrcD),

    // Output
    .out_data(lc_ImmExtD)
  );
  
  reg_rst_param #(.WIDTH(32)) reg_RD1D (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(lc_RD1D),
    
    // Outputs
    .read_data(RD1E)
  );
  
  reg_rst_param #(.WIDTH(32)) reg_RD2D (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(lc_RD2D),
    
    // Outputs
    .read_data(RD2E)
  );
  
  reg_rst_param #(.WIDTH(32)) reg_PCD (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(PCD),
    
    // Outputs
    .read_data(PCE)
  );
  
  reg_rst_param #(.WIDTH(5)) reg_Rs1D (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(InstrD[19:15]),
    
    // Outputs
    .read_data(Rs1E)
  );
  
  reg_rst_param #(.WIDTH(5)) reg_Rs2D (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(InstrD[24:20]),
    
    // Outputs
    .read_data(Rs2E)
  );
  
  reg_rst_param #(.WIDTH(5)) reg_RdD (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(lc_RdD),
    
    // Outputs
    .read_data(RdE)
  );
  
  reg_rst_param #(.WIDTH(32)) reg_ImmExtD (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(lc_ImmExtD),
    
    // Outputs
    .read_data(ImmExtE)
  );
  
  reg_rst_param #(.WIDTH(32)) reg_PCPlus4D (
    // Inputs
    .clk(clk),
    .flush(lc_rst_FlushE),
    .write_data(PCPlus4D),
    
    // Outputs
    .read_data(PCPlus4E)
  );
  
endmodule
