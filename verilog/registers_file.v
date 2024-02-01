`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/29/2023 05:16:11 PM
// Design Name: 
// Module Name: registers_file
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Registers file
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module registers_file 
#(
  parameter REGISTERS_INIT_FILE = ""
)
(
    // Inputs
    input clk,
    input write_en_3,
    input [4:0] read_addr_1,
    input [4:0] read_addr_2,
    input [4:0] write_addr_3,
    input [31:0] write_data_3,
    // Outputs
    output [31:0] read_data_1,
    output [31:0] read_data_2
);

reg [31:0] lc_registers [0:31];

initial if (REGISTERS_INIT_FILE) begin: registers_init
    integer k;

    $display("SRC:INFO: Before start init PC registers file");

    for (k = 0; k < 32; k = k + 1)
    begin
        $display("SRC:INFO: Register %d: 0x%08X", k, lc_registers[k]);
    end

    $readmemh(REGISTERS_INIT_FILE, lc_registers, 0, 31);

    $display("SRC:INFO: After start init PC registers file");
    for (k = 0; k < 32; k = k + 1)
    begin
        $display("SRC:INFO: Register %d: 0x%08X", k, lc_registers[k]);
    end
end

wire [4:0] inv_read_addr_1;
wire [4:0] inv_read_addr_2;
wire [4:0] inv_write_addr_3;

wire read_addr_1_reg_zero_fl;
wire read_addr_2_reg_zero_fl;
wire write_addr_3_reg_zero_fl;

reg  write_forward_rd1_fl;
reg  write_forward_rd2_fl;

assign inv_read_addr_1 = ~read_addr_1;
assign inv_read_addr_2 = ~read_addr_2;
assign inv_write_addr_3 = ~write_addr_3;

assign read_addr_1_reg_zero_fl = &inv_read_addr_1;
assign read_addr_2_reg_zero_fl = &inv_read_addr_2;
assign write_addr_3_reg_zero_fl = &inv_write_addr_3;

always @(*) begin
    if (write_en_3) begin
        if (read_addr_1 == write_addr_3) begin
            write_forward_rd1_fl <= 1'b1;
        end
        else begin
            write_forward_rd1_fl <= 1'b0;
        end
    end
    else begin
        write_forward_rd1_fl <= 1'b0;
    end
end

always @(*) begin
    if (write_en_3) begin
        if (read_addr_2 == write_addr_3) begin
            write_forward_rd2_fl <= 1'b1;
        end
        else begin
            write_forward_rd2_fl <= 1'b0;
        end
    end
    else begin
        write_forward_rd2_fl <= 1'b0;
    end
end

assign read_data_1 = (read_addr_1_reg_zero_fl == 1'b1) ? 32'h00000000 : {(write_forward_rd1_fl) ? write_data_3 : lc_registers[read_addr_1]};
assign read_data_2 = (read_addr_2_reg_zero_fl == 1'b1) ? 32'h00000000 : {(write_forward_rd2_fl) ? write_data_3 : lc_registers[read_addr_2]};

always @(posedge clk)
begin
    if (write_en_3)
        if (~write_addr_3_reg_zero_fl)
        begin
            lc_registers[write_addr_3] <= write_data_3;
        end
end

endmodule
