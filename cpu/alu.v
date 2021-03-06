`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:42:10 04/27/2020
// Design Name:
// Module Name:    alu
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
`include "common.v"
module alu(input wire        clk,
           input wire [5:0]  alu_op,
           input wire [31:0] a,
           input wire [31:0] b,
           input wire [4:0]  shamt, // or last byte
           input wire [4:0]  ins15_11, // msbd, msb
           output reg [31:0] out,
           output reg       zero,
           output reg       great,
           output reg       overflow);

wire [31:0] ua;
wire [31:0] ub;
wire signed   [31:0] sa;
wire signed   [31:0] sb;
wire signed   [63:0] mul_res;
wire signed   [63:0] mulu_res;
wire          [63:0] rot;

wire [31:0] ins_mask = (32'hffff_ffff >> (31-(ins15_11 - shamt))) << shamt;

reg [64:0] _temp;

assign ua = a;
assign ub = b;
assign sa = a;
assign sb = b;

assign mul_res  = sa * sb;
assign mulu_res = ua * ub;

assign rot = {b, b};

always @(*) begin
    if (clk) begin
        overflow = 1'b0;
        case (alu_op)
            `ALU_OP_NOP:
                out = 32'b0;
            `ALU_OP_ADD:
                out = sa+sb;
            `ALU_OP_ADDU: begin
                out = sa+sb;
                overflow = ((a[31] ~^ b[31]) & (a[31] ^ out[31]));
            end
            `ALU_OP_SUB:
                out = sa-sb;
            `ALU_OP_SUBU: begin
                out = sa-sb;
                overflow = ((a[31] ^ b[31]) & (a[31] ^ out[31]));
            end
            `ALU_OP_AND:
                out = ua & ub;
            `ALU_OP_OR:
                out = ua | ub;
            `ALU_OP_NOR:
                out = ~(ua | ub);
            `ALU_OP_XOR:
                out = ua ^ ub;
            `ALU_OP_DIV:
                out = sa % sb;
            `ALU_OP_DIVU:
                out = ua % ub;
            `ALU_OP_MOD:
                out = sa / sb;
            `ALU_OP_MODU:
                out = ua / ub;
            `ALU_OP_MUL:
                out = mul_res[31:0];
            `ALU_OP_MULU:
                out = mulu_res[31:0];
            `ALU_OP_MUH:
                out = mul_res[63:32];
            `ALU_OP_MUHU:
                out = mulu_res[63:32];
            `ALU_OP_SLL:
                out = ub << shamt;
            `ALU_OP_SLLV:
                out = ub << ua[4:0];
            `ALU_OP_SRA:
                out = ub >>> shamt;
            `ALU_OP_SRAV:
                out = ub >>> ua[4:0];
            `ALU_OP_SRL:
                out = ub >> shamt;
            `ALU_OP_SRLV:
                out = ub >> ua[4:0];
            `ALU_OP_ROTR: begin
                _temp = rot >> shamt;
                out   = _temp[31:0];
            end
            `ALU_OP_ROTRV: begin
                _temp = rot >> ua[4:0];
                out   = _temp[31:0];
            end
            `ALU_OP_SLT:
                out = (sa < sb) ? 32'h00000001: 32'h00000000;
            `ALU_OP_SLTU:
                out = (ua < ub) ? 32'h00000001: 32'h00000000;
            `ALU_OP_INS: begin
                if (shamt > ins_mask) begin
                    // lsb > msb
                    // TODO: UNPREDICTABLE
                end
                out = (ub & ~ins_mask) | ((ua<<shamt)&ins_mask);
            end
            `ALU_OP_EXT: begin
                if (ins15_11 + shamt > 31) begin
                    // lsb + msbd > 31
                    // TODO: UNPREDICTABLE
                end
                out = (32'hffff_ffff >> (31-ins15_11)) & (ua >> shamt);
            end
        endcase
        zero  = (out == 0) ? 1'b1 : 1'b0;
        great = (out > 0)  ? 1'b1 : 1'b0;

    end
end

always @(negedge clk) begin
    $display("#alu: a:%h b:%h o:%h op:%h zero: %h great:%h", a, b, out, alu_op, zero, great);
end


endmodule
