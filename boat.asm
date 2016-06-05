
_boat:     file format elf32-i386


Disassembly of section .text:

00000000 <initialize_sem>:
  lock_t the_lock;
  int number;
  struct queue qu;
};

void initialize_sem(int value, struct semaphore* sem) {
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  init_q(&sem->qu);
       6:	8b 45 0c             	mov    0xc(%ebp),%eax
       9:	83 c0 08             	add    $0x8,%eax
       c:	89 04 24             	mov    %eax,(%esp)
       f:	e8 d8 0e 00 00       	call   eec <init_q>
  lock_init(&sem->the_lock);
      14:	8b 45 0c             	mov    0xc(%ebp),%eax
      17:	89 04 24             	mov    %eax,(%esp)
      1a:	e8 8b 0d 00 00       	call   daa <lock_init>
  sem->number = value;
      1f:	8b 45 0c             	mov    0xc(%ebp),%eax
      22:	8b 55 08             	mov    0x8(%ebp),%edx
      25:	89 50 04             	mov    %edx,0x4(%eax)
};
      28:	c9                   	leave  
      29:	c3                   	ret    

0000002a <sem_acquire>:

void sem_acquire(struct semaphore* sem) {
      2a:	55                   	push   %ebp
      2b:	89 e5                	mov    %esp,%ebp
      2d:	83 ec 18             	sub    $0x18,%esp
  lock_acquire(&sem->the_lock);
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 7d 0d 00 00       	call   db8 <lock_acquire>
  
  if(sem->number > 0) {
      3b:	8b 45 08             	mov    0x8(%ebp),%eax
      3e:	8b 40 04             	mov    0x4(%eax),%eax
      41:	85 c0                	test   %eax,%eax
      43:	7e 1c                	jle    61 <sem_acquire+0x37>
    sem->number--;
      45:	8b 45 08             	mov    0x8(%ebp),%eax
      48:	8b 40 04             	mov    0x4(%eax),%eax
      4b:	8d 50 ff             	lea    -0x1(%eax),%edx
      4e:	8b 45 08             	mov    0x8(%ebp),%eax
      51:	89 50 04             	mov    %edx,0x4(%eax)
    lock_release(&sem->the_lock);
      54:	8b 45 08             	mov    0x8(%ebp),%eax
      57:	89 04 24             	mov    %eax,(%esp)
      5a:	e8 78 0d 00 00       	call   dd7 <lock_release>
    return;
      5f:	eb 27                	jmp    88 <sem_acquire+0x5e>
  }
  else {
    add_q(&sem->qu, getpid());
      61:	e8 4a 08 00 00       	call   8b0 <getpid>
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	83 c2 08             	add    $0x8,%edx
      6c:	89 44 24 04          	mov    %eax,0x4(%esp)
      70:	89 14 24             	mov    %edx,(%esp)
      73:	e8 96 0e 00 00       	call   f0e <add_q>
    lock_release(&sem->the_lock);
      78:	8b 45 08             	mov    0x8(%ebp),%eax
      7b:	89 04 24             	mov    %eax,(%esp)
      7e:	e8 54 0d 00 00       	call   dd7 <lock_release>
    tsleep();
      83:	e8 58 08 00 00       	call   8e0 <tsleep>
  }

};
      88:	c9                   	leave  
      89:	c3                   	ret    

0000008a <sem_signal>:


void sem_signal(struct semaphore* sem) {
      8a:	55                   	push   %ebp
      8b:	89 e5                	mov    %esp,%ebp
      8d:	83 ec 28             	sub    $0x28,%esp
  lock_acquire(&sem->the_lock);
      90:	8b 45 08             	mov    0x8(%ebp),%eax
      93:	89 04 24             	mov    %eax,(%esp)
      96:	e8 1d 0d 00 00       	call   db8 <lock_acquire>
  
  if(empty_q(&sem->qu) == 1) {
      9b:	8b 45 08             	mov    0x8(%ebp),%eax
      9e:	83 c0 08             	add    $0x8,%eax
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 c5 0e 00 00       	call   f6e <empty_q>
      a9:	83 f8 01             	cmp    $0x1,%eax
      ac:	75 11                	jne    bf <sem_signal+0x35>
    sem->number++;
      ae:	8b 45 08             	mov    0x8(%ebp),%eax
      b1:	8b 40 04             	mov    0x4(%eax),%eax
      b4:	8d 50 01             	lea    0x1(%eax),%edx
      b7:	8b 45 08             	mov    0x8(%ebp),%eax
      ba:	89 50 04             	mov    %edx,0x4(%eax)
      bd:	eb 1c                	jmp    db <sem_signal+0x51>
  }
  else {
    int tid = pop_q(&sem->qu);
      bf:	8b 45 08             	mov    0x8(%ebp),%eax
      c2:	83 c0 08             	add    $0x8,%eax
      c5:	89 04 24             	mov    %eax,(%esp)
      c8:	e8 bb 0e 00 00       	call   f88 <pop_q>
      cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tid);
      d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d3:	89 04 24             	mov    %eax,(%esp)
      d6:	e8 0d 08 00 00       	call   8e8 <twakeup>
  }

  
  lock_release(&sem->the_lock);
      db:	8b 45 08             	mov    0x8(%ebp),%eax
      de:	89 04 24             	mov    %eax,(%esp)
      e1:	e8 f1 0c 00 00       	call   dd7 <lock_release>

};
      e6:	c9                   	leave  
      e7:	c3                   	ret    

000000e8 <missionary>:

struct mutex {
  lock_t lock;
} mutex;

void missionary(void* arg_ptr) {
      e8:	55                   	push   %ebp
      e9:	89 e5                	mov    %esp,%ebp
      eb:	83 ec 18             	sub    $0x18,%esp
  printf(1, "Missionary came to boat.\n");
      ee:	c7 44 24 04 04 10 00 	movl   $0x1004,0x4(%esp)
      f5:	00 
      f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      fd:	e8 c7 08 00 00       	call   9c9 <printf>
  if(number_mis >= 2) {
     102:	a1 e0 10 00 00       	mov    0x10e0,%eax
     107:	83 f8 01             	cmp    $0x1,%eax
     10a:	7e 31                	jle    13d <missionary+0x55>
    sem_signal(&mis_sem);
     10c:	c7 04 24 f4 10 00 00 	movl   $0x10f4,(%esp)
     113:	e8 72 ff ff ff       	call   8a <sem_signal>
    sem_signal(&mis_sem);
     118:	c7 04 24 f4 10 00 00 	movl   $0x10f4,(%esp)
     11f:	e8 66 ff ff ff       	call   8a <sem_signal>

    printf(1, "Boat is full, crossing river.\n");
     124:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
     12b:	00 
     12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     133:	e8 91 08 00 00       	call   9c9 <printf>
     138:	e9 a2 00 00 00       	jmp    1df <missionary+0xf7>
  }
  // This takes into account that the boat is still waiting if one missionary 
  // and two cannibals arrived, as this is an invalid combination. 
  else if(number_mis == 1 && (number_can == 1 || number_can == 2)) {
     13d:	a1 e0 10 00 00       	mov    0x10e0,%eax
     142:	83 f8 01             	cmp    $0x1,%eax
     145:	75 42                	jne    189 <missionary+0xa1>
     147:	a1 e4 10 00 00       	mov    0x10e4,%eax
     14c:	83 f8 01             	cmp    $0x1,%eax
     14f:	74 0a                	je     15b <missionary+0x73>
     151:	a1 e4 10 00 00       	mov    0x10e4,%eax
     156:	83 f8 02             	cmp    $0x2,%eax
     159:	75 2e                	jne    189 <missionary+0xa1>
    sem_signal(&mis_sem);
     15b:	c7 04 24 f4 10 00 00 	movl   $0x10f4,(%esp)
     162:	e8 23 ff ff ff       	call   8a <sem_signal>
    sem_signal(&can_sem);
     167:	c7 04 24 0c 11 00 00 	movl   $0x110c,(%esp)
     16e:	e8 17 ff ff ff       	call   8a <sem_signal>
    
    printf(1, "Boat is full, crossing river.\n");
     173:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
     17a:	00 
     17b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     182:	e8 42 08 00 00       	call   9c9 <printf>

    printf(1, "Boat is full, crossing river.\n");
  }
  // This takes into account that the boat is still waiting if one missionary 
  // and two cannibals arrived, as this is an invalid combination. 
  else if(number_mis == 1 && (number_can == 1 || number_can == 2)) {
     187:	eb 56                	jmp    1df <missionary+0xf7>
    
    printf(1, "Boat is full, crossing river.\n");
  }

  else {
    lock_acquire(&mutex.lock);
     189:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     190:	e8 23 0c 00 00       	call   db8 <lock_acquire>
    number_mis = number_mis + 1;
     195:	a1 e0 10 00 00       	mov    0x10e0,%eax
     19a:	83 c0 01             	add    $0x1,%eax
     19d:	a3 e0 10 00 00       	mov    %eax,0x10e0
    lock_release(&mutex.lock);
     1a2:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     1a9:	e8 29 0c 00 00       	call   dd7 <lock_release>

    sem_acquire(&mis_sem);
     1ae:	c7 04 24 f4 10 00 00 	movl   $0x10f4,(%esp)
     1b5:	e8 70 fe ff ff       	call   2a <sem_acquire>
    lock_acquire(&mutex.lock);
     1ba:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     1c1:	e8 f2 0b 00 00       	call   db8 <lock_acquire>
    number_mis = number_mis - 1;
     1c6:	a1 e0 10 00 00       	mov    0x10e0,%eax
     1cb:	83 e8 01             	sub    $0x1,%eax
     1ce:	a3 e0 10 00 00       	mov    %eax,0x10e0
    lock_release(&mutex.lock);
     1d3:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     1da:	e8 f8 0b 00 00       	call   dd7 <lock_release>

  }

  texit();
     1df:	e8 f4 06 00 00       	call   8d8 <texit>

000001e4 <cannibal>:

}

void cannibal(void* arg_ptr) {
     1e4:	55                   	push   %ebp
     1e5:	89 e5                	mov    %esp,%ebp
     1e7:	83 ec 18             	sub    $0x18,%esp
  printf(1, "Cannibal came to boat.\n");
     1ea:	c7 44 24 04 3f 10 00 	movl   $0x103f,0x4(%esp)
     1f1:	00 
     1f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1f9:	e8 cb 07 00 00       	call   9c9 <printf>
  if(number_mis == 2) {
     1fe:	a1 e0 10 00 00       	mov    0x10e0,%eax
     203:	83 f8 02             	cmp    $0x2,%eax
     206:	75 31                	jne    239 <cannibal+0x55>
    sem_signal(&mis_sem);
     208:	c7 04 24 f4 10 00 00 	movl   $0x10f4,(%esp)
     20f:	e8 76 fe ff ff       	call   8a <sem_signal>
    sem_signal(&mis_sem);
     214:	c7 04 24 f4 10 00 00 	movl   $0x10f4,(%esp)
     21b:	e8 6a fe ff ff       	call   8a <sem_signal>

    printf(1, "Boat is full, crossing river.\n");
     220:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
     227:	00 
     228:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     22f:	e8 95 07 00 00       	call   9c9 <printf>
     234:	e9 8e 00 00 00       	jmp    2c7 <cannibal+0xe3>
  }
  else if(number_can >= 2) {
     239:	a1 e4 10 00 00       	mov    0x10e4,%eax
     23e:	83 f8 01             	cmp    $0x1,%eax
     241:	7e 2e                	jle    271 <cannibal+0x8d>
    sem_signal(&can_sem);
     243:	c7 04 24 0c 11 00 00 	movl   $0x110c,(%esp)
     24a:	e8 3b fe ff ff       	call   8a <sem_signal>
    sem_signal(&can_sem);
     24f:	c7 04 24 0c 11 00 00 	movl   $0x110c,(%esp)
     256:	e8 2f fe ff ff       	call   8a <sem_signal>
    
    printf(1, "Boat is full, crossing river.\n");
     25b:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
     262:	00 
     263:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     26a:	e8 5a 07 00 00       	call   9c9 <printf>
     26f:	eb 56                	jmp    2c7 <cannibal+0xe3>
  }
  else {
    lock_acquire(&mutex.lock);
     271:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     278:	e8 3b 0b 00 00       	call   db8 <lock_acquire>
    number_can = number_can + 1;
     27d:	a1 e4 10 00 00       	mov    0x10e4,%eax
     282:	83 c0 01             	add    $0x1,%eax
     285:	a3 e4 10 00 00       	mov    %eax,0x10e4
    lock_release(&mutex.lock);
     28a:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     291:	e8 41 0b 00 00       	call   dd7 <lock_release>

    sem_acquire(&can_sem);
     296:	c7 04 24 0c 11 00 00 	movl   $0x110c,(%esp)
     29d:	e8 88 fd ff ff       	call   2a <sem_acquire>
    lock_acquire(&mutex.lock);
     2a2:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     2a9:	e8 0a 0b 00 00       	call   db8 <lock_acquire>
    number_can = number_can - 1;
     2ae:	a1 e4 10 00 00       	mov    0x10e4,%eax
     2b3:	83 e8 01             	sub    $0x1,%eax
     2b6:	a3 e4 10 00 00       	mov    %eax,0x10e4
    lock_release(&mutex.lock);
     2bb:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     2c2:	e8 10 0b 00 00       	call   dd7 <lock_release>

  }


  texit();
     2c7:	e8 0c 06 00 00       	call   8d8 <texit>

000002cc <main>:

}



int main(void) {
     2cc:	55                   	push   %ebp
     2cd:	89 e5                	mov    %esp,%ebp
     2cf:	83 e4 f0             	and    $0xfffffff0,%esp
     2d2:	83 ec 40             	sub    $0x40,%esp
  lock_init(&mutex.lock);
     2d5:	c7 04 24 08 11 00 00 	movl   $0x1108,(%esp)
     2dc:	e8 c9 0a 00 00       	call   daa <lock_init>
  initialize_sem(0, &can_sem);
     2e1:	c7 44 24 04 0c 11 00 	movl   $0x110c,0x4(%esp)
     2e8:	00 
     2e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2f0:	e8 0b fd ff ff       	call   0 <initialize_sem>
  initialize_sem(1, &mis_sem);
     2f5:	c7 44 24 04 f4 10 00 	movl   $0x10f4,0x4(%esp)
     2fc:	00 
     2fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     304:	e8 f7 fc ff ff       	call   0 <initialize_sem>
  
  printf(1, "Program: boat, starting.\n");
     309:	c7 44 24 04 57 10 00 	movl   $0x1057,0x4(%esp)
     310:	00 
     311:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     318:	e8 ac 06 00 00       	call   9c9 <printf>
  void* tid_1 = thread_create(missionary, (void*) 0);
     31d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     324:	00 
     325:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
     32c:	e8 c1 0a 00 00       	call   df2 <thread_create>
     331:	89 44 24 10          	mov    %eax,0x10(%esp)
  if(tid_1 == 0) {
     335:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
     33a:	75 19                	jne    355 <main+0x89>
    printf(1, "Error, thread creation failed.\n");
     33c:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     343:	00 
     344:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     34b:	e8 79 06 00 00       	call   9c9 <printf>
    exit();
     350:	e8 db 04 00 00       	call   830 <exit>
  }
  void* tid_2 = thread_create(cannibal, (void*) 0);
     355:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     35c:	00 
     35d:	c7 04 24 e4 01 00 00 	movl   $0x1e4,(%esp)
     364:	e8 89 0a 00 00       	call   df2 <thread_create>
     369:	89 44 24 14          	mov    %eax,0x14(%esp)
  if(tid_2 == 0) {
     36d:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
     372:	75 19                	jne    38d <main+0xc1>
    printf(1, "Error, thread creation failed.\n");
     374:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     37b:	00 
     37c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     383:	e8 41 06 00 00       	call   9c9 <printf>
    exit();
     388:	e8 a3 04 00 00       	call   830 <exit>
  }
  void* tid_3 = thread_create(missionary, (void*) 0);
     38d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     394:	00 
     395:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
     39c:	e8 51 0a 00 00       	call   df2 <thread_create>
     3a1:	89 44 24 18          	mov    %eax,0x18(%esp)
  if(tid_3 == 0) {
     3a5:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
     3aa:	75 19                	jne    3c5 <main+0xf9>
    printf(1, "Error, thread creation failed.\n");
     3ac:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     3b3:	00 
     3b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3bb:	e8 09 06 00 00       	call   9c9 <printf>
    exit();
     3c0:	e8 6b 04 00 00       	call   830 <exit>
  }
  void* tid_4 = thread_create(cannibal, (void*) 0);
     3c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3cc:	00 
     3cd:	c7 04 24 e4 01 00 00 	movl   $0x1e4,(%esp)
     3d4:	e8 19 0a 00 00       	call   df2 <thread_create>
     3d9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  if(tid_4 == 0) {
     3dd:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     3e2:	75 19                	jne    3fd <main+0x131>
    printf(1, "Error, thread creation failed.\n");
     3e4:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     3eb:	00 
     3ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3f3:	e8 d1 05 00 00       	call   9c9 <printf>
    exit();
     3f8:	e8 33 04 00 00       	call   830 <exit>
  }
  void* tid_5 = thread_create(missionary, (void*) 0);
     3fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     404:	00 
     405:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
     40c:	e8 e1 09 00 00       	call   df2 <thread_create>
     411:	89 44 24 20          	mov    %eax,0x20(%esp)
  if(tid_5 == 0) {
     415:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
     41a:	75 19                	jne    435 <main+0x169>
    printf(1, "Error, thread creation failed.\n");
     41c:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     423:	00 
     424:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     42b:	e8 99 05 00 00       	call   9c9 <printf>
    exit();
     430:	e8 fb 03 00 00       	call   830 <exit>
  }
  void* tid_6 = thread_create(missionary, (void*) 0);
     435:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     43c:	00 
     43d:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
     444:	e8 a9 09 00 00       	call   df2 <thread_create>
     449:	89 44 24 24          	mov    %eax,0x24(%esp)
  if(tid_6 == 0) {
     44d:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
     452:	75 19                	jne    46d <main+0x1a1>
    printf(1, "Error, thread creation failed.\n");
     454:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     45b:	00 
     45c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     463:	e8 61 05 00 00       	call   9c9 <printf>
    exit();
     468:	e8 c3 03 00 00       	call   830 <exit>
  }
  void* tid_7 = thread_create(missionary, (void*) 0);
     46d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     474:	00 
     475:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
     47c:	e8 71 09 00 00       	call   df2 <thread_create>
     481:	89 44 24 28          	mov    %eax,0x28(%esp)
  if(tid_7 == 0) {
     485:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
     48a:	75 19                	jne    4a5 <main+0x1d9>
    printf(1, "Error, thread creation failed.\n");
     48c:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     493:	00 
     494:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     49b:	e8 29 05 00 00       	call   9c9 <printf>
    exit();
     4a0:	e8 8b 03 00 00       	call   830 <exit>
  }
  void* tid_8 = thread_create(missionary, (void*) 0);
     4a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4ac:	00 
     4ad:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
     4b4:	e8 39 09 00 00       	call   df2 <thread_create>
     4b9:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  if(tid_8 == 0) {
     4bd:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
     4c2:	75 19                	jne    4dd <main+0x211>
    printf(1, "Error, thread creation failed.\n");
     4c4:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     4cb:	00 
     4cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4d3:	e8 f1 04 00 00       	call   9c9 <printf>
    exit();
     4d8:	e8 53 03 00 00       	call   830 <exit>
  }
  void* tid_9 = thread_create(cannibal, (void*) 0);
     4dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4e4:	00 
     4e5:	c7 04 24 e4 01 00 00 	movl   $0x1e4,(%esp)
     4ec:	e8 01 09 00 00       	call   df2 <thread_create>
     4f1:	89 44 24 30          	mov    %eax,0x30(%esp)
  if(tid_9 == 0) {
     4f5:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
     4fa:	75 19                	jne    515 <main+0x249>
    printf(1, "Error, thread creation failed.\n");
     4fc:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     503:	00 
     504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     50b:	e8 b9 04 00 00       	call   9c9 <printf>
    exit();
     510:	e8 1b 03 00 00       	call   830 <exit>
  }
  void* tid_10 = thread_create(cannibal, (void*) 0);
     515:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     51c:	00 
     51d:	c7 04 24 e4 01 00 00 	movl   $0x1e4,(%esp)
     524:	e8 c9 08 00 00       	call   df2 <thread_create>
     529:	89 44 24 34          	mov    %eax,0x34(%esp)
  if(tid_10 == 0) {
     52d:	83 7c 24 34 00       	cmpl   $0x0,0x34(%esp)
     532:	75 19                	jne    54d <main+0x281>
    printf(1, "Error, thread creation failed.\n");
     534:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     53b:	00 
     53c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     543:	e8 81 04 00 00       	call   9c9 <printf>
    exit();
     548:	e8 e3 02 00 00       	call   830 <exit>
  }
  void* tid_11 = thread_create(cannibal, (void*) 0);
     54d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     554:	00 
     555:	c7 04 24 e4 01 00 00 	movl   $0x1e4,(%esp)
     55c:	e8 91 08 00 00       	call   df2 <thread_create>
     561:	89 44 24 38          	mov    %eax,0x38(%esp)
  if(tid_11 == 0) {
     565:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
     56a:	75 19                	jne    585 <main+0x2b9>
    printf(1, "Error, thread creation failed.\n");
     56c:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     573:	00 
     574:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     57b:	e8 49 04 00 00       	call   9c9 <printf>
    exit();
     580:	e8 ab 02 00 00       	call   830 <exit>
  }
  void* tid_12 = thread_create(cannibal, (void*) 0);
     585:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     58c:	00 
     58d:	c7 04 24 e4 01 00 00 	movl   $0x1e4,(%esp)
     594:	e8 59 08 00 00       	call   df2 <thread_create>
     599:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  if(tid_12 == 0) {
     59d:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     5a2:	75 19                	jne    5bd <main+0x2f1>
    printf(1, "Error, thread creation failed.\n");
     5a4:	c7 44 24 04 74 10 00 	movl   $0x1074,0x4(%esp)
     5ab:	00 
     5ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5b3:	e8 11 04 00 00       	call   9c9 <printf>
    exit();
     5b8:	e8 73 02 00 00       	call   830 <exit>
  }

  while(wait() > 0);
     5bd:	e8 76 02 00 00       	call   838 <wait>
     5c2:	85 c0                	test   %eax,%eax
     5c4:	7f f7                	jg     5bd <main+0x2f1>

  exit();
     5c6:	e8 65 02 00 00       	call   830 <exit>
     5cb:	90                   	nop

000005cc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     5cc:	55                   	push   %ebp
     5cd:	89 e5                	mov    %esp,%ebp
     5cf:	57                   	push   %edi
     5d0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     5d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
     5d4:	8b 55 10             	mov    0x10(%ebp),%edx
     5d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     5da:	89 cb                	mov    %ecx,%ebx
     5dc:	89 df                	mov    %ebx,%edi
     5de:	89 d1                	mov    %edx,%ecx
     5e0:	fc                   	cld    
     5e1:	f3 aa                	rep stos %al,%es:(%edi)
     5e3:	89 ca                	mov    %ecx,%edx
     5e5:	89 fb                	mov    %edi,%ebx
     5e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
     5ea:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     5ed:	5b                   	pop    %ebx
     5ee:	5f                   	pop    %edi
     5ef:	5d                   	pop    %ebp
     5f0:	c3                   	ret    

000005f1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     5f1:	55                   	push   %ebp
     5f2:	89 e5                	mov    %esp,%ebp
     5f4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     5f7:	8b 45 08             	mov    0x8(%ebp),%eax
     5fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     5fd:	8b 45 0c             	mov    0xc(%ebp),%eax
     600:	0f b6 10             	movzbl (%eax),%edx
     603:	8b 45 08             	mov    0x8(%ebp),%eax
     606:	88 10                	mov    %dl,(%eax)
     608:	8b 45 08             	mov    0x8(%ebp),%eax
     60b:	0f b6 00             	movzbl (%eax),%eax
     60e:	84 c0                	test   %al,%al
     610:	0f 95 c0             	setne  %al
     613:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     617:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     61b:	84 c0                	test   %al,%al
     61d:	75 de                	jne    5fd <strcpy+0xc>
    ;
  return os;
     61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     622:	c9                   	leave  
     623:	c3                   	ret    

00000624 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     624:	55                   	push   %ebp
     625:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     627:	eb 08                	jmp    631 <strcmp+0xd>
    p++, q++;
     629:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     62d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     631:	8b 45 08             	mov    0x8(%ebp),%eax
     634:	0f b6 00             	movzbl (%eax),%eax
     637:	84 c0                	test   %al,%al
     639:	74 10                	je     64b <strcmp+0x27>
     63b:	8b 45 08             	mov    0x8(%ebp),%eax
     63e:	0f b6 10             	movzbl (%eax),%edx
     641:	8b 45 0c             	mov    0xc(%ebp),%eax
     644:	0f b6 00             	movzbl (%eax),%eax
     647:	38 c2                	cmp    %al,%dl
     649:	74 de                	je     629 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     64b:	8b 45 08             	mov    0x8(%ebp),%eax
     64e:	0f b6 00             	movzbl (%eax),%eax
     651:	0f b6 d0             	movzbl %al,%edx
     654:	8b 45 0c             	mov    0xc(%ebp),%eax
     657:	0f b6 00             	movzbl (%eax),%eax
     65a:	0f b6 c0             	movzbl %al,%eax
     65d:	89 d1                	mov    %edx,%ecx
     65f:	29 c1                	sub    %eax,%ecx
     661:	89 c8                	mov    %ecx,%eax
}
     663:	5d                   	pop    %ebp
     664:	c3                   	ret    

00000665 <strlen>:

uint
strlen(char *s)
{
     665:	55                   	push   %ebp
     666:	89 e5                	mov    %esp,%ebp
     668:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     66b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     672:	eb 04                	jmp    678 <strlen+0x13>
     674:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     678:	8b 45 fc             	mov    -0x4(%ebp),%eax
     67b:	03 45 08             	add    0x8(%ebp),%eax
     67e:	0f b6 00             	movzbl (%eax),%eax
     681:	84 c0                	test   %al,%al
     683:	75 ef                	jne    674 <strlen+0xf>
    ;
  return n;
     685:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     688:	c9                   	leave  
     689:	c3                   	ret    

0000068a <memset>:

void*
memset(void *dst, int c, uint n)
{
     68a:	55                   	push   %ebp
     68b:	89 e5                	mov    %esp,%ebp
     68d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     690:	8b 45 10             	mov    0x10(%ebp),%eax
     693:	89 44 24 08          	mov    %eax,0x8(%esp)
     697:	8b 45 0c             	mov    0xc(%ebp),%eax
     69a:	89 44 24 04          	mov    %eax,0x4(%esp)
     69e:	8b 45 08             	mov    0x8(%ebp),%eax
     6a1:	89 04 24             	mov    %eax,(%esp)
     6a4:	e8 23 ff ff ff       	call   5cc <stosb>
  return dst;
     6a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     6ac:	c9                   	leave  
     6ad:	c3                   	ret    

000006ae <strchr>:

char*
strchr(const char *s, char c)
{
     6ae:	55                   	push   %ebp
     6af:	89 e5                	mov    %esp,%ebp
     6b1:	83 ec 04             	sub    $0x4,%esp
     6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
     6b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     6ba:	eb 14                	jmp    6d0 <strchr+0x22>
    if(*s == c)
     6bc:	8b 45 08             	mov    0x8(%ebp),%eax
     6bf:	0f b6 00             	movzbl (%eax),%eax
     6c2:	3a 45 fc             	cmp    -0x4(%ebp),%al
     6c5:	75 05                	jne    6cc <strchr+0x1e>
      return (char*)s;
     6c7:	8b 45 08             	mov    0x8(%ebp),%eax
     6ca:	eb 13                	jmp    6df <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     6cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     6d0:	8b 45 08             	mov    0x8(%ebp),%eax
     6d3:	0f b6 00             	movzbl (%eax),%eax
     6d6:	84 c0                	test   %al,%al
     6d8:	75 e2                	jne    6bc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     6da:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6df:	c9                   	leave  
     6e0:	c3                   	ret    

000006e1 <gets>:

char*
gets(char *buf, int max)
{
     6e1:	55                   	push   %ebp
     6e2:	89 e5                	mov    %esp,%ebp
     6e4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     6e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     6ee:	eb 44                	jmp    734 <gets+0x53>
    cc = read(0, &c, 1);
     6f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     6f7:	00 
     6f8:	8d 45 ef             	lea    -0x11(%ebp),%eax
     6fb:	89 44 24 04          	mov    %eax,0x4(%esp)
     6ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     706:	e8 3d 01 00 00       	call   848 <read>
     70b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
     70e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     712:	7e 2d                	jle    741 <gets+0x60>
      break;
    buf[i++] = c;
     714:	8b 45 f0             	mov    -0x10(%ebp),%eax
     717:	03 45 08             	add    0x8(%ebp),%eax
     71a:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     71e:	88 10                	mov    %dl,(%eax)
     720:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
     724:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     728:	3c 0a                	cmp    $0xa,%al
     72a:	74 16                	je     742 <gets+0x61>
     72c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     730:	3c 0d                	cmp    $0xd,%al
     732:	74 0e                	je     742 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     734:	8b 45 f0             	mov    -0x10(%ebp),%eax
     737:	83 c0 01             	add    $0x1,%eax
     73a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     73d:	7c b1                	jl     6f0 <gets+0xf>
     73f:	eb 01                	jmp    742 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     741:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     742:	8b 45 f0             	mov    -0x10(%ebp),%eax
     745:	03 45 08             	add    0x8(%ebp),%eax
     748:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     74b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     74e:	c9                   	leave  
     74f:	c3                   	ret    

00000750 <stat>:

int
stat(char *n, struct stat *st)
{
     750:	55                   	push   %ebp
     751:	89 e5                	mov    %esp,%ebp
     753:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     756:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     75d:	00 
     75e:	8b 45 08             	mov    0x8(%ebp),%eax
     761:	89 04 24             	mov    %eax,(%esp)
     764:	e8 07 01 00 00       	call   870 <open>
     769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
     76c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     770:	79 07                	jns    779 <stat+0x29>
    return -1;
     772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     777:	eb 23                	jmp    79c <stat+0x4c>
  r = fstat(fd, st);
     779:	8b 45 0c             	mov    0xc(%ebp),%eax
     77c:	89 44 24 04          	mov    %eax,0x4(%esp)
     780:	8b 45 f0             	mov    -0x10(%ebp),%eax
     783:	89 04 24             	mov    %eax,(%esp)
     786:	e8 fd 00 00 00       	call   888 <fstat>
     78b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
     78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     791:	89 04 24             	mov    %eax,(%esp)
     794:	e8 bf 00 00 00       	call   858 <close>
  return r;
     799:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     79c:	c9                   	leave  
     79d:	c3                   	ret    

0000079e <atoi>:

int
atoi(const char *s)
{
     79e:	55                   	push   %ebp
     79f:	89 e5                	mov    %esp,%ebp
     7a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     7a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     7ab:	eb 24                	jmp    7d1 <atoi+0x33>
    n = n*10 + *s++ - '0';
     7ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
     7b0:	89 d0                	mov    %edx,%eax
     7b2:	c1 e0 02             	shl    $0x2,%eax
     7b5:	01 d0                	add    %edx,%eax
     7b7:	01 c0                	add    %eax,%eax
     7b9:	89 c2                	mov    %eax,%edx
     7bb:	8b 45 08             	mov    0x8(%ebp),%eax
     7be:	0f b6 00             	movzbl (%eax),%eax
     7c1:	0f be c0             	movsbl %al,%eax
     7c4:	8d 04 02             	lea    (%edx,%eax,1),%eax
     7c7:	83 e8 30             	sub    $0x30,%eax
     7ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
     7cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     7d1:	8b 45 08             	mov    0x8(%ebp),%eax
     7d4:	0f b6 00             	movzbl (%eax),%eax
     7d7:	3c 2f                	cmp    $0x2f,%al
     7d9:	7e 0a                	jle    7e5 <atoi+0x47>
     7db:	8b 45 08             	mov    0x8(%ebp),%eax
     7de:	0f b6 00             	movzbl (%eax),%eax
     7e1:	3c 39                	cmp    $0x39,%al
     7e3:	7e c8                	jle    7ad <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     7e8:	c9                   	leave  
     7e9:	c3                   	ret    

000007ea <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     7ea:	55                   	push   %ebp
     7eb:	89 e5                	mov    %esp,%ebp
     7ed:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     7f0:	8b 45 08             	mov    0x8(%ebp),%eax
     7f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
     7f6:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
     7fc:	eb 13                	jmp    811 <memmove+0x27>
    *dst++ = *src++;
     7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
     801:	0f b6 10             	movzbl (%eax),%edx
     804:	8b 45 f8             	mov    -0x8(%ebp),%eax
     807:	88 10                	mov    %dl,(%eax)
     809:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
     80d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     811:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     815:	0f 9f c0             	setg   %al
     818:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     81c:	84 c0                	test   %al,%al
     81e:	75 de                	jne    7fe <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     820:	8b 45 08             	mov    0x8(%ebp),%eax
}
     823:	c9                   	leave  
     824:	c3                   	ret    
     825:	90                   	nop
     826:	90                   	nop
     827:	90                   	nop

00000828 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     828:	b8 01 00 00 00       	mov    $0x1,%eax
     82d:	cd 40                	int    $0x40
     82f:	c3                   	ret    

00000830 <exit>:
SYSCALL(exit)
     830:	b8 02 00 00 00       	mov    $0x2,%eax
     835:	cd 40                	int    $0x40
     837:	c3                   	ret    

00000838 <wait>:
SYSCALL(wait)
     838:	b8 03 00 00 00       	mov    $0x3,%eax
     83d:	cd 40                	int    $0x40
     83f:	c3                   	ret    

00000840 <pipe>:
SYSCALL(pipe)
     840:	b8 04 00 00 00       	mov    $0x4,%eax
     845:	cd 40                	int    $0x40
     847:	c3                   	ret    

00000848 <read>:
SYSCALL(read)
     848:	b8 05 00 00 00       	mov    $0x5,%eax
     84d:	cd 40                	int    $0x40
     84f:	c3                   	ret    

00000850 <write>:
SYSCALL(write)
     850:	b8 10 00 00 00       	mov    $0x10,%eax
     855:	cd 40                	int    $0x40
     857:	c3                   	ret    

00000858 <close>:
SYSCALL(close)
     858:	b8 15 00 00 00       	mov    $0x15,%eax
     85d:	cd 40                	int    $0x40
     85f:	c3                   	ret    

00000860 <kill>:
SYSCALL(kill)
     860:	b8 06 00 00 00       	mov    $0x6,%eax
     865:	cd 40                	int    $0x40
     867:	c3                   	ret    

00000868 <exec>:
SYSCALL(exec)
     868:	b8 07 00 00 00       	mov    $0x7,%eax
     86d:	cd 40                	int    $0x40
     86f:	c3                   	ret    

00000870 <open>:
SYSCALL(open)
     870:	b8 0f 00 00 00       	mov    $0xf,%eax
     875:	cd 40                	int    $0x40
     877:	c3                   	ret    

00000878 <mknod>:
SYSCALL(mknod)
     878:	b8 11 00 00 00       	mov    $0x11,%eax
     87d:	cd 40                	int    $0x40
     87f:	c3                   	ret    

00000880 <unlink>:
SYSCALL(unlink)
     880:	b8 12 00 00 00       	mov    $0x12,%eax
     885:	cd 40                	int    $0x40
     887:	c3                   	ret    

00000888 <fstat>:
SYSCALL(fstat)
     888:	b8 08 00 00 00       	mov    $0x8,%eax
     88d:	cd 40                	int    $0x40
     88f:	c3                   	ret    

00000890 <link>:
SYSCALL(link)
     890:	b8 13 00 00 00       	mov    $0x13,%eax
     895:	cd 40                	int    $0x40
     897:	c3                   	ret    

00000898 <mkdir>:
SYSCALL(mkdir)
     898:	b8 14 00 00 00       	mov    $0x14,%eax
     89d:	cd 40                	int    $0x40
     89f:	c3                   	ret    

000008a0 <chdir>:
SYSCALL(chdir)
     8a0:	b8 09 00 00 00       	mov    $0x9,%eax
     8a5:	cd 40                	int    $0x40
     8a7:	c3                   	ret    

000008a8 <dup>:
SYSCALL(dup)
     8a8:	b8 0a 00 00 00       	mov    $0xa,%eax
     8ad:	cd 40                	int    $0x40
     8af:	c3                   	ret    

000008b0 <getpid>:
SYSCALL(getpid)
     8b0:	b8 0b 00 00 00       	mov    $0xb,%eax
     8b5:	cd 40                	int    $0x40
     8b7:	c3                   	ret    

000008b8 <sbrk>:
SYSCALL(sbrk)
     8b8:	b8 0c 00 00 00       	mov    $0xc,%eax
     8bd:	cd 40                	int    $0x40
     8bf:	c3                   	ret    

000008c0 <sleep>:
SYSCALL(sleep)
     8c0:	b8 0d 00 00 00       	mov    $0xd,%eax
     8c5:	cd 40                	int    $0x40
     8c7:	c3                   	ret    

000008c8 <uptime>:
SYSCALL(uptime)
     8c8:	b8 0e 00 00 00       	mov    $0xe,%eax
     8cd:	cd 40                	int    $0x40
     8cf:	c3                   	ret    

000008d0 <clone>:
SYSCALL(clone)
     8d0:	b8 16 00 00 00       	mov    $0x16,%eax
     8d5:	cd 40                	int    $0x40
     8d7:	c3                   	ret    

000008d8 <texit>:
SYSCALL(texit)
     8d8:	b8 17 00 00 00       	mov    $0x17,%eax
     8dd:	cd 40                	int    $0x40
     8df:	c3                   	ret    

000008e0 <tsleep>:
SYSCALL(tsleep)
     8e0:	b8 18 00 00 00       	mov    $0x18,%eax
     8e5:	cd 40                	int    $0x40
     8e7:	c3                   	ret    

000008e8 <twakeup>:
SYSCALL(twakeup)
     8e8:	b8 19 00 00 00       	mov    $0x19,%eax
     8ed:	cd 40                	int    $0x40
     8ef:	c3                   	ret    

000008f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     8f0:	55                   	push   %ebp
     8f1:	89 e5                	mov    %esp,%ebp
     8f3:	83 ec 28             	sub    $0x28,%esp
     8f6:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     8fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     903:	00 
     904:	8d 45 f4             	lea    -0xc(%ebp),%eax
     907:	89 44 24 04          	mov    %eax,0x4(%esp)
     90b:	8b 45 08             	mov    0x8(%ebp),%eax
     90e:	89 04 24             	mov    %eax,(%esp)
     911:	e8 3a ff ff ff       	call   850 <write>
}
     916:	c9                   	leave  
     917:	c3                   	ret    

00000918 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     918:	55                   	push   %ebp
     919:	89 e5                	mov    %esp,%ebp
     91b:	53                   	push   %ebx
     91c:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     91f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     926:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     92a:	74 17                	je     943 <printint+0x2b>
     92c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     930:	79 11                	jns    943 <printint+0x2b>
    neg = 1;
     932:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     939:	8b 45 0c             	mov    0xc(%ebp),%eax
     93c:	f7 d8                	neg    %eax
     93e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     941:	eb 06                	jmp    949 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     943:	8b 45 0c             	mov    0xc(%ebp),%eax
     946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
     949:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
     950:	8b 4d ec             	mov    -0x14(%ebp),%ecx
     953:	8b 5d 10             	mov    0x10(%ebp),%ebx
     956:	8b 45 f4             	mov    -0xc(%ebp),%eax
     959:	ba 00 00 00 00       	mov    $0x0,%edx
     95e:	f7 f3                	div    %ebx
     960:	89 d0                	mov    %edx,%eax
     962:	0f b6 80 c8 10 00 00 	movzbl 0x10c8(%eax),%eax
     969:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
     96d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
     971:	8b 45 10             	mov    0x10(%ebp),%eax
     974:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     977:	8b 45 f4             	mov    -0xc(%ebp),%eax
     97a:	ba 00 00 00 00       	mov    $0x0,%edx
     97f:	f7 75 d4             	divl   -0x2c(%ebp)
     982:	89 45 f4             	mov    %eax,-0xc(%ebp)
     985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     989:	75 c5                	jne    950 <printint+0x38>
  if(neg)
     98b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     98f:	74 28                	je     9b9 <printint+0xa1>
    buf[i++] = '-';
     991:	8b 45 ec             	mov    -0x14(%ebp),%eax
     994:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
     999:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
     99d:	eb 1a                	jmp    9b9 <printint+0xa1>
    putc(fd, buf[i]);
     99f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9a2:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
     9a7:	0f be c0             	movsbl %al,%eax
     9aa:	89 44 24 04          	mov    %eax,0x4(%esp)
     9ae:	8b 45 08             	mov    0x8(%ebp),%eax
     9b1:	89 04 24             	mov    %eax,(%esp)
     9b4:	e8 37 ff ff ff       	call   8f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     9b9:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
     9bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     9c1:	79 dc                	jns    99f <printint+0x87>
    putc(fd, buf[i]);
}
     9c3:	83 c4 44             	add    $0x44,%esp
     9c6:	5b                   	pop    %ebx
     9c7:	5d                   	pop    %ebp
     9c8:	c3                   	ret    

000009c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     9c9:	55                   	push   %ebp
     9ca:	89 e5                	mov    %esp,%ebp
     9cc:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     9cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     9d6:	8d 45 0c             	lea    0xc(%ebp),%eax
     9d9:	83 c0 04             	add    $0x4,%eax
     9dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
     9df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9e6:	e9 7e 01 00 00       	jmp    b69 <printf+0x1a0>
    c = fmt[i] & 0xff;
     9eb:	8b 55 0c             	mov    0xc(%ebp),%edx
     9ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9f1:	8d 04 02             	lea    (%edx,%eax,1),%eax
     9f4:	0f b6 00             	movzbl (%eax),%eax
     9f7:	0f be c0             	movsbl %al,%eax
     9fa:	25 ff 00 00 00       	and    $0xff,%eax
     9ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
     a02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a06:	75 2c                	jne    a34 <printf+0x6b>
      if(c == '%'){
     a08:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
     a0c:	75 0c                	jne    a1a <printf+0x51>
        state = '%';
     a0e:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
     a15:	e9 4b 01 00 00       	jmp    b65 <printf+0x19c>
      } else {
        putc(fd, c);
     a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a1d:	0f be c0             	movsbl %al,%eax
     a20:	89 44 24 04          	mov    %eax,0x4(%esp)
     a24:	8b 45 08             	mov    0x8(%ebp),%eax
     a27:	89 04 24             	mov    %eax,(%esp)
     a2a:	e8 c1 fe ff ff       	call   8f0 <putc>
     a2f:	e9 31 01 00 00       	jmp    b65 <printf+0x19c>
      }
    } else if(state == '%'){
     a34:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
     a38:	0f 85 27 01 00 00    	jne    b65 <printf+0x19c>
      if(c == 'd'){
     a3e:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
     a42:	75 2d                	jne    a71 <printf+0xa8>
        printint(fd, *ap, 10, 1);
     a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a47:	8b 00                	mov    (%eax),%eax
     a49:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     a50:	00 
     a51:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     a58:	00 
     a59:	89 44 24 04          	mov    %eax,0x4(%esp)
     a5d:	8b 45 08             	mov    0x8(%ebp),%eax
     a60:	89 04 24             	mov    %eax,(%esp)
     a63:	e8 b0 fe ff ff       	call   918 <printint>
        ap++;
     a68:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
     a6c:	e9 ed 00 00 00       	jmp    b5e <printf+0x195>
      } else if(c == 'x' || c == 'p'){
     a71:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
     a75:	74 06                	je     a7d <printf+0xb4>
     a77:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
     a7b:	75 2d                	jne    aaa <printf+0xe1>
        printint(fd, *ap, 16, 0);
     a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a80:	8b 00                	mov    (%eax),%eax
     a82:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a89:	00 
     a8a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     a91:	00 
     a92:	89 44 24 04          	mov    %eax,0x4(%esp)
     a96:	8b 45 08             	mov    0x8(%ebp),%eax
     a99:	89 04 24             	mov    %eax,(%esp)
     a9c:	e8 77 fe ff ff       	call   918 <printint>
        ap++;
     aa1:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     aa5:	e9 b4 00 00 00       	jmp    b5e <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     aaa:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
     aae:	75 46                	jne    af6 <printf+0x12d>
        s = (char*)*ap;
     ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab3:	8b 00                	mov    (%eax),%eax
     ab5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
     ab8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
     abc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ac0:	75 27                	jne    ae9 <printf+0x120>
          s = "(null)";
     ac2:	c7 45 e4 94 10 00 00 	movl   $0x1094,-0x1c(%ebp)
        while(*s != 0){
     ac9:	eb 1f                	jmp    aea <printf+0x121>
          putc(fd, *s);
     acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ace:	0f b6 00             	movzbl (%eax),%eax
     ad1:	0f be c0             	movsbl %al,%eax
     ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
     ad8:	8b 45 08             	mov    0x8(%ebp),%eax
     adb:	89 04 24             	mov    %eax,(%esp)
     ade:	e8 0d fe ff ff       	call   8f0 <putc>
          s++;
     ae3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     ae7:	eb 01                	jmp    aea <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     ae9:	90                   	nop
     aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     aed:	0f b6 00             	movzbl (%eax),%eax
     af0:	84 c0                	test   %al,%al
     af2:	75 d7                	jne    acb <printf+0x102>
     af4:	eb 68                	jmp    b5e <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     af6:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
     afa:	75 1d                	jne    b19 <printf+0x150>
        putc(fd, *ap);
     afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aff:	8b 00                	mov    (%eax),%eax
     b01:	0f be c0             	movsbl %al,%eax
     b04:	89 44 24 04          	mov    %eax,0x4(%esp)
     b08:	8b 45 08             	mov    0x8(%ebp),%eax
     b0b:	89 04 24             	mov    %eax,(%esp)
     b0e:	e8 dd fd ff ff       	call   8f0 <putc>
        ap++;
     b13:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
     b17:	eb 45                	jmp    b5e <printf+0x195>
      } else if(c == '%'){
     b19:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
     b1d:	75 17                	jne    b36 <printf+0x16d>
        putc(fd, c);
     b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b22:	0f be c0             	movsbl %al,%eax
     b25:	89 44 24 04          	mov    %eax,0x4(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 04 24             	mov    %eax,(%esp)
     b2f:	e8 bc fd ff ff       	call   8f0 <putc>
     b34:	eb 28                	jmp    b5e <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     b36:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     b3d:	00 
     b3e:	8b 45 08             	mov    0x8(%ebp),%eax
     b41:	89 04 24             	mov    %eax,(%esp)
     b44:	e8 a7 fd ff ff       	call   8f0 <putc>
        putc(fd, c);
     b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b4c:	0f be c0             	movsbl %al,%eax
     b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
     b53:	8b 45 08             	mov    0x8(%ebp),%eax
     b56:	89 04 24             	mov    %eax,(%esp)
     b59:	e8 92 fd ff ff       	call   8f0 <putc>
      }
      state = 0;
     b5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     b65:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     b69:	8b 55 0c             	mov    0xc(%ebp),%edx
     b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b6f:	8d 04 02             	lea    (%edx,%eax,1),%eax
     b72:	0f b6 00             	movzbl (%eax),%eax
     b75:	84 c0                	test   %al,%al
     b77:	0f 85 6e fe ff ff    	jne    9eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     b7d:	c9                   	leave  
     b7e:	c3                   	ret    
     b7f:	90                   	nop

00000b80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     b80:	55                   	push   %ebp
     b81:	89 e5                	mov    %esp,%ebp
     b83:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     b86:	8b 45 08             	mov    0x8(%ebp),%eax
     b89:	83 e8 08             	sub    $0x8,%eax
     b8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     b8f:	a1 f0 10 00 00       	mov    0x10f0,%eax
     b94:	89 45 fc             	mov    %eax,-0x4(%ebp)
     b97:	eb 24                	jmp    bbd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     b99:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b9c:	8b 00                	mov    (%eax),%eax
     b9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     ba1:	77 12                	ja     bb5 <free+0x35>
     ba3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ba6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     ba9:	77 24                	ja     bcf <free+0x4f>
     bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bae:	8b 00                	mov    (%eax),%eax
     bb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     bb3:	77 1a                	ja     bcf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bb8:	8b 00                	mov    (%eax),%eax
     bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
     bbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     bc0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     bc3:	76 d4                	jbe    b99 <free+0x19>
     bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bc8:	8b 00                	mov    (%eax),%eax
     bca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     bcd:	76 ca                	jbe    b99 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     bcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
     bd2:	8b 40 04             	mov    0x4(%eax),%eax
     bd5:	c1 e0 03             	shl    $0x3,%eax
     bd8:	89 c2                	mov    %eax,%edx
     bda:	03 55 f8             	add    -0x8(%ebp),%edx
     bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     be0:	8b 00                	mov    (%eax),%eax
     be2:	39 c2                	cmp    %eax,%edx
     be4:	75 24                	jne    c0a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
     be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     be9:	8b 50 04             	mov    0x4(%eax),%edx
     bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bef:	8b 00                	mov    (%eax),%eax
     bf1:	8b 40 04             	mov    0x4(%eax),%eax
     bf4:	01 c2                	add    %eax,%edx
     bf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     bf9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bff:	8b 00                	mov    (%eax),%eax
     c01:	8b 10                	mov    (%eax),%edx
     c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
     c06:	89 10                	mov    %edx,(%eax)
     c08:	eb 0a                	jmp    c14 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
     c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c0d:	8b 10                	mov    (%eax),%edx
     c0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     c12:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c17:	8b 40 04             	mov    0x4(%eax),%eax
     c1a:	c1 e0 03             	shl    $0x3,%eax
     c1d:	03 45 fc             	add    -0x4(%ebp),%eax
     c20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     c23:	75 20                	jne    c45 <free+0xc5>
    p->s.size += bp->s.size;
     c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c28:	8b 50 04             	mov    0x4(%eax),%edx
     c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     c2e:	8b 40 04             	mov    0x4(%eax),%eax
     c31:	01 c2                	add    %eax,%edx
     c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c36:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     c39:	8b 45 f8             	mov    -0x8(%ebp),%eax
     c3c:	8b 10                	mov    (%eax),%edx
     c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c41:	89 10                	mov    %edx,(%eax)
     c43:	eb 08                	jmp    c4d <free+0xcd>
  } else
    p->s.ptr = bp;
     c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c48:	8b 55 f8             	mov    -0x8(%ebp),%edx
     c4b:	89 10                	mov    %edx,(%eax)
  freep = p;
     c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c50:	a3 f0 10 00 00       	mov    %eax,0x10f0
}
     c55:	c9                   	leave  
     c56:	c3                   	ret    

00000c57 <morecore>:

static Header*
morecore(uint nu)
{
     c57:	55                   	push   %ebp
     c58:	89 e5                	mov    %esp,%ebp
     c5a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     c5d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     c64:	77 07                	ja     c6d <morecore+0x16>
    nu = 4096;
     c66:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     c6d:	8b 45 08             	mov    0x8(%ebp),%eax
     c70:	c1 e0 03             	shl    $0x3,%eax
     c73:	89 04 24             	mov    %eax,(%esp)
     c76:	e8 3d fc ff ff       	call   8b8 <sbrk>
     c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
     c7e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
     c82:	75 07                	jne    c8b <morecore+0x34>
    return 0;
     c84:	b8 00 00 00 00       	mov    $0x0,%eax
     c89:	eb 22                	jmp    cad <morecore+0x56>
  hp = (Header*)p;
     c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
     c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c94:	8b 55 08             	mov    0x8(%ebp),%edx
     c97:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9d:	83 c0 08             	add    $0x8,%eax
     ca0:	89 04 24             	mov    %eax,(%esp)
     ca3:	e8 d8 fe ff ff       	call   b80 <free>
  return freep;
     ca8:	a1 f0 10 00 00       	mov    0x10f0,%eax
}
     cad:	c9                   	leave  
     cae:	c3                   	ret    

00000caf <malloc>:

void*
malloc(uint nbytes)
{
     caf:	55                   	push   %ebp
     cb0:	89 e5                	mov    %esp,%ebp
     cb2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     cb5:	8b 45 08             	mov    0x8(%ebp),%eax
     cb8:	83 c0 07             	add    $0x7,%eax
     cbb:	c1 e8 03             	shr    $0x3,%eax
     cbe:	83 c0 01             	add    $0x1,%eax
     cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
     cc4:	a1 f0 10 00 00       	mov    0x10f0,%eax
     cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ccc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cd0:	75 23                	jne    cf5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     cd2:	c7 45 f0 e8 10 00 00 	movl   $0x10e8,-0x10(%ebp)
     cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cdc:	a3 f0 10 00 00       	mov    %eax,0x10f0
     ce1:	a1 f0 10 00 00       	mov    0x10f0,%eax
     ce6:	a3 e8 10 00 00       	mov    %eax,0x10e8
    base.s.size = 0;
     ceb:	c7 05 ec 10 00 00 00 	movl   $0x0,0x10ec
     cf2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cf8:	8b 00                	mov    (%eax),%eax
     cfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
     cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d00:	8b 40 04             	mov    0x4(%eax),%eax
     d03:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     d06:	72 4d                	jb     d55 <malloc+0xa6>
      if(p->s.size == nunits)
     d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d0b:	8b 40 04             	mov    0x4(%eax),%eax
     d0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     d11:	75 0c                	jne    d1f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d16:	8b 10                	mov    (%eax),%edx
     d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d1b:	89 10                	mov    %edx,(%eax)
     d1d:	eb 26                	jmp    d45 <malloc+0x96>
      else {
        p->s.size -= nunits;
     d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d22:	8b 40 04             	mov    0x4(%eax),%eax
     d25:	89 c2                	mov    %eax,%edx
     d27:	2b 55 f4             	sub    -0xc(%ebp),%edx
     d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d2d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d33:	8b 40 04             	mov    0x4(%eax),%eax
     d36:	c1 e0 03             	shl    $0x3,%eax
     d39:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
     d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d42:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d48:	a3 f0 10 00 00       	mov    %eax,0x10f0
      return (void*)(p + 1);
     d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d50:	83 c0 08             	add    $0x8,%eax
     d53:	eb 38                	jmp    d8d <malloc+0xde>
    }
    if(p == freep)
     d55:	a1 f0 10 00 00       	mov    0x10f0,%eax
     d5a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
     d5d:	75 1b                	jne    d7a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d62:	89 04 24             	mov    %eax,(%esp)
     d65:	e8 ed fe ff ff       	call   c57 <morecore>
     d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d71:	75 07                	jne    d7a <malloc+0xcb>
        return 0;
     d73:	b8 00 00 00 00       	mov    $0x0,%eax
     d78:	eb 13                	jmp    d8d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d83:	8b 00                	mov    (%eax),%eax
     d85:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     d88:	e9 70 ff ff ff       	jmp    cfd <malloc+0x4e>
}
     d8d:	c9                   	leave  
     d8e:	c3                   	ret    
     d8f:	90                   	nop

00000d90 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
     d96:	8b 55 08             	mov    0x8(%ebp),%edx
     d99:	8b 45 0c             	mov    0xc(%ebp),%eax
     d9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d9f:	f0 87 02             	lock xchg %eax,(%edx)
     da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
     da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     da8:	c9                   	leave  
     da9:	c3                   	ret    

00000daa <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
     daa:	55                   	push   %ebp
     dab:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
     dad:	8b 45 08             	mov    0x8(%ebp),%eax
     db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
     db6:	5d                   	pop    %ebp
     db7:	c3                   	ret    

00000db8 <lock_acquire>:
void lock_acquire(lock_t *lock){
     db8:	55                   	push   %ebp
     db9:	89 e5                	mov    %esp,%ebp
     dbb:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
     dbe:	8b 45 08             	mov    0x8(%ebp),%eax
     dc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
     dc8:	00 
     dc9:	89 04 24             	mov    %eax,(%esp)
     dcc:	e8 bf ff ff ff       	call   d90 <xchg>
     dd1:	85 c0                	test   %eax,%eax
     dd3:	75 e9                	jne    dbe <lock_acquire+0x6>
}
     dd5:	c9                   	leave  
     dd6:	c3                   	ret    

00000dd7 <lock_release>:
void lock_release(lock_t *lock){
     dd7:	55                   	push   %ebp
     dd8:	89 e5                	mov    %esp,%ebp
     dda:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
     ddd:	8b 45 08             	mov    0x8(%ebp),%eax
     de0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     de7:	00 
     de8:	89 04 24             	mov    %eax,(%esp)
     deb:	e8 a0 ff ff ff       	call   d90 <xchg>
}
     df0:	c9                   	leave  
     df1:	c3                   	ret    

00000df2 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
     df2:	55                   	push   %ebp
     df3:	89 e5                	mov    %esp,%ebp
     df5:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
     df8:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
     dff:	e8 ab fe ff ff       	call   caf <malloc>
     e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
     e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
     e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e10:	25 ff 0f 00 00       	and    $0xfff,%eax
     e15:	85 c0                	test   %eax,%eax
     e17:	74 15                	je     e2e <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
     e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e1c:	89 c2                	mov    %eax,%edx
     e1e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
     e24:	b8 00 10 00 00       	mov    $0x1000,%eax
     e29:	29 d0                	sub    %edx,%eax
     e2b:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
     e2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e32:	75 1b                	jne    e4f <thread_create+0x5d>

        printf(1,"malloc fail \n");
     e34:	c7 44 24 04 9b 10 00 	movl   $0x109b,0x4(%esp)
     e3b:	00 
     e3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e43:	e8 81 fb ff ff       	call   9c9 <printf>
        return 0;
     e48:	b8 00 00 00 00       	mov    $0x0,%eax
     e4d:	eb 6f                	jmp    ebe <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
     e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     e52:	8b 55 08             	mov    0x8(%ebp),%edx
     e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e58:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     e5c:	89 54 24 08          	mov    %edx,0x8(%esp)
     e60:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
     e67:	00 
     e68:	89 04 24             	mov    %eax,(%esp)
     e6b:	e8 60 fa ff ff       	call   8d0 <clone>
     e70:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
     e73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e77:	79 1b                	jns    e94 <thread_create+0xa2>
        printf(1,"clone fails\n");
     e79:	c7 44 24 04 a9 10 00 	movl   $0x10a9,0x4(%esp)
     e80:	00 
     e81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e88:	e8 3c fb ff ff       	call   9c9 <printf>
        return 0;
     e8d:	b8 00 00 00 00       	mov    $0x0,%eax
     e92:	eb 2a                	jmp    ebe <thread_create+0xcc>
    }
    if(tid > 0){
     e94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e98:	7e 05                	jle    e9f <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
     e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e9d:	eb 1f                	jmp    ebe <thread_create+0xcc>
    }
    if(tid == 0){
     e9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ea3:	75 14                	jne    eb9 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
     ea5:	c7 44 24 04 b6 10 00 	movl   $0x10b6,0x4(%esp)
     eac:	00 
     ead:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     eb4:	e8 10 fb ff ff       	call   9c9 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
     eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ebe:	c9                   	leave  
     ebf:	c3                   	ret    

00000ec0 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
     ec3:	a1 dc 10 00 00       	mov    0x10dc,%eax
     ec8:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
     ece:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
     ed3:	a3 dc 10 00 00       	mov    %eax,0x10dc
    return (int)(rands % max);
     ed8:	a1 dc 10 00 00       	mov    0x10dc,%eax
     edd:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ee0:	ba 00 00 00 00       	mov    $0x0,%edx
     ee5:	f7 f1                	div    %ecx
     ee7:	89 d0                	mov    %edx,%eax
}
     ee9:	5d                   	pop    %ebp
     eea:	c3                   	ret    
     eeb:	90                   	nop

00000eec <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
     eec:	55                   	push   %ebp
     eed:	89 e5                	mov    %esp,%ebp
    q->size = 0;
     eef:	8b 45 08             	mov    0x8(%ebp),%eax
     ef2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
     ef8:	8b 45 08             	mov    0x8(%ebp),%eax
     efb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
     f02:	8b 45 08             	mov    0x8(%ebp),%eax
     f05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
     f0c:	5d                   	pop    %ebp
     f0d:	c3                   	ret    

00000f0e <add_q>:

void add_q(struct queue *q, int v){
     f0e:	55                   	push   %ebp
     f0f:	89 e5                	mov    %esp,%ebp
     f11:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
     f14:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     f1b:	e8 8f fd ff ff       	call   caf <malloc>
     f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
     f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
     f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f30:	8b 55 0c             	mov    0xc(%ebp),%edx
     f33:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
     f35:	8b 45 08             	mov    0x8(%ebp),%eax
     f38:	8b 40 04             	mov    0x4(%eax),%eax
     f3b:	85 c0                	test   %eax,%eax
     f3d:	75 0b                	jne    f4a <add_q+0x3c>
        q->head = n;
     f3f:	8b 45 08             	mov    0x8(%ebp),%eax
     f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f45:	89 50 04             	mov    %edx,0x4(%eax)
     f48:	eb 0c                	jmp    f56 <add_q+0x48>
    }else{
        q->tail->next = n;
     f4a:	8b 45 08             	mov    0x8(%ebp),%eax
     f4d:	8b 40 08             	mov    0x8(%eax),%eax
     f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f53:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
     f56:	8b 45 08             	mov    0x8(%ebp),%eax
     f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f5c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
     f5f:	8b 45 08             	mov    0x8(%ebp),%eax
     f62:	8b 00                	mov    (%eax),%eax
     f64:	8d 50 01             	lea    0x1(%eax),%edx
     f67:	8b 45 08             	mov    0x8(%ebp),%eax
     f6a:	89 10                	mov    %edx,(%eax)
}
     f6c:	c9                   	leave  
     f6d:	c3                   	ret    

00000f6e <empty_q>:

int empty_q(struct queue *q){
     f6e:	55                   	push   %ebp
     f6f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
     f71:	8b 45 08             	mov    0x8(%ebp),%eax
     f74:	8b 00                	mov    (%eax),%eax
     f76:	85 c0                	test   %eax,%eax
     f78:	75 07                	jne    f81 <empty_q+0x13>
        return 1;
     f7a:	b8 01 00 00 00       	mov    $0x1,%eax
     f7f:	eb 05                	jmp    f86 <empty_q+0x18>
    else
        return 0;
     f81:	b8 00 00 00 00       	mov    $0x0,%eax
} 
     f86:	5d                   	pop    %ebp
     f87:	c3                   	ret    

00000f88 <pop_q>:
int pop_q(struct queue *q){
     f88:	55                   	push   %ebp
     f89:	89 e5                	mov    %esp,%ebp
     f8b:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
     f8e:	8b 45 08             	mov    0x8(%ebp),%eax
     f91:	89 04 24             	mov    %eax,(%esp)
     f94:	e8 d5 ff ff ff       	call   f6e <empty_q>
     f99:	85 c0                	test   %eax,%eax
     f9b:	75 5d                	jne    ffa <pop_q+0x72>
       val = q->head->value; 
     f9d:	8b 45 08             	mov    0x8(%ebp),%eax
     fa0:	8b 40 04             	mov    0x4(%eax),%eax
     fa3:	8b 00                	mov    (%eax),%eax
     fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
     fa8:	8b 45 08             	mov    0x8(%ebp),%eax
     fab:	8b 40 04             	mov    0x4(%eax),%eax
     fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
     fb1:	8b 45 08             	mov    0x8(%ebp),%eax
     fb4:	8b 40 04             	mov    0x4(%eax),%eax
     fb7:	8b 50 04             	mov    0x4(%eax),%edx
     fba:	8b 45 08             	mov    0x8(%ebp),%eax
     fbd:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
     fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc3:	89 04 24             	mov    %eax,(%esp)
     fc6:	e8 b5 fb ff ff       	call   b80 <free>
       q->size--;
     fcb:	8b 45 08             	mov    0x8(%ebp),%eax
     fce:	8b 00                	mov    (%eax),%eax
     fd0:	8d 50 ff             	lea    -0x1(%eax),%edx
     fd3:	8b 45 08             	mov    0x8(%ebp),%eax
     fd6:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
     fd8:	8b 45 08             	mov    0x8(%ebp),%eax
     fdb:	8b 00                	mov    (%eax),%eax
     fdd:	85 c0                	test   %eax,%eax
     fdf:	75 14                	jne    ff5 <pop_q+0x6d>
            q->head = 0;
     fe1:	8b 45 08             	mov    0x8(%ebp),%eax
     fe4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
     feb:	8b 45 08             	mov    0x8(%ebp),%eax
     fee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
     ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff8:	eb 05                	jmp    fff <pop_q+0x77>
    }
    return -1;
     ffa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     fff:	c9                   	leave  
    1000:	c3                   	ret    
