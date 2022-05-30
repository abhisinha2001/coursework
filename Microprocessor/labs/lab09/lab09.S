#include "hardware/regs/addressmap.h"
#include "hardware/regs/io_bank0.h"
#include "hardware/regs/timer.h"
#include "hardware/regs/m0plus.h"
#include "hardware/regs/adc.h"

.syntax unified                     @ Specify unified assembly syntax
.cpu    cortex-m0plus               @ Specify CPU type is Cortex M0+
.thumb                              @ Specify thumb assembly for RP2040
.global main_asm                    @ Provide program starting address to the linker
.align 4                            @ Specify code alignment

.equ    DFLT_STATE_STRT,1           @ Default States for the timer
.equ    DFLT_STATE_STOP,0   

.equ    ACD_RESULT,0x04             @ Result offset for the ADC_base

.equ    DFLT_ALARM_TIME, 1000000    @ Default alarm time for the timer
.equ    ALRM_ISR_OFFSET, 0x40       @ Alarm ISR offset

.equ    LED_VAL_ON,1                @ LED value for ON
.equ    LED_VAL_OFF,0               @ LED value for OFF


@ Entry point to the ASM portion of the program
main_asm:
    bl install_alrm_isr             @ branch to Install the alarm ISR
    loop:                           @ Loop forever
        bl set_alarm                @ Set the alarm
        wfi                         @ Wait for interrupt
        b  loop                     @ Loop forever

@ Setting the alarm used in previous assignment
set_alarm:
    push    {lr}                    @ Pushing the Link Register for going back to the main program
    ldr     r2, =(TIMER_BASE + TIMER_INTE_OFFSET)   @ Load the interrupt enable register
    movs    r0, #DFLT_STATE_STRT    @ Load the state to start the timer
    str     r0, [r2]                @ Store the state to the register
    ldr     r2, =(TIMER_BASE + TIMER_TIMELR_OFFSET)  @ Load the time register
    ldr     r1, [r2]               @ Load the time register
    ldr      r5, =DFLT_ALARM_TIME   @ Load the default alarm time
    add     r1, r5                  @ Add the default alarm time to the time register
    ldr     r2, =(TIMER_BASE + TIMER_ALARM0_OFFSET) @ Load the alarm register
    str     r1, [r2]                @ Store the alarm time to the register
    pop      {pc}                   @ Return to the main program

@ Used from the given sample assignment solutions
install_alrm_isr:
    push    {r2, lr}                @ Pushing the Link Register for going back to the main program
    ldr     r2, =(PPB_BASE + M0PLUS_VTOR_OFFSET)    @ Load the VTOR register
    ldr     r1, [r2]                @ Load the VTOR register
    movs    r2, #ALRM_ISR_OFFSET    @ Load the offset of the alarm ISR
    add     r2, r1                  @ Add the offset to the VTOR register
    ldr     r0, =alrm_isr           @ Load the address of the alarm ISR
    str     r0, [r2]                @ Store the address of the alarm ISR
    movs    r1, #1                  @ Load the interrupt enable bit
    lsls    r1, #0                  @ Shift the bit to the correct position
    ldr     r2, =(PPB_BASE + M0PLUS_NVIC_ICPR_OFFSET)   @ Load the ICPR register
    str     r1, [r2]                @ Store the interrupt enable bit to the register
    ldr     r2, =(PPB_BASE + M0PLUS_NVIC_ISER_OFFSET)       @ Load the ISER register
    str     r1, [r2]                @ Store the interrupt enable bit to the register
    pop     {r2, pc}                @ Return to the main program

.thumb_func
    alrm_isr:
        push    {lr}                @ Pushing the Link Register for going back to the main program
        bl      get_adc             @ Call the get_adc function
        ldr     r2, =(TIMER_BASE + TIMER_INTR_OFFSET)   @ Load the interrupt register
        movs    r0, #DFLT_STATE_STRT    @ Load the state to start the timer
        str     r0, [r2]            @ Store the state to the register
        pop     {pc}                @ Return to the main program
    get_adc:
        push    {lr}                @ Pushing the Link Register for going back to the main program

        ldr     r3, =ADC_BASE       @ Load the base address of the ADC
        ldr     r2, [r3]                         
        ldr     r3,=(ADC_BASE+ACD_RESULT)   @ Load the result register
        ldr     r0, [r3]            @ Load the result register
        bl      read_adc            @ Call the read_adc function

        pop     {pc}    @ Return to the main program
@ Set data alignment
.data
    .align 4

