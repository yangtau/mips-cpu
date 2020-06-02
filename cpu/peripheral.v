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
                  output wire [7:0] io_seven_seg_n
                 );

// keypad
wire [3:0] keypad_data;

// seven segs
reg [23:0] seg_digits;
reg [5:0] seg_en;

// memory
parameter NMEM = 256; // NMEM * 32bits for data
parameter NBIT = 8;
reg [31:0] mem[0:NMEM-1];

reg [31:0] mem_reg;


always @(posedge clk) begin
    $display("#dm addr: %h w%d: %h ;r%d:%h", addr, dm_w, wdata, dm_r, rdata);
    if (dm_w) begin
        case (addr[31:20])
            12'hbf8: begin
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
                        $display( $time , "  invalid address for write : %x" , addr) ;
                endcase
            end
            default: begin
                case (dm_op)
                    `DM_OP_WD:
                        mem[addr[9:2]] <= wdata;
                    `DM_OP_SB: // store byte
                        mem[addr[9:2]][31:24] <= wdata[7:0]; // least-significant 8-bit
                    `DM_OP_SH: // stroe half word
                        mem[addr[9:2]][31:16] <= wdata[15:0]; // least-significant 16-bit
                endcase
            end
        endcase
    end
end

always @(negedge clk) begin
    $display("#dm addr:%h w%d: %h ;r%d:%h", addr, dm_w, wdata, dm_r, rdata);
    if (dm_r) begin
        case (addr[31:20])
            12'hbf8: begin
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
                        $display( $time , "  invalid address for read: %x" , addr) ;
                endcase
            end
            default: begin
                mem_reg = mem[addr[NBIT+1:2]][31:0];
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
                endcase

            end
        endcase
    end
end

//> keypad
keypad kp(.clk(clk),
          .rst(rst),
          .row(io_keypad_row),
          .col(io_keypad_col),
          .key_val(keypad_data));
//< keypad
segs_ctrl segs(.clk(clk_5hz),
               .rst(rst),
               .enables(seg_en),
               .data(seg_digits),
               .seven_segs_point(io_seven_seg_n),
               .show_one(io_seg_enables));

endmodule
