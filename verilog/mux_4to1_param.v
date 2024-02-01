`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/29/2023 03:34:59 PM
// Design Name: 
// Module Name: mux_4to1_param
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Parametrized multiplexor 4 to 1
//
// 00 - output A
// 01 - output B
// 10 - output C
// 11 - output D
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_4to1_param
#(
  parameter WIDTH = 32  //# width of data
)
(
    // Inputs
    input [1:0] control,
    input [WIDTH - 1:0] input_A,
    input [WIDTH - 1:0] input_B,
    input [WIDTH - 1:0] input_C,
    input [WIDTH - 1:0] input_D,
    
    // Outputs
    output [WIDTH - 1:0] output_MUX
    );
    
    assign output_MUX = (control[1] == 1'b1) ? {(control[0] == 1'b1) ? input_D : input_C} : {(control[0] == 1'b1) ? input_B : input_A};
    
endmodule
