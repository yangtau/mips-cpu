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
           output wire      alu_src, // [rt] or im
           output reg [2:0] dm_op,
           output wire      dm_wr,
           output wire      dm_rd,
           output wire [1:0] ext_op,
           output reg [3:0] pc_op,
           output reg [1:0] reg_src,
           output wire [1:0] reg_dst,
           output reg       reg_wr,
           output wire      reg_in,
           output reg       cop0_wr,
           output reg       cop0_rd,
           output reg [3:0] cop0_op);

wire [31:0] _ins      = {opcode,  rs, rt, rd, hint, funct};
wire [7:0]  _ins_10_3 = _ins[10:3];
wire [2:0]  _ins_2_0  = _ins[2:0];
wire        _ins_5    = _ins[5];

// for ins like bal bgez  bgezal  bltz
assign reg_in = (opcode == `OPCODE_REGIMM ? `REG_IN_ZERO : `REG_IN_RT);

// dm
assign dm_wr = (opcode == `OPCODE_SB || opcode == `OPCODE_SH ||
                opcode == `OPCODE_SW) ? 1'b1 : 1'b0;
assign dm_rd = (opcode == `OPCODE_LB || opcode == `OPCODE_LH ||
                opcode == `OPCODE_LW || opcode == `OPCODE_LBU ||
                opcode == `OPCODE_LHU) ? 1'b1 : 1'b0;

assign ext_op = (opcode == `OPCODE_AUI ?
                 `EXT_OP_LS :
                 (opcode == `OPCODE_ANDI || opcode == `OPCODE_ORI ||
                  opcode == `OPCODE_XORI ?
                  `EXT_OP_ZE : (
                      opcode == `OPCODE_ADDI || opcode == `OPCODE_ADDIU ||
                      opcode == `OPCODE_SLTI || opcode == `OPCODE_SLTIU ||
                      opcode == `OPCODE_SB || opcode == `OPCODE_SH ||
                      opcode == `OPCODE_SW || opcode == `OPCODE_LB ||
                      opcode == `OPCODE_LH || opcode == `OPCODE_LW ||
                      opcode == `OPCODE_LBU || opcode == `OPCODE_LHU ?
                      `EXT_OP_SE : 2'b00)
                 )
                );
// 1 for ext(imm), 0 for [rt]
assign alu_src = ext_op == `EXT_OP_NOP ? `ALU_SRC_RT : `ALU_SRC_IM;

// rt for default
assign reg_dst = (opcode == `OPCODE_SPECIAL ) ? `REG_DST_RD :
       (((opcode == `OPCODE_REGIMM && rt == `RT_BAL) ||
         (opcode == `OPCODE_JAL)) ? `REG_DST_31 : `REG_DST_RT);

always @(*) begin
    pc_op   = `PC_OP_NEXT;
    reg_wr  = 1'b0;
    alu_op  = `ALU_OP_NOP;
    cop0_op = `COP_OP_NOP;
    cop0_rd = 1'b0;
    cop0_wr = 1'b0;
    dm_op   = `DM_OP_NOP;
    case (opcode)
        `OPCODE_SPECIAL: begin // R-type
            reg_src = `REG_SRC_ALU;
            cop0_rd = 1'b0;
            cop0_wr = 1'b0;
            dm_op = `DM_OP_NOP;
            case (funct)
                `FUNCT_SLL: begin
                    // sll, nop
                    alu_op  = rt == 5'b0_0000 ? `ALU_OP_NOP : `ALU_OP_SLL;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = rd == 5'b0_0000 ? 1'b0 : 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_MOVCI: begin
                end
                `FUNCT_SRL: begin
                    // srl
                    alu_op = `ALU_OP_SRL;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_SRA: begin
                    // sra
                    alu_op = `ALU_OP_SRA;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_SLLV: begin
                    // sllv
                    alu_op = `ALU_OP_SLLV;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_LSA: begin
                end
                `FUNCT_SRLV: begin
                    // srlv
                    alu_op = `ALU_OP_SRLV;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_SRAV: begin
                    // srav
                    alu_op = `ALU_OP_SRAV;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end

                `FUNCT_JR    : begin
                    alu_op  = `ALU_OP_NOP;
                    reg_wr = 1'b0;
                    pc_op  = `PC_OP_JR;
                    cop0_op = 2'b00;
                end
                `FUNCT_JALR  : begin
                    alu_op  = `ALU_OP_NOP;
                    reg_src = `REG_SRC_PC;
                    pc_op   = `PC_OP_JR;
                    cop0_op = 2'b00;
                end
                `FUNCT_MOVZ  : begin
                    $display("#error: ctrl unsupport ins");
                end
                `FUNCT_MOVN  : begin
                    $display("#error: ctrl unsupport ins");
                end
                `FUNCT_SYSCALL: begin
                    // syscall
                    alu_op  = `ALU_OP_NOP;
                    reg_wr  = 1'b0;
                    pc_op   = `PC_OP_COP0;
                    cop0_op = `COP_OP_SYS;
                end
                `FUNCT_BREAK : begin
                    // break
                    alu_op  = `ALU_OP_NOP;
                    reg_wr  = 1'b0;
                    pc_op   = `PC_OP_COP0;
                    cop0_op = `COP_OP_BRK;
                end
                `FUNCT_SDBBP : begin
                    $display("#error: ctrl unsupport ins");
                end
                `FUNCT_SYNC  : begin
                    $display("#error: ctrl unsupport ins");
                end


                `FUNCT_MULT: begin
                    // mul, muh
                    if (hint == 5'b00010) begin // mul
                        alu_op = `ALU_OP_MUL;
                    end
                    else if (hint == 5'b00011) begin // muh
                        alu_op = `ALU_OP_MUH;
                    end
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;

                end
                `FUNCT_MULTU: begin
                    // mulu, muhu
                    if (hint == 5'b00010) begin // mulu
                        alu_op = `ALU_OP_MULU;
                    end
                    else if (hint == 5'b00011) begin // muhu
                        alu_op = `ALU_OP_MUHU;
                    end
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;

                end
                `FUNCT_DIV: begin
                    // div, mod
                    if (hint == 5'b00010) begin // div
                        alu_op = `ALU_OP_DIV;
                    end
                    else if (hint == 5'b00011) begin // mod
                        alu_op = `ALU_OP_MOD;
                    end
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;

                end
                `FUNCT_DIVU: begin
                    // divu, modu
                    if (hint == 5'b00010) begin // divu
                        alu_op = `ALU_OP_DIVU;
                    end
                    else if (hint == 5'b00011) begin // modu
                        alu_op = `ALU_OP_MODU;
                    end
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                    pc_op   = `PC_OP_NEXT;
                end

                `FUNCT_ADD: begin
                    alu_op = `ALU_OP_ADD;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_ADDU: begin
                    alu_op = `ALU_OP_ADDU;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_SUB: begin
                    alu_op = `ALU_OP_SUB;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_SUBU: begin
                    alu_op = `ALU_OP_SUB;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_AND: begin
                    alu_op = `ALU_OP_AND;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_OR: begin
                    alu_op = `ALU_OP_OR;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_XOR: begin
                    alu_op = `ALU_OP_XOR;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_NOR: begin
                    alu_op = `ALU_OP_NOR;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end

                `FUNCT_SLT: begin
                    alu_op = `ALU_OP_SLT;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end
                `FUNCT_SLTU: begin
                    alu_op = `ALU_OP_SLTU;
                    pc_op   = `PC_OP_NEXT;
                    reg_wr  = 1'b1;
                    cop0_op = 2'b00;
                end

                default:
                    $display("#error: ctrl unkown ins");
            endcase
        end // op_special

        `OPCODE_REGIMM: begin // branch
            // bal: [rt]=10001
            // bgez:     00001
            // bgezal:   10001
            // bltz:     00000
            case (rt)
                `RT_BAL: begin // bal, bgezal
                    //  brach and link if [rs] >= 0
                    alu_op  = `ALU_OP_SUB;
                    pc_op   = `PC_OP_BGZ;
                    reg_src = `REG_SRC_PC;
                    reg_wr  = 1'b1;
                end
                `RT_BGEZ: begin
                    // [rs] >= 0
                    alu_op  = `ALU_OP_SUB;
                    pc_op   = `PC_OP_BGZ;
                    reg_wr  = 1'b0;
                end
                `RT_BLTZ: begin
                    // [rs] >= 0
                    alu_op  = `ALU_OP_SUB;
                    pc_op   = `PC_OP_BNGNZ;
                    reg_wr  = 1'b0;
                end
                default:
                    $display("#error: ctrl unkown ins");
            endcase
        end
        `OPCODE_J: begin
            pc_op = `PC_OP_J;
            reg_wr  = 1'b0;
            alu_op  = `ALU_OP_NOP;
            cop0_op = 2'b00;
            cop0_rd = 1'b0;
            cop0_wr = 1'b0;
        end
        `OPCODE_JAL: begin
            pc_op   = `PC_OP_J;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_PC;
        end
        `OPCODE_BEQ: begin
            // [rs] == [rt]
            alu_op  = `ALU_OP_SUB;
            pc_op   = `PC_OP_BZ;
        end
        `OPCODE_BNE: begin
            // [rs] != [rt]
            alu_op  = `ALU_OP_SUB;
            pc_op   = `PC_OP_BNZ;
        end
        `OPCODE_BLEZ: begin
            // [rs] = 0
            // rt should be 0
            alu_op  = `ALU_OP_SUB;
            pc_op   = `PC_OP_BNG;
        end
        `OPCODE_BGTZ: begin
            // [rs] > 0
            // rt should be 0
            alu_op  = `ALU_OP_SUB;
            pc_op   = `PC_OP_BG;
        end
        `OPCODE_ADDI: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_ADDIU: begin
            alu_op  = `ALU_OP_ADDU;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_SLTI: begin
            alu_op  = `ALU_OP_SLT;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_SLTIU: begin
            alu_op  = `ALU_OP_SLTU;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_ANDI: begin
            alu_op  = `ALU_OP_AND;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_ORI: begin
            alu_op  = `ALU_OP_OR;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_XORI: begin
            alu_op  = `ALU_OP_XOR;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_AUI: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_ALU;
        end
        `OPCODE_LB: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_DM;
            dm_op   = `DM_OP_BS;
        end
        `OPCODE_LH: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_DM;
            dm_op   = `DM_OP_HS;
        end
        `OPCODE_LWL: begin
            $display("#error: ctrl unsupport ins");
        end
        `OPCODE_LW: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_DM;
            dm_op   = `DM_OP_WD;
        end
        `OPCODE_LBU: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_DM;
            dm_op   = `DM_OP_BZ;
        end
        `OPCODE_LHU: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b1;
            reg_src = `REG_SRC_DM;
            dm_op   = `DM_OP_HZ;
        end
        `OPCODE_LWR: begin
            $display("#error: ctrl unsupport ins");
        end
        `OPCODE_SB: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b0;
            dm_op   = `DM_OP_SB;
        end
        `OPCODE_SH: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b0;
            dm_op   = `DM_OP_SH;
        end
        `OPCODE_SWL: begin
            $display("#error: ctrl unsupport ins");
        end
        `OPCODE_SW: begin
            alu_op  = `ALU_OP_ADD;
            reg_wr  = 1'b0;
            dm_op   = `DM_OP_WD;
        end
        `OPCODE_SWR: begin
        end
        `OPCODE_CACHE: begin
            $display("#error: ctrl unsupport ins");
        end

        `OPCODE_COP0: begin
            if (
                _ins[25]   == 1'b1 &&
                _ins[24:6] == {19{1'b0}} &&
                funct      == 6'b011000) begin
                // eret
                cop0_op = `COP_OP_RET;
                pc_op   = `PC_OP_COP0;
            end
            else begin
                case (rs)
                    5'b00100: begin
                        // mtc0
                        cop0_op = `COP_OP_MV;
                        cop0_wr = 1'b1;
                    end
                    5'b00000: begin
                        // mfc0
                        cop0_op = `COP_OP_MV;
                        cop0_rd = 1'b1;
                        reg_src = `REG_SRC_COP0;
                        reg_wr  = 1'b1;
                    end
                    5'b01011: begin
                        // ei, di
                        cop0_op = _ins_5 ?  `COP_OP_EN : `COP_OP_DIS;
                        reg_src = `REG_SRC_COP0;
                        reg_wr  = 1'b1;
                    end
                    default:
                        $display("#error: ctrl unsupport ins");
                endcase
            end
        end

        `OPCODE_SPECIAL3: begin
            reg_wr = 1'b1;
            case (funct)
                6'b000100: begin
                    //ins
                    alu_op = `ALU_OP_INS;
                end
                6'b000000: begin
                    // ext
                    alu_op = `ALU_OP_EXT;
                end
            endcase
        end
        default:
            $display("#error: ctrl unsupport ins");
    endcase
end

endmodule
