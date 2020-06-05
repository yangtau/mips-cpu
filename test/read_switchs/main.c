#include "mfp_io.h"

void delay();

//------------------
// main()
//------------------
int main() {
  volatile unsigned int switches;

  while (1) {
    switches = MFP_SWITCHES;

    MFP_7SEGEN = 0x3f; // turnon all 7-segment displays

    MFP_LEDS = switches; // turnon LEDS
    MFP_7SEGDIGITS = switches;

    delay();
    MFP_7SEGEN = 0x0; // turn off all 7-segment displays
    MFP_LEDS = 0;      // turn off LEDs
    delay();
  }
  return 0;
}

void delay() {
  volatile unsigned int j;

  for (j = 0; j < (900000); j++)
    ; // delay
}
