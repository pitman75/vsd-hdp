`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/29/2023 03:49:32 PM
// Design Name: 
// Module Name: mux_2to1_param
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Parametrized multiplexor 4 to 1
// 
// 0 - output A
// 1 - output B
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_2to1_param
#(
  parameter WIDTH = 32  //# width of data
)
(
    // Inputs
    input               control,
    input [WIDTH - 1:0] input_A,
    input [WIDTH - 1:0] input_B,
    
    // Outputs
    output [WIDTH - 1:0] output_MUX
);
    
    assign output_MUX = (control == 1'b1) ? input_B : input_A;
    
endmodule
