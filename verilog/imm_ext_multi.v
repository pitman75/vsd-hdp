`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 05/13/2023 09:10:57 PM
// Design Name: 
// Module Name: imm_ext_multi
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module imm_ext_multi (
    // Inputs
    input [24:0] in_data,
    input [1:0] imm_src,
    
    // Outputs
    output [31:0] out_data
);

    assign out_data = {imm_src[1] == 1'b1} ? {{imm_src[0] == 1'b1} ? {{12{in_data[24]}}, in_data[12:5], in_data[13], in_data[23:14], 1'b0} : {{20{in_data[24]}}, in_data[0], in_data[23:18], in_data[4:1], 1'b0}} : {{{imm_src[0] == 1'b1} ? {{20{in_data[24]}}, in_data[24:18], in_data[4:0]} : {{20{in_data[24]}}, in_data[24:13]}}};

endmodule

