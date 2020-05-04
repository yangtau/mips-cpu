`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:45:04 04/27/2020
// Design Name:
// Module Name:    greg
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
// general register
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module greg(input wire         clk,
            input wire         regwrite,
            input wire  [4:0]  read1,
            input wire  [4:0]  read2,
            input wire  [4:0]  wrreg,
            input wire  [31:0] wrdata,
            output wire [31:0] data1,
            output wire [31:0] data2);

reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

initial begin
    mem[0]=32'd0;
end

/*
always @(*) begin
    if (read1 == 5'd0)
        _data1 = 32'd0;
    else if ((read1 == wrreg) && regwrite)
        _data1 = wrdata;
    else
        _data1 = mem[read1][31:0];
end
 
always @(*) begin
    if (read2 == 5'd0)
        _data2 = 32'd0;
    else if ((read2 == wrreg) && regwrite)
        _data2 = wrdata;
    else
        _data2 = mem[read2][31:0];
end
*/

assign data1 = mem[read1][31:0];
assign data2 = mem[read2][31:0];

always @(posedge clk) begin
    if (regwrite && wrreg != 5'd0) begin
        mem[wrreg] <= wrdata;
    end
end
endmodule
