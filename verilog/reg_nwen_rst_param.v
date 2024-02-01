`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/29/2023 04:21:58 PM
// Design Name: 
// Module Name: reg_nwen_rst_param
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Register with write enable low logic and reset high logic
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_nwen_rst_param
#(
    parameter WIDTH = 32
)
(
    // Input
    input                        clk,
    input                        flush,
    input                        nwrite_enable,
    input      [WIDTH - 1:0] write_data,
    
    // Output
    output     [WIDTH - 1:0] read_data
);

    reg [WIDTH - 1:0] lc_data;
    wire [WIDTH - 1:0] lc_zero = 0;
    
    always @(posedge clk) begin
        if (flush) begin
            lc_data <= lc_zero;
        end else
        if (nwrite_enable == 1'b0) begin
            lc_data <= write_data;
        end
    end
    
    assign read_data = lc_data;

endmodule
