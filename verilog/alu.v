`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 04/22/2023 03:01:50 PM
// Design Name: 
// Module Name: alu
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: ALU unit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    // Input signals
    input [31:0] input_a,
    input [31:0] input_b,
    input  [2:0] alu_control,
    
    // Output signals
    output reg [31:0] result,
    output  [3:0] flags
    );
    
    wire [31:0] lc_a_and_b;
    wire [31:0] lc_a_or_b;
    wire [32:0] lc_sub_result;
    wire        lc_neg, lc_zero, lc_carry, lc_over;
    reg         lc_cout;
    
    assign lc_a_and_b = input_a & input_b;
    assign lc_a_or_b = input_a | input_b;
    assign lc_sub_result = {1'b0, input_a} - {1'b0, input_b};
    
    always @(input_a or input_b or alu_control or lc_a_and_b or lc_a_or_b or lc_sub_result or lc_over) begin
        case (alu_control)
        3'b000: {lc_cout, result} <= input_a + input_b;
        3'b001: {lc_cout, result} <= lc_sub_result;
        3'b010: {lc_cout, result} <= {1'b0, lc_a_and_b};
        3'b011: {lc_cout, result} <= {1'b0, lc_a_or_b};
        3'b101: {lc_cout, result} <= {1'b0, {31{1'b0}}, (lc_sub_result[31] ^ lc_over)};
        default: {lc_cout, result} <= 33'd0;
        endcase
    end
    
    assign lc_neg = result[31];
    assign lc_zero = ~|result;
    assign lc_carry = lc_cout & ~alu_control[1];
    assign lc_over = (~alu_control[1]) & (result[31] ^ input_a[31]) & (~(alu_control[0] ^ input_a[31] ^ input_b[31]));
    
    assign flags = {lc_neg, lc_zero, lc_carry, lc_over};
    
endmodule
