
_test_random:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"


int main(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    printf(1,"random number %d\n",random(100));
   9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  10:	e8 a3 09 00 00       	call   9b8 <random>
  15:	89 44 24 08          	mov    %eax,0x8(%esp)
  19:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 94 04 00 00       	call   4c1 <printf>
    printf(1,"random number %d\n",random(100));
  2d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  34:	e8 7f 09 00 00       	call   9b8 <random>
  39:	89 44 24 08          	mov    %eax,0x8(%esp)
  3d:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
  44:	00 
  45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4c:	e8 70 04 00 00       	call   4c1 <printf>
    printf(1,"random number %d\n",random(100));
  51:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  58:	e8 5b 09 00 00       	call   9b8 <random>
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 4c 04 00 00       	call   4c1 <printf>
    printf(1,"random number %d\n",random(100));
  75:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  7c:	e8 37 09 00 00       	call   9b8 <random>
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 28 04 00 00       	call   4c1 <printf>
    printf(1,"random number %d\n",random(100));
  99:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  a0:	e8 13 09 00 00       	call   9b8 <random>
  a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  a9:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 04 04 00 00       	call   4c1 <printf>

    exit();
  bd:	e8 66 02 00 00       	call   328 <exit>
  c2:	90                   	nop
  c3:	90                   	nop

000000c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cc:	8b 55 10             	mov    0x10(%ebp),%edx
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	89 cb                	mov    %ecx,%ebx
  d4:	89 df                	mov    %ebx,%edi
  d6:	89 d1                	mov    %edx,%ecx
  d8:	fc                   	cld    
  d9:	f3 aa                	rep stos %al,%es:(%edi)
  db:	89 ca                	mov    %ecx,%edx
  dd:	89 fb                	mov    %edi,%ebx
  df:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e5:	5b                   	pop    %ebx
  e6:	5f                   	pop    %edi
  e7:	5d                   	pop    %ebp
  e8:	c3                   	ret    

000000e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	88 10                	mov    %dl,(%eax)
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	84 c0                	test   %al,%al
 108:	0f 95 c0             	setne  %al
 10b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 113:	84 c0                	test   %al,%al
 115:	75 de                	jne    f5 <strcpy+0xc>
    ;
  return os;
 117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11a:	c9                   	leave  
 11b:	c3                   	ret    

0000011c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11f:	eb 08                	jmp    129 <strcmp+0xd>
    p++, q++;
 121:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 125:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	0f b6 00             	movzbl (%eax),%eax
 12f:	84 c0                	test   %al,%al
 131:	74 10                	je     143 <strcmp+0x27>
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 10             	movzbl (%eax),%edx
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	38 c2                	cmp    %al,%dl
 141:	74 de                	je     121 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	0f b6 d0             	movzbl %al,%edx
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	0f b6 c0             	movzbl %al,%eax
 155:	89 d1                	mov    %edx,%ecx
 157:	29 c1                	sub    %eax,%ecx
 159:	89 c8                	mov    %ecx,%eax
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <strlen>:

uint
strlen(char *s)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 16a:	eb 04                	jmp    170 <strlen+0x13>
 16c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 170:	8b 45 fc             	mov    -0x4(%ebp),%eax
 173:	03 45 08             	add    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 ef                	jne    16c <strlen+0xf>
    ;
  return n;
 17d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 188:	8b 45 10             	mov    0x10(%ebp),%eax
 18b:	89 44 24 08          	mov    %eax,0x8(%esp)
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	89 44 24 04          	mov    %eax,0x4(%esp)
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	89 04 24             	mov    %eax,(%esp)
 19c:	e8 23 ff ff ff       	call   c4 <stosb>
  return dst;
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 04             	sub    $0x4,%esp
 1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 1af:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b2:	eb 14                	jmp    1c8 <strchr+0x22>
    if(*s == c)
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1bd:	75 05                	jne    1c4 <strchr+0x1e>
      return (char*)s;
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	eb 13                	jmp    1d7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	84 c0                	test   %al,%al
 1d0:	75 e2                	jne    1b4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    

000001d9 <gets>:

char*
gets(char *buf, int max)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1e6:	eb 44                	jmp    22c <gets+0x53>
    cc = read(0, &c, 1);
 1e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ef:	00 
 1f0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1fe:	e8 3d 01 00 00       	call   340 <read>
 203:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20a:	7e 2d                	jle    239 <gets+0x60>
      break;
    buf[i++] = c;
 20c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 20f:	03 45 08             	add    0x8(%ebp),%eax
 212:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 216:	88 10                	mov    %dl,(%eax)
 218:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 21c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 220:	3c 0a                	cmp    $0xa,%al
 222:	74 16                	je     23a <gets+0x61>
 224:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 228:	3c 0d                	cmp    $0xd,%al
 22a:	74 0e                	je     23a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22f:	83 c0 01             	add    $0x1,%eax
 232:	3b 45 0c             	cmp    0xc(%ebp),%eax
 235:	7c b1                	jl     1e8 <gets+0xf>
 237:	eb 01                	jmp    23a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 239:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 23d:	03 45 08             	add    0x8(%ebp),%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
}
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <stat>:

int
stat(char *n, struct stat *st)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 255:	00 
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	89 04 24             	mov    %eax,(%esp)
 25c:	e8 07 01 00 00       	call   368 <open>
 261:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 264:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 268:	79 07                	jns    271 <stat+0x29>
    return -1;
 26a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26f:	eb 23                	jmp    294 <stat+0x4c>
  r = fstat(fd, st);
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	89 44 24 04          	mov    %eax,0x4(%esp)
 278:	8b 45 f0             	mov    -0x10(%ebp),%eax
 27b:	89 04 24             	mov    %eax,(%esp)
 27e:	e8 fd 00 00 00       	call   380 <fstat>
 283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 286:	8b 45 f0             	mov    -0x10(%ebp),%eax
 289:	89 04 24             	mov    %eax,(%esp)
 28c:	e8 bf 00 00 00       	call   350 <close>
  return r;
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 294:	c9                   	leave  
 295:	c3                   	ret    

00000296 <atoi>:

int
atoi(const char *s)
{
 296:	55                   	push   %ebp
 297:	89 e5                	mov    %esp,%ebp
 299:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 29c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a3:	eb 24                	jmp    2c9 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a8:	89 d0                	mov    %edx,%eax
 2aa:	c1 e0 02             	shl    $0x2,%eax
 2ad:	01 d0                	add    %edx,%eax
 2af:	01 c0                	add    %eax,%eax
 2b1:	89 c2                	mov    %eax,%edx
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	0f be c0             	movsbl %al,%eax
 2bc:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2bf:	83 e8 30             	sub    $0x30,%eax
 2c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 2f                	cmp    $0x2f,%al
 2d1:	7e 0a                	jle    2dd <atoi+0x47>
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	0f b6 00             	movzbl (%eax),%eax
 2d9:	3c 39                	cmp    $0x39,%al
 2db:	7e c8                	jle    2a5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2f4:	eb 13                	jmp    309 <memmove+0x27>
    *dst++ = *src++;
 2f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f9:	0f b6 10             	movzbl (%eax),%edx
 2fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ff:	88 10                	mov    %dl,(%eax)
 301:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 305:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 309:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 30d:	0f 9f c0             	setg   %al
 310:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 314:	84 c0                	test   %al,%al
 316:	75 de                	jne    2f6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    
 31d:	90                   	nop
 31e:	90                   	nop
 31f:	90                   	nop

00000320 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 320:	b8 01 00 00 00       	mov    $0x1,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <exit>:
SYSCALL(exit)
 328:	b8 02 00 00 00       	mov    $0x2,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <wait>:
SYSCALL(wait)
 330:	b8 03 00 00 00       	mov    $0x3,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <pipe>:
SYSCALL(pipe)
 338:	b8 04 00 00 00       	mov    $0x4,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <read>:
SYSCALL(read)
 340:	b8 05 00 00 00       	mov    $0x5,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <write>:
SYSCALL(write)
 348:	b8 10 00 00 00       	mov    $0x10,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <close>:
SYSCALL(close)
 350:	b8 15 00 00 00       	mov    $0x15,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <kill>:
SYSCALL(kill)
 358:	b8 06 00 00 00       	mov    $0x6,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exec>:
SYSCALL(exec)
 360:	b8 07 00 00 00       	mov    $0x7,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <open>:
SYSCALL(open)
 368:	b8 0f 00 00 00       	mov    $0xf,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <mknod>:
SYSCALL(mknod)
 370:	b8 11 00 00 00       	mov    $0x11,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <unlink>:
SYSCALL(unlink)
 378:	b8 12 00 00 00       	mov    $0x12,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <fstat>:
SYSCALL(fstat)
 380:	b8 08 00 00 00       	mov    $0x8,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <link>:
SYSCALL(link)
 388:	b8 13 00 00 00       	mov    $0x13,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <mkdir>:
SYSCALL(mkdir)
 390:	b8 14 00 00 00       	mov    $0x14,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <chdir>:
SYSCALL(chdir)
 398:	b8 09 00 00 00       	mov    $0x9,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <dup>:
SYSCALL(dup)
 3a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <getpid>:
SYSCALL(getpid)
 3a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <sbrk>:
SYSCALL(sbrk)
 3b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <sleep>:
SYSCALL(sleep)
 3b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <uptime>:
SYSCALL(uptime)
 3c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <clone>:
SYSCALL(clone)
 3c8:	b8 16 00 00 00       	mov    $0x16,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <texit>:
SYSCALL(texit)
 3d0:	b8 17 00 00 00       	mov    $0x17,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <tsleep>:
SYSCALL(tsleep)
 3d8:	b8 18 00 00 00       	mov    $0x18,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <twakeup>:
SYSCALL(twakeup)
 3e0:	b8 19 00 00 00       	mov    $0x19,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 28             	sub    $0x28,%esp
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3fb:	00 
 3fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	89 04 24             	mov    %eax,(%esp)
 409:	e8 3a ff ff ff       	call   348 <write>
}
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 417:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 422:	74 17                	je     43b <printint+0x2b>
 424:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 428:	79 11                	jns    43b <printint+0x2b>
    neg = 1;
 42a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	f7 d8                	neg    %eax
 436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 439:	eb 06                	jmp    441 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43b:	8b 45 0c             	mov    0xc(%ebp),%eax
 43e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 441:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 448:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 44b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f3                	div    %ebx
 458:	89 d0                	mov    %edx,%eax
 45a:	0f b6 80 40 0b 00 00 	movzbl 0xb40(%eax),%eax
 461:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 465:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 469:	8b 45 10             	mov    0x10(%ebp),%eax
 46c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	ba 00 00 00 00       	mov    $0x0,%edx
 477:	f7 75 d4             	divl   -0x2c(%ebp)
 47a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 47d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 481:	75 c5                	jne    448 <printint+0x38>
  if(neg)
 483:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 487:	74 28                	je     4b1 <printint+0xa1>
    buf[i++] = '-';
 489:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 491:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 495:	eb 1a                	jmp    4b1 <printint+0xa1>
    putc(fd, buf[i]);
 497:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 49f:	0f be c0             	movsbl %al,%eax
 4a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	89 04 24             	mov    %eax,(%esp)
 4ac:	e8 37 ff ff ff       	call   3e8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b1:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b9:	79 dc                	jns    497 <printint+0x87>
    putc(fd, buf[i]);
}
 4bb:	83 c4 44             	add    $0x44,%esp
 4be:	5b                   	pop    %ebx
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    

000004c1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ce:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 4d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4de:	e9 7e 01 00 00       	jmp    661 <printf+0x1a0>
    c = fmt[i] & 0xff;
 4e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e9:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4ec:	0f b6 00             	movzbl (%eax),%eax
 4ef:	0f be c0             	movsbl %al,%eax
 4f2:	25 ff 00 00 00       	and    $0xff,%eax
 4f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 4fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fe:	75 2c                	jne    52c <printf+0x6b>
      if(c == '%'){
 500:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 504:	75 0c                	jne    512 <printf+0x51>
        state = '%';
 506:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 50d:	e9 4b 01 00 00       	jmp    65d <printf+0x19c>
      } else {
        putc(fd, c);
 512:	8b 45 e8             	mov    -0x18(%ebp),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 c1 fe ff ff       	call   3e8 <putc>
 527:	e9 31 01 00 00       	jmp    65d <printf+0x19c>
      }
    } else if(state == '%'){
 52c:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 530:	0f 85 27 01 00 00    	jne    65d <printf+0x19c>
      if(c == 'd'){
 536:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 53a:	75 2d                	jne    569 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	8b 00                	mov    (%eax),%eax
 541:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 548:	00 
 549:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 550:	00 
 551:	89 44 24 04          	mov    %eax,0x4(%esp)
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	89 04 24             	mov    %eax,(%esp)
 55b:	e8 b0 fe ff ff       	call   410 <printint>
        ap++;
 560:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 564:	e9 ed 00 00 00       	jmp    656 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 569:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 56d:	74 06                	je     575 <printf+0xb4>
 56f:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 573:	75 2d                	jne    5a2 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 575:	8b 45 f4             	mov    -0xc(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 581:	00 
 582:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 589:	00 
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 77 fe ff ff       	call   410 <printint>
        ap++;
 599:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 59d:	e9 b4 00 00 00       	jmp    656 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5a2:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5a6:	75 46                	jne    5ee <printf+0x12d>
        s = (char*)*ap;
 5a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ab:	8b 00                	mov    (%eax),%eax
 5ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5b0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5b8:	75 27                	jne    5e1 <printf+0x120>
          s = "(null)";
 5ba:	c7 45 e4 0b 0b 00 00 	movl   $0xb0b,-0x1c(%ebp)
        while(*s != 0){
 5c1:	eb 1f                	jmp    5e2 <printf+0x121>
          putc(fd, *s);
 5c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 0d fe ff ff       	call   3e8 <putc>
          s++;
 5db:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 5df:	eb 01                	jmp    5e2 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e1:	90                   	nop
 5e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e5:	0f b6 00             	movzbl (%eax),%eax
 5e8:	84 c0                	test   %al,%al
 5ea:	75 d7                	jne    5c3 <printf+0x102>
 5ec:	eb 68                	jmp    656 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ee:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 5f2:	75 1d                	jne    611 <printf+0x150>
        putc(fd, *ap);
 5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 dd fd ff ff       	call   3e8 <putc>
        ap++;
 60b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 60f:	eb 45                	jmp    656 <printf+0x195>
      } else if(c == '%'){
 611:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 615:	75 17                	jne    62e <printf+0x16d>
        putc(fd, c);
 617:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	89 44 24 04          	mov    %eax,0x4(%esp)
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	89 04 24             	mov    %eax,(%esp)
 627:	e8 bc fd ff ff       	call   3e8 <putc>
 62c:	eb 28                	jmp    656 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 635:	00 
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	89 04 24             	mov    %eax,(%esp)
 63c:	e8 a7 fd ff ff       	call   3e8 <putc>
        putc(fd, c);
 641:	8b 45 e8             	mov    -0x18(%ebp),%eax
 644:	0f be c0             	movsbl %al,%eax
 647:	89 44 24 04          	mov    %eax,0x4(%esp)
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	89 04 24             	mov    %eax,(%esp)
 651:	e8 92 fd ff ff       	call   3e8 <putc>
      }
      state = 0;
 656:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 661:	8b 55 0c             	mov    0xc(%ebp),%edx
 664:	8b 45 ec             	mov    -0x14(%ebp),%eax
 667:	8d 04 02             	lea    (%edx,%eax,1),%eax
 66a:	0f b6 00             	movzbl (%eax),%eax
 66d:	84 c0                	test   %al,%al
 66f:	0f 85 6e fe ff ff    	jne    4e3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 675:	c9                   	leave  
 676:	c3                   	ret    
 677:	90                   	nop

00000678 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67e:	8b 45 08             	mov    0x8(%ebp),%eax
 681:	83 e8 08             	sub    $0x8,%eax
 684:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 687:	a1 60 0b 00 00       	mov    0xb60,%eax
 68c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68f:	eb 24                	jmp    6b5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 699:	77 12                	ja     6ad <free+0x35>
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a1:	77 24                	ja     6c7 <free+0x4f>
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ab:	77 1a                	ja     6c7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bb:	76 d4                	jbe    691 <free+0x19>
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c5:	76 ca                	jbe    691 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	c1 e0 03             	shl    $0x3,%eax
 6d0:	89 c2                	mov    %eax,%edx
 6d2:	03 55 f8             	add    -0x8(%ebp),%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	39 c2                	cmp    %eax,%edx
 6dc:	75 24                	jne    702 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 40 04             	mov    0x4(%eax),%eax
 6ec:	01 c2                	add    %eax,%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
 700:	eb 0a                	jmp    70c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 40 04             	mov    0x4(%eax),%eax
 712:	c1 e0 03             	shl    $0x3,%eax
 715:	03 45 fc             	add    -0x4(%ebp),%eax
 718:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71b:	75 20                	jne    73d <free+0xc5>
    p->s.size += bp->s.size;
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 50 04             	mov    0x4(%eax),%edx
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	8b 40 04             	mov    0x4(%eax),%eax
 729:	01 c2                	add    %eax,%edx
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	8b 10                	mov    (%eax),%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	89 10                	mov    %edx,(%eax)
 73b:	eb 08                	jmp    745 <free+0xcd>
  } else
    p->s.ptr = bp;
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 55 f8             	mov    -0x8(%ebp),%edx
 743:	89 10                	mov    %edx,(%eax)
  freep = p;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 74d:	c9                   	leave  
 74e:	c3                   	ret    

0000074f <morecore>:

static Header*
morecore(uint nu)
{
 74f:	55                   	push   %ebp
 750:	89 e5                	mov    %esp,%ebp
 752:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 755:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75c:	77 07                	ja     765 <morecore+0x16>
    nu = 4096;
 75e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	c1 e0 03             	shl    $0x3,%eax
 76b:	89 04 24             	mov    %eax,(%esp)
 76e:	e8 3d fc ff ff       	call   3b0 <sbrk>
 773:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 776:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 77a:	75 07                	jne    783 <morecore+0x34>
    return 0;
 77c:	b8 00 00 00 00       	mov    $0x0,%eax
 781:	eb 22                	jmp    7a5 <morecore+0x56>
  hp = (Header*)p;
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 55 08             	mov    0x8(%ebp),%edx
 78f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	83 c0 08             	add    $0x8,%eax
 798:	89 04 24             	mov    %eax,(%esp)
 79b:	e8 d8 fe ff ff       	call   678 <free>
  return freep;
 7a0:	a1 60 0b 00 00       	mov    0xb60,%eax
}
 7a5:	c9                   	leave  
 7a6:	c3                   	ret    

000007a7 <malloc>:

void*
malloc(uint nbytes)
{
 7a7:	55                   	push   %ebp
 7a8:	89 e5                	mov    %esp,%ebp
 7aa:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	83 c0 07             	add    $0x7,%eax
 7b3:	c1 e8 03             	shr    $0x3,%eax
 7b6:	83 c0 01             	add    $0x1,%eax
 7b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7bc:	a1 60 0b 00 00       	mov    0xb60,%eax
 7c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c8:	75 23                	jne    7ed <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ca:	c7 45 f0 58 0b 00 00 	movl   $0xb58,-0x10(%ebp)
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	a3 60 0b 00 00       	mov    %eax,0xb60
 7d9:	a1 60 0b 00 00       	mov    0xb60,%eax
 7de:	a3 58 0b 00 00       	mov    %eax,0xb58
    base.s.size = 0;
 7e3:	c7 05 5c 0b 00 00 00 	movl   $0x0,0xb5c
 7ea:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 7f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7fe:	72 4d                	jb     84d <malloc+0xa6>
      if(p->s.size == nunits)
 800:	8b 45 ec             	mov    -0x14(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 809:	75 0c                	jne    817 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80e:	8b 10                	mov    (%eax),%edx
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	89 10                	mov    %edx,(%eax)
 815:	eb 26                	jmp    83d <malloc+0x96>
      else {
        p->s.size -= nunits;
 817:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	89 c2                	mov    %eax,%edx
 81f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 822:	8b 45 ec             	mov    -0x14(%ebp),%eax
 825:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 828:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 834:	8b 45 ec             	mov    -0x14(%ebp),%eax
 837:	8b 55 f4             	mov    -0xc(%ebp),%edx
 83a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	a3 60 0b 00 00       	mov    %eax,0xb60
      return (void*)(p + 1);
 845:	8b 45 ec             	mov    -0x14(%ebp),%eax
 848:	83 c0 08             	add    $0x8,%eax
 84b:	eb 38                	jmp    885 <malloc+0xde>
    }
    if(p == freep)
 84d:	a1 60 0b 00 00       	mov    0xb60,%eax
 852:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 855:	75 1b                	jne    872 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	89 04 24             	mov    %eax,(%esp)
 85d:	e8 ed fe ff ff       	call   74f <morecore>
 862:	89 45 ec             	mov    %eax,-0x14(%ebp)
 865:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 869:	75 07                	jne    872 <malloc+0xcb>
        return 0;
 86b:	b8 00 00 00 00       	mov    $0x0,%eax
 870:	eb 13                	jmp    885 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	8b 45 ec             	mov    -0x14(%ebp),%eax
 875:	89 45 f0             	mov    %eax,-0x10(%ebp)
 878:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87b:	8b 00                	mov    (%eax),%eax
 87d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 880:	e9 70 ff ff ff       	jmp    7f5 <malloc+0x4e>
}
 885:	c9                   	leave  
 886:	c3                   	ret    
 887:	90                   	nop

00000888 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
 88b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 88e:	8b 55 08             	mov    0x8(%ebp),%edx
 891:	8b 45 0c             	mov    0xc(%ebp),%eax
 894:	8b 4d 08             	mov    0x8(%ebp),%ecx
 897:	f0 87 02             	lock xchg %eax,(%edx)
 89a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8a0:	c9                   	leave  
 8a1:	c3                   	ret    

000008a2 <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 8a2:	55                   	push   %ebp
 8a3:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8ae:	5d                   	pop    %ebp
 8af:	c3                   	ret    

000008b0 <lock_acquire>:
void lock_acquire(lock_t *lock){
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 8b6:	8b 45 08             	mov    0x8(%ebp),%eax
 8b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8c0:	00 
 8c1:	89 04 24             	mov    %eax,(%esp)
 8c4:	e8 bf ff ff ff       	call   888 <xchg>
 8c9:	85 c0                	test   %eax,%eax
 8cb:	75 e9                	jne    8b6 <lock_acquire+0x6>
}
 8cd:	c9                   	leave  
 8ce:	c3                   	ret    

000008cf <lock_release>:
void lock_release(lock_t *lock){
 8cf:	55                   	push   %ebp
 8d0:	89 e5                	mov    %esp,%ebp
 8d2:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 8d5:	8b 45 08             	mov    0x8(%ebp),%eax
 8d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8df:	00 
 8e0:	89 04 24             	mov    %eax,(%esp)
 8e3:	e8 a0 ff ff ff       	call   888 <xchg>
}
 8e8:	c9                   	leave  
 8e9:	c3                   	ret    

000008ea <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 8ea:	55                   	push   %ebp
 8eb:	89 e5                	mov    %esp,%ebp
 8ed:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 8f0:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 8f7:	e8 ab fe ff ff       	call   7a7 <malloc>
 8fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 8ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 902:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	25 ff 0f 00 00       	and    $0xfff,%eax
 90d:	85 c0                	test   %eax,%eax
 90f:	74 15                	je     926 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 911:	8b 45 f0             	mov    -0x10(%ebp),%eax
 914:	89 c2                	mov    %eax,%edx
 916:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 91c:	b8 00 10 00 00       	mov    $0x1000,%eax
 921:	29 d0                	sub    %edx,%eax
 923:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 926:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 92a:	75 1b                	jne    947 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 92c:	c7 44 24 04 12 0b 00 	movl   $0xb12,0x4(%esp)
 933:	00 
 934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 93b:	e8 81 fb ff ff       	call   4c1 <printf>
        return 0;
 940:	b8 00 00 00 00       	mov    $0x0,%eax
 945:	eb 6f                	jmp    9b6 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 947:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 94a:	8b 55 08             	mov    0x8(%ebp),%edx
 94d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 950:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 954:	89 54 24 08          	mov    %edx,0x8(%esp)
 958:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 95f:	00 
 960:	89 04 24             	mov    %eax,(%esp)
 963:	e8 60 fa ff ff       	call   3c8 <clone>
 968:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 96b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 96f:	79 1b                	jns    98c <thread_create+0xa2>
        printf(1,"clone fails\n");
 971:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
 978:	00 
 979:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 980:	e8 3c fb ff ff       	call   4c1 <printf>
        return 0;
 985:	b8 00 00 00 00       	mov    $0x0,%eax
 98a:	eb 2a                	jmp    9b6 <thread_create+0xcc>
    }
    if(tid > 0){
 98c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 990:	7e 05                	jle    997 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	eb 1f                	jmp    9b6 <thread_create+0xcc>
    }
    if(tid == 0){
 997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 99b:	75 14                	jne    9b1 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 99d:	c7 44 24 04 2d 0b 00 	movl   $0xb2d,0x4(%esp)
 9a4:	00 
 9a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9ac:	e8 10 fb ff ff       	call   4c1 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9b6:	c9                   	leave  
 9b7:	c3                   	ret    

000009b8 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 9b8:	55                   	push   %ebp
 9b9:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 9bb:	a1 54 0b 00 00       	mov    0xb54,%eax
 9c0:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 9c6:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 9cb:	a3 54 0b 00 00       	mov    %eax,0xb54
    return (int)(rands % max);
 9d0:	a1 54 0b 00 00       	mov    0xb54,%eax
 9d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9d8:	ba 00 00 00 00       	mov    $0x0,%edx
 9dd:	f7 f1                	div    %ecx
 9df:	89 d0                	mov    %edx,%eax
}
 9e1:	5d                   	pop    %ebp
 9e2:	c3                   	ret    
 9e3:	90                   	nop

000009e4 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 9e4:	55                   	push   %ebp
 9e5:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 9e7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 9f0:	8b 45 08             	mov    0x8(%ebp),%eax
 9f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 9fa:	8b 45 08             	mov    0x8(%ebp),%eax
 9fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a04:	5d                   	pop    %ebp
 a05:	c3                   	ret    

00000a06 <add_q>:

void add_q(struct queue *q, int v){
 a06:	55                   	push   %ebp
 a07:	89 e5                	mov    %esp,%ebp
 a09:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 a0c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a13:	e8 8f fd ff ff       	call   7a7 <malloc>
 a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	8b 55 0c             	mov    0xc(%ebp),%edx
 a2b:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a2d:	8b 45 08             	mov    0x8(%ebp),%eax
 a30:	8b 40 04             	mov    0x4(%eax),%eax
 a33:	85 c0                	test   %eax,%eax
 a35:	75 0b                	jne    a42 <add_q+0x3c>
        q->head = n;
 a37:	8b 45 08             	mov    0x8(%ebp),%eax
 a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a3d:	89 50 04             	mov    %edx,0x4(%eax)
 a40:	eb 0c                	jmp    a4e <add_q+0x48>
    }else{
        q->tail->next = n;
 a42:	8b 45 08             	mov    0x8(%ebp),%eax
 a45:	8b 40 08             	mov    0x8(%eax),%eax
 a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a4b:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 a4e:	8b 45 08             	mov    0x8(%ebp),%eax
 a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a54:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	8b 00                	mov    (%eax),%eax
 a5c:	8d 50 01             	lea    0x1(%eax),%edx
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	89 10                	mov    %edx,(%eax)
}
 a64:	c9                   	leave  
 a65:	c3                   	ret    

00000a66 <empty_q>:

int empty_q(struct queue *q){
 a66:	55                   	push   %ebp
 a67:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 a69:	8b 45 08             	mov    0x8(%ebp),%eax
 a6c:	8b 00                	mov    (%eax),%eax
 a6e:	85 c0                	test   %eax,%eax
 a70:	75 07                	jne    a79 <empty_q+0x13>
        return 1;
 a72:	b8 01 00 00 00       	mov    $0x1,%eax
 a77:	eb 05                	jmp    a7e <empty_q+0x18>
    else
        return 0;
 a79:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 a7e:	5d                   	pop    %ebp
 a7f:	c3                   	ret    

00000a80 <pop_q>:
int pop_q(struct queue *q){
 a80:	55                   	push   %ebp
 a81:	89 e5                	mov    %esp,%ebp
 a83:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 a86:	8b 45 08             	mov    0x8(%ebp),%eax
 a89:	89 04 24             	mov    %eax,(%esp)
 a8c:	e8 d5 ff ff ff       	call   a66 <empty_q>
 a91:	85 c0                	test   %eax,%eax
 a93:	75 5d                	jne    af2 <pop_q+0x72>
       val = q->head->value; 
 a95:	8b 45 08             	mov    0x8(%ebp),%eax
 a98:	8b 40 04             	mov    0x4(%eax),%eax
 a9b:	8b 00                	mov    (%eax),%eax
 a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 aa0:	8b 45 08             	mov    0x8(%ebp),%eax
 aa3:	8b 40 04             	mov    0x4(%eax),%eax
 aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 aa9:	8b 45 08             	mov    0x8(%ebp),%eax
 aac:	8b 40 04             	mov    0x4(%eax),%eax
 aaf:	8b 50 04             	mov    0x4(%eax),%edx
 ab2:	8b 45 08             	mov    0x8(%ebp),%eax
 ab5:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abb:	89 04 24             	mov    %eax,(%esp)
 abe:	e8 b5 fb ff ff       	call   678 <free>
       q->size--;
 ac3:	8b 45 08             	mov    0x8(%ebp),%eax
 ac6:	8b 00                	mov    (%eax),%eax
 ac8:	8d 50 ff             	lea    -0x1(%eax),%edx
 acb:	8b 45 08             	mov    0x8(%ebp),%eax
 ace:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 ad0:	8b 45 08             	mov    0x8(%ebp),%eax
 ad3:	8b 00                	mov    (%eax),%eax
 ad5:	85 c0                	test   %eax,%eax
 ad7:	75 14                	jne    aed <pop_q+0x6d>
            q->head = 0;
 ad9:	8b 45 08             	mov    0x8(%ebp),%eax
 adc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 ae3:	8b 45 08             	mov    0x8(%ebp),%eax
 ae6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af0:	eb 05                	jmp    af7 <pop_q+0x77>
    }
    return -1;
 af2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 af7:	c9                   	leave  
 af8:	c3                   	ret    
