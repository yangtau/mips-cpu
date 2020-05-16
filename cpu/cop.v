`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:37:44 05/16/2020
// Design Name:
// Module Name:    cop
// Project Name:
// Target Devices:
// Tool versions:
// Description: coprocessor 0
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "common.v"
module cop(input  wire [4:0]  reg_num,
           input  wire [2:0]  reg_sel,
           input  wire [31:0] in_data,
           input  wire [31:0] cur_pc,
           input  wire        reg_wr,
           input  wire        reg_rd,
           input  wire [2:0]  cop_op,
           output wire [31:0] out_data);

reg [31:0] regs [0:31][0:2];

`define COUNT     regs[9][0]  // processor cycle count
`define COMPARE   regs[11][0]
`define CAUSE     regs[13][0] // cause of last exception
`define EPC       regs[14][0] // program counter at last exception
`define ERROR_EPC regs[30][0] // program counter at last error
`define STATUS    regs[12][0] // processor status and control
/* status
```
+----+----+-------------------------------------------+
|name|bits| description                               |
+----+----+-------------------------------------------+
|BEV | 22 | controls the location of exception vectors|
|    |    | 0: normal, 1: bootstrap                   |
+----+----+-------------------------------------------+
|UM  | 4  | 0: kernel mode, 1: user mode              |
+----+----+-------------------------------------------+
|ERL | 2  | Error Level                               |
|    |    | 0: normal level, 1: error level           |
+----+----+-------------------------------------------+
|EXL | 1  | Exception Level                           |
|    |    | 0: normal level, 1: exception level       |
+----+----+-------------------------------------------+
|IE  | 0  | Interrupt Enable                          |
+----+----+-------------------------------------------+
```
*/

reg [31:0] _out;

assign out_data = _out;

always @(*) begin
    case (cop_op)
        `COP_OP_MV:
            if (reg_wr)
                regs[reg_num][reg_sel] = in_data;
            else if (reg_rd)
                _out = regs[reg_num][reg_sel];
        `COP_OP_EN: begin
            _out <= `STATUS;
            `STATUS[0] <= 1'b1;
        end
        `COP_OP_DIS: begin
            _out <= `STATUS;
            `STATUS[0] <= 1'b0;
        end
        `COP_OP_SYS: begin
            // TODO
        end
        `COP_OP_RET:
            if (`STATUS[2]) begin
                // error
                _out <= `ERROR_EPC;
                `STATUS[2] <= 1'b0;
            end
            else begin
                // exception
                _out <= `EPC;
                `STATUS[1] <= 1'b0;
            end
        `COP_OP_BRK: begin

        end
        default:;
    endcase
end

endmodule
