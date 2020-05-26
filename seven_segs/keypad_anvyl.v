`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:48:20 05/20/2020
// Design Name:
// Module Name:    keypad_anvyl
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
module keypad_anvyl(input clk,
                    input [3:0] row,
                    output [3:0] col,
                    output [6:0] segs,
                    output en);

wire div_clk;
wire [3:0] data;

assign en = 1'b1;

keypad kp(.clk(div_clk),
           .rst(1'b0),
           .row(row),
           .col(col),
           .key_val(data));

clock_div clk_d(.Reset(1'b0),
                .Clock(clk),
                .DividedClock(div_clk));

seven_segs segs_m(.Digit(data),
                  .EnableSegs(1'b1),
                  .Seg(segs));

endmodule