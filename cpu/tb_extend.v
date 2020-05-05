`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   20:56:33 05/05/2020
// Design Name:   extend
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_extend.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: extend
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////
`include "extend.v"
module tb_extend;

// Inputs
reg [1:0] ext_op;
reg [15:0] im;

// Outputs
wire [31:0] out;

// Instantiate the Unit Under Test (UUT)
extend uut (
           .ext_op(ext_op),
           .im(im),
           .out(out)
       );

initial begin
    // Initialize Inputs
    ext_op = 0;
    im = 0;

    // Wait 100 ns for global reset to finish
    #100;
    ext_op = `EXT_OP_SE;
    im   = 16'b1111_1111_1111_1111;
	#10;
	ext_op = `EXT_OP_ZE;
	#10;
	ext_op = `EXT_OP_LS;

    // Add stimulus here

end

endmodule

