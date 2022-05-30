#include "hardware/regs/addressmap.h"
#include "hardware/regs/m0plus.h"

.syntax unified                 @ Specify unified assembly syntax
.cpu    cortex-m0plus           @ Specify CPU type is Cortex M0+
.thumb                          @ Specify thumb assembly for RP2040
.global main_asm                @ Provide program starting address to the linker
.align 4                        @ Specify code alignment

.equ    SLEEP_TIME, 500         @ Specify the sleep time (in ms)
.equ    LED_GPIO_PIN, 25        @ Specify the pin that the LED is connected to
.equ    LED_GPIO_OUT, 1         @ Specify the direction of the GPIO pin
.equ    LED_VALUE_ON, 1         @ Specify the value that turns the LED "on"
.equ    LED_VALUE_OFF, 0        @ Specify the value that turns the LED "off"
.equ    SVC_ISR_OFFSET, 0x2C    @ The SVC is entry 11 in the vector table
.equ    SVC_MAX_INSTRS, 0x01    @ Maximum allowed SVC subroutines

@ Entry point to the ASM portion of the program
main_asm:
    bl      init_gpio_led       @ Initialise the GPIO LED pin
    bl      install_svc_isr     @ Install the SVC interrupt service routine
loop:
    svc     #0                  @ Call the SVC ISR with value 0 (turns on LED)
    nop                         @ Add a no-op instruction for alignment after SVC
    bl      do_sleep            @ Short pause before proceeding
    svc     #1                  @ Call the SVC ISR with value 1 (turns off LED)
    nop                         @ Add a no-op instruction for alignment after SVC
    bl      do_sleep            @ Add a short pause before proceeding
    b       loop                @ Always jump back to the start of the loop

@ Subroutine used to introduce a short delay in the application
do_sleep:                               @ <TODO – add assembly code to implement the sleep delay using sleep_ms>
    push    {lr}
    ldr     r0, =SLEEP_TIME             @ Set the value of SLEEP_TIME we want to wait for
    bl      sleep_ms                    @ Sleep until SLEEP_TIME has elapsed then toggle the LED GPIO pin
    @bl       loop
    pop     {pc}
@ Subroutine used to initialise the PI Pico built-in LED
init_gpio_led:                          @ <TODO – add assembly code to initialise the LED GPIO pin>
    push    {lr}
    movs    r0, #LED_GPIO_PIN           @ This value is the GPIO LED pin on the PI PICO board
    bl      asm_gpio_init               @ Call the subroutine to initialise the GPIO pin specified by r0
    movs    r0, #LED_GPIO_PIN           @ This value is the GPIO LED pin on the PI PICO board
    movs    r1, #LED_GPIO_OUT           @ We want this GPIO pin to be setup as an output pin
    bl      asm_gpio_set_dir            @ Call the subroutine to set the GPIO pin specified by r0 to state specified by r1
    pop     {pc}
@ Subroutine used to install the SVC interrupt service handler
install_svc_isr:    
    ldr     r2, =(PPB_BASE + M0PLUS_VTOR_OFFSET)    @ <Loading the SVR address in the memory>
    ldr     r1, [r2]                                @ <Storing r2 in r1 using load register>
    movs    r2, #SVC_ISR_OFFSET                     @ <Storing the SVR initial offset in r2>
    add     r2, r1                                  @ <Adding the SVR call stack offset to r2>
    ldr     r0, =svc_isr                            @ <Loading register with SVC subroutine address>
    str     r0, [r2]                                @ <Storing r2 in r0>
    bx      lr                                      @ <This statement acts as the return of this subroutine and signifies whether the return is a thumb or ARM instruction>     

@ SVC interrupt service handler routine
.thumb_func                     @ Required for all interrupt service routines
svc_isr:
    push    {lr}                @ <Pushing the calling address onto the call stack.>
    ldr     r0, [sp, #0x1C]     @ <Load r0 with the required stack area for further processing>
    subs    r0, #0x2            @ <Subracting the stored r0 value with hex 2>
    ldr     r0, [r0]            @ <Loading the r0 register with the r0 memory>
    ldr     r1, =#0xFF          @ <Loading r1 with the maximum possible 8 bit hex value>
    ands    r0, r1              @ <Performing the AND operation between r0 and r1>
    cmp     r0, #SVC_MAX_INSTRS @ <Comparing the SVC intruction with he r0 value>
    bgt     svc_done            @ <Go to svc_done branch if r0 is greatet than or equal to #SVC_MAX_INSTRS>
    adr     r1, svc_jmptbl      @ <Rotating the register value r1 by svc_jmptbl>
    lsls    r0, #2              @ <Performing logical shift left on register r0 by 2 bits>
    ldr     r1, [r1, r0]        @ <Loading the r1-r0 segment in r1>
    mov     pc, r1              @ <Storing the next instruction to be executed in pc stored in r1>
svc_done:
    pop     {pc}                @ <Remove the subroutine call from the call stack>

@ First function of SVC subroutine - turn on the LED
svc_num0:                       @ <TODO – add assembly code to turn on the LED>
    movs    r1, #LED_VALUE_ON   @ The LED is currently "off" so we want to turn it "on"
    b       set_state            @ Branch back to the main ISR when done

@ Second function of SVC subroutine - turn off the LED
svc_num1:                       @   <TODO – add assembly code to turn off the LED> 
    movs    r1, #LED_VALUE_OFF  @ The LED is currently "off" so we want to turn it "on"
set_state:
    movs    r0,#LED_GPIO_PIN
    bl      asm_gpio_put    
    b       svc_done            @ Branch back to the main ISR when done

@ SVC function entry jump table.
.align 2
svc_jmptbl:
    .word svc_num0              @ Entry zero goes to SVC function #0.
    .word svc_num1              @ Entry one goes to SVC function #1.
    .word 0                     @ Null termination of the jump table.

@ Set data alignment
.data
    .align 4