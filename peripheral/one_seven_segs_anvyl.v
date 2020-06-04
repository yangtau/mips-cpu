`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    14:57:08 05/13/2020
// Design Name:
// Module Name:    one_seven_segs_anvyl
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
module one_seven_segs_anvyl(
           input [3:0] Switch,
           input Btn0,
           output [6:0] Segs,
           output En);

assign En = ~Btn0 ; // Btn0 means for Disable

seven_segs segs(.Digit(Switch),
                .EnableSegs(En),
                .Seg(Segs) );
endmodule
