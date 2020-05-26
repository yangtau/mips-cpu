`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   10:11:00 05/05/2020
// Design Name:   pc
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_pc.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: pc
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////
`include "common.v"
module tb_pc;

// Inputs
reg clk;
reg rest;
reg zero;
reg great;
reg [15:0] im1;
reg [25:0] im2;
reg [3:0] pc_op;
reg [31:0] j_reg;
reg [31:0] cop_addr;

// Outputs
wire [31:0] rt_addr;
wire [31:0] addr;

// Instantiate the Unit Under Test (UUT)
pc uut (
       .clk(clk),
       .rest(rest),
       .zero(zero),
       .great(great),
       .im1(im1),
       .im2(im2),
       .pc_op(pc_op),
       .j_reg(j_reg),
       .cop_addr(cop_addr),
       .rt_addr(rt_addr),
       .addr(addr)
   );

always begin
    clk = ~clk;
    #5;
end

initial begin
    // Initialize Inputs
    clk = 1;
    rest = 1;
    zero = 0;
    great = 0;
    im1 = 0;
    im2 = 0;
    j_reg = 0;
    pc_op = 0;
    #100;
    // Wait 100 ns for global reset to finish
    // Add stimulus here
    rest = 0;
    pc_op = `PC_OP_NEXT;
    #10; // 1
    pc_op = `PC_OP_NEXT;
    #10; // 2
    pc_op = `PC_OP_BG;
    great = 0;
    #10; // 3
    pc_op = `PC_OP_BZ;
    zero  = 1;
    im1   = 20;
    #10; // 23
    pc_op = `PC_OP_NEXT;
    #10; // 24
    // rest  = 1;
    // 0
    pc_op = 1;
    cop_addr = 32'h3000;
    zero = 1;
    im1 = 16'h202a;
    im2 = 26'h64202a;
    j_reg = 32'h7;

end

endmodule

