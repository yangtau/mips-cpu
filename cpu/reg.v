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


module greg(input  wire        clk,
            input  wire        rst,
            input  wire        reg_wr,
            input  wire [4:0]  read1,
            input  wire [4:0]  read2,
            input  wire [4:0]  wr_num,
            input  wire [31:0] wr_data,
            output reg [31:0] data1,
            output reg [31:0] data2);

reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

integer i;
initial begin
    for (i=0; i < 32; i=i+1)
        mem[i] <= 32'b0;
end

always @(posedge clk, read1, read2) begin
    data1 <= mem[read1][31:0];
    data2 <= mem[read2][31:0];
end

always @(negedge clk) begin
    if (rst)
        for (i=0; i < 32; i=i+1)
            mem[i] <= 32'b0;
    else if (reg_wr && wr_num != 5'd0) begin
        mem[wr_num] <= wr_data;
    end
end
endmodule
