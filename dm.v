`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:44:36 04/27/2020 
// Design Name: 
// Module Name:    dm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// data memory
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dm(
    input  wire        clk,
    input  wire [32:0] addr,
    input  wire        ctrl_w, ctrl_r,
    input  wire [32:0] wdata,
    output wire [31:0] rdata);

    parameter NMEM = 256; // NMEM * 32bits for data
    reg [31:0] mem[0:NMEM-1];

    always @(posedge clk)
        if (ctrl_w) begin
            mem[addr] = wdata;
        end
        if (ctrl_r) begin
            rdata = mem[addr];
        end
    end

endmodule
