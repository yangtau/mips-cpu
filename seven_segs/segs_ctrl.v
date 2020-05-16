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
`include "seven_segs.v"
module segs_ctrl(
           input Reset ,
           input Clock ,
           input [5:0] DisplayEnables ,
           input [23:0] Data ,
           output [7:0] SevenSegsAndPoint,
           output [5:0] ShowOneofSix
       );

reg [2:0] select_display;
wire [3:0] four_digits;

always @(posedge Clock or posedge Reset)
    if (Reset == 1'b1)
        select_display <= 3'b000;
    else begin
        if (select_display == 5 )
            select_display <= 3'b000;
        else
            select_display <= select_display + 1;
    end

assign four_digits =
       (select_display[2:0] == 3'b000) ? Data[3:0] :
       (select_display[2:0] == 3'b001) ? Data[7:4] :
       (select_display[2:0] == 3'b010) ? Data[11:8] :
       (select_display[2:0] == 3'b011) ? Data[15:12] :
       (select_display[2:0] == 3'b100) ? Data[19:16] :
       Data[23:20];

assign ShowOneofSix =
       (select_display[2:0] == 3'b000 & DisplayEnables[0] == 1'b1) ? 6'b000001 :
       (select_display[2:0] == 3'b001 & DisplayEnables[1] == 1'b1) ? 6'b000010 :
       (select_display[2:0] == 3'b010 & DisplayEnables[2] == 1'b1) ? 6'b000100 :
       (select_display[2:0] == 3'b011 & DisplayEnables[3] == 1'b1) ? 6'b001000 :
       (select_display[2:0] == 3'b100 & DisplayEnables[4] == 1'b1) ? 6'b010000 :
       (select_display[2:0] == 3'b101 & DisplayEnables[5] == 1'b1) ? 6'b100000 :
       6'b000000;

seven_segs sev_segs(.Digit(four_digits),
                    .EnableSegs(DisplayEnables[select_display]),
                    .Seg(SevenSegsAndPoint[6:0]));

assign SevenSegsAndPoint[7] = 1'b0;

endmodule
