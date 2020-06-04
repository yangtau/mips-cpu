`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:41:06 05/13/2020
// Design Name:
// Module Name:    segs_ctrl
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
module segs_ctrl(
           input rst,
           input clk,
           input [5:0] enables,
           input [23:0] data,
           output [7:0] seven_segs_point,
           output [5:0] show_one
       );

reg [2:0] select_display;
wire [3:0] four_digits;

always @(posedge clk or posedge rst)
    if (rst == 1'b1)
        select_display <= 3'b000;
    else begin
        if (select_display == 5 )
            select_display <= 3'b000;
        else
            select_display <= select_display + 1;
    end

assign four_digits =
       (select_display[2:0] == 3'b000) ? data[3:0] :
       (select_display[2:0] == 3'b001) ? data[7:4] :
       (select_display[2:0] == 3'b010) ? data[11:8] :
       (select_display[2:0] == 3'b011) ? data[15:12] :
       (select_display[2:0] == 3'b100) ? data[19:16] :
       data[23:20];

assign show_one =
       (select_display[2:0] == 3'b000 & enables[0] == 1'b1) ? 6'b000001 :
       (select_display[2:0] == 3'b001 & enables[1] == 1'b1) ? 6'b000010 :
       (select_display[2:0] == 3'b010 & enables[2] == 1'b1) ? 6'b000100 :
       (select_display[2:0] == 3'b011 & enables[3] == 1'b1) ? 6'b001000 :
       (select_display[2:0] == 3'b100 & enables[4] == 1'b1) ? 6'b010000 :
       (select_display[2:0] == 3'b101 & enables[5] == 1'b1) ? 6'b100000 :
       6'b000000;

seven_segs sev_segs(.Digit(four_digits),
                    .EnableSegs(enables[select_display]),
                    .Seg(seven_segs_point[6:0]));

assign seven_segs_point[7] = 1'b0;

endmodule
