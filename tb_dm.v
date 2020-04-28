`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:51:59 04/27/2020
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

module tb_dm;

    // Inputs
    reg clk;
    reg [32:0] addr;
    reg ctrl_w;
    reg ctrl_r;
    reg [32:0] wdata;

    // Outputs
    wire [31:0] rdata;

    // Instantiate the Unit Under Test (UUT)
    dm uut (
        .clk(clk), 
        .addr(addr), 
        .ctrl_w(ctrl_w), 
        .ctrl_r(ctrl_r), 
        .wdata(wdata), 
        .rdata(rdata)
    );

    always begin
        clk = ~clk;
        #5;
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        addr = 0;
        ctrl_w = 0;
        ctrl_r = 0;
        wdata = 0;

        // Wait 100 ns for global reset to finish
        #100;
        // Add stimulus here
        #10;
        addr = 0;
        ctrl_w = 1;
        ctrl_r = 0;
        wdata = 32;

        #10;
        addr = 4;
        ctrl_w = 1;
        ctrl_r = 0;
        wdata = 64;

        #10;
        addr = 8;
        ctrl_w = 1;
        ctrl_r = 0;
        wdata = 128;
        
        #10;
        addr = 4;
        ctrl_w = 0;
        ctrl_r = 1;
        wdata = 0;
        
        #10;
        addr = 8;
        ctrl_w = 0;
        ctrl_r = 1;
        wdata = 0;
        
        #10;
        addr = 0;
        ctrl_w = 0;
        ctrl_r = 1;
        wdata = 0;
        

    end
      
endmodule

