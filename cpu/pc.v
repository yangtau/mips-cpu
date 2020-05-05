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
          output wire [31:0] rt_addr,
          output wire [31:0] addr);

parameter INITAL_ADDR = 32'b0;

reg  [31:0] pc_r;
reg  [31:0] _rt_addr;
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
    _rt_addr <= pc_plus4;
    if (rest) begin
        pc_r <= INITAL_ADDR;
    end
    else if (
        (pc_op == `PC_OP_BZ && zero) ||
        (pc_op == `PC_OP_BNZ && !zero) ||
        (pc_op == `PC_OP_BG && great) ||
        (pc_op == `PC_OP_BNG && !great) ||
        (pc_op == `PC_OP_BGZ && (zero || great)) ||
        (pc_op == `PC_OP_BNGNZ && (!zero && !great))
    ) begin
        pc_r <= br;
    end
    else if (pc_op == `PC_OP_J) begin
        pc_r <=  jmp;
    end
    else if (pc_op == `PC_OP_JR) begin
        pc_r <= j_reg;
    end
    else begin
        pc_r <= pc_plus4;
    end
end

assign addr    = pc_r;
assign rt_addr = _rt_addr;

endmodule