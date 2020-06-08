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
module cop(input wire clk,
           input wire rst,
           input  wire [4:0]  reg_num,
           input  wire [2:0]  reg_sel,
           input  wire [31:0] in_data,
           input  wire [31:0] next_pc,
           input  wire        reg_wr,
           input  wire        reg_rd,
           input  wire [3:0]  cop_op,
           input  wire [19:0] code, // syscall, break
           input  wire [5:0] hard_int,
           output reg [31:0] out_data);

parameter EXCEPTION_ENTRY = 32'h80000180;
reg[31:0] COUNT    ;// regs[9]  // processor cycle count
reg[31:0] COMPARE  ;// regs[11]
reg[31:0] CAUSE    ;// regs[13] // cause of last exception
reg[31:0] EPC      ;// regs[14] // program counter at last exception
reg[31:0] ERROR_EPC;// regs[30] // program counter at last error
reg[31:0] STATUS   ;// regs[12] // processor status and control

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

// CAUSE
// exception code
//  CAUSE[6:2];
// soft interrupt
//  CAUSE[9:8];
// hard interrupt
//  CAUSE[15:10];

initial begin
    CAUSE  = 32'b0;
    STATUS = 32'b0;
    EPC    = EXCEPTION_ENTRY;
end

wire int_enabled = STATUS[0] & ~STATUS[1] & ~STATUS[2];
wire [1:0] soft_enable_mask = STATUS[9:8];
wire [7:0] hard_enable_mask = STATUS[16:10];

always @(*) begin
    if (rst) begin
        CAUSE  = 32'b0;
        STATUS = 32'b0;
        EPC    = EXCEPTION_ENTRY;
    end
    if ((hard_enable_mask[5:0] & hard_int) && int_enabled) begin
        // handle hard int
        CAUSE[15:10] = hard_int;
        // set exl
        STATUS[1] = 1'b1;
        // set cause
        CAUSE[6:2] = 5'h0; // exception code for int
        out_data = EXCEPTION_ENTRY;
    end
    else
    case (cop_op)
        `COP_OP_NOP:
            out_data = 32'b0;
        `COP_OP_MV:
            // mfc0
            if (reg_rd) begin
                // out_data = regs[reg_num][reg_sel];
                // out_data = regs[reg_num];
                case (reg_num)
                    9:
                        out_data = COUNT;
                    11:
                        out_data = COMPARE;
                    13:
                        out_data = CAUSE;
                    14:
                        out_data = EPC;
                    12:
                        out_data = STATUS;
                    30:
                        out_data = ERROR_EPC;
                    default:
                        $display("#cop0 read unknown reg number: %x", reg_num);
                endcase
            end
            else if (reg_wr) begin
                case (reg_num)
                    9:
                        COUNT = in_data;
                    11:
                        COMPARE = in_data;
                    13:
                        CAUSE = in_data;
                    14:
                        EPC = in_data;
                    12:
                        STATUS = in_data;
                    30:
                        ERROR_EPC = in_data;
                    default:
                        $display("#cop0 write unknown reg number: %x", reg_num);
                endcase
            end

        `COP_OP_EN: begin
            // ei
            STATUS[0] = 1'b1;
            out_data = STATUS;
        end
        `COP_OP_DIS: begin
            // di
            STATUS[0] = 1'b0;
            out_data = STATUS;
        end
        `COP_OP_RET:
            if (STATUS[2]) begin
                // error
                STATUS[2] = 1'b0;
                out_data = ERROR_EPC;
            end
            else begin
                // exception
                STATUS[1] = 1'b0;
                out_data = EPC;
            end
        `COP_OP_SYS: begin
            if (int_enabled && soft_enable_mask[0]) begin
                EPC = next_pc;
                // set exl
                STATUS[1] = 1'b1;
                // set cause
                CAUSE[8] = 1'b1; // sint0
                CAUSE[6:2] = 5'h08; // exception code for system call: 0x08
                out_data = EXCEPTION_ENTRY;
            end
        end
        `COP_OP_BRK: begin
            if (int_enabled && soft_enable_mask[0]) begin
                EPC = next_pc;
                // set exl
                STATUS[1] = 1'b1;
                // set cause
                CAUSE[8] = 1'b1; // sint0
                CAUSE[6:2] = 5'h09; // exception code for break point: 0x08
                out_data = EXCEPTION_ENTRY;
            end
        end
        default:
            $display("#cop0 error: unknown op %d", cop_op);
    endcase
end

endmodule
