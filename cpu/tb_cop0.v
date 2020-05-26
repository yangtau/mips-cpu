`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   15:48:54 05/26/2020
// Design Name:   cop
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_cop0.v
// Project Name:  cpu
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: cop
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tb_cop0;

// Inputs
reg [4:0] reg_num;
reg [2:0] reg_sel;
reg [31:0] in_data;
reg [31:0] next_pc;
reg reg_wr;
reg reg_rd;
reg [2:0] cop_op;
reg [19:0] code;

// Outputs
wire [31:0] out_data;

// Instantiate the Unit Under Test (UUT)
cop uut (
        .reg_num(reg_num),
        .reg_sel(reg_sel),
        .in_data(in_data),
        .next_pc(next_pc),
        .reg_wr(reg_wr),
        .reg_rd(reg_rd),
        .cop_op(cop_op),
        .code(code),
        .out_data(out_data)
    );

initial begin
    // Initialize Inputs
    reg_num = 0;
    reg_sel = 0;
    in_data = 0;
    next_pc = 0;
    reg_wr = 0;
    reg_rd = 0;
    cop_op = 0;
    code = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here

end

endmodule

