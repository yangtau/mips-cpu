`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:27:22 04/27/2020
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
        #5;
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        addr = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        #10;
        addr = 0;
        #10;
        addr = 4;
        #10;
        addr = 8;
        #10;
        addr = 12;

    end
      
endmodule

