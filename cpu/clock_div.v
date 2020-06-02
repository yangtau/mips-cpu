`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:35:36 05/13/2020
// Design Name:
// Module Name:    clock_div
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
module clock_div(input rst,
                 input clk,
                 output reg div_clk);

parameter COUNTER = 32'hC350; // 50 000
reg [32:0] clock_count;

always @(posedge clk or posedge rst)
    if (rst == 1'b1)
        clock_count <= {32{1'b0}};
    else begin
        if ( clock_count == COUNTER-1) // CLK为100M时，dividedClk的周期 1ms , 高低各 0.5ms
        begin
            div_clk <= ~div_clk;
            clock_count <= {32{1'b0}};
        end
        else
            clock_count <= clock_count + 1;
    end
endmodule