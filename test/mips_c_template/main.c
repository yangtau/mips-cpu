#include "mfp_io.h"

void delay();

//------------------
// main()
//------------------
int main() {

  return 0;
}

void delay() {
  volatile unsigned int j;

  for (j = 0; j < (900000); j++) ;	// delay 
}


