# MIPS 机器代码

## Codescape 环境搭建
1. 首先从 [Codescape](https://codescape.mips.com/) 网站上下载相应操作系统的 MTI Bare Metal Toolchain。
2. 解压文件，然后将路径添加到环境变量中。在 Linux 下，使用 `export MIPS_ELF_ROOT="/opt/mips-mti-elf/2019.09-01"` 添加环境变量。在 Windows 中通过控制面板添加 `MIPS_ELF_ROOT` 及相应路径作为环境变量。
3. 安装 make. Ubuntu 下 `sudo apt install make`。Windows 下可使用 scoop 快速安装 `scoop install make` 或者安装 MinGW 工具链。
4. 添加 libfdc 库。下载 [libfdc.zip](https://github.com/mriosrivas/MIPS_FPGA/blob/master/libfdc.zip) 文件，
   然后解压到 `$MIPS_ELF_ROOT/share/mips/addons/libfdc/` 目录下。

## 从 C 语言代码中生成代码

可能是 Codescape 版本的原因，直接使用老师提供的 Makefile 编译会失败。错误信息：
```
mips-mti-elf-gcc  -EL -march=m14kc -msoft-float -nostartfiles -Wl,-Map=program.map -L"C:\Users\qyang\apps\mips-mti-elf/share/mips/addons/libfdc/" -Wl,--defsym,__stack=0x80040000 -Wl,--defsym,__memory_size=0x1f800 -T uhi32.ld -Wl,--defsym,__flash_start=0xbfc00000 -Wl,--defsym,__flash_app_start=0x80000000 -Wl,--defsym,__app_start=0x80000000 -Wl,--defsym,__isr_vec_count=0 -Wl,-e,0xbfc00000 boot.o exceptions.o dummy.o main.o -lfdc -o program.elf
uhi32.ld:148 cannot move location counter backwards (from 0000000080000320 to 0000000080000200)
collect2.exe: error: ld returned 1 exit status
mingw32-make: *** [Makefile:89: program.elf] Error 1
```
修改 Makefile 中的 `__isr_vec_count`，把 0 变成 10，或者注释相应那一行，可以编译通过。这个的后果是，禁掉 ISR vectors 保留空间的效果没有了。

## 从汇编代码中生成机器代码

需要修改 mips_asm_tempalte/Makefile 中部分内容，才能成功编译。首先需要像修改 C 语言版本那样修改 `__isr_vec_count` 字段。
除此之外，还需要修改部分内容，如下所示（减号表示需要删除的内容，加号是要增加的内容）：
```
- CSOURCES= \
- main.c
-
- COBJECTS = $(CSOURCES:.c=.o)
- CASMS    = $(CSOURCES:.c=.s)
+ CASMS= \
+ main.S
COBJECTS = $(CASMS:.S=.o)
AOBJECTS = $(ASOURCES:.S=.o)
```