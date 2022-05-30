#include "pico/stdlib.h"

/**
 * @brief The code has been taken from the given example BLINK_C
 *        EXAMPLE - BLINK_C
 *        Simple example to initialise the built-in LED on
 *        the Raspberry Pi Pico and then flash it forever.
 *
 * @return int  Application return code (zero for success).
 */

// subroutine / function which accepts the required parameters (led_pin,led_delay) and performs the LED switching operation
void subroutine(uint led_pin, uint led_delay)
{
    while (true)
    {
        gpio_put(led_pin, 1);
        sleep_ms(led_delay);

        // Toggle the LED off and then sleep for delay period
        gpio_put(led_pin, 0);
        sleep_ms(led_delay);
        // subroutine(led_pin, led_delay);
    }
}

// Main function to call and perform the initialization of LED_PIN and LED_DELAY
int main()
{

    // Specify the PIN number and sleep delay
    const uint LED_PIN = 25;
    const uint LED_DELAY = 500;

    // Setup the LED pin as an output.
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);

    // Do forever...
    subroutine(LED_PIN, LED_DELAY);
    // Should never get here due to infinite while-loop.
    return 0;
}