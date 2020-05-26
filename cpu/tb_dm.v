`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   10:44:51 05/05/2020
// Design Name:   dm
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_dm.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: dm
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////
`include "common.v"

module tb_dm;

// Inputs
reg clk;
reg dm_w;
reg dm_r;
reg [31:0] addr;
reg [31:0] wdata;
reg [2:0] dm_op;

// Outputs
wire [31:0] rdata;

// Instantiate the Unit Under Test (UUT)
dm uut (
       .clk(clk),
       .dm_w(dm_w),
       .dm_r(dm_r),
       .addr(addr),
       .wdata(wdata),
       .dm_op(dm_op),
       .rdata(rdata)
   );

always  begin
    clk = ~clk;
    #5;
end

initial begin
    // Initialize Inputs
    clk = 1;
    dm_w = 0;
    dm_r = 0;
    addr = 0;
    wdata = 0;
    dm_op = 0;

    // Wait 100 ns for global reset to finish
    #100;
    dm_op = `DM_OP_WD;
    dm_w = 1;
    addr = 4;
    wdata = 2333;
    #10;
    dm_w = 0;
    dm_r = 1;
    addr = 4;
    #10;
    dm_op = `DM_OP_WD;
    dm_r = 0;
    dm_w = 1;
    addr = 8;
    wdata = 2433;
    #10;
    dm_w = 0;
    dm_r = 1;
    addr = 8;
    #10;
end

endmodule

