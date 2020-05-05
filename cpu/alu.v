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
module alu(input wire [5:0]  alu_op,
           input wire [31:0] a,
           input wire [31:0] b,
           input wire [4:0]  shamt,
           output reg [31:0] out,
           output wire       zero,
           output wire       great,
           output wire       overflow);

wire unsigned [31:0] ua;
wire unsigned [31:0] ub;
wire signed   [31:0] sa;
wire signed   [31:0] sb;
wire signed   [63:0] mul_res;
wire signed   [63:0] mulu_res;
wire          [63:0] rot;

reg _overflow;

assign ua = a;
assign ub = b;
assign sa = a;
assign sb = b;

assign mul_res  = sa * sb;
assign mulu_res = ua * ub;

assign rot = {b, b};

always @(*) begin
    case (alu_op)
        `ALU_OP_ADD:
            out <= sa+sb;
        `ALU_OP_ADDU:
            out <= sa+sb; // TODO: trap if overflow
        `ALU_OP_SUB:
            out <= sa-sb;
        `ALU_OP_SUBU:
            out <= sa-sb; // TODO: trap if overflow
        `ALU_OP_AND:
            out <= ua & ub;
        `ALU_OP_OR:
            out <= ua | ub;
        `ALU_OP_NOR:
            out <= ~(ua | ub);
        `ALU_OP_XOR:
            out <= ua ^ ub;
        `ALU_OP_DIV:
            out <= sa % sb;
        `ALU_OP_DIVU:
            out <= ua % ub;
        `ALU_OP_MOD:
            out <= sa / sb;
        `ALU_OP_MODU:
            out <= ua / ub;
        `ALU_OP_MUL:
            out <= mul_res[31:0];
        `ALU_OP_MULU:
            out <= mulu_res[31:0];
        `ALU_OP_MUH:
            out <= mul_res[63:32];
        `ALU_OP_MUHU:
            out <= mulu_res[63:32];
        `ALU_OP_SLL:
            out <= ub << shamt;
        `ALU_OP_SLLV:
            out <= ub << ua[4:0];
        `ALU_OP_SRA:
            out <= ub >>> shamt;
        `ALU_OP_SRAV:
            out <= ub >>> ua[4:0];
        `ALU_OP_SRL:
            out <= ub >> shamt;
        `ALU_OP_SRLV:
            out <= ub >> ua[4:0];
        `ALU_OP_ROTR:
            out <= rot >> shamt; // !note: high bits will be discard?
        `ALU_OP_ROTRV:
            out <= rot >> ua[4:0];
        `ALU_OP_SLT:
            out <= (sa < sb) ? 32'h00000001: 32'h00000000;
        `ALU_OP_SLTU:
            out <= (ua < ub) ? 32'h00000001: 32'h00000000;
    endcase
end

// detect overflow for `addu` and `subu`
// should be traped if overflow
always @(*) begin
    case (alu_op)
        `ALU_OP_ADDU:
            _overflow <= ((a[31] ~^ b[31]) & (a[31] ^ out[31]));
        `ALU_OP_SUBU:
            _overflow <= ((a[31] ^ b[31]) & (a[31] ^ out[31]));
        default:
            _overflow <= 1'b0;
    endcase
end

assign zero     = (out == 0) ? 1'b1 : 1'b0;
assign great    = (out > 0)  ? 1'b1 : 1'b0;
assign overflow = _overflow;

endmodule