`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   17:51:40 05/26/2020
// Design Name:   control
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_control.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////
`include "common.v"
module tb_control;

// Inputs
reg [5:0] opcode;
reg [5:0] funct;
reg [4:0] hint;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;

// Outputs
wire [5:0] alu_op;
wire alu_src;
wire [2:0] dm_op;
wire dm_wr;
wire dm_rd;
wire [1:0] ext_op;
wire [3:0] pc_op;
wire [1:0] reg_src;
wire [1:0] reg_dst;
wire reg_wr;
wire reg_in;
wire cop0_wr;
wire cop0_rd;
wire [2:0] cop0_op;

// Instantiate the Unit Under Test (UUT)
control uut (
            .opcode(opcode),
            .funct(funct),
            .hint(hint),
            .rs(rs),
            .rt(rt),
            .rd(rd),
            .alu_op(alu_op),
            .alu_src(alu_src),
            .dm_op(dm_op),
            .dm_wr(dm_wr),
            .dm_rd(dm_rd),
            .ext_op(ext_op),
            .pc_op(pc_op),
            .reg_src(reg_src),
            .reg_dst(reg_dst),
            .reg_wr(reg_wr),
            .reg_in(reg_in),
            .cop0_wr(cop0_wr),
            .cop0_rd(cop0_rd),
            .cop0_op(cop0_op)
        );

initial begin
    // Initialize Inputs
    opcode = 0;
    funct = 0;
    hint = 0;
    rs = 0;
    rt = 0;
    rd = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    opcode = `OPCODE_SPECIAL;
    funct = `FUNCT_ADD;
    #10;
    funct = `FUNCT_JR;
    #10;
    funct = `FUNCT_JALR;
    #10;
    opcode = `OPCODE_JAL;
    #10;
    opcode = `OPCODE_LB;
    #10;
    opcode = `OPCODE_SH;
end

endmodule

