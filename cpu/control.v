`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:42:54 04/27/2020
// Design Name:
// Module Name:    control
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
module control(
           input wire [5:0] opcode,
           input wire [5:0] funct,
           input wire [4:0] hint, // ins[10:6]
           input wire [4:0] rs,   // ins[25:21]
           input wire [4:0] rt,   // ins[20:16]
           input wire [4:0] rd,   // ins[15:11]
           output reg [5:0] alu_op,
           output reg       alu_src, // [rt] or im
           output reg [2:0] dm_op,
           output reg       dm_wr,
           output reg       dm_rd,
           output reg [1:0] ext_op,
           output reg [3:0] pc_op,
           output reg [1:0] reg_src,
           output reg [1:0] reg_dst,
           output reg       reg_wr,
           output reg       reg_in,
           output reg       cop0_wr,
           output reg       cop0_rd,
           output reg [2:0] cop0_op);

wire [31:0] _ins      = {opcode,  rs, rt, rd, hint, funct};
wire [7:0]  _ins_10_3 = _ins[10:3];
wire [2:0]  _ins_2_0  = _ins[2:0];
wire        _ins_5    = _ins[5];

always @(*) begin
    pc_op   <= `PC_OP_NEXT;
    reg_in  <= `REG_IN_RT;
    reg_wr  <= 1'b0;
    alu_op  <= `ALU_OP_NOP;
    dm_rd   <= 1'b0;
    dm_wr   <= 1'b0;
    cop0_op <= 2'b00;
    cop0_rd <= 1'b0;
    cop0_wr <= 1'b0;
    case (opcode)
        `OPCODE_SPECIAL: begin // R-type
            reg_dst <= `REG_DST_RD;
            reg_src <= `REG_SRC_ALU;
            reg_wr  <= 1'b1;
            alu_src <= 1'b0; // 0 for [rt]
            dm_wr   <= 1'b0;
            dm_rd   <= 1'b0;

            case (funct)
                `FUNCT_SLL: begin
                    // sll, nop
                    alu_op <= `ALU_OP_SLL;
                end
                `FUNCT_MOVCI: begin
                end
                `FUNCT_SRL: begin
                    // srl
                    alu_op <= `ALU_OP_SRL;
                end
                `FUNCT_SRA: begin
                    // sra
                    alu_op <= `ALU_OP_SRA;
                end
                `FUNCT_SLLV: begin
                    // sllv
                    alu_op <= `ALU_OP_SLLV;
                end
                `FUNCT_LSA: begin
                end
                `FUNCT_SRLV: begin
                    // srlv
                    alu_op <= `ALU_OP_SRLV;
                end
                `FUNCT_SRAV: begin
                    // srav
                    alu_op <= `ALU_OP_SRAV;
                end

                `FUNCT_JR    : begin
                    reg_wr <= 1'b0;
                    pc_op  <= `PC_OP_JR;
                end
                `FUNCT_JALR  : begin
                    reg_src <= `REG_SRC_PC;
                    pc_op   <= `PC_OP_JR;
                end
                `FUNCT_MOVZ  : begin
                end
                `FUNCT_MOVN  : begin
                end
                `FUNCT_SYSCALL: begin
                    // syscall
                    reg_wr  <= 1'b0;
                    pc_op   <= `PC_OP_COP0;
                    cop0_op <= `COP_OP_SYS;
                end
                `FUNCT_BREAK : begin
                    // break
                    reg_wr  <= 1'b0;
                    pc_op   <= `PC_OP_COP0;
                    cop0_op <= `COP_OP_BRK;
                end
                `FUNCT_SDBBP : begin
                end
                `FUNCT_SYNC  : begin
                end


                `FUNCT_MULT: begin
                    // mul, muh
                    if (hint == 5'b00010) begin // mul
                        alu_op <= `ALU_OP_MUL;
                    end
                    else if (hint == 5'b00011) begin // muh
                        alu_op <= `ALU_OP_MUH;
                    end
                end
                `FUNCT_MULTU: begin
                    // mulu, muhu
                    if (hint == 5'b00010) begin // mulu
                        alu_op <= `ALU_OP_MULU;
                    end
                    else if (hint == 5'b00011) begin // muhu
                        alu_op <= `ALU_OP_MUHU;
                    end
                end
                `FUNCT_DIV: begin
                    // div, mod
                    if (hint == 5'b00010) begin // div
                        alu_op <= `ALU_OP_DIV;
                    end
                    else if (hint == 5'b00011) begin // mod
                        alu_op <= `ALU_OP_MOD;
                    end
                end
                `FUNCT_DIVU: begin
                    // divu, modu
                    if (hint == 5'b00010) begin // divu
                        alu_op <= `ALU_OP_DIVU;
                    end
                    else if (hint == 5'b00011) begin // modu
                        alu_op <= `ALU_OP_MODU;
                    end
                end

                `FUNCT_ADD: begin
                    alu_op <= `ALU_OP_ADD;
                end
                `FUNCT_ADDU: begin
                    alu_op <= `ALU_OP_ADDU;
                end
                `FUNCT_SUB: begin
                    alu_op <= `ALU_OP_SUB;
                end
                `FUNCT_SUBU: begin
                    alu_op <= `ALU_OP_SUB;
                end
                `FUNCT_AND: begin
                    alu_op <= `ALU_OP_AND;
                end
                `FUNCT_OR: begin
                    alu_op <= `ALU_OP_OR;
                end
                `FUNCT_XOR: begin
                    alu_op <= `ALU_OP_XOR;
                end
                `FUNCT_NOR: begin
                    alu_op <= `ALU_OP_NOR;
                end

                `FUNCT_SLT: begin
                    alu_op <= `ALU_OP_SLT;
                end
                `FUNCT_SLTU: begin
                    alu_op <= `ALU_OP_SLTU;
                end

                default:
                    // TODO
                    ;
            endcase
        end
        `OPCODE_REGIMM: begin // branch
            // bal: [rt]=10001
            // bgez:     00001
            // bgezal:   10001
            // bltz:     00000
            case (rt)
                `RT_BAL: begin // bal, bgezal
                    //  brach and link if [rs] >= 0
                    alu_op  <= `ALU_OP_SUB;
                    pc_op   <= `PC_OP_BGZ;
                    reg_in  <= `REG_IN_ZERO;
                    reg_src <= `REG_SRC_PC;
                    reg_dst <= `REG_DST_31;
                    reg_wr  <= 1'b1;
                    alu_src <= `ALU_SRC_RT;
                end
                `RT_BGEZ: begin
                    // [rs] >= 0
                    alu_op  <= `ALU_OP_SUB;
                    pc_op   <= `PC_OP_BGZ;
                    reg_in  <= `REG_IN_ZERO;
                    alu_src <= `ALU_SRC_RT;
                end
                `RT_BLTZ: begin
                    // [rs] >= 0
                    alu_op  <= `ALU_OP_SUB;
                    pc_op   <= `PC_OP_BNGNZ;
                    reg_in  <= `REG_IN_ZERO;
                    alu_src <= `ALU_SRC_RT;
                end
                default:
                    // TODO
                    ;
            endcase
        end
        `OPCODE_J: begin
            pc_op <= `PC_OP_J;
        end
        `OPCODE_JAL: begin
            pc_op   <= `PC_OP_J;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_PC;
            reg_dst <= `REG_DST_31;
        end
        `OPCODE_BEQ: begin
            // [rs] == [rt]
            alu_op  <= `ALU_OP_SUB;
            alu_src <= `ALU_SRC_RT;
            pc_op   <= `PC_OP_BZ;
        end
        `OPCODE_BNE: begin
            // [rs] != [rt]
            alu_op  <= `ALU_OP_SUB;
            alu_src <= `ALU_SRC_RT;
            pc_op   <= `PC_OP_BNZ;
        end
        `OPCODE_BLEZ: begin
            // [rs] <= 0
            // rt should be 0
            alu_op  <= `ALU_OP_SUB;
            alu_src <= `ALU_SRC_RT;
            pc_op   <= `PC_OP_BNG;
        end
        `OPCODE_BGTZ: begin
            // [rs] > 0
            // rt should be 0
            alu_op  <= `ALU_OP_SUB;
            alu_src <= `ALU_SRC_RT;
            pc_op   <= `PC_OP_BG;
        end
        `OPCODE_ADDI: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_ADDIU: begin
            alu_op  <= `ALU_OP_ADDU;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_SLTI: begin
            alu_op  <= `ALU_OP_SLT;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_SLTIU: begin
            alu_op  <= `ALU_OP_SLTU;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_ANDI: begin
            alu_op  <= `ALU_OP_AND;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_ZE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_ORI: begin
            alu_op  <= `ALU_OP_OR;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_ZE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_XORI: begin
            alu_op  <= `ALU_OP_XOR;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_ZE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_AUI: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_LS;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_LB: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_DM;
            dm_op   <= `DM_OP_BS;
            dm_rd   <= 1'b1;
        end
        `OPCODE_LH: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_DM;
            dm_op   <= `DM_OP_HS;
            dm_rd   <= 1'b1;
        end
        `OPCODE_LWL: begin
        end
        `OPCODE_LW: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_DM;
            dm_op   <= `DM_OP_WD;
            dm_rd   <= 1'b1;
        end
        `OPCODE_LBU: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_DM;
            dm_op   <= `DM_OP_BZ;
            dm_rd   <= 1'b1;
        end
        `OPCODE_LHU: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b1;
            reg_src <= `REG_SRC_DM;
            dm_op   <= `DM_OP_HZ;
            dm_rd   <= 1'b1;
        end
        `OPCODE_LWR: begin
        end
        `OPCODE_SB: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b0;
            dm_op   <= `DM_OP_SB;
            dm_wr   <= 1'b1;
        end
        `OPCODE_SH: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b0;
            dm_op   <= `DM_OP_SH;
            dm_wr   <= 1'b1;
        end
        `OPCODE_SWL: begin
        end
        `OPCODE_SW: begin
            alu_op  <= `ALU_OP_ADD;
            alu_src <= `ALU_SRC_IM;
            ext_op  <= `EXT_OP_SE;
            reg_wr  <= 1'b0;
            dm_op   <= `DM_OP_WD;
            dm_wr   <= 1'b1;
        end
        `OPCODE_SWR: begin
        end
        `OPCODE_CACHE: begin
        end

        `OPCODE_COP0: begin
            if (
                _ins[25]   == 1'b1 &&
                _ins[24:6] == {19{1'b1}} &&
                funct      == 6'b011000) begin
                // eret
                cop0_op <= `COP_OP_RET;
                pc_op   <= `PC_OP_COP0;
            end
            else begin
                case (rs)
                    5'b00100: begin
                        // mtc0
                        cop0_op <= `COP_OP_MV;
                        cop0_rd <= 1'b1;
                    end
                    5'b00000: begin
                        // mfc0
                        cop0_op <= `COP_OP_MV;
                        cop0_wr <= 1'b1;
                        reg_src <= `REG_SRC_COP0;
                        reg_wr  <= 1'b1;
                    end
                    5'b01011: begin
                        // ei, di
                        cop0_op <= _ins_5 ?  `COP_OP_EN : `COP_OP_DIS;
                        reg_src <= `REG_SRC_COP0;
                        reg_wr  <= 1'b1;
                    end
                    default:
                        // TODO
                        ;
                endcase

            end
        end

        default:
            // TODO
            ;
    endcase
end

endmodule
