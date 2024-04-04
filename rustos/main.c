// ########################################################################
// # << NEORV32 - "Example Registers" Demo Program >>                     #
// ########################################################################


/**********************************************************************//**
 * @file examp_regs/main.c
 * @author David Gussler
 * @brief Custom AXI registers demo program.
 **************************************************************************/

#include <neorv32.h>
#include <stdint.h>
#include "examp_regs.h"

#define EXAMP_REGS_BASE_ADDR 0xF0000000
#define EXAMP_REGS ((examp_regs_t*) (EXAMP_REGS_BASE_ADDR))



/**********************************************************************//**
 * @name User configuration
 **************************************************************************/
/**@{*/
/** UART BAUD rate */
#define BAUD_RATE 19200
/**@}*/



/**********************************************************************//**
 * Main function; prints some fancy stuff via UART.
 *
 * @note This program requires the UART interface to be synthesized.
 *
 * @return 0 if execution was successful
 **************************************************************************/
int main() {

  // capture all exceptions and give debug info via UART
  // this is not required, but keeps us safe
  neorv32_rte_setup();

  // setup UART at default baud rate, no interrupts
  neorv32_uart0_setup(BAUD_RATE, 0);

  // print project logo via UART
  neorv32_rte_print_logo();

  // say hello
  neorv32_uart0_puts("Hello world!\n");

  // print the git hash
  neorv32_uart0_printf("Git Hash: 0x%X\n", EXAMP_REGS->common.git);

  // print the scratchpad register
  neorv32_uart0_printf("Scratchpad Reg: 0x%X\n", EXAMP_REGS->common.scratchpad);

  // Modify the scratchapd
  EXAMP_REGS->common.scratchpad = 0x11223344;

  // print the scratchpad register again
  neorv32_uart0_printf("Modified scratchpad Reg: 0x%X\n", EXAMP_REGS->common.scratchpad);

  // print the control register
  neorv32_uart0_printf("Control Reg : 0x%X\n", EXAMP_REGS->control);


  return 0;
}
