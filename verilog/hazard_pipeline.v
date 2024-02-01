`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 05:18:39 PM
// Design Name: 
// Module Name: hazard_pipeline
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Hazard of RISC-V pipeline MCU
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hazard_pipeline(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
    input  [4:0] Rs1D,
    input  [4:0] Rs2D,
    input  [4:0] Rs1E,
    input  [4:0] Rs2E,
    input  [4:0] RdE,
    input        PCSrcE,
    input  [1:0] ResultSrcE,
    input        RegWriteM,
    input  [4:0] RdM,
    input        RegWriteW,
    input  [4:0] RdW,
    
    // Outputs
    output       StallF,
    output       StallD,
    output       FlushD,
    output       FlushE,
    output [1:0] ForwardAE,
    output [1:0] ForwardBE
    );
    
    reg  [1:0] lc_ForwardAE;
    reg  [1:0] lc_ForwardBE;
    wire       lc_Stall;        
    
    assign ForwardAE = lc_ForwardAE;
    assign ForwardBE = lc_ForwardBE;
    
    always @(*) begin
        if (((Rs1E == RdM) & RegWriteM) & (Rs1E != 0))begin
            lc_ForwardAE <= 2'b10;
        end
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 0))begin
            lc_ForwardAE <= 2'b01;
        end
        else begin
            lc_ForwardAE <= 2'b00;
        end
    end

    always @(*) begin
        if (((Rs2E == RdM) & RegWriteM) & (Rs2E != 0))begin
            lc_ForwardBE <= 2'b10;
        end
        else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 0))begin
            lc_ForwardBE <= 2'b01;
        end
        else begin
            lc_ForwardBE <= 2'b00;
        end
    end
    
    assign lc_Stall = ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE));
    assign StallF = lc_Stall;
    assign StallD = lc_Stall;
    
    assign FlushD = PCSrcE;
    assign FlushE = lc_Stall | PCSrcE;
    
endmodule
