`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   17:39:28 05/04/2020
// Design Name:   ireg
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_ireg.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: ireg
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

`include "ir.v"

module tb_ireg;

// Inputs
reg [31:0] ins;

// Outputs
wire [5:0] opcode;
wire [5:0] funct;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [15:0] im1;
wire [25:0] im2;

// Instantiate the Unit Under Test (UUT)
ireg uut (
         .ins(ins),
         .opcode(opcode),
         .funct(funct),
         .rs(rs),
         .rt(rt),
         .rd(rd),
         .shamt(shamt),
         .im1(im1),
         .im2(im2)
     );

initial begin
    // Initialize Inputs
    ins = 0;
    #100;
    ins = 32'b01101101110100110110101001101011;
    // Add stimulus here
end

endmodule

