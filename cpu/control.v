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
           input  wire [5:0] opcode,
           input  wire [5:0] funct,
           input  wire [4:0] hint, // ins[10:6]
           input  wire [4:0] rs,   // ins[25:21]
           input  wire [4:0] rt,   // ins[20:16]
           input  wire [4:0] rd,   // ins[15:11]
           output wire [5:0] alu_op,
           output wire       alu_src, // [rt] or im
           output wire [2:0] dm_op,
           output wire       dm_wr,
           output wire       dm_rd,
           output wire [1:0] ext_op,
           output wire [3:0] pc_op,
           output wire [1:0] reg_src,
           output wire [1:0] reg_dst,
           output wire       reg_wr,
           output wire       reg_in,
           output wire       cop0_wr,
           output wire       cop0_rd,
           output wire [2:0] cop0_op);

reg [5:0] _alu_op;
reg       _alu_src;
reg [2:0] _dm_op;
reg       _dm_wr;
reg       _dm_rd;
reg [1:0] _ext_op;
reg [3:0] _pc_op;
reg [1:0] _reg_src;
reg [1:0] _reg_dst;
reg       _reg_wr;
reg       _reg_in;
reg      _cop0_wr;
reg      _cop0_rd;
reg      _cop0_op;

wire [31:0] _ins      = {opcode,  rs, rt, rd, hint, funct};
wire [7:0]  _ins_10_3 = _ins[10:3];
wire [2:0]  _ins_2_0  = _ins[2:0];
wire        _ins_5    = _ins[5];

always @(*) begin
    _pc_op   <= `PC_OP_NEXT;
    _reg_in  <= `REG_IN_RT;
    _reg_wr  <= 1'b0;
    _alu_op  <= `ALU_OP_NOP;
    _dm_rd   <= 1'b0;
    _dm_wr   <= 1'b0;
    _cop0_op <= 2'b00;
    _cop0_rd <= 1'b0;
    _cop0_wr <= 1'b0;
    case (opcode)
        `OPCODE_SPECIAL: begin // R-type
            _reg_dst <= `REG_DST_RD;
            _reg_src <= `REG_SRC_ALU;
            _reg_wr  <= 1'b1;
            _alu_src <= 1'b0; // 0 for [rt]
            _dm_wr   <= 1'b0;
            _dm_rd   <= 1'b0;

            case (funct)
                `FUNCT_SLL: begin
                    // sll, nop
                    _alu_op <= `ALU_OP_SLL;
                end
                `FUNCT_MOVCI: begin
                end
                `FUNCT_SRL: begin
                    // srl
                    _alu_op <= `ALU_OP_SRL;
                end
                `FUNCT_SRA: begin
                    // sra
                    _alu_op <= `ALU_OP_SRA;
                end
                `FUNCT_SLLV: begin
                    // sllv
                    _alu_op <= `ALU_OP_SLLV;
                end
                `FUNCT_LSA: begin
                end
                `FUNCT_SRLV: begin
                    // srlv
                    _alu_op <= `ALU_OP_SRLV;
                end
                `FUNCT_SRAV: begin
                    // srav
                    _alu_op <= `ALU_OP_SRAV;
                end

                `FUNCT_JR    : begin
                    _reg_wr <= 1'b0;
                    _pc_op  <= `PC_OP_JR;
                end
                `FUNCT_JALR  : begin
                    _reg_src <= `REG_SRC_PC;
                    _pc_op   <= `PC_OP_JR;
                end
                `FUNCT_MOVZ  : begin
                end
                `FUNCT_MOVN  : begin
                end
                `FUNCT_SYSCALL: begin
                    // syscall
                    _reg_wr  <= 1'b0;
                    _pc_op   <= `PC_OP_COP0;
                    _cop0_op <= `COP_OP_SYS;
                end
                `FUNCT_BREAK : begin
                    // break
                    _reg_wr  <= 1'b0;
                    _pc_op   <= `PC_OP_COP0;
                    _cop0_op <= `COP_OP_BRK;
                end
                `FUNCT_SDBBP : begin
                end
                `FUNCT_SYNC  : begin
                end


                `FUNCT_MULT: begin
                    // mul, muh
                    if (hint == 5'b00010) begin // mul
                        _alu_op <= `ALU_OP_MUL;
                    end
                    else if (hint == 5'b00011) begin // muh
                        _alu_op <= `ALU_OP_MUH;
                    end
                end
                `FUNCT_MULTU: begin
                    // mulu, muhu
                    if (hint == 5'b00010) begin // mulu
                        _alu_op <= `ALU_OP_MULU;
                    end
                    else if (hint == 5'b00011) begin // muhu
                        _alu_op <= `ALU_OP_MUHU;
                    end
                end
                `FUNCT_DIV: begin
                    // div, mod
                    if (hint == 5'b00010) begin // div
                        _alu_op <= `ALU_OP_DIV;
                    end
                    else if (hint == 5'b00011) begin // mod
                        _alu_op <= `ALU_OP_MOD;
                    end
                end
                `FUNCT_DIVU: begin
                    // divu, modu
                    if (hint == 5'b00010) begin // divu
                        _alu_op <= `ALU_OP_DIVU;
                    end
                    else if (hint == 5'b00011) begin // modu
                        _alu_op <= `ALU_OP_MODU;
                    end
                end

                `FUNCT_ADD: begin
                    _alu_op <= `ALU_OP_ADD;
                end
                `FUNCT_ADDU: begin
                    _alu_op <= `ALU_OP_ADDU;
                end
                `FUNCT_SUB: begin
                    _alu_op <= `ALU_OP_SUB;
                end
                `FUNCT_SUBU: begin
                    _alu_op <= `ALU_OP_SUB;
                end
                `FUNCT_AND: begin
                    _alu_op <= `ALU_OP_AND;
                end
                `FUNCT_OR: begin
                    _alu_op <= `ALU_OP_OR;
                end
                `FUNCT_XOR: begin
                    _alu_op <= `ALU_OP_XOR;
                end
                `FUNCT_NOR: begin
                    _alu_op <= `ALU_OP_NOR;
                end

                `FUNCT_SLT: begin
                    _alu_op <= `ALU_OP_SLT;
                end
                `FUNCT_SLTU: begin
                    _alu_op <= `ALU_OP_SLTU;
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
                    _alu_op  <= `ALU_OP_SUB;
                    _pc_op   <= `PC_OP_BGZ;
                    _reg_in  <= `REG_IN_ZERO;
                    _reg_src <= `REG_SRC_PC;
                    _reg_dst <= `REG_DST_31;
                    _reg_wr  <= 1'b1;
                    _alu_src <= `ALU_SRC_RT;
                end
                `RT_BGEZ: begin
                    // [rs] >= 0
                    _alu_op  <= `ALU_OP_SUB;
                    _pc_op   <= `PC_OP_BGZ;
                    _reg_in  <= `REG_IN_ZERO;
                    _alu_src <= `ALU_SRC_RT;
                end
                `RT_BLTZ: begin
                    // [rs] >= 0
                    _alu_op  <= `ALU_OP_SUB;
                    _pc_op   <= `PC_OP_BNGNZ;
                    _reg_in  <= `REG_IN_ZERO;
                    _alu_src <= `ALU_SRC_RT;
                end
                default:
                    // TODO
                    ;
            endcase
        end
        `OPCODE_J: begin
            _pc_op <= `PC_OP_J;
        end
        `OPCODE_JAL: begin
            _pc_op   <= `PC_OP_J;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_PC;
            _reg_dst <= `REG_DST_31;
        end
        `OPCODE_BEQ: begin
            // [rs] == [rt]
            _alu_op  <= `ALU_OP_SUB;
            _alu_src <= `ALU_SRC_RT;
            _pc_op   <= `PC_OP_BZ;
        end
        `OPCODE_BNE: begin
            // [rs] != [rt]
            _alu_op  <= `ALU_OP_SUB;
            _alu_src <= `ALU_SRC_RT;
            _pc_op   <= `PC_OP_BNZ;
        end
        `OPCODE_BLEZ: begin
            // [rs] <= 0
            // rt should be 0
            _alu_op  <= `ALU_OP_SUB;
            _alu_src <= `ALU_SRC_RT;
            _pc_op   <= `PC_OP_BNG;
        end
        `OPCODE_BGTZ: begin
            // [rs] > 0
            // rt should be 0
            _alu_op  <= `ALU_OP_SUB;
            _alu_src <= `ALU_SRC_RT;
            _pc_op   <= `PC_OP_BG;
        end
        `OPCODE_ADDI: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_ADDIU: begin
            _alu_op  <= `ALU_OP_ADDU;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_SLTI: begin
            _alu_op  <= `ALU_OP_SLT;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_SLTIU: begin
            _alu_op  <= `ALU_OP_SLTU;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_ANDI: begin
            _alu_op  <= `ALU_OP_AND;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_ZE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_ORI: begin
            _alu_op  <= `ALU_OP_OR;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_ZE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_XORI: begin
            _alu_op  <= `ALU_OP_XOR;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_ZE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_AUI: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_LS;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_ALU;
        end
        `OPCODE_LB: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_DM;
            _dm_op   <= `DM_OP_BS;
            _dm_rd   <= 1'b1;
        end
        `OPCODE_LH: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_DM;
            _dm_op   <= `DM_OP_HS;
            _dm_rd   <= 1'b1;
        end
        `OPCODE_LWL: begin
        end
        `OPCODE_LW: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_DM;
            _dm_op   <= `DM_OP_WD;
            _dm_rd   <= 1'b1;
        end
        `OPCODE_LBU: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_DM;
            _dm_op   <= `DM_OP_BZ;
            _dm_rd   <= 1'b1;
        end
        `OPCODE_LHU: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b1;
            _reg_src <= `REG_SRC_DM;
            _dm_op   <= `DM_OP_HZ;
            _dm_rd   <= 1'b1;
        end
        `OPCODE_LWR: begin
        end
        `OPCODE_SB: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b0;
            _dm_op   <= `DM_OP_SB;
            _dm_wr   <= 1'b1;
        end
        `OPCODE_SH: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b0;
            _dm_op   <= `DM_OP_SH;
            _dm_wr   <= 1'b1;
        end
        `OPCODE_SWL: begin
        end
        `OPCODE_SW: begin
            _alu_op  <= `ALU_OP_ADD;
            _alu_src <= `ALU_SRC_IM;
            _ext_op  <= `EXT_OP_SE;
            _reg_wr  <= 1'b0;
            _dm_op   <= `DM_OP_WD;
            _dm_wr   <= 1'b1;
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
                _cop0_op <= `COP_OP_RET;
                _pc_op   <= `PC_OP_COP0;
            end
            else begin
                case (rs)
                    5'b00100: begin
                        // mtc0
                        _cop0_op <= `COP_OP_MV;
                        _cop0_rd <= 1'b1;
                    end
                    5'b00000: begin
                        // mfc0
                        _cop0_op <= `COP_OP_MV;
                        _cop0_wr <= 1'b1;
                        _reg_src <= `REG_SRC_COP0;
                        _reg_wr  <= 1'b1;
                    end
                    5'b01011: begin
                        // ei, di
                        _cop0_op <= _ins_5 ?  `COP_OP_EN : `COP_OP_DIS;
                        _reg_src <= `REG_SRC_COP0;
                        _reg_wr  <= 1'b1;
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

assign alu_op  = _alu_op;
assign alu_src = _alu_src;
assign dm_op   = _dm_op;
assign dm_wr   = _dm_wr;
assign dm_rd   = _dm_rd;
assign ext_op  = _ext_op;
assign pc_op   = _pc_op;
assign reg_src = _reg_src;
assign reg_dst = _reg_dst;
assign reg_wr  = _reg_wr;
assign reg_in  = _reg_in;
assign cop0_wr = _cop0_wr;
assign cop0_rd = _cop0_rd;
assign cop0_op = _cop0_op;

endmodule
