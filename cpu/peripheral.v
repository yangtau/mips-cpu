`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:17:04 06/02/2020
// Design Name:
// Module Name:    peripheral
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

module peripheral(input wire rst,
                  input wire clk, // system clock
                  input wire clk_5hz, // clock for keypad and seven-segs

                  input wire dm_w,
                  input wire dm_r,
                  input wire [31:0] addr,
                  input wire [31:0] wdata,
                  input wire [2:0]  dm_op,
                  output reg [31:0] rdata,

                  output reg [`MFP_N_LED-1:0] io_led,
                  input wire [`MFP_N_SW-1:0] io_switch,
                  input wire [`MFP_N_PB-1:0] io_btn,
                  input wire [3:0] io_keypad_row,
                  output wire [3:0] io_keypad_col,
                  output wire [5:0] io_seg_enables,
                  output wire [7:0] io_seven_seg
                 );

// keypad
wire [3:0] keypad_data;

// seven segs
reg [23:0] seg_digits;
reg [5:0] seg_en;

initial begin
    seg_en = 6'b11_1111;
    seg_digits = 24'b0;
    io_led = {`MFP_N_LED{1'b0}};
end


// GPIO: 0xbf80_00xx
// memory
parameter NMEM = 1024; // NMEM * 32bits for data
parameter NBIT = 10;
reg [31:0] mem1[0:NMEM-1]; // global area: 0x8000_8xxx
reg [31:0] mem2[0:NMEM-1]; // stack: 0x8004_xxxx
// reg [31:0] mem3[0:NMEM-1]; // bss:   0x8000_1 I do not think I really need it
// reg [31:0] mem3[0:NMEM-1]; // heap: forbid usage of heap

reg [31:0] mem_reg;

always @(negedge clk) begin
    if (dm_w) begin
        $display("#dm addr: %h w%d: %h", addr, dm_w, wdata);
        case (addr[31:16])
            20'hbf80: begin
                // GPIO
                // disable data mem
                case (addr[7:0])
                    8'h00: // led
                        io_led <= wdata[`MFP_N_LED-1:0];
                    8'h0c: // seven segs enable
                        seg_en <= wdata[5:0];
                    8'h10: // seven segs
                        seg_digits <= wdata[23:0];
                    default:
                        $display("#peripheral invalid GPIO address for writing: %x" , addr) ;
                endcase
            end
            20'h8000: begin
                // global area
                case (dm_op)
                    `DM_OP_WD:
                        mem1[addr[NBIT+1:2]] <= wdata;
                    `DM_OP_SB: // store byte
                        mem1[addr[NBIT+1:2]][31:24] <= wdata[7:0]; // least-significant 8-bit
                    `DM_OP_SH: // stroe half word
                        mem1[addr[NBIT+1:2]][31:16] <= wdata[15:0]; // least-significant 16-bit
                    default:
                        $display("#peripheral dm write: invalid op: %x", dm_op);
                endcase
            end
            20'h8003: begin
                // stack
                case (dm_op)
                    `DM_OP_WD:
                        mem2[addr[NBIT+1:2]] <= wdata;
                    `DM_OP_SB: // store byte
                        mem2[addr[NBIT+1:2]][31:24] <= wdata[7:0]; // least-significant 8-bit
                    `DM_OP_SH: // stroe half word
                        mem2[addr[NBIT+1:2]][31:16] <= wdata[15:0]; // least-significant 16-bit
                    default:
                        $display("#peripheral dm write: invalid op: %x", dm_op);
                endcase
            end
            default:
                $display("#peripheral invalid address for writing : %x" , addr) ;
        endcase
    end
end

always @(addr, dm_r, dm_op, io_switch, io_btn, keypad_data) begin
    if (dm_r) begin
        case (addr[31:16])
            20'hbf80: begin
                // GPIO
                // disable data mem
                case (addr[7:0])
                    8'h04: // switch
                        rdata <= {{(32-`MFP_N_SW){1'b0}}, io_switch};
                    8'h08: // btn
                        rdata <= {{(32-`MFP_N_PB){1'b0}}, io_btn}; // ReadData[`MFP_N_PB-1  :0] <= IO_PB[`MFP_N_PB-1  :0] ;
                    8'h14: // keypad
                        rdata <= {28'b0, keypad_data};
                    default:
                        $display("#peripheral GPIO invalid address for reading: %x" , addr) ;
                endcase
            end
            20'h8000: begin
                // global area
                mem_reg = mem1[addr[NBIT+1:2]][31:0];
                case (dm_op)
                    `DM_OP_BS: // sign extend byte
                        rdata <= {{24{mem_reg[31]}},mem_reg[31:24]};
                    `DM_OP_BZ: // zero extend byte
                        rdata <= {{24{1'b0}},mem_reg[31:24]};
                    `DM_OP_HS:  // sign extend half word
                        rdata <= {{16{mem_reg[31]}},mem_reg[31:16]};
                    `DM_OP_HZ:  // zero exten half word
                        rdata <= {{16{1'b0}}, mem_reg[31:16]};
                    `DM_OP_WD:  // word
                        rdata <= mem_reg;
                    default:
                        $display("#peripheral dm read: invalid op: %x", dm_op);
                endcase

            end
            20'h8003: begin
                // stack
                mem_reg = mem2[addr[NBIT+1:2]][31:0];
                case (dm_op)
                    `DM_OP_BS: // sign extend byte
                        rdata <= {{24{mem_reg[31]}},mem_reg[31:24]};
                    `DM_OP_BZ: // zero extend byte
                        rdata <= {{24{1'b0}},mem_reg[31:24]};
                    `DM_OP_HS:  // sign extend half word
                        rdata <= {{16{mem_reg[31]}},mem_reg[31:16]};
                    `DM_OP_HZ:  // zero exten half word
                        rdata <= {{16{1'b0}}, mem_reg[31:16]};
                    `DM_OP_WD:  // word
                        rdata <= mem_reg;
                    default:
                        $display("#peripheral dm read: invalid op: %x", dm_op);
                endcase
            end
            default:
                $display("#peripheral invalid address for reading: %x" , addr) ;
        endcase
        $display("#dm addr:%h r%d:%h", addr,  dm_r, rdata);
    end
end

//> keypad
keypad kp(.clk(clk_5hz),
          .rst(rst),
          .row(io_keypad_row),
          .col(io_keypad_col),
          .key_val(keypad_data));
//< keypad
segs_ctrl segs(.clk(clk_5hz),
               .rst(rst),
               .enables(seg_en),
               .data(seg_digits),
               .seven_segs_point(io_seven_seg),
               .show_one(io_seg_enables));

endmodule
