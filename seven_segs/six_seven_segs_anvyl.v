`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:50:00 05/13/2020
// Design Name:
// Module Name:    six_seven_segs_anvyl
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
`include "clock_div.v"
`include "segs_ctrl.v"
module six_seven_segs_anvyl(
           input Clock,
           input [5:0] Switch,
           output [5:0] En,
           output [7:0] Segs);

wire divided_clock;
wire [23:0] data ;

assign data = 24'h012345 ;

clock_div m_clock_div(.Reset(1'b0),
                      .Clock(Clock),
                      .DividedClock(divided_clock));

segs_ctrl m_segs_ctr(
              .Reset(1'b0),
              .Clock(divided_clock),
              .DisplayEnables(Switch),
              .Data(data),
              .SevenSegsAndPoint(Segs),
              .ShowOneofSix(En));
endmodule
