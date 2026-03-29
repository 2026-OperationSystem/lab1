
_hello:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    printf(1, "Hello, world!\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 ba 07 00 00       	push   $0x7ba
  19:	6a 01                	push   $0x1
  1b:	e8 e3 03 00 00       	call   403 <printf>
  20:	83 c4 10             	add    $0x10,%esp
    exit();
  23:	e8 57 02 00 00       	call   27f <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	90                   	nop
  4a:	5b                   	pop    %ebx
  4b:	5f                   	pop    %edi
  4c:	5d                   	pop    %ebp
  4d:	c3                   	ret

0000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5a:	90                   	nop
  5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  5e:	8d 42 01             	lea    0x1(%edx),%eax
  61:	89 45 0c             	mov    %eax,0xc(%ebp)
  64:	8b 45 08             	mov    0x8(%ebp),%eax
  67:	8d 48 01             	lea    0x1(%eax),%ecx
  6a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  6d:	0f b6 12             	movzbl (%edx),%edx
  70:	88 10                	mov    %dl,(%eax)
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	84 c0                	test   %al,%al
  77:	75 e2                	jne    5b <strcpy+0xd>
    ;
  return os;
  79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7c:	c9                   	leave
  7d:	c3                   	ret

0000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  81:	eb 08                	jmp    8b <strcmp+0xd>
    p++, q++;
  83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  87:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 00             	movzbl (%eax),%eax
  91:	84 c0                	test   %al,%al
  93:	74 10                	je     a5 <strcmp+0x27>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	38 c2                	cmp    %al,%dl
  a3:	74 de                	je     83 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	0f b6 d0             	movzbl %al,%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	01 d0                	add    %edx,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 ed                	jne    cc <strlen+0xf>
    ;
  return n;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave
  e3:	c3                   	ret

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e7:	8b 45 10             	mov    0x10(%ebp),%eax
  ea:	50                   	push   %eax
  eb:	ff 75 0c             	push   0xc(%ebp)
  ee:	ff 75 08             	push   0x8(%ebp)
  f1:	e8 32 ff ff ff       	call   28 <stosb>
  f6:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fc:	c9                   	leave
  fd:	c3                   	ret

000000fe <strchr>:

char*
strchr(const char *s, char c)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 04             	sub    $0x4,%esp
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10a:	eb 14                	jmp    120 <strchr+0x22>
    if(*s == c)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	38 45 fc             	cmp    %al,-0x4(%ebp)
 115:	75 05                	jne    11c <strchr+0x1e>
      return (char*)s;
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	eb 13                	jmp    12f <strchr+0x31>
  for(; *s; s++)
 11c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 e2                	jne    10c <strchr+0xe>
  return 0;
 12a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12f:	c9                   	leave
 130:	c3                   	ret

00000131 <gets>:

char*
gets(char *buf, int max)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13e:	eb 42                	jmp    182 <gets+0x51>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	8d 45 ef             	lea    -0x11(%ebp),%eax
 148:	50                   	push   %eax
 149:	6a 00                	push   $0x0
 14b:	e8 47 01 00 00       	call   297 <read>
 150:	83 c4 10             	add    $0x10,%esp
 153:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15a:	7e 33                	jle    18f <gets+0x5e>
      break;
    buf[i++] = c;
 15c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15f:	8d 50 01             	lea    0x1(%eax),%edx
 162:	89 55 f4             	mov    %edx,-0xc(%ebp)
 165:	89 c2                	mov    %eax,%edx
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	01 c2                	add    %eax,%edx
 16c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 170:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0a                	cmp    $0xa,%al
 178:	74 16                	je     190 <gets+0x5f>
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	3c 0d                	cmp    $0xd,%al
 180:	74 0e                	je     190 <gets+0x5f>
  for(i=0; i+1 < max; ){
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	83 c0 01             	add    $0x1,%eax
 188:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18b:	7f b3                	jg     140 <gets+0xf>
 18d:	eb 01                	jmp    190 <gets+0x5f>
      break;
 18f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 190:	8b 55 f4             	mov    -0xc(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19e:	c9                   	leave
 19f:	c3                   	ret

000001a0 <stat>:

int
stat(char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	83 ec 08             	sub    $0x8,%esp
 1a9:	6a 00                	push   $0x0
 1ab:	ff 75 08             	push   0x8(%ebp)
 1ae:	e8 0c 01 00 00       	call   2bf <open>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bd:	79 07                	jns    1c6 <stat+0x26>
    return -1;
 1bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c4:	eb 25                	jmp    1eb <stat+0x4b>
  r = fstat(fd, st);
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	ff 75 0c             	push   0xc(%ebp)
 1cc:	ff 75 f4             	push   -0xc(%ebp)
 1cf:	e8 03 01 00 00       	call   2d7 <fstat>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1da:	83 ec 0c             	sub    $0xc,%esp
 1dd:	ff 75 f4             	push   -0xc(%ebp)
 1e0:	e8 c2 00 00 00       	call   2a7 <close>
 1e5:	83 c4 10             	add    $0x10,%esp
  return r;
 1e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1eb:	c9                   	leave
 1ec:	c3                   	ret

000001ed <atoi>:

int
atoi(const char *s)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fa:	eb 25                	jmp    221 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ff:	89 d0                	mov    %edx,%eax
 201:	c1 e0 02             	shl    $0x2,%eax
 204:	01 d0                	add    %edx,%eax
 206:	01 c0                	add    %eax,%eax
 208:	89 c1                	mov    %eax,%ecx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 08             	mov    %edx,0x8(%ebp)
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	0f be c0             	movsbl %al,%eax
 219:	01 c8                	add    %ecx,%eax
 21b:	83 e8 30             	sub    $0x30,%eax
 21e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	3c 2f                	cmp    $0x2f,%al
 229:	7e 0a                	jle    235 <atoi+0x48>
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	3c 39                	cmp    $0x39,%al
 233:	7e c7                	jle    1fc <atoi+0xf>
  return n;
 235:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 238:	c9                   	leave
 239:	c3                   	ret

0000023a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24c:	eb 17                	jmp    265 <memmove+0x2b>
    *dst++ = *src++;
 24e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 251:	8d 42 01             	lea    0x1(%edx),%eax
 254:	89 45 f8             	mov    %eax,-0x8(%ebp)
 257:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25a:	8d 48 01             	lea    0x1(%eax),%ecx
 25d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 260:	0f b6 12             	movzbl (%edx),%edx
 263:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 265:	8b 45 10             	mov    0x10(%ebp),%eax
 268:	8d 50 ff             	lea    -0x1(%eax),%edx
 26b:	89 55 10             	mov    %edx,0x10(%ebp)
 26e:	85 c0                	test   %eax,%eax
 270:	7f dc                	jg     24e <memmove+0x14>
  return vdst;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
}
 275:	c9                   	leave
 276:	c3                   	ret

00000277 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 277:	b8 01 00 00 00       	mov    $0x1,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <exit>:
SYSCALL(exit)
 27f:	b8 02 00 00 00       	mov    $0x2,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <wait>:
SYSCALL(wait)
 287:	b8 03 00 00 00       	mov    $0x3,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <pipe>:
SYSCALL(pipe)
 28f:	b8 04 00 00 00       	mov    $0x4,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <read>:
SYSCALL(read)
 297:	b8 05 00 00 00       	mov    $0x5,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <write>:
SYSCALL(write)
 29f:	b8 10 00 00 00       	mov    $0x10,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <close>:
SYSCALL(close)
 2a7:	b8 15 00 00 00       	mov    $0x15,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <kill>:
SYSCALL(kill)
 2af:	b8 06 00 00 00       	mov    $0x6,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <exec>:
SYSCALL(exec)
 2b7:	b8 07 00 00 00       	mov    $0x7,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <open>:
SYSCALL(open)
 2bf:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <mknod>:
SYSCALL(mknod)
 2c7:	b8 11 00 00 00       	mov    $0x11,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <unlink>:
SYSCALL(unlink)
 2cf:	b8 12 00 00 00       	mov    $0x12,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <fstat>:
SYSCALL(fstat)
 2d7:	b8 08 00 00 00       	mov    $0x8,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <link>:
SYSCALL(link)
 2df:	b8 13 00 00 00       	mov    $0x13,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <mkdir>:
SYSCALL(mkdir)
 2e7:	b8 14 00 00 00       	mov    $0x14,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <chdir>:
SYSCALL(chdir)
 2ef:	b8 09 00 00 00       	mov    $0x9,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <dup>:
SYSCALL(dup)
 2f7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <getpid>:
SYSCALL(getpid)
 2ff:	b8 0b 00 00 00       	mov    $0xb,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <sbrk>:
SYSCALL(sbrk)
 307:	b8 0c 00 00 00       	mov    $0xc,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <sleep>:
SYSCALL(sleep)
 30f:	b8 0d 00 00 00       	mov    $0xd,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <uptime>:
SYSCALL(uptime)
 317:	b8 0e 00 00 00       	mov    $0xe,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <exit2>:
SYSCALL(exit2)
 31f:	b8 16 00 00 00       	mov    $0x16,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <wait2>:
 327:	b8 17 00 00 00       	mov    $0x17,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	83 ec 18             	sub    $0x18,%esp
 335:	8b 45 0c             	mov    0xc(%ebp),%eax
 338:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33b:	83 ec 04             	sub    $0x4,%esp
 33e:	6a 01                	push   $0x1
 340:	8d 45 f4             	lea    -0xc(%ebp),%eax
 343:	50                   	push   %eax
 344:	ff 75 08             	push   0x8(%ebp)
 347:	e8 53 ff ff ff       	call   29f <write>
 34c:	83 c4 10             	add    $0x10,%esp
}
 34f:	90                   	nop
 350:	c9                   	leave
 351:	c3                   	ret

00000352 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 35f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 363:	74 17                	je     37c <printint+0x2a>
 365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 369:	79 11                	jns    37c <printint+0x2a>
    neg = 1;
 36b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	f7 d8                	neg    %eax
 377:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37a:	eb 06                	jmp    382 <printint+0x30>
  } else {
    x = xx;
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 389:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 38f:	ba 00 00 00 00       	mov    $0x0,%edx
 394:	f7 f1                	div    %ecx
 396:	89 d1                	mov    %edx,%ecx
 398:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39b:	8d 50 01             	lea    0x1(%eax),%edx
 39e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3a1:	0f b6 91 14 0a 00 00 	movzbl 0xa14(%ecx),%edx
 3a8:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b2:	ba 00 00 00 00       	mov    $0x0,%edx
 3b7:	f7 f1                	div    %ecx
 3b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c0:	75 c7                	jne    389 <printint+0x37>
  if(neg)
 3c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c6:	74 2d                	je     3f5 <printint+0xa3>
    buf[i++] = '-';
 3c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cb:	8d 50 01             	lea    0x1(%eax),%edx
 3ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3d6:	eb 1d                	jmp    3f5 <printint+0xa3>
    putc(fd, buf[i]);
 3d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3de:	01 d0                	add    %edx,%eax
 3e0:	0f b6 00             	movzbl (%eax),%eax
 3e3:	0f be c0             	movsbl %al,%eax
 3e6:	83 ec 08             	sub    $0x8,%esp
 3e9:	50                   	push   %eax
 3ea:	ff 75 08             	push   0x8(%ebp)
 3ed:	e8 3d ff ff ff       	call   32f <putc>
 3f2:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 3f5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3fd:	79 d9                	jns    3d8 <printint+0x86>
}
 3ff:	90                   	nop
 400:	90                   	nop
 401:	c9                   	leave
 402:	c3                   	ret

00000403 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 409:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 410:	8d 45 0c             	lea    0xc(%ebp),%eax
 413:	83 c0 04             	add    $0x4,%eax
 416:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 419:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 420:	e9 59 01 00 00       	jmp    57e <printf+0x17b>
    c = fmt[i] & 0xff;
 425:	8b 55 0c             	mov    0xc(%ebp),%edx
 428:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	0f be c0             	movsbl %al,%eax
 433:	25 ff 00 00 00       	and    $0xff,%eax
 438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 43b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43f:	75 2c                	jne    46d <printf+0x6a>
      if(c == '%'){
 441:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 445:	75 0c                	jne    453 <printf+0x50>
        state = '%';
 447:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 44e:	e9 27 01 00 00       	jmp    57a <printf+0x177>
      } else {
        putc(fd, c);
 453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 456:	0f be c0             	movsbl %al,%eax
 459:	83 ec 08             	sub    $0x8,%esp
 45c:	50                   	push   %eax
 45d:	ff 75 08             	push   0x8(%ebp)
 460:	e8 ca fe ff ff       	call   32f <putc>
 465:	83 c4 10             	add    $0x10,%esp
 468:	e9 0d 01 00 00       	jmp    57a <printf+0x177>
      }
    } else if(state == '%'){
 46d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 471:	0f 85 03 01 00 00    	jne    57a <printf+0x177>
      if(c == 'd'){
 477:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 47b:	75 1e                	jne    49b <printf+0x98>
        printint(fd, *ap, 10, 1);
 47d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 480:	8b 00                	mov    (%eax),%eax
 482:	6a 01                	push   $0x1
 484:	6a 0a                	push   $0xa
 486:	50                   	push   %eax
 487:	ff 75 08             	push   0x8(%ebp)
 48a:	e8 c3 fe ff ff       	call   352 <printint>
 48f:	83 c4 10             	add    $0x10,%esp
        ap++;
 492:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 496:	e9 d8 00 00 00       	jmp    573 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 49b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 49f:	74 06                	je     4a7 <printf+0xa4>
 4a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a5:	75 1e                	jne    4c5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4aa:	8b 00                	mov    (%eax),%eax
 4ac:	6a 00                	push   $0x0
 4ae:	6a 10                	push   $0x10
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	push   0x8(%ebp)
 4b4:	e8 99 fe ff ff       	call   352 <printint>
 4b9:	83 c4 10             	add    $0x10,%esp
        ap++;
 4bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c0:	e9 ae 00 00 00       	jmp    573 <printf+0x170>
      } else if(c == 's'){
 4c5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4c9:	75 43                	jne    50e <printf+0x10b>
        s = (char*)*ap;
 4cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ce:	8b 00                	mov    (%eax),%eax
 4d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	75 25                	jne    502 <printf+0xff>
          s = "(null)";
 4dd:	c7 45 f4 c9 07 00 00 	movl   $0x7c9,-0xc(%ebp)
        while(*s != 0){
 4e4:	eb 1c                	jmp    502 <printf+0xff>
          putc(fd, *s);
 4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e9:	0f b6 00             	movzbl (%eax),%eax
 4ec:	0f be c0             	movsbl %al,%eax
 4ef:	83 ec 08             	sub    $0x8,%esp
 4f2:	50                   	push   %eax
 4f3:	ff 75 08             	push   0x8(%ebp)
 4f6:	e8 34 fe ff ff       	call   32f <putc>
 4fb:	83 c4 10             	add    $0x10,%esp
          s++;
 4fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 502:	8b 45 f4             	mov    -0xc(%ebp),%eax
 505:	0f b6 00             	movzbl (%eax),%eax
 508:	84 c0                	test   %al,%al
 50a:	75 da                	jne    4e6 <printf+0xe3>
 50c:	eb 65                	jmp    573 <printf+0x170>
        }
      } else if(c == 'c'){
 50e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 512:	75 1d                	jne    531 <printf+0x12e>
        putc(fd, *ap);
 514:	8b 45 e8             	mov    -0x18(%ebp),%eax
 517:	8b 00                	mov    (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	83 ec 08             	sub    $0x8,%esp
 51f:	50                   	push   %eax
 520:	ff 75 08             	push   0x8(%ebp)
 523:	e8 07 fe ff ff       	call   32f <putc>
 528:	83 c4 10             	add    $0x10,%esp
        ap++;
 52b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52f:	eb 42                	jmp    573 <printf+0x170>
      } else if(c == '%'){
 531:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 535:	75 17                	jne    54e <printf+0x14b>
        putc(fd, c);
 537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	83 ec 08             	sub    $0x8,%esp
 540:	50                   	push   %eax
 541:	ff 75 08             	push   0x8(%ebp)
 544:	e8 e6 fd ff ff       	call   32f <putc>
 549:	83 c4 10             	add    $0x10,%esp
 54c:	eb 25                	jmp    573 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54e:	83 ec 08             	sub    $0x8,%esp
 551:	6a 25                	push   $0x25
 553:	ff 75 08             	push   0x8(%ebp)
 556:	e8 d4 fd ff ff       	call   32f <putc>
 55b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 55e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	83 ec 08             	sub    $0x8,%esp
 567:	50                   	push   %eax
 568:	ff 75 08             	push   0x8(%ebp)
 56b:	e8 bf fd ff ff       	call   32f <putc>
 570:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 573:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 57a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 57e:	8b 55 0c             	mov    0xc(%ebp),%edx
 581:	8b 45 f0             	mov    -0x10(%ebp),%eax
 584:	01 d0                	add    %edx,%eax
 586:	0f b6 00             	movzbl (%eax),%eax
 589:	84 c0                	test   %al,%al
 58b:	0f 85 94 fe ff ff    	jne    425 <printf+0x22>
    }
  }
}
 591:	90                   	nop
 592:	90                   	nop
 593:	c9                   	leave
 594:	c3                   	ret

00000595 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	83 e8 08             	sub    $0x8,%eax
 5a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a4:	a1 30 0a 00 00       	mov    0xa30,%eax
 5a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ac:	eb 24                	jmp    5d2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5b6:	72 12                	jb     5ca <free+0x35>
 5b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5bb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5be:	72 24                	jb     5e4 <free+0x4f>
 5c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5c8:	72 1a                	jb     5e4 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5d8:	73 d4                	jae    5ae <free+0x19>
 5da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5e2:	73 ca                	jae    5ae <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e7:	8b 40 04             	mov    0x4(%eax),%eax
 5ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f4:	01 c2                	add    %eax,%edx
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	39 c2                	cmp    %eax,%edx
 5fd:	75 24                	jne    623 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	8b 50 04             	mov    0x4(%eax),%edx
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	8b 40 04             	mov    0x4(%eax),%eax
 60d:	01 c2                	add    %eax,%edx
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	8b 10                	mov    (%eax),%edx
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	89 10                	mov    %edx,(%eax)
 621:	eb 0a                	jmp    62d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 10                	mov    (%eax),%edx
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 40 04             	mov    0x4(%eax),%eax
 633:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	01 d0                	add    %edx,%eax
 63f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 642:	75 20                	jne    664 <free+0xcf>
    p->s.size += bp->s.size;
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 50 04             	mov    0x4(%eax),%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	8b 40 04             	mov    0x4(%eax),%eax
 650:	01 c2                	add    %eax,%edx
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	8b 10                	mov    (%eax),%edx
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	89 10                	mov    %edx,(%eax)
 662:	eb 08                	jmp    66c <free+0xd7>
  } else
    p->s.ptr = bp;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66a:	89 10                	mov    %edx,(%eax)
  freep = p;
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	a3 30 0a 00 00       	mov    %eax,0xa30
}
 674:	90                   	nop
 675:	c9                   	leave
 676:	c3                   	ret

00000677 <morecore>:

static Header*
morecore(uint nu)
{
 677:	55                   	push   %ebp
 678:	89 e5                	mov    %esp,%ebp
 67a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 67d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 684:	77 07                	ja     68d <morecore+0x16>
    nu = 4096;
 686:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	c1 e0 03             	shl    $0x3,%eax
 693:	83 ec 0c             	sub    $0xc,%esp
 696:	50                   	push   %eax
 697:	e8 6b fc ff ff       	call   307 <sbrk>
 69c:	83 c4 10             	add    $0x10,%esp
 69f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6a2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6a6:	75 07                	jne    6af <morecore+0x38>
    return 0;
 6a8:	b8 00 00 00 00       	mov    $0x0,%eax
 6ad:	eb 26                	jmp    6d5 <morecore+0x5e>
  hp = (Header*)p;
 6af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b8:	8b 55 08             	mov    0x8(%ebp),%edx
 6bb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c1:	83 c0 08             	add    $0x8,%eax
 6c4:	83 ec 0c             	sub    $0xc,%esp
 6c7:	50                   	push   %eax
 6c8:	e8 c8 fe ff ff       	call   595 <free>
 6cd:	83 c4 10             	add    $0x10,%esp
  return freep;
 6d0:	a1 30 0a 00 00       	mov    0xa30,%eax
}
 6d5:	c9                   	leave
 6d6:	c3                   	ret

000006d7 <malloc>:

void*
malloc(uint nbytes)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	83 c0 07             	add    $0x7,%eax
 6e3:	c1 e8 03             	shr    $0x3,%eax
 6e6:	83 c0 01             	add    $0x1,%eax
 6e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6ec:	a1 30 0a 00 00       	mov    0xa30,%eax
 6f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f8:	75 23                	jne    71d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6fa:	c7 45 f0 28 0a 00 00 	movl   $0xa28,-0x10(%ebp)
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	a3 30 0a 00 00       	mov    %eax,0xa30
 709:	a1 30 0a 00 00       	mov    0xa30,%eax
 70e:	a3 28 0a 00 00       	mov    %eax,0xa28
    base.s.size = 0;
 713:	c7 05 2c 0a 00 00 00 	movl   $0x0,0xa2c
 71a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 72e:	72 4d                	jb     77d <malloc+0xa6>
      if(p->s.size == nunits)
 730:	8b 45 f4             	mov    -0xc(%ebp),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 739:	75 0c                	jne    747 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	8b 10                	mov    (%eax),%edx
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	89 10                	mov    %edx,(%eax)
 745:	eb 26                	jmp    76d <malloc+0x96>
      else {
        p->s.size -= nunits;
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 750:	89 c2                	mov    %eax,%edx
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 758:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	c1 e0 03             	shl    $0x3,%eax
 761:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8b 55 ec             	mov    -0x14(%ebp),%edx
 76a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	a3 30 0a 00 00       	mov    %eax,0xa30
      return (void*)(p + 1);
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	83 c0 08             	add    $0x8,%eax
 77b:	eb 3b                	jmp    7b8 <malloc+0xe1>
    }
    if(p == freep)
 77d:	a1 30 0a 00 00       	mov    0xa30,%eax
 782:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 785:	75 1e                	jne    7a5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 787:	83 ec 0c             	sub    $0xc,%esp
 78a:	ff 75 ec             	push   -0x14(%ebp)
 78d:	e8 e5 fe ff ff       	call   677 <morecore>
 792:	83 c4 10             	add    $0x10,%esp
 795:	89 45 f4             	mov    %eax,-0xc(%ebp)
 798:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79c:	75 07                	jne    7a5 <malloc+0xce>
        return 0;
 79e:	b8 00 00 00 00       	mov    $0x0,%eax
 7a3:	eb 13                	jmp    7b8 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b3:	e9 6d ff ff ff       	jmp    725 <malloc+0x4e>
  }
}
 7b8:	c9                   	leave
 7b9:	c3                   	ret
