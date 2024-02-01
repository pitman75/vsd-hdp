`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 05/27/2023 11:05:55 AM
// Design Name: 
// Module Name: rom_tb_01
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: The testbench for RISC-V from Harris's book
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rom_tb_01
#(
  parameter ROM_SIZE = 32,  //# size of RAM by 4 bytes elements
  parameter ROM_INIT_FILE = "rom_init.mem"
)
(
    // Input
    input      [31:0] addr,
    
    // Output
    output     [31:0] data
);

reg [31:0] rom_array[0 : ROM_SIZE - 1];

initial begin: rom_init
    integer k;

    $display("SRC:INFO: Before start init ROM array");

    for (k = 0; k < ROM_SIZE; k = k + 1)
    begin
        $display("SRC:INFO: ROM [0x%08X]: 0x%08X", k << 2, rom_array[k]);
    end

    $readmemh(ROM_INIT_FILE, rom_array, 0, ROM_SIZE - 1);

    $display("SRC:INFO: After start init ROM array");

    for (k = 0; k < ROM_SIZE; k = k + 1)
    begin
        $display("SRC:INFO: ROM [0x%08X]: 0x%08X", k << 2, rom_array[k]);
    end
end

    wire [31:0] rom_address;

    assign rom_address[31:0] = {1'b0, 1'b0, addr[31:2]};
    assign data = rom_array[rom_address];

endmodule




