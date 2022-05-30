#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "pico/stdlib.h"
#include "pico/float.h"     // Required for using single-precision variables.
#include "pico/double.h"    // Required for using double-precision variables.
#include "pico/multicore.h" // Required for using multiple cores on the RP2040. // Needs to be specified in the CMake File,else doesn't import or recognize

/**
 * @brief This function acts as the main entry-point for core #1.
 *        A function pointer is passed in via the FIFO with one
 *        incoming int32_t used as a parameter. The function will
 *        provide an int32_t return value by pushing it back on
 *        the FIFO, which also indicates that the result is ready.
 */
void core1_entry()
{
    while (1)
    {
        //
        int32_t (*func)() = (int32_t(*)())multicore_fifo_pop_blocking();
        int32_t p = multicore_fifo_pop_blocking();
        int32_t result = (*func)(p);
        multicore_fifo_push_blocking(result);
    }
}

/**
 * @brief Pi calculator using wallis algorithm which gives a higher precision
 *
 * @return double - Value of wallis algorithm.
 */

double pi_calculator_double_precision(int NUM_ITERATIONS)
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

float pi_calculator_single_precision(int NUM_ITERATIONS)
{
    float pi = 1.0;
    for (int i = 1; i <= NUM_ITERATIONS; i++)
    {
        pi *= (float)((((float)(2 * i) / (2 * i - 1))) * ((float)(2 * i) / (2 * i + 1)));
    }
    return 2 * pi;
}

/**
 * @brief Pi calculator using wallis algorithm which gives lower precision
 *
 * @return double - Value of wallis algorithm.
 */
int main()
{

    const int ITER_MAX = 100000;
    stdio_init_all();
    multicore_launch_core1(core1_entry);

    //      Code for sequential run goes here…
    //      Take snapshot of timer and store
    int start_time_sequential = time_us_32(); // Getting the starting time of sequential code

    //      Run the single-precision Wallis approximation
    int start_time_sequential_single_precision = time_us_32();
    pi_calculator_single_precision(ITER_MAX);
    int end_time_sequential_single_precision = time_us_32();
    //      Run the double-precision Wallis approximation
    int start_time_sequential_double_precision = time_us_32();
    pi_calculator_double_precision(ITER_MAX);
    int end_time_sequential_double_precision = time_us_32();
    //      Take snapshot of timer and store

    int end_time_sequential = time_us_32(); // Getting the ending time of sequential code
    //      Display time taken for application to run in sequential mode
    printf("Time taken to run single precision sequentially: %lld\n", end_time_sequential_single_precision - start_time_sequential_single_precision);
    printf("Time taken to run double precision sequentially: %lld\n", end_time_sequential_double_precision - start_time_sequential_double_precision);
    printf("Time taken to run sequentially: %lld\n", end_time_sequential - start_time_sequential);

    //      Code for parallel run goes here…
    //      Take snapshot of timer and store
    int start_time_parallel_double_precision = time_us_32();
    multicore_fifo_push_blocking((uintptr_t)&pi_calculator_double_precision);
    multicore_fifo_push_blocking(ITER_MAX);

    int start_time_parallel = time_us_32(); // getting start parallel time

    int start_time_parallel_single_precision = time_us_32();
    float single_precision_result = pi_calculator_single_precision(ITER_MAX);
    int end_time_parallel_single_precision = time_us_32();

    int32_t double_precision_result = multicore_fifo_pop_blocking();

    int end_time_parallel_double_precision = time_us_32();

    int end_time_parallel = time_us_32(); // Getting end parallel time
    printf("Time taken to run single precision in parallel is: %lld\n", end_time_parallel_single_precision - start_time_parallel_single_precision);
    printf("Time taken to run double precision in parallel is: %lld\n", end_time_parallel_double_precision - start_time_parallel_double_precision);
    printf("Time taken to run both in parallel is: %lld\n", end_time_parallel - start_time_parallel);
    //      Display time taken for application to run in parallel mode

    printf("\n");

    return 0;
}