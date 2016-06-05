//Since semaphore is mostly implemented in this header file, it will work when declared
// at the top of the test file.

#include "types.h"
#include "user.h"
#include "queue.h"

struct semaphore {
  lock_t the_lock;
  int number;
  struct queue qu;
};

void initialize_sem(int value, struct semaphore* sem) {
  init_q(&sem->qu);
  lock_init(&sem->the_lock);
  sem->number = value;
};

void sem_acquire(struct semaphore* sem) {
  lock_acquire(&sem->the_lock);
  
  if(sem->number > 0) {
    sem->number--;
    lock_release(&sem->the_lock);
    return;
  }
  else {
    add_q(&sem->qu, getpid());
    lock_release(&sem->the_lock);
    tsleep();
  }

};


void sem_signal(struct semaphore* sem) {
  lock_acquire(&sem->the_lock);
  
  if(empty_q(&sem->qu) == 1) {
    sem->number++;
  }
  else {
    int tid = pop_q(&sem->qu);
    twakeup(tid);
  }

  
  lock_release(&sem->the_lock);

};
