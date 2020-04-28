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
    input  wire [31:0] addr,
    input  wire        ctrl_w, ctrl_r,
    input  wire [31:0] wdata,
    output wire [31:0] rdata);

    parameter NMEM = 256; // NMEM * 32bits for data
    reg [31:0] mem[0:NMEM-1];

    always @(posedge clk) begin
        if (ctrl_w) begin
            mem[addr[9:2]] = wdata;
        end
    end
    
    assign rdata = ctrl_r ? mem[addr[9:2]][31:0] : 0;
    
    
    always @(posedge clk) begin
        $monitor("%h w%d: %h ;r%d:%h", addr, ctrl_w, wdata, ctrl_r, rdata);
    end

endmodule
