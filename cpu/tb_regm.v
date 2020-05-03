`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:50:55 04/28/2020
// Design Name:   regm
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_regm.v
// Project Name:  cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: regm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_regm;

    // Inputs
    reg clk;
    reg [4:0] read1;
    reg [4:0] read2;
    reg regwrite;
    reg [4:0] wrreg;
    reg [31:0] wrdata;

    // Outputs
    wire [31:0] data1;
    wire [31:0] data2;

    // Instantiate the Unit Under Test (UUT)
    regm uut (
        .clk(clk), 
        .read1(read1), 
        .read2(read2), 
        .data1(data1), 
        .data2(data2), 
        .regwrite(regwrite), 
        .wrreg(wrreg), 
        .wrdata(wrdata)
    );
    
    always begin
        clk = ~clk;
        #5;
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        read1 = 0;
        read2 = 0;
        regwrite = 0;
        wrreg = 0;
        wrdata = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        #10;
        read1 = 0;
        read2 = 0;
        regwrite = 1;
        wrreg = 1;
        wrdata = 32;
        
        #10;
        read1 = 0;
        read2 = 0;
        regwrite = 1;
        wrreg = 5;
        wrdata = 64;
        
        #10;
        read1 = 1;
        read2 = 5;
        regwrite = 0;
        wrreg = 0;
        wrdata = 0;

    end
      
endmodule

