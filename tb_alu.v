`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:52:57 04/28/2020
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

module tb_alu;

    // Inputs
    reg [3:0] ctl;
    reg [31:0] a;
    reg [31:0] b;

    // Outputs
    wire [31:0] out;
    wire zero;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .ctl(ctl), 
        .a(a), 
        .b(b), 
        .out(out), 
        .zero(zero)
    );

    initial begin
        // Initialize Inputs
        ctl = 0;
        a = 0;
        b = 0;
        // Wait 100 ns for global reset to finish
        #100;
        #10;
        // and
        ctl = 0;
        a = 32;
        b = 96;
        #10;
        // or
        ctl = 1;
        a = 32;
        b = 64;
        #10;
        // add
        ctl = 2;
        a = 32;
        b = 64;
        #10;
        // sub
        ctl = 6;
        a = 64;
        b = 32;
        #10;
        // slt
        ctl = 7;
        a = 64;
        b = 3;

    end
      
endmodule

