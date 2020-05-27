`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   17:42:57 05/26/2020
// Design Name:   alu
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_alu.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////
`include "common.v"
module tb_alu;

// Inputs
reg clk;
reg [5:0] alu_op;
reg [31:0] a;
reg [31:0] b;
reg [4:0] shamt;
reg [4:0] rd;

// Outputs
wire [31:0] out;
wire zero;
wire great;
wire overflow;

// Instantiate the Unit Under Test (UUT)
alu uut (
        .clk(clk),
        .alu_op(alu_op),
        .a(a),
        .b(b),
        .shamt(shamt),
        .ins15_11(rd),
        .out(out),
        .zero(zero),
        .great(great),
        .overflow(overflow)
    );

always begin
	clk = ~clk;
	#10;	
end

initial begin
    // Initialize Inputs
    clk = 0;
    alu_op = 0;
    a = 0;
    b = 0;
    shamt = 0;
    rd = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    // Add stimulus here
    // rotr
    alu_op = `ALU_OP_ROTR;
    a      = 32'b0000_0000_0000_0011;
    b      = 32'b1001_1010_1101_0011_1001_1010_1101_0011;
    shamt  = 5'b00100;
    #10;
    // rotrv
    alu_op = `ALU_OP_ROTRV;
    a      = 32'b0000_0000_0000_0011;
    b      = 32'b1001_1010_1101_0011_1001_1010_1101_0011;
    shamt  = 5'b00100;
    #10;
    // addu
    alu_op = `ALU_OP_ADDU;
    a      = 32'b0100_0000_0000_0011_0100_0000_0000_0011;
    b      = 32'b0101_1010_1101_0011_1001_1010_1101_0011;
    #10;
    // add
    alu_op = `ALU_OP_ADD;
    a      = 32'b0100_0000_0000_0011_0100_0000_0000_0011;
    b      = 32'b0101_1010_1101_0011_1001_1010_1101_0011;
    #10;
    // sub
    alu_op = `ALU_OP_SUB;
    a      = 32'b1100_0000_0000_0011_0100_0000_0000_0011;
    b      = 32'b0111_1111_1101_0011_1001_1010_1101_0011;
    #10;
    // subu
    alu_op = `ALU_OP_SUBU;
    a      = 32'b1100_0000_0000_0011_0100_0000_0000_0011;
    b      = 32'b0111_1111_1101_0011_1001_1010_1101_0011;
    #10;
    // ins
    shamt = 4; // lsb
    rd = 7; // msb
    alu_op = `ALU_OP_INS;
    a      = 32'b1100_0000_0000_0011_0100_0000_0000_0011;
    b      = 32'b0111_1111_1101_0011_1001_1010_1101_0011;
    // out = 32'b0111_1111_1101_0011_1001_1010_0011_0011;
    #10;
    // ext
    shamt = 8;// lsb
    rd = 5; // msbd
    alu_op = `ALU_OP_EXT;
    a      = 32'b1100_0000_0000_0011_0101_1010_0000_0011;
    b      = 32'b0111_1111_1101_0011_1001_1010_1101_0011;
    // out = 32'b0000_0000_0000_0000_0000_0000_0001_1010;
    #10;
    shamt = 8;// lsb
    rd = 7; // msbd
    alu_op = `ALU_OP_EXT;
    a      = 32'b1100_0000_0000_0011_1101_1010_0000_0011;
    b      = 32'b0111_1111_1101_0011_1001_1010_1101_0011;
    // out = 32'b0000_0000_0000_0000_0000_0000_1101_1010;
end

endmodule

