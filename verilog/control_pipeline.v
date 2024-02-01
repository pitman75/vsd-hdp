`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal project
// Engineer: Dmitrii Belimov <d.belimov@gmail.com>
// 
// Create Date: 06/28/2023 05:17:22 PM
// Design Name: 
// Module Name: control_pipeline
// Project Name: RISC-V core
// Target Devices: 
// Tool Versions: 
// Description: Control module of RISC-V pipeline MCU
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module control_pipeline(
    // Inputs
    input        clk,           // Clock 
    input        rst,           // Reset
       // Stage Decode
    input [31:0] InstrD,        // Instructions
       // Stage ALU
    input        FlushE,        // Flush Execute stage
    input        ZeroE,
    
    // Outputs
       // Stage Decode    
    output  [1:0] ImmSrcD,       // Immediate data decode mode
       // Stage ALU
    output  [2:0] ALUControlE,
    output        ALUSrcE,
    output        RegWriteE,
    output  [1:0] ResultSrcE,
    output        PCSrcE,
    output        MemWriteE,
       // Stage Memory
    output        RegWriteM,
    output  [1:0] ResultSrcM,
    output        MemWriteM,
       // Stage Writeback
    output        RegWriteW,
    output  [1:0] ResultSrcW
    );
    
    wire      lc_rst_FlushE;
    // Decode stage
    reg       lc_RegWriteD;
    reg [1:0] lc_ResultSrcD;
    reg       lc_MemWriteD;
    reg       lc_JumpD;
    reg       lc_BranchD;
    reg [2:0] lc_ALUControlD;
    reg       lc_ALUSrcD;
    reg [1:0] lc_ImmSrcD;
    
    // Execute/ALU stage
    wire       lc_JumpE;
    wire       lc_BranchE;
    wire [2:0] lc_ALUControlE;
    wire       lc_ALUSrcE;
    
    reg [1:0 ] lc_alu_op;
    wire [6:0] lc_alu_decoder_in;
    
    assign lc_rst_FlushE = rst | FlushE;
    assign lc_alu_decoder_in = {lc_alu_op, InstrD[14:12], InstrD[5], InstrD[30]};
    
    assign PCSrcE = (ZeroE & lc_BranchE) | lc_JumpE;
    assign ALUControlE = lc_ALUControlE;
    assign ALUSrcE = lc_ALUSrcE;
    assign ImmSrcD = lc_ImmSrcD;
    
    always @(InstrD or rst) begin
        if (rst) begin
            lc_RegWriteD  <= 1'b0;
            lc_ImmSrcD    <= 2'b00;
            lc_ALUSrcD    <= 1'b0;
            lc_MemWriteD  <= 1'b0;
            lc_ResultSrcD <= 2'b00;
            lc_BranchD <= 1'b0;
            lc_alu_op  <= 2'b00;
            lc_JumpD <= 1'b0; 
        end
        else case (InstrD[6:0])
            7'b0000011: begin // lw
                            lc_RegWriteD  <= 1'b1;
                            lc_ImmSrcD    <= 2'b00;
                            lc_ALUSrcD    <= 1'b1;
                            lc_MemWriteD  <= 1'b0;
                            lc_ResultSrcD <= 2'b01;
                            lc_BranchD <= 1'b0;
                            lc_alu_op  <= 2'b00; 
                            lc_JumpD <= 1'b0;
                        end
            7'b0100011: begin // sw
                            lc_RegWriteD  <= 1'b0;
                            lc_ImmSrcD    <= 2'b01;
                            lc_ALUSrcD    <= 1'b1;
                            lc_MemWriteD  <= 1'b1;
                            lc_ResultSrcD <= 2'b00;
                            lc_BranchD <= 1'b0;
                            lc_alu_op  <= 2'b00;
                            lc_JumpD <= 1'b0; 
                        end
            7'b0110011: begin // type R
                            lc_RegWriteD  <= 1'b1;
                            lc_ImmSrcD    <= 2'b00;
                            lc_ALUSrcD    <= 1'b0;
                            lc_MemWriteD  <= 1'b0;
                            lc_ResultSrcD <= 2'b00;
                            lc_BranchD <= 1'b0;
                            lc_alu_op  <= 2'b10;
                            lc_JumpD <= 1'b0; 
                        end
            7'b1100011: begin // beq
                            lc_RegWriteD  <= 1'b0;
                            lc_ImmSrcD    <= 2'b10;
                            lc_ALUSrcD    <= 1'b0;
                            lc_MemWriteD  <= 1'b0;
                            lc_ResultSrcD <= 2'b00;
                            lc_BranchD <= 1'b1;
                            lc_alu_op  <= 2'b01;
                            lc_JumpD <= 1'b0; 
                        end
            7'b0010011: begin // addi/ori/slti
                            lc_RegWriteD  <= 1'b1;
                            lc_ImmSrcD    <= 2'b00;
                            lc_ALUSrcD    <= 1'b1;
                            lc_MemWriteD  <= 1'b0;
                            lc_ResultSrcD <= 2'b00;
                            lc_BranchD <= 1'b0;
                            lc_alu_op  <= 2'b10;
                            lc_JumpD <= 1'b0;
                        end
            7'b1101111: begin // jal
                            lc_RegWriteD  <= 1'b1;
                            lc_ImmSrcD    <= 2'b11;
                            lc_ALUSrcD    <= 1'b0;
                            lc_MemWriteD  <= 1'b0;
                            lc_ResultSrcD <= 2'b10;
                            lc_BranchD <= 1'b0;
                            lc_alu_op  <= 2'b00;
                            lc_JumpD <= 1'b1;
                        end
              default: begin // incorrect command
                            lc_RegWriteD  <= 1'b0;
                            lc_ImmSrcD    <= 2'b00;
                            lc_ALUSrcD    <= 1'b0;
                            lc_MemWriteD  <= 1'b0;
                            lc_ResultSrcD <= 2'b00;
                            lc_BranchD <= 1'b0;
                            lc_alu_op  <= 2'b00;
                            lc_JumpD <= 1'b0;
              end

//            default: begin // incorrect command
//                            lc_RegWriteD  <= 1'bX;
//                            lc_ImmSrcD    <= 2'bXX;
//                            lc_ALUSrcD    <= 1'bX;
//                            lc_MemWriteD  <= 1'bX;
//                            lc_ResultSrcD <= 2'bXX;
//                            lc_BranchD <= 1'bX;
//                            lc_alu_op  <= 2'bXX;
//                            lc_JumpD <= 1'bX;
//                     end
        endcase
    end
    
    always @(lc_alu_decoder_in) begin
        casex (lc_alu_decoder_in)
            7'b00?????: lc_ALUControlD <= 3'b000; // lw, sw
            7'b01?????: lc_ALUControlD <= 3'b001; // beq
            7'b100000?: lc_ALUControlD <= 3'b000; // add
            7'b1000010: lc_ALUControlD <= 3'b000; // add
            7'b1000011: lc_ALUControlD <= 3'b001; // sub
            7'b10010??: lc_ALUControlD <= 3'b101; // slt
            7'b10110??: lc_ALUControlD <= 3'b011; // or
            7'b10111??: lc_ALUControlD <= 3'b010; // and
            default: lc_ALUControlD <= 3'bXXX;
        endcase
    end
    
    // Execute/ALU stage output
    reg_rst_param #(.WIDTH(1)) reg_RegWriteD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_RegWriteD),
        
        // Output
        .read_data(RegWriteE)
    );
    
    reg_rst_param #(.WIDTH(2)) reg_ResultSrcD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_ResultSrcD),
        
        // Output
        .read_data(ResultSrcE)
    );
    
    reg_rst_param #(.WIDTH(1)) reg_MemWriteD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_MemWriteD),
        
        // Output
        .read_data(MemWriteE)
    );
    
    reg_rst_param #(.WIDTH(1)) reg_JumpD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_JumpD),
        
        // Output
        .read_data(lc_JumpE)
    );
    
    reg_rst_param #(.WIDTH(1)) reg_BranchD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_BranchD),
        
        // Output
        .read_data(lc_BranchE)
    );
    
    reg_rst_param #(.WIDTH(3)) reg_ALUControlD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_ALUControlD),
        
        // Output
        .read_data(lc_ALUControlE)
    );
    
    reg_rst_param #(.WIDTH(1)) reg_ALUSrcD (
        // Inputs
        .clk(clk),
        .flush(lc_rst_FlushE),
        .write_data(lc_ALUSrcD),
        
        // Output
        .read_data(lc_ALUSrcE)
    );
    
    // Memory stage output
    reg_rst_param #(.WIDTH(1)) reg_RegWriteE (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(RegWriteE),
        
        // Output
        .read_data(RegWriteM)
    );
    
    reg_rst_param #(.WIDTH(2)) reg_ResultSrcE (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(ResultSrcE),
        
        // Output
        .read_data(ResultSrcM)
    );
    
    reg_rst_param #(.WIDTH(1)) reg_MemWriteE (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(MemWriteE),
        
        // Output
        .read_data(MemWriteM)
    );
    
    // Writeback stage output
    reg_rst_param #(.WIDTH(1)) reg_RegWriteM (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(RegWriteM),
        
        // Output
        .read_data(RegWriteW)
    );
    
    reg_rst_param #(.WIDTH(2)) reg_ResultSrcM (
        // Inputs
        .clk(clk),
        .flush(rst),
        .write_data(ResultSrcM),
        
        // Output
        .read_data(ResultSrcW)
    );
    
endmodule
