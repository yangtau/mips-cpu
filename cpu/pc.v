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
          output reg  [31:0] rt_addr,
          output reg  [31:0] addr);

parameter INITAL_ADDR = 32'b0;

reg  [31:0] pc_r;
wire [31:0] pc_plus4;
wire [31:0] br;     // branch offset
wire [31:0] jmp;      // jump addr


initial begin
    pc_r <= INITAL_ADDR;
end

assign pc_plus4 = pc_r + 4;
assign br       = {{14{im1[15]}}, im1, 2'b00} + pc_r;
assign jmp      = {pc_r[31:30], im2, 2'b00};

always @(posedge clk) begin
    rt_addr <= pc_plus4;
    if (rest)
        pc_r <= INITAL_ADDR;
    else if (
        (pc_op == `PC_OP_BZ && zero) ||
        (pc_op == `PC_OP_BNZ && !zero) ||
        (pc_op == `PC_OP_BG && great) ||
        (pc_op == `PC_OP_BNG && !great) ||
        (pc_op == `PC_OP_BGZ && (zero || great)) ||
        (pc_op == `PC_OP_BNGNZ && (!zero && !great))
    )
        pc_r <= br;
    else if (pc_op == `PC_OP_J)
        pc_r <=  jmp;
    else if (pc_op == `PC_OP_JR)
        pc_r <= j_reg;
    else if (pc_op == `PC_OP_COP0)
        pc_r <= cop_addr;
    else
        pc_r <= pc_plus4;

    addr = pc_r;
    $monitor("#pc: %h, op:%h", addr, pc_op);
end


endmodule
