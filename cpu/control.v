`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:42:54 04/27/2020
// Design Name:
// Module Name:    control
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module control(
           input wire[5:0] opcode,
           input wire[5:0] funct,
           output wire[:] alu_op,
           output wire[:] dm_op,
           output wire[:] ext_op,
           output wire[:] pc_op,
           output wire[:] reg_src,
           output wire[:] reg_dst,
           output wire    reg_write);

always @(*) begin
end
endmodule
