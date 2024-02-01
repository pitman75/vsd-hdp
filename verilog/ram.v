`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/30/2023 01:16:47 PM
// Design Name: 
// Module Name: ram
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: parametrized RAM module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ram
#(
  parameter RAM_SIZE = 32,  //# size of RAM by 4 bytes elements
  parameter RAM_INIT_FILE = "ram_init.mem"
)
(
    // Input
    input             clk,
    input             write_enable,
    input      [31:0] addr,
    input      [31:0] write_data,
    
    // Output
    output     [31:0] read_data
);

reg [31:0] ram_array[0 : RAM_SIZE - 1];

initial begin: ram_init
    integer k;

    $display("SRC:INFO: Before start init RAM array");

    for (k = 0; k < RAM_SIZE; k = k + 1)
    begin
        $display("SRC:INFO: RAM [0x%08X]: 0x%08X", k << 2, ram_array[k]);
    end

    $readmemh(RAM_INIT_FILE, ram_array, 0, RAM_SIZE - 1);

    $display("SRC:INFO: After start init RAM array");

    for (k = 0; k < RAM_SIZE; k = k + 1)
    begin
        $display("SRC:INFO: RAM [0x%08X]: 0x%08X", k << 2, ram_array[k]);
    end
end

wire [31:0] ram_address;

assign ram_address[31:0] = {1'b0, 1'b0, addr[31:2]};

always @(posedge clk) begin
    if (write_enable) begin
        ram_array[ram_address] <= write_data;
    end
end

assign read_data = ram_array[ram_address];

endmodule
