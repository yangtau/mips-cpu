// This boot code is derived from https://github.com/sergev/LiteBSD/blob/master/sys/mips/pic32/locore.s

// Place all code in the .reset section
#define _RESETCODE

#include <mips/regdef.h>
#include <mips/asm.h>
#include <mips/m32c0.h>


/*-----------------------------------
 * Reset/NMI exception handler.
 */
	.set push
        .set noreorder                  # Don't allow the assembler to reorder instructions.
        .set noat
	.set nomicromips
LEAF(__reset_vector)

        mtc0    zero, C0_COUNT          # Clear cp0 Count (Used to measure boot time.)

        //
        // Init CP0 Status, Count, Compare, Watch*, and Cause.
        //
init_cp0:
        # Initialize Status
	li	v1, 0x00400004		// (M_StatusERL | M_StatusBEV)
        mtc0    v1, C0_STATUS           # write Status

        # Clear WP bit to avoid watch exception upon user code entry, IV, and software interrupts.
        mtc0    zero, C0_CAUSE          # clear Cause: init AFTER init of WatchHi/Lo registers.

        # Clear timer interrupt. (Count was cleared at the reset vector to allow timing boot.)
        mtc0    zero, C0_COMPARE        # clear Compare

        # Prepare for eret to _start.

        la      ra, all_done        # If main returns then go to all_done:.
        move    a0, zero            # Indicate that there are no arguments available.

        la      v0, _start          # load the address of the CRT entry point _start.
        mtc0    v0, $30             # Write ErrorEPC with the address of main
        ehb                         # clear hazards (makes sure write to ErrorPC has completed)

        # Return from exception will now execute code at _start

        eret                        # Exit reset exception handler and start execution of _start.


/**************************************************************************************/
all_done:
        # If main returns it will return to this point.  Just spin here.
        b       all_done
        nop
END(__reset_vector)
