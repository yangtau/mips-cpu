`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   21:34:04 05/19/2020
// Design Name:   cpu
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_cpu.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: cpu
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tb_cpu;

// Inputs
reg clk;
reg rest;

// Instantiate the Unit Under Test (UUT)
cpu uut (
        .clk(clk),
        .rest(rest)
    );

always begin
    clk = ~clk;
    #10;
end

initial begin
    // Initialize Inputs
    clk = 1;
    rest = 1;
    // Wait 100 ns for global reset to finish
    #10;
	rest = 0;

    // Add stimulus here

end
endmodule

