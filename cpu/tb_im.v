`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   11:33:02 05/27/2020
// Design Name:   im
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_im.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: im
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tb_im;

// Inputs
reg clk;
reg [31:0] addr;

// Outputs
wire [31:0] data;

// Instantiate the Unit Under Test (UUT)
im uut (
       .clk(clk),
       .addr(addr),
       .data(data)
   );

always begin
	clk = ~clk;
	#10;
end

initial begin
    // Initialize Inputs
    clk = 1;
    addr = 32'h80000200;

    // Wait 100 ns for global reset to finish
    #100;
    addr = 32'h80000204;
	#20;
	addr = 32'h9fc00000;

    // Add stimulus here

end

endmodule

