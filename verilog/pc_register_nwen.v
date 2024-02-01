`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/30/2023 01:16:47 PM
// Design Name: 
// Module Name: pc_register_nwen
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


module pc_register_nwen
#(
  parameter RESET_ADDRESS = 32'h00000000  //# reset address
)
(
    // Input
    input clk,                  // Clock 
    input rst,                  // Reset
    input nwen,                 // Write enable low logic
    input [31:0] new_pc_value,  // New value
    
    // Output
    output reg [31:0] pc_value  // Output value
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    pc_value <= RESET_ADDRESS;
  end 
  else
    if (nwen == 1'b0) begin
        pc_value <= new_pc_value;
    end
end

endmodule
