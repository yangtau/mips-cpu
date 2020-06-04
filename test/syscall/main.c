#include "mfp_io.h"
#include <mips/cpu.h>

void delay() {
  volatile unsigned int j;

  for (j = 0; j < (900000); j++)
    ; // delay
}

volatile int n;
int main() {
  // set up interrupts
  // clear boot interrupt vector bit in cop0 status reg
  mips32_bicsr(SR_BEV);
  mips32_bicsr(SR_ERL);
  // set master interrupt enable bit and individual interrupt
  // enable bits in cop0 status reg
  mips32_bissr(SR_IE | SR_SINT1 | SR_HINT0 | SR_HINT1 | SR_HINT2);
  while (1) {
    n = 0xa3a3;
    asm("syscall");
  }
  return 0;
}

void __attribute__((interrupt, keep_interrupts_masked))
_mips_general_exception() {
  unsigned cause = mips32_getcr();
  if (cause & CR_SINT0) {
    // syscall
    MFP_LEDS = n;
    MFP_7SEGDIGITS = n;
  }
  if (cause & CR_HINT0) {
    MFP_LEDS = 2;
    MFP_7SEGDIGITS = 2;
  }
  if (cause & CR_HINT1) {
    MFP_LEDS = 3;
    MFP_7SEGDIGITS = 3;
  }
  if (cause & CR_HINT2) {
    MFP_LEDS = 4;
    MFP_7SEGDIGITS = 4;
  }
}

