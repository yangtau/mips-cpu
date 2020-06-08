// Reg Src  (determine the data write to register file)
`define REG_SRC_PC   2'b01
`define REG_SRC_ALU  2'b10
`define REG_SRC_DM   2'b11
`define REG_SRC_COP0 2'b00

// Reg Dst (determine the register number that will be written)
`define REG_DST_RD 2'b01
`define REG_DST_RT 2'b10
`define REG_DST_31 2'b11

// Reg in: rt
`define REG_IN_RT   1'b1
`define REG_IN_ZERO 1'b0

// ALU src
`define ALU_SRC_IM 1'b1
`define ALU_SRC_RT 1'b0

// Extend Op
`define EXT_OP_NOP 2'b00
`define EXT_OP_SE  2'b01 // sign extend
`define EXT_OP_ZE  2'b10 // zero extend
`define EXT_OP_LS  2'b11 // left shift for 16bits

// DataMem Op
`define DM_OP_NOP 3'b000
`define DM_OP_BS  3'b001 // load sign extended byte
`define DM_OP_BZ  3'b011 // zero extended byte
`define DM_OP_HS  3'b010 // sign extend half word
`define DM_OP_HZ  3'b110 // zero extend half word
`define DM_OP_SB  3'b100 // store byte
`define DM_OP_SH  3'b101 // store half word
`define DM_OP_WD  3'b111 // store or load word

// PC Op
`define PC_OP_NEXT  4'b0001
`define PC_OP_BZ    4'b0010 // brach if zero
`define PC_OP_BNZ   4'b0011 // brach if not zero
`define PC_OP_BG    4'b0100 // branch if great
`define PC_OP_BNG   4'b0101 // le: branch if not great
`define PC_OP_BNGNZ 4'b0110 // ls: not zero and not great
`define PC_OP_BGZ   4'b0111 // ge: zero or great
`define PC_OP_J     4'b1000 //
`define PC_OP_JR    4'b1001 //
`define PC_OP_COP0  4'b1010 // get next pc from cop0

// ALU Op
`define ALU_OP_ADD  6'b100000
`define ALU_OP_ADDU 6'b100001
`define ALU_OP_SUB  6'b100010
`define ALU_OP_SUBU 6'b100011
`define ALU_OP_AND  6'b100100
`define ALU_OP_OR   6'b100101
`define ALU_OP_NOR  6'b100110
`define ALU_OP_XOR  6'b100111

`define ALU_OP_DIV  6'b011010
`define ALU_OP_DIVU 6'b011011
`define ALU_OP_MOD  6'b011110
`define ALU_OP_MODU 6'b011111
`define ALU_OP_MUL  6'b011000
`define ALU_OP_MULU 6'b011001
`define ALU_OP_MUH  6'b011100
`define ALU_OP_MUHU 6'b011101

`define ALU_OP_SLL   6'b000000
`define ALU_OP_SLLV  6'b000001
`define ALU_OP_SRA   6'b000010
`define ALU_OP_SRAV  6'b000011
`define ALU_OP_SRL   6'b000100
`define ALU_OP_SRLV  6'b000101
`define ALU_OP_ROTR  6'b000110
`define ALU_OP_ROTRV 6'b000111

`define ALU_OP_SLT   6'b101010
`define ALU_OP_SLTU  6'b101011
`define ALU_OP_NOP   6'b111111

// bit field operation
`define ALU_OP_INS 6'b001000
`define ALU_OP_EXT 6'b001001
//< ALU Op

//> Opcode
`define OPCODE_SPECIAL 6'b000000 // f
`define OPCODE_REGIMM  6'b000001 // f
`define OPCODE_J       6'b000010
`define OPCODE_JAL     6'b000011
`define OPCODE_BEQ     6'b000100
`define OPCODE_BNE     6'b000101
`define OPCODE_BLEZ    6'b000110  // rt = 0
`define OPCODE_BGTZ    6'b000111  // rt = 0

`define OPCODE_ADDI  6'b001000
`define OPCODE_ADDIU 6'b001001
`define OPCODE_SLTI  6'b001010
`define OPCODE_SLTIU 6'b001011
`define OPCODE_ANDI  6'b001100
`define OPCODE_ORI   6'b001101
`define OPCODE_XORI  6'b001110
`define OPCODE_AUI   6'b001111

`define OPCODE_COP0  6'b010000
`define OPCODE_COP1  6'b010001
`define OPCODE_COP2  6'b010010
`define OPCODE_COP1X 6'b010011
`define OPCODE_BEQL  6'b010100
`define OPCODE_BNEL  6'b010101
`define OPCODE_BLEZL 6'b010110
`define OPCODE_BGTZL 6'b010111

`define OPCODE_POP30    6'b011000
`define OPCODE_RV1      6'b011001
`define OPCODE_RV2      6'b011010
`define OPCODE_RV3      6'b011011
`define OPCODE_SPECIAL2 6'b011100 // f
`define OPCODE_JALX     6'b011101
`define OPCODE_MSA      6'b011110
`define OPCODE_SPECIAL3 6'b011111

`define OPCODE_LB  6'b100000
`define OPCODE_LH  6'b100001
`define OPCODE_LWL 6'b100010
`define OPCODE_LW  6'b100011
`define OPCODE_LBU 6'b100100
`define OPCODE_LHU 6'b100101
`define OPCODE_LWR 6'b100110
`define OPCODE_RV4 6'b100111

`define OPCODE_SB    6'b101000
`define OPCODE_SH    6'b101001
`define OPCODE_SWL   6'b101010
`define OPCODE_SW    6'b101011
`define OPCODE_RV5   6'b101100
`define OPCODE_RV6   6'b101101
`define OPCODE_SWR   6'b101110
`define OPCODE_CACHE 6'b101111

`define OPCODE_LL    6'b110000
`define OPCODE_LWC1  6'b110001
`define OPCODE_LWC2  6'b110010
`define OPCODE_PREF  6'b110011
`define OPCODE_RV7   6'b110100
`define OPCODE_LDC1  6'b110101
`define OPCODE_LDC2  6'b110110
`define OPCODE_RV8   6'b110111

`define OPCODE_SC    6'b111000
`define OPCODE_SWC1  6'b111001
`define OPCODE_SWC2  6'b111010
`define OPCODE_PCREL 6'b111011
`define OPCODE_RV9   6'b111100
`define OPCODE_SDC1  6'b111101
`define OPCODE_SDC2  6'b111110
`define OPCODE_RV10  6'b111111
//< Opcode

//> funct
`define FUNCT_SLL   6'b000000
`define FUNCT_MOVCI 6'b000001
`define FUNCT_SRL   6'b000010 // f
`define FUNCT_SRA   6'b000011
`define FUNCT_SLLV  6'b000100
`define FUNCT_LSA   6'b000101
`define FUNCT_SRLV  6'b000110
`define FUNCT_SRAV  6'b000111

`define FUNCT_JR      6'b001000
`define FUNCT_JALR    6'b001001
`define FUNCT_MOVZ    6'b001010
`define FUNCT_MOVN    6'b001011
`define FUNCT_SYSCALL 6'b001100
`define FUNCT_BREAK   6'b001101
`define FUNCT_SDBBP   6'b001110
`define FUNCT_SYNC    6'b001111

//`define FUNCT_      6'b010000
//`define FUNCT_      6'b010001
//`define FUNCT_      6'b010010
//`define FUNCT_      6'b010011
//`define FUNCT_      6'b010100
//`define FUNCT_      6'b010101
//`define FUNCT_      6'b010110
//`define FUNCT_      6'b010111

`define FUNCT_MULT  6'b011000
`define FUNCT_MULTU 6'b011001
`define FUNCT_DIV   6'b011010
`define FUNCT_DIVU  6'b011011
//`define FUNCT_      6'b011100
//`define FUNCT_      6'b011101
//`define FUNCT_      6'b011110
//`define FUNCT_      6'b011111

`define FUNCT_ADD    6'b100000
`define FUNCT_ADDU   6'b100001
`define FUNCT_SUB    6'b100010
`define FUNCT_SUBU   6'b100011
`define FUNCT_AND    6'b100100
`define FUNCT_OR     6'b100101
`define FUNCT_XOR    6'b100110
`define FUNCT_NOR    6'b100111

//`define FUNCT_      6'b101000
//`define FUNCT_      6'b101001
`define FUNCT_SLT   6'b101010
`define FUNCT_SLTU  6'b101011
//`define FUNCT_      6'b101100
//`define FUNCT_      6'b101101
//`define FUNCT_      6'b101110
//`define FUNCT_      6'b101111

//`define FUNCT_      6'b110000
//`define FUNCT_      6'b110001
//`define FUNCT_      6'b110010
//`define FUNCT_      6'b110011
//`define FUNCT_      6'b110100
//`define FUNCT_      6'b110101
//`define FUNCT_      6'b110110
//`define FUNCT_      6'b110111

//`define FUNCT_      6'b111000
//`define FUNCT_      6'b111001
//`define FUNCT_      6'b111010
//`define FUNCT_      6'b111011
//`define FUNCT_      6'b111100
//`define FUNCT_      6'b111101
//`define FUNCT_      6'b111110
//`define FUNCT_      6'b111111
//< funct

// rt field
`define RT_BLTZ 5'b00000
`define RT_BGEZ 5'b00001
`define RT_BAL  5'b10001

//> COP Op
`define COP_OP_NOP 3'b000
`define COP_OP_MV  3'b001
`define COP_OP_EN  3'b010 // enable interupt
`define COP_OP_DIS 3'b011 // disable interupt
`define COP_OP_SYS 3'b100 // system call
`define COP_OP_RET 3'b101 // eret
`define COP_OP_BRK 3'b110 // break
//< COP Op


//> 
// Physical bit-width of memory-mapped I/O interfaces
`define MFP_N_LED             8
`define MFP_N_SW              8
`define MFP_N_PB              1

`define H_RAM_RESET_ADDR_WIDTH  (8)   // each block is 256 Bytes , the total size is  1 KB
`define H_RAM_ADDR_WIDTH		  (12)  // each block is 4K  Bytes , the total size is 16 KB
//<