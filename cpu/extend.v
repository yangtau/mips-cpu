// Company:
// Engineer:
//
// Create Date:    11:10:49 05/04/2020
// Design Name:
// Module Name:    extend
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
`include "common.v"

module extend(input wire  [1:0]  ext_op,
              input wire  [15:0] im,
              output wire [31:0] out);

reg [31:0] _out;

always @(*) begin
    case (ext_op)
        `EXT_OP_SE:
            _out <= {{16{im[15]}}, im};
        `EXT_OP_ZE:
            _out <= {{16{1'b0}}, im};
        `EXT_OP_LS:
            _out <= {im, {16{1'b0}}};
    endcase
end

assign out = _out;

endmodule
