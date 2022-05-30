//#define WOKWI             // Uncomment if running on Wokwi RP2040 emulator.

#include <stdio.h>
#include <stdlib.h>
#include "pico/float.h"
#include "pico/double.h"
// #include "pico/stdlib.h"

/**
 * @brief Given pi constant to be used for error calculation.
 */

#define my_pi 3.14159265359

/**
 * @brief Given number of iterations that the loop needs to be run for for given precision.
 */
#define NUM_ITERATIONS 100000

/**
 * @brief Error calculation function - calculates the percentage(%) error for the calculated value of pi
 *
 * @return double - Value of error of pi.
 */
double calculate_error(double value)
{
    double error = (double)((((double)my_pi - (value)) / my_pi) * 100);
    return error;
}
/**
 * @brief Pi calculator using wallis algorithm which gives a higher precision
 *
 * @return double - Value of wallis algorithm.
 */
double pi_calculator_double_precision()
{
    double pi = 1.0;
    for (int i = 1; i <= NUM_ITERATIONS; i++)
    {
        pi *= (double)((((double)(2 * i) / (2 * i - 1))) * ((double)(2 * i) / (2 * i + 1)));
    }
    return 2 * pi;
}

/**
 * @brief Pi calculator using wallis algorithm which gives lower precision
 *
 * @return double - Value of wallis algorithm.
 */

float pi_calculator_single_precision()
{
    float pi = 1.0;
    for (int i = 1; i <= NUM_ITERATIONS; i++)
    {
        pi *= (float)((((float)(2 * i) / (2 * i - 1))) * ((float)(2 * i) / (2 * i + 1)));
    }
    return 2 * pi;
}

/**
 * @brief Main function - Runs the program and calls the helping functions
 *
 * @return int - 0 if the program runs succesfully.
 */
int main()
{

#ifndef WOKWI
    // Initialise the IO as we will be using the UART
    // Only required for hardware and not needed for Wokwi
    // stdio_init_all();
#endif

    // Print a console message to inform user what's going on.
    printf("Output (Abhinav Sinha [21355085]):\n");
    printf("Single Precision: %.11lf\n", pi_calculator_single_precision());
    printf("Approx Error: %lf%c\n", calculate_error(pi_calculator_single_precision()), 0x25);
    printf("Double Precision: %.11lf\n", pi_calculator_double_precision());
    printf("Approx Error: %lf%c\n", calculate_error(pi_calculator_double_precision()), 0x25);

    // Returning zero indicates everything went okay.
    return 0;
}
