`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:43:46 04/27/2020
// Design Name:
// Module Name:    cpu
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
`include "dm.v"
`include "alu.v"
`include "reg.v"
`include "im.v"
`include "pc.v"
`include "common.v"
`include "extend.v"
`include "control.v"
`include "cop.v"

module cpu(input wire clk,
           input wire rest);

wire [31:0] ins_addr;
wire [31:0] ins;

wire [5:0]  opcode;
wire [5:0]  funct;
wire [4:0]  rs;
wire [4:0]  rt;
wire [4:0]  rd;
wire [15:0] im1;
wire [25:0] im2;
wire [4:0]  shamt;

// decode instruction
assign opcode = ins[31:26];
assign funct  = ins[5:0];
assign rs     = ins[25:21];
assign rt     = ins[20:16];
assign rd     = ins[15:11];
assign shamt  = ins[10:6];
assign im1    = ins[15:0];
assign im2    = ins[25:0];

wire        dm_wr;
wire        dm_rd;
wire [2:0]  dm_op;
wire [31:0] dm_addr; // always from alu_res
wire [31:0] dm_rd_data;
wire [31:0] dm_wr_data;

wire        reg_wr;
wire        reg_in;      // determine reg_num_rd2
reg  [4:0]  reg_num_rd2; // rt or 0
wire [1:0]  reg_dst;     // determine reg_num_wr
reg  [4:0]  reg_num_wr;  // rt, rd, or 31
wire [1:0]  reg_src;     // determine reg_wr_data
reg  [31:0] reg_wr_data; // from pc, alu or dm
wire [31:0] reg_data1;
wire [31:0] reg_data2;

wire [31:0] ext_data;
wire [1:0]  ext_op;

wire        alu_src;    // determine alu_input2
reg  [31:0] alu_input2; // reg_data2 or ext_data
wire [31:0] alu_input1;
wire [31:0] alu_res;
wire [4:0]  alu_shamt;
wire [5:0]  alu_op;
wire        alu_flag_zero;
wire        alu_flag_great;
wire        alu_flag_overflow;

wire [3:0]  pc_op;
wire [31:0] rt_addr;

wire [31:0] cop_input;
wire [31:0] cop_output;
wire        cop_wr;
wire        cop_rd;
wire [2:0]  cop_op;
wire [4:0]  cop_num = rd;
wire [2:0]  cop_sel = ins[2:0];
wire [19:0] cop_code = ins[25:6]; // used in system, break


im im(.clk  (clk),
      .addr (ins_addr),
      .data (ins));

pc pc(.clk        (clk),
      .rest       (rest),
      .zero       (alu_flag_zero),
      .great      (alu_flag_great),
      .im1        (im1),
      .im2        (im2),
      .pc_op      (pc_op),
      .j_reg      (reg_data1), // [rs]
      .cop_addr   (cop_output),
      .rt_addr    (rt_addr),
      .addr       (ins_addr));

assign cop_input = reg_data2;
cop cop0(.reg_num(cop_num),
         .reg_sel(cop_sel),
         .in_data(cop_input),
         .next_pc(ins_addr), // TODO: next pc or current pc
         .reg_wr(cop_wr),
         .reg_rd(cop_rd),
         .cop_op(cop_op),
         .code(cop_code),
         .out_data(cop_output));

control ctl(.opcode   (opcode),
            .funct    (funct),
            .hint     (shamt),
            .rs       (rs),
            .rt       (rt),
            .alu_op   (alu_op),
            .alu_src  (alu_src),
            .dm_op    (dm_op),
            .dm_wr    (dm_wr),
            .dm_rd    (dm_rd),
            .ext_op   (ext_op),
            .pc_op    (pc_op),
            .reg_src  (reg_src),
            .reg_dst  (reg_dst),
            .reg_wr   (reg_wr),
            .reg_in   (reg_in),
            .cop0_wr  (cop_wr),
            .cop0_rd  (cop_rd),
            .cop0_op  (cop_op));

assign dm_addr    = alu_res;
assign dm_wr_data = reg_data2;
dm dm (.clk   (clk),
       .dm_w  (dm_wr),
       .dm_r  (dm_rd),
       .addr  (dm_addr),
       .wdata (dm_wr_data),
       .dm_op (dm_op),
       .rdata (dm_rd_data));

extend ext(.ext_op (ext_op),
           .im     (im1),
           .out    (ext_data));

// reg file
always @(reg_in) begin
    case (reg_in)
        `REG_IN_RT:
            reg_num_rd2 <= rd;
        `REG_IN_ZERO:
            reg_num_rd2 <= 5'b0;
    endcase
end
always @(reg_dst) begin
    case (reg_dst)
        `REG_DST_RD:
            reg_num_wr <= rd;
        `REG_DST_RT:
            reg_num_wr <= rt;
        `REG_DST_31:
            reg_num_wr <= 31;
    endcase
end
always @(reg_src) begin
    case (reg_src)
        `REG_SRC_PC:
            reg_wr_data <= rt_addr;
        `REG_SRC_ALU:
            reg_wr_data <= alu_res;
        `REG_SRC_DM:
            reg_wr_data <= dm_rd_data;
        `REG_SRC_COP0:
            reg_wr_data <= cop_output;
    endcase
end
greg gr(.clk      (clk),
        .reg_wr   (reg_wr),
        .read1    (rs),
        .read2    (reg_num_rd2),
        .wr_num   (reg_num_wr),
        .wr_data  (reg_wr_data),
        .data1    (reg_data1),
        .data2    (reg_data2));


// alu
assign alu_input1 = reg_data1;
assign alu_shamt  =shamt;
always @(alu_src) begin
    case (alu_src)
        `ALU_SRC_IM:
            alu_input2 <= ext_data;
        `ALU_SRC_RT:
            alu_input2 <= reg_data2;
    endcase
end
alu alu(.alu_op   (alu_op),
        .a        (alu_input1),
        .b        (alu_input2),
        .shamt    (alu_shamt),
        .out      (alu_res),
        .zero     (alu_flag_zero),
        .great    (alu_flag_great),
        .overflow (alu_flag_overflow));

endmodule
