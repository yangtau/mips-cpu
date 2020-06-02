`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    14:53:27 05/13/2020
// Design Name:
// Module Name:    seven_segs
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
module seven_segs(
           input [3:0] Digit,
           input EnableSegs,
           output reg [6:0] Seg) ;

reg [6:0] A_G ;

always @ (Digit or EnableSegs ) begin
    if (EnableSegs)
    case ( Digit )
        // Segment patterns abcdefg
        0:
            A_G = 7'b1111110; // 0
        1:
            A_G = 7'b0110000; // 1
        2:
            A_G = 7'b1101101; // 2
        3:
            A_G = 7'b1111001; // 3
        4:
            A_G = 7'b0110011; // 4
        5:
            A_G = 7'b1011011; // 5
        6:
            A_G = 7'b1011111; // 6
        7:
            A_G = 7'b1110000; // 7
        8:
            A_G = 7'b1111111; // 8
        9:
            A_G = 7'b1110011; // 9 (no 'tail')
        10:
            A_G = 7'b1110111; // A
        11:
            A_G = 7'b0011111; // b
        12:
            A_G = 7'b1001110; // C
        13:
            A_G = 7'b0111101; // d
        14:
            A_G = 7'b1001111; // E
        15:
            A_G = 7'b1000111; // F
        default:
            A_G = 7'bx;
    endcase
    else
        A_G = 7'b0;

    Seg = {A_G[0],A_G[1],A_G[2],A_G[3],A_G[4],A_G[5],A_G[6]};
end

endmodule
