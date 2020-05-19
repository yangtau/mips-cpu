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
            input  wire        reg_wr,
            input  wire [4:0]  read1,
            input  wire [4:0]  read2,
            input  wire [4:0]  wr_num,
            input  wire [31:0] wr_data,
            output wire [31:0] data1,
            output wire [31:0] data2);

reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

initial begin
    mem[0]=32'd0;
end

assign data1 = mem[read1][31:0];
assign data2 = mem[read2][31:0];

always @(posedge clk) begin
    if (reg_wr && wr_num != 5'd0) begin
        mem[wr_num] <= wr_data;
    end
end
endmodule
