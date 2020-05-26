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
`include "common.v"
`define DM_DEBUG
module dm(input  wire        clk,
          input  wire        dm_w,
          input  wire        dm_r,
          input  wire [31:0] addr,
          input  wire [31:0] wdata,
          input  wire [2:0]  dm_op,
          output reg  [31:0] rdata);

parameter NMEM = 256; // NMEM * 32bits for data
parameter NBIT = 8;
reg [31:0] mem[0:NMEM-1];

reg [31:0] _r;

always @(*) begin
    _r = mem[addr[NBIT+1:2]][31:0];
    if (dm_r) begin
        case (dm_op)
            `DM_OP_BS: // sign extend byte
                rdata = {{24{_r[31]}},_r[31:24]};
            `DM_OP_BZ: // zero extend byte
                rdata = {{24{1'b0}},_r[31:24]};
            `DM_OP_HS:  // sign extend half word
                rdata = {{16{_r[31]}},_r[31:16]};
            `DM_OP_HZ:  // zero exten half word
                rdata = {{16{1'b0}}, _r[31:16]};
            `DM_OP_WD:  // word
                rdata = _r;
        endcase
    end
end


always @(posedge clk) begin
    if (dm_w) begin
        case (dm_op)
            `DM_OP_WD:
                mem[addr[9:2]] <= wdata;
            `DM_OP_SB: // store byte
                mem[addr[9:2]][31:24] <= wdata[7:0]; // least-significant 8-bit
            `DM_OP_SH: // stroe half word
                mem[addr[9:2]][31:16] <= wdata[15:0]; // least-significant 16-bit
        endcase
    end
end

`ifdef DM_DEBUG
// always @(posedge clk) begin
//     $monitor("#dm#%h w%d: %h ;r%d:%h", addr, dm_w, wdata, dm_r, rdata);
// end
`endif

endmodule
