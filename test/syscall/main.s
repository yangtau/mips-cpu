	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	oddspreg
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.align	2
	.globl	delay
.LFB0 = .
	.file 1 "main.c"
	.loc 1 4 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	delay
	.type	delay, @function
delay:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	.cfi_def_cfa_offset 16
	sw	$fp,12($sp)
	.cfi_offset 30, -4
	move	$fp,$sp
	.cfi_def_cfa_register 30
	.loc 1 7 0
	sw	$0,0($fp)
	b	.L2
	nop

.L3:
	.loc 1 7 0 is_stmt 0 discriminator 3
	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
.L2:
	.loc 1 7 0 discriminator 1
	lw	$3,0($fp)
	li	$2,851968			# 0xd0000
	ori	$2,$2,0xbba0
	sltu	$2,$3,$2
	bne	$2,$0,.L3
	nop

	.loc 1 9 0 is_stmt 1
	nop
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	delay
	.cfi_endproc
.LFE0:
	.size	delay, .-delay

	.comm	n,4,4
	.align	2
	.globl	main
.LFB1 = .
	.loc 1 12 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,8,$31		# vars= 0, regs= 2/0, args= 0, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	.cfi_def_cfa_offset 8
	sw	$31,4($sp)
	sw	$fp,0($sp)
	.cfi_offset 31, -4
	.cfi_offset 30, -8
	move	$fp,$sp
	.cfi_def_cfa_register 30
.LBB2 = .
.LBB3 = .
	.loc 1 15 0
 #APP
 # 15 "main.c" 1
	mfc0 $2,$12,0
 # 0 "" 2
 #NO_APP
	move	$31,$2
	move	$2,$31
.LBE3 = .
	move	$31,$2
	move	$2,$31
	ins	$2,$0,22,1
 #APP
 # 15 "main.c" 1
	.set push 
.set noreorder
mtc0 $2,$12,0
ehb
.set pop
 # 0 "" 2
 #NO_APP
.LBE2 = .
.LBB4 = .
.LBB5 = .
	.loc 1 16 0
 #APP
 # 16 "main.c" 1
	mfc0 $2,$12,0
 # 0 "" 2
 #NO_APP
	move	$31,$2
	move	$2,$31
.LBE5 = .
	move	$31,$2
	move	$2,$31
	ins	$2,$0,2,1
 #APP
 # 16 "main.c" 1
	.set push 
.set noreorder
mtc0 $2,$12,0
ehb
.set pop
 # 0 "" 2
 #NO_APP
.LBE4 = .
.LBB6 = .
.LBB7 = .
	.loc 1 19 0
 #APP
 # 19 "main.c" 1
	mfc0 $2,$12,0
 # 0 "" 2
 #NO_APP
	move	$31,$2
	move	$2,$31
.LBE7 = .
	move	$31,$2
	ori	$2,$31,0x1e01
 #APP
 # 19 "main.c" 1
	.set push 
.set noreorder
mtc0 $2,$12,0
ehb
.set pop
 # 0 "" 2
 #NO_APP
.L5:
.LBE6 = .
	.loc 1 21 0 discriminator 1
	li	$2,41891			# 0xa3a3
	sw	$2,%gp_rel(n)($28)
	.loc 1 22 0 discriminator 1
 #APP
 # 22 "main.c" 1
	syscall
 # 0 "" 2
	.loc 1 21 0 discriminator 1
 #NO_APP
	b	.L5
	.end	main
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.align	2
	.globl	_mips_general_exception
.LFB2 = .
	.loc 1 28 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	_mips_general_exception
	.type	_mips_general_exception, @function
_mips_general_exception:
	.frame	$fp,32,$31		# vars= 8, regs= 4/0, args= 0, gp= 0
	.mask	0x4001000c,-12
	.fmask	0x00000000,0
	mfc0	$27,$14
	addiu	$sp,$sp,-32
	.cfi_def_cfa_offset 32
	sw	$27,28($sp)
	mfc0	$27,$12
	sw	$27,24($sp)
	ins	$27,$0,0,5
	mtc0	$27,$12
	sw	$fp,20($sp)
	sw	$16,16($sp)
	sw	$3,12($sp)
	sw	$2,8($sp)
	.cfi_offset 30, -12
	.cfi_offset 16, -16
	.cfi_offset 3, -20
	.cfi_offset 2, -24
	move	$fp,$sp
	.cfi_def_cfa_register 30
.LBB8 = .
	.loc 1 29 0
 #APP
 # 29 "main.c" 1
	mfc0 $2,$13,0
 # 0 "" 2
 #NO_APP
	move	$16,$2
	move	$2,$16
.LBE8 = .
	sw	$2,0($fp)
	.loc 1 30 0
	lw	$2,0($fp)
	andi	$2,$2,0x100
	beq	$2,$0,.L7
	.loc 1 32 0
	li	$2,-1082130432			# 0xffffffffbf800000
	lw	$3,%gp_rel(n)($28)
	sw	$3,0($2)
	.loc 1 33 0
	li	$2,-1082130432			# 0xffffffffbf800000
	ori	$2,$2,0x10
	lw	$3,%gp_rel(n)($28)
	sw	$3,0($2)
.L7:
	.loc 1 35 0
	lw	$2,0($fp)
	andi	$2,$2,0x400
	beq	$2,$0,.L8
	.loc 1 36 0
	li	$2,-1082130432			# 0xffffffffbf800000
	li	$3,2			# 0x2
	sw	$3,0($2)
	.loc 1 37 0
	li	$2,-1082130432			# 0xffffffffbf800000
	ori	$2,$2,0x10
	li	$3,2			# 0x2
	sw	$3,0($2)
.L8:
	.loc 1 39 0
	lw	$2,0($fp)
	andi	$2,$2,0x800
	beq	$2,$0,.L9
	.loc 1 40 0
	li	$2,-1082130432			# 0xffffffffbf800000
	li	$3,3			# 0x3
	sw	$3,0($2)
	.loc 1 41 0
	li	$2,-1082130432			# 0xffffffffbf800000
	ori	$2,$2,0x10
	li	$3,3			# 0x3
	sw	$3,0($2)
.L9:
	.loc 1 43 0
	lw	$2,0($fp)
	andi	$2,$2,0x1000
	beq	$2,$0,.L11
	.loc 1 44 0
	li	$2,-1082130432			# 0xffffffffbf800000
	li	$3,4			# 0x4
	sw	$3,0($2)
	.loc 1 45 0
	li	$2,-1082130432			# 0xffffffffbf800000
	ori	$2,$2,0x10
	li	$3,4			# 0x4
	sw	$3,0($2)
.L11:
	.loc 1 47 0
	.set	noreorder
	nop
	.set	reorder
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$fp,20($sp)
	lw	$16,16($sp)
	lw	$3,12($sp)
	lw	$2,8($sp)
	lw	$27,28($sp)
	mtc0	$27,$14
	lw	$27,24($sp)
	addiu	$sp,$sp,32
	.cfi_restore 2
	.cfi_restore 3
	.cfi_restore 16
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	mtc0	$27,$12
	eret
	.end	_mips_general_exception
	.cfi_endproc
.LFE2:
	.size	_mips_general_exception, .-_mips_general_exception
.Letext0:
	.file 2 "c:\\users\\qyang\\apps\\mips-mti-elf\\mips-mti-elf\\include\\mips\\cpu.h"
	.file 3 "c:\\users\\qyang\\apps\\mips-mti-elf\\mips-mti-elf\\include\\mips\\m32c0.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x22b
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF25
	.byte	0xc
	.4byte	.LASF26
	.4byte	.LASF27
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.4byte	.LASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.4byte	.LASF2
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.4byte	.LASF4
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF5
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF7
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x4
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.4byte	.LASF8
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF9
	.uleb128 0x4
	.4byte	0x70
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF11
	.uleb128 0x5
	.4byte	.LASF28
	.byte	0x3
	.2byte	0x400
	.4byte	0x70
	.uleb128 0x6
	.4byte	.LASF12
	.byte	0x2
	.byte	0x3f
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF13
	.byte	0x2
	.byte	0x3f
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF14
	.byte	0x2
	.byte	0x3f
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF15
	.byte	0x2
	.byte	0x40
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF16
	.byte	0x2
	.byte	0x40
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF17
	.byte	0x2
	.byte	0x40
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF18
	.byte	0x2
	.byte	0x41
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF19
	.byte	0x2
	.byte	0x41
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF20
	.byte	0x2
	.byte	0x41
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF21
	.byte	0x2
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF22
	.byte	0x2
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF23
	.byte	0x2
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x7
	.ascii	"n\000"
	.byte	0x1
	.byte	0xb
	.4byte	0x64
	.uleb128 0x5
	.byte	0x3
	.4byte	n
	.uleb128 0x8
	.4byte	.LASF29
	.byte	0x1
	.byte	0x1c
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x164
	.uleb128 0x9
	.4byte	.LASF24
	.byte	0x1
	.byte	0x1d
	.4byte	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xa
	.4byte	.LBB8
	.4byte	.LBE8-.LBB8
	.uleb128 0xb
	.ascii	"__r\000"
	.byte	0x1
	.byte	0x1d
	.4byte	0x48
	.uleb128 0x1
	.byte	0x60
	.byte	0
	.byte	0
	.uleb128 0xc
	.4byte	.LASF30
	.byte	0x1
	.byte	0xc
	.4byte	0x5d
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x210
	.uleb128 0xd
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.4byte	0x1af
	.uleb128 0xb
	.ascii	"__o\000"
	.byte	0x1
	.byte	0xf
	.4byte	0x8a
	.uleb128 0x1
	.byte	0x6f
	.uleb128 0xa
	.4byte	.LBB3
	.4byte	.LBE3-.LBB3
	.uleb128 0xb
	.ascii	"__r\000"
	.byte	0x1
	.byte	0xf
	.4byte	0x48
	.uleb128 0x1
	.byte	0x6f
	.byte	0
	.byte	0
	.uleb128 0xd
	.4byte	.LBB4
	.4byte	.LBE4-.LBB4
	.4byte	0x1e1
	.uleb128 0xb
	.ascii	"__o\000"
	.byte	0x1
	.byte	0x10
	.4byte	0x8a
	.uleb128 0x1
	.byte	0x6f
	.uleb128 0xa
	.4byte	.LBB5
	.4byte	.LBE5-.LBB5
	.uleb128 0xb
	.ascii	"__r\000"
	.byte	0x1
	.byte	0x10
	.4byte	0x48
	.uleb128 0x1
	.byte	0x6f
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	.LBB6
	.4byte	.LBE6-.LBB6
	.uleb128 0xb
	.ascii	"__o\000"
	.byte	0x1
	.byte	0x13
	.4byte	0x8a
	.uleb128 0x1
	.byte	0x6f
	.uleb128 0xa
	.4byte	.LBB7
	.4byte	.LBE7-.LBB7
	.uleb128 0xb
	.ascii	"__r\000"
	.byte	0x1
	.byte	0x13
	.4byte	0x48
	.uleb128 0x1
	.byte	0x6f
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xe
	.4byte	.LASF31
	.byte	0x1
	.byte	0x4
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xb
	.ascii	"j\000"
	.byte	0x1
	.byte	0x5
	.4byte	0x77
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF2:
	.ascii	"short int\000"
.LASF10:
	.ascii	"sizetype\000"
.LASF12:
	.ascii	"mips_icache_size\000"
.LASF13:
	.ascii	"mips_icache_linesize\000"
.LASF30:
	.ascii	"main\000"
.LASF31:
	.ascii	"delay\000"
.LASF23:
	.ascii	"mips_tcache_ways\000"
.LASF6:
	.ascii	"long long int\000"
.LASF17:
	.ascii	"mips_dcache_ways\000"
.LASF21:
	.ascii	"mips_tcache_size\000"
.LASF4:
	.ascii	"long int\000"
.LASF29:
	.ascii	"_mips_general_exception\000"
.LASF20:
	.ascii	"mips_scache_ways\000"
.LASF22:
	.ascii	"mips_tcache_linesize\000"
.LASF24:
	.ascii	"cause\000"
.LASF8:
	.ascii	"long double\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF0:
	.ascii	"signed char\000"
.LASF7:
	.ascii	"long long unsigned int\000"
.LASF28:
	.ascii	"reg32_t\000"
.LASF9:
	.ascii	"unsigned int\000"
.LASF15:
	.ascii	"mips_dcache_size\000"
.LASF3:
	.ascii	"short unsigned int\000"
.LASF25:
	.ascii	"GNU C11 6.3.0 -mel -march=m14kc -msoft-float -mplt -mips"
	.ascii	"32r2 -msynci -mabi=32 -g -O0\000"
.LASF11:
	.ascii	"char\000"
.LASF18:
	.ascii	"mips_scache_size\000"
.LASF19:
	.ascii	"mips_scache_linesize\000"
.LASF26:
	.ascii	"main.c\000"
.LASF5:
	.ascii	"long unsigned int\000"
.LASF16:
	.ascii	"mips_dcache_linesize\000"
.LASF14:
	.ascii	"mips_icache_ways\000"
.LASF27:
	.ascii	"C:\\Users\\qyang\\Code\\mips\\test\\syscall\000"
	.ident	"GCC: (Codescape GNU Tools 2017.10-08 for MIPS MTI Bare Metal) 6.3.0"
