#include "semaphore.h"

struct semaphore h_sem;
struct semaphore o_sem;

int number = 0;

struct mutex {
  lock_t lock;
} mutex;

void h_acquire(void* arg_ptr) {
  printf(1, "Hydrogen formed.\n");
  sem_signal(&h_sem);
  sem_acquire(&o_sem);
  thread_yield();
  texit();
}

void o_acquire(void* arg_ptr) {

  printf(1, "Oxygen formed.\n");
  sem_acquire(&h_sem);
  sem_acquire(&h_sem);
  sem_signal(&o_sem);
  sem_signal(&o_sem);
  lock_acquire(&mutex.lock);
  number++;
  printf(1, "Atoms combined, molecule has formed.\n");

  lock_release(&mutex.lock);
  texit();
}

int main(void) {
  
  initialize_sem(0, &h_sem);
  initialize_sem(0, &o_sem);
  
  lock_init(&mutex.lock);

  printf(1, "program: Molecules, started\n");

  void* tid_1 = thread_create(h_acquire, (void*) 0);
  if(tid_1 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_2 = thread_create(h_acquire, (void*) 0);
  if(tid_2 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_3 = thread_create(o_acquire, (void*) 0);
  if(tid_3 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_4 = thread_create(o_acquire, (void*) 0);
  if(tid_4 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_5 = thread_create(h_acquire, (void*) 0);
  if(tid_5 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_6 = thread_create(h_acquire, (void*) 0);
  if(tid_6 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_7 = thread_create(h_acquire, (void*) 0);
  if(tid_7 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_8 = thread_create(o_acquire, (void*) 0);
  if(tid_8 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }
  void* tid_9 = thread_create(h_acquire, (void*) 0);
  if(tid_9 == 0) {
    printf(1, "Error, thread creation failed.\n");
    exit();
  }

  while(wait() > 0);

  printf(1, "number of molecules formed: %d\n", number);
   
  
  exit();
  return 0;
} 
