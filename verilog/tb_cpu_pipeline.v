`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/30/2023 04:44:05 PM
// Design Name: 
// Module Name: tb_cpu_pipeline
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Testbench of RISC-V pipeline core
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_pipeline_tb;

// Parameters
parameter CLK_PERIOD = 10;
parameter TICK_SIMULATE = 50;

// Inputs
reg clk, rst;

// Outputs

// Local varaibles
integer i;

// Instantiate the DUT
cpu_pipeline dut (
    // Input
    .clk(clk),
    .rst(rst)
);

integer     errors_counter = 0;

// Clock generator
initial // Clock generator
  begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = !clk;
  end

// Test all possible input values
initial begin
    $dumpfile("tb_cpu_pipeline.vcd");
    $dumpvars(0,cpu_pipeline_tb);

    $display("START: Test CPU");

    // Set Reset signal
    rst = 1'b1;

    @(negedge clk)
    @(negedge clk)

    // Release Reset signal
    rst = 1'b0;

    @(negedge clk)
    @(negedge clk)

    for (i = 0; i < TICK_SIMULATE; i = i + 1)
    begin
        @(negedge clk)
        $display("LOG: Tick %d", i);
    end

    $display("STOP: Simulation done.");
    if (errors_counter == 0)
    begin
        $display("RESULT: PASSED");
    end
    else
    begin
        $display("RESULT: FAIL");
        $display("ERRORS: %d", errors_counter);
    end
    $finish;
end

endmodule
