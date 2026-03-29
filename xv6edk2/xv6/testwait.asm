
_testwait:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 24             	sub    $0x24,%esp
	int pid, child_pid;
	char *message;
	int n, status, exit_code;
	pid = fork();
  11:	e8 38 03 00 00       	call   34e <fork>
  16:	89 45 e8             	mov    %eax,-0x18(%ebp)
         switch(pid)	{
  19:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  1d:	74 08                	je     27 <main+0x27>
  1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  23:	74 21                	je     46 <main+0x46>
  25:	eb 36                	jmp    5d <main+0x5d>
	 case -1:
		printf(2,"fork failed");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 91 08 00 00       	push   $0x891
  2f:	6a 02                	push   $0x2
  31:	e8 a4 04 00 00       	call   4da <printf>
  36:	83 c4 10             	add    $0x10,%esp
		exit2(0);
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	6a 00                	push   $0x0
  3e:	e8 b3 03 00 00       	call   3f6 <exit2>
  43:	83 c4 10             	add    $0x10,%esp
	 case 0:
		message = "This is the child";
  46:	c7 45 f4 9d 08 00 00 	movl   $0x89d,-0xc(%ebp)
		n = 5;
  4d:	c7 45 f0 05 00 00 00 	movl   $0x5,-0x10(%ebp)
		exit_code = 37;
  54:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
		break;
  5b:	eb 16                	jmp    73 <main+0x73>
	 default:
		message = "This is the parent";
  5d:	c7 45 f4 af 08 00 00 	movl   $0x8af,-0xc(%ebp)
		n = 3;
  64:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
		exit_code = 0;
  6b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		break;
  72:	90                   	nop
	}
    for(; n > 0; n--) {
  73:	eb 26                	jmp    9b <main+0x9b>
        printf(1, "%s\n", message);
  75:	83 ec 04             	sub    $0x4,%esp
  78:	ff 75 f4             	push   -0xc(%ebp)
  7b:	68 c2 08 00 00       	push   $0x8c2
  80:	6a 01                	push   $0x1
  82:	e8 53 04 00 00       	call   4da <printf>
  87:	83 c4 10             	add    $0x10,%esp
        sleep(1);
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	6a 01                	push   $0x1
  8f:	e8 52 03 00 00       	call   3e6 <sleep>
  94:	83 c4 10             	add    $0x10,%esp
    for(; n > 0; n--) {
  97:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  9f:	7f d4                	jg     75 <main+0x75>
    }
    if (pid != 0) {
  a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  a5:	74 3d                	je     e4 <main+0xe4>
        child_pid = wait2(&status);
  a7:	83 ec 0c             	sub    $0xc,%esp
  aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  ad:	50                   	push   %eax
  ae:	e8 4b 03 00 00       	call   3fe <wait2>
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "Child has finished: PID = %d\n", 
  b9:	83 ec 04             	sub    $0x4,%esp
  bc:	ff 75 e4             	push   -0x1c(%ebp)
  bf:	68 c6 08 00 00       	push   $0x8c6
  c4:	6a 01                	push   $0x1
  c6:	e8 0f 04 00 00       	call   4da <printf>
  cb:	83 c4 10             	add    $0x10,%esp
                child_pid);
        printf(1, "Child exited with code %d\n", status);
  ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  d1:	83 ec 04             	sub    $0x4,%esp
  d4:	50                   	push   %eax
  d5:	68 e4 08 00 00       	push   $0x8e4
  da:	6a 01                	push   $0x1
  dc:	e8 f9 03 00 00       	call   4da <printf>
  e1:	83 c4 10             	add    $0x10,%esp
    }
    exit2(exit_code);
  e4:	83 ec 0c             	sub    $0xc,%esp
  e7:	ff 75 ec             	push   -0x14(%ebp)
  ea:	e8 07 03 00 00       	call   3f6 <exit2>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  fa:	c9                   	leave
  fb:	8d 61 fc             	lea    -0x4(%ecx),%esp
  fe:	c3                   	ret

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	57                   	push   %edi
 103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 10             	mov    0x10(%ebp),%edx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 cb                	mov    %ecx,%ebx
 10f:	89 df                	mov    %ebx,%edi
 111:	89 d1                	mov    %edx,%ecx
 113:	fc                   	cld
 114:	f3 aa                	rep stos %al,%es:(%edi)
 116:	89 ca                	mov    %ecx,%edx
 118:	89 fb                	mov    %edi,%ebx
 11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 120:	90                   	nop
 121:	5b                   	pop    %ebx
 122:	5f                   	pop    %edi
 123:	5d                   	pop    %ebp
 124:	c3                   	ret

00000125 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 131:	90                   	nop
 132:	8b 55 0c             	mov    0xc(%ebp),%edx
 135:	8d 42 01             	lea    0x1(%edx),%eax
 138:	89 45 0c             	mov    %eax,0xc(%ebp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	8d 48 01             	lea    0x1(%eax),%ecx
 141:	89 4d 08             	mov    %ecx,0x8(%ebp)
 144:	0f b6 12             	movzbl (%edx),%edx
 147:	88 10                	mov    %dl,(%eax)
 149:	0f b6 00             	movzbl (%eax),%eax
 14c:	84 c0                	test   %al,%al
 14e:	75 e2                	jne    132 <strcpy+0xd>
    ;
  return os;
 150:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 153:	c9                   	leave
 154:	c3                   	ret

00000155 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 158:	eb 08                	jmp    162 <strcmp+0xd>
    p++, q++;
 15a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	84 c0                	test   %al,%al
 16a:	74 10                	je     17c <strcmp+0x27>
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 10             	movzbl (%eax),%edx
 172:	8b 45 0c             	mov    0xc(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	38 c2                	cmp    %al,%dl
 17a:	74 de                	je     15a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	0f b6 d0             	movzbl %al,%edx
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	0f b6 c0             	movzbl %al,%eax
 18e:	29 c2                	sub    %eax,%edx
 190:	89 d0                	mov    %edx,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret

00000194 <strlen>:

uint
strlen(char *s)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a1:	eb 04                	jmp    1a7 <strlen+0x13>
 1a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	01 d0                	add    %edx,%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	84 c0                	test   %al,%al
 1b4:	75 ed                	jne    1a3 <strlen+0xf>
    ;
  return n;
 1b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b9:	c9                   	leave
 1ba:	c3                   	ret

000001bb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1be:	8b 45 10             	mov    0x10(%ebp),%eax
 1c1:	50                   	push   %eax
 1c2:	ff 75 0c             	push   0xc(%ebp)
 1c5:	ff 75 08             	push   0x8(%ebp)
 1c8:	e8 32 ff ff ff       	call   ff <stosb>
 1cd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d3:	c9                   	leave
 1d4:	c3                   	ret

000001d5 <strchr>:

char*
strchr(const char *s, char c)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 04             	sub    $0x4,%esp
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e1:	eb 14                	jmp    1f7 <strchr+0x22>
    if(*s == c)
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 00             	movzbl (%eax),%eax
 1e9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1ec:	75 05                	jne    1f3 <strchr+0x1e>
      return (char*)s;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	eb 13                	jmp    206 <strchr+0x31>
  for(; *s; s++)
 1f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	84 c0                	test   %al,%al
 1ff:	75 e2                	jne    1e3 <strchr+0xe>
  return 0;
 201:	b8 00 00 00 00       	mov    $0x0,%eax
}
 206:	c9                   	leave
 207:	c3                   	ret

00000208 <gets>:

char*
gets(char *buf, int max)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 215:	eb 42                	jmp    259 <gets+0x51>
    cc = read(0, &c, 1);
 217:	83 ec 04             	sub    $0x4,%esp
 21a:	6a 01                	push   $0x1
 21c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21f:	50                   	push   %eax
 220:	6a 00                	push   $0x0
 222:	e8 47 01 00 00       	call   36e <read>
 227:	83 c4 10             	add    $0x10,%esp
 22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 231:	7e 33                	jle    266 <gets+0x5e>
      break;
    buf[i++] = c;
 233:	8b 45 f4             	mov    -0xc(%ebp),%eax
 236:	8d 50 01             	lea    0x1(%eax),%edx
 239:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23c:	89 c2                	mov    %eax,%edx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	01 c2                	add    %eax,%edx
 243:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 247:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 249:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24d:	3c 0a                	cmp    $0xa,%al
 24f:	74 16                	je     267 <gets+0x5f>
 251:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 255:	3c 0d                	cmp    $0xd,%al
 257:	74 0e                	je     267 <gets+0x5f>
  for(i=0; i+1 < max; ){
 259:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25c:	83 c0 01             	add    $0x1,%eax
 25f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 262:	7f b3                	jg     217 <gets+0xf>
 264:	eb 01                	jmp    267 <gets+0x5f>
      break;
 266:	90                   	nop
      break;
  }
  buf[i] = '\0';
 267:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
}
 275:	c9                   	leave
 276:	c3                   	ret

00000277 <stat>:

int
stat(char *n, struct stat *st)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27d:	83 ec 08             	sub    $0x8,%esp
 280:	6a 00                	push   $0x0
 282:	ff 75 08             	push   0x8(%ebp)
 285:	e8 0c 01 00 00       	call   396 <open>
 28a:	83 c4 10             	add    $0x10,%esp
 28d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 294:	79 07                	jns    29d <stat+0x26>
    return -1;
 296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29b:	eb 25                	jmp    2c2 <stat+0x4b>
  r = fstat(fd, st);
 29d:	83 ec 08             	sub    $0x8,%esp
 2a0:	ff 75 0c             	push   0xc(%ebp)
 2a3:	ff 75 f4             	push   -0xc(%ebp)
 2a6:	e8 03 01 00 00       	call   3ae <fstat>
 2ab:	83 c4 10             	add    $0x10,%esp
 2ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b1:	83 ec 0c             	sub    $0xc,%esp
 2b4:	ff 75 f4             	push   -0xc(%ebp)
 2b7:	e8 c2 00 00 00       	call   37e <close>
 2bc:	83 c4 10             	add    $0x10,%esp
  return r;
 2bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c2:	c9                   	leave
 2c3:	c3                   	ret

000002c4 <atoi>:

int
atoi(const char *s)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d1:	eb 25                	jmp    2f8 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	c1 e0 02             	shl    $0x2,%eax
 2db:	01 d0                	add    %edx,%eax
 2dd:	01 c0                	add    %eax,%eax
 2df:	89 c1                	mov    %eax,%ecx
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	8d 50 01             	lea    0x1(%eax),%edx
 2e7:	89 55 08             	mov    %edx,0x8(%ebp)
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	0f be c0             	movsbl %al,%eax
 2f0:	01 c8                	add    %ecx,%eax
 2f2:	83 e8 30             	sub    $0x30,%eax
 2f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	3c 2f                	cmp    $0x2f,%al
 300:	7e 0a                	jle    30c <atoi+0x48>
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	3c 39                	cmp    $0x39,%al
 30a:	7e c7                	jle    2d3 <atoi+0xf>
  return n;
 30c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30f:	c9                   	leave
 310:	c3                   	ret

00000311 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 323:	eb 17                	jmp    33c <memmove+0x2b>
    *dst++ = *src++;
 325:	8b 55 f8             	mov    -0x8(%ebp),%edx
 328:	8d 42 01             	lea    0x1(%edx),%eax
 32b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 32e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 331:	8d 48 01             	lea    0x1(%eax),%ecx
 334:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 337:	0f b6 12             	movzbl (%edx),%edx
 33a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 33c:	8b 45 10             	mov    0x10(%ebp),%eax
 33f:	8d 50 ff             	lea    -0x1(%eax),%edx
 342:	89 55 10             	mov    %edx,0x10(%ebp)
 345:	85 c0                	test   %eax,%eax
 347:	7f dc                	jg     325 <memmove+0x14>
  return vdst;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34c:	c9                   	leave
 34d:	c3                   	ret

0000034e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34e:	b8 01 00 00 00       	mov    $0x1,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret

00000356 <exit>:
SYSCALL(exit)
 356:	b8 02 00 00 00       	mov    $0x2,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret

0000035e <wait>:
SYSCALL(wait)
 35e:	b8 03 00 00 00       	mov    $0x3,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret

00000366 <pipe>:
SYSCALL(pipe)
 366:	b8 04 00 00 00       	mov    $0x4,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret

0000036e <read>:
SYSCALL(read)
 36e:	b8 05 00 00 00       	mov    $0x5,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret

00000376 <write>:
SYSCALL(write)
 376:	b8 10 00 00 00       	mov    $0x10,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret

0000037e <close>:
SYSCALL(close)
 37e:	b8 15 00 00 00       	mov    $0x15,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret

00000386 <kill>:
SYSCALL(kill)
 386:	b8 06 00 00 00       	mov    $0x6,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret

0000038e <exec>:
SYSCALL(exec)
 38e:	b8 07 00 00 00       	mov    $0x7,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret

00000396 <open>:
SYSCALL(open)
 396:	b8 0f 00 00 00       	mov    $0xf,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret

0000039e <mknod>:
SYSCALL(mknod)
 39e:	b8 11 00 00 00       	mov    $0x11,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret

000003a6 <unlink>:
SYSCALL(unlink)
 3a6:	b8 12 00 00 00       	mov    $0x12,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret

000003ae <fstat>:
SYSCALL(fstat)
 3ae:	b8 08 00 00 00       	mov    $0x8,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret

000003b6 <link>:
SYSCALL(link)
 3b6:	b8 13 00 00 00       	mov    $0x13,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret

000003be <mkdir>:
SYSCALL(mkdir)
 3be:	b8 14 00 00 00       	mov    $0x14,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret

000003c6 <chdir>:
SYSCALL(chdir)
 3c6:	b8 09 00 00 00       	mov    $0x9,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret

000003ce <dup>:
SYSCALL(dup)
 3ce:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret

000003d6 <getpid>:
SYSCALL(getpid)
 3d6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret

000003de <sbrk>:
SYSCALL(sbrk)
 3de:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret

000003e6 <sleep>:
SYSCALL(sleep)
 3e6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret

000003ee <uptime>:
SYSCALL(uptime)
 3ee:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret

000003f6 <exit2>:
SYSCALL(exit2)
 3f6:	b8 16 00 00 00       	mov    $0x16,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret

000003fe <wait2>:
 3fe:	b8 17 00 00 00       	mov    $0x17,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret

00000406 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	83 ec 18             	sub    $0x18,%esp
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 412:	83 ec 04             	sub    $0x4,%esp
 415:	6a 01                	push   $0x1
 417:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41a:	50                   	push   %eax
 41b:	ff 75 08             	push   0x8(%ebp)
 41e:	e8 53 ff ff ff       	call   376 <write>
 423:	83 c4 10             	add    $0x10,%esp
}
 426:	90                   	nop
 427:	c9                   	leave
 428:	c3                   	ret

00000429 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 436:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43a:	74 17                	je     453 <printint+0x2a>
 43c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 440:	79 11                	jns    453 <printint+0x2a>
    neg = 1;
 442:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	f7 d8                	neg    %eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 451:	eb 06                	jmp    459 <printint+0x30>
  } else {
    x = xx;
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 460:	8b 4d 10             	mov    0x10(%ebp),%ecx
 463:	8b 45 ec             	mov    -0x14(%ebp),%eax
 466:	ba 00 00 00 00       	mov    $0x0,%edx
 46b:	f7 f1                	div    %ecx
 46d:	89 d1                	mov    %edx,%ecx
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	8d 50 01             	lea    0x1(%eax),%edx
 475:	89 55 f4             	mov    %edx,-0xc(%ebp)
 478:	0f b6 91 54 0b 00 00 	movzbl 0xb54(%ecx),%edx
 47f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 483:	8b 4d 10             	mov    0x10(%ebp),%ecx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	ba 00 00 00 00       	mov    $0x0,%edx
 48e:	f7 f1                	div    %ecx
 490:	89 45 ec             	mov    %eax,-0x14(%ebp)
 493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 497:	75 c7                	jne    460 <printint+0x37>
  if(neg)
 499:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49d:	74 2d                	je     4cc <printint+0xa3>
    buf[i++] = '-';
 49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a2:	8d 50 01             	lea    0x1(%eax),%edx
 4a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ad:	eb 1d                	jmp    4cc <printint+0xa3>
    putc(fd, buf[i]);
 4af:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b5:	01 d0                	add    %edx,%eax
 4b7:	0f b6 00             	movzbl (%eax),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	83 ec 08             	sub    $0x8,%esp
 4c0:	50                   	push   %eax
 4c1:	ff 75 08             	push   0x8(%ebp)
 4c4:	e8 3d ff ff ff       	call   406 <putc>
 4c9:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4cc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d4:	79 d9                	jns    4af <printint+0x86>
}
 4d6:	90                   	nop
 4d7:	90                   	nop
 4d8:	c9                   	leave
 4d9:	c3                   	ret

000004da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ea:	83 c0 04             	add    $0x4,%eax
 4ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f7:	e9 59 01 00 00       	jmp    655 <printf+0x17b>
    c = fmt[i] & 0xff;
 4fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 502:	01 d0                	add    %edx,%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	25 ff 00 00 00       	and    $0xff,%eax
 50f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 516:	75 2c                	jne    544 <printf+0x6a>
      if(c == '%'){
 518:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51c:	75 0c                	jne    52a <printf+0x50>
        state = '%';
 51e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 525:	e9 27 01 00 00       	jmp    651 <printf+0x177>
      } else {
        putc(fd, c);
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 ec 08             	sub    $0x8,%esp
 533:	50                   	push   %eax
 534:	ff 75 08             	push   0x8(%ebp)
 537:	e8 ca fe ff ff       	call   406 <putc>
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	e9 0d 01 00 00       	jmp    651 <printf+0x177>
      }
    } else if(state == '%'){
 544:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 548:	0f 85 03 01 00 00    	jne    651 <printf+0x177>
      if(c == 'd'){
 54e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 552:	75 1e                	jne    572 <printf+0x98>
        printint(fd, *ap, 10, 1);
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	6a 01                	push   $0x1
 55b:	6a 0a                	push   $0xa
 55d:	50                   	push   %eax
 55e:	ff 75 08             	push   0x8(%ebp)
 561:	e8 c3 fe ff ff       	call   429 <printint>
 566:	83 c4 10             	add    $0x10,%esp
        ap++;
 569:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56d:	e9 d8 00 00 00       	jmp    64a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 572:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 576:	74 06                	je     57e <printf+0xa4>
 578:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 57c:	75 1e                	jne    59c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 57e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 581:	8b 00                	mov    (%eax),%eax
 583:	6a 00                	push   $0x0
 585:	6a 10                	push   $0x10
 587:	50                   	push   %eax
 588:	ff 75 08             	push   0x8(%ebp)
 58b:	e8 99 fe ff ff       	call   429 <printint>
 590:	83 c4 10             	add    $0x10,%esp
        ap++;
 593:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 597:	e9 ae 00 00 00       	jmp    64a <printf+0x170>
      } else if(c == 's'){
 59c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a0:	75 43                	jne    5e5 <printf+0x10b>
        s = (char*)*ap;
 5a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a5:	8b 00                	mov    (%eax),%eax
 5a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b2:	75 25                	jne    5d9 <printf+0xff>
          s = "(null)";
 5b4:	c7 45 f4 ff 08 00 00 	movl   $0x8ff,-0xc(%ebp)
        while(*s != 0){
 5bb:	eb 1c                	jmp    5d9 <printf+0xff>
          putc(fd, *s);
 5bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	50                   	push   %eax
 5ca:	ff 75 08             	push   0x8(%ebp)
 5cd:	e8 34 fe ff ff       	call   406 <putc>
 5d2:	83 c4 10             	add    $0x10,%esp
          s++;
 5d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	84 c0                	test   %al,%al
 5e1:	75 da                	jne    5bd <printf+0xe3>
 5e3:	eb 65                	jmp    64a <printf+0x170>
        }
      } else if(c == 'c'){
 5e5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e9:	75 1d                	jne    608 <printf+0x12e>
        putc(fd, *ap);
 5eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	push   0x8(%ebp)
 5fa:	e8 07 fe ff ff       	call   406 <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 602:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 606:	eb 42                	jmp    64a <printf+0x170>
      } else if(c == '%'){
 608:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60c:	75 17                	jne    625 <printf+0x14b>
        putc(fd, c);
 60e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 611:	0f be c0             	movsbl %al,%eax
 614:	83 ec 08             	sub    $0x8,%esp
 617:	50                   	push   %eax
 618:	ff 75 08             	push   0x8(%ebp)
 61b:	e8 e6 fd ff ff       	call   406 <putc>
 620:	83 c4 10             	add    $0x10,%esp
 623:	eb 25                	jmp    64a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 625:	83 ec 08             	sub    $0x8,%esp
 628:	6a 25                	push   $0x25
 62a:	ff 75 08             	push   0x8(%ebp)
 62d:	e8 d4 fd ff ff       	call   406 <putc>
 632:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	83 ec 08             	sub    $0x8,%esp
 63e:	50                   	push   %eax
 63f:	ff 75 08             	push   0x8(%ebp)
 642:	e8 bf fd ff ff       	call   406 <putc>
 647:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 64a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 651:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 655:	8b 55 0c             	mov    0xc(%ebp),%edx
 658:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65b:	01 d0                	add    %edx,%eax
 65d:	0f b6 00             	movzbl (%eax),%eax
 660:	84 c0                	test   %al,%al
 662:	0f 85 94 fe ff ff    	jne    4fc <printf+0x22>
    }
  }
}
 668:	90                   	nop
 669:	90                   	nop
 66a:	c9                   	leave
 66b:	c3                   	ret

0000066c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	83 e8 08             	sub    $0x8,%eax
 678:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67b:	a1 70 0b 00 00       	mov    0xb70,%eax
 680:	89 45 fc             	mov    %eax,-0x4(%ebp)
 683:	eb 24                	jmp    6a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 68d:	72 12                	jb     6a1 <free+0x35>
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 695:	72 24                	jb     6bb <free+0x4f>
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69f:	72 1a                	jb     6bb <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6af:	73 d4                	jae    685 <free+0x19>
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6b9:	73 ca                	jae    685 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	01 c2                	add    %eax,%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	39 c2                	cmp    %eax,%edx
 6d4:	75 24                	jne    6fa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 50 04             	mov    0x4(%eax),%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	01 c2                	add    %eax,%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	89 10                	mov    %edx,(%eax)
 6f8:	eb 0a                	jmp    704 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 10                	mov    (%eax),%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 40 04             	mov    0x4(%eax),%eax
 70a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	01 d0                	add    %edx,%eax
 716:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 719:	75 20                	jne    73b <free+0xcf>
    p->s.size += bp->s.size;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 50 04             	mov    0x4(%eax),%edx
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	8b 40 04             	mov    0x4(%eax),%eax
 727:	01 c2                	add    %eax,%edx
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	8b 10                	mov    (%eax),%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	89 10                	mov    %edx,(%eax)
 739:	eb 08                	jmp    743 <free+0xd7>
  } else
    p->s.ptr = bp;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 741:	89 10                	mov    %edx,(%eax)
  freep = p;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 74b:	90                   	nop
 74c:	c9                   	leave
 74d:	c3                   	ret

0000074e <morecore>:

static Header*
morecore(uint nu)
{
 74e:	55                   	push   %ebp
 74f:	89 e5                	mov    %esp,%ebp
 751:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 754:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75b:	77 07                	ja     764 <morecore+0x16>
    nu = 4096;
 75d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	c1 e0 03             	shl    $0x3,%eax
 76a:	83 ec 0c             	sub    $0xc,%esp
 76d:	50                   	push   %eax
 76e:	e8 6b fc ff ff       	call   3de <sbrk>
 773:	83 c4 10             	add    $0x10,%esp
 776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 779:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 77d:	75 07                	jne    786 <morecore+0x38>
    return 0;
 77f:	b8 00 00 00 00       	mov    $0x0,%eax
 784:	eb 26                	jmp    7ac <morecore+0x5e>
  hp = (Header*)p;
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	8b 55 08             	mov    0x8(%ebp),%edx
 792:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 795:	8b 45 f0             	mov    -0x10(%ebp),%eax
 798:	83 c0 08             	add    $0x8,%eax
 79b:	83 ec 0c             	sub    $0xc,%esp
 79e:	50                   	push   %eax
 79f:	e8 c8 fe ff ff       	call   66c <free>
 7a4:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a7:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7ac:	c9                   	leave
 7ad:	c3                   	ret

000007ae <malloc>:

void*
malloc(uint nbytes)
{
 7ae:	55                   	push   %ebp
 7af:	89 e5                	mov    %esp,%ebp
 7b1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	83 c0 07             	add    $0x7,%eax
 7ba:	c1 e8 03             	shr    $0x3,%eax
 7bd:	83 c0 01             	add    $0x1,%eax
 7c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c3:	a1 70 0b 00 00       	mov    0xb70,%eax
 7c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7cf:	75 23                	jne    7f4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d1:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 7d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7db:	a3 70 0b 00 00       	mov    %eax,0xb70
 7e0:	a1 70 0b 00 00       	mov    0xb70,%eax
 7e5:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 7ea:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 7f1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 805:	72 4d                	jb     854 <malloc+0xa6>
      if(p->s.size == nunits)
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 40 04             	mov    0x4(%eax),%eax
 80d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 810:	75 0c                	jne    81e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	8b 10                	mov    (%eax),%edx
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	89 10                	mov    %edx,(%eax)
 81c:	eb 26                	jmp    844 <malloc+0x96>
      else {
        p->s.size -= nunits;
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	2b 45 ec             	sub    -0x14(%ebp),%eax
 827:	89 c2                	mov    %eax,%edx
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	c1 e0 03             	shl    $0x3,%eax
 838:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 841:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
 847:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	83 c0 08             	add    $0x8,%eax
 852:	eb 3b                	jmp    88f <malloc+0xe1>
    }
    if(p == freep)
 854:	a1 70 0b 00 00       	mov    0xb70,%eax
 859:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 85c:	75 1e                	jne    87c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 85e:	83 ec 0c             	sub    $0xc,%esp
 861:	ff 75 ec             	push   -0x14(%ebp)
 864:	e8 e5 fe ff ff       	call   74e <morecore>
 869:	83 c4 10             	add    $0x10,%esp
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 873:	75 07                	jne    87c <malloc+0xce>
        return 0;
 875:	b8 00 00 00 00       	mov    $0x0,%eax
 87a:	eb 13                	jmp    88f <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 00                	mov    (%eax),%eax
 887:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88a:	e9 6d ff ff ff       	jmp    7fc <malloc+0x4e>
  }
}
 88f:	c9                   	leave
 890:	c3                   	ret
