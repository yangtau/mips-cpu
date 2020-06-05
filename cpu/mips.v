`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:44:25 05/26/2020
// Design Name:
// Module Name:    mips
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
`define MIPS_DEBUG
module mips(
           `ifndef MIPS_DEBUG
           input clk, input rst,
`endif
           input wire [5:0] hard_int,
           output wire [`MFP_N_LED-1:0] io_led,
           input wire [`MFP_N_SW-1:0] io_switch,
           input wire [`MFP_N_PB-1:0] io_btn,
           input wire [3:0] io_keypad_row,
           output wire [3:0] io_keypad_col,
           output wire [5:0] io_seg_enables,
           output wire [7:0] io_seven_seg_n
       );


`ifdef MIPS_DEBUG
reg clk;
reg rst;

always  begin
    clk = ~clk;
    #10;
end

// dump wave
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,mips);
end

initial begin
    clk = 1'b1;
    rst = 1'b1;
    #110;
    rst = 1'b0;
end
`endif

wire [31:0] ins_addr;
wire [31:0] ins;

// ins decode
wire [5:0]  opcode;
wire [5:0]  funct;
wire [4:0]  rs;
wire [4:0]  rt;
wire [4:0]  rd;
wire [15:0] im1;
wire [25:0] im2;
wire [4:0]  shamt;
// control singal
wire [5:0]  alu_op;
wire        alu_src;    // alu_input2 = extend(im) or [rt]
wire [2:0]  dm_op;
wire        dm_wr;
wire        dm_rd;
wire [1:0]  ext_op;
wire [3:0]  pc_op;
wire [1:0]  reg_src; // [reg_wr_num] = pc_rt_addr, alu, dm, or cop0
wire [1:0]  reg_dst; // reg_wr_num = rd, rt or 31
wire        reg_wr;
wire        reg_in;  // reg_rd_num2 = rt or 0 (for branch)
wire        cop_wr;
wire        cop_rd;
wire [3:0]  cop_op;

wire [31:0] pc_rt_addr;

// decode instruction
assign opcode = ins[31:26];
assign funct  = ins[5:0];
assign rs     = ins[25:21];
assign rt     = ins[20:16];
assign rd     = ins[15:11];
assign shamt  = ins[10:6];
assign im1    = ins[15:0];
assign im2    = ins[25:0];

// reg file output
wire [31:0] reg_data1;
wire [31:0] reg_data2;

// alu res
wire [31:0] alu_res;

// data mem data
wire [31:0] dm_data;

// cop0 data
wire [31:0] cop_data;

// alu flag
wire        alu_flag_zero;
wire        alu_flag_great;
wire        alu_flag_overflow;


always @(negedge clk) begin
    $display("addr:%x ins:%x alu_res:%x reg_write:<%b %x>, cop_data:%x",
             ins_addr, ins, alu_res,reg_wr, reg_wr_data, cop_data);
end

wire div_clk = clk; // TODO:
// clock_div clkdiv(.rst(rst),
//                  .clk(clk),
//                  .div_clk(div_clk));

im im(.clk  (clk),
      .addr (ins_addr),
      .data (ins));

control ctrl(.opcode   (opcode),
             .funct    (funct),
             .hint     (shamt),
             .rs       (rs),
             .rt       (rt),
             .rd       (rd),
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

pc pc(.clk        (clk),
      .rest       (rst),
      .zero       (alu_flag_zero),
      .great      (alu_flag_great),
      .im1        (im1),
      .im2        (im2),
      .pc_op      (pc_op),
      .j_reg      (reg_data1), // [rs]
      .cop_addr   (cop_data),
      .rt_addr    (pc_rt_addr),
      .addr       (ins_addr));


//> reg file
wire [4:0]  reg_rd_num2 =
     reg_in == `REG_IN_RT ? rt : 5'b0;
wire [4:0]  reg_wr_num  =
     reg_dst == `REG_DST_31 ? 31
     : (reg_dst == `REG_DST_RT ? rt : rd);
wire [31:0] reg_wr_data =
     reg_src == `REG_SRC_PC ? pc_rt_addr :
     (reg_src == `REG_SRC_ALU ? alu_res :
      (reg_src == `REG_SRC_DM ? dm_data : cop_data));

greg reg_file(.clk      (clk),
              .rst      (rst),
              .reg_wr   (reg_wr),
              .read1    (rs),
              .read2    (reg_rd_num2),
              .wr_num   (reg_wr_num),
              .wr_data  (reg_wr_data),
              .data1    (reg_data1),
              .data2    (reg_data2));
//< reg file


//> extend
wire [31:0] ext_data;
extend ext(.ext_op (ext_op),
           .im     (im1),
           .out    (ext_data));
//< extend

//> alu
wire [31:0] alu_in2 = alu_src == `ALU_SRC_IM ? ext_data : reg_data2;

alu alu(.clk      (clk),
        .alu_op   (alu_op),
        .a        (reg_data1),
        .b        (alu_in2),
        .shamt    (shamt),
        .ins15_11 (rd),
        .out      (alu_res),
        .zero     (alu_flag_zero),
        .great    (alu_flag_great),
        .overflow (alu_flag_overflow));
//< alu

//> peripheral
peripheral periph (.clk   (clk),
                   .clk_5hz(div_clk), // TODO: clk
                   .rst   (rst),
                   .dm_w  (dm_wr),
                   .dm_r  (dm_rd),
                   .addr  (alu_res),
                   .wdata (reg_data2),
                   .dm_op (dm_op),
                   .rdata (dm_data),
                   .io_led(io_led),
                   .io_switch(io_switch),
                   .io_btn(io_btn),
                   .io_keypad_row(io_keypad_row),
                   .io_keypad_col(io_keypad_col),
                   .io_seg_enables(io_seg_enables),
                   .io_seven_seg_n(io_seven_seg_n));
//< peripheral

//> cop0
wire [2:0]  cop_sel = ins[2:0];
wire [19:0] cop_code = ins[25:6]; // used in system, break
cop cop0(.rst(rst),
         .clk(clk),
         .reg_num(rd),
         .reg_sel(cop_sel),
         .in_data(reg_data2),
         .next_pc(pc_rt_addr),
         .reg_wr(cop_wr),
         .reg_rd(cop_rd),
         .cop_op(cop_op),
         .code(cop_code),
         .hard_int(hard_int),
         .out_data(cop_data));
//< cop0
endmodule
