#include "hardware/regs/addressmap.h"
#include "hardware/regs/io_bank0.h"
#include "hardware/regs/timer.h"
#include "hardware/regs/m0plus.h"

@ Link to Demonstration Video - https://drive.google.com/file/d/1H_vI_sPpqe9t4PdOsQUpEMncsWnSYzHJ/view?usp=sharing

.syntax unified
.cpu    cortex-m0plus
.thumb
.global main_asm
.align  4
.extern printf

.equ    DFLT_STATE_STRT, 1            @ Specify the value to start flashing
.equ    DFLT_STATE_STOP, 0            @ Specify the value to stop flashing
.equ    DFLT_ALARM_TIME, 1000000      @ Specify the default alarm timeout

.equ    GPIO_BTN_DN_MSK, 0x00040000   @ Bit-18 for falling-edge event on GP20
.equ    GPIO_BTN_EN_MSK, 0x00400000   @ Bit-22 for falling-edge event on GP21
.equ    GPIO_BTN_UP_MSK, 0x04000000   @ Bit-26 for falling-edge event on GP22

.equ    GPIO_BTN_DN,  20              @ Specify pin for the "down" button
.equ    GPIO_BTN_EN,  21              @ Specify pin for the "enter" button
.equ    GPIO_BTN_UP,  22              @ Specify pin for the "up" button
.equ    GPIO_LED_PIN, 25              @ Specify pin for the built-in LED
.equ    GPIO_DIR_IN,   0              @ Specify input direction for a GPIO pin
.equ    GPIO_DIR_OUT,  1              @ Specify output direction for a GPIO pin

.equ    LED_VAL_ON,    1              @ Specify value that turns the LED "on"
.equ    LED_VAL_OFF,   0              @ Specify value that turns the LED "off"

.equ    GPIO_ISR_OFFSET, 0x74         @ GPIO is int #13 (vector table entry 29)
.equ    ALRM_ISR_OFFSET, 0x40         @ ALARM0 is int #0 (vector table entry 16)

main_asm:
    bl      init_leds                 @ Same as previous labs
    bl      init_btns                 @ Use asm_gpio_set_irq C function to setup falling-edge interrutps
    bl      install_alrm_isr          @ See below
    bl      install_gpio_isr          @ See below
loop:
    bl      set_alarm                 @ Set a new alarm
    wfi                               @ Wait here until any interrupt fires
    b       loop                      @ Always branch back to loop


init_leds:
    push    {lr}                      @ Pushing the link register onto the stack so as to go back to calling sub routine

    movs    r0, #GPIO_LED_PIN         @ Assigning r0 to the GPIO LED pin which needs to be initialized
    bl      asm_gpio_init             @ Calling GPIO initialising sub-routine
    movs    r0, #GPIO_LED_PIN         @ Assigning r0 to the GPIO LED pin to set the Input/Output Mode
    movs    r1, #GPIO_DIR_OUT         @ Passing Input/Output r1 parameter to sub routine
    bl      asm_gpio_set_dir          @ Calling the setting GPIO pin as Input/output sub-routine to set our pin as output 

    pop     {pc}                      @ Exiting the sub-routine by popping the stack
    
init_btns:
    push    {lr}                      @ Pushing the link register onto the stack so as to go back to calling sub routine
                                        
    movs    r0, #GPIO_BTN_EN          @ Assigning r0 to the GPIO BTN pin which needs to be initialized
    bl      asm_gpio_init             @ Calling GPIO initialising sub-routine
    movs    r0, #GPIO_BTN_EN          @ Assigning r0 to the GPIO BTN pin to set the Input Mode
    movs    r1, #GPIO_DIR_IN          @ Passing Input r1 parameter to sub routine
    bl      asm_gpio_set_dir          @ Calling the setting GPIO pin as Input/output sub-routine to set our pin as input
    movs    r0, #GPIO_BTN_EN          @ Assigning r0 to the GPIO BTN pin which needs to be initialized
    bl      asm_gpio_set_irq          @ Calling the irq sub-routine to set the falling edge interrupt

    movs    r0, #GPIO_BTN_DN          @ Assigning r0 to the GPIO BTN pin which needs to be initialized
    bl      asm_gpio_init             @ Calling GPIO initialising sub-routine
    movs    r0, #GPIO_BTN_DN          @ Assigning r0 to the GPIO BTN pin to set the Input Mode
    movs    r1, #GPIO_DIR_IN          @ Passing Input r1 parameter to sub routine
    bl      asm_gpio_set_dir          @ Calling the setting GPIO pin as Input/output sub-routine to set our pin as input
    movs    r0, #GPIO_BTN_DN          @ Assigning r0 to the GPIO BTN pin which needs to be initialized
    bl      asm_gpio_set_irq          @ Calling the irq sub-routine to set the falling edge interrupt

    movs    r0, #GPIO_BTN_UP          @ Assigning r0 to the GPIO BTN pin which needs to be initialized
    bl      asm_gpio_init             @ Calling GPIO initialising sub-routine
    movs    r0, #GPIO_BTN_UP          @ Assigning r0 to the GPIO BTN pin to set the Input Mode
    movs    r1, #GPIO_DIR_IN          @ Passing Input r1 parameter to sub routine
    bl      asm_gpio_set_dir          @ Calling the setting GPIO pin as Input/output sub-routine to set our pin as input
    movs    r0, #GPIO_BTN_UP          @ Assigning r0 to the GPIO BTN pin which needs to be initialized
    bl      asm_gpio_set_irq          @ Calling the irq sub-routine to set the falling edge interrupt
    
    pop     {pc}                      @ Exiting the sub-routine by popping the stack



@ Enable alarm timer interrupts and set an alarm

set_alarm:                                              @ Following the steps based on the given hint
    ldr     r2, =(TIMER_BASE + TIMER_INTE_OFFSET)       @ Enable alarm timer interrupts using the (TIMER_BASE + TIMER_INTE_OFFSET) register
    ldr     r3, =1
    str     r3, [r2]

    ldr     r2, =(TIMER_BASE + TIMER_TIMELR_OFFSET)     @ Get the current timer count from (TIMER_BASE + TIMER_TIMELR_OFFSET) register
    ldr     r1, [r2]
    ldr     r3, =ltimer
    ldr     r3, [r3]
    adds    r1, r3                                      @ Add the time delay you want to wait for to the current timer count
    ldr     r2, =(TIMER_BASE + TIMER_ALARM0_OFFSET)
    str     r1, [r2]                                    @ Push the updated value to (TIMER_BASE + TIMER_ALARM0_OFFSET)

    bx      lr                                          @ Exit subroutine

@ Sets up the alrm_isr in the RAM vector table and enables the correct interrupt
install_alrm_isr:
    ldr     r2, =(PPB_BASE + M0PLUS_VTOR_OFFSET)        @ Get the address of the RAM vector table using the (PPB_BASE + M0PLUS_VTOR_OFFSET) register
    ldr     r1, [r2]
    movs    r2, #ALRM_ISR_OFFSET                        @ Store the address of the alrm_isr handler to the correct offset for ALARM0 in the vector table
    add     r2, r1                                      @ Adding the required offset 
    ldr     r0, =alrm_isr                               @ Loading the alrm_isr subtroutine to r0
    str     r0, [r2]                                    @ Storing the loaded subroutine to the loaded vector table space
    movs    r3, #1                                      @ Register for setting enable/disable
    ldr     r2, =(PPB_BASE + M0PLUS_NVIC_ICPR_OFFSET)   @ Disable the ALARM0 IRQ by writing the correct value to (PPB_BASE + M0PLUS_NVIC_ICPR_OFFSET)
    str     r3, [r2]
    ldr     r2, =(PPB_BASE + M0PLUS_NVIC_ISER_OFFSET)   @ Enable the ALARM0 IRQ by writing the correct value to (PPB_BASE + M0PLUS_NVIC_ISER_OFFSET)
    str     r3, [r2]

    bx      lr                                          @ Exit subroutine

@ // Service the pending interrupt from the ALARM0 TIMER
.thumb_func                                         @ Required for interrupt service routines
alrm_isr:                                           @ Perform required functionality (e.g. toggle the LED)
    push    {lr}                                    @ Pushing the link register onto the stack 

    @ Disable pending interrupt from TIMER by writing correct value to (TIMER_BASE + TIMER_INTR_OFFSET)  
                        
    ldr     r2, =(TIMER_BASE + TIMER_INTR_OFFSET)   @ loading the Timer base with correct offset                                       
    movs    r1, #1                                  @ Assigning an intiial value to register
    str     r1, [r2]                                @ Disabling by setting/writing to r2

    ldr     r1, =lstate                             @ Loading default state onto r1
    ldr     r1, [r1]                                @ Loading the register with r1
    cmp     r1, #DFLT_STATE_STOP                    @ Comparing with the STOP_STATE
    beq     end_alarm                               @ If found equal then branch to end alarm branch which exits the sub-routine
    bl      toggle                                  @ Else branch off to toggle LED branch

end_alarm:
    pop     {pc}                                    @ Exit ISR

toggle:
    push    {lr}                                    @ Pushing Link register onto stack

    ldr     r2, =(TIMER_BASE+TIMER_INTR_OFFSET)     @ Loading/Reading the Timer base with raw offset
    movs    r1, #1                                  @ Loading r1 with 1
    str     r1, [r2]                                @ Storing r2 register which was previosly read onto r1
    
    ldr     r0, =GPIO_LED_PIN                       @ Loading the r0 register with LED GPIO pin
    bl      asm_gpio_get                            @ Getting the current state of LED pin
    cmp     r0, #LED_VAL_OFF                        @ Comparing the off state of LED
    beq     led_set_on                              @ If true then switch switch on LED- branch
led_set_off:
    ldr     r1, =LED_VAL_OFF                        @ Else LED is on and needs to be set to off
    b       led_set_state                           @ Branch to setting LED State
led_set_on:
    ldr     r1, =LED_VAL_ON                         @ Setting LED ON
led_set_state:
    ldr     r0, =GPIO_LED_PIN                       @ Loading the GPIO pin onto register r0
    bl      asm_gpio_put                            @ Setting the value of LED with r1 as paramater
    pop     {pc}                                    @ Exiting sub-routine

@ // Sets up the gpio_isr in the RAM vector table and enables the correct interrupt
install_gpio_isr:
    ldr     r2, =(PPB_BASE + M0PLUS_VTOR_OFFSET)        @ Get the address of the RAM vector table using the (PPB_BASE + M0PLUS_VTOR_OFFSET) register
    ldr     r1, [r2]
    movs    r2, #GPIO_ISR_OFFSET                        @ Store the address of the gpio_isr handler to the correct offset for GPIO in the vector table
    adds    r2, r1
    ldr     r0, =gpio_isr
    str     r0, [r2]
    ldr     r3, =1                                      @ Setting r3 with 1 in order to disable the GPIO IRQ
    lsls    r3, #13                                     @ Performing Logical shifting by 13 bits to set required bit to 1 for disabling GPIO IRQ
    ldr     r2, =(PPB_BASE + M0PLUS_NVIC_ICPR_OFFSET)   @ Disable the GPIO IRQ by writing the correct value to (PPB_BASE + M0PLUS_NVIC_ICPR_OFFSET)
    str     r3, [r2]
    ldr     r2, =(PPB_BASE + M0PLUS_NVIC_ISER_OFFSET)   @ Enable the GPIO IRQ by writing the correct value to (PPB_BASE + M0PLUS_NVIC_ISER_OFFSET)
    str     r3, [r2]

    bx      lr                                          @ Exit subroutine

@ Service the pending interrupt from the GPIO

.thumb_func                                                     @ Required for all interrupt service routines
gpio_isr:
    push    {lr}                                                @ Pushing Link Register Onto the stack
    ldr     r2, =(IO_BANK0_BASE + IO_BANK0_PROC0_INTS2_OFFSET)  @ Read the interrupt status event from the (IO_BANK0_BASE + IO_BANK0_PROC0_INTS2_OFFSET) register
    ldr     r2, [r2]

    ldr     r5, =GPIO_BTN_DN_MSK    @ Storing the button masks in local registers {r4 onwards are used for local subroutine storage as per ARM}
    ldr     r6, =GPIO_BTN_EN_MSK    @ Storing the button masks in local registers {r4 onwards are used for local subroutine storage as per ARM}
    ldr     r7, =GPIO_BTN_UP_MSK    @ Storing the button masks in local registers {r4 onwards are used for local subroutine storage as per ARM}

    @ Detect which button was pressed by comparing to GPIO_BTN_DN_MSK, GPIO_BTN_EN_MSK and GPIO_BTN_UP_MSK

    movs    r1, r2                                          @ Storing the interrupt status onto r1
    cmp     r1, r5                                          @ Comparing the read interrupt to Down BTN mask
    bne     check_mul_2                                     @ If not equal branch to check if GPIO 22 has been pressed for increasing delay
    ldr     r3, =lstate                                     @ Load the default timer state
    ldr     r0, [r3]                                        @ Store in r0
    cmp     r0, #DFLT_STATE_STRT                            @ Compare the loaded state to Default Start State
    beq     delay_div_2                                     @ If equal,branch-off to dividing the delay
    ldr     r2, =(IO_BANK0_BASE + IO_BANK0_INTR2_OFFSET)    @ The GPIO raw interrupt
    str     r5, [r2]

    ldr     r0,=gpio20_msg                                  @ If code reached this point, it implies that GPIO 20 has been pressed
    bl      printf                                          @ Printing optional message to console
    
    b       delay_reset                                     @ Branch to reset the delay if the current state is not same as default start state
delay_div_2:
    ldr     r3, =ltimer                                     @ Load the current timer state
    ldr     r0, [r3]
    lsrs    r0, r0, #1                                      @ Performing Logical Shift Right is the same is dividing by 2
    str     r0, [r3]                                        @ Updating the r3 value to hold the new delay
    ldr     r2, =(IO_BANK0_BASE + IO_BANK0_INTR2_OFFSET)    @ Reading the raw interrupt
    str     r5, [r2]                                        @ Updating the value of the GPIO componnent

    ldr     r0,=gpio20_msg_delay_div_2                      @ Printing optional console message for GPIO20 button event causing the decrease in delay
    bl      printf

    b       finish

check_mul_2:                                                @ Branch to check if the GPIO 22 has been pressed
    movs    r1, r2
    cmp     r1, r7                                          @ Comparing with BTN_UP mask
    bne     toggle_check                                    @ If not equal branch off to toggle_check
    ldr     r3, =lstate                                     @ Else store the Default start start
    ldr     r0, [r3]
    cmp     r0, #DFLT_STATE_STRT                            @ Comparing the current state to start state
    beq     delay_mul_2                                     @ If equal then branch to multiply the delay time by 2
    ldr     r2, =(IO_BANK0_BASE + IO_BANK0_INTR2_OFFSET)    @ Read the GPIO raw interrupt
    str     r7, [r2]

    ldr     r0,=gpio22_msg                                  @ Printing optional button event to console
    bl      printf

    b       delay_reset                                     @ If not default start state then branch to reset the delay time i.e. if LED is off then reset delay
delay_mul_2:
    ldr     r3, =ltimer                                     @ Load the current delay time
    ldr     r0, [r3]                                        @ Load the register r0 with delay time
    lsls    r0, r0, #1                                      @ Logically shifting right has the same effect as multipyling by 2
    str     r0, [r3]                                        @ Storing the new delay time
    ldr     r2, =(IO_BANK0_BASE + IO_BANK0_INTR2_OFFSET)    @ Reading the raw GPIO interrupt
    str     r7, [r2]                                        @ Updating with GPIO btn mask
    ldr     r0,=gpio22_msg_delay_mul_2                      @ Optional message printing to console.
    bl      printf                                          @ Branch to print

    b       finish                                          @ Branch to exit subroutine

toggle_check:
    movs    r1, r2
    cmp     r1, r6                  @ Comparing the state to button mask for EN btn
    bne     finish                  @ Branch to finish if not equal
    ldr     r4, =lstate             @ Else load r0 with [r4]
    ldr     r0, [r4]
    cmp     r0, #DFLT_STATE_STRT    @Comparing r0 with default start state.
    beq     gpio_off                @ If equal then branch to setting LED OFF
gpio_on:
    movs    r1, #LED_VAL_ON         @ Else set the LED value to ON
    str     r1, [r4]

    ldr     r0,=gpio21_msg_on       @Printing optional message caused by GPIO 21 btn event
    bl      printf
                            
    b       disable_interrupt       @ Default to disabling interrupt for GPIO
gpio_off:                   
    movs    r1, #LED_VAL_OFF
    str     r1, [r4]
    ldr     r0,=gpio21_msg_off      @ Printing console message caused by GPIO 21 btn-en
    bl      printf
disable_interrupt:
    ldr     r2, =(IO_BANK0_BASE + IO_BANK0_INTR2_OFFSET) @ Disable the pending interrupt from GPIO by writing the correct value to (IO_BANK0_BASE + IO_BANK0_INTR2_OFFSET)
    str     r6, [r2]
    b       finish

delay_reset:
    ldr r1, =ltimer                 @ Load the current delay time to r1
    ldr r2, =DFLT_ALARM_TIME        @ Set the default delay time to r2
    str r2, [r1]                    @ Store the default time to r1
    
finish:
    pop     {pc}                    @ Exit ISR

.align 4
@ Message declarations for optional console messages.
msg:
    .asciz "Hello World!\n"
gpio20_msg:
    .asciz "GPIO 20 was pressed"
gpio20_msg_delay_div_2:
    .asciz "GPIO 20 caused delay by 2"
gpio22_msg:
    .asciz "GPIO 22 was pressed"
gpio22_msg_delay_mul_2:
    .asciz "GPIO 22 caused delay to double"
gpio21_msg_on:
    .asciz "GPIO 21 was pressed causing LED on"
gpio21_msg_off:
    .asciz "GPIO 21 was pressed causing LED off"

.data
lstate: .word   DFLT_STATE_STRT
ltimer: .word   DFLT_ALARM_TIME
