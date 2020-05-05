# MIPS CPU

## Instructions

### I-type

- `lui` (`aui`): `lui` `rs` 字段为 0，`aui` 为其拓展
- `andi`
- `ori`
- `xori`
- `lb`
- `lbu`
- `sb`
- `lh`
- `lhu`
- `sh`
- `lw`
- `sw`
- `addi`
- `addiu`
- `slti`
- `sltiu`
- `bal`
- `beq`: `b`: a special case for `beq`
- `bne`
- `bgez`: PCOp 需要參考 rt 字段的值
- `bgezal`
- `bgtz`
- `blez`
- `bltz`

### J-type

- `j`
- `jal`
- `jalr`

### R-type

- `and`
- `nor`
- `or`
- `rotr`
- `rotrv`
- `sll`: `nop`
- `sllv`
- `sra`
- `srav`
- `srl`
- `srlv`
- `xor`
- `add`
- `addu`
- `div`
- `mod`
- `divu`
- `modu`
- `mul`
- `muh`
- `mulu `
- `muhu`
- `sub`
- `subu`
- `slt`
- `sltu`
- `jr`

### Others

- `ext`
- `ins`
- `break`
- `di`
- `ei`
- `eret`
- `mfc0`
- `mtc0`
- `syscall`

## 控制信号

**RegDst**: 1 (RD) 选择 rd，0 (RT) 选择 rt, 31

**ALUSrc**: 1 选择 Immediate，0 选择 rt （must be different from RegDst）

**ExtOp**: SE 表示sign extend，ZE 表示 zero extend，LS 表示 left shift for 16bits

**ALUOp**:  ADD，SUB，AND，OR，XOR，NOR，SLT，SLTU

`great` and `zero` and two input for PC
**PCOp**：NEXT, BZ (branch if `zero`), BNZ (branch if not `zero`), BG (branch if `great`),
         BNG (branch if not `great` ), BNGNZ (branch if not `zero` and not `great`),
         BGZ (branch if `zero` or `great`), J, JA

**DataMemOp**: BS (sign extend byte)，BZ (zero extend byte)，HS，HZ，W，SB，SH

**RegSrc**: PC, ALU (0), MEM (1)

|          | RegDst | RegWr | ALUSrc | ALUOp | MemWr | MemRd | RegSrc | ExtOp | PCOp  | DMOp |
| -------- | ------ | ----- | ------ | ----- | ----- | ----- | ------ | ----- | ----- | ---- |
| `aui`    | 0      | 1     | 1      | ADD   | 0     | 0     | 0      | LS    | NEXT  | x    |
| `andi`   | 0      | 1     | 1      | AND   | 0     | 0     | 0      | ZE    | NEXT  | x    |
| `ori`    | 0      | 1     | 1      | OR    | 0     | 0     | 0      | ZE    | NEXT  | x    |
| `xori`   | 0      | 1     | 1      | XOR   | 0     | 0     | 0      | ZE    | NEXT  | x    |
| `addiu`  | 0      | 1     | 1      | ADD   | 0     | 0     | 0      | SE    | NEXT  | x    |
| `addi`   |        |       |        |       |       |       |        |       |       |      |
| `slti`   | 0      | 1     | 1      | SLT   | 0     | 0     | 0      | SE    | NEXT  | x    |
| `sltiu`  | 0      | 1     | 1      | SLTU  | 0     | 0     | 0      | SE    | NEXT  | x    |
| `lb`     | 0      | 1     | 1      | ADD   | 0     | 1     | 1      | SE    | NEXT  | BS   |
| `lbu`    | 0      | 1     | 1      | ADD   | 0     | 1     | 1      | SE    | NEXT  | BZ   |
| `lh`     | 0      | 1     | 1      | ADD   | 0     | 1     | 1      | SE    | NEXT  | HS   |
| `lhu`    | 0      | 1     | 1      | ADD   | 0     | 1     | 1      | SE    | NEXT  | HZ   |
| `lw`     | 0      | 1     | 1      | ADD   | 0     | 1     | 1      | SE    | NEXT  | W    |
| `sb`     | x      | 0     | 1      | ADD   | 1     | 0     | x      | SE    | NEXT  | SB   |
| `sh`     | x      | 0     | 1      | ADD   | 1     | 0     | x      | SE    | NEXT  | SH   |
| `sw`     | x      | 0     | 1      | ADD   | 1     | 0     | x      | SE    | NEXT  | W    |
| `beq`    | x      | 0     | 0      | SUB   | 0     | 0     | x      | x     | BZ    | x    |
| `bne`    | x      | 0     | 0      | SUB   | 0     | 0     | x      | x     | BNZ   | x    |
| `bgtz`   | x      | 0     | 0      | SUB   | 0     | 0     | x      | x     | BG    | x    |
| `blez`   | x      | 0     | 0      | SUB   | 0     | 0     | x      | x     | BNG   | x    |
| `bltz`   | x      | 0     | 0      | SUB   | 0     | 0     | x      | x     | BNGNZ | x    |
| `bgez`   | x      | 0     | 0      | SUB   | 0     | 0     | x      | x     | BGZ   | x    |
| `bgezal` | 31     | 1     | 0      | SUB   | 0     | 0     | pc     | x     | BGZ   | x    |
| `bal`    | 31     | 1     | 0      | SUB   | 0     | 0     | pc     | x     | BGZ   | x    |
| `j`      | x      | 0     | x      | x     | 0     | 0     | x      | x     | J     | x    |
| `jal`    | 31     | 1     | x      | x     | 0     | 0     | pc     | x     | J     | x    |
|          | RegDst | RegWr | ALUSrc | ALUOp | MemWr | MemRd | RegSrc | ExtOp | PCOp  | DMOp |
| `jr`     | x      | 0     | x      | x     | 0     | 0     | x      | x     | JR    | x    |
| `jalr`   | 1      | 1     | x      | x     | 0     | 0     | PC     | x     | JR    | x    |
| `and`    | 1      | 1     | 0      | AND   | 0     | 0     | 0      | x     | NEXT  | x    |
| `or`     | 1      | 1     | 0      | OR    | 0     | 0     | 0      | x     | NEXT  | x    |
| `nor`    | 1      | 1     | 0      | NOR   | 0     | 0     | 0      | x     | NEXT  | x    |
| `xor`    | 1      | 1     | 0      | XOR   | 0     | 0     | 0      | x     | NEXT  | x    |
| `sll`    | 1      | 1     | 0      | SLL   | 0     | 0     | 0      | x     | NEXT  | x    |
| `sllv`   | 1      | 1     | 0      | SLLV  | 0     | 0     | 0      | x     | NEXT  | x    |
| `sra`    | 1      | 1     | 0      | SRA   | 0     | 0     | 0      | x     | NEXT  | x    |
| `srav`   | 1      | 1     | 0      | SRAV  | 0     | 0     | 0      | x     | NEXT  | x    |
| `srl`    | 1      | 1     | 0      | SRL   | 0     | 0     | 0      | x     | NEXT  | x    |
| `srlv`   | 1      | 1     | 0      | SRLV  | 0     | 0     | 0      | x     | NEXT  | x    |
| `rotr`   | 1      | 1     | 0      | ROTR  | 0     | 0     | 0      | x     | NEXT  | x    |
| `rotrv`  | 1      | 1     | 0      | ROTRV | 0     | 0     | 0      | x     | NEXT  | x    |
| `add`    | 1      | 1     | 0      | ADD   | 0     | 0     | 0      | x     | NEXT  | x    |
| `addu`   | 1      | 1     | 0      | ADD   | 0     | 0     | 0      | x     | NEXT  | x    |
| `sub`    | 1      | 1     | 0      | SUB   | 0     | 0     | 0      | x     | NEXT  | x    |
| `subu`   | 1      | 1     | 0      | SUB   | 0     | 0     | 0      | x     | NEXT  | x    |
| `div`    | 1      | 1     | 0      | DIV   | 0     | 0     | 0      | x     | NEXT  | x    |
| `divu`   | 1      | 1     | 0      | DIVU  | 0     | 0     | 0      | x     | NEXT  | x    |
| `mod`    | 1      | 1     | 0      | MOD   | 0     | 0     | 0      | x     | NEXT  | x    |
| `modu`   | 1      | 1     | 0      | MODU  | 0     | 0     | 0      | x     | NEXT  | x    |
| `mul`    | 1      | 1     | 0      | MUL   | 0     | 0     | 0      | x     | NEXT  | x    |
| `mulu`   | 1      | 1     | 0      | MULU  | 0     | 0     | 0      | x     | NEXT  | x    |
| `muh`    | 1      | 1     | 0      | MUH   | 0     | 0     | 0      | x     | NEXT  | x    |
| `muhu`   | 1      | 1     | 0      | MUHU  | 0     | 0     | 0      | x     | NEXT  | x    |
| `slt`    | 1      | 1     | 0      | slt   | 0     | 0     | 0      | x     | NEXT  | x    |
| `sltu`   | 1      | 1     | 0      | sltu  | 0     | 0     | 0      | x     | NEXT  | x    |
