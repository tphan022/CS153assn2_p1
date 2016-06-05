
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 4b 0f 00 00       	call   f5c <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 5c 17 00 00 	mov    0x175c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 30 17 00 00 	movl   $0x1730,(%esp)
      2b:	e8 29 03 00 00       	call   359 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 e8             	mov    -0x18(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 17 0f 00 00       	call   f5c <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 e8             	mov    -0x18(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 37 0f 00 00       	call   f94 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 37 17 00 	movl   $0x1737,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 7a 10 00 00       	call   10f5 <printf>
    break;
      7b:	e9 83 01 00 00       	jmp    203 <runcmd+0x203>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    close(rcmd->fd);
      86:	8b 45 f4             	mov    -0xc(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f0 0e 00 00       	call   f84 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f4             	mov    -0xc(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 f0 0e 00 00       	call   f9c <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 47 17 00 	movl   $0x1747,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 27 10 00 00       	call   10f5 <printf>
      exit();
      ce:	e8 89 0e 00 00       	call   f5c <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 1d 01 00 00       	jmp    203 <runcmd+0x203>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8e 02 00 00       	call   37f <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 5c 0e 00 00       	call   f64 <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 e8 00 00 00       	jmp    203 <runcmd+0x203>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 40 0e 00 00       	call   f6c <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 57 17 00 00 	movl   $0x1757,(%esp)
     137:	e8 1d 02 00 00       	call   359 <panic>
    if(fork1() == 0){
     13c:	e8 3e 02 00 00       	call   37f <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 33 0e 00 00       	call   f84 <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 78 0e 00 00       	call   fd4 <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 1d 0e 00 00       	call   f84 <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 12 0e 00 00       	call   f84 <close>
      runcmd(pcmd->left);
     172:	8b 45 f0             	mov    -0x10(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 fa 01 00 00       	call   37f <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 ef 0d 00 00       	call   f84 <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 34 0e 00 00       	call   fd4 <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 d9 0d 00 00       	call   f84 <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 ce 0d 00 00       	call   f84 <close>
      runcmd(pcmd->right);
     1b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 b5 0d 00 00       	call   f84 <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 aa 0d 00 00       	call   f84 <close>
    wait();
     1da:	e8 85 0d 00 00       	call   f64 <wait>
    wait();
     1df:	e8 80 0d 00 00       	call   f64 <wait>
    break;
     1e4:	eb 1d                	jmp    203 <runcmd+0x203>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8e 01 00 00       	call   37f <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 0e                	jne    203 <runcmd+0x203>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
  }
  exit();
     203:	e8 54 0d 00 00       	call   f5c <exit>

00000208 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     208:	55                   	push   %ebp
     209:	89 e5                	mov    %esp,%ebp
     20b:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     20e:	c7 44 24 04 74 17 00 	movl   $0x1774,0x4(%esp)
     215:	00 
     216:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21d:	e8 d3 0e 00 00       	call   10f5 <printf>
  memset(buf, 0, nbuf);
     222:	8b 45 0c             	mov    0xc(%ebp),%eax
     225:	89 44 24 08          	mov    %eax,0x8(%esp)
     229:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     230:	00 
     231:	8b 45 08             	mov    0x8(%ebp),%eax
     234:	89 04 24             	mov    %eax,(%esp)
     237:	e8 7a 0b 00 00       	call   db6 <memset>
  gets(buf, nbuf);
     23c:	8b 45 0c             	mov    0xc(%ebp),%eax
     23f:	89 44 24 04          	mov    %eax,0x4(%esp)
     243:	8b 45 08             	mov    0x8(%ebp),%eax
     246:	89 04 24             	mov    %eax,(%esp)
     249:	e8 bf 0b 00 00       	call   e0d <gets>
  if(buf[0] == 0) // EOF
     24e:	8b 45 08             	mov    0x8(%ebp),%eax
     251:	0f b6 00             	movzbl (%eax),%eax
     254:	84 c0                	test   %al,%al
     256:	75 07                	jne    25f <getcmd+0x57>
    return -1;
     258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     25d:	eb 05                	jmp    264 <getcmd+0x5c>
  return 0;
     25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     264:	c9                   	leave  
     265:	c3                   	ret    

00000266 <main>:

int
main(void)
{
     266:	55                   	push   %ebp
     267:	89 e5                	mov    %esp,%ebp
     269:	83 e4 f0             	and    $0xfffffff0,%esp
     26c:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     26f:	eb 19                	jmp    28a <main+0x24>
    if(fd >= 3){
     271:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     276:	7e 12                	jle    28a <main+0x24>
      close(fd);
     278:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27c:	89 04 24             	mov    %eax,(%esp)
     27f:	e8 00 0d 00 00       	call   f84 <close>
      break;
     284:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     285:	e9 ae 00 00 00       	jmp    338 <main+0xd2>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     28a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     291:	00 
     292:	c7 04 24 77 17 00 00 	movl   $0x1777,(%esp)
     299:	e8 fe 0c 00 00       	call   f9c <open>
     29e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a2:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a7:	79 c8                	jns    271 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a9:	e9 8a 00 00 00       	jmp    338 <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ae:	0f b6 05 80 18 00 00 	movzbl 0x1880,%eax
     2b5:	3c 63                	cmp    $0x63,%al
     2b7:	75 5a                	jne    313 <main+0xad>
     2b9:	0f b6 05 81 18 00 00 	movzbl 0x1881,%eax
     2c0:	3c 64                	cmp    $0x64,%al
     2c2:	75 4f                	jne    313 <main+0xad>
     2c4:	0f b6 05 82 18 00 00 	movzbl 0x1882,%eax
     2cb:	3c 20                	cmp    $0x20,%al
     2cd:	75 44                	jne    313 <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2cf:	c7 04 24 80 18 00 00 	movl   $0x1880,(%esp)
     2d6:	e8 b6 0a 00 00       	call   d91 <strlen>
     2db:	83 e8 01             	sub    $0x1,%eax
     2de:	c6 80 80 18 00 00 00 	movb   $0x0,0x1880(%eax)
      if(chdir(buf+3) < 0)
     2e5:	c7 04 24 83 18 00 00 	movl   $0x1883,(%esp)
     2ec:	e8 db 0c 00 00       	call   fcc <chdir>
     2f1:	85 c0                	test   %eax,%eax
     2f3:	79 42                	jns    337 <main+0xd1>
        printf(2, "cannot cd %s\n", buf+3);
     2f5:	c7 44 24 08 83 18 00 	movl   $0x1883,0x8(%esp)
     2fc:	00 
     2fd:	c7 44 24 04 7f 17 00 	movl   $0x177f,0x4(%esp)
     304:	00 
     305:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30c:	e8 e4 0d 00 00       	call   10f5 <printf>
      continue;
     311:	eb 25                	jmp    338 <main+0xd2>
    }
    if(fork1() == 0)
     313:	e8 67 00 00 00       	call   37f <fork1>
     318:	85 c0                	test   %eax,%eax
     31a:	75 14                	jne    330 <main+0xca>
      runcmd(parsecmd(buf));
     31c:	c7 04 24 80 18 00 00 	movl   $0x1880,(%esp)
     323:	e8 c6 03 00 00       	call   6ee <parsecmd>
     328:	89 04 24             	mov    %eax,(%esp)
     32b:	e8 d0 fc ff ff       	call   0 <runcmd>
    wait();
     330:	e8 2f 0c 00 00       	call   f64 <wait>
     335:	eb 01                	jmp    338 <main+0xd2>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     337:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     338:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     33f:	00 
     340:	c7 04 24 80 18 00 00 	movl   $0x1880,(%esp)
     347:	e8 bc fe ff ff       	call   208 <getcmd>
     34c:	85 c0                	test   %eax,%eax
     34e:	0f 89 5a ff ff ff    	jns    2ae <main+0x48>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     354:	e8 03 0c 00 00       	call   f5c <exit>

00000359 <panic>:
}

void
panic(char *s)
{
     359:	55                   	push   %ebp
     35a:	89 e5                	mov    %esp,%ebp
     35c:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     35f:	8b 45 08             	mov    0x8(%ebp),%eax
     362:	89 44 24 08          	mov    %eax,0x8(%esp)
     366:	c7 44 24 04 8d 17 00 	movl   $0x178d,0x4(%esp)
     36d:	00 
     36e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     375:	e8 7b 0d 00 00       	call   10f5 <printf>
  exit();
     37a:	e8 dd 0b 00 00       	call   f5c <exit>

0000037f <fork1>:
}

int
fork1(void)
{
     37f:	55                   	push   %ebp
     380:	89 e5                	mov    %esp,%ebp
     382:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     385:	e8 ca 0b 00 00       	call   f54 <fork>
     38a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     391:	75 0c                	jne    39f <fork1+0x20>
    panic("fork");
     393:	c7 04 24 91 17 00 00 	movl   $0x1791,(%esp)
     39a:	e8 ba ff ff ff       	call   359 <panic>
  return pid;
     39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a2:	c9                   	leave  
     3a3:	c3                   	ret    

000003a4 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a4:	55                   	push   %ebp
     3a5:	89 e5                	mov    %esp,%ebp
     3a7:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3aa:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3b1:	e8 25 10 00 00       	call   13db <malloc>
     3b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3b9:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3c0:	00 
     3c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c8:	00 
     3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3cc:	89 04 24             	mov    %eax,(%esp)
     3cf:	e8 e2 09 00 00       	call   db6 <memset>
  cmd->type = EXEC;
     3d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e0:	c9                   	leave  
     3e1:	c3                   	ret    

000003e2 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e2:	55                   	push   %ebp
     3e3:	89 e5                	mov    %esp,%ebp
     3e5:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e8:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ef:	e8 e7 0f 00 00       	call   13db <malloc>
     3f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f7:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3fe:	00 
     3ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     406:	00 
     407:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40a:	89 04 24             	mov    %eax,(%esp)
     40d:	e8 a4 09 00 00       	call   db6 <memset>
  cmd->type = REDIR;
     412:	8b 45 f4             	mov    -0xc(%ebp),%eax
     415:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41e:	8b 55 08             	mov    0x8(%ebp),%edx
     421:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     424:	8b 45 f4             	mov    -0xc(%ebp),%eax
     427:	8b 55 0c             	mov    0xc(%ebp),%edx
     42a:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     430:	8b 55 10             	mov    0x10(%ebp),%edx
     433:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     436:	8b 45 f4             	mov    -0xc(%ebp),%eax
     439:	8b 55 14             	mov    0x14(%ebp),%edx
     43c:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     442:	8b 55 18             	mov    0x18(%ebp),%edx
     445:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     448:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     44b:	c9                   	leave  
     44c:	c3                   	ret    

0000044d <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44d:	55                   	push   %ebp
     44e:	89 e5                	mov    %esp,%ebp
     450:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     453:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     45a:	e8 7c 0f 00 00       	call   13db <malloc>
     45f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     462:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     469:	00 
     46a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     471:	00 
     472:	8b 45 f4             	mov    -0xc(%ebp),%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 39 09 00 00       	call   db6 <memset>
  cmd->type = PIPE;
     47d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     480:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     486:	8b 45 f4             	mov    -0xc(%ebp),%eax
     489:	8b 55 08             	mov    0x8(%ebp),%edx
     48c:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     492:	8b 55 0c             	mov    0xc(%ebp),%edx
     495:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     498:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     49b:	c9                   	leave  
     49c:	c3                   	ret    

0000049d <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49d:	55                   	push   %ebp
     49e:	89 e5                	mov    %esp,%ebp
     4a0:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a3:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4aa:	e8 2c 0f 00 00       	call   13db <malloc>
     4af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b2:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4b9:	00 
     4ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4c1:	00 
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	89 04 24             	mov    %eax,(%esp)
     4c8:	e8 e9 08 00 00       	call   db6 <memset>
  cmd->type = LIST;
     4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d0:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d9:	8b 55 08             	mov    0x8(%ebp),%edx
     4dc:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e2:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e5:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4eb:	c9                   	leave  
     4ec:	c3                   	ret    

000004ed <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4ed:	55                   	push   %ebp
     4ee:	89 e5                	mov    %esp,%ebp
     4f0:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4fa:	e8 dc 0e 00 00       	call   13db <malloc>
     4ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     502:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     509:	00 
     50a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     511:	00 
     512:	8b 45 f4             	mov    -0xc(%ebp),%eax
     515:	89 04 24             	mov    %eax,(%esp)
     518:	e8 99 08 00 00       	call   db6 <memset>
  cmd->type = BACK;
     51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     520:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     526:	8b 45 f4             	mov    -0xc(%ebp),%eax
     529:	8b 55 08             	mov    0x8(%ebp),%edx
     52c:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     532:	c9                   	leave  
     533:	c3                   	ret    

00000534 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     534:	55                   	push   %ebp
     535:	89 e5                	mov    %esp,%ebp
     537:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     53a:	8b 45 08             	mov    0x8(%ebp),%eax
     53d:	8b 00                	mov    (%eax),%eax
     53f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(s < es && strchr(whitespace, *s))
     542:	eb 04                	jmp    548 <gettoken+0x14>
    s++;
     544:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     548:	8b 45 f0             	mov    -0x10(%ebp),%eax
     54b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54e:	73 1d                	jae    56d <gettoken+0x39>
     550:	8b 45 f0             	mov    -0x10(%ebp),%eax
     553:	0f b6 00             	movzbl (%eax),%eax
     556:	0f be c0             	movsbl %al,%eax
     559:	89 44 24 04          	mov    %eax,0x4(%esp)
     55d:	c7 04 24 54 18 00 00 	movl   $0x1854,(%esp)
     564:	e8 71 08 00 00       	call   dda <strchr>
     569:	85 c0                	test   %eax,%eax
     56b:	75 d7                	jne    544 <gettoken+0x10>
    s++;
  if(q)
     56d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     571:	74 08                	je     57b <gettoken+0x47>
    *q = s;
     573:	8b 45 10             	mov    0x10(%ebp),%eax
     576:	8b 55 f0             	mov    -0x10(%ebp),%edx
     579:	89 10                	mov    %edx,(%eax)
  ret = *s;
     57b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     57e:	0f b6 00             	movzbl (%eax),%eax
     581:	0f be c0             	movsbl %al,%eax
     584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  switch(*s){
     587:	8b 45 f0             	mov    -0x10(%ebp),%eax
     58a:	0f b6 00             	movzbl (%eax),%eax
     58d:	0f be c0             	movsbl %al,%eax
     590:	83 f8 3c             	cmp    $0x3c,%eax
     593:	7f 1e                	jg     5b3 <gettoken+0x7f>
     595:	83 f8 3b             	cmp    $0x3b,%eax
     598:	7d 23                	jge    5bd <gettoken+0x89>
     59a:	83 f8 29             	cmp    $0x29,%eax
     59d:	7f 3f                	jg     5de <gettoken+0xaa>
     59f:	83 f8 28             	cmp    $0x28,%eax
     5a2:	7d 19                	jge    5bd <gettoken+0x89>
     5a4:	85 c0                	test   %eax,%eax
     5a6:	0f 84 83 00 00 00    	je     62f <gettoken+0xfb>
     5ac:	83 f8 26             	cmp    $0x26,%eax
     5af:	74 0c                	je     5bd <gettoken+0x89>
     5b1:	eb 2b                	jmp    5de <gettoken+0xaa>
     5b3:	83 f8 3e             	cmp    $0x3e,%eax
     5b6:	74 0b                	je     5c3 <gettoken+0x8f>
     5b8:	83 f8 7c             	cmp    $0x7c,%eax
     5bb:	75 21                	jne    5de <gettoken+0xaa>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5bd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    break;
     5c1:	eb 70                	jmp    633 <gettoken+0xff>
  case '>':
    s++;
     5c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(*s == '>'){
     5c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ca:	0f b6 00             	movzbl (%eax),%eax
     5cd:	3c 3e                	cmp    $0x3e,%al
     5cf:	75 61                	jne    632 <gettoken+0xfe>
      ret = '+';
     5d1:	c7 45 f4 2b 00 00 00 	movl   $0x2b,-0xc(%ebp)
      s++;
     5d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    break;
     5dc:	eb 55                	jmp    633 <gettoken+0xff>
  default:
    ret = 'a';
     5de:	c7 45 f4 61 00 00 00 	movl   $0x61,-0xc(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5e5:	eb 04                	jmp    5eb <gettoken+0xb7>
      s++;
     5e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f1:	73 40                	jae    633 <gettoken+0xff>
     5f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5f6:	0f b6 00             	movzbl (%eax),%eax
     5f9:	0f be c0             	movsbl %al,%eax
     5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
     600:	c7 04 24 54 18 00 00 	movl   $0x1854,(%esp)
     607:	e8 ce 07 00 00       	call   dda <strchr>
     60c:	85 c0                	test   %eax,%eax
     60e:	75 23                	jne    633 <gettoken+0xff>
     610:	8b 45 f0             	mov    -0x10(%ebp),%eax
     613:	0f b6 00             	movzbl (%eax),%eax
     616:	0f be c0             	movsbl %al,%eax
     619:	89 44 24 04          	mov    %eax,0x4(%esp)
     61d:	c7 04 24 5a 18 00 00 	movl   $0x185a,(%esp)
     624:	e8 b1 07 00 00       	call   dda <strchr>
     629:	85 c0                	test   %eax,%eax
     62b:	74 ba                	je     5e7 <gettoken+0xb3>
     62d:	eb 04                	jmp    633 <gettoken+0xff>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     62f:	90                   	nop
     630:	eb 01                	jmp    633 <gettoken+0xff>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     632:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     633:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     637:	74 0e                	je     647 <gettoken+0x113>
    *eq = s;
     639:	8b 45 14             	mov    0x14(%ebp),%eax
     63c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     63f:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     641:	eb 04                	jmp    647 <gettoken+0x113>
    s++;
     643:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     647:	8b 45 f0             	mov    -0x10(%ebp),%eax
     64a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     64d:	73 1d                	jae    66c <gettoken+0x138>
     64f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     652:	0f b6 00             	movzbl (%eax),%eax
     655:	0f be c0             	movsbl %al,%eax
     658:	89 44 24 04          	mov    %eax,0x4(%esp)
     65c:	c7 04 24 54 18 00 00 	movl   $0x1854,(%esp)
     663:	e8 72 07 00 00       	call   dda <strchr>
     668:	85 c0                	test   %eax,%eax
     66a:	75 d7                	jne    643 <gettoken+0x10f>
    s++;
  *ps = s;
     66c:	8b 45 08             	mov    0x8(%ebp),%eax
     66f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     672:	89 10                	mov    %edx,(%eax)
  return ret;
     674:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     677:	c9                   	leave  
     678:	c3                   	ret    

00000679 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     679:	55                   	push   %ebp
     67a:	89 e5                	mov    %esp,%ebp
     67c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     67f:	8b 45 08             	mov    0x8(%ebp),%eax
     682:	8b 00                	mov    (%eax),%eax
     684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     687:	eb 04                	jmp    68d <peek+0x14>
    s++;
     689:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     68d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     690:	3b 45 0c             	cmp    0xc(%ebp),%eax
     693:	73 1d                	jae    6b2 <peek+0x39>
     695:	8b 45 f4             	mov    -0xc(%ebp),%eax
     698:	0f b6 00             	movzbl (%eax),%eax
     69b:	0f be c0             	movsbl %al,%eax
     69e:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a2:	c7 04 24 54 18 00 00 	movl   $0x1854,(%esp)
     6a9:	e8 2c 07 00 00       	call   dda <strchr>
     6ae:	85 c0                	test   %eax,%eax
     6b0:	75 d7                	jne    689 <peek+0x10>
    s++;
  *ps = s;
     6b2:	8b 45 08             	mov    0x8(%ebp),%eax
     6b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6b8:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6bd:	0f b6 00             	movzbl (%eax),%eax
     6c0:	84 c0                	test   %al,%al
     6c2:	74 23                	je     6e7 <peek+0x6e>
     6c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c7:	0f b6 00             	movzbl (%eax),%eax
     6ca:	0f be c0             	movsbl %al,%eax
     6cd:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d1:	8b 45 10             	mov    0x10(%ebp),%eax
     6d4:	89 04 24             	mov    %eax,(%esp)
     6d7:	e8 fe 06 00 00       	call   dda <strchr>
     6dc:	85 c0                	test   %eax,%eax
     6de:	74 07                	je     6e7 <peek+0x6e>
     6e0:	b8 01 00 00 00       	mov    $0x1,%eax
     6e5:	eb 05                	jmp    6ec <peek+0x73>
     6e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6ec:	c9                   	leave  
     6ed:	c3                   	ret    

000006ee <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6ee:	55                   	push   %ebp
     6ef:	89 e5                	mov    %esp,%ebp
     6f1:	53                   	push   %ebx
     6f2:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6f8:	8b 45 08             	mov    0x8(%ebp),%eax
     6fb:	89 04 24             	mov    %eax,(%esp)
     6fe:	e8 8e 06 00 00       	call   d91 <strlen>
     703:	8d 04 03             	lea    (%ebx,%eax,1),%eax
     706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = parseline(&s, es);
     709:	8b 45 f0             	mov    -0x10(%ebp),%eax
     70c:	89 44 24 04          	mov    %eax,0x4(%esp)
     710:	8d 45 08             	lea    0x8(%ebp),%eax
     713:	89 04 24             	mov    %eax,(%esp)
     716:	e8 60 00 00 00       	call   77b <parseline>
     71b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  peek(&s, es, "");
     71e:	c7 44 24 08 96 17 00 	movl   $0x1796,0x8(%esp)
     725:	00 
     726:	8b 45 f0             	mov    -0x10(%ebp),%eax
     729:	89 44 24 04          	mov    %eax,0x4(%esp)
     72d:	8d 45 08             	lea    0x8(%ebp),%eax
     730:	89 04 24             	mov    %eax,(%esp)
     733:	e8 41 ff ff ff       	call   679 <peek>
  if(s != es){
     738:	8b 45 08             	mov    0x8(%ebp),%eax
     73b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     73e:	74 27                	je     767 <parsecmd+0x79>
    printf(2, "leftovers: %s\n", s);
     740:	8b 45 08             	mov    0x8(%ebp),%eax
     743:	89 44 24 08          	mov    %eax,0x8(%esp)
     747:	c7 44 24 04 97 17 00 	movl   $0x1797,0x4(%esp)
     74e:	00 
     74f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     756:	e8 9a 09 00 00       	call   10f5 <printf>
    panic("syntax");
     75b:	c7 04 24 a6 17 00 00 	movl   $0x17a6,(%esp)
     762:	e8 f2 fb ff ff       	call   359 <panic>
  }
  nulterminate(cmd);
     767:	8b 45 f4             	mov    -0xc(%ebp),%eax
     76a:	89 04 24             	mov    %eax,(%esp)
     76d:	e8 a4 04 00 00       	call   c16 <nulterminate>
  return cmd;
     772:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     775:	83 c4 24             	add    $0x24,%esp
     778:	5b                   	pop    %ebx
     779:	5d                   	pop    %ebp
     77a:	c3                   	ret    

0000077b <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77b:	55                   	push   %ebp
     77c:	89 e5                	mov    %esp,%ebp
     77e:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     781:	8b 45 0c             	mov    0xc(%ebp),%eax
     784:	89 44 24 04          	mov    %eax,0x4(%esp)
     788:	8b 45 08             	mov    0x8(%ebp),%eax
     78b:	89 04 24             	mov    %eax,(%esp)
     78e:	e8 bc 00 00 00       	call   84f <parsepipe>
     793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     796:	eb 30                	jmp    7c8 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     798:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     79f:	00 
     7a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7a7:	00 
     7a8:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ab:	89 44 24 04          	mov    %eax,0x4(%esp)
     7af:	8b 45 08             	mov    0x8(%ebp),%eax
     7b2:	89 04 24             	mov    %eax,(%esp)
     7b5:	e8 7a fd ff ff       	call   534 <gettoken>
    cmd = backcmd(cmd);
     7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7bd:	89 04 24             	mov    %eax,(%esp)
     7c0:	e8 28 fd ff ff       	call   4ed <backcmd>
     7c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7c8:	c7 44 24 08 ad 17 00 	movl   $0x17ad,0x8(%esp)
     7cf:	00 
     7d0:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d3:	89 44 24 04          	mov    %eax,0x4(%esp)
     7d7:	8b 45 08             	mov    0x8(%ebp),%eax
     7da:	89 04 24             	mov    %eax,(%esp)
     7dd:	e8 97 fe ff ff       	call   679 <peek>
     7e2:	85 c0                	test   %eax,%eax
     7e4:	75 b2                	jne    798 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e6:	c7 44 24 08 af 17 00 	movl   $0x17af,0x8(%esp)
     7ed:	00 
     7ee:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f5:	8b 45 08             	mov    0x8(%ebp),%eax
     7f8:	89 04 24             	mov    %eax,(%esp)
     7fb:	e8 79 fe ff ff       	call   679 <peek>
     800:	85 c0                	test   %eax,%eax
     802:	74 46                	je     84a <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     804:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80b:	00 
     80c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     813:	00 
     814:	8b 45 0c             	mov    0xc(%ebp),%eax
     817:	89 44 24 04          	mov    %eax,0x4(%esp)
     81b:	8b 45 08             	mov    0x8(%ebp),%eax
     81e:	89 04 24             	mov    %eax,(%esp)
     821:	e8 0e fd ff ff       	call   534 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     826:	8b 45 0c             	mov    0xc(%ebp),%eax
     829:	89 44 24 04          	mov    %eax,0x4(%esp)
     82d:	8b 45 08             	mov    0x8(%ebp),%eax
     830:	89 04 24             	mov    %eax,(%esp)
     833:	e8 43 ff ff ff       	call   77b <parseline>
     838:	89 44 24 04          	mov    %eax,0x4(%esp)
     83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83f:	89 04 24             	mov    %eax,(%esp)
     842:	e8 56 fc ff ff       	call   49d <listcmd>
     847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     84d:	c9                   	leave  
     84e:	c3                   	ret    

0000084f <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     84f:	55                   	push   %ebp
     850:	89 e5                	mov    %esp,%ebp
     852:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     855:	8b 45 0c             	mov    0xc(%ebp),%eax
     858:	89 44 24 04          	mov    %eax,0x4(%esp)
     85c:	8b 45 08             	mov    0x8(%ebp),%eax
     85f:	89 04 24             	mov    %eax,(%esp)
     862:	e8 67 02 00 00       	call   ace <parseexec>
     867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86a:	c7 44 24 08 b1 17 00 	movl   $0x17b1,0x8(%esp)
     871:	00 
     872:	8b 45 0c             	mov    0xc(%ebp),%eax
     875:	89 44 24 04          	mov    %eax,0x4(%esp)
     879:	8b 45 08             	mov    0x8(%ebp),%eax
     87c:	89 04 24             	mov    %eax,(%esp)
     87f:	e8 f5 fd ff ff       	call   679 <peek>
     884:	85 c0                	test   %eax,%eax
     886:	74 46                	je     8ce <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     888:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     88f:	00 
     890:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     897:	00 
     898:	8b 45 0c             	mov    0xc(%ebp),%eax
     89b:	89 44 24 04          	mov    %eax,0x4(%esp)
     89f:	8b 45 08             	mov    0x8(%ebp),%eax
     8a2:	89 04 24             	mov    %eax,(%esp)
     8a5:	e8 8a fc ff ff       	call   534 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8aa:	8b 45 0c             	mov    0xc(%ebp),%eax
     8ad:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b1:	8b 45 08             	mov    0x8(%ebp),%eax
     8b4:	89 04 24             	mov    %eax,(%esp)
     8b7:	e8 93 ff ff ff       	call   84f <parsepipe>
     8bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c3:	89 04 24             	mov    %eax,(%esp)
     8c6:	e8 82 fb ff ff       	call   44d <pipecmd>
     8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d1:	c9                   	leave  
     8d2:	c3                   	ret    

000008d3 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d3:	55                   	push   %ebp
     8d4:	89 e5                	mov    %esp,%ebp
     8d6:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8d9:	e9 f5 00 00 00       	jmp    9d3 <parseredirs+0x100>
    tok = gettoken(ps, es, 0, 0);
     8de:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e5:	00 
     8e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8ed:	00 
     8ee:	8b 45 10             	mov    0x10(%ebp),%eax
     8f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f8:	89 04 24             	mov    %eax,(%esp)
     8fb:	e8 34 fc ff ff       	call   534 <gettoken>
     900:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     903:	8d 45 ec             	lea    -0x14(%ebp),%eax
     906:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90a:	8d 45 f0             	lea    -0x10(%ebp),%eax
     90d:	89 44 24 08          	mov    %eax,0x8(%esp)
     911:	8b 45 10             	mov    0x10(%ebp),%eax
     914:	89 44 24 04          	mov    %eax,0x4(%esp)
     918:	8b 45 0c             	mov    0xc(%ebp),%eax
     91b:	89 04 24             	mov    %eax,(%esp)
     91e:	e8 11 fc ff ff       	call   534 <gettoken>
     923:	83 f8 61             	cmp    $0x61,%eax
     926:	74 0c                	je     934 <parseredirs+0x61>
      panic("missing file for redirection");
     928:	c7 04 24 b3 17 00 00 	movl   $0x17b3,(%esp)
     92f:	e8 25 fa ff ff       	call   359 <panic>
    switch(tok){
     934:	8b 45 f4             	mov    -0xc(%ebp),%eax
     937:	83 f8 3c             	cmp    $0x3c,%eax
     93a:	74 0f                	je     94b <parseredirs+0x78>
     93c:	83 f8 3e             	cmp    $0x3e,%eax
     93f:	74 38                	je     979 <parseredirs+0xa6>
     941:	83 f8 2b             	cmp    $0x2b,%eax
     944:	74 61                	je     9a7 <parseredirs+0xd4>
     946:	e9 88 00 00 00       	jmp    9d3 <parseredirs+0x100>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     94e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     951:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     958:	00 
     959:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     960:	00 
     961:	89 54 24 08          	mov    %edx,0x8(%esp)
     965:	89 44 24 04          	mov    %eax,0x4(%esp)
     969:	8b 45 08             	mov    0x8(%ebp),%eax
     96c:	89 04 24             	mov    %eax,(%esp)
     96f:	e8 6e fa ff ff       	call   3e2 <redircmd>
     974:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     977:	eb 5a                	jmp    9d3 <parseredirs+0x100>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     979:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     97f:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     986:	00 
     987:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     98e:	00 
     98f:	89 54 24 08          	mov    %edx,0x8(%esp)
     993:	89 44 24 04          	mov    %eax,0x4(%esp)
     997:	8b 45 08             	mov    0x8(%ebp),%eax
     99a:	89 04 24             	mov    %eax,(%esp)
     99d:	e8 40 fa ff ff       	call   3e2 <redircmd>
     9a2:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a5:	eb 2c                	jmp    9d3 <parseredirs+0x100>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ad:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b4:	00 
     9b5:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bc:	00 
     9bd:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c5:	8b 45 08             	mov    0x8(%ebp),%eax
     9c8:	89 04 24             	mov    %eax,(%esp)
     9cb:	e8 12 fa ff ff       	call   3e2 <redircmd>
     9d0:	89 45 08             	mov    %eax,0x8(%ebp)
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d3:	c7 44 24 08 d0 17 00 	movl   $0x17d0,0x8(%esp)
     9da:	00 
     9db:	8b 45 10             	mov    0x10(%ebp),%eax
     9de:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e2:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e5:	89 04 24             	mov    %eax,(%esp)
     9e8:	e8 8c fc ff ff       	call   679 <peek>
     9ed:	85 c0                	test   %eax,%eax
     9ef:	0f 85 e9 fe ff ff    	jne    8de <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9f8:	c9                   	leave  
     9f9:	c3                   	ret    

000009fa <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fa:	55                   	push   %ebp
     9fb:	89 e5                	mov    %esp,%ebp
     9fd:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a00:	c7 44 24 08 d3 17 00 	movl   $0x17d3,0x8(%esp)
     a07:	00 
     a08:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
     a0f:	8b 45 08             	mov    0x8(%ebp),%eax
     a12:	89 04 24             	mov    %eax,(%esp)
     a15:	e8 5f fc ff ff       	call   679 <peek>
     a1a:	85 c0                	test   %eax,%eax
     a1c:	75 0c                	jne    a2a <parseblock+0x30>
    panic("parseblock");
     a1e:	c7 04 24 d5 17 00 00 	movl   $0x17d5,(%esp)
     a25:	e8 2f f9 ff ff       	call   359 <panic>
  gettoken(ps, es, 0, 0);
     a2a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a31:	00 
     a32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a39:	00 
     a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     a41:	8b 45 08             	mov    0x8(%ebp),%eax
     a44:	89 04 24             	mov    %eax,(%esp)
     a47:	e8 e8 fa ff ff       	call   534 <gettoken>
  cmd = parseline(ps, es);
     a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a53:	8b 45 08             	mov    0x8(%ebp),%eax
     a56:	89 04 24             	mov    %eax,(%esp)
     a59:	e8 1d fd ff ff       	call   77b <parseline>
     a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a61:	c7 44 24 08 e0 17 00 	movl   $0x17e0,0x8(%esp)
     a68:	00 
     a69:	8b 45 0c             	mov    0xc(%ebp),%eax
     a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
     a70:	8b 45 08             	mov    0x8(%ebp),%eax
     a73:	89 04 24             	mov    %eax,(%esp)
     a76:	e8 fe fb ff ff       	call   679 <peek>
     a7b:	85 c0                	test   %eax,%eax
     a7d:	75 0c                	jne    a8b <parseblock+0x91>
    panic("syntax - missing )");
     a7f:	c7 04 24 e2 17 00 00 	movl   $0x17e2,(%esp)
     a86:	e8 ce f8 ff ff       	call   359 <panic>
  gettoken(ps, es, 0, 0);
     a8b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a92:	00 
     a93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9a:	00 
     a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa2:	8b 45 08             	mov    0x8(%ebp),%eax
     aa5:	89 04 24             	mov    %eax,(%esp)
     aa8:	e8 87 fa ff ff       	call   534 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     aad:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab0:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab4:	8b 45 08             	mov    0x8(%ebp),%eax
     ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
     abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     abe:	89 04 24             	mov    %eax,(%esp)
     ac1:	e8 0d fe ff ff       	call   8d3 <parseredirs>
     ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     acc:	c9                   	leave  
     acd:	c3                   	ret    

00000ace <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ace:	55                   	push   %ebp
     acf:	89 e5                	mov    %esp,%ebp
     ad1:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad4:	c7 44 24 08 d3 17 00 	movl   $0x17d3,0x8(%esp)
     adb:	00 
     adc:	8b 45 0c             	mov    0xc(%ebp),%eax
     adf:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae3:	8b 45 08             	mov    0x8(%ebp),%eax
     ae6:	89 04 24             	mov    %eax,(%esp)
     ae9:	e8 8b fb ff ff       	call   679 <peek>
     aee:	85 c0                	test   %eax,%eax
     af0:	74 17                	je     b09 <parseexec+0x3b>
    return parseblock(ps, es);
     af2:	8b 45 0c             	mov    0xc(%ebp),%eax
     af5:	89 44 24 04          	mov    %eax,0x4(%esp)
     af9:	8b 45 08             	mov    0x8(%ebp),%eax
     afc:	89 04 24             	mov    %eax,(%esp)
     aff:	e8 f6 fe ff ff       	call   9fa <parseblock>
     b04:	e9 0b 01 00 00       	jmp    c14 <parseexec+0x146>

  ret = execcmd();
     b09:	e8 96 f8 ff ff       	call   3a4 <execcmd>
     b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = (struct execcmd*)ret;
     b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b14:	89 45 f0             	mov    %eax,-0x10(%ebp)

  argc = 0;
     b17:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ret = parseredirs(ret, ps, es);
     b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
     b21:	89 44 24 08          	mov    %eax,0x8(%esp)
     b25:	8b 45 08             	mov    0x8(%ebp),%eax
     b28:	89 44 24 04          	mov    %eax,0x4(%esp)
     b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2f:	89 04 24             	mov    %eax,(%esp)
     b32:	e8 9c fd ff ff       	call   8d3 <parseredirs>
     b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3a:	e9 8e 00 00 00       	jmp    bcd <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b3f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b42:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b49:	89 44 24 08          	mov    %eax,0x8(%esp)
     b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
     b50:	89 44 24 04          	mov    %eax,0x4(%esp)
     b54:	8b 45 08             	mov    0x8(%ebp),%eax
     b57:	89 04 24             	mov    %eax,(%esp)
     b5a:	e8 d5 f9 ff ff       	call   534 <gettoken>
     b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b62:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b66:	0f 84 85 00 00 00    	je     bf1 <parseexec+0x123>
      break;
    if(tok != 'a')
     b6c:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b70:	74 0c                	je     b7e <parseexec+0xb0>
      panic("syntax");
     b72:	c7 04 24 a6 17 00 00 	movl   $0x17a6,(%esp)
     b79:	e8 db f7 ff ff       	call   359 <panic>
    cmd->argv[argc] = q;
     b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b87:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b8b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
     b8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b94:	83 c1 08             	add    $0x8,%ecx
     b97:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b9b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(argc >= MAXARGS)
     b9f:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
     ba3:	7e 0c                	jle    bb1 <parseexec+0xe3>
      panic("too many args");
     ba5:	c7 04 24 f5 17 00 00 	movl   $0x17f5,(%esp)
     bac:	e8 a8 f7 ff ff       	call   359 <panic>
    ret = parseredirs(ret, ps, es);
     bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
     bb8:	8b 45 08             	mov    0x8(%ebp),%eax
     bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
     bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc2:	89 04 24             	mov    %eax,(%esp)
     bc5:	e8 09 fd ff ff       	call   8d3 <parseredirs>
     bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bcd:	c7 44 24 08 03 18 00 	movl   $0x1803,0x8(%esp)
     bd4:	00 
     bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
     bdc:	8b 45 08             	mov    0x8(%ebp),%eax
     bdf:	89 04 24             	mov    %eax,(%esp)
     be2:	e8 92 fa ff ff       	call   679 <peek>
     be7:	85 c0                	test   %eax,%eax
     be9:	0f 84 50 ff ff ff    	je     b3f <parseexec+0x71>
     bef:	eb 01                	jmp    bf2 <parseexec+0x124>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     bf1:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
     bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bf8:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     bff:	00 
  cmd->eargv[argc] = 0;
     c00:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c06:	83 c2 08             	add    $0x8,%edx
     c09:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c10:	00 
  return ret;
     c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c14:	c9                   	leave  
     c15:	c3                   	ret    

00000c16 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c16:	55                   	push   %ebp
     c17:	89 e5                	mov    %esp,%ebp
     c19:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c20:	75 0a                	jne    c2c <nulterminate+0x16>
    return 0;
     c22:	b8 00 00 00 00       	mov    $0x0,%eax
     c27:	e9 c8 00 00 00       	jmp    cf4 <nulterminate+0xde>
  
  switch(cmd->type){
     c2c:	8b 45 08             	mov    0x8(%ebp),%eax
     c2f:	8b 00                	mov    (%eax),%eax
     c31:	83 f8 05             	cmp    $0x5,%eax
     c34:	0f 87 b7 00 00 00    	ja     cf1 <nulterminate+0xdb>
     c3a:	8b 04 85 08 18 00 00 	mov    0x1808(,%eax,4),%eax
     c41:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c43:	8b 45 08             	mov    0x8(%ebp),%eax
     c46:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c49:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     c50:	eb 14                	jmp    c66 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c52:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c58:	83 c2 08             	add    $0x8,%edx
     c5b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c5f:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c62:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
     c66:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c6c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c70:	85 c0                	test   %eax,%eax
     c72:	75 de                	jne    c52 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c74:	eb 7b                	jmp    cf1 <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c76:	8b 45 08             	mov    0x8(%ebp),%eax
     c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    nulterminate(rcmd->cmd);
     c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c7f:	8b 40 04             	mov    0x4(%eax),%eax
     c82:	89 04 24             	mov    %eax,(%esp)
     c85:	e8 8c ff ff ff       	call   c16 <nulterminate>
    *rcmd->efile = 0;
     c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c8d:	8b 40 0c             	mov    0xc(%eax),%eax
     c90:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c93:	eb 5c                	jmp    cf1 <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c95:	8b 45 08             	mov    0x8(%ebp),%eax
     c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(pcmd->left);
     c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c9e:	8b 40 04             	mov    0x4(%eax),%eax
     ca1:	89 04 24             	mov    %eax,(%esp)
     ca4:	e8 6d ff ff ff       	call   c16 <nulterminate>
    nulterminate(pcmd->right);
     ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cac:	8b 40 08             	mov    0x8(%eax),%eax
     caf:	89 04 24             	mov    %eax,(%esp)
     cb2:	e8 5f ff ff ff       	call   c16 <nulterminate>
    break;
     cb7:	eb 38                	jmp    cf1 <nulterminate+0xdb>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cb9:	8b 45 08             	mov    0x8(%ebp),%eax
     cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
     cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cc2:	8b 40 04             	mov    0x4(%eax),%eax
     cc5:	89 04 24             	mov    %eax,(%esp)
     cc8:	e8 49 ff ff ff       	call   c16 <nulterminate>
    nulterminate(lcmd->right);
     ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cd0:	8b 40 08             	mov    0x8(%eax),%eax
     cd3:	89 04 24             	mov    %eax,(%esp)
     cd6:	e8 3b ff ff ff       	call   c16 <nulterminate>
    break;
     cdb:	eb 14                	jmp    cf1 <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cdd:	8b 45 08             	mov    0x8(%ebp),%eax
     ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(bcmd->cmd);
     ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ce6:	8b 40 04             	mov    0x4(%eax),%eax
     ce9:	89 04 24             	mov    %eax,(%esp)
     cec:	e8 25 ff ff ff       	call   c16 <nulterminate>
    break;
  }
  return cmd;
     cf1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf4:	c9                   	leave  
     cf5:	c3                   	ret    
     cf6:	90                   	nop
     cf7:	90                   	nop

00000cf8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cf8:	55                   	push   %ebp
     cf9:	89 e5                	mov    %esp,%ebp
     cfb:	57                   	push   %edi
     cfc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d00:	8b 55 10             	mov    0x10(%ebp),%edx
     d03:	8b 45 0c             	mov    0xc(%ebp),%eax
     d06:	89 cb                	mov    %ecx,%ebx
     d08:	89 df                	mov    %ebx,%edi
     d0a:	89 d1                	mov    %edx,%ecx
     d0c:	fc                   	cld    
     d0d:	f3 aa                	rep stos %al,%es:(%edi)
     d0f:	89 ca                	mov    %ecx,%edx
     d11:	89 fb                	mov    %edi,%ebx
     d13:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d16:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d19:	5b                   	pop    %ebx
     d1a:	5f                   	pop    %edi
     d1b:	5d                   	pop    %ebp
     d1c:	c3                   	ret    

00000d1d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d1d:	55                   	push   %ebp
     d1e:	89 e5                	mov    %esp,%ebp
     d20:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d23:	8b 45 08             	mov    0x8(%ebp),%eax
     d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d29:	8b 45 0c             	mov    0xc(%ebp),%eax
     d2c:	0f b6 10             	movzbl (%eax),%edx
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
     d32:	88 10                	mov    %dl,(%eax)
     d34:	8b 45 08             	mov    0x8(%ebp),%eax
     d37:	0f b6 00             	movzbl (%eax),%eax
     d3a:	84 c0                	test   %al,%al
     d3c:	0f 95 c0             	setne  %al
     d3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d43:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     d47:	84 c0                	test   %al,%al
     d49:	75 de                	jne    d29 <strcpy+0xc>
    ;
  return os;
     d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d4e:	c9                   	leave  
     d4f:	c3                   	ret    

00000d50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d50:	55                   	push   %ebp
     d51:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d53:	eb 08                	jmp    d5d <strcmp+0xd>
    p++, q++;
     d55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d59:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d5d:	8b 45 08             	mov    0x8(%ebp),%eax
     d60:	0f b6 00             	movzbl (%eax),%eax
     d63:	84 c0                	test   %al,%al
     d65:	74 10                	je     d77 <strcmp+0x27>
     d67:	8b 45 08             	mov    0x8(%ebp),%eax
     d6a:	0f b6 10             	movzbl (%eax),%edx
     d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d70:	0f b6 00             	movzbl (%eax),%eax
     d73:	38 c2                	cmp    %al,%dl
     d75:	74 de                	je     d55 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d77:	8b 45 08             	mov    0x8(%ebp),%eax
     d7a:	0f b6 00             	movzbl (%eax),%eax
     d7d:	0f b6 d0             	movzbl %al,%edx
     d80:	8b 45 0c             	mov    0xc(%ebp),%eax
     d83:	0f b6 00             	movzbl (%eax),%eax
     d86:	0f b6 c0             	movzbl %al,%eax
     d89:	89 d1                	mov    %edx,%ecx
     d8b:	29 c1                	sub    %eax,%ecx
     d8d:	89 c8                	mov    %ecx,%eax
}
     d8f:	5d                   	pop    %ebp
     d90:	c3                   	ret    

00000d91 <strlen>:

uint
strlen(char *s)
{
     d91:	55                   	push   %ebp
     d92:	89 e5                	mov    %esp,%ebp
     d94:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d9e:	eb 04                	jmp    da4 <strlen+0x13>
     da0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     da7:	03 45 08             	add    0x8(%ebp),%eax
     daa:	0f b6 00             	movzbl (%eax),%eax
     dad:	84 c0                	test   %al,%al
     daf:	75 ef                	jne    da0 <strlen+0xf>
    ;
  return n;
     db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     db4:	c9                   	leave  
     db5:	c3                   	ret    

00000db6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     db6:	55                   	push   %ebp
     db7:	89 e5                	mov    %esp,%ebp
     db9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     dbc:	8b 45 10             	mov    0x10(%ebp),%eax
     dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
     dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
     dca:	8b 45 08             	mov    0x8(%ebp),%eax
     dcd:	89 04 24             	mov    %eax,(%esp)
     dd0:	e8 23 ff ff ff       	call   cf8 <stosb>
  return dst;
     dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dd8:	c9                   	leave  
     dd9:	c3                   	ret    

00000dda <strchr>:

char*
strchr(const char *s, char c)
{
     dda:	55                   	push   %ebp
     ddb:	89 e5                	mov    %esp,%ebp
     ddd:	83 ec 04             	sub    $0x4,%esp
     de0:	8b 45 0c             	mov    0xc(%ebp),%eax
     de3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     de6:	eb 14                	jmp    dfc <strchr+0x22>
    if(*s == c)
     de8:	8b 45 08             	mov    0x8(%ebp),%eax
     deb:	0f b6 00             	movzbl (%eax),%eax
     dee:	3a 45 fc             	cmp    -0x4(%ebp),%al
     df1:	75 05                	jne    df8 <strchr+0x1e>
      return (char*)s;
     df3:	8b 45 08             	mov    0x8(%ebp),%eax
     df6:	eb 13                	jmp    e0b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     df8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     dfc:	8b 45 08             	mov    0x8(%ebp),%eax
     dff:	0f b6 00             	movzbl (%eax),%eax
     e02:	84 c0                	test   %al,%al
     e04:	75 e2                	jne    de8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e0b:	c9                   	leave  
     e0c:	c3                   	ret    

00000e0d <gets>:

char*
gets(char *buf, int max)
{
     e0d:	55                   	push   %ebp
     e0e:	89 e5                	mov    %esp,%ebp
     e10:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     e1a:	eb 44                	jmp    e60 <gets+0x53>
    cc = read(0, &c, 1);
     e1c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e23:	00 
     e24:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e27:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e32:	e8 3d 01 00 00       	call   f74 <read>
     e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
     e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e3e:	7e 2d                	jle    e6d <gets+0x60>
      break;
    buf[i++] = c;
     e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e43:	03 45 08             	add    0x8(%ebp),%eax
     e46:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     e4a:	88 10                	mov    %dl,(%eax)
     e4c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
     e50:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e54:	3c 0a                	cmp    $0xa,%al
     e56:	74 16                	je     e6e <gets+0x61>
     e58:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e5c:	3c 0d                	cmp    $0xd,%al
     e5e:	74 0e                	je     e6e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e63:	83 c0 01             	add    $0x1,%eax
     e66:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e69:	7c b1                	jl     e1c <gets+0xf>
     e6b:	eb 01                	jmp    e6e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     e6d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e71:	03 45 08             	add    0x8(%ebp),%eax
     e74:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e7a:	c9                   	leave  
     e7b:	c3                   	ret    

00000e7c <stat>:

int
stat(char *n, struct stat *st)
{
     e7c:	55                   	push   %ebp
     e7d:	89 e5                	mov    %esp,%ebp
     e7f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e89:	00 
     e8a:	8b 45 08             	mov    0x8(%ebp),%eax
     e8d:	89 04 24             	mov    %eax,(%esp)
     e90:	e8 07 01 00 00       	call   f9c <open>
     e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
     e98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e9c:	79 07                	jns    ea5 <stat+0x29>
    return -1;
     e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea3:	eb 23                	jmp    ec8 <stat+0x4c>
  r = fstat(fd, st);
     ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
     eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eaf:	89 04 24             	mov    %eax,(%esp)
     eb2:	e8 fd 00 00 00       	call   fb4 <fstat>
     eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
     eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ebd:	89 04 24             	mov    %eax,(%esp)
     ec0:	e8 bf 00 00 00       	call   f84 <close>
  return r;
     ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ec8:	c9                   	leave  
     ec9:	c3                   	ret    

00000eca <atoi>:

int
atoi(const char *s)
{
     eca:	55                   	push   %ebp
     ecb:	89 e5                	mov    %esp,%ebp
     ecd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ed7:	eb 24                	jmp    efd <atoi+0x33>
    n = n*10 + *s++ - '0';
     ed9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     edc:	89 d0                	mov    %edx,%eax
     ede:	c1 e0 02             	shl    $0x2,%eax
     ee1:	01 d0                	add    %edx,%eax
     ee3:	01 c0                	add    %eax,%eax
     ee5:	89 c2                	mov    %eax,%edx
     ee7:	8b 45 08             	mov    0x8(%ebp),%eax
     eea:	0f b6 00             	movzbl (%eax),%eax
     eed:	0f be c0             	movsbl %al,%eax
     ef0:	8d 04 02             	lea    (%edx,%eax,1),%eax
     ef3:	83 e8 30             	sub    $0x30,%eax
     ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     ef9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     efd:	8b 45 08             	mov    0x8(%ebp),%eax
     f00:	0f b6 00             	movzbl (%eax),%eax
     f03:	3c 2f                	cmp    $0x2f,%al
     f05:	7e 0a                	jle    f11 <atoi+0x47>
     f07:	8b 45 08             	mov    0x8(%ebp),%eax
     f0a:	0f b6 00             	movzbl (%eax),%eax
     f0d:	3c 39                	cmp    $0x39,%al
     f0f:	7e c8                	jle    ed9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f14:	c9                   	leave  
     f15:	c3                   	ret    

00000f16 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f16:	55                   	push   %ebp
     f17:	89 e5                	mov    %esp,%ebp
     f19:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f1c:	8b 45 08             	mov    0x8(%ebp),%eax
     f1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
     f22:	8b 45 0c             	mov    0xc(%ebp),%eax
     f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
     f28:	eb 13                	jmp    f3d <memmove+0x27>
    *dst++ = *src++;
     f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f2d:	0f b6 10             	movzbl (%eax),%edx
     f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f33:	88 10                	mov    %dl,(%eax)
     f35:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
     f39:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f41:	0f 9f c0             	setg   %al
     f44:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     f48:	84 c0                	test   %al,%al
     f4a:	75 de                	jne    f2a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f4f:	c9                   	leave  
     f50:	c3                   	ret    
     f51:	90                   	nop
     f52:	90                   	nop
     f53:	90                   	nop

00000f54 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f54:	b8 01 00 00 00       	mov    $0x1,%eax
     f59:	cd 40                	int    $0x40
     f5b:	c3                   	ret    

00000f5c <exit>:
SYSCALL(exit)
     f5c:	b8 02 00 00 00       	mov    $0x2,%eax
     f61:	cd 40                	int    $0x40
     f63:	c3                   	ret    

00000f64 <wait>:
SYSCALL(wait)
     f64:	b8 03 00 00 00       	mov    $0x3,%eax
     f69:	cd 40                	int    $0x40
     f6b:	c3                   	ret    

00000f6c <pipe>:
SYSCALL(pipe)
     f6c:	b8 04 00 00 00       	mov    $0x4,%eax
     f71:	cd 40                	int    $0x40
     f73:	c3                   	ret    

00000f74 <read>:
SYSCALL(read)
     f74:	b8 05 00 00 00       	mov    $0x5,%eax
     f79:	cd 40                	int    $0x40
     f7b:	c3                   	ret    

00000f7c <write>:
SYSCALL(write)
     f7c:	b8 10 00 00 00       	mov    $0x10,%eax
     f81:	cd 40                	int    $0x40
     f83:	c3                   	ret    

00000f84 <close>:
SYSCALL(close)
     f84:	b8 15 00 00 00       	mov    $0x15,%eax
     f89:	cd 40                	int    $0x40
     f8b:	c3                   	ret    

00000f8c <kill>:
SYSCALL(kill)
     f8c:	b8 06 00 00 00       	mov    $0x6,%eax
     f91:	cd 40                	int    $0x40
     f93:	c3                   	ret    

00000f94 <exec>:
SYSCALL(exec)
     f94:	b8 07 00 00 00       	mov    $0x7,%eax
     f99:	cd 40                	int    $0x40
     f9b:	c3                   	ret    

00000f9c <open>:
SYSCALL(open)
     f9c:	b8 0f 00 00 00       	mov    $0xf,%eax
     fa1:	cd 40                	int    $0x40
     fa3:	c3                   	ret    

00000fa4 <mknod>:
SYSCALL(mknod)
     fa4:	b8 11 00 00 00       	mov    $0x11,%eax
     fa9:	cd 40                	int    $0x40
     fab:	c3                   	ret    

00000fac <unlink>:
SYSCALL(unlink)
     fac:	b8 12 00 00 00       	mov    $0x12,%eax
     fb1:	cd 40                	int    $0x40
     fb3:	c3                   	ret    

00000fb4 <fstat>:
SYSCALL(fstat)
     fb4:	b8 08 00 00 00       	mov    $0x8,%eax
     fb9:	cd 40                	int    $0x40
     fbb:	c3                   	ret    

00000fbc <link>:
SYSCALL(link)
     fbc:	b8 13 00 00 00       	mov    $0x13,%eax
     fc1:	cd 40                	int    $0x40
     fc3:	c3                   	ret    

00000fc4 <mkdir>:
SYSCALL(mkdir)
     fc4:	b8 14 00 00 00       	mov    $0x14,%eax
     fc9:	cd 40                	int    $0x40
     fcb:	c3                   	ret    

00000fcc <chdir>:
SYSCALL(chdir)
     fcc:	b8 09 00 00 00       	mov    $0x9,%eax
     fd1:	cd 40                	int    $0x40
     fd3:	c3                   	ret    

00000fd4 <dup>:
SYSCALL(dup)
     fd4:	b8 0a 00 00 00       	mov    $0xa,%eax
     fd9:	cd 40                	int    $0x40
     fdb:	c3                   	ret    

00000fdc <getpid>:
SYSCALL(getpid)
     fdc:	b8 0b 00 00 00       	mov    $0xb,%eax
     fe1:	cd 40                	int    $0x40
     fe3:	c3                   	ret    

00000fe4 <sbrk>:
SYSCALL(sbrk)
     fe4:	b8 0c 00 00 00       	mov    $0xc,%eax
     fe9:	cd 40                	int    $0x40
     feb:	c3                   	ret    

00000fec <sleep>:
SYSCALL(sleep)
     fec:	b8 0d 00 00 00       	mov    $0xd,%eax
     ff1:	cd 40                	int    $0x40
     ff3:	c3                   	ret    

00000ff4 <uptime>:
SYSCALL(uptime)
     ff4:	b8 0e 00 00 00       	mov    $0xe,%eax
     ff9:	cd 40                	int    $0x40
     ffb:	c3                   	ret    

00000ffc <clone>:
SYSCALL(clone)
     ffc:	b8 16 00 00 00       	mov    $0x16,%eax
    1001:	cd 40                	int    $0x40
    1003:	c3                   	ret    

00001004 <texit>:
SYSCALL(texit)
    1004:	b8 17 00 00 00       	mov    $0x17,%eax
    1009:	cd 40                	int    $0x40
    100b:	c3                   	ret    

0000100c <tsleep>:
SYSCALL(tsleep)
    100c:	b8 18 00 00 00       	mov    $0x18,%eax
    1011:	cd 40                	int    $0x40
    1013:	c3                   	ret    

00001014 <twakeup>:
SYSCALL(twakeup)
    1014:	b8 19 00 00 00       	mov    $0x19,%eax
    1019:	cd 40                	int    $0x40
    101b:	c3                   	ret    

0000101c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    101c:	55                   	push   %ebp
    101d:	89 e5                	mov    %esp,%ebp
    101f:	83 ec 28             	sub    $0x28,%esp
    1022:	8b 45 0c             	mov    0xc(%ebp),%eax
    1025:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1028:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    102f:	00 
    1030:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1033:	89 44 24 04          	mov    %eax,0x4(%esp)
    1037:	8b 45 08             	mov    0x8(%ebp),%eax
    103a:	89 04 24             	mov    %eax,(%esp)
    103d:	e8 3a ff ff ff       	call   f7c <write>
}
    1042:	c9                   	leave  
    1043:	c3                   	ret    

00001044 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1044:	55                   	push   %ebp
    1045:	89 e5                	mov    %esp,%ebp
    1047:	53                   	push   %ebx
    1048:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    104b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1052:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1056:	74 17                	je     106f <printint+0x2b>
    1058:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    105c:	79 11                	jns    106f <printint+0x2b>
    neg = 1;
    105e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1065:	8b 45 0c             	mov    0xc(%ebp),%eax
    1068:	f7 d8                	neg    %eax
    106a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    106d:	eb 06                	jmp    1075 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    106f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1072:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
    1075:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
    107c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    107f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1085:	ba 00 00 00 00       	mov    $0x0,%edx
    108a:	f7 f3                	div    %ebx
    108c:	89 d0                	mov    %edx,%eax
    108e:	0f b6 80 64 18 00 00 	movzbl 0x1864(%eax),%eax
    1095:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
    1099:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
    109d:	8b 45 10             	mov    0x10(%ebp),%eax
    10a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    10a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a6:	ba 00 00 00 00       	mov    $0x0,%edx
    10ab:	f7 75 d4             	divl   -0x2c(%ebp)
    10ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    10b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10b5:	75 c5                	jne    107c <printint+0x38>
  if(neg)
    10b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10bb:	74 28                	je     10e5 <printint+0xa1>
    buf[i++] = '-';
    10bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
    10c5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
    10c9:	eb 1a                	jmp    10e5 <printint+0xa1>
    putc(fd, buf[i]);
    10cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10ce:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
    10d3:	0f be c0             	movsbl %al,%eax
    10d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    10da:	8b 45 08             	mov    0x8(%ebp),%eax
    10dd:	89 04 24             	mov    %eax,(%esp)
    10e0:	e8 37 ff ff ff       	call   101c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    10e5:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
    10e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10ed:	79 dc                	jns    10cb <printint+0x87>
    putc(fd, buf[i]);
}
    10ef:	83 c4 44             	add    $0x44,%esp
    10f2:	5b                   	pop    %ebx
    10f3:	5d                   	pop    %ebp
    10f4:	c3                   	ret    

000010f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10f5:	55                   	push   %ebp
    10f6:	89 e5                	mov    %esp,%ebp
    10f8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1102:	8d 45 0c             	lea    0xc(%ebp),%eax
    1105:	83 c0 04             	add    $0x4,%eax
    1108:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
    110b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1112:	e9 7e 01 00 00       	jmp    1295 <printf+0x1a0>
    c = fmt[i] & 0xff;
    1117:	8b 55 0c             	mov    0xc(%ebp),%edx
    111a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    111d:	8d 04 02             	lea    (%edx,%eax,1),%eax
    1120:	0f b6 00             	movzbl (%eax),%eax
    1123:	0f be c0             	movsbl %al,%eax
    1126:	25 ff 00 00 00       	and    $0xff,%eax
    112b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
    112e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1132:	75 2c                	jne    1160 <printf+0x6b>
      if(c == '%'){
    1134:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    1138:	75 0c                	jne    1146 <printf+0x51>
        state = '%';
    113a:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
    1141:	e9 4b 01 00 00       	jmp    1291 <printf+0x19c>
      } else {
        putc(fd, c);
    1146:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1149:	0f be c0             	movsbl %al,%eax
    114c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1150:	8b 45 08             	mov    0x8(%ebp),%eax
    1153:	89 04 24             	mov    %eax,(%esp)
    1156:	e8 c1 fe ff ff       	call   101c <putc>
    115b:	e9 31 01 00 00       	jmp    1291 <printf+0x19c>
      }
    } else if(state == '%'){
    1160:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
    1164:	0f 85 27 01 00 00    	jne    1291 <printf+0x19c>
      if(c == 'd'){
    116a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
    116e:	75 2d                	jne    119d <printf+0xa8>
        printint(fd, *ap, 10, 1);
    1170:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1173:	8b 00                	mov    (%eax),%eax
    1175:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    117c:	00 
    117d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1184:	00 
    1185:	89 44 24 04          	mov    %eax,0x4(%esp)
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	89 04 24             	mov    %eax,(%esp)
    118f:	e8 b0 fe ff ff       	call   1044 <printint>
        ap++;
    1194:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    1198:	e9 ed 00 00 00       	jmp    128a <printf+0x195>
      } else if(c == 'x' || c == 'p'){
    119d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
    11a1:	74 06                	je     11a9 <printf+0xb4>
    11a3:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
    11a7:	75 2d                	jne    11d6 <printf+0xe1>
        printint(fd, *ap, 16, 0);
    11a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ac:	8b 00                	mov    (%eax),%eax
    11ae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    11b5:	00 
    11b6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11bd:	00 
    11be:	89 44 24 04          	mov    %eax,0x4(%esp)
    11c2:	8b 45 08             	mov    0x8(%ebp),%eax
    11c5:	89 04 24             	mov    %eax,(%esp)
    11c8:	e8 77 fe ff ff       	call   1044 <printint>
        ap++;
    11cd:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    11d1:	e9 b4 00 00 00       	jmp    128a <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    11d6:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
    11da:	75 46                	jne    1222 <printf+0x12d>
        s = (char*)*ap;
    11dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11df:	8b 00                	mov    (%eax),%eax
    11e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
    11e4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
    11e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    11ec:	75 27                	jne    1215 <printf+0x120>
          s = "(null)";
    11ee:	c7 45 e4 20 18 00 00 	movl   $0x1820,-0x1c(%ebp)
        while(*s != 0){
    11f5:	eb 1f                	jmp    1216 <printf+0x121>
          putc(fd, *s);
    11f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11fa:	0f b6 00             	movzbl (%eax),%eax
    11fd:	0f be c0             	movsbl %al,%eax
    1200:	89 44 24 04          	mov    %eax,0x4(%esp)
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	89 04 24             	mov    %eax,(%esp)
    120a:	e8 0d fe ff ff       	call   101c <putc>
          s++;
    120f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    1213:	eb 01                	jmp    1216 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1215:	90                   	nop
    1216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1219:	0f b6 00             	movzbl (%eax),%eax
    121c:	84 c0                	test   %al,%al
    121e:	75 d7                	jne    11f7 <printf+0x102>
    1220:	eb 68                	jmp    128a <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1222:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
    1226:	75 1d                	jne    1245 <printf+0x150>
        putc(fd, *ap);
    1228:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122b:	8b 00                	mov    (%eax),%eax
    122d:	0f be c0             	movsbl %al,%eax
    1230:	89 44 24 04          	mov    %eax,0x4(%esp)
    1234:	8b 45 08             	mov    0x8(%ebp),%eax
    1237:	89 04 24             	mov    %eax,(%esp)
    123a:	e8 dd fd ff ff       	call   101c <putc>
        ap++;
    123f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    1243:	eb 45                	jmp    128a <printf+0x195>
      } else if(c == '%'){
    1245:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    1249:	75 17                	jne    1262 <printf+0x16d>
        putc(fd, c);
    124b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    124e:	0f be c0             	movsbl %al,%eax
    1251:	89 44 24 04          	mov    %eax,0x4(%esp)
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
    1258:	89 04 24             	mov    %eax,(%esp)
    125b:	e8 bc fd ff ff       	call   101c <putc>
    1260:	eb 28                	jmp    128a <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1262:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1269:	00 
    126a:	8b 45 08             	mov    0x8(%ebp),%eax
    126d:	89 04 24             	mov    %eax,(%esp)
    1270:	e8 a7 fd ff ff       	call   101c <putc>
        putc(fd, c);
    1275:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1278:	0f be c0             	movsbl %al,%eax
    127b:	89 44 24 04          	mov    %eax,0x4(%esp)
    127f:	8b 45 08             	mov    0x8(%ebp),%eax
    1282:	89 04 24             	mov    %eax,(%esp)
    1285:	e8 92 fd ff ff       	call   101c <putc>
      }
      state = 0;
    128a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1291:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1295:	8b 55 0c             	mov    0xc(%ebp),%edx
    1298:	8b 45 ec             	mov    -0x14(%ebp),%eax
    129b:	8d 04 02             	lea    (%edx,%eax,1),%eax
    129e:	0f b6 00             	movzbl (%eax),%eax
    12a1:	84 c0                	test   %al,%al
    12a3:	0f 85 6e fe ff ff    	jne    1117 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    12a9:	c9                   	leave  
    12aa:	c3                   	ret    
    12ab:	90                   	nop

000012ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12ac:	55                   	push   %ebp
    12ad:	89 e5                	mov    %esp,%ebp
    12af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12b2:	8b 45 08             	mov    0x8(%ebp),%eax
    12b5:	83 e8 08             	sub    $0x8,%eax
    12b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12bb:	a1 ec 18 00 00       	mov    0x18ec,%eax
    12c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12c3:	eb 24                	jmp    12e9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c8:	8b 00                	mov    (%eax),%eax
    12ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12cd:	77 12                	ja     12e1 <free+0x35>
    12cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12d5:	77 24                	ja     12fb <free+0x4f>
    12d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12da:	8b 00                	mov    (%eax),%eax
    12dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12df:	77 1a                	ja     12fb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e4:	8b 00                	mov    (%eax),%eax
    12e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12ef:	76 d4                	jbe    12c5 <free+0x19>
    12f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12f4:	8b 00                	mov    (%eax),%eax
    12f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12f9:	76 ca                	jbe    12c5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    12fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12fe:	8b 40 04             	mov    0x4(%eax),%eax
    1301:	c1 e0 03             	shl    $0x3,%eax
    1304:	89 c2                	mov    %eax,%edx
    1306:	03 55 f8             	add    -0x8(%ebp),%edx
    1309:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130c:	8b 00                	mov    (%eax),%eax
    130e:	39 c2                	cmp    %eax,%edx
    1310:	75 24                	jne    1336 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    1312:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1315:	8b 50 04             	mov    0x4(%eax),%edx
    1318:	8b 45 fc             	mov    -0x4(%ebp),%eax
    131b:	8b 00                	mov    (%eax),%eax
    131d:	8b 40 04             	mov    0x4(%eax),%eax
    1320:	01 c2                	add    %eax,%edx
    1322:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1325:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1328:	8b 45 fc             	mov    -0x4(%ebp),%eax
    132b:	8b 00                	mov    (%eax),%eax
    132d:	8b 10                	mov    (%eax),%edx
    132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1332:	89 10                	mov    %edx,(%eax)
    1334:	eb 0a                	jmp    1340 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    1336:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1339:	8b 10                	mov    (%eax),%edx
    133b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    133e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1340:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1343:	8b 40 04             	mov    0x4(%eax),%eax
    1346:	c1 e0 03             	shl    $0x3,%eax
    1349:	03 45 fc             	add    -0x4(%ebp),%eax
    134c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    134f:	75 20                	jne    1371 <free+0xc5>
    p->s.size += bp->s.size;
    1351:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1354:	8b 50 04             	mov    0x4(%eax),%edx
    1357:	8b 45 f8             	mov    -0x8(%ebp),%eax
    135a:	8b 40 04             	mov    0x4(%eax),%eax
    135d:	01 c2                	add    %eax,%edx
    135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1362:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1365:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1368:	8b 10                	mov    (%eax),%edx
    136a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136d:	89 10                	mov    %edx,(%eax)
    136f:	eb 08                	jmp    1379 <free+0xcd>
  } else
    p->s.ptr = bp;
    1371:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1374:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1377:	89 10                	mov    %edx,(%eax)
  freep = p;
    1379:	8b 45 fc             	mov    -0x4(%ebp),%eax
    137c:	a3 ec 18 00 00       	mov    %eax,0x18ec
}
    1381:	c9                   	leave  
    1382:	c3                   	ret    

00001383 <morecore>:

static Header*
morecore(uint nu)
{
    1383:	55                   	push   %ebp
    1384:	89 e5                	mov    %esp,%ebp
    1386:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1389:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1390:	77 07                	ja     1399 <morecore+0x16>
    nu = 4096;
    1392:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1399:	8b 45 08             	mov    0x8(%ebp),%eax
    139c:	c1 e0 03             	shl    $0x3,%eax
    139f:	89 04 24             	mov    %eax,(%esp)
    13a2:	e8 3d fc ff ff       	call   fe4 <sbrk>
    13a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
    13aa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    13ae:	75 07                	jne    13b7 <morecore+0x34>
    return 0;
    13b0:	b8 00 00 00 00       	mov    $0x0,%eax
    13b5:	eb 22                	jmp    13d9 <morecore+0x56>
  hp = (Header*)p;
    13b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
    13bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c0:	8b 55 08             	mov    0x8(%ebp),%edx
    13c3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c9:	83 c0 08             	add    $0x8,%eax
    13cc:	89 04 24             	mov    %eax,(%esp)
    13cf:	e8 d8 fe ff ff       	call   12ac <free>
  return freep;
    13d4:	a1 ec 18 00 00       	mov    0x18ec,%eax
}
    13d9:	c9                   	leave  
    13da:	c3                   	ret    

000013db <malloc>:

void*
malloc(uint nbytes)
{
    13db:	55                   	push   %ebp
    13dc:	89 e5                	mov    %esp,%ebp
    13de:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13e1:	8b 45 08             	mov    0x8(%ebp),%eax
    13e4:	83 c0 07             	add    $0x7,%eax
    13e7:	c1 e8 03             	shr    $0x3,%eax
    13ea:	83 c0 01             	add    $0x1,%eax
    13ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
    13f0:	a1 ec 18 00 00       	mov    0x18ec,%eax
    13f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13fc:	75 23                	jne    1421 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13fe:	c7 45 f0 e4 18 00 00 	movl   $0x18e4,-0x10(%ebp)
    1405:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1408:	a3 ec 18 00 00       	mov    %eax,0x18ec
    140d:	a1 ec 18 00 00       	mov    0x18ec,%eax
    1412:	a3 e4 18 00 00       	mov    %eax,0x18e4
    base.s.size = 0;
    1417:	c7 05 e8 18 00 00 00 	movl   $0x0,0x18e8
    141e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1421:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1424:	8b 00                	mov    (%eax),%eax
    1426:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
    1429:	8b 45 ec             	mov    -0x14(%ebp),%eax
    142c:	8b 40 04             	mov    0x4(%eax),%eax
    142f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1432:	72 4d                	jb     1481 <malloc+0xa6>
      if(p->s.size == nunits)
    1434:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1437:	8b 40 04             	mov    0x4(%eax),%eax
    143a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    143d:	75 0c                	jne    144b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    143f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1442:	8b 10                	mov    (%eax),%edx
    1444:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1447:	89 10                	mov    %edx,(%eax)
    1449:	eb 26                	jmp    1471 <malloc+0x96>
      else {
        p->s.size -= nunits;
    144b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    144e:	8b 40 04             	mov    0x4(%eax),%eax
    1451:	89 c2                	mov    %eax,%edx
    1453:	2b 55 f4             	sub    -0xc(%ebp),%edx
    1456:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1459:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    145f:	8b 40 04             	mov    0x4(%eax),%eax
    1462:	c1 e0 03             	shl    $0x3,%eax
    1465:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
    1468:	8b 45 ec             	mov    -0x14(%ebp),%eax
    146b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    146e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1471:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1474:	a3 ec 18 00 00       	mov    %eax,0x18ec
      return (void*)(p + 1);
    1479:	8b 45 ec             	mov    -0x14(%ebp),%eax
    147c:	83 c0 08             	add    $0x8,%eax
    147f:	eb 38                	jmp    14b9 <malloc+0xde>
    }
    if(p == freep)
    1481:	a1 ec 18 00 00       	mov    0x18ec,%eax
    1486:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1489:	75 1b                	jne    14a6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148e:	89 04 24             	mov    %eax,(%esp)
    1491:	e8 ed fe ff ff       	call   1383 <morecore>
    1496:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    149d:	75 07                	jne    14a6 <malloc+0xcb>
        return 0;
    149f:	b8 00 00 00 00       	mov    $0x0,%eax
    14a4:	eb 13                	jmp    14b9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14af:	8b 00                	mov    (%eax),%eax
    14b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14b4:	e9 70 ff ff ff       	jmp    1429 <malloc+0x4e>
}
    14b9:	c9                   	leave  
    14ba:	c3                   	ret    
    14bb:	90                   	nop

000014bc <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    14bc:	55                   	push   %ebp
    14bd:	89 e5                	mov    %esp,%ebp
    14bf:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    14c2:	8b 55 08             	mov    0x8(%ebp),%edx
    14c5:	8b 45 0c             	mov    0xc(%ebp),%eax
    14c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    14cb:	f0 87 02             	lock xchg %eax,(%edx)
    14ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    14d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14d4:	c9                   	leave  
    14d5:	c3                   	ret    

000014d6 <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    14d6:	55                   	push   %ebp
    14d7:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    14d9:	8b 45 08             	mov    0x8(%ebp),%eax
    14dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    14e2:	5d                   	pop    %ebp
    14e3:	c3                   	ret    

000014e4 <lock_acquire>:
void lock_acquire(lock_t *lock){
    14e4:	55                   	push   %ebp
    14e5:	89 e5                	mov    %esp,%ebp
    14e7:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    14ea:	8b 45 08             	mov    0x8(%ebp),%eax
    14ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    14f4:	00 
    14f5:	89 04 24             	mov    %eax,(%esp)
    14f8:	e8 bf ff ff ff       	call   14bc <xchg>
    14fd:	85 c0                	test   %eax,%eax
    14ff:	75 e9                	jne    14ea <lock_acquire+0x6>
}
    1501:	c9                   	leave  
    1502:	c3                   	ret    

00001503 <lock_release>:
void lock_release(lock_t *lock){
    1503:	55                   	push   %ebp
    1504:	89 e5                	mov    %esp,%ebp
    1506:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1509:	8b 45 08             	mov    0x8(%ebp),%eax
    150c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1513:	00 
    1514:	89 04 24             	mov    %eax,(%esp)
    1517:	e8 a0 ff ff ff       	call   14bc <xchg>
}
    151c:	c9                   	leave  
    151d:	c3                   	ret    

0000151e <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
    151e:	55                   	push   %ebp
    151f:	89 e5                	mov    %esp,%ebp
    1521:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1524:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    152b:	e8 ab fe ff ff       	call   13db <malloc>
    1530:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
    1533:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1536:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
    1539:	8b 45 f0             	mov    -0x10(%ebp),%eax
    153c:	25 ff 0f 00 00       	and    $0xfff,%eax
    1541:	85 c0                	test   %eax,%eax
    1543:	74 15                	je     155a <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
    1545:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1548:	89 c2                	mov    %eax,%edx
    154a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    1550:	b8 00 10 00 00       	mov    $0x1000,%eax
    1555:	29 d0                	sub    %edx,%eax
    1557:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
    155a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    155e:	75 1b                	jne    157b <thread_create+0x5d>

        printf(1,"malloc fail \n");
    1560:	c7 44 24 04 27 18 00 	movl   $0x1827,0x4(%esp)
    1567:	00 
    1568:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    156f:	e8 81 fb ff ff       	call   10f5 <printf>
        return 0;
    1574:	b8 00 00 00 00       	mov    $0x0,%eax
    1579:	eb 6f                	jmp    15ea <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    157b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    157e:	8b 55 08             	mov    0x8(%ebp),%edx
    1581:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1584:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1588:	89 54 24 08          	mov    %edx,0x8(%esp)
    158c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1593:	00 
    1594:	89 04 24             	mov    %eax,(%esp)
    1597:	e8 60 fa ff ff       	call   ffc <clone>
    159c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
    159f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15a3:	79 1b                	jns    15c0 <thread_create+0xa2>
        printf(1,"clone fails\n");
    15a5:	c7 44 24 04 35 18 00 	movl   $0x1835,0x4(%esp)
    15ac:	00 
    15ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15b4:	e8 3c fb ff ff       	call   10f5 <printf>
        return 0;
    15b9:	b8 00 00 00 00       	mov    $0x0,%eax
    15be:	eb 2a                	jmp    15ea <thread_create+0xcc>
    }
    if(tid > 0){
    15c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15c4:	7e 05                	jle    15cb <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
    15c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c9:	eb 1f                	jmp    15ea <thread_create+0xcc>
    }
    if(tid == 0){
    15cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15cf:	75 14                	jne    15e5 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
    15d1:	c7 44 24 04 42 18 00 	movl   $0x1842,0x4(%esp)
    15d8:	00 
    15d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15e0:	e8 10 fb ff ff       	call   10f5 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    15e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    15ea:	c9                   	leave  
    15eb:	c3                   	ret    

000015ec <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    15ec:	55                   	push   %ebp
    15ed:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    15ef:	a1 78 18 00 00       	mov    0x1878,%eax
    15f4:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    15fa:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    15ff:	a3 78 18 00 00       	mov    %eax,0x1878
    return (int)(rands % max);
    1604:	a1 78 18 00 00       	mov    0x1878,%eax
    1609:	8b 4d 08             	mov    0x8(%ebp),%ecx
    160c:	ba 00 00 00 00       	mov    $0x0,%edx
    1611:	f7 f1                	div    %ecx
    1613:	89 d0                	mov    %edx,%eax
}
    1615:	5d                   	pop    %ebp
    1616:	c3                   	ret    
    1617:	90                   	nop

00001618 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
    1618:	55                   	push   %ebp
    1619:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    161b:	8b 45 08             	mov    0x8(%ebp),%eax
    161e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1624:	8b 45 08             	mov    0x8(%ebp),%eax
    1627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    162e:	8b 45 08             	mov    0x8(%ebp),%eax
    1631:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1638:	5d                   	pop    %ebp
    1639:	c3                   	ret    

0000163a <add_q>:

void add_q(struct queue *q, int v){
    163a:	55                   	push   %ebp
    163b:	89 e5                	mov    %esp,%ebp
    163d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1640:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1647:	e8 8f fd ff ff       	call   13db <malloc>
    164c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1659:	8b 45 f4             	mov    -0xc(%ebp),%eax
    165c:	8b 55 0c             	mov    0xc(%ebp),%edx
    165f:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1661:	8b 45 08             	mov    0x8(%ebp),%eax
    1664:	8b 40 04             	mov    0x4(%eax),%eax
    1667:	85 c0                	test   %eax,%eax
    1669:	75 0b                	jne    1676 <add_q+0x3c>
        q->head = n;
    166b:	8b 45 08             	mov    0x8(%ebp),%eax
    166e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1671:	89 50 04             	mov    %edx,0x4(%eax)
    1674:	eb 0c                	jmp    1682 <add_q+0x48>
    }else{
        q->tail->next = n;
    1676:	8b 45 08             	mov    0x8(%ebp),%eax
    1679:	8b 40 08             	mov    0x8(%eax),%eax
    167c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    167f:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1682:	8b 45 08             	mov    0x8(%ebp),%eax
    1685:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1688:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    168b:	8b 45 08             	mov    0x8(%ebp),%eax
    168e:	8b 00                	mov    (%eax),%eax
    1690:	8d 50 01             	lea    0x1(%eax),%edx
    1693:	8b 45 08             	mov    0x8(%ebp),%eax
    1696:	89 10                	mov    %edx,(%eax)
}
    1698:	c9                   	leave  
    1699:	c3                   	ret    

0000169a <empty_q>:

int empty_q(struct queue *q){
    169a:	55                   	push   %ebp
    169b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    169d:	8b 45 08             	mov    0x8(%ebp),%eax
    16a0:	8b 00                	mov    (%eax),%eax
    16a2:	85 c0                	test   %eax,%eax
    16a4:	75 07                	jne    16ad <empty_q+0x13>
        return 1;
    16a6:	b8 01 00 00 00       	mov    $0x1,%eax
    16ab:	eb 05                	jmp    16b2 <empty_q+0x18>
    else
        return 0;
    16ad:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    16b2:	5d                   	pop    %ebp
    16b3:	c3                   	ret    

000016b4 <pop_q>:
int pop_q(struct queue *q){
    16b4:	55                   	push   %ebp
    16b5:	89 e5                	mov    %esp,%ebp
    16b7:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    16ba:	8b 45 08             	mov    0x8(%ebp),%eax
    16bd:	89 04 24             	mov    %eax,(%esp)
    16c0:	e8 d5 ff ff ff       	call   169a <empty_q>
    16c5:	85 c0                	test   %eax,%eax
    16c7:	75 5d                	jne    1726 <pop_q+0x72>
       val = q->head->value; 
    16c9:	8b 45 08             	mov    0x8(%ebp),%eax
    16cc:	8b 40 04             	mov    0x4(%eax),%eax
    16cf:	8b 00                	mov    (%eax),%eax
    16d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
    16d4:	8b 45 08             	mov    0x8(%ebp),%eax
    16d7:	8b 40 04             	mov    0x4(%eax),%eax
    16da:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
    16dd:	8b 45 08             	mov    0x8(%ebp),%eax
    16e0:	8b 40 04             	mov    0x4(%eax),%eax
    16e3:	8b 50 04             	mov    0x4(%eax),%edx
    16e6:	8b 45 08             	mov    0x8(%ebp),%eax
    16e9:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    16ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ef:	89 04 24             	mov    %eax,(%esp)
    16f2:	e8 b5 fb ff ff       	call   12ac <free>
       q->size--;
    16f7:	8b 45 08             	mov    0x8(%ebp),%eax
    16fa:	8b 00                	mov    (%eax),%eax
    16fc:	8d 50 ff             	lea    -0x1(%eax),%edx
    16ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1702:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1704:	8b 45 08             	mov    0x8(%ebp),%eax
    1707:	8b 00                	mov    (%eax),%eax
    1709:	85 c0                	test   %eax,%eax
    170b:	75 14                	jne    1721 <pop_q+0x6d>
            q->head = 0;
    170d:	8b 45 08             	mov    0x8(%ebp),%eax
    1710:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1717:	8b 45 08             	mov    0x8(%ebp),%eax
    171a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1721:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1724:	eb 05                	jmp    172b <pop_q+0x77>
    }
    return -1;
    1726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    172b:	c9                   	leave  
    172c:	c3                   	ret    
