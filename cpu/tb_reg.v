`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   20:55:21 05/05/2020
// Design Name:   greg
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_reg.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: greg
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

`include "reg.v"
module tb_reg;

// Inputs
reg clk;
reg reg_wr;
reg [4:0] read1;
reg [4:0] read2;
reg [4:0] wr_num;
reg [31:0] wr_data;

// Outputs
wire [31:0] data1;
wire [31:0] data2;

// Instantiate the Unit Under Test (UUT)
greg uut (
         .clk(clk),
         .reg_wr(reg_wr),
         .read1(read1),
         .read2(read2),
         .wr_num(wr_num),
         .wr_data(wr_data),
         .data1(data1),
         .data2(data2)
     );

always  begin
    clk = ~clk;
    #5;
end

initial begin
    // Initialize Inputs
    clk = 1;
    reg_wr = 0;
    read1 = 0;
    read2 = 0;
    wr_num = 0;
    wr_data = 0;

    // Wait 100 ns for global reset to finish
    #100;
    reg_wr =  1;
    read1  =  0;
    read2  =  0;
    wr_num =  0;
    wr_data = 2333;
    #10;
    reg_wr =  1;
    read1  =  0;
    read2  =  0;
    wr_num =  1;
    wr_data = 2333;
    #10;
    reg_wr =  0;
    read1  =  1;
    read2  =  2;
    wr_num =  2;
    wr_data = 2333;


    // Add stimulus here

end

endmodule

