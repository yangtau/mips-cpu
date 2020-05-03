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
module im(
    input  wire        clk,
    input  wire [31:0] addr,
    output wire [31:0] data);
    
     
    parameter NMEM   = 256; // NMEM * 32 bits for instructions
    parameter IM_TXT = "im.txt";
     
    reg [31:0] mem [0:NMEM-1];
    
    initial begin
        $readmemh(IM_TXT, mem, 0, NMEM-1);
    end
    
    
    assign data = mem[addr[9:2]];

    always @(posedge clk) begin
        $monitor("%h: %h", addr, data);
    end

endmodule