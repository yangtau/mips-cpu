// Extend Op
`define EXT_OP_SE 2'b01 // sign extend
`define EXT_OP_ZE 2'b10 // zero extend
`define EXT_OP_LS 2'b11 // left shift for 16bits

// DataMem Op
`define DM_OP_BS 3'b001
`define DM_OP_BZ 3'b011
`define DM_OP_HS 3'b010
`define DM_OP_HZ 3'b110
`define DM_OP_SB 3'b100
`define DM_OP_SH 3'b101
`define DM_OP_WD 3'b111

// PC Op
`define PC_OP_NEXT 4'b0001
`define PC_OP_BZ   4'b0010 // brach if zero
`define PC_OP_BNZ  4'b0011 // brach if not zero
`define PC_OP_BG   4'b0100 // branch if great
`define PC_OP_BNG  4'b0101 // le: branch if not great
`define PC_OP_BNGNZ 4'b0110 // ls: not zero and not great
`define PC_OP_BGZ  4'b0111 // ge: zero or great
`define PC_OP_J    4'b1000 //
`define PC_OP_JR   4'b1001 //
// Opcode


// ALU Op
`define ALU_OP_ADD   6'b100000
`define ALU_OP_ADDU  6'b100001
`define ALU_OP_SUB   6'b100010
`define ALU_OP_SUBU  6'b100011
`define ALU_OP_AND   6'b100100
`define ALU_OP_OR    6'b100101
`define ALU_OP_NOR   6'b100110
`define ALU_OP_XOR   6'b100111

`define ALU_OP_DIV   6'b011010
`define ALU_OP_DIVU  6'b011011
`define ALU_OP_MOD   6'b011110
`define ALU_OP_MODU  6'b011111
`define ALU_OP_MUL   6'b011000
`define ALU_OP_MULU  6'b011001
`define ALU_OP_MUH   6'b011100
`define ALU_OP_MUHU  6'b011101

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
