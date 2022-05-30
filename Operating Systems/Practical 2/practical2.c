#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include "cond.c"

int pnum; // number updated when producer runs.
int csum; // sum computed using pnum when consumer runs.

// Mutex Variable to protect the shared resource
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

// Condition Variables for the producer and the consumer to signal each other when ready to use.
pthread_cond_t producer_condition = PTHREAD_COND_INITIALIZER;
pthread_cond_t consumer_condition = PTHREAD_COND_INITIALIZER;

// Given C variable in the slides to operate the condition variables
int C = 0;

int (*pred)(int); // predicate indicating if pnum is to be consumed

int produceT()
{
  scanf("%d", &pnum); // read a number from stdin
  return pnum;
}
// Producer is the creator or S (which corresponds to the nomenclature mentioned in the slides)
void *Produce(void *a)
{
  int p;

  p = 1;
  while (p)
  {
    printf("@P-READY\n");
    // Locking the critical resource.
    pthread_mutex_lock(&mutex);
    while (C)
    {
      // if the C (Condition) is true, wait for the consumer signal to start producing the value.
      pthread_cond_wait(&consumer_condition, &mutex);
    }
    p = produceT();
    // Alter the condition to true/1 after the value has been produced
    C = 1;
    // Signal the consumer that the value has been produced
    pthread_cond_signal(&producer_condition);
    // Unlocking the mutex after critcal resource alteration.
    pthread_mutex_unlock(&mutex);
    printf("@PRODUCED %d\n", p);
  }
  printf("@P-EXIT\n");
  pthread_exit(NULL);
}

int consumeT()
{
  if (pred(pnum))
  {
    csum += pnum;
  }
  return pnum;
}
// U is the consumer or user (as given in slides)
void *Consume(void *a)
{
  int p;
  p = 1;
  while (p)
  {
    printf("@C-READY\n");
    // Locking the critcal region.
    pthread_mutex_lock(&mutex);
    // If the condition is not true then wait for the producer
    while (!C)
    {
      pthread_cond_wait(&producer_condition, &mutex);
    }
    p = consumeT(); // Using the critical resource
    // Setting the condition back to false
    C = 0;
    // Signalling the producer that the consumer has finished it's work with the resource
    pthread_cond_signal(&consumer_condition);
    // Unlocking the shared critical resource
    pthread_mutex_unlock(&mutex);
    printf("@CONSUMED %d\n", csum);
  }
  printf("@C-EXIT\n");
  pthread_exit(NULL);
}

int main(int argc, const char *argv[])
{
  // the current number predicate
  static pthread_t prod, cons;
  long rc;

  pred = &cond1;
  if (argc > 1)
  {
    if (!strncmp(argv[1], "2", 10))
    {
      pred = &cond2;
    }
    else if (!strncmp(argv[1], "3", 10))
    {
      pred = &cond3;
    }
  }

  pnum = 999;
  csum = 0;
  srand(time(0));

  printf("@P-CREATE\n");
  rc = pthread_create(&prod, NULL, Produce, (void *)0);
  if (rc)
  {
    printf("@P-ERROR %ld\n", rc);
    exit(-1);
  }
  printf("@C-CREATE\n");
  rc = pthread_create(&cons, NULL, Consume, (void *)0);
  if (rc)
  {
    printf("@C-ERROR %ld\n", rc);
    exit(-1);
  }

  printf("@P-JOIN\n");
  pthread_join(prod, NULL);
  printf("@C-JOIN\n");
  pthread_join(cons, NULL);

  printf("@CSUM=%d.\n", csum);

  return 0;
}
