
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 ae 00 00 00       	jmp    c0 <grep+0xc0>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 e0 0d 00 00       	add    $0xde0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 44                	jmp    70 <grep+0x70>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	push   -0x10(%ebp)
  38:	ff 75 08             	push   0x8(%ebp)
  3b:	e8 8f 01 00 00       	call   1cf <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 20                	je     67 <grep+0x67>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	2b 45 f0             	sub    -0x10(%ebp),%eax
  56:	83 ec 04             	sub    $0x4,%esp
  59:	50                   	push   %eax
  5a:	ff 75 f0             	push   -0x10(%ebp)
  5d:	6a 01                	push   $0x1
  5f:	e8 3e 05 00 00       	call   5a2 <write>
  64:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6a:	83 c0 01             	add    $0x1,%eax
  6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  70:	83 ec 08             	sub    $0x8,%esp
  73:	6a 0a                	push   $0xa
  75:	ff 75 f0             	push   -0x10(%ebp)
  78:	e8 84 03 00 00       	call   401 <strchr>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	89 45 e8             	mov    %eax,-0x18(%ebp)
  83:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  87:	75 a3                	jne    2c <grep+0x2c>
    }
    if(p == buf)
  89:	81 7d f0 e0 0d 00 00 	cmpl   $0xde0,-0x10(%ebp)
  90:	75 07                	jne    99 <grep+0x99>
      m = 0;
  92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  9d:	7e 21                	jle    c0 <grep+0xc0>
      m -= p - buf;
  9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a2:	2d e0 0d 00 00       	sub    $0xde0,%eax
  a7:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  aa:	83 ec 04             	sub    $0x4,%esp
  ad:	ff 75 f4             	push   -0xc(%ebp)
  b0:	ff 75 f0             	push   -0x10(%ebp)
  b3:	68 e0 0d 00 00       	push   $0xde0
  b8:	e8 80 04 00 00       	call   53d <memmove>
  bd:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c3:	ba ff 03 00 00       	mov    $0x3ff,%edx
  c8:	29 c2                	sub    %eax,%edx
  ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cd:	05 e0 0d 00 00       	add    $0xde0,%eax
  d2:	83 ec 04             	sub    $0x4,%esp
  d5:	52                   	push   %edx
  d6:	50                   	push   %eax
  d7:	ff 75 0c             	push   0xc(%ebp)
  da:	e8 bb 04 00 00       	call   59a <read>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  e9:	0f 8f 23 ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
  ef:	90                   	nop
  f0:	90                   	nop
  f1:	c9                   	leave
  f2:	c3                   	ret

000000f3 <main>:

int
main(int argc, char *argv[])
{
  f3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f7:	83 e4 f0             	and    $0xfffffff0,%esp
  fa:	ff 71 fc             	push   -0x4(%ecx)
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	53                   	push   %ebx
 101:	51                   	push   %ecx
 102:	83 ec 10             	sub    $0x10,%esp
 105:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 107:	83 3b 01             	cmpl   $0x1,(%ebx)
 10a:	7f 17                	jg     123 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 10c:	83 ec 08             	sub    $0x8,%esp
 10f:	68 c0 0a 00 00       	push   $0xac0
 114:	6a 02                	push   $0x2
 116:	e8 eb 05 00 00       	call   706 <printf>
 11b:	83 c4 10             	add    $0x10,%esp
    exit();
 11e:	e8 5f 04 00 00       	call   582 <exit>
  }
  pattern = argv[1];
 123:	8b 43 04             	mov    0x4(%ebx),%eax
 126:	8b 40 04             	mov    0x4(%eax),%eax
 129:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 12c:	83 3b 02             	cmpl   $0x2,(%ebx)
 12f:	7f 15                	jg     146 <main+0x53>
    grep(pattern, 0);
 131:	83 ec 08             	sub    $0x8,%esp
 134:	6a 00                	push   $0x0
 136:	ff 75 f0             	push   -0x10(%ebp)
 139:	e8 c2 fe ff ff       	call   0 <grep>
 13e:	83 c4 10             	add    $0x10,%esp
    exit();
 141:	e8 3c 04 00 00       	call   582 <exit>
  }

  for(i = 2; i < argc; i++){
 146:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 14d:	eb 74                	jmp    1c3 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 159:	8b 43 04             	mov    0x4(%ebx),%eax
 15c:	01 d0                	add    %edx,%eax
 15e:	8b 00                	mov    (%eax),%eax
 160:	83 ec 08             	sub    $0x8,%esp
 163:	6a 00                	push   $0x0
 165:	50                   	push   %eax
 166:	e8 57 04 00 00       	call   5c2 <open>
 16b:	83 c4 10             	add    $0x10,%esp
 16e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 171:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 175:	79 29                	jns    1a0 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 177:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 181:	8b 43 04             	mov    0x4(%ebx),%eax
 184:	01 d0                	add    %edx,%eax
 186:	8b 00                	mov    (%eax),%eax
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	50                   	push   %eax
 18c:	68 e0 0a 00 00       	push   $0xae0
 191:	6a 01                	push   $0x1
 193:	e8 6e 05 00 00       	call   706 <printf>
 198:	83 c4 10             	add    $0x10,%esp
      exit();
 19b:	e8 e2 03 00 00       	call   582 <exit>
    }
    grep(pattern, fd);
 1a0:	83 ec 08             	sub    $0x8,%esp
 1a3:	ff 75 ec             	push   -0x14(%ebp)
 1a6:	ff 75 f0             	push   -0x10(%ebp)
 1a9:	e8 52 fe ff ff       	call   0 <grep>
 1ae:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1b1:	83 ec 0c             	sub    $0xc,%esp
 1b4:	ff 75 ec             	push   -0x14(%ebp)
 1b7:	e8 ee 03 00 00       	call   5aa <close>
 1bc:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	3b 03                	cmp    (%ebx),%eax
 1c8:	7c 85                	jl     14f <main+0x5c>
  }
  exit();
 1ca:	e8 b3 03 00 00       	call   582 <exit>

000001cf <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	3c 5e                	cmp    $0x5e,%al
 1dd:	75 17                	jne    1f6 <match+0x27>
    return matchhere(re+1, text);
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	83 c0 01             	add    $0x1,%eax
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	push   0xc(%ebp)
 1eb:	50                   	push   %eax
 1ec:	e8 38 00 00 00       	call   229 <matchhere>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	eb 31                	jmp    227 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	ff 75 0c             	push   0xc(%ebp)
 1fc:	ff 75 08             	push   0x8(%ebp)
 1ff:	e8 25 00 00 00       	call   229 <matchhere>
 204:	83 c4 10             	add    $0x10,%esp
 207:	85 c0                	test   %eax,%eax
 209:	74 07                	je     212 <match+0x43>
      return 1;
 20b:	b8 01 00 00 00       	mov    $0x1,%eax
 210:	eb 15                	jmp    227 <match+0x58>
  }while(*text++ != '\0');
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	8d 50 01             	lea    0x1(%eax),%edx
 218:	89 55 0c             	mov    %edx,0xc(%ebp)
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	84 c0                	test   %al,%al
 220:	75 d4                	jne    1f6 <match+0x27>
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave
 228:	c3                   	ret

00000229 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	84 c0                	test   %al,%al
 237:	75 0a                	jne    243 <matchhere+0x1a>
    return 1;
 239:	b8 01 00 00 00       	mov    $0x1,%eax
 23e:	e9 99 00 00 00       	jmp    2dc <matchhere+0xb3>
  if(re[1] == '*')
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	83 c0 01             	add    $0x1,%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	3c 2a                	cmp    $0x2a,%al
 24e:	75 21                	jne    271 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8d 50 02             	lea    0x2(%eax),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	0f be c0             	movsbl %al,%eax
 25f:	83 ec 04             	sub    $0x4,%esp
 262:	ff 75 0c             	push   0xc(%ebp)
 265:	52                   	push   %edx
 266:	50                   	push   %eax
 267:	e8 72 00 00 00       	call   2de <matchstar>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	eb 6b                	jmp    2dc <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 24                	cmp    $0x24,%al
 279:	75 1d                	jne    298 <matchhere+0x6f>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	83 c0 01             	add    $0x1,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 10                	jne    298 <matchhere+0x6f>
    return *text == '\0';
 288:	8b 45 0c             	mov    0xc(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	84 c0                	test   %al,%al
 290:	0f 94 c0             	sete   %al
 293:	0f b6 c0             	movzbl %al,%eax
 296:	eb 44                	jmp    2dc <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	84 c0                	test   %al,%al
 2a0:	74 35                	je     2d7 <matchhere+0xae>
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 00             	movzbl (%eax),%eax
 2a8:	3c 2e                	cmp    $0x2e,%al
 2aa:	74 10                	je     2bc <matchhere+0x93>
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 10             	movzbl (%eax),%edx
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	38 c2                	cmp    %al,%dl
 2ba:	75 1b                	jne    2d7 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	8d 50 01             	lea    0x1(%eax),%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	83 c0 01             	add    $0x1,%eax
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	52                   	push   %edx
 2cc:	50                   	push   %eax
 2cd:	e8 57 ff ff ff       	call   229 <matchhere>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	eb 05                	jmp    2dc <matchhere+0xb3>
  return 0;
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dc:	c9                   	leave
 2dd:	c3                   	ret

000002de <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2e4:	83 ec 08             	sub    $0x8,%esp
 2e7:	ff 75 10             	push   0x10(%ebp)
 2ea:	ff 75 0c             	push   0xc(%ebp)
 2ed:	e8 37 ff ff ff       	call   229 <matchhere>
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	74 07                	je     300 <matchstar+0x22>
      return 1;
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	eb 29                	jmp    329 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 300:	8b 45 10             	mov    0x10(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	84 c0                	test   %al,%al
 308:	74 1a                	je     324 <matchstar+0x46>
 30a:	8b 45 10             	mov    0x10(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 10             	mov    %edx,0x10(%ebp)
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	0f be c0             	movsbl %al,%eax
 319:	39 45 08             	cmp    %eax,0x8(%ebp)
 31c:	74 c6                	je     2e4 <matchstar+0x6>
 31e:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 322:	74 c0                	je     2e4 <matchstar+0x6>
  return 0;
 324:	b8 00 00 00 00       	mov    $0x0,%eax
}
 329:	c9                   	leave
 32a:	c3                   	ret

0000032b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	57                   	push   %edi
 32f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 330:	8b 4d 08             	mov    0x8(%ebp),%ecx
 333:	8b 55 10             	mov    0x10(%ebp),%edx
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	89 cb                	mov    %ecx,%ebx
 33b:	89 df                	mov    %ebx,%edi
 33d:	89 d1                	mov    %edx,%ecx
 33f:	fc                   	cld
 340:	f3 aa                	rep stos %al,%es:(%edi)
 342:	89 ca                	mov    %ecx,%edx
 344:	89 fb                	mov    %edi,%ebx
 346:	89 5d 08             	mov    %ebx,0x8(%ebp)
 349:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 34c:	90                   	nop
 34d:	5b                   	pop    %ebx
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret

00000351 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 35d:	90                   	nop
 35e:	8b 55 0c             	mov    0xc(%ebp),%edx
 361:	8d 42 01             	lea    0x1(%edx),%eax
 364:	89 45 0c             	mov    %eax,0xc(%ebp)
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	8d 48 01             	lea    0x1(%eax),%ecx
 36d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	84 c0                	test   %al,%al
 37a:	75 e2                	jne    35e <strcpy+0xd>
    ;
  return os;
 37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37f:	c9                   	leave
 380:	c3                   	ret

00000381 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 384:	eb 08                	jmp    38e <strcmp+0xd>
    p++, q++;
 386:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	74 10                	je     3a8 <strcmp+0x27>
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 10             	movzbl (%eax),%edx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	38 c2                	cmp    %al,%dl
 3a6:	74 de                	je     386 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 d0             	movzbl %al,%edx
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	0f b6 c0             	movzbl %al,%eax
 3ba:	29 c2                	sub    %eax,%edx
 3bc:	89 d0                	mov    %edx,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cd:	eb 04                	jmp    3d3 <strlen+0x13>
 3cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 d0                	add    %edx,%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	84 c0                	test   %al,%al
 3e0:	75 ed                	jne    3cf <strlen+0xf>
    ;
  return n;
 3e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e5:	c9                   	leave
 3e6:	c3                   	ret

000003e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ea:	8b 45 10             	mov    0x10(%ebp),%eax
 3ed:	50                   	push   %eax
 3ee:	ff 75 0c             	push   0xc(%ebp)
 3f1:	ff 75 08             	push   0x8(%ebp)
 3f4:	e8 32 ff ff ff       	call   32b <stosb>
 3f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ff:	c9                   	leave
 400:	c3                   	ret

00000401 <strchr>:

char*
strchr(const char *s, char c)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
 404:	83 ec 04             	sub    $0x4,%esp
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 40d:	eb 14                	jmp    423 <strchr+0x22>
    if(*s == c)
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	38 45 fc             	cmp    %al,-0x4(%ebp)
 418:	75 05                	jne    41f <strchr+0x1e>
      return (char*)s;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	eb 13                	jmp    432 <strchr+0x31>
  for(; *s; s++)
 41f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	84 c0                	test   %al,%al
 42b:	75 e2                	jne    40f <strchr+0xe>
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave
 433:	c3                   	ret

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 42                	jmp    485 <gets+0x51>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 47 01 00 00       	call   59a <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7e 33                	jle    492 <gets+0x5e>
      break;
    buf[i++] = c;
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	8d 50 01             	lea    0x1(%eax),%edx
 465:	89 55 f4             	mov    %edx,-0xc(%ebp)
 468:	89 c2                	mov    %eax,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	01 c2                	add    %eax,%edx
 46f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 473:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 475:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 16                	je     493 <gets+0x5f>
 47d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 481:	3c 0d                	cmp    $0xd,%al
 483:	74 0e                	je     493 <gets+0x5f>
  for(i=0; i+1 < max; ){
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	83 c0 01             	add    $0x1,%eax
 48b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 48e:	7f b3                	jg     443 <gets+0xf>
 490:	eb 01                	jmp    493 <gets+0x5f>
      break;
 492:	90                   	nop
      break;
  }
  buf[i] = '\0';
 493:	8b 55 f4             	mov    -0xc(%ebp),%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a1:	c9                   	leave
 4a2:	c3                   	ret

000004a3 <stat>:

int
stat(char *n, struct stat *st)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a9:	83 ec 08             	sub    $0x8,%esp
 4ac:	6a 00                	push   $0x0
 4ae:	ff 75 08             	push   0x8(%ebp)
 4b1:	e8 0c 01 00 00       	call   5c2 <open>
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c0:	79 07                	jns    4c9 <stat+0x26>
    return -1;
 4c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c7:	eb 25                	jmp    4ee <stat+0x4b>
  r = fstat(fd, st);
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	ff 75 0c             	push   0xc(%ebp)
 4cf:	ff 75 f4             	push   -0xc(%ebp)
 4d2:	e8 03 01 00 00       	call   5da <fstat>
 4d7:	83 c4 10             	add    $0x10,%esp
 4da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	ff 75 f4             	push   -0xc(%ebp)
 4e3:	e8 c2 00 00 00       	call   5aa <close>
 4e8:	83 c4 10             	add    $0x10,%esp
  return r;
 4eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4ee:	c9                   	leave
 4ef:	c3                   	ret

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4fd:	eb 25                	jmp    524 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 502:	89 d0                	mov    %edx,%eax
 504:	c1 e0 02             	shl    $0x2,%eax
 507:	01 d0                	add    %edx,%eax
 509:	01 c0                	add    %eax,%eax
 50b:	89 c1                	mov    %eax,%ecx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	8d 50 01             	lea    0x1(%eax),%edx
 513:	89 55 08             	mov    %edx,0x8(%ebp)
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	01 c8                	add    %ecx,%eax
 51e:	83 e8 30             	sub    $0x30,%eax
 521:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	3c 2f                	cmp    $0x2f,%al
 52c:	7e 0a                	jle    538 <atoi+0x48>
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	3c 39                	cmp    $0x39,%al
 536:	7e c7                	jle    4ff <atoi+0xf>
  return n;
 538:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53b:	c9                   	leave
 53c:	c3                   	ret

0000053d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 549:	8b 45 0c             	mov    0xc(%ebp),%eax
 54c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 54f:	eb 17                	jmp    568 <memmove+0x2b>
    *dst++ = *src++;
 551:	8b 55 f8             	mov    -0x8(%ebp),%edx
 554:	8d 42 01             	lea    0x1(%edx),%eax
 557:	89 45 f8             	mov    %eax,-0x8(%ebp)
 55a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 55d:	8d 48 01             	lea    0x1(%eax),%ecx
 560:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 563:	0f b6 12             	movzbl (%edx),%edx
 566:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 568:	8b 45 10             	mov    0x10(%ebp),%eax
 56b:	8d 50 ff             	lea    -0x1(%eax),%edx
 56e:	89 55 10             	mov    %edx,0x10(%ebp)
 571:	85 c0                	test   %eax,%eax
 573:	7f dc                	jg     551 <memmove+0x14>
  return vdst;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
}
 578:	c9                   	leave
 579:	c3                   	ret

0000057a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57a:	b8 01 00 00 00       	mov    $0x1,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret

00000582 <exit>:
SYSCALL(exit)
 582:	b8 02 00 00 00       	mov    $0x2,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret

0000058a <wait>:
SYSCALL(wait)
 58a:	b8 03 00 00 00       	mov    $0x3,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret

00000592 <pipe>:
SYSCALL(pipe)
 592:	b8 04 00 00 00       	mov    $0x4,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret

0000059a <read>:
SYSCALL(read)
 59a:	b8 05 00 00 00       	mov    $0x5,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret

000005a2 <write>:
SYSCALL(write)
 5a2:	b8 10 00 00 00       	mov    $0x10,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret

000005aa <close>:
SYSCALL(close)
 5aa:	b8 15 00 00 00       	mov    $0x15,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret

000005b2 <kill>:
SYSCALL(kill)
 5b2:	b8 06 00 00 00       	mov    $0x6,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret

000005ba <exec>:
SYSCALL(exec)
 5ba:	b8 07 00 00 00       	mov    $0x7,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret

000005c2 <open>:
SYSCALL(open)
 5c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret

000005ca <mknod>:
SYSCALL(mknod)
 5ca:	b8 11 00 00 00       	mov    $0x11,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret

000005d2 <unlink>:
SYSCALL(unlink)
 5d2:	b8 12 00 00 00       	mov    $0x12,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret

000005da <fstat>:
SYSCALL(fstat)
 5da:	b8 08 00 00 00       	mov    $0x8,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret

000005e2 <link>:
SYSCALL(link)
 5e2:	b8 13 00 00 00       	mov    $0x13,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret

000005ea <mkdir>:
SYSCALL(mkdir)
 5ea:	b8 14 00 00 00       	mov    $0x14,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret

000005f2 <chdir>:
SYSCALL(chdir)
 5f2:	b8 09 00 00 00       	mov    $0x9,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret

000005fa <dup>:
SYSCALL(dup)
 5fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret

00000602 <getpid>:
SYSCALL(getpid)
 602:	b8 0b 00 00 00       	mov    $0xb,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret

0000060a <sbrk>:
SYSCALL(sbrk)
 60a:	b8 0c 00 00 00       	mov    $0xc,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret

00000612 <sleep>:
SYSCALL(sleep)
 612:	b8 0d 00 00 00       	mov    $0xd,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret

0000061a <uptime>:
SYSCALL(uptime)
 61a:	b8 0e 00 00 00       	mov    $0xe,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret

00000622 <exit2>:
SYSCALL(exit2)
 622:	b8 16 00 00 00       	mov    $0x16,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret

0000062a <wait2>:
 62a:	b8 17 00 00 00       	mov    $0x17,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret

00000632 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 632:	55                   	push   %ebp
 633:	89 e5                	mov    %esp,%ebp
 635:	83 ec 18             	sub    $0x18,%esp
 638:	8b 45 0c             	mov    0xc(%ebp),%eax
 63b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 63e:	83 ec 04             	sub    $0x4,%esp
 641:	6a 01                	push   $0x1
 643:	8d 45 f4             	lea    -0xc(%ebp),%eax
 646:	50                   	push   %eax
 647:	ff 75 08             	push   0x8(%ebp)
 64a:	e8 53 ff ff ff       	call   5a2 <write>
 64f:	83 c4 10             	add    $0x10,%esp
}
 652:	90                   	nop
 653:	c9                   	leave
 654:	c3                   	ret

00000655 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 655:	55                   	push   %ebp
 656:	89 e5                	mov    %esp,%ebp
 658:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 65b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 662:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 666:	74 17                	je     67f <printint+0x2a>
 668:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 66c:	79 11                	jns    67f <printint+0x2a>
    neg = 1;
 66e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 675:	8b 45 0c             	mov    0xc(%ebp),%eax
 678:	f7 d8                	neg    %eax
 67a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 67d:	eb 06                	jmp    685 <printint+0x30>
  } else {
    x = xx;
 67f:	8b 45 0c             	mov    0xc(%ebp),%eax
 682:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 685:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 68c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 68f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 692:	ba 00 00 00 00       	mov    $0x0,%edx
 697:	f7 f1                	div    %ecx
 699:	89 d1                	mov    %edx,%ecx
 69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69e:	8d 50 01             	lea    0x1(%eax),%edx
 6a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a4:	0f b6 91 c8 0d 00 00 	movzbl 0xdc8(%ecx),%edx
 6ab:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6af:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b5:	ba 00 00 00 00       	mov    $0x0,%edx
 6ba:	f7 f1                	div    %ecx
 6bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c3:	75 c7                	jne    68c <printint+0x37>
  if(neg)
 6c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c9:	74 2d                	je     6f8 <printint+0xa3>
    buf[i++] = '-';
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	8d 50 01             	lea    0x1(%eax),%edx
 6d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6d4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6d9:	eb 1d                	jmp    6f8 <printint+0xa3>
    putc(fd, buf[i]);
 6db:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e1:	01 d0                	add    %edx,%eax
 6e3:	0f b6 00             	movzbl (%eax),%eax
 6e6:	0f be c0             	movsbl %al,%eax
 6e9:	83 ec 08             	sub    $0x8,%esp
 6ec:	50                   	push   %eax
 6ed:	ff 75 08             	push   0x8(%ebp)
 6f0:	e8 3d ff ff ff       	call   632 <putc>
 6f5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 6f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 700:	79 d9                	jns    6db <printint+0x86>
}
 702:	90                   	nop
 703:	90                   	nop
 704:	c9                   	leave
 705:	c3                   	ret

00000706 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 706:	55                   	push   %ebp
 707:	89 e5                	mov    %esp,%ebp
 709:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 70c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 713:	8d 45 0c             	lea    0xc(%ebp),%eax
 716:	83 c0 04             	add    $0x4,%eax
 719:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 71c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 723:	e9 59 01 00 00       	jmp    881 <printf+0x17b>
    c = fmt[i] & 0xff;
 728:	8b 55 0c             	mov    0xc(%ebp),%edx
 72b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72e:	01 d0                	add    %edx,%eax
 730:	0f b6 00             	movzbl (%eax),%eax
 733:	0f be c0             	movsbl %al,%eax
 736:	25 ff 00 00 00       	and    $0xff,%eax
 73b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 73e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 742:	75 2c                	jne    770 <printf+0x6a>
      if(c == '%'){
 744:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 748:	75 0c                	jne    756 <printf+0x50>
        state = '%';
 74a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 751:	e9 27 01 00 00       	jmp    87d <printf+0x177>
      } else {
        putc(fd, c);
 756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 759:	0f be c0             	movsbl %al,%eax
 75c:	83 ec 08             	sub    $0x8,%esp
 75f:	50                   	push   %eax
 760:	ff 75 08             	push   0x8(%ebp)
 763:	e8 ca fe ff ff       	call   632 <putc>
 768:	83 c4 10             	add    $0x10,%esp
 76b:	e9 0d 01 00 00       	jmp    87d <printf+0x177>
      }
    } else if(state == '%'){
 770:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 774:	0f 85 03 01 00 00    	jne    87d <printf+0x177>
      if(c == 'd'){
 77a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 77e:	75 1e                	jne    79e <printf+0x98>
        printint(fd, *ap, 10, 1);
 780:	8b 45 e8             	mov    -0x18(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	6a 01                	push   $0x1
 787:	6a 0a                	push   $0xa
 789:	50                   	push   %eax
 78a:	ff 75 08             	push   0x8(%ebp)
 78d:	e8 c3 fe ff ff       	call   655 <printint>
 792:	83 c4 10             	add    $0x10,%esp
        ap++;
 795:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 799:	e9 d8 00 00 00       	jmp    876 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 79e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7a2:	74 06                	je     7aa <printf+0xa4>
 7a4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7a8:	75 1e                	jne    7c8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	6a 00                	push   $0x0
 7b1:	6a 10                	push   $0x10
 7b3:	50                   	push   %eax
 7b4:	ff 75 08             	push   0x8(%ebp)
 7b7:	e8 99 fe ff ff       	call   655 <printint>
 7bc:	83 c4 10             	add    $0x10,%esp
        ap++;
 7bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c3:	e9 ae 00 00 00       	jmp    876 <printf+0x170>
      } else if(c == 's'){
 7c8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7cc:	75 43                	jne    811 <printf+0x10b>
        s = (char*)*ap;
 7ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7de:	75 25                	jne    805 <printf+0xff>
          s = "(null)";
 7e0:	c7 45 f4 f6 0a 00 00 	movl   $0xaf6,-0xc(%ebp)
        while(*s != 0){
 7e7:	eb 1c                	jmp    805 <printf+0xff>
          putc(fd, *s);
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	0f b6 00             	movzbl (%eax),%eax
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	83 ec 08             	sub    $0x8,%esp
 7f5:	50                   	push   %eax
 7f6:	ff 75 08             	push   0x8(%ebp)
 7f9:	e8 34 fe ff ff       	call   632 <putc>
 7fe:	83 c4 10             	add    $0x10,%esp
          s++;
 801:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	0f b6 00             	movzbl (%eax),%eax
 80b:	84 c0                	test   %al,%al
 80d:	75 da                	jne    7e9 <printf+0xe3>
 80f:	eb 65                	jmp    876 <printf+0x170>
        }
      } else if(c == 'c'){
 811:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 815:	75 1d                	jne    834 <printf+0x12e>
        putc(fd, *ap);
 817:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	0f be c0             	movsbl %al,%eax
 81f:	83 ec 08             	sub    $0x8,%esp
 822:	50                   	push   %eax
 823:	ff 75 08             	push   0x8(%ebp)
 826:	e8 07 fe ff ff       	call   632 <putc>
 82b:	83 c4 10             	add    $0x10,%esp
        ap++;
 82e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 832:	eb 42                	jmp    876 <printf+0x170>
      } else if(c == '%'){
 834:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 838:	75 17                	jne    851 <printf+0x14b>
        putc(fd, c);
 83a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 83d:	0f be c0             	movsbl %al,%eax
 840:	83 ec 08             	sub    $0x8,%esp
 843:	50                   	push   %eax
 844:	ff 75 08             	push   0x8(%ebp)
 847:	e8 e6 fd ff ff       	call   632 <putc>
 84c:	83 c4 10             	add    $0x10,%esp
 84f:	eb 25                	jmp    876 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 851:	83 ec 08             	sub    $0x8,%esp
 854:	6a 25                	push   $0x25
 856:	ff 75 08             	push   0x8(%ebp)
 859:	e8 d4 fd ff ff       	call   632 <putc>
 85e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 864:	0f be c0             	movsbl %al,%eax
 867:	83 ec 08             	sub    $0x8,%esp
 86a:	50                   	push   %eax
 86b:	ff 75 08             	push   0x8(%ebp)
 86e:	e8 bf fd ff ff       	call   632 <putc>
 873:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 876:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 87d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 881:	8b 55 0c             	mov    0xc(%ebp),%edx
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	01 d0                	add    %edx,%eax
 889:	0f b6 00             	movzbl (%eax),%eax
 88c:	84 c0                	test   %al,%al
 88e:	0f 85 94 fe ff ff    	jne    728 <printf+0x22>
    }
  }
}
 894:	90                   	nop
 895:	90                   	nop
 896:	c9                   	leave
 897:	c3                   	ret

00000898 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 898:	55                   	push   %ebp
 899:	89 e5                	mov    %esp,%ebp
 89b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	83 e8 08             	sub    $0x8,%eax
 8a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a7:	a1 e8 11 00 00       	mov    0x11e8,%eax
 8ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8af:	eb 24                	jmp    8d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8b9:	72 12                	jb     8cd <free+0x35>
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8c1:	72 24                	jb     8e7 <free+0x4f>
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 00                	mov    (%eax),%eax
 8c8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8cb:	72 1a                	jb     8e7 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8db:	73 d4                	jae    8b1 <free+0x19>
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8b 00                	mov    (%eax),%eax
 8e2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8e5:	73 ca                	jae    8b1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	01 c2                	add    %eax,%edx
 8f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fc:	8b 00                	mov    (%eax),%eax
 8fe:	39 c2                	cmp    %eax,%edx
 900:	75 24                	jne    926 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	8b 50 04             	mov    0x4(%eax),%edx
 908:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90b:	8b 00                	mov    (%eax),%eax
 90d:	8b 40 04             	mov    0x4(%eax),%eax
 910:	01 c2                	add    %eax,%edx
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 00                	mov    (%eax),%eax
 91d:	8b 10                	mov    (%eax),%edx
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	89 10                	mov    %edx,(%eax)
 924:	eb 0a                	jmp    930 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	8b 10                	mov    (%eax),%edx
 92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 940:	01 d0                	add    %edx,%eax
 942:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 945:	75 20                	jne    967 <free+0xcf>
    p->s.size += bp->s.size;
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	8b 50 04             	mov    0x4(%eax),%edx
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	8b 40 04             	mov    0x4(%eax),%eax
 953:	01 c2                	add    %eax,%edx
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95e:	8b 10                	mov    (%eax),%edx
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	89 10                	mov    %edx,(%eax)
 965:	eb 08                	jmp    96f <free+0xd7>
  } else
    p->s.ptr = bp;
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 96d:	89 10                	mov    %edx,(%eax)
  freep = p;
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	a3 e8 11 00 00       	mov    %eax,0x11e8
}
 977:	90                   	nop
 978:	c9                   	leave
 979:	c3                   	ret

0000097a <morecore>:

static Header*
morecore(uint nu)
{
 97a:	55                   	push   %ebp
 97b:	89 e5                	mov    %esp,%ebp
 97d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 980:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 987:	77 07                	ja     990 <morecore+0x16>
    nu = 4096;
 989:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 990:	8b 45 08             	mov    0x8(%ebp),%eax
 993:	c1 e0 03             	shl    $0x3,%eax
 996:	83 ec 0c             	sub    $0xc,%esp
 999:	50                   	push   %eax
 99a:	e8 6b fc ff ff       	call   60a <sbrk>
 99f:	83 c4 10             	add    $0x10,%esp
 9a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9a9:	75 07                	jne    9b2 <morecore+0x38>
    return 0;
 9ab:	b8 00 00 00 00       	mov    $0x0,%eax
 9b0:	eb 26                	jmp    9d8 <morecore+0x5e>
  hp = (Header*)p;
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bb:	8b 55 08             	mov    0x8(%ebp),%edx
 9be:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c4:	83 c0 08             	add    $0x8,%eax
 9c7:	83 ec 0c             	sub    $0xc,%esp
 9ca:	50                   	push   %eax
 9cb:	e8 c8 fe ff ff       	call   898 <free>
 9d0:	83 c4 10             	add    $0x10,%esp
  return freep;
 9d3:	a1 e8 11 00 00       	mov    0x11e8,%eax
}
 9d8:	c9                   	leave
 9d9:	c3                   	ret

000009da <malloc>:

void*
malloc(uint nbytes)
{
 9da:	55                   	push   %ebp
 9db:	89 e5                	mov    %esp,%ebp
 9dd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	83 c0 07             	add    $0x7,%eax
 9e6:	c1 e8 03             	shr    $0x3,%eax
 9e9:	83 c0 01             	add    $0x1,%eax
 9ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9ef:	a1 e8 11 00 00       	mov    0x11e8,%eax
 9f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9fb:	75 23                	jne    a20 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9fd:	c7 45 f0 e0 11 00 00 	movl   $0x11e0,-0x10(%ebp)
 a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a07:	a3 e8 11 00 00       	mov    %eax,0x11e8
 a0c:	a1 e8 11 00 00       	mov    0x11e8,%eax
 a11:	a3 e0 11 00 00       	mov    %eax,0x11e0
    base.s.size = 0;
 a16:	c7 05 e4 11 00 00 00 	movl   $0x0,0x11e4
 a1d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a23:	8b 00                	mov    (%eax),%eax
 a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 04             	mov    0x4(%eax),%eax
 a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a31:	72 4d                	jb     a80 <malloc+0xa6>
      if(p->s.size == nunits)
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 40 04             	mov    0x4(%eax),%eax
 a39:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a3c:	75 0c                	jne    a4a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 10                	mov    (%eax),%edx
 a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a46:	89 10                	mov    %edx,(%eax)
 a48:	eb 26                	jmp    a70 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 40 04             	mov    0x4(%eax),%eax
 a50:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a53:	89 c2                	mov    %eax,%edx
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	c1 e0 03             	shl    $0x3,%eax
 a64:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a6d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a73:	a3 e8 11 00 00       	mov    %eax,0x11e8
      return (void*)(p + 1);
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	83 c0 08             	add    $0x8,%eax
 a7e:	eb 3b                	jmp    abb <malloc+0xe1>
    }
    if(p == freep)
 a80:	a1 e8 11 00 00       	mov    0x11e8,%eax
 a85:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a88:	75 1e                	jne    aa8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a8a:	83 ec 0c             	sub    $0xc,%esp
 a8d:	ff 75 ec             	push   -0x14(%ebp)
 a90:	e8 e5 fe ff ff       	call   97a <morecore>
 a95:	83 c4 10             	add    $0x10,%esp
 a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a9f:	75 07                	jne    aa8 <malloc+0xce>
        return 0;
 aa1:	b8 00 00 00 00       	mov    $0x0,%eax
 aa6:	eb 13                	jmp    abb <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	8b 00                	mov    (%eax),%eax
 ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ab6:	e9 6d ff ff ff       	jmp    a28 <malloc+0x4e>
  }
}
 abb:	c9                   	leave
 abc:	c3                   	ret
