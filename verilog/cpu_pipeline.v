`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 06:48:52 PM
// Design Name: 
// Module Name: cpu_pipeline
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: RISC-V pipeline MCU main project file
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_pipeline(
    // Inputs
    input         clk,          // Clock 
    input         rst,          // Reset

    output [31:0] mem_addr,     // Address for I/O RAM
    output [31:0] mem_write,    // Write data to RAM
    output        mem_wen,      // RAM write enable flag
    output [31:0] data_result   // Output data from writeback stage
    );
    
    // Fetch signals
    wire        lc_StallF;
    
    // Decode signals
    wire        lc_StallD;
    wire        lc_FlushD;
    wire [31:0] lc_InstrD;
    wire [31:0] lc_PCPlus4D;
    wire [31:0] lc_PCD;
    wire  [1:0] lc_ImmSrcD;
    wire  [4:0] lc_Rs1D;
    wire  [4:0] lc_Rs2D;
    
    // Execute signals
    wire [31:0] lc_PCTargetE;
    wire        lc_PCSrcE;
    wire        lc_FlushE;
    wire [31:0] lc_RD1E;
    wire [31:0] lc_RD2E;
    wire [31:0] lc_PCE;
    wire  [4:0] lc_Rs1E;   
    wire  [4:0] lc_Rs2E;
    wire  [4:0] lc_RdE;
    wire [31:0] lc_ImmExtE;
    wire [31:0] lc_PCPlus4E;
    wire        lc_ALUSrcE;
    wire  [2:0] lc_ALUControlE;
    wire  [1:0] lc_ForwardAE;
    wire  [1:0] lc_ForwardBE;
    wire        lc_ZeroE;
    wire  [1:0] lc_ResultSrcE;
     
    // Memory signals
    wire [31:0] lc_ALUResultM;
    wire [31:0] lc_ALUResultM_back;
    wire [31:0] lc_WriteDataM;
    wire [31:0] lc_PCPlus4M;
    wire  [4:0] lc_RdM;
    wire        lc_RegWriteM;
    wire        lc_MemWriteM;
        
    // Writeback signals
    wire [31:0] lc_ALUResultW;
    wire [31:0] lc_ReadDataW;
    wire  [4:0] lc_RdW;
    wire        lc_RegWriteW;
    wire  [1:0] lc_ResultSrcW;
    wire [31:0] lc_ResultW;
    wire [31:0] lc_PCPlus4W;
    
    // 1 - Fetch
    fetch_stage fetch (
        // Inputs
        .clk(clk),
        .rst(rst),
        .PCTargetE(lc_PCTargetE),
        .PCSrcE(lc_PCSrcE),
        .StallF(lc_StallF),
        .StallD(lc_StallD),
        .FlushD(lc_FlushD),
        
        // Outputs
        .InstrD(lc_InstrD),
        .PCPlus4D(lc_PCPlus4D),
        .PCD(lc_PCD)
    );
    
    // 2 - Decode
    decode_stage decode (
        // Inputs
        .clk(clk),
        .rst(rst),
        .InstrD(lc_InstrD),
        .PCD(lc_PCD),
        .PCPlus4D(lc_PCPlus4D),
        .ResultW(lc_ResultW),
        .RdW(lc_RdW),
        .RegWriteW(lc_RegWriteW),
        .ImmSrcD(lc_ImmSrcD),
        .FlushE(lc_FlushE),
        
        // Outputs
        .Rs1D(lc_Rs1D),
        .Rs2D(lc_Rs2D),
        .RD1E(lc_RD1E),
        .RD2E(lc_RD2E),
        .PCE(lc_PCE),
        .Rs1E(lc_Rs1E),
        .Rs2E(lc_Rs2E),
        .RdE(lc_RdE),
        .ImmExtE(lc_ImmExtE),
        .PCPlus4E(lc_PCPlus4E)
    );
    
    // 3 - Execute/ALU
    alu_stage alu (
        // Inputs
        .clk(clk),
        .rst(rst),
        .RD1E(lc_RD1E),
        .RD2E(lc_RD2E),
        .PCE(lc_PCE),
        .RdE(lc_RdE),
        .ImmExtE(lc_ImmExtE),
        .PCPlus4E(lc_PCPlus4E),
        .ResultW(lc_ResultW),
        .ALUResultM_back(lc_ALUResultM_back),
        .ALUSrcE(lc_ALUSrcE),
        .ALUControlE(lc_ALUControlE),
        .ForwardAE(lc_ForwardAE),
        .ForwardBE(lc_ForwardBE),
        
        // Outputs
        .ALUResultM(lc_ALUResultM),
        .WriteDataM(lc_WriteDataM),
        .PCTargetE(lc_PCTargetE),
        .PCPlus4M(lc_PCPlus4M),
        .RdM(lc_RdM),
        .ZeroE(lc_ZeroE)
    );
    
    assign lc_ALUResultM_back = lc_ALUResultM;
    
    // 4 - Memory read/write
    memory_stage memory (
        // Inputs
        .clk(clk),
        .rst(rst),
        .ALUResultM(lc_ALUResultM),
        .WriteDataM(lc_WriteDataM),
        .RdM(lc_RdM),
        .PCPlus4M(lc_PCPlus4M),
        .MemWriteM(lc_MemWriteM),
        
        // Outputs
        .ALUResultW(lc_ALUResultW),
        .ReadDataW(lc_ReadDataW),
        .PCPlus4W(lc_PCPlus4W),
        .RdW(lc_RdW)
    );
    
    // 5 - Writeback
    writeback_stage writeback (
        // Inputs
        .clk(clk),
        .rst(rst),
        .ALUResultW(lc_ALUResultW),
        .ReadDataW(lc_ReadDataW),
        .PCPlus4W(lc_PCPlus4W),
        .ResultSrcW(lc_ResultSrcW),
        
        // Outputs
        .ResultW(lc_ResultW)
    );
    
    // Hazard module
    hazard_pipeline hazard (
        // Inputs
        .clk(clk),
        .rst(rst),
        .Rs1D(lc_Rs1D),
        .Rs2D(lc_Rs2D),
        .Rs1E(lc_Rs1E),
        .Rs2E(lc_Rs2E),
        .RdE(lc_RdE),
        .PCSrcE(lc_PCSrcE),
        .ResultSrcE(lc_ResultSrcE),
        .RegWriteM(lc_RegWriteM),
        .RdM(lc_RdM),
        .RegWriteW(lc_RegWriteW),
        .RdW(lc_RdW),
        
        // Outputs
        .StallF(lc_StallF),
        .StallD(lc_StallD),
        .FlushD(lc_FlushD),
        .FlushE(lc_FlushE),
        .ForwardAE(lc_ForwardAE),
        .ForwardBE(lc_ForwardBE)
    );
    
    // Control module
    control_pipeline control (
        // Inputs
        .clk(clk),
        .rst(rst),
        .InstrD(lc_InstrD),
        .FlushE(lc_FlushE),
        .ZeroE(lc_ZeroE),
        
        // Outputs
        .ImmSrcD(lc_ImmSrcD),
        .ALUControlE(lc_ALUControlE),
        .ALUSrcE(lc_ALUSrcE),
        .ResultSrcE(lc_ResultSrcE),
        .PCSrcE(lc_PCSrcE),
        .RegWriteM(lc_RegWriteM),
        .MemWriteM(lc_MemWriteM),
        .RegWriteW(lc_RegWriteW),
        .ResultSrcW(lc_ResultSrcW)
    );
    
    assign mem_addr    = lc_ALUResultM;
    assign mem_write   = lc_WriteDataM;
    assign mem_wen     = lc_MemWriteM;
    assign data_result = lc_ResultW;

endmodule
