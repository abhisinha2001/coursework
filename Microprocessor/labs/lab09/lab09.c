#include <stdio.h>
#include <stdlib.h>

#include "pico/stdlib.h"
#include "hardware/pio.h"
#include "hardware/clocks.h"
#include "lab09.pio.h"

#define IS_RGBW true  // Will use RGBW format
#define NUM_PIXELS 1  // There is 1 WS2812 device in the chain
#define WS2812_PIN 28 // The GPIO pin that the WS2812 connected to

static inline void put_pixel(uint32_t pixel_grb)
{
    pio_sm_put_blocking(pio0, 0, pixel_grb << 8u);
}

static inline uint32_t urgb_u32(uint8_t r, uint8_t g, uint8_t b)
{
    return ((uint32_t)(r) << 8) |
           ((uint32_t)(g) << 16) |
           (uint32_t)(b);
}

void read_adc(uint adc_result)
{
    uint16_t raw = adc_result;
    const float conversion_factor = 3.3f / (1 << 12);
    float result = raw * conversion_factor;
    float temp = 27 - (result - 0.706) / 0.001721;
    printf("Temperature is %f\n", temp);
    if (result > 600)
    {
        put_pixel(urgb_u32(0x3F, 0x00, 0x00));
    }
    else if (result > 421 && result < 599)
    {
        put_pixel(urgb_u32(0x3F, 0x00, 0x00));
    }
    else
    {
        put_pixel(urgb_u32(0x3F, 0x00, 0x00));
    }
}
void main_asm();

/**
 * @brief LAB #09 - TEMPLATE
 *        Main entry point for the code - calls the main assembly
 *        function where the body of the code is implemented.
 *
 * @return int      Returns exit-status zero on completion.
 */
int main()
{
    stdio_init_all();
    adc_init();
    PIO pio = pio0;
    uint offset = pio_add_program(pio, &lab09_program);
    lab09_program_init(pio, 0, offset, WS2812_PIN, 800000, IS_RGBW);
    // Initialise the PIO interface with the WS2812 code
    main_asm();
    // Returning zero indicates everything went okay.
    return 0;
}
