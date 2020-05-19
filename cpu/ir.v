`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:53:44 05/04/2020
// Design Name:
// Module Name:    ir
// Project Name:
// Target Devices:
// Tool versions:
// Description:
// instruction register
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module ireg(input  wire [31:0] ins,
            output wire [5:0]  opcode,
            output wire [5:0]  funct,
            output wire [4:0]  rs,
            output wire [4:0]  rt,
            output wire [4:0]  rd,
            output wire [4:0]  shamt,
            output wire [15:0] im1,
            output wire [25:0] im2);


endmodule
