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
           input  wire [31:0] next_pc,
           input  wire        reg_wr,
           input  wire        reg_rd,
           input  wire [2:0]  cop_op,
           input  wire [19:0] code, // syscall, break
           output reg [31:0] out_data);

parameter EXCEPTION_ENTRY = 32'h80000000;
// reg [31:0] regs [0:31][0:2];

// `define COUNT     regs[9][0]  // processor cycle count
// `define COMPARE   regs[11][0]
// `define CAUSE     regs[13][0] // cause of last exception
// `define EPC       regs[14][0] // program counter at last exception
// `define ERROR_EPC regs[30][0] // program counter at last error
// `define STATUS    regs[12][0] // processor status and control
reg [31:0] regs[0:31];
`define COUNT     regs[9]  // processor cycle count
`define COMPARE   regs[11]
`define CAUSE     regs[13] // cause of last exception
`define EPC       regs[14] // program counter at last exception
`define ERROR_EPC regs[30] // program counter at last error
`define STATUS    regs[12] // processor status and control

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

initial begin
    `CAUSE  = 32'b0;
    `EPC    = 32'b0;
    `STATUS = 32'b0;
    `STATUS[0] <= 1'b1;
end

always @(*) begin
    case (cop_op)
        `COP_OP_MV:
            // mfc0 mtc0
            if (reg_wr)
                // regs[reg_num][reg_sel] = in_data;
                regs[reg_num] = in_data;
            else if (reg_rd)
                // out_data = regs[reg_num][reg_sel];
                out_data = regs[reg_num];
        `COP_OP_EN: begin
            // ei
            out_data = `STATUS;
            `STATUS[0] = 1'b1;
        end
        `COP_OP_DIS: begin
            // di
            out_data = `STATUS;
            `STATUS[0] = 1'b0;
        end
        `COP_OP_RET:
            if (`STATUS[2]) begin
                // error
                out_data = `ERROR_EPC;
                `STATUS[2] = 1'b0;
            end
            else begin
                // exception
                out_data = `EPC;
                `STATUS[1] = 1'b0;
            end
        `COP_OP_SYS: begin
            `EPC = next_pc;
            // TODO: goto somewhere
            out_data = EXCEPTION_ENTRY;
        end
        `COP_OP_BRK: begin
            `EPC = next_pc;
            // TODO: goto somewhere
            // set exl ?
            out_data = EXCEPTION_ENTRY;
        end
        default:
            ;
    endcase
end

endmodule
