`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    21:54:49 05/04/2020
// Design Name:
// Module Name:    pc
// Project Name:
// Description:    program counter
//
//////////////////////////////////////////////////////////////////////////////////
`include "common.v"
module pc(input wire         clk,
          input wire         rest,
          input wire         zero,
          input wire         great,
          input wire  [15:0] im1,
          input wire  [25:0] im2,
          input wire  [3:0]  pc_op,
          input wire  [31:0] j_reg,
          input wire  [31:0] cop_addr,
          output wire [31:0] rt_addr,
          output wire [31:0] addr);

parameter INITAL_ADDR = 32'h9fc00000;

reg  [31:0] next_pc;
reg  [31:0] pc_r;

initial begin
    pc_r <= INITAL_ADDR;
end

wire [31:0] pc_plus4 = pc_r + 4;
wire [31:0] br       = {{14{im1[15]}}, im1, 2'b00} + pc_plus4;     // branch offset
wire [31:0] jmp      = {pc_r[31:28], im2, 2'b00};    // jump addr

always @(*) begin
    // $display("#pc:addr %x pc_op:%x zero:%x great:%x",addr, pc_op, zero, great);
    if (
        ((pc_op == `PC_OP_BZ) && zero) ||
        ((pc_op == `PC_OP_BNZ) && !zero) ||
        ((pc_op == `PC_OP_BG) && great) ||
        ((pc_op == `PC_OP_BNG) && !great) ||
        ((pc_op == `PC_OP_BGZ) && (zero || great)) ||
        ((pc_op == `PC_OP_BNGNZ) && (!zero && !great))
    )
        next_pc = br;
    else if (pc_op == `PC_OP_J)
        next_pc =  jmp;
    else if (pc_op == `PC_OP_JR)
        next_pc = j_reg;
    else if (pc_op == `PC_OP_COP0)
        next_pc = cop_addr;
    else
        next_pc = pc_plus4;
end

assign rt_addr = pc_plus4;
assign addr    = pc_r;
always @(posedge clk) begin
    if (rest)
        pc_r <= INITAL_ADDR;
    else
        pc_r <= next_pc;
end

endmodule
