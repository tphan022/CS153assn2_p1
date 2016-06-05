#include "semaphore.h"

struct semaphore mis_sem;
struct semaphore can_sem;

int number_mis = 0;
int number_can = 0;

struct mutex {
  lock_t lock;
} mutex;

void missionary(void* arg_ptr) {
  printf(1, "Missionary came to boat.\n");
  if(number_mis >= 2) {
    sem_signal(&mis_sem);
    sem_signal(&mis_sem);

    printf(1, "Boat is full, crossing river.\n");
  }
  // This takes into account that the boat is still waiting if one missionary 
  // and two cannibals arrived, as this is an invalid combination. 
  else if(number_mis == 1 && (number_can == 1 || number_can == 2)) {
    sem_signal(&mis_sem);
    sem_signal(&can_sem);
    
    printf(1, "Boat is full, crossing river.\n");
  }

  else {
    lock_acquire(&mutex.lock);
    number_mis = number_mis + 1;
    lock_release(&mutex.lock);

    sem_acquire(&mis_sem);
    lock_acquire(&mutex.lock);
    number_mis = number_mis - 1;
    lock_release(&mutex.lock);

  }

  texit();

}

void cannibal(void* arg_ptr) {
  printf(1, "Cannibal came to boat.\n");
  if(number_mis == 2) {
    sem_signal(&mis_sem);
    sem_signal(&mis_sem);

    printf(1, "Boat is full, crossing river.\n");
  }
  else if(number_can >= 2) {
    sem_signal(&can_sem);
    sem_signal(&can_sem);
    
    printf(1, "Boat is full, crossing river.\n");
  }
  else {
    lock_acquire(&mutex.lock);
    number_can = number_can + 1;
    lock_release(&mutex.lock);

    sem_acquire(&can_sem);
    lock_acquire(&mutex.lock);
    number_can = number_can - 1;
    lock_release(&mutex.lock);

  }


  texit();

}



int main(void) {
  lock_init(&mutex.lock);
  initialize_sem(0, &can_sem);
  initialize_sem(1, &mis_sem);
  
  printf(1, "Program: boat, starting.\n");
  void* tid_1 = thread_create(missionary, (void*) 0);
  if(tid_1 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_2 = thread_create(cannibal, (void*) 0);
  if(tid_2 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_3 = thread_create(missionary, (void*) 0);
  if(tid_3 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_4 = thread_create(cannibal, (void*) 0);
  if(tid_4 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_5 = thread_create(missionary, (void*) 0);
  if(tid_5 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_6 = thread_create(missionary, (void*) 0);
  if(tid_6 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_7 = thread_create(missionary, (void*) 0);
  if(tid_7 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_8 = thread_create(missionary, (void*) 0);
  if(tid_8 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_9 = thread_create(cannibal, (void*) 0);
  if(tid_9 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_10 = thread_create(cannibal, (void*) 0);
  if(tid_10 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_11 = thread_create(cannibal, (void*) 0);
  if(tid_11 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_12 = thread_create(cannibal, (void*) 0);
  if(tid_12 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }

  while(wait() > 0);

  exit();
  return 0;
} 
