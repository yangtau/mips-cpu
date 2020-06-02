`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:44:13 04/27/2020
// Design Name:
// Module Name:    im
// Project Name:
// Target Devices:
// Tool versions:
// Description:
// instruction memory
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module im(input  wire        clk,
          input  wire [31:0] addr,
          output reg [31:0] data);

parameter NMEM   = 256; // NMEM * 32 bits for instructions
parameter NBIT = 8;
parameter IM_TXT1 = "im1.txt";
parameter IM_TXT2 = "im2.txt";

reg [31:0] mem1 [0:NMEM-1]; // start with 9fc00000

reg [31:0] mem2 [0:NMEM-1]; // start with 80000000

initial begin
    $readmemh(IM_TXT1, mem1, 0, NMEM-1);
    $readmemh(IM_TXT2, mem2, 0, NMEM-1);
end

always @(*) begin
    case (addr[31:20])
        12'h9fc:
            data <= mem1[addr[NBIT+1:2]];
        12'h800:
            data <= mem2[addr[NBIT+1:2]];
        default:
            $display($time , "#im  invalid address: %x" , addr) ;
    endcase
end
//
//assign data = addr[31:20] == 12'h9fc ?
//       mem1[addr[NBIT+1:2]] :
//       mem2[addr[NBIT+1:2]] ;

endmodule
