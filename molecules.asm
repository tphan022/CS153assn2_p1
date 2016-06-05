
_molecules:     file format elf32-i386


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
   f:	e8 28 0d 00 00       	call   d3c <init_q>
  lock_init(&sem->the_lock);
  14:	8b 45 0c             	mov    0xc(%ebp),%eax
  17:	89 04 24             	mov    %eax,(%esp)
  1a:	e8 db 0b 00 00       	call   bfa <lock_init>
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
  36:	e8 cd 0b 00 00       	call   c08 <lock_acquire>
  
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
  5a:	e8 c8 0b 00 00       	call   c27 <lock_release>
    return;
  5f:	eb 27                	jmp    88 <sem_acquire+0x5e>
  }
  else {
    add_q(&sem->qu, getpid());
  61:	e8 9a 06 00 00       	call   700 <getpid>
  66:	8b 55 08             	mov    0x8(%ebp),%edx
  69:	83 c2 08             	add    $0x8,%edx
  6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  70:	89 14 24             	mov    %edx,(%esp)
  73:	e8 e6 0c 00 00       	call   d5e <add_q>
    lock_release(&sem->the_lock);
  78:	8b 45 08             	mov    0x8(%ebp),%eax
  7b:	89 04 24             	mov    %eax,(%esp)
  7e:	e8 a4 0b 00 00       	call   c27 <lock_release>
    tsleep();
  83:	e8 a8 06 00 00       	call   730 <tsleep>
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
  96:	e8 6d 0b 00 00       	call   c08 <lock_acquire>
  
  if(empty_q(&sem->qu) == 1) {
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	83 c0 08             	add    $0x8,%eax
  a1:	89 04 24             	mov    %eax,(%esp)
  a4:	e8 15 0d 00 00       	call   dbe <empty_q>
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
  c8:	e8 0b 0d 00 00       	call   dd8 <pop_q>
  cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tid);
  d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d3:	89 04 24             	mov    %eax,(%esp)
  d6:	e8 5d 06 00 00       	call   738 <twakeup>
  }

  
  lock_release(&sem->the_lock);
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	89 04 24             	mov    %eax,(%esp)
  e1:	e8 41 0b 00 00       	call   c27 <lock_release>

};
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <h_acquire>:

struct mutex {
  lock_t lock;
} mutex;

void h_acquire(void* arg_ptr) {
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 18             	sub    $0x18,%esp
  printf(1, "Hydrogen formed.\n");
  ee:	c7 44 24 04 54 0e 00 	movl   $0xe54,0x4(%esp)
  f5:	00 
  f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fd:	e8 17 07 00 00       	call   819 <printf>
  sem_signal(&h_sem);
 102:	c7 04 24 5c 0f 00 00 	movl   $0xf5c,(%esp)
 109:	e8 7c ff ff ff       	call   8a <sem_signal>
  sem_acquire(&o_sem);
 10e:	c7 04 24 70 0f 00 00 	movl   $0xf70,(%esp)
 115:	e8 10 ff ff ff       	call   2a <sem_acquire>
  texit();
 11a:	e8 09 06 00 00       	call   728 <texit>

0000011f <o_acquire>:
}

void o_acquire(void* arg_ptr) {
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 18             	sub    $0x18,%esp

  printf(1, "Oxygen formed.\n");
 125:	c7 44 24 04 66 0e 00 	movl   $0xe66,0x4(%esp)
 12c:	00 
 12d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 134:	e8 e0 06 00 00       	call   819 <printf>
  sem_acquire(&h_sem);
 139:	c7 04 24 5c 0f 00 00 	movl   $0xf5c,(%esp)
 140:	e8 e5 fe ff ff       	call   2a <sem_acquire>
  sem_acquire(&h_sem);
 145:	c7 04 24 5c 0f 00 00 	movl   $0xf5c,(%esp)
 14c:	e8 d9 fe ff ff       	call   2a <sem_acquire>
  sem_signal(&o_sem);
 151:	c7 04 24 70 0f 00 00 	movl   $0xf70,(%esp)
 158:	e8 2d ff ff ff       	call   8a <sem_signal>
  sem_signal(&o_sem);
 15d:	c7 04 24 70 0f 00 00 	movl   $0xf70,(%esp)
 164:	e8 21 ff ff ff       	call   8a <sem_signal>
  lock_acquire(&mutex.lock);
 169:	c7 04 24 58 0f 00 00 	movl   $0xf58,(%esp)
 170:	e8 93 0a 00 00       	call   c08 <lock_acquire>
  number++;
 175:	a1 48 0f 00 00       	mov    0xf48,%eax
 17a:	83 c0 01             	add    $0x1,%eax
 17d:	a3 48 0f 00 00       	mov    %eax,0xf48
  printf(1, "Atoms combined, molecule has formed.\n");
 182:	c7 44 24 04 78 0e 00 	movl   $0xe78,0x4(%esp)
 189:	00 
 18a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 191:	e8 83 06 00 00       	call   819 <printf>

  lock_release(&mutex.lock);
 196:	c7 04 24 58 0f 00 00 	movl   $0xf58,(%esp)
 19d:	e8 85 0a 00 00       	call   c27 <lock_release>
  texit();
 1a2:	e8 81 05 00 00       	call   728 <texit>

000001a7 <main>:
}

int main(void) {
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	83 e4 f0             	and    $0xfffffff0,%esp
 1ad:	83 ec 40             	sub    $0x40,%esp
  
  initialize_sem(0, &h_sem);
 1b0:	c7 44 24 04 5c 0f 00 	movl   $0xf5c,0x4(%esp)
 1b7:	00 
 1b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bf:	e8 3c fe ff ff       	call   0 <initialize_sem>
  initialize_sem(0, &o_sem);
 1c4:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
 1cb:	00 
 1cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d3:	e8 28 fe ff ff       	call   0 <initialize_sem>
  
  lock_init(&mutex.lock);
 1d8:	c7 04 24 58 0f 00 00 	movl   $0xf58,(%esp)
 1df:	e8 16 0a 00 00       	call   bfa <lock_init>

  printf(1, "program: Molecules, started\n");
 1e4:	c7 44 24 04 9e 0e 00 	movl   $0xe9e,0x4(%esp)
 1eb:	00 
 1ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f3:	e8 21 06 00 00       	call   819 <printf>

  void* tid_1 = thread_create(h_acquire, (void*) 0);
 1f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ff:	00 
 200:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
 207:	e8 36 0a 00 00       	call   c42 <thread_create>
 20c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  if(tid_1 == 0) {
 210:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 215:	75 19                	jne    230 <main+0x89>
    printf(1, "Error, thread creation failed.\n");
 217:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 21e:	00 
 21f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 226:	e8 ee 05 00 00       	call   819 <printf>
    exit();
 22b:	e8 50 04 00 00       	call   680 <exit>
  }
  void* tid_2 = thread_create(h_acquire, (void*) 0);
 230:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 237:	00 
 238:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
 23f:	e8 fe 09 00 00       	call   c42 <thread_create>
 244:	89 44 24 20          	mov    %eax,0x20(%esp)
  if(tid_2 == 0) {
 248:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
 24d:	75 19                	jne    268 <main+0xc1>
    printf(1, "Error, thread creation failed.\n");
 24f:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 256:	00 
 257:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25e:	e8 b6 05 00 00       	call   819 <printf>
    exit();
 263:	e8 18 04 00 00       	call   680 <exit>
  }
  void* tid_3 = thread_create(o_acquire, (void*) 0);
 268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 26f:	00 
 270:	c7 04 24 1f 01 00 00 	movl   $0x11f,(%esp)
 277:	e8 c6 09 00 00       	call   c42 <thread_create>
 27c:	89 44 24 24          	mov    %eax,0x24(%esp)
  if(tid_3 == 0) {
 280:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 285:	75 19                	jne    2a0 <main+0xf9>
    printf(1, "Error, thread creation failed.\n");
 287:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 28e:	00 
 28f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 296:	e8 7e 05 00 00       	call   819 <printf>
    exit();
 29b:	e8 e0 03 00 00       	call   680 <exit>
  }
  void* tid_4 = thread_create(o_acquire, (void*) 0);
 2a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a7:	00 
 2a8:	c7 04 24 1f 01 00 00 	movl   $0x11f,(%esp)
 2af:	e8 8e 09 00 00       	call   c42 <thread_create>
 2b4:	89 44 24 28          	mov    %eax,0x28(%esp)
  if(tid_4 == 0) {
 2b8:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
 2bd:	75 19                	jne    2d8 <main+0x131>
    printf(1, "Error, thread creation failed.\n");
 2bf:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 2c6:	00 
 2c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ce:	e8 46 05 00 00       	call   819 <printf>
    exit();
 2d3:	e8 a8 03 00 00       	call   680 <exit>
  }
  void* tid_5 = thread_create(h_acquire, (void*) 0);
 2d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2df:	00 
 2e0:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
 2e7:	e8 56 09 00 00       	call   c42 <thread_create>
 2ec:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  if(tid_5 == 0) {
 2f0:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
 2f5:	75 19                	jne    310 <main+0x169>
    printf(1, "Error, thread creation failed.\n");
 2f7:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 2fe:	00 
 2ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 306:	e8 0e 05 00 00       	call   819 <printf>
    exit();
 30b:	e8 70 03 00 00       	call   680 <exit>
  }
  void* tid_6 = thread_create(h_acquire, (void*) 0);
 310:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 317:	00 
 318:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
 31f:	e8 1e 09 00 00       	call   c42 <thread_create>
 324:	89 44 24 30          	mov    %eax,0x30(%esp)
  if(tid_6 == 0) {
 328:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
 32d:	75 19                	jne    348 <main+0x1a1>
    printf(1, "Error, thread creation failed.\n");
 32f:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 336:	00 
 337:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 33e:	e8 d6 04 00 00       	call   819 <printf>
    exit();
 343:	e8 38 03 00 00       	call   680 <exit>
  }
  void* tid_7 = thread_create(h_acquire, (void*) 0);
 348:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 34f:	00 
 350:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
 357:	e8 e6 08 00 00       	call   c42 <thread_create>
 35c:	89 44 24 34          	mov    %eax,0x34(%esp)
  if(tid_7 == 0) {
 360:	83 7c 24 34 00       	cmpl   $0x0,0x34(%esp)
 365:	75 19                	jne    380 <main+0x1d9>
    printf(1, "Error, thread creation failed.\n");
 367:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 36e:	00 
 36f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 376:	e8 9e 04 00 00       	call   819 <printf>
    exit();
 37b:	e8 00 03 00 00       	call   680 <exit>
  }
  void* tid_8 = thread_create(o_acquire, (void*) 0);
 380:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 387:	00 
 388:	c7 04 24 1f 01 00 00 	movl   $0x11f,(%esp)
 38f:	e8 ae 08 00 00       	call   c42 <thread_create>
 394:	89 44 24 38          	mov    %eax,0x38(%esp)
  if(tid_8 == 0) {
 398:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
 39d:	75 19                	jne    3b8 <main+0x211>
    printf(1, "Error, thread creation failed.\n");
 39f:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 3a6:	00 
 3a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ae:	e8 66 04 00 00       	call   819 <printf>
    exit();
 3b3:	e8 c8 02 00 00       	call   680 <exit>
  }
  void* tid_9 = thread_create(h_acquire, (void*) 0);
 3b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3bf:	00 
 3c0:	c7 04 24 e8 00 00 00 	movl   $0xe8,(%esp)
 3c7:	e8 76 08 00 00       	call   c42 <thread_create>
 3cc:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  if(tid_9 == 0) {
 3d0:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
 3d5:	75 19                	jne    3f0 <main+0x249>
    printf(1, "Error, thread creation failed.\n");
 3d7:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 3de:	00 
 3df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3e6:	e8 2e 04 00 00       	call   819 <printf>
    exit();
 3eb:	e8 90 02 00 00       	call   680 <exit>
  }

  while(wait() > 0);
 3f0:	e8 93 02 00 00       	call   688 <wait>
 3f5:	85 c0                	test   %eax,%eax
 3f7:	7f f7                	jg     3f0 <main+0x249>

  printf(1, "number of molecules formed: %d\n", number);
 3f9:	a1 48 0f 00 00       	mov    0xf48,%eax
 3fe:	89 44 24 08          	mov    %eax,0x8(%esp)
 402:	c7 44 24 04 dc 0e 00 	movl   $0xedc,0x4(%esp)
 409:	00 
 40a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 411:	e8 03 04 00 00       	call   819 <printf>
   
  
  exit();
 416:	e8 65 02 00 00       	call   680 <exit>
 41b:	90                   	nop

0000041c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	57                   	push   %edi
 420:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 421:	8b 4d 08             	mov    0x8(%ebp),%ecx
 424:	8b 55 10             	mov    0x10(%ebp),%edx
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	89 cb                	mov    %ecx,%ebx
 42c:	89 df                	mov    %ebx,%edi
 42e:	89 d1                	mov    %edx,%ecx
 430:	fc                   	cld    
 431:	f3 aa                	rep stos %al,%es:(%edi)
 433:	89 ca                	mov    %ecx,%edx
 435:	89 fb                	mov    %edi,%ebx
 437:	89 5d 08             	mov    %ebx,0x8(%ebp)
 43a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 43d:	5b                   	pop    %ebx
 43e:	5f                   	pop    %edi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret    

00000441 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 441:	55                   	push   %ebp
 442:	89 e5                	mov    %esp,%ebp
 444:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	0f b6 10             	movzbl (%eax),%edx
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	88 10                	mov    %dl,(%eax)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	0f b6 00             	movzbl (%eax),%eax
 45e:	84 c0                	test   %al,%al
 460:	0f 95 c0             	setne  %al
 463:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 467:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 46b:	84 c0                	test   %al,%al
 46d:	75 de                	jne    44d <strcpy+0xc>
    ;
  return os;
 46f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 477:	eb 08                	jmp    481 <strcmp+0xd>
    p++, q++;
 479:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 47d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	84 c0                	test   %al,%al
 489:	74 10                	je     49b <strcmp+0x27>
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	0f b6 10             	movzbl (%eax),%edx
 491:	8b 45 0c             	mov    0xc(%ebp),%eax
 494:	0f b6 00             	movzbl (%eax),%eax
 497:	38 c2                	cmp    %al,%dl
 499:	74 de                	je     479 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	0f b6 00             	movzbl (%eax),%eax
 4a1:	0f b6 d0             	movzbl %al,%edx
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	0f b6 c0             	movzbl %al,%eax
 4ad:	89 d1                	mov    %edx,%ecx
 4af:	29 c1                	sub    %eax,%ecx
 4b1:	89 c8                	mov    %ecx,%eax
}
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    

000004b5 <strlen>:

uint
strlen(char *s)
{
 4b5:	55                   	push   %ebp
 4b6:	89 e5                	mov    %esp,%ebp
 4b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4c2:	eb 04                	jmp    4c8 <strlen+0x13>
 4c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4cb:	03 45 08             	add    0x8(%ebp),%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	84 c0                	test   %al,%al
 4d3:	75 ef                	jne    4c4 <strlen+0xf>
    ;
  return n;
 4d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d8:	c9                   	leave  
 4d9:	c3                   	ret    

000004da <memset>:

void*
memset(void *dst, int c, uint n)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 4e0:	8b 45 10             	mov    0x10(%ebp),%eax
 4e3:	89 44 24 08          	mov    %eax,0x8(%esp)
 4e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 23 ff ff ff       	call   41c <stosb>
  return dst;
 4f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fc:	c9                   	leave  
 4fd:	c3                   	ret    

000004fe <strchr>:

char*
strchr(const char *s, char c)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	83 ec 04             	sub    $0x4,%esp
 504:	8b 45 0c             	mov    0xc(%ebp),%eax
 507:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 50a:	eb 14                	jmp    520 <strchr+0x22>
    if(*s == c)
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	0f b6 00             	movzbl (%eax),%eax
 512:	3a 45 fc             	cmp    -0x4(%ebp),%al
 515:	75 05                	jne    51c <strchr+0x1e>
      return (char*)s;
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	eb 13                	jmp    52f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 51c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	0f b6 00             	movzbl (%eax),%eax
 526:	84 c0                	test   %al,%al
 528:	75 e2                	jne    50c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 52a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 52f:	c9                   	leave  
 530:	c3                   	ret    

00000531 <gets>:

char*
gets(char *buf, int max)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 537:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53e:	eb 44                	jmp    584 <gets+0x53>
    cc = read(0, &c, 1);
 540:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 547:	00 
 548:	8d 45 ef             	lea    -0x11(%ebp),%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 556:	e8 3d 01 00 00       	call   698 <read>
 55b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 55e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 562:	7e 2d                	jle    591 <gets+0x60>
      break;
    buf[i++] = c;
 564:	8b 45 f0             	mov    -0x10(%ebp),%eax
 567:	03 45 08             	add    0x8(%ebp),%eax
 56a:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 56e:	88 10                	mov    %dl,(%eax)
 570:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 574:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 578:	3c 0a                	cmp    $0xa,%al
 57a:	74 16                	je     592 <gets+0x61>
 57c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 580:	3c 0d                	cmp    $0xd,%al
 582:	74 0e                	je     592 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 584:	8b 45 f0             	mov    -0x10(%ebp),%eax
 587:	83 c0 01             	add    $0x1,%eax
 58a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 58d:	7c b1                	jl     540 <gets+0xf>
 58f:	eb 01                	jmp    592 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 591:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 592:	8b 45 f0             	mov    -0x10(%ebp),%eax
 595:	03 45 08             	add    0x8(%ebp),%eax
 598:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 59e:	c9                   	leave  
 59f:	c3                   	ret    

000005a0 <stat>:

int
stat(char *n, struct stat *st)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5ad:	00 
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 07 01 00 00       	call   6c0 <open>
 5b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 5bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c0:	79 07                	jns    5c9 <stat+0x29>
    return -1;
 5c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5c7:	eb 23                	jmp    5ec <stat+0x4c>
  r = fstat(fd, st);
 5c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 fd 00 00 00       	call   6d8 <fstat>
 5db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 5de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e1:	89 04 24             	mov    %eax,(%esp)
 5e4:	e8 bf 00 00 00       	call   6a8 <close>
  return r;
 5e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 5ec:	c9                   	leave  
 5ed:	c3                   	ret    

000005ee <atoi>:

int
atoi(const char *s)
{
 5ee:	55                   	push   %ebp
 5ef:	89 e5                	mov    %esp,%ebp
 5f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 5f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5fb:	eb 24                	jmp    621 <atoi+0x33>
    n = n*10 + *s++ - '0';
 5fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 600:	89 d0                	mov    %edx,%eax
 602:	c1 e0 02             	shl    $0x2,%eax
 605:	01 d0                	add    %edx,%eax
 607:	01 c0                	add    %eax,%eax
 609:	89 c2                	mov    %eax,%edx
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	0f be c0             	movsbl %al,%eax
 614:	8d 04 02             	lea    (%edx,%eax,1),%eax
 617:	83 e8 30             	sub    $0x30,%eax
 61a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	0f b6 00             	movzbl (%eax),%eax
 627:	3c 2f                	cmp    $0x2f,%al
 629:	7e 0a                	jle    635 <atoi+0x47>
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	0f b6 00             	movzbl (%eax),%eax
 631:	3c 39                	cmp    $0x39,%al
 633:	7e c8                	jle    5fd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 638:	c9                   	leave  
 639:	c3                   	ret    

0000063a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 63a:	55                   	push   %ebp
 63b:	89 e5                	mov    %esp,%ebp
 63d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 646:	8b 45 0c             	mov    0xc(%ebp),%eax
 649:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 64c:	eb 13                	jmp    661 <memmove+0x27>
    *dst++ = *src++;
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	0f b6 10             	movzbl (%eax),%edx
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	88 10                	mov    %dl,(%eax)
 659:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 65d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 661:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 665:	0f 9f c0             	setg   %al
 668:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 66c:	84 c0                	test   %al,%al
 66e:	75 de                	jne    64e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 670:	8b 45 08             	mov    0x8(%ebp),%eax
}
 673:	c9                   	leave  
 674:	c3                   	ret    
 675:	90                   	nop
 676:	90                   	nop
 677:	90                   	nop

00000678 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 678:	b8 01 00 00 00       	mov    $0x1,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <exit>:
SYSCALL(exit)
 680:	b8 02 00 00 00       	mov    $0x2,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <wait>:
SYSCALL(wait)
 688:	b8 03 00 00 00       	mov    $0x3,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <pipe>:
SYSCALL(pipe)
 690:	b8 04 00 00 00       	mov    $0x4,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <read>:
SYSCALL(read)
 698:	b8 05 00 00 00       	mov    $0x5,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <write>:
SYSCALL(write)
 6a0:	b8 10 00 00 00       	mov    $0x10,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <close>:
SYSCALL(close)
 6a8:	b8 15 00 00 00       	mov    $0x15,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <kill>:
SYSCALL(kill)
 6b0:	b8 06 00 00 00       	mov    $0x6,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <exec>:
SYSCALL(exec)
 6b8:	b8 07 00 00 00       	mov    $0x7,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <open>:
SYSCALL(open)
 6c0:	b8 0f 00 00 00       	mov    $0xf,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <mknod>:
SYSCALL(mknod)
 6c8:	b8 11 00 00 00       	mov    $0x11,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <unlink>:
SYSCALL(unlink)
 6d0:	b8 12 00 00 00       	mov    $0x12,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <fstat>:
SYSCALL(fstat)
 6d8:	b8 08 00 00 00       	mov    $0x8,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <link>:
SYSCALL(link)
 6e0:	b8 13 00 00 00       	mov    $0x13,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <mkdir>:
SYSCALL(mkdir)
 6e8:	b8 14 00 00 00       	mov    $0x14,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <chdir>:
SYSCALL(chdir)
 6f0:	b8 09 00 00 00       	mov    $0x9,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <dup>:
SYSCALL(dup)
 6f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <getpid>:
SYSCALL(getpid)
 700:	b8 0b 00 00 00       	mov    $0xb,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <sbrk>:
SYSCALL(sbrk)
 708:	b8 0c 00 00 00       	mov    $0xc,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <sleep>:
SYSCALL(sleep)
 710:	b8 0d 00 00 00       	mov    $0xd,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <uptime>:
SYSCALL(uptime)
 718:	b8 0e 00 00 00       	mov    $0xe,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <clone>:
SYSCALL(clone)
 720:	b8 16 00 00 00       	mov    $0x16,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <texit>:
SYSCALL(texit)
 728:	b8 17 00 00 00       	mov    $0x17,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <tsleep>:
SYSCALL(tsleep)
 730:	b8 18 00 00 00       	mov    $0x18,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <twakeup>:
SYSCALL(twakeup)
 738:	b8 19 00 00 00       	mov    $0x19,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 28             	sub    $0x28,%esp
 746:	8b 45 0c             	mov    0xc(%ebp),%eax
 749:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 74c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 753:	00 
 754:	8d 45 f4             	lea    -0xc(%ebp),%eax
 757:	89 44 24 04          	mov    %eax,0x4(%esp)
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	89 04 24             	mov    %eax,(%esp)
 761:	e8 3a ff ff ff       	call   6a0 <write>
}
 766:	c9                   	leave  
 767:	c3                   	ret    

00000768 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 768:	55                   	push   %ebp
 769:	89 e5                	mov    %esp,%ebp
 76b:	53                   	push   %ebx
 76c:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 76f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 776:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 77a:	74 17                	je     793 <printint+0x2b>
 77c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 780:	79 11                	jns    793 <printint+0x2b>
    neg = 1;
 782:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 789:	8b 45 0c             	mov    0xc(%ebp),%eax
 78c:	f7 d8                	neg    %eax
 78e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 791:	eb 06                	jmp    799 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 793:	8b 45 0c             	mov    0xc(%ebp),%eax
 796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 799:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 7a0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 7a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	ba 00 00 00 00       	mov    $0x0,%edx
 7ae:	f7 f3                	div    %ebx
 7b0:	89 d0                	mov    %edx,%eax
 7b2:	0f b6 80 30 0f 00 00 	movzbl 0xf30(%eax),%eax
 7b9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 7bd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 7c1:	8b 45 10             	mov    0x10(%ebp),%eax
 7c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	ba 00 00 00 00       	mov    $0x0,%edx
 7cf:	f7 75 d4             	divl   -0x2c(%ebp)
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d9:	75 c5                	jne    7a0 <printint+0x38>
  if(neg)
 7db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7df:	74 28                	je     809 <printint+0xa1>
    buf[i++] = '-';
 7e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 7e9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 7ed:	eb 1a                	jmp    809 <printint+0xa1>
    putc(fd, buf[i]);
 7ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f2:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 7f7:	0f be c0             	movsbl %al,%eax
 7fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	89 04 24             	mov    %eax,(%esp)
 804:	e8 37 ff ff ff       	call   740 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 809:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 80d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 811:	79 dc                	jns    7ef <printint+0x87>
    putc(fd, buf[i]);
}
 813:	83 c4 44             	add    $0x44,%esp
 816:	5b                   	pop    %ebx
 817:	5d                   	pop    %ebp
 818:	c3                   	ret    

00000819 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 819:	55                   	push   %ebp
 81a:	89 e5                	mov    %esp,%ebp
 81c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 81f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 826:	8d 45 0c             	lea    0xc(%ebp),%eax
 829:	83 c0 04             	add    $0x4,%eax
 82c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 82f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 836:	e9 7e 01 00 00       	jmp    9b9 <printf+0x1a0>
    c = fmt[i] & 0xff;
 83b:	8b 55 0c             	mov    0xc(%ebp),%edx
 83e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 841:	8d 04 02             	lea    (%edx,%eax,1),%eax
 844:	0f b6 00             	movzbl (%eax),%eax
 847:	0f be c0             	movsbl %al,%eax
 84a:	25 ff 00 00 00       	and    $0xff,%eax
 84f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 852:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 856:	75 2c                	jne    884 <printf+0x6b>
      if(c == '%'){
 858:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 85c:	75 0c                	jne    86a <printf+0x51>
        state = '%';
 85e:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 865:	e9 4b 01 00 00       	jmp    9b5 <printf+0x19c>
      } else {
        putc(fd, c);
 86a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86d:	0f be c0             	movsbl %al,%eax
 870:	89 44 24 04          	mov    %eax,0x4(%esp)
 874:	8b 45 08             	mov    0x8(%ebp),%eax
 877:	89 04 24             	mov    %eax,(%esp)
 87a:	e8 c1 fe ff ff       	call   740 <putc>
 87f:	e9 31 01 00 00       	jmp    9b5 <printf+0x19c>
      }
    } else if(state == '%'){
 884:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 888:	0f 85 27 01 00 00    	jne    9b5 <printf+0x19c>
      if(c == 'd'){
 88e:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 892:	75 2d                	jne    8c1 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8a0:	00 
 8a1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8a8:	00 
 8a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ad:	8b 45 08             	mov    0x8(%ebp),%eax
 8b0:	89 04 24             	mov    %eax,(%esp)
 8b3:	e8 b0 fe ff ff       	call   768 <printint>
        ap++;
 8b8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 8bc:	e9 ed 00 00 00       	jmp    9ae <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 8c1:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 8c5:	74 06                	je     8cd <printf+0xb4>
 8c7:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 8cb:	75 2d                	jne    8fa <printf+0xe1>
        printint(fd, *ap, 16, 0);
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8d9:	00 
 8da:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8e1:	00 
 8e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e6:	8b 45 08             	mov    0x8(%ebp),%eax
 8e9:	89 04 24             	mov    %eax,(%esp)
 8ec:	e8 77 fe ff ff       	call   768 <printint>
        ap++;
 8f1:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 8f5:	e9 b4 00 00 00       	jmp    9ae <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 8fa:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 8fe:	75 46                	jne    946 <printf+0x12d>
        s = (char*)*ap;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 908:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 90c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 910:	75 27                	jne    939 <printf+0x120>
          s = "(null)";
 912:	c7 45 e4 fc 0e 00 00 	movl   $0xefc,-0x1c(%ebp)
        while(*s != 0){
 919:	eb 1f                	jmp    93a <printf+0x121>
          putc(fd, *s);
 91b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 91e:	0f b6 00             	movzbl (%eax),%eax
 921:	0f be c0             	movsbl %al,%eax
 924:	89 44 24 04          	mov    %eax,0x4(%esp)
 928:	8b 45 08             	mov    0x8(%ebp),%eax
 92b:	89 04 24             	mov    %eax,(%esp)
 92e:	e8 0d fe ff ff       	call   740 <putc>
          s++;
 933:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 937:	eb 01                	jmp    93a <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 939:	90                   	nop
 93a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 93d:	0f b6 00             	movzbl (%eax),%eax
 940:	84 c0                	test   %al,%al
 942:	75 d7                	jne    91b <printf+0x102>
 944:	eb 68                	jmp    9ae <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 946:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 94a:	75 1d                	jne    969 <printf+0x150>
        putc(fd, *ap);
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	0f be c0             	movsbl %al,%eax
 954:	89 44 24 04          	mov    %eax,0x4(%esp)
 958:	8b 45 08             	mov    0x8(%ebp),%eax
 95b:	89 04 24             	mov    %eax,(%esp)
 95e:	e8 dd fd ff ff       	call   740 <putc>
        ap++;
 963:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 967:	eb 45                	jmp    9ae <printf+0x195>
      } else if(c == '%'){
 969:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 96d:	75 17                	jne    986 <printf+0x16d>
        putc(fd, c);
 96f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 972:	0f be c0             	movsbl %al,%eax
 975:	89 44 24 04          	mov    %eax,0x4(%esp)
 979:	8b 45 08             	mov    0x8(%ebp),%eax
 97c:	89 04 24             	mov    %eax,(%esp)
 97f:	e8 bc fd ff ff       	call   740 <putc>
 984:	eb 28                	jmp    9ae <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 986:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 98d:	00 
 98e:	8b 45 08             	mov    0x8(%ebp),%eax
 991:	89 04 24             	mov    %eax,(%esp)
 994:	e8 a7 fd ff ff       	call   740 <putc>
        putc(fd, c);
 999:	8b 45 e8             	mov    -0x18(%ebp),%eax
 99c:	0f be c0             	movsbl %al,%eax
 99f:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	89 04 24             	mov    %eax,(%esp)
 9a9:	e8 92 fd ff ff       	call   740 <putc>
      }
      state = 0;
 9ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9b5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 9b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 9bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9bf:	8d 04 02             	lea    (%edx,%eax,1),%eax
 9c2:	0f b6 00             	movzbl (%eax),%eax
 9c5:	84 c0                	test   %al,%al
 9c7:	0f 85 6e fe ff ff    	jne    83b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9cd:	c9                   	leave  
 9ce:	c3                   	ret    
 9cf:	90                   	nop

000009d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	83 e8 08             	sub    $0x8,%eax
 9dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9df:	a1 54 0f 00 00       	mov    0xf54,%eax
 9e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9e7:	eb 24                	jmp    a0d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ec:	8b 00                	mov    (%eax),%eax
 9ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9f1:	77 12                	ja     a05 <free+0x35>
 9f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9f9:	77 24                	ja     a1f <free+0x4f>
 9fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fe:	8b 00                	mov    (%eax),%eax
 a00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a03:	77 1a                	ja     a1f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	8b 00                	mov    (%eax),%eax
 a0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a10:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a13:	76 d4                	jbe    9e9 <free+0x19>
 a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a18:	8b 00                	mov    (%eax),%eax
 a1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a1d:	76 ca                	jbe    9e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a22:	8b 40 04             	mov    0x4(%eax),%eax
 a25:	c1 e0 03             	shl    $0x3,%eax
 a28:	89 c2                	mov    %eax,%edx
 a2a:	03 55 f8             	add    -0x8(%ebp),%edx
 a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a30:	8b 00                	mov    (%eax),%eax
 a32:	39 c2                	cmp    %eax,%edx
 a34:	75 24                	jne    a5a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 a36:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a39:	8b 50 04             	mov    0x4(%eax),%edx
 a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3f:	8b 00                	mov    (%eax),%eax
 a41:	8b 40 04             	mov    0x4(%eax),%eax
 a44:	01 c2                	add    %eax,%edx
 a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a49:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4f:	8b 00                	mov    (%eax),%eax
 a51:	8b 10                	mov    (%eax),%edx
 a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a56:	89 10                	mov    %edx,(%eax)
 a58:	eb 0a                	jmp    a64 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5d:	8b 10                	mov    (%eax),%edx
 a5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a62:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a67:	8b 40 04             	mov    0x4(%eax),%eax
 a6a:	c1 e0 03             	shl    $0x3,%eax
 a6d:	03 45 fc             	add    -0x4(%ebp),%eax
 a70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a73:	75 20                	jne    a95 <free+0xc5>
    p->s.size += bp->s.size;
 a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a78:	8b 50 04             	mov    0x4(%eax),%edx
 a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7e:	8b 40 04             	mov    0x4(%eax),%eax
 a81:	01 c2                	add    %eax,%edx
 a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a86:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a8c:	8b 10                	mov    (%eax),%edx
 a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a91:	89 10                	mov    %edx,(%eax)
 a93:	eb 08                	jmp    a9d <free+0xcd>
  } else
    p->s.ptr = bp;
 a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a98:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a9b:	89 10                	mov    %edx,(%eax)
  freep = p;
 a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa0:	a3 54 0f 00 00       	mov    %eax,0xf54
}
 aa5:	c9                   	leave  
 aa6:	c3                   	ret    

00000aa7 <morecore>:

static Header*
morecore(uint nu)
{
 aa7:	55                   	push   %ebp
 aa8:	89 e5                	mov    %esp,%ebp
 aaa:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 aad:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ab4:	77 07                	ja     abd <morecore+0x16>
    nu = 4096;
 ab6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 abd:	8b 45 08             	mov    0x8(%ebp),%eax
 ac0:	c1 e0 03             	shl    $0x3,%eax
 ac3:	89 04 24             	mov    %eax,(%esp)
 ac6:	e8 3d fc ff ff       	call   708 <sbrk>
 acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 ace:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 ad2:	75 07                	jne    adb <morecore+0x34>
    return 0;
 ad4:	b8 00 00 00 00       	mov    $0x0,%eax
 ad9:	eb 22                	jmp    afd <morecore+0x56>
  hp = (Header*)p;
 adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae4:	8b 55 08             	mov    0x8(%ebp),%edx
 ae7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	83 c0 08             	add    $0x8,%eax
 af0:	89 04 24             	mov    %eax,(%esp)
 af3:	e8 d8 fe ff ff       	call   9d0 <free>
  return freep;
 af8:	a1 54 0f 00 00       	mov    0xf54,%eax
}
 afd:	c9                   	leave  
 afe:	c3                   	ret    

00000aff <malloc>:

void*
malloc(uint nbytes)
{
 aff:	55                   	push   %ebp
 b00:	89 e5                	mov    %esp,%ebp
 b02:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b05:	8b 45 08             	mov    0x8(%ebp),%eax
 b08:	83 c0 07             	add    $0x7,%eax
 b0b:	c1 e8 03             	shr    $0x3,%eax
 b0e:	83 c0 01             	add    $0x1,%eax
 b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 b14:	a1 54 0f 00 00       	mov    0xf54,%eax
 b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b20:	75 23                	jne    b45 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b22:	c7 45 f0 4c 0f 00 00 	movl   $0xf4c,-0x10(%ebp)
 b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2c:	a3 54 0f 00 00       	mov    %eax,0xf54
 b31:	a1 54 0f 00 00       	mov    0xf54,%eax
 b36:	a3 4c 0f 00 00       	mov    %eax,0xf4c
    base.s.size = 0;
 b3b:	c7 05 50 0f 00 00 00 	movl   $0x0,0xf50
 b42:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b48:	8b 00                	mov    (%eax),%eax
 b4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b50:	8b 40 04             	mov    0x4(%eax),%eax
 b53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 b56:	72 4d                	jb     ba5 <malloc+0xa6>
      if(p->s.size == nunits)
 b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b5b:	8b 40 04             	mov    0x4(%eax),%eax
 b5e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 b61:	75 0c                	jne    b6f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b66:	8b 10                	mov    (%eax),%edx
 b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6b:	89 10                	mov    %edx,(%eax)
 b6d:	eb 26                	jmp    b95 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b72:	8b 40 04             	mov    0x4(%eax),%eax
 b75:	89 c2                	mov    %eax,%edx
 b77:	2b 55 f4             	sub    -0xc(%ebp),%edx
 b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b7d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b83:	8b 40 04             	mov    0x4(%eax),%eax
 b86:	c1 e0 03             	shl    $0x3,%eax
 b89:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b92:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b98:	a3 54 0f 00 00       	mov    %eax,0xf54
      return (void*)(p + 1);
 b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ba0:	83 c0 08             	add    $0x8,%eax
 ba3:	eb 38                	jmp    bdd <malloc+0xde>
    }
    if(p == freep)
 ba5:	a1 54 0f 00 00       	mov    0xf54,%eax
 baa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 bad:	75 1b                	jne    bca <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb2:	89 04 24             	mov    %eax,(%esp)
 bb5:	e8 ed fe ff ff       	call   aa7 <morecore>
 bba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 bbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bc1:	75 07                	jne    bca <malloc+0xcb>
        return 0;
 bc3:	b8 00 00 00 00       	mov    $0x0,%eax
 bc8:	eb 13                	jmp    bdd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bd3:	8b 00                	mov    (%eax),%eax
 bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bd8:	e9 70 ff ff ff       	jmp    b4d <malloc+0x4e>
}
 bdd:	c9                   	leave  
 bde:	c3                   	ret    
 bdf:	90                   	nop

00000be0 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 be0:	55                   	push   %ebp
 be1:	89 e5                	mov    %esp,%ebp
 be3:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 be6:	8b 55 08             	mov    0x8(%ebp),%edx
 be9:	8b 45 0c             	mov    0xc(%ebp),%eax
 bec:	8b 4d 08             	mov    0x8(%ebp),%ecx
 bef:	f0 87 02             	lock xchg %eax,(%edx)
 bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 bf8:	c9                   	leave  
 bf9:	c3                   	ret    

00000bfa <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 bfa:	55                   	push   %ebp
 bfb:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 bfd:	8b 45 08             	mov    0x8(%ebp),%eax
 c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 c06:	5d                   	pop    %ebp
 c07:	c3                   	ret    

00000c08 <lock_acquire>:
void lock_acquire(lock_t *lock){
 c08:	55                   	push   %ebp
 c09:	89 e5                	mov    %esp,%ebp
 c0b:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 c0e:	8b 45 08             	mov    0x8(%ebp),%eax
 c11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 c18:	00 
 c19:	89 04 24             	mov    %eax,(%esp)
 c1c:	e8 bf ff ff ff       	call   be0 <xchg>
 c21:	85 c0                	test   %eax,%eax
 c23:	75 e9                	jne    c0e <lock_acquire+0x6>
}
 c25:	c9                   	leave  
 c26:	c3                   	ret    

00000c27 <lock_release>:
void lock_release(lock_t *lock){
 c27:	55                   	push   %ebp
 c28:	89 e5                	mov    %esp,%ebp
 c2a:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 c2d:	8b 45 08             	mov    0x8(%ebp),%eax
 c30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 c37:	00 
 c38:	89 04 24             	mov    %eax,(%esp)
 c3b:	e8 a0 ff ff ff       	call   be0 <xchg>
}
 c40:	c9                   	leave  
 c41:	c3                   	ret    

00000c42 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 c42:	55                   	push   %ebp
 c43:	89 e5                	mov    %esp,%ebp
 c45:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 c48:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 c4f:	e8 ab fe ff ff       	call   aff <malloc>
 c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c60:	25 ff 0f 00 00       	and    $0xfff,%eax
 c65:	85 c0                	test   %eax,%eax
 c67:	74 15                	je     c7e <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c6c:	89 c2                	mov    %eax,%edx
 c6e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 c74:	b8 00 10 00 00       	mov    $0x1000,%eax
 c79:	29 d0                	sub    %edx,%eax
 c7b:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c82:	75 1b                	jne    c9f <thread_create+0x5d>

        printf(1,"malloc fail \n");
 c84:	c7 44 24 04 03 0f 00 	movl   $0xf03,0x4(%esp)
 c8b:	00 
 c8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c93:	e8 81 fb ff ff       	call   819 <printf>
        return 0;
 c98:	b8 00 00 00 00       	mov    $0x0,%eax
 c9d:	eb 6f                	jmp    d0e <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 ca2:	8b 55 08             	mov    0x8(%ebp),%edx
 ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 cac:	89 54 24 08          	mov    %edx,0x8(%esp)
 cb0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 cb7:	00 
 cb8:	89 04 24             	mov    %eax,(%esp)
 cbb:	e8 60 fa ff ff       	call   720 <clone>
 cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 cc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 cc7:	79 1b                	jns    ce4 <thread_create+0xa2>
        printf(1,"clone fails\n");
 cc9:	c7 44 24 04 11 0f 00 	movl   $0xf11,0x4(%esp)
 cd0:	00 
 cd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cd8:	e8 3c fb ff ff       	call   819 <printf>
        return 0;
 cdd:	b8 00 00 00 00       	mov    $0x0,%eax
 ce2:	eb 2a                	jmp    d0e <thread_create+0xcc>
    }
    if(tid > 0){
 ce4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ce8:	7e 05                	jle    cef <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ced:	eb 1f                	jmp    d0e <thread_create+0xcc>
    }
    if(tid == 0){
 cef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 cf3:	75 14                	jne    d09 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 cf5:	c7 44 24 04 1e 0f 00 	movl   $0xf1e,0x4(%esp)
 cfc:	00 
 cfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d04:	e8 10 fb ff ff       	call   819 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d0e:	c9                   	leave  
 d0f:	c3                   	ret    

00000d10 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 d10:	55                   	push   %ebp
 d11:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 d13:	a1 44 0f 00 00       	mov    0xf44,%eax
 d18:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 d1e:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 d23:	a3 44 0f 00 00       	mov    %eax,0xf44
    return (int)(rands % max);
 d28:	a1 44 0f 00 00       	mov    0xf44,%eax
 d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 d30:	ba 00 00 00 00       	mov    $0x0,%edx
 d35:	f7 f1                	div    %ecx
 d37:	89 d0                	mov    %edx,%eax
}
 d39:	5d                   	pop    %ebp
 d3a:	c3                   	ret    
 d3b:	90                   	nop

00000d3c <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 d3c:	55                   	push   %ebp
 d3d:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 d3f:	8b 45 08             	mov    0x8(%ebp),%eax
 d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 d48:	8b 45 08             	mov    0x8(%ebp),%eax
 d4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 d52:	8b 45 08             	mov    0x8(%ebp),%eax
 d55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 d5c:	5d                   	pop    %ebp
 d5d:	c3                   	ret    

00000d5e <add_q>:

void add_q(struct queue *q, int v){
 d5e:	55                   	push   %ebp
 d5f:	89 e5                	mov    %esp,%ebp
 d61:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 d64:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 d6b:	e8 8f fd ff ff       	call   aff <malloc>
 d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d80:	8b 55 0c             	mov    0xc(%ebp),%edx
 d83:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 d85:	8b 45 08             	mov    0x8(%ebp),%eax
 d88:	8b 40 04             	mov    0x4(%eax),%eax
 d8b:	85 c0                	test   %eax,%eax
 d8d:	75 0b                	jne    d9a <add_q+0x3c>
        q->head = n;
 d8f:	8b 45 08             	mov    0x8(%ebp),%eax
 d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
 d95:	89 50 04             	mov    %edx,0x4(%eax)
 d98:	eb 0c                	jmp    da6 <add_q+0x48>
    }else{
        q->tail->next = n;
 d9a:	8b 45 08             	mov    0x8(%ebp),%eax
 d9d:	8b 40 08             	mov    0x8(%eax),%eax
 da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 da3:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 da6:	8b 45 08             	mov    0x8(%ebp),%eax
 da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 dac:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 daf:	8b 45 08             	mov    0x8(%ebp),%eax
 db2:	8b 00                	mov    (%eax),%eax
 db4:	8d 50 01             	lea    0x1(%eax),%edx
 db7:	8b 45 08             	mov    0x8(%ebp),%eax
 dba:	89 10                	mov    %edx,(%eax)
}
 dbc:	c9                   	leave  
 dbd:	c3                   	ret    

00000dbe <empty_q>:

int empty_q(struct queue *q){
 dbe:	55                   	push   %ebp
 dbf:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 dc1:	8b 45 08             	mov    0x8(%ebp),%eax
 dc4:	8b 00                	mov    (%eax),%eax
 dc6:	85 c0                	test   %eax,%eax
 dc8:	75 07                	jne    dd1 <empty_q+0x13>
        return 1;
 dca:	b8 01 00 00 00       	mov    $0x1,%eax
 dcf:	eb 05                	jmp    dd6 <empty_q+0x18>
    else
        return 0;
 dd1:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 dd6:	5d                   	pop    %ebp
 dd7:	c3                   	ret    

00000dd8 <pop_q>:
int pop_q(struct queue *q){
 dd8:	55                   	push   %ebp
 dd9:	89 e5                	mov    %esp,%ebp
 ddb:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 dde:	8b 45 08             	mov    0x8(%ebp),%eax
 de1:	89 04 24             	mov    %eax,(%esp)
 de4:	e8 d5 ff ff ff       	call   dbe <empty_q>
 de9:	85 c0                	test   %eax,%eax
 deb:	75 5d                	jne    e4a <pop_q+0x72>
       val = q->head->value; 
 ded:	8b 45 08             	mov    0x8(%ebp),%eax
 df0:	8b 40 04             	mov    0x4(%eax),%eax
 df3:	8b 00                	mov    (%eax),%eax
 df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 df8:	8b 45 08             	mov    0x8(%ebp),%eax
 dfb:	8b 40 04             	mov    0x4(%eax),%eax
 dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 e01:	8b 45 08             	mov    0x8(%ebp),%eax
 e04:	8b 40 04             	mov    0x4(%eax),%eax
 e07:	8b 50 04             	mov    0x4(%eax),%edx
 e0a:	8b 45 08             	mov    0x8(%ebp),%eax
 e0d:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e13:	89 04 24             	mov    %eax,(%esp)
 e16:	e8 b5 fb ff ff       	call   9d0 <free>
       q->size--;
 e1b:	8b 45 08             	mov    0x8(%ebp),%eax
 e1e:	8b 00                	mov    (%eax),%eax
 e20:	8d 50 ff             	lea    -0x1(%eax),%edx
 e23:	8b 45 08             	mov    0x8(%ebp),%eax
 e26:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 e28:	8b 45 08             	mov    0x8(%ebp),%eax
 e2b:	8b 00                	mov    (%eax),%eax
 e2d:	85 c0                	test   %eax,%eax
 e2f:	75 14                	jne    e45 <pop_q+0x6d>
            q->head = 0;
 e31:	8b 45 08             	mov    0x8(%ebp),%eax
 e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 e3b:	8b 45 08             	mov    0x8(%ebp),%eax
 e3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e48:	eb 05                	jmp    e4f <pop_q+0x77>
    }
    return -1;
 e4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 e4f:	c9                   	leave  
 e50:	c3                   	ret    
