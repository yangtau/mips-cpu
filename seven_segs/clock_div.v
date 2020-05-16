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
module clock_div(input Reset,
                    input Clock,
                    output reg DividedClock);

parameter COUNTER = 32'hC350; // 50 000
reg [32:0] clock_count;

always @(posedge Clock or posedge Reset)
    if (Reset == 1'b1)
        clock_count <= {32{1'b0}};
    else begin
        clock_count <= clock_count + 1;
        if ( clock_count == COUNTER ) // CLK为100M时，dividedClk的周期 1ms , 高低各 0.5ms
        begin
            DividedClock <= ~DividedClock;
            clock_count <= {32{1'b0}};
        end
    end
endmodule