`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:04 04/27/2020 
// Design Name: 
// Module Name:    reg 
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


module regm(
        input wire            clk,
        input wire  [4:0]    read1, read2,
        output wire [31:0]    data1, data2,
        input wire            regwrite,
        input wire    [4:0]    wrreg,
        input wire    [31:0]    wrdata);

    reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

    reg [31:0] _data1, _data2;

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

    assign data1 = _data1;
    assign data2 = _data2;

    always @(posedge clk) begin
        if (regwrite && wrreg != 5'd0) begin
            mem[wrreg] <= wrdata;
        end
    end
endmodule
