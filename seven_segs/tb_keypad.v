`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   14:51:42 05/27/2020
// Design Name:   keypad_anvyl
// Module Name:   C:/Users/qyang/Code/mips/seven_segs/tb_keypad.v
// Project Name:  seven_segs
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: keypad_anvyl
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tb_keypad;

// Inputs
reg clk;
reg [3:0] row;

// Outputs
wire [3:0] col;
wire [6:0] segs;
wire en;

// Instantiate the Unit Under Test (UUT)
keypad_anvyl uut (
                 .clk(clk),
                 .row(row),
                 .col(col),
                 .segs(segs),
                 .en(en)
             );

always  begin
    clk = ~clk;
	#1;
end

initial begin
    // Initialize Inputs
    clk = 0;
    row = 4'b1111;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    row = 4'b1011;
    #1;
    row = 4'b1111;

    row = 4'b1101;
    #1;
    row = 4'b1111;

end

endmodule

