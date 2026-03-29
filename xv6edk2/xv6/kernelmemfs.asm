
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <wait_main>:
8010000c:	00 00                	add    %al,(%eax)
	...

80100010 <entry>:
  .long 0
# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  #Set Data Segment
  mov $0x10,%ax
80100010:	66 b8 10 00          	mov    $0x10,%ax
  mov %ax,%ds
80100014:	8e d8                	mov    %eax,%ds
  mov %ax,%es
80100016:	8e c0                	mov    %eax,%es
  mov %ax,%ss
80100018:	8e d0                	mov    %eax,%ss
  mov $0,%ax
8010001a:	66 b8 00 00          	mov    $0x0,%ax
  mov %ax,%fs
8010001e:	8e e0                	mov    %eax,%fs
  mov %ax,%gs
80100020:	8e e8                	mov    %eax,%gs

  #Turn off paing
  movl %cr0,%eax
80100022:	0f 20 c0             	mov    %cr0,%eax
  andl $0x7fffffff,%eax
80100025:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  movl %eax,%cr0 
8010002a:	0f 22 c0             	mov    %eax,%cr0

  #Set Page Table Base Address
  movl    $(V2P_WO(entrypgdir)), %eax
8010002d:	b8 00 e0 10 00       	mov    $0x10e000,%eax
  movl    %eax, %cr3
80100032:	0f 22 d8             	mov    %eax,%cr3
  
  #Disable IA32e mode
  movl $0x0c0000080,%ecx
80100035:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
8010003a:	0f 32                	rdmsr
  andl $0xFFFFFEFF,%eax
8010003c:	25 ff fe ff ff       	and    $0xfffffeff,%eax
  wrmsr
80100041:	0f 30                	wrmsr

  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80100043:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80100046:	83 c8 10             	or     $0x10,%eax
  andl    $0xFFFFFFDF, %eax
80100049:	83 e0 df             	and    $0xffffffdf,%eax
  movl    %eax, %cr4
8010004c:	0f 22 e0             	mov    %eax,%cr4

  #Turn on Paging
  movl    %cr0, %eax
8010004f:	0f 20 c0             	mov    %cr0,%eax
  orl     $0x80010001, %eax
80100052:	0d 01 00 01 80       	or     $0x80010001,%eax
  movl    %eax, %cr0
80100057:	0f 22 c0             	mov    %eax,%cr0




  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
8010005a:	bc 80 80 19 80       	mov    $0x80198080,%esp
  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
#  jz .waiting_main
  movl $main, %edx
8010005f:	ba 67 33 10 80       	mov    $0x80103367,%edx
  jmp %edx
80100064:	ff e2                	jmp    *%edx

80100066 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100066:	55                   	push   %ebp
80100067:	89 e5                	mov    %esp,%ebp
80100069:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010006c:	83 ec 08             	sub    $0x8,%esp
8010006f:	68 20 a2 10 80       	push   $0x8010a220
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 a8 48 00 00       	call   80104926 <initlock>
8010007e:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100081:	c7 05 4c 17 19 80 fc 	movl   $0x801916fc,0x8019174c
80100088:	16 19 80 
  bcache.head.next = &bcache.head;
8010008b:	c7 05 50 17 19 80 fc 	movl   $0x801916fc,0x80191750
80100092:	16 19 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100095:	c7 45 f4 34 d0 18 80 	movl   $0x8018d034,-0xc(%ebp)
8010009c:	eb 47                	jmp    801000e5 <binit+0x7f>
    b->next = bcache.head.next;
8010009e:	8b 15 50 17 19 80    	mov    0x80191750,%edx
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ad:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
801000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b7:	83 c0 0c             	add    $0xc,%eax
801000ba:	83 ec 08             	sub    $0x8,%esp
801000bd:	68 27 a2 10 80       	push   $0x8010a227
801000c2:	50                   	push   %eax
801000c3:	e8 01 47 00 00       	call   801047c9 <initsleeplock>
801000c8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000cb:	a1 50 17 19 80       	mov    0x80191750,%eax
801000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d3:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d9:	a3 50 17 19 80       	mov    %eax,0x80191750
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000de:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e5:	b8 fc 16 19 80       	mov    $0x801916fc,%eax
801000ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ed:	72 af                	jb     8010009e <binit+0x38>
  }
}
801000ef:	90                   	nop
801000f0:	90                   	nop
801000f1:	c9                   	leave
801000f2:	c3                   	ret

801000f3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000f3:	55                   	push   %ebp
801000f4:	89 e5                	mov    %esp,%ebp
801000f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000f9:	83 ec 0c             	sub    $0xc,%esp
801000fc:	68 00 d0 18 80       	push   $0x8018d000
80100101:	e8 42 48 00 00       	call   80104948 <acquire>
80100106:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	a1 50 17 19 80       	mov    0x80191750,%eax
8010010e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100111:	eb 58                	jmp    8010016b <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	8b 40 04             	mov    0x4(%eax),%eax
80100119:	39 45 08             	cmp    %eax,0x8(%ebp)
8010011c:	75 44                	jne    80100162 <bget+0x6f>
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	8b 40 08             	mov    0x8(%eax),%eax
80100124:	39 45 0c             	cmp    %eax,0xc(%ebp)
80100127:	75 39                	jne    80100162 <bget+0x6f>
      b->refcnt++;
80100129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010012f:	8d 50 01             	lea    0x1(%eax),%edx
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100138:	83 ec 0c             	sub    $0xc,%esp
8010013b:	68 00 d0 18 80       	push   $0x8018d000
80100140:	e8 71 48 00 00       	call   801049b6 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 ae 46 00 00       	call   80104805 <acquiresleep>
80100157:	83 c4 10             	add    $0x10,%esp
      return b;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	e9 9d 00 00 00       	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 40 54             	mov    0x54(%eax),%eax
80100168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010016b:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
80100172:	75 9f                	jne    80100113 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100174:	a1 4c 17 19 80       	mov    0x8019174c,%eax
80100179:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010017c:	eb 6b                	jmp    801001e9 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010017e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100181:	8b 40 4c             	mov    0x4c(%eax),%eax
80100184:	85 c0                	test   %eax,%eax
80100186:	75 58                	jne    801001e0 <bget+0xed>
80100188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018b:	8b 00                	mov    (%eax),%eax
8010018d:	83 e0 04             	and    $0x4,%eax
80100190:	85 c0                	test   %eax,%eax
80100192:	75 4c                	jne    801001e0 <bget+0xed>
      b->dev = dev;
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 55 08             	mov    0x8(%ebp),%edx
8010019a:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010019d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801001a3:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
801001a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
801001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	68 00 d0 18 80       	push   $0x8018d000
801001c1:	e8 f0 47 00 00       	call   801049b6 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 2d 46 00 00       	call   80104805 <acquiresleep>
801001d8:	83 c4 10             	add    $0x10,%esp
      return b;
801001db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001de:	eb 1f                	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e3:	8b 40 50             	mov    0x50(%eax),%eax
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001e9:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
801001f0:	75 8c                	jne    8010017e <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	68 2e a2 10 80       	push   $0x8010a22e
801001fa:	e8 aa 03 00 00       	call   801005a9 <panic>
}
801001ff:	c9                   	leave
80100200:	c3                   	ret

80100201 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100201:	55                   	push   %ebp
80100202:	89 e5                	mov    %esp,%ebp
80100204:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100207:	83 ec 08             	sub    $0x8,%esp
8010020a:	ff 75 0c             	push   0xc(%ebp)
8010020d:	ff 75 08             	push   0x8(%ebp)
80100210:	e8 de fe ff ff       	call   801000f3 <bget>
80100215:	83 c4 10             	add    $0x10,%esp
80100218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
8010021b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010021e:	8b 00                	mov    (%eax),%eax
80100220:	83 e0 02             	and    $0x2,%eax
80100223:	85 c0                	test   %eax,%eax
80100225:	75 0e                	jne    80100235 <bread+0x34>
    iderw(b);
80100227:	83 ec 0c             	sub    $0xc,%esp
8010022a:	ff 75 f4             	push   -0xc(%ebp)
8010022d:	e8 f4 9e 00 00       	call   8010a126 <iderw>
80100232:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100235:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100238:	c9                   	leave
80100239:	c3                   	ret

8010023a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010023a:	55                   	push   %ebp
8010023b:	89 e5                	mov    %esp,%ebp
8010023d:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100240:	8b 45 08             	mov    0x8(%ebp),%eax
80100243:	83 c0 0c             	add    $0xc,%eax
80100246:	83 ec 0c             	sub    $0xc,%esp
80100249:	50                   	push   %eax
8010024a:	e8 68 46 00 00       	call   801048b7 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 3f a2 10 80       	push   $0x8010a23f
8010025e:	e8 46 03 00 00       	call   801005a9 <panic>
  b->flags |= B_DIRTY;
80100263:	8b 45 08             	mov    0x8(%ebp),%eax
80100266:	8b 00                	mov    (%eax),%eax
80100268:	83 c8 04             	or     $0x4,%eax
8010026b:	89 c2                	mov    %eax,%edx
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100272:	83 ec 0c             	sub    $0xc,%esp
80100275:	ff 75 08             	push   0x8(%ebp)
80100278:	e8 a9 9e 00 00       	call   8010a126 <iderw>
8010027d:	83 c4 10             	add    $0x10,%esp
}
80100280:	90                   	nop
80100281:	c9                   	leave
80100282:	c3                   	ret

80100283 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100283:	55                   	push   %ebp
80100284:	89 e5                	mov    %esp,%ebp
80100286:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	83 c0 0c             	add    $0xc,%eax
8010028f:	83 ec 0c             	sub    $0xc,%esp
80100292:	50                   	push   %eax
80100293:	e8 1f 46 00 00       	call   801048b7 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 46 a2 10 80       	push   $0x8010a246
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 ae 45 00 00       	call   80104869 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 7d 46 00 00       	call   80104948 <acquire>
801002cb:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002ce:	8b 45 08             	mov    0x8(%ebp),%eax
801002d1:	8b 40 4c             	mov    0x4c(%eax),%eax
801002d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801002d7:	8b 45 08             	mov    0x8(%ebp),%eax
801002da:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002dd:	8b 45 08             	mov    0x8(%ebp),%eax
801002e0:	8b 40 4c             	mov    0x4c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	75 47                	jne    8010032e <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002e7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ea:	8b 40 54             	mov    0x54(%eax),%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	8b 52 50             	mov    0x50(%edx),%edx
801002f3:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002f6:	8b 45 08             	mov    0x8(%ebp),%eax
801002f9:	8b 40 50             	mov    0x50(%eax),%eax
801002fc:	8b 55 08             	mov    0x8(%ebp),%edx
801002ff:	8b 52 54             	mov    0x54(%edx),%edx
80100302:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100305:	8b 15 50 17 19 80    	mov    0x80191750,%edx
8010030b:	8b 45 08             	mov    0x8(%ebp),%eax
8010030e:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    bcache.head.next->prev = b;
8010031b:	a1 50 17 19 80       	mov    0x80191750,%eax
80100320:	8b 55 08             	mov    0x8(%ebp),%edx
80100323:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	a3 50 17 19 80       	mov    %eax,0x80191750
  }
  
  release(&bcache.lock);
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 00 d0 18 80       	push   $0x8018d000
80100336:	e8 7b 46 00 00       	call   801049b6 <release>
8010033b:	83 c4 10             	add    $0x10,%esp
}
8010033e:	90                   	nop
8010033f:	c9                   	leave
80100340:	c3                   	ret

80100341 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100344:	fa                   	cli
}
80100345:	90                   	nop
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret

80100348 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010034e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100352:	74 1c                	je     80100370 <printint+0x28>
80100354:	8b 45 08             	mov    0x8(%ebp),%eax
80100357:	c1 e8 1f             	shr    $0x1f,%eax
8010035a:	0f b6 c0             	movzbl %al,%eax
8010035d:	89 45 10             	mov    %eax,0x10(%ebp)
80100360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100364:	74 0a                	je     80100370 <printint+0x28>
    x = -xx;
80100366:	8b 45 08             	mov    0x8(%ebp),%eax
80100369:	f7 d8                	neg    %eax
8010036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036e:	eb 06                	jmp    80100376 <printint+0x2e>
  else
    x = xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010037d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100383:	ba 00 00 00 00       	mov    $0x0,%edx
80100388:	f7 f1                	div    %ecx
8010038a:	89 d1                	mov    %edx,%ecx
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	0f b6 91 04 d0 10 80 	movzbl -0x7fef2ffc(%ecx),%edx
8010039c:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a6:	ba 00 00 00 00       	mov    $0x0,%edx
801003ab:	f7 f1                	div    %ecx
801003ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003b4:	75 c7                	jne    8010037d <printint+0x35>

  if(sign)
801003b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003ba:	74 2a                	je     801003e6 <printint+0x9e>
    buf[i++] = '-';
801003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bf:	8d 50 01             	lea    0x1(%eax),%edx
801003c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003c5:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ca:	eb 1a                	jmp    801003e6 <printint+0x9e>
    consputc(buf[i]);
801003cc:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d2:	01 d0                	add    %edx,%eax
801003d4:	0f b6 00             	movzbl (%eax),%eax
801003d7:	0f be c0             	movsbl %al,%eax
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 8b 03 00 00       	call   8010076e <consputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ee:	79 dc                	jns    801003cc <printint+0x84>
}
801003f0:	90                   	nop
801003f1:	90                   	nop
801003f2:	c9                   	leave
801003f3:	c3                   	ret

801003f4 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003f4:	55                   	push   %ebp
801003f5:	89 e5                	mov    %esp,%ebp
801003f7:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003fa:	a1 34 1a 19 80       	mov    0x80191a34,%eax
801003ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100406:	74 10                	je     80100418 <cprintf+0x24>
    acquire(&cons.lock);
80100408:	83 ec 0c             	sub    $0xc,%esp
8010040b:	68 00 1a 19 80       	push   $0x80191a00
80100410:	e8 33 45 00 00       	call   80104948 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 4d a2 10 80       	push   $0x8010a24d
80100427:	e8 7d 01 00 00       	call   801005a9 <panic>


  argp = (uint*)(void*)(&fmt + 1);
8010042c:	8d 45 0c             	lea    0xc(%ebp),%eax
8010042f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100439:	e9 2f 01 00 00       	jmp    8010056d <cprintf+0x179>
    if(c != '%'){
8010043e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100442:	74 13                	je     80100457 <cprintf+0x63>
      consputc(c);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	ff 75 e4             	push   -0x1c(%ebp)
8010044a:	e8 1f 03 00 00       	call   8010076e <consputc>
8010044f:	83 c4 10             	add    $0x10,%esp
      continue;
80100452:	e9 12 01 00 00       	jmp    80100569 <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100457:	8b 55 08             	mov    0x8(%ebp),%edx
8010045a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100461:	01 d0                	add    %edx,%eax
80100463:	0f b6 00             	movzbl (%eax),%eax
80100466:	0f be c0             	movsbl %al,%eax
80100469:	25 ff 00 00 00       	and    $0xff,%eax
8010046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100475:	0f 84 14 01 00 00    	je     8010058f <cprintf+0x19b>
      break;
    switch(c){
8010047b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010047f:	74 5e                	je     801004df <cprintf+0xeb>
80100481:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100485:	0f 8f c2 00 00 00    	jg     8010054d <cprintf+0x159>
8010048b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010048f:	74 6b                	je     801004fc <cprintf+0x108>
80100491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100495:	0f 8f b2 00 00 00    	jg     8010054d <cprintf+0x159>
8010049b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010049f:	74 3e                	je     801004df <cprintf+0xeb>
801004a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a5:	0f 8f a2 00 00 00    	jg     8010054d <cprintf+0x159>
801004ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004af:	0f 84 89 00 00 00    	je     8010053e <cprintf+0x14a>
801004b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004b9:	0f 85 8e 00 00 00    	jne    8010054d <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
801004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c2:	8d 50 04             	lea    0x4(%eax),%edx
801004c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c8:	8b 00                	mov    (%eax),%eax
801004ca:	83 ec 04             	sub    $0x4,%esp
801004cd:	6a 01                	push   $0x1
801004cf:	6a 0a                	push   $0xa
801004d1:	50                   	push   %eax
801004d2:	e8 71 fe ff ff       	call   80100348 <printint>
801004d7:	83 c4 10             	add    $0x10,%esp
      break;
801004da:	e9 8a 00 00 00       	jmp    80100569 <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e2:	8d 50 04             	lea    0x4(%eax),%edx
801004e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e8:	8b 00                	mov    (%eax),%eax
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	6a 00                	push   $0x0
801004ef:	6a 10                	push   $0x10
801004f1:	50                   	push   %eax
801004f2:	e8 51 fe ff ff       	call   80100348 <printint>
801004f7:	83 c4 10             	add    $0x10,%esp
      break;
801004fa:	eb 6d                	jmp    80100569 <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ff:	8d 50 04             	lea    0x4(%eax),%edx
80100502:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100505:	8b 00                	mov    (%eax),%eax
80100507:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010050a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010050e:	75 22                	jne    80100532 <cprintf+0x13e>
        s = "(null)";
80100510:	c7 45 ec 56 a2 10 80 	movl   $0x8010a256,-0x14(%ebp)
      for(; *s; s++)
80100517:	eb 19                	jmp    80100532 <cprintf+0x13e>
        consputc(*s);
80100519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051c:	0f b6 00             	movzbl (%eax),%eax
8010051f:	0f be c0             	movsbl %al,%eax
80100522:	83 ec 0c             	sub    $0xc,%esp
80100525:	50                   	push   %eax
80100526:	e8 43 02 00 00       	call   8010076e <consputc>
8010052b:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010052e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100535:	0f b6 00             	movzbl (%eax),%eax
80100538:	84 c0                	test   %al,%al
8010053a:	75 dd                	jne    80100519 <cprintf+0x125>
      break;
8010053c:	eb 2b                	jmp    80100569 <cprintf+0x175>
    case '%':
      consputc('%');
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	6a 25                	push   $0x25
80100543:	e8 26 02 00 00       	call   8010076e <consputc>
80100548:	83 c4 10             	add    $0x10,%esp
      break;
8010054b:	eb 1c                	jmp    80100569 <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	6a 25                	push   $0x25
80100552:	e8 17 02 00 00       	call   8010076e <consputc>
80100557:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010055a:	83 ec 0c             	sub    $0xc,%esp
8010055d:	ff 75 e4             	push   -0x1c(%ebp)
80100560:	e8 09 02 00 00       	call   8010076e <consputc>
80100565:	83 c4 10             	add    $0x10,%esp
      break;
80100568:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010056d:	8b 55 08             	mov    0x8(%ebp),%edx
80100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100573:	01 d0                	add    %edx,%eax
80100575:	0f b6 00             	movzbl (%eax),%eax
80100578:	0f be c0             	movsbl %al,%eax
8010057b:	25 ff 00 00 00       	and    $0xff,%eax
80100580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100587:	0f 85 b1 fe ff ff    	jne    8010043e <cprintf+0x4a>
8010058d:	eb 01                	jmp    80100590 <cprintf+0x19c>
      break;
8010058f:	90                   	nop
    }
  }

  if(locking)
80100590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100594:	74 10                	je     801005a6 <cprintf+0x1b2>
    release(&cons.lock);
80100596:	83 ec 0c             	sub    $0xc,%esp
80100599:	68 00 1a 19 80       	push   $0x80191a00
8010059e:	e8 13 44 00 00       	call   801049b6 <release>
801005a3:	83 c4 10             	add    $0x10,%esp
}
801005a6:	90                   	nop
801005a7:	c9                   	leave
801005a8:	c3                   	ret

801005a9 <panic>:

void
panic(char *s)
{
801005a9:	55                   	push   %ebp
801005aa:	89 e5                	mov    %esp,%ebp
801005ac:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005af:	e8 8d fd ff ff       	call   80100341 <cli>
  cons.locking = 0;
801005b4:	c7 05 34 1a 19 80 00 	movl   $0x0,0x80191a34
801005bb:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005be:	e8 39 25 00 00       	call   80102afc <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 5d a2 10 80       	push   $0x8010a25d
801005cc:	e8 23 fe ff ff       	call   801003f4 <cprintf>
801005d1:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005d4:	8b 45 08             	mov    0x8(%ebp),%eax
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	50                   	push   %eax
801005db:	e8 14 fe ff ff       	call   801003f4 <cprintf>
801005e0:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005e3:	83 ec 0c             	sub    $0xc,%esp
801005e6:	68 71 a2 10 80       	push   $0x8010a271
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 05 44 00 00       	call   80104a08 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 73 a2 10 80       	push   $0x8010a273
8010061f:	e8 d0 fd ff ff       	call   801003f4 <cprintf>
80100624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062f:	7e de                	jle    8010060f <panic+0x66>
  panicked = 1; // freeze other CPU
80100631:	c7 05 ec 19 19 80 01 	movl   $0x1,0x801919ec
80100638:	00 00 00 
  for(;;)
8010063b:	90                   	nop
8010063c:	eb fd                	jmp    8010063b <panic+0x92>

8010063e <graphic_putc>:

#define CONSOLE_HORIZONTAL_MAX 53
#define CONSOLE_VERTICAL_MAX 20
int console_pos = CONSOLE_HORIZONTAL_MAX*(CONSOLE_VERTICAL_MAX);
//int console_pos = 0;
void graphic_putc(int c){
8010063e:	55                   	push   %ebp
8010063f:	89 e5                	mov    %esp,%ebp
80100641:	83 ec 18             	sub    $0x18,%esp
  if(c == '\n'){
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 64                	jne    801006ae <graphic_putc+0x70>
    console_pos += CONSOLE_HORIZONTAL_MAX - console_pos%CONSOLE_HORIZONTAL_MAX;
8010064a:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100650:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	f7 ea                	imul   %edx
80100659:	89 d0                	mov    %edx,%eax
8010065b:	c1 f8 04             	sar    $0x4,%eax
8010065e:	89 ca                	mov    %ecx,%edx
80100660:	c1 fa 1f             	sar    $0x1f,%edx
80100663:	29 d0                	sub    %edx,%eax
80100665:	6b d0 35             	imul   $0x35,%eax,%edx
80100668:	89 c8                	mov    %ecx,%eax
8010066a:	29 d0                	sub    %edx,%eax
8010066c:	ba 35 00 00 00       	mov    $0x35,%edx
80100671:	29 c2                	sub    %eax,%edx
80100673:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100678:	01 d0                	add    %edx,%eax
8010067a:	a3 00 d0 10 80       	mov    %eax,0x8010d000
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
8010067f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100684:	3d 23 04 00 00       	cmp    $0x423,%eax
80100689:	0f 8e dc 00 00 00    	jle    8010076b <graphic_putc+0x12d>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
8010068f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100694:	83 e8 35             	sub    $0x35,%eax
80100697:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
8010069c:	83 ec 0c             	sub    $0xc,%esp
8010069f:	6a 1e                	push   $0x1e
801006a1:	e8 ed 79 00 00       	call   80108093 <graphic_scroll_up>
801006a6:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
    font_render(x,y,c);
    console_pos++;
  }
}
801006a9:	e9 bd 00 00 00       	jmp    8010076b <graphic_putc+0x12d>
  }else if(c == BACKSPACE){
801006ae:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006b5:	75 1f                	jne    801006d6 <graphic_putc+0x98>
    if(console_pos>0) --console_pos;
801006b7:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006bc:	85 c0                	test   %eax,%eax
801006be:	0f 8e a7 00 00 00    	jle    8010076b <graphic_putc+0x12d>
801006c4:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006c9:	83 e8 01             	sub    $0x1,%eax
801006cc:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
801006d1:	e9 95 00 00 00       	jmp    8010076b <graphic_putc+0x12d>
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
801006d6:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006db:	3d 23 04 00 00       	cmp    $0x423,%eax
801006e0:	7e 1a                	jle    801006fc <graphic_putc+0xbe>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
801006e2:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006e7:	83 e8 35             	sub    $0x35,%eax
801006ea:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
801006ef:	83 ec 0c             	sub    $0xc,%esp
801006f2:	6a 1e                	push   $0x1e
801006f4:	e8 9a 79 00 00       	call   80108093 <graphic_scroll_up>
801006f9:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
801006fc:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100702:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100707:	89 c8                	mov    %ecx,%eax
80100709:	f7 ea                	imul   %edx
8010070b:	89 d0                	mov    %edx,%eax
8010070d:	c1 f8 04             	sar    $0x4,%eax
80100710:	89 ca                	mov    %ecx,%edx
80100712:	c1 fa 1f             	sar    $0x1f,%edx
80100715:	29 d0                	sub    %edx,%eax
80100717:	6b d0 35             	imul   $0x35,%eax,%edx
8010071a:	89 c8                	mov    %ecx,%eax
8010071c:	29 d0                	sub    %edx,%eax
8010071e:	89 c2                	mov    %eax,%edx
80100720:	c1 e2 04             	shl    $0x4,%edx
80100723:	29 c2                	sub    %eax,%edx
80100725:	8d 42 02             	lea    0x2(%edx),%eax
80100728:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
8010072b:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100731:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100736:	89 c8                	mov    %ecx,%eax
80100738:	f7 ea                	imul   %edx
8010073a:	c1 fa 04             	sar    $0x4,%edx
8010073d:	89 c8                	mov    %ecx,%eax
8010073f:	c1 f8 1f             	sar    $0x1f,%eax
80100742:	29 c2                	sub    %eax,%edx
80100744:	6b c2 1e             	imul   $0x1e,%edx,%eax
80100747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    font_render(x,y,c);
8010074a:	83 ec 04             	sub    $0x4,%esp
8010074d:	ff 75 08             	push   0x8(%ebp)
80100750:	ff 75 f0             	push   -0x10(%ebp)
80100753:	ff 75 f4             	push   -0xc(%ebp)
80100756:	e8 a5 79 00 00       	call   80108100 <font_render>
8010075b:	83 c4 10             	add    $0x10,%esp
    console_pos++;
8010075e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100763:	83 c0 01             	add    $0x1,%eax
80100766:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
8010076b:	90                   	nop
8010076c:	c9                   	leave
8010076d:	c3                   	ret

8010076e <consputc>:


void
consputc(int c)
{
8010076e:	55                   	push   %ebp
8010076f:	89 e5                	mov    %esp,%ebp
80100771:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100774:	a1 ec 19 19 80       	mov    0x801919ec,%eax
80100779:	85 c0                	test   %eax,%eax
8010077b:	74 08                	je     80100785 <consputc+0x17>
    cli();
8010077d:	e8 bf fb ff ff       	call   80100341 <cli>
    for(;;)
80100782:	90                   	nop
80100783:	eb fd                	jmp    80100782 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
80100785:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010078c:	75 29                	jne    801007b7 <consputc+0x49>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078e:	83 ec 0c             	sub    $0xc,%esp
80100791:	6a 08                	push   $0x8
80100793:	e8 74 5d 00 00       	call   8010650c <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 67 5d 00 00       	call   8010650c <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 5a 5d 00 00       	call   8010650c <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x57>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 4a 5d 00 00       	call   8010650c <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
  }
  graphic_putc(c);
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	ff 75 08             	push   0x8(%ebp)
801007cb:	e8 6e fe ff ff       	call   8010063e <graphic_putc>
801007d0:	83 c4 10             	add    $0x10,%esp
}
801007d3:	90                   	nop
801007d4:	c9                   	leave
801007d5:	c3                   	ret

801007d6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d6:	55                   	push   %ebp
801007d7:	89 e5                	mov    %esp,%ebp
801007d9:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 00 1a 19 80       	push   $0x80191a00
801007eb:	e8 58 41 00 00       	call   80104948 <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 58 01 00 00       	jmp    80100950 <consoleintr+0x17a>
    switch(c){
801007f8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801007fc:	0f 84 81 00 00 00    	je     80100883 <consoleintr+0xad>
80100802:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100806:	0f 8f ac 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010080c:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100810:	74 43                	je     80100855 <consoleintr+0x7f>
80100812:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100816:	0f 8f 9c 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010081c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100820:	74 61                	je     80100883 <consoleintr+0xad>
80100822:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100826:	0f 85 8c 00 00 00    	jne    801008b8 <consoleintr+0xe2>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100833:	e9 18 01 00 00       	jmp    80100950 <consoleintr+0x17a>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100838:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010083d:	83 e8 01             	sub    $0x1,%eax
80100840:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
80100845:	83 ec 0c             	sub    $0xc,%esp
80100848:	68 00 01 00 00       	push   $0x100
8010084d:	e8 1c ff ff ff       	call   8010076e <consputc>
80100852:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100855:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
8010085b:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	0f 84 e1 00 00 00    	je     80100949 <consoleintr+0x173>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100868:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	83 e0 7f             	and    $0x7f,%eax
80100873:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
      while(input.e != input.w &&
8010087a:	3c 0a                	cmp    $0xa,%al
8010087c:	75 ba                	jne    80100838 <consoleintr+0x62>
      }
      break;
8010087e:	e9 c6 00 00 00       	jmp    80100949 <consoleintr+0x173>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100883:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100889:	a1 e4 19 19 80       	mov    0x801919e4,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 b6 00 00 00    	je     8010094c <consoleintr+0x176>
        input.e--;
80100896:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 00 01 00 00       	push   $0x100
801008ab:	e8 be fe ff ff       	call   8010076e <consputc>
801008b0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008b3:	e9 94 00 00 00       	jmp    8010094c <consoleintr+0x176>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 8d 00 00 00    	je     8010094f <consoleintr+0x179>
801008c2:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
801008c8:	a1 e0 19 19 80       	mov    0x801919e0,%eax
801008cd:	29 c2                	sub    %eax,%edx
801008cf:	83 fa 7f             	cmp    $0x7f,%edx
801008d2:	77 7b                	ja     8010094f <consoleintr+0x179>
        c = (c == '\r') ? '\n' : c;
801008d4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d8:	74 05                	je     801008df <consoleintr+0x109>
801008da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008dd:	eb 05                	jmp    801008e4 <consoleintr+0x10e>
801008df:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e7:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008ec:	8d 50 01             	lea    0x1(%eax),%edx
801008ef:	89 15 e8 19 19 80    	mov    %edx,0x801919e8
801008f5:	83 e0 7f             	and    $0x7f,%eax
801008f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008fb:	88 90 60 19 19 80    	mov    %dl,-0x7fe6e6a0(%eax)
        consputc(c);
80100901:	83 ec 0c             	sub    $0xc,%esp
80100904:	ff 75 f0             	push   -0x10(%ebp)
80100907:	e8 62 fe ff ff       	call   8010076e <consputc>
8010090c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010090f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100913:	74 18                	je     8010092d <consoleintr+0x157>
80100915:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100919:	74 12                	je     8010092d <consoleintr+0x157>
8010091b:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100921:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100926:	83 e8 80             	sub    $0xffffff80,%eax
80100929:	39 c2                	cmp    %eax,%edx
8010092b:	75 22                	jne    8010094f <consoleintr+0x179>
          input.w = input.e;
8010092d:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100932:	a3 e4 19 19 80       	mov    %eax,0x801919e4
          wakeup(&input.r);
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 e0 19 19 80       	push   $0x801919e0
8010093f:	e8 7c 3a 00 00       	call   801043c0 <wakeup>
80100944:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100947:	eb 06                	jmp    8010094f <consoleintr+0x179>
      break;
80100949:	90                   	nop
8010094a:	eb 04                	jmp    80100950 <consoleintr+0x17a>
      break;
8010094c:	90                   	nop
8010094d:	eb 01                	jmp    80100950 <consoleintr+0x17a>
      break;
8010094f:	90                   	nop
  while((c = getc()) >= 0){
80100950:	8b 45 08             	mov    0x8(%ebp),%eax
80100953:	ff d0                	call   *%eax
80100955:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010095c:	0f 89 96 fe ff ff    	jns    801007f8 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
80100962:	83 ec 0c             	sub    $0xc,%esp
80100965:	68 00 1a 19 80       	push   $0x80191a00
8010096a:	e8 47 40 00 00       	call   801049b6 <release>
8010096f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100976:	74 05                	je     8010097d <consoleintr+0x1a7>
    procdump();  // now call procdump() wo. cons.lock held
80100978:	e8 fe 3a 00 00       	call   8010447b <procdump>
  }
}
8010097d:	90                   	nop
8010097e:	c9                   	leave
8010097f:	c3                   	ret

80100980 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100986:	83 ec 0c             	sub    $0xc,%esp
80100989:	ff 75 08             	push   0x8(%ebp)
8010098c:	e8 74 11 00 00       	call   80101b05 <iunlock>
80100991:	83 c4 10             	add    $0x10,%esp
  target = n;
80100994:	8b 45 10             	mov    0x10(%ebp),%eax
80100997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
8010099a:	83 ec 0c             	sub    $0xc,%esp
8010099d:	68 00 1a 19 80       	push   $0x80191a00
801009a2:	e8 a1 3f 00 00       	call   80104948 <acquire>
801009a7:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009aa:	e9 ab 00 00 00       	jmp    80100a5a <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009af:	e8 7c 30 00 00       	call   80103a30 <myproc>
801009b4:	8b 40 24             	mov    0x24(%eax),%eax
801009b7:	85 c0                	test   %eax,%eax
801009b9:	74 28                	je     801009e3 <consoleread+0x63>
        release(&cons.lock);
801009bb:	83 ec 0c             	sub    $0xc,%esp
801009be:	68 00 1a 19 80       	push   $0x80191a00
801009c3:	e8 ee 3f 00 00       	call   801049b6 <release>
801009c8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	ff 75 08             	push   0x8(%ebp)
801009d1:	e8 1c 10 00 00       	call   801019f2 <ilock>
801009d6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009de:	e9 ab 00 00 00       	jmp    80100a8e <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
801009e3:	83 ec 08             	sub    $0x8,%esp
801009e6:	68 00 1a 19 80       	push   $0x80191a00
801009eb:	68 e0 19 19 80       	push   $0x801919e0
801009f0:	e8 e4 38 00 00       	call   801042d9 <sleep>
801009f5:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
801009f8:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801009fe:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100a03:	39 c2                	cmp    %eax,%edx
80100a05:	74 a8                	je     801009af <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a07:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a0c:	8d 50 01             	lea    0x1(%eax),%edx
80100a0f:	89 15 e0 19 19 80    	mov    %edx,0x801919e0
80100a15:	83 e0 7f             	and    $0x7f,%eax
80100a18:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
80100a1f:	0f be c0             	movsbl %al,%eax
80100a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a25:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a29:	75 17                	jne    80100a42 <consoleread+0xc2>
      if(n < target){
80100a2b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a2e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a31:	73 2f                	jae    80100a62 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a33:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a38:	83 e8 01             	sub    $0x1,%eax
80100a3b:	a3 e0 19 19 80       	mov    %eax,0x801919e0
      }
      break;
80100a40:	eb 20                	jmp    80100a62 <consoleread+0xe2>
    }
    *dst++ = c;
80100a42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a45:	8d 50 01             	lea    0x1(%eax),%edx
80100a48:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a4e:	88 10                	mov    %dl,(%eax)
    --n;
80100a50:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a54:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a58:	74 0b                	je     80100a65 <consoleread+0xe5>
  while(n > 0){
80100a5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a5e:	7f 98                	jg     801009f8 <consoleread+0x78>
80100a60:	eb 04                	jmp    80100a66 <consoleread+0xe6>
      break;
80100a62:	90                   	nop
80100a63:	eb 01                	jmp    80100a66 <consoleread+0xe6>
      break;
80100a65:	90                   	nop
  }
  release(&cons.lock);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	68 00 1a 19 80       	push   $0x80191a00
80100a6e:	e8 43 3f 00 00       	call   801049b6 <release>
80100a73:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	ff 75 08             	push   0x8(%ebp)
80100a7c:	e8 71 0f 00 00       	call   801019f2 <ilock>
80100a81:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a84:	8b 45 10             	mov    0x10(%ebp),%eax
80100a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a8a:	29 c2                	sub    %eax,%edx
80100a8c:	89 d0                	mov    %edx,%eax
}
80100a8e:	c9                   	leave
80100a8f:	c3                   	ret

80100a90 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a96:	83 ec 0c             	sub    $0xc,%esp
80100a99:	ff 75 08             	push   0x8(%ebp)
80100a9c:	e8 64 10 00 00       	call   80101b05 <iunlock>
80100aa1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aa4:	83 ec 0c             	sub    $0xc,%esp
80100aa7:	68 00 1a 19 80       	push   $0x80191a00
80100aac:	e8 97 3e 00 00       	call   80104948 <acquire>
80100ab1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100abb:	eb 21                	jmp    80100ade <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ac3:	01 d0                	add    %edx,%eax
80100ac5:	0f b6 00             	movzbl (%eax),%eax
80100ac8:	0f be c0             	movsbl %al,%eax
80100acb:	0f b6 c0             	movzbl %al,%eax
80100ace:	83 ec 0c             	sub    $0xc,%esp
80100ad1:	50                   	push   %eax
80100ad2:	e8 97 fc ff ff       	call   8010076e <consputc>
80100ad7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ada:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ae1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ae4:	7c d7                	jl     80100abd <consolewrite+0x2d>
  release(&cons.lock);
80100ae6:	83 ec 0c             	sub    $0xc,%esp
80100ae9:	68 00 1a 19 80       	push   $0x80191a00
80100aee:	e8 c3 3e 00 00       	call   801049b6 <release>
80100af3:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	ff 75 08             	push   0x8(%ebp)
80100afc:	e8 f1 0e 00 00       	call   801019f2 <ilock>
80100b01:	83 c4 10             	add    $0x10,%esp

  return n;
80100b04:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b07:	c9                   	leave
80100b08:	c3                   	ret

80100b09 <consoleinit>:

void
consoleinit(void)
{
80100b09:	55                   	push   %ebp
80100b0a:	89 e5                	mov    %esp,%ebp
80100b0c:	83 ec 18             	sub    $0x18,%esp
  panicked = 0;
80100b0f:	c7 05 ec 19 19 80 00 	movl   $0x0,0x801919ec
80100b16:	00 00 00 
  initlock(&cons.lock, "console");
80100b19:	83 ec 08             	sub    $0x8,%esp
80100b1c:	68 77 a2 10 80       	push   $0x8010a277
80100b21:	68 00 1a 19 80       	push   $0x80191a00
80100b26:	e8 fb 3d 00 00       	call   80104926 <initlock>
80100b2b:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b2e:	c7 05 4c 1a 19 80 90 	movl   $0x80100a90,0x80191a4c
80100b35:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b38:	c7 05 48 1a 19 80 80 	movl   $0x80100980,0x80191a48
80100b3f:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b42:	c7 45 f4 7f a2 10 80 	movl   $0x8010a27f,-0xc(%ebp)
80100b49:	eb 19                	jmp    80100b64 <consoleinit+0x5b>
    graphic_putc(*p);
80100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b4e:	0f b6 00             	movzbl (%eax),%eax
80100b51:	0f be c0             	movsbl %al,%eax
80100b54:	83 ec 0c             	sub    $0xc,%esp
80100b57:	50                   	push   %eax
80100b58:	e8 e1 fa ff ff       	call   8010063e <graphic_putc>
80100b5d:	83 c4 10             	add    $0x10,%esp
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b67:	0f b6 00             	movzbl (%eax),%eax
80100b6a:	84 c0                	test   %al,%al
80100b6c:	75 dd                	jne    80100b4b <consoleinit+0x42>
  
  cons.locking = 1;
80100b6e:	c7 05 34 1a 19 80 01 	movl   $0x1,0x80191a34
80100b75:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b78:	83 ec 08             	sub    $0x8,%esp
80100b7b:	6a 00                	push   $0x0
80100b7d:	6a 01                	push   $0x1
80100b7f:	e8 b2 1a 00 00       	call   80102636 <ioapicenable>
80100b84:	83 c4 10             	add    $0x10,%esp
}
80100b87:	90                   	nop
80100b88:	c9                   	leave
80100b89:	c3                   	ret

80100b8a <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b8a:	55                   	push   %ebp
80100b8b:	89 e5                	mov    %esp,%ebp
80100b8d:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b93:	e8 98 2e 00 00       	call   80103a30 <myproc>
80100b98:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b9b:	e8 9e 24 00 00       	call   8010303e <begin_op>

  if((ip = namei(path)) == 0){
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	ff 75 08             	push   0x8(%ebp)
80100ba6:	e8 7a 19 00 00       	call   80102525 <namei>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bb5:	75 1f                	jne    80100bd6 <exec+0x4c>
    end_op();
80100bb7:	e8 0e 25 00 00       	call   801030ca <end_op>
    cprintf("exec: fail\n");
80100bbc:	83 ec 0c             	sub    $0xc,%esp
80100bbf:	68 95 a2 10 80       	push   $0x8010a295
80100bc4:	e8 2b f8 ff ff       	call   801003f4 <cprintf>
80100bc9:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd1:	e9 f1 03 00 00       	jmp    80100fc7 <exec+0x43d>
  }
  ilock(ip);
80100bd6:	83 ec 0c             	sub    $0xc,%esp
80100bd9:	ff 75 d8             	push   -0x28(%ebp)
80100bdc:	e8 11 0e 00 00       	call   801019f2 <ilock>
80100be1:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100be4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100beb:	6a 34                	push   $0x34
80100bed:	6a 00                	push   $0x0
80100bef:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100bf5:	50                   	push   %eax
80100bf6:	ff 75 d8             	push   -0x28(%ebp)
80100bf9:	e8 e0 12 00 00       	call   80101ede <readi>
80100bfe:	83 c4 10             	add    $0x10,%esp
80100c01:	83 f8 34             	cmp    $0x34,%eax
80100c04:	0f 85 66 03 00 00    	jne    80100f70 <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c0a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c10:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c15:	0f 85 58 03 00 00    	jne    80100f73 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c1b:	e8 e8 68 00 00       	call   80107508 <setupkvm>
80100c20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c23:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c27:	0f 84 49 03 00 00    	je     80100f76 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c34:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c3b:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c41:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c44:	e9 de 00 00 00       	jmp    80100d27 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c4c:	6a 20                	push   $0x20
80100c4e:	50                   	push   %eax
80100c4f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c55:	50                   	push   %eax
80100c56:	ff 75 d8             	push   -0x28(%ebp)
80100c59:	e8 80 12 00 00       	call   80101ede <readi>
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	83 f8 20             	cmp    $0x20,%eax
80100c64:	0f 85 0f 03 00 00    	jne    80100f79 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c6a:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c70:	83 f8 01             	cmp    $0x1,%eax
80100c73:	0f 85 a0 00 00 00    	jne    80100d19 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c79:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c7f:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c85:	39 c2                	cmp    %eax,%edx
80100c87:	0f 82 ef 02 00 00    	jb     80100f7c <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c8d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c93:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c99:	01 c2                	add    %eax,%edx
80100c9b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ca1:	39 c2                	cmp    %eax,%edx
80100ca3:	0f 82 d6 02 00 00    	jb     80100f7f <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ca9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100caf:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cb5:	01 d0                	add    %edx,%eax
80100cb7:	83 ec 04             	sub    $0x4,%esp
80100cba:	50                   	push   %eax
80100cbb:	ff 75 e0             	push   -0x20(%ebp)
80100cbe:	ff 75 d4             	push   -0x2c(%ebp)
80100cc1:	e8 3c 6c 00 00       	call   80107902 <allocuvm>
80100cc6:	83 c4 10             	add    $0x10,%esp
80100cc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ccc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cd0:	0f 84 ac 02 00 00    	je     80100f82 <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100cd6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cdc:	25 ff 0f 00 00       	and    $0xfff,%eax
80100ce1:	85 c0                	test   %eax,%eax
80100ce3:	0f 85 9c 02 00 00    	jne    80100f85 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce9:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100cef:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cf5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	52                   	push   %edx
80100cff:	50                   	push   %eax
80100d00:	ff 75 d8             	push   -0x28(%ebp)
80100d03:	51                   	push   %ecx
80100d04:	ff 75 d4             	push   -0x2c(%ebp)
80100d07:	e8 29 6b 00 00       	call   80107835 <loaduvm>
80100d0c:	83 c4 20             	add    $0x20,%esp
80100d0f:	85 c0                	test   %eax,%eax
80100d11:	0f 88 71 02 00 00    	js     80100f88 <exec+0x3fe>
80100d17:	eb 01                	jmp    80100d1a <exec+0x190>
      continue;
80100d19:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d1a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d21:	83 c0 20             	add    $0x20,%eax
80100d24:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d27:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d2e:	0f b7 c0             	movzwl %ax,%eax
80100d31:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d34:	0f 8c 0f ff ff ff    	jl     80100c49 <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	ff 75 d8             	push   -0x28(%ebp)
80100d40:	e8 de 0e 00 00       	call   80101c23 <iunlockput>
80100d45:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d48:	e8 7d 23 00 00       	call   801030ca <end_op>
  ip = 0;
80100d4d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d57:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d67:	05 00 20 00 00       	add    $0x2000,%eax
80100d6c:	83 ec 04             	sub    $0x4,%esp
80100d6f:	50                   	push   %eax
80100d70:	ff 75 e0             	push   -0x20(%ebp)
80100d73:	ff 75 d4             	push   -0x2c(%ebp)
80100d76:	e8 87 6b 00 00       	call   80107902 <allocuvm>
80100d7b:	83 c4 10             	add    $0x10,%esp
80100d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d85:	0f 84 00 02 00 00    	je     80100f8b <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d8e:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d93:	83 ec 08             	sub    $0x8,%esp
80100d96:	50                   	push   %eax
80100d97:	ff 75 d4             	push   -0x2c(%ebp)
80100d9a:	e8 c5 6d 00 00       	call   80107b64 <clearpteu>
80100d9f:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100da8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100daf:	e9 96 00 00 00       	jmp    80100e4a <exec+0x2c0>
    if(argc >= MAXARG)
80100db4:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100db8:	0f 87 d0 01 00 00    	ja     80100f8e <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcb:	01 d0                	add    %edx,%eax
80100dcd:	8b 00                	mov    (%eax),%eax
80100dcf:	83 ec 0c             	sub    $0xc,%esp
80100dd2:	50                   	push   %eax
80100dd3:	e8 34 40 00 00       	call   80104e0c <strlen>
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	89 c2                	mov    %eax,%edx
80100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de0:	29 d0                	sub    %edx,%eax
80100de2:	83 e8 01             	sub    $0x1,%eax
80100de5:	83 e0 fc             	and    $0xfffffffc,%eax
80100de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df8:	01 d0                	add    %edx,%eax
80100dfa:	8b 00                	mov    (%eax),%eax
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	50                   	push   %eax
80100e00:	e8 07 40 00 00       	call   80104e0c <strlen>
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	83 c0 01             	add    $0x1,%eax
80100e0b:	89 c1                	mov    %eax,%ecx
80100e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e1a:	01 d0                	add    %edx,%eax
80100e1c:	8b 00                	mov    (%eax),%eax
80100e1e:	51                   	push   %ecx
80100e1f:	50                   	push   %eax
80100e20:	ff 75 dc             	push   -0x24(%ebp)
80100e23:	ff 75 d4             	push   -0x2c(%ebp)
80100e26:	e8 d8 6e 00 00       	call   80107d03 <copyout>
80100e2b:	83 c4 10             	add    $0x10,%esp
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	0f 88 5b 01 00 00    	js     80100f91 <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e39:	8d 50 03             	lea    0x3(%eax),%edx
80100e3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e3f:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e46:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e57:	01 d0                	add    %edx,%eax
80100e59:	8b 00                	mov    (%eax),%eax
80100e5b:	85 c0                	test   %eax,%eax
80100e5d:	0f 85 51 ff ff ff    	jne    80100db4 <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e66:	83 c0 03             	add    $0x3,%eax
80100e69:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e70:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e74:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e7b:	ff ff ff 
  ustack[1] = argc;
80100e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e81:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8a:	83 c0 01             	add    $0x1,%eax
80100e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e97:	29 d0                	sub    %edx,%eax
80100e99:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea2:	83 c0 04             	add    $0x4,%eax
80100ea5:	c1 e0 02             	shl    $0x2,%eax
80100ea8:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eae:	83 c0 04             	add    $0x4,%eax
80100eb1:	c1 e0 02             	shl    $0x2,%eax
80100eb4:	50                   	push   %eax
80100eb5:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ebb:	50                   	push   %eax
80100ebc:	ff 75 dc             	push   -0x24(%ebp)
80100ebf:	ff 75 d4             	push   -0x2c(%ebp)
80100ec2:	e8 3c 6e 00 00       	call   80107d03 <copyout>
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	0f 88 c2 00 00 00    	js     80100f94 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ede:	eb 17                	jmp    80100ef7 <exec+0x36d>
    if(*s == '/')
80100ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee3:	0f b6 00             	movzbl (%eax),%eax
80100ee6:	3c 2f                	cmp    $0x2f,%al
80100ee8:	75 09                	jne    80100ef3 <exec+0x369>
      last = s+1;
80100eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eed:	83 c0 01             	add    $0x1,%eax
80100ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ef3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efa:	0f b6 00             	movzbl (%eax),%eax
80100efd:	84 c0                	test   %al,%al
80100eff:	75 df                	jne    80100ee0 <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f04:	83 c0 6c             	add    $0x6c,%eax
80100f07:	83 ec 04             	sub    $0x4,%esp
80100f0a:	6a 10                	push   $0x10
80100f0c:	ff 75 f0             	push   -0x10(%ebp)
80100f0f:	50                   	push   %eax
80100f10:	e8 ac 3e 00 00       	call   80104dc1 <safestrcpy>
80100f15:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f18:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f1b:	8b 40 04             	mov    0x4(%eax),%eax
80100f1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f21:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f27:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f30:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f32:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f35:	8b 40 18             	mov    0x18(%eax),%eax
80100f38:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f3e:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f44:	8b 40 18             	mov    0x18(%eax),%eax
80100f47:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f4a:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 d0             	push   -0x30(%ebp)
80100f53:	e8 ce 66 00 00       	call   80107626 <switchuvm>
80100f58:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 cc             	push   -0x34(%ebp)
80100f61:	e8 65 6b 00 00       	call   80107acb <freevm>
80100f66:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f69:	b8 00 00 00 00       	mov    $0x0,%eax
80100f6e:	eb 57                	jmp    80100fc7 <exec+0x43d>
    goto bad;
80100f70:	90                   	nop
80100f71:	eb 22                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f73:	90                   	nop
80100f74:	eb 1f                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f76:	90                   	nop
80100f77:	eb 1c                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f79:	90                   	nop
80100f7a:	eb 19                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f7c:	90                   	nop
80100f7d:	eb 16                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f7f:	90                   	nop
80100f80:	eb 13                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f82:	90                   	nop
80100f83:	eb 10                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f85:	90                   	nop
80100f86:	eb 0d                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f88:	90                   	nop
80100f89:	eb 0a                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f8b:	90                   	nop
80100f8c:	eb 07                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f8e:	90                   	nop
80100f8f:	eb 04                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f91:	90                   	nop
80100f92:	eb 01                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f94:	90                   	nop

 bad:
  if(pgdir)
80100f95:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f99:	74 0e                	je     80100fa9 <exec+0x41f>
    freevm(pgdir);
80100f9b:	83 ec 0c             	sub    $0xc,%esp
80100f9e:	ff 75 d4             	push   -0x2c(%ebp)
80100fa1:	e8 25 6b 00 00       	call   80107acb <freevm>
80100fa6:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fa9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fad:	74 13                	je     80100fc2 <exec+0x438>
    iunlockput(ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 75 d8             	push   -0x28(%ebp)
80100fb5:	e8 69 0c 00 00       	call   80101c23 <iunlockput>
80100fba:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fbd:	e8 08 21 00 00       	call   801030ca <end_op>
  }
  return -1;
80100fc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fc7:	c9                   	leave
80100fc8:	c3                   	ret

80100fc9 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fc9:	55                   	push   %ebp
80100fca:	89 e5                	mov    %esp,%ebp
80100fcc:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fcf:	83 ec 08             	sub    $0x8,%esp
80100fd2:	68 a1 a2 10 80       	push   $0x8010a2a1
80100fd7:	68 a0 1a 19 80       	push   $0x80191aa0
80100fdc:	e8 45 39 00 00       	call   80104926 <initlock>
80100fe1:	83 c4 10             	add    $0x10,%esp
}
80100fe4:	90                   	nop
80100fe5:	c9                   	leave
80100fe6:	c3                   	ret

80100fe7 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fe7:	55                   	push   %ebp
80100fe8:	89 e5                	mov    %esp,%ebp
80100fea:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	68 a0 1a 19 80       	push   $0x80191aa0
80100ff5:	e8 4e 39 00 00       	call   80104948 <acquire>
80100ffa:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ffd:	c7 45 f4 d4 1a 19 80 	movl   $0x80191ad4,-0xc(%ebp)
80101004:	eb 2d                	jmp    80101033 <filealloc+0x4c>
    if(f->ref == 0){
80101006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101009:	8b 40 04             	mov    0x4(%eax),%eax
8010100c:	85 c0                	test   %eax,%eax
8010100e:	75 1f                	jne    8010102f <filealloc+0x48>
      f->ref = 1;
80101010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101013:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010101a:	83 ec 0c             	sub    $0xc,%esp
8010101d:	68 a0 1a 19 80       	push   $0x80191aa0
80101022:	e8 8f 39 00 00       	call   801049b6 <release>
80101027:	83 c4 10             	add    $0x10,%esp
      return f;
8010102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010102d:	eb 23                	jmp    80101052 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010102f:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101033:	b8 34 24 19 80       	mov    $0x80192434,%eax
80101038:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010103b:	72 c9                	jb     80101006 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
8010103d:	83 ec 0c             	sub    $0xc,%esp
80101040:	68 a0 1a 19 80       	push   $0x80191aa0
80101045:	e8 6c 39 00 00       	call   801049b6 <release>
8010104a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010104d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101052:	c9                   	leave
80101053:	c3                   	ret

80101054 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101054:	55                   	push   %ebp
80101055:	89 e5                	mov    %esp,%ebp
80101057:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	68 a0 1a 19 80       	push   $0x80191aa0
80101062:	e8 e1 38 00 00       	call   80104948 <acquire>
80101067:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010106a:	8b 45 08             	mov    0x8(%ebp),%eax
8010106d:	8b 40 04             	mov    0x4(%eax),%eax
80101070:	85 c0                	test   %eax,%eax
80101072:	7f 0d                	jg     80101081 <filedup+0x2d>
    panic("filedup");
80101074:	83 ec 0c             	sub    $0xc,%esp
80101077:	68 a8 a2 10 80       	push   $0x8010a2a8
8010107c:	e8 28 f5 ff ff       	call   801005a9 <panic>
  f->ref++;
80101081:	8b 45 08             	mov    0x8(%ebp),%eax
80101084:	8b 40 04             	mov    0x4(%eax),%eax
80101087:	8d 50 01             	lea    0x1(%eax),%edx
8010108a:	8b 45 08             	mov    0x8(%ebp),%eax
8010108d:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101090:	83 ec 0c             	sub    $0xc,%esp
80101093:	68 a0 1a 19 80       	push   $0x80191aa0
80101098:	e8 19 39 00 00       	call   801049b6 <release>
8010109d:	83 c4 10             	add    $0x10,%esp
  return f;
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010a3:	c9                   	leave
801010a4:	c3                   	ret

801010a5 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010a5:	55                   	push   %ebp
801010a6:	89 e5                	mov    %esp,%ebp
801010a8:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	68 a0 1a 19 80       	push   $0x80191aa0
801010b3:	e8 90 38 00 00       	call   80104948 <acquire>
801010b8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bb:	8b 45 08             	mov    0x8(%ebp),%eax
801010be:	8b 40 04             	mov    0x4(%eax),%eax
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7f 0d                	jg     801010d2 <fileclose+0x2d>
    panic("fileclose");
801010c5:	83 ec 0c             	sub    $0xc,%esp
801010c8:	68 b0 a2 10 80       	push   $0x8010a2b0
801010cd:	e8 d7 f4 ff ff       	call   801005a9 <panic>
  if(--f->ref > 0){
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	8b 40 04             	mov    0x4(%eax),%eax
801010d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	89 50 04             	mov    %edx,0x4(%eax)
801010e1:	8b 45 08             	mov    0x8(%ebp),%eax
801010e4:	8b 40 04             	mov    0x4(%eax),%eax
801010e7:	85 c0                	test   %eax,%eax
801010e9:	7e 15                	jle    80101100 <fileclose+0x5b>
    release(&ftable.lock);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	68 a0 1a 19 80       	push   $0x80191aa0
801010f3:	e8 be 38 00 00       	call   801049b6 <release>
801010f8:	83 c4 10             	add    $0x10,%esp
801010fb:	e9 8b 00 00 00       	jmp    8010118b <fileclose+0xe6>
    return;
  }
  ff = *f;
80101100:	8b 45 08             	mov    0x8(%ebp),%eax
80101103:	8b 10                	mov    (%eax),%edx
80101105:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101108:	8b 50 04             	mov    0x4(%eax),%edx
8010110b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010110e:	8b 50 08             	mov    0x8(%eax),%edx
80101111:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101114:	8b 50 0c             	mov    0xc(%eax),%edx
80101117:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010111a:	8b 50 10             	mov    0x10(%eax),%edx
8010111d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101120:	8b 40 14             	mov    0x14(%eax),%eax
80101123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101130:	8b 45 08             	mov    0x8(%ebp),%eax
80101133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101139:	83 ec 0c             	sub    $0xc,%esp
8010113c:	68 a0 1a 19 80       	push   $0x80191aa0
80101141:	e8 70 38 00 00       	call   801049b6 <release>
80101146:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101149:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010114c:	83 f8 01             	cmp    $0x1,%eax
8010114f:	75 19                	jne    8010116a <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101151:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101155:	0f be d0             	movsbl %al,%edx
80101158:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010115b:	83 ec 08             	sub    $0x8,%esp
8010115e:	52                   	push   %edx
8010115f:	50                   	push   %eax
80101160:	e8 5a 25 00 00       	call   801036bf <pipeclose>
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	eb 21                	jmp    8010118b <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010116a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010116d:	83 f8 02             	cmp    $0x2,%eax
80101170:	75 19                	jne    8010118b <fileclose+0xe6>
    begin_op();
80101172:	e8 c7 1e 00 00       	call   8010303e <begin_op>
    iput(ff.ip);
80101177:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	50                   	push   %eax
8010117e:	e8 d0 09 00 00       	call   80101b53 <iput>
80101183:	83 c4 10             	add    $0x10,%esp
    end_op();
80101186:	e8 3f 1f 00 00       	call   801030ca <end_op>
  }
}
8010118b:	c9                   	leave
8010118c:	c3                   	ret

8010118d <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010118d:	55                   	push   %ebp
8010118e:	89 e5                	mov    %esp,%ebp
80101190:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	8b 00                	mov    (%eax),%eax
80101198:	83 f8 02             	cmp    $0x2,%eax
8010119b:	75 40                	jne    801011dd <filestat+0x50>
    ilock(f->ip);
8010119d:	8b 45 08             	mov    0x8(%ebp),%eax
801011a0:	8b 40 10             	mov    0x10(%eax),%eax
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	50                   	push   %eax
801011a7:	e8 46 08 00 00       	call   801019f2 <ilock>
801011ac:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011af:	8b 45 08             	mov    0x8(%ebp),%eax
801011b2:	8b 40 10             	mov    0x10(%eax),%eax
801011b5:	83 ec 08             	sub    $0x8,%esp
801011b8:	ff 75 0c             	push   0xc(%ebp)
801011bb:	50                   	push   %eax
801011bc:	e8 d7 0c 00 00       	call   80101e98 <stati>
801011c1:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011c4:	8b 45 08             	mov    0x8(%ebp),%eax
801011c7:	8b 40 10             	mov    0x10(%eax),%eax
801011ca:	83 ec 0c             	sub    $0xc,%esp
801011cd:	50                   	push   %eax
801011ce:	e8 32 09 00 00       	call   80101b05 <iunlock>
801011d3:	83 c4 10             	add    $0x10,%esp
    return 0;
801011d6:	b8 00 00 00 00       	mov    $0x0,%eax
801011db:	eb 05                	jmp    801011e2 <filestat+0x55>
  }
  return -1;
801011dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011e2:	c9                   	leave
801011e3:	c3                   	ret

801011e4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011e4:	55                   	push   %ebp
801011e5:	89 e5                	mov    %esp,%ebp
801011e7:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011ea:	8b 45 08             	mov    0x8(%ebp),%eax
801011ed:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011f1:	84 c0                	test   %al,%al
801011f3:	75 0a                	jne    801011ff <fileread+0x1b>
    return -1;
801011f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011fa:	e9 9b 00 00 00       	jmp    8010129a <fileread+0xb6>
  if(f->type == FD_PIPE)
801011ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101202:	8b 00                	mov    (%eax),%eax
80101204:	83 f8 01             	cmp    $0x1,%eax
80101207:	75 1a                	jne    80101223 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101209:	8b 45 08             	mov    0x8(%ebp),%eax
8010120c:	8b 40 0c             	mov    0xc(%eax),%eax
8010120f:	83 ec 04             	sub    $0x4,%esp
80101212:	ff 75 10             	push   0x10(%ebp)
80101215:	ff 75 0c             	push   0xc(%ebp)
80101218:	50                   	push   %eax
80101219:	e8 4e 26 00 00       	call   8010386c <piperead>
8010121e:	83 c4 10             	add    $0x10,%esp
80101221:	eb 77                	jmp    8010129a <fileread+0xb6>
  if(f->type == FD_INODE){
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 00                	mov    (%eax),%eax
80101228:	83 f8 02             	cmp    $0x2,%eax
8010122b:	75 60                	jne    8010128d <fileread+0xa9>
    ilock(f->ip);
8010122d:	8b 45 08             	mov    0x8(%ebp),%eax
80101230:	8b 40 10             	mov    0x10(%eax),%eax
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	50                   	push   %eax
80101237:	e8 b6 07 00 00       	call   801019f2 <ilock>
8010123c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010123f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101242:	8b 45 08             	mov    0x8(%ebp),%eax
80101245:	8b 50 14             	mov    0x14(%eax),%edx
80101248:	8b 45 08             	mov    0x8(%ebp),%eax
8010124b:	8b 40 10             	mov    0x10(%eax),%eax
8010124e:	51                   	push   %ecx
8010124f:	52                   	push   %edx
80101250:	ff 75 0c             	push   0xc(%ebp)
80101253:	50                   	push   %eax
80101254:	e8 85 0c 00 00       	call   80101ede <readi>
80101259:	83 c4 10             	add    $0x10,%esp
8010125c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010125f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101263:	7e 11                	jle    80101276 <fileread+0x92>
      f->off += r;
80101265:	8b 45 08             	mov    0x8(%ebp),%eax
80101268:	8b 50 14             	mov    0x14(%eax),%edx
8010126b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010126e:	01 c2                	add    %eax,%edx
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101276:	8b 45 08             	mov    0x8(%ebp),%eax
80101279:	8b 40 10             	mov    0x10(%eax),%eax
8010127c:	83 ec 0c             	sub    $0xc,%esp
8010127f:	50                   	push   %eax
80101280:	e8 80 08 00 00       	call   80101b05 <iunlock>
80101285:	83 c4 10             	add    $0x10,%esp
    return r;
80101288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128b:	eb 0d                	jmp    8010129a <fileread+0xb6>
  }
  panic("fileread");
8010128d:	83 ec 0c             	sub    $0xc,%esp
80101290:	68 ba a2 10 80       	push   $0x8010a2ba
80101295:	e8 0f f3 ff ff       	call   801005a9 <panic>
}
8010129a:	c9                   	leave
8010129b:	c3                   	ret

8010129c <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010129c:	55                   	push   %ebp
8010129d:	89 e5                	mov    %esp,%ebp
8010129f:	53                   	push   %ebx
801012a0:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012a3:	8b 45 08             	mov    0x8(%ebp),%eax
801012a6:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012aa:	84 c0                	test   %al,%al
801012ac:	75 0a                	jne    801012b8 <filewrite+0x1c>
    return -1;
801012ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012b3:	e9 1b 01 00 00       	jmp    801013d3 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012b8:	8b 45 08             	mov    0x8(%ebp),%eax
801012bb:	8b 00                	mov    (%eax),%eax
801012bd:	83 f8 01             	cmp    $0x1,%eax
801012c0:	75 1d                	jne    801012df <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 40 0c             	mov    0xc(%eax),%eax
801012c8:	83 ec 04             	sub    $0x4,%esp
801012cb:	ff 75 10             	push   0x10(%ebp)
801012ce:	ff 75 0c             	push   0xc(%ebp)
801012d1:	50                   	push   %eax
801012d2:	e8 93 24 00 00       	call   8010376a <pipewrite>
801012d7:	83 c4 10             	add    $0x10,%esp
801012da:	e9 f4 00 00 00       	jmp    801013d3 <filewrite+0x137>
  if(f->type == FD_INODE){
801012df:	8b 45 08             	mov    0x8(%ebp),%eax
801012e2:	8b 00                	mov    (%eax),%eax
801012e4:	83 f8 02             	cmp    $0x2,%eax
801012e7:	0f 85 d9 00 00 00    	jne    801013c6 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012ed:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801012f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012fb:	e9 a3 00 00 00       	jmp    801013a3 <filewrite+0x107>
      int n1 = n - i;
80101300:	8b 45 10             	mov    0x10(%ebp),%eax
80101303:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101306:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101309:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010130c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010130f:	7e 06                	jle    80101317 <filewrite+0x7b>
        n1 = max;
80101311:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101314:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101317:	e8 22 1d 00 00       	call   8010303e <begin_op>
      ilock(f->ip);
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 40 10             	mov    0x10(%eax),%eax
80101322:	83 ec 0c             	sub    $0xc,%esp
80101325:	50                   	push   %eax
80101326:	e8 c7 06 00 00       	call   801019f2 <ilock>
8010132b:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010132e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101331:	8b 45 08             	mov    0x8(%ebp),%eax
80101334:	8b 50 14             	mov    0x14(%eax),%edx
80101337:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010133a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133d:	01 c3                	add    %eax,%ebx
8010133f:	8b 45 08             	mov    0x8(%ebp),%eax
80101342:	8b 40 10             	mov    0x10(%eax),%eax
80101345:	51                   	push   %ecx
80101346:	52                   	push   %edx
80101347:	53                   	push   %ebx
80101348:	50                   	push   %eax
80101349:	e8 e5 0c 00 00       	call   80102033 <writei>
8010134e:	83 c4 10             	add    $0x10,%esp
80101351:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101354:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101358:	7e 11                	jle    8010136b <filewrite+0xcf>
        f->off += r;
8010135a:	8b 45 08             	mov    0x8(%ebp),%eax
8010135d:	8b 50 14             	mov    0x14(%eax),%edx
80101360:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101363:	01 c2                	add    %eax,%edx
80101365:	8b 45 08             	mov    0x8(%ebp),%eax
80101368:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	8b 40 10             	mov    0x10(%eax),%eax
80101371:	83 ec 0c             	sub    $0xc,%esp
80101374:	50                   	push   %eax
80101375:	e8 8b 07 00 00       	call   80101b05 <iunlock>
8010137a:	83 c4 10             	add    $0x10,%esp
      end_op();
8010137d:	e8 48 1d 00 00       	call   801030ca <end_op>

      if(r < 0)
80101382:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101386:	78 29                	js     801013b1 <filewrite+0x115>
        break;
      if(r != n1)
80101388:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010138b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010138e:	74 0d                	je     8010139d <filewrite+0x101>
        panic("short filewrite");
80101390:	83 ec 0c             	sub    $0xc,%esp
80101393:	68 c3 a2 10 80       	push   $0x8010a2c3
80101398:	e8 0c f2 ff ff       	call   801005a9 <panic>
      i += r;
8010139d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013a0:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a6:	3b 45 10             	cmp    0x10(%ebp),%eax
801013a9:	0f 8c 51 ff ff ff    	jl     80101300 <filewrite+0x64>
801013af:	eb 01                	jmp    801013b2 <filewrite+0x116>
        break;
801013b1:	90                   	nop
    }
    return i == n ? n : -1;
801013b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b8:	75 05                	jne    801013bf <filewrite+0x123>
801013ba:	8b 45 10             	mov    0x10(%ebp),%eax
801013bd:	eb 14                	jmp    801013d3 <filewrite+0x137>
801013bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013c4:	eb 0d                	jmp    801013d3 <filewrite+0x137>
  }
  panic("filewrite");
801013c6:	83 ec 0c             	sub    $0xc,%esp
801013c9:	68 d3 a2 10 80       	push   $0x8010a2d3
801013ce:	e8 d6 f1 ff ff       	call   801005a9 <panic>
}
801013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013d6:	c9                   	leave
801013d7:	c3                   	ret

801013d8 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d8:	55                   	push   %ebp
801013d9:	89 e5                	mov    %esp,%ebp
801013db:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013de:	8b 45 08             	mov    0x8(%ebp),%eax
801013e1:	83 ec 08             	sub    $0x8,%esp
801013e4:	6a 01                	push   $0x1
801013e6:	50                   	push   %eax
801013e7:	e8 15 ee ff ff       	call   80100201 <bread>
801013ec:	83 c4 10             	add    $0x10,%esp
801013ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f5:	83 c0 5c             	add    $0x5c,%eax
801013f8:	83 ec 04             	sub    $0x4,%esp
801013fb:	6a 1c                	push   $0x1c
801013fd:	50                   	push   %eax
801013fe:	ff 75 0c             	push   0xc(%ebp)
80101401:	e8 77 38 00 00       	call   80104c7d <memmove>
80101406:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101409:	83 ec 0c             	sub    $0xc,%esp
8010140c:	ff 75 f4             	push   -0xc(%ebp)
8010140f:	e8 6f ee ff ff       	call   80100283 <brelse>
80101414:	83 c4 10             	add    $0x10,%esp
}
80101417:	90                   	nop
80101418:	c9                   	leave
80101419:	c3                   	ret

8010141a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010141a:	55                   	push   %ebp
8010141b:	89 e5                	mov    %esp,%ebp
8010141d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101420:	8b 55 0c             	mov    0xc(%ebp),%edx
80101423:	8b 45 08             	mov    0x8(%ebp),%eax
80101426:	83 ec 08             	sub    $0x8,%esp
80101429:	52                   	push   %edx
8010142a:	50                   	push   %eax
8010142b:	e8 d1 ed ff ff       	call   80100201 <bread>
80101430:	83 c4 10             	add    $0x10,%esp
80101433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101439:	83 c0 5c             	add    $0x5c,%eax
8010143c:	83 ec 04             	sub    $0x4,%esp
8010143f:	68 00 02 00 00       	push   $0x200
80101444:	6a 00                	push   $0x0
80101446:	50                   	push   %eax
80101447:	e8 72 37 00 00       	call   80104bbe <memset>
8010144c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	ff 75 f4             	push   -0xc(%ebp)
80101455:	e8 1d 1e 00 00       	call   80103277 <log_write>
8010145a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010145d:	83 ec 0c             	sub    $0xc,%esp
80101460:	ff 75 f4             	push   -0xc(%ebp)
80101463:	e8 1b ee ff ff       	call   80100283 <brelse>
80101468:	83 c4 10             	add    $0x10,%esp
}
8010146b:	90                   	nop
8010146c:	c9                   	leave
8010146d:	c3                   	ret

8010146e <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010146e:	55                   	push   %ebp
8010146f:	89 e5                	mov    %esp,%ebp
80101471:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101474:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010147b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101482:	e9 0b 01 00 00       	jmp    80101592 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
80101487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101490:	85 c0                	test   %eax,%eax
80101492:	0f 48 c2             	cmovs  %edx,%eax
80101495:	c1 f8 0c             	sar    $0xc,%eax
80101498:	89 c2                	mov    %eax,%edx
8010149a:	a1 58 24 19 80       	mov    0x80192458,%eax
8010149f:	01 d0                	add    %edx,%eax
801014a1:	83 ec 08             	sub    $0x8,%esp
801014a4:	50                   	push   %eax
801014a5:	ff 75 08             	push   0x8(%ebp)
801014a8:	e8 54 ed ff ff       	call   80100201 <bread>
801014ad:	83 c4 10             	add    $0x10,%esp
801014b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014ba:	e9 9e 00 00 00       	jmp    8010155d <balloc+0xef>
      m = 1 << (bi % 8);
801014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c2:	83 e0 07             	and    $0x7,%eax
801014c5:	ba 01 00 00 00       	mov    $0x1,%edx
801014ca:	89 c1                	mov    %eax,%ecx
801014cc:	d3 e2                	shl    %cl,%edx
801014ce:	89 d0                	mov    %edx,%eax
801014d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d6:	8d 50 07             	lea    0x7(%eax),%edx
801014d9:	85 c0                	test   %eax,%eax
801014db:	0f 48 c2             	cmovs  %edx,%eax
801014de:	c1 f8 03             	sar    $0x3,%eax
801014e1:	89 c2                	mov    %eax,%edx
801014e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014e6:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014eb:	0f b6 c0             	movzbl %al,%eax
801014ee:	23 45 e8             	and    -0x18(%ebp),%eax
801014f1:	85 c0                	test   %eax,%eax
801014f3:	75 64                	jne    80101559 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
801014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f8:	8d 50 07             	lea    0x7(%eax),%edx
801014fb:	85 c0                	test   %eax,%eax
801014fd:	0f 48 c2             	cmovs  %edx,%eax
80101500:	c1 f8 03             	sar    $0x3,%eax
80101503:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101506:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010150b:	89 d1                	mov    %edx,%ecx
8010150d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101510:	09 ca                	or     %ecx,%edx
80101512:	89 d1                	mov    %edx,%ecx
80101514:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101517:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010151b:	83 ec 0c             	sub    $0xc,%esp
8010151e:	ff 75 ec             	push   -0x14(%ebp)
80101521:	e8 51 1d 00 00       	call   80103277 <log_write>
80101526:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101529:	83 ec 0c             	sub    $0xc,%esp
8010152c:	ff 75 ec             	push   -0x14(%ebp)
8010152f:	e8 4f ed ff ff       	call   80100283 <brelse>
80101534:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101537:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153d:	01 c2                	add    %eax,%edx
8010153f:	8b 45 08             	mov    0x8(%ebp),%eax
80101542:	83 ec 08             	sub    $0x8,%esp
80101545:	52                   	push   %edx
80101546:	50                   	push   %eax
80101547:	e8 ce fe ff ff       	call   8010141a <bzero>
8010154c:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	01 d0                	add    %edx,%eax
80101557:	eb 56                	jmp    801015af <balloc+0x141>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101559:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010155d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101564:	7f 17                	jg     8010157d <balloc+0x10f>
80101566:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101569:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156c:	01 d0                	add    %edx,%eax
8010156e:	89 c2                	mov    %eax,%edx
80101570:	a1 40 24 19 80       	mov    0x80192440,%eax
80101575:	39 c2                	cmp    %eax,%edx
80101577:	0f 82 42 ff ff ff    	jb     801014bf <balloc+0x51>
      }
    }
    brelse(bp);
8010157d:	83 ec 0c             	sub    $0xc,%esp
80101580:	ff 75 ec             	push   -0x14(%ebp)
80101583:	e8 fb ec ff ff       	call   80100283 <brelse>
80101588:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010158b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101592:	a1 40 24 19 80       	mov    0x80192440,%eax
80101597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159a:	39 c2                	cmp    %eax,%edx
8010159c:	0f 82 e5 fe ff ff    	jb     80101487 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 e0 a2 10 80       	push   $0x8010a2e0
801015aa:	e8 fa ef ff ff       	call   801005a9 <panic>
}
801015af:	c9                   	leave
801015b0:	c3                   	ret

801015b1 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015b1:	55                   	push   %ebp
801015b2:	89 e5                	mov    %esp,%ebp
801015b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015b7:	83 ec 08             	sub    $0x8,%esp
801015ba:	68 40 24 19 80       	push   $0x80192440
801015bf:	ff 75 08             	push   0x8(%ebp)
801015c2:	e8 11 fe ff ff       	call   801013d8 <readsb>
801015c7:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801015cd:	c1 e8 0c             	shr    $0xc,%eax
801015d0:	89 c2                	mov    %eax,%edx
801015d2:	a1 58 24 19 80       	mov    0x80192458,%eax
801015d7:	01 c2                	add    %eax,%edx
801015d9:	8b 45 08             	mov    0x8(%ebp),%eax
801015dc:	83 ec 08             	sub    $0x8,%esp
801015df:	52                   	push   %edx
801015e0:	50                   	push   %eax
801015e1:	e8 1b ec ff ff       	call   80100201 <bread>
801015e6:	83 c4 10             	add    $0x10,%esp
801015e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801015ef:	25 ff 0f 00 00       	and    $0xfff,%eax
801015f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fa:	83 e0 07             	and    $0x7,%eax
801015fd:	ba 01 00 00 00       	mov    $0x1,%edx
80101602:	89 c1                	mov    %eax,%ecx
80101604:	d3 e2                	shl    %cl,%edx
80101606:	89 d0                	mov    %edx,%eax
80101608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160e:	8d 50 07             	lea    0x7(%eax),%edx
80101611:	85 c0                	test   %eax,%eax
80101613:	0f 48 c2             	cmovs  %edx,%eax
80101616:	c1 f8 03             	sar    $0x3,%eax
80101619:	89 c2                	mov    %eax,%edx
8010161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161e:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101623:	0f b6 c0             	movzbl %al,%eax
80101626:	23 45 ec             	and    -0x14(%ebp),%eax
80101629:	85 c0                	test   %eax,%eax
8010162b:	75 0d                	jne    8010163a <bfree+0x89>
    panic("freeing free block");
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	68 f6 a2 10 80       	push   $0x8010a2f6
80101635:	e8 6f ef ff ff       	call   801005a9 <panic>
  bp->data[bi/8] &= ~m;
8010163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163d:	8d 50 07             	lea    0x7(%eax),%edx
80101640:	85 c0                	test   %eax,%eax
80101642:	0f 48 c2             	cmovs  %edx,%eax
80101645:	c1 f8 03             	sar    $0x3,%eax
80101648:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010164b:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101650:	89 d1                	mov    %edx,%ecx
80101652:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101655:	f7 d2                	not    %edx
80101657:	21 ca                	and    %ecx,%edx
80101659:	89 d1                	mov    %edx,%ecx
8010165b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010165e:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101662:	83 ec 0c             	sub    $0xc,%esp
80101665:	ff 75 f4             	push   -0xc(%ebp)
80101668:	e8 0a 1c 00 00       	call   80103277 <log_write>
8010166d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	ff 75 f4             	push   -0xc(%ebp)
80101676:	e8 08 ec ff ff       	call   80100283 <brelse>
8010167b:	83 c4 10             	add    $0x10,%esp
}
8010167e:	90                   	nop
8010167f:	c9                   	leave
80101680:	c3                   	ret

80101681 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101681:	55                   	push   %ebp
80101682:	89 e5                	mov    %esp,%ebp
80101684:	57                   	push   %edi
80101685:	56                   	push   %esi
80101686:	53                   	push   %ebx
80101687:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
8010168a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101691:	83 ec 08             	sub    $0x8,%esp
80101694:	68 09 a3 10 80       	push   $0x8010a309
80101699:	68 60 24 19 80       	push   $0x80192460
8010169e:	e8 83 32 00 00       	call   80104926 <initlock>
801016a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016ad:	eb 2d                	jmp    801016dc <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016b2:	89 d0                	mov    %edx,%eax
801016b4:	c1 e0 03             	shl    $0x3,%eax
801016b7:	01 d0                	add    %edx,%eax
801016b9:	c1 e0 04             	shl    $0x4,%eax
801016bc:	83 c0 30             	add    $0x30,%eax
801016bf:	05 60 24 19 80       	add    $0x80192460,%eax
801016c4:	83 c0 10             	add    $0x10,%eax
801016c7:	83 ec 08             	sub    $0x8,%esp
801016ca:	68 10 a3 10 80       	push   $0x8010a310
801016cf:	50                   	push   %eax
801016d0:	e8 f4 30 00 00       	call   801047c9 <initsleeplock>
801016d5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016d8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016dc:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016e0:	7e cd                	jle    801016af <iinit+0x2e>
  }

  readsb(dev, &sb);
801016e2:	83 ec 08             	sub    $0x8,%esp
801016e5:	68 40 24 19 80       	push   $0x80192440
801016ea:	ff 75 08             	push   0x8(%ebp)
801016ed:	e8 e6 fc ff ff       	call   801013d8 <readsb>
801016f2:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016f5:	a1 58 24 19 80       	mov    0x80192458,%eax
801016fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016fd:	8b 3d 54 24 19 80    	mov    0x80192454,%edi
80101703:	8b 35 50 24 19 80    	mov    0x80192450,%esi
80101709:	8b 1d 4c 24 19 80    	mov    0x8019244c,%ebx
8010170f:	8b 0d 48 24 19 80    	mov    0x80192448,%ecx
80101715:	8b 15 44 24 19 80    	mov    0x80192444,%edx
8010171b:	a1 40 24 19 80       	mov    0x80192440,%eax
80101720:	ff 75 d4             	push   -0x2c(%ebp)
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	51                   	push   %ecx
80101727:	52                   	push   %edx
80101728:	50                   	push   %eax
80101729:	68 18 a3 10 80       	push   $0x8010a318
8010172e:	e8 c1 ec ff ff       	call   801003f4 <cprintf>
80101733:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101736:	90                   	nop
80101737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173a:	5b                   	pop    %ebx
8010173b:	5e                   	pop    %esi
8010173c:	5f                   	pop    %edi
8010173d:	5d                   	pop    %ebp
8010173e:	c3                   	ret

8010173f <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010173f:	55                   	push   %ebp
80101740:	89 e5                	mov    %esp,%ebp
80101742:	83 ec 28             	sub    $0x28,%esp
80101745:	8b 45 0c             	mov    0xc(%ebp),%eax
80101748:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101753:	e9 9e 00 00 00       	jmp    801017f6 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175b:	c1 e8 03             	shr    $0x3,%eax
8010175e:	89 c2                	mov    %eax,%edx
80101760:	a1 54 24 19 80       	mov    0x80192454,%eax
80101765:	01 d0                	add    %edx,%eax
80101767:	83 ec 08             	sub    $0x8,%esp
8010176a:	50                   	push   %eax
8010176b:	ff 75 08             	push   0x8(%ebp)
8010176e:	e8 8e ea ff ff       	call   80100201 <bread>
80101773:	83 c4 10             	add    $0x10,%esp
80101776:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101779:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177c:	8d 50 5c             	lea    0x5c(%eax),%edx
8010177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101782:	83 e0 07             	and    $0x7,%eax
80101785:	c1 e0 06             	shl    $0x6,%eax
80101788:	01 d0                	add    %edx,%eax
8010178a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010178d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101790:	0f b7 00             	movzwl (%eax),%eax
80101793:	66 85 c0             	test   %ax,%ax
80101796:	75 4c                	jne    801017e4 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101798:	83 ec 04             	sub    $0x4,%esp
8010179b:	6a 40                	push   $0x40
8010179d:	6a 00                	push   $0x0
8010179f:	ff 75 ec             	push   -0x14(%ebp)
801017a2:	e8 17 34 00 00       	call   80104bbe <memset>
801017a7:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ad:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017b1:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	ff 75 f0             	push   -0x10(%ebp)
801017ba:	e8 b8 1a 00 00       	call   80103277 <log_write>
801017bf:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017c2:	83 ec 0c             	sub    $0xc,%esp
801017c5:	ff 75 f0             	push   -0x10(%ebp)
801017c8:	e8 b6 ea ff ff       	call   80100283 <brelse>
801017cd:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	50                   	push   %eax
801017d7:	ff 75 08             	push   0x8(%ebp)
801017da:	e8 f7 00 00 00       	call   801018d6 <iget>
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	eb 2f                	jmp    80101813 <ialloc+0xd4>
    }
    brelse(bp);
801017e4:	83 ec 0c             	sub    $0xc,%esp
801017e7:	ff 75 f0             	push   -0x10(%ebp)
801017ea:	e8 94 ea ff ff       	call   80100283 <brelse>
801017ef:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017f6:	a1 48 24 19 80       	mov    0x80192448,%eax
801017fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017fe:	39 c2                	cmp    %eax,%edx
80101800:	0f 82 52 ff ff ff    	jb     80101758 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	68 6b a3 10 80       	push   $0x8010a36b
8010180e:	e8 96 ed ff ff       	call   801005a9 <panic>
}
80101813:	c9                   	leave
80101814:	c3                   	ret

80101815 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101815:	55                   	push   %ebp
80101816:	89 e5                	mov    %esp,%ebp
80101818:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010181b:	8b 45 08             	mov    0x8(%ebp),%eax
8010181e:	8b 40 04             	mov    0x4(%eax),%eax
80101821:	c1 e8 03             	shr    $0x3,%eax
80101824:	89 c2                	mov    %eax,%edx
80101826:	a1 54 24 19 80       	mov    0x80192454,%eax
8010182b:	01 c2                	add    %eax,%edx
8010182d:	8b 45 08             	mov    0x8(%ebp),%eax
80101830:	8b 00                	mov    (%eax),%eax
80101832:	83 ec 08             	sub    $0x8,%esp
80101835:	52                   	push   %edx
80101836:	50                   	push   %eax
80101837:	e8 c5 e9 ff ff       	call   80100201 <bread>
8010183c:	83 c4 10             	add    $0x10,%esp
8010183f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101845:	8d 50 5c             	lea    0x5c(%eax),%edx
80101848:	8b 45 08             	mov    0x8(%ebp),%eax
8010184b:	8b 40 04             	mov    0x4(%eax),%eax
8010184e:	83 e0 07             	and    $0x7,%eax
80101851:	c1 e0 06             	shl    $0x6,%eax
80101854:	01 d0                	add    %edx,%eax
80101856:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101859:	8b 45 08             	mov    0x8(%ebp),%eax
8010185c:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101863:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101866:	8b 45 08             	mov    0x8(%ebp),%eax
80101869:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101870:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101882:	8b 45 08             	mov    0x8(%ebp),%eax
80101885:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101889:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
80101893:	8b 50 58             	mov    0x58(%eax),%edx
80101896:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101899:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010189c:	8b 45 08             	mov    0x8(%ebp),%eax
8010189f:	8d 50 5c             	lea    0x5c(%eax),%edx
801018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a5:	83 c0 0c             	add    $0xc,%eax
801018a8:	83 ec 04             	sub    $0x4,%esp
801018ab:	6a 34                	push   $0x34
801018ad:	52                   	push   %edx
801018ae:	50                   	push   %eax
801018af:	e8 c9 33 00 00       	call   80104c7d <memmove>
801018b4:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	ff 75 f4             	push   -0xc(%ebp)
801018bd:	e8 b5 19 00 00       	call   80103277 <log_write>
801018c2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	ff 75 f4             	push   -0xc(%ebp)
801018cb:	e8 b3 e9 ff ff       	call   80100283 <brelse>
801018d0:	83 c4 10             	add    $0x10,%esp
}
801018d3:	90                   	nop
801018d4:	c9                   	leave
801018d5:	c3                   	ret

801018d6 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018d6:	55                   	push   %ebp
801018d7:	89 e5                	mov    %esp,%ebp
801018d9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	68 60 24 19 80       	push   $0x80192460
801018e4:	e8 5f 30 00 00       	call   80104948 <acquire>
801018e9:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f3:	c7 45 f4 94 24 19 80 	movl   $0x80192494,-0xc(%ebp)
801018fa:	eb 60                	jmp    8010195c <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ff:	8b 40 08             	mov    0x8(%eax),%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	7e 39                	jle    8010193f <iget+0x69>
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	8b 00                	mov    (%eax),%eax
8010190b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010190e:	75 2f                	jne    8010193f <iget+0x69>
80101910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101913:	8b 40 04             	mov    0x4(%eax),%eax
80101916:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101919:	75 24                	jne    8010193f <iget+0x69>
      ip->ref++;
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	8b 40 08             	mov    0x8(%eax),%eax
80101921:	8d 50 01             	lea    0x1(%eax),%edx
80101924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101927:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010192a:	83 ec 0c             	sub    $0xc,%esp
8010192d:	68 60 24 19 80       	push   $0x80192460
80101932:	e8 7f 30 00 00       	call   801049b6 <release>
80101937:	83 c4 10             	add    $0x10,%esp
      return ip;
8010193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193d:	eb 77                	jmp    801019b6 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010193f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101943:	75 10                	jne    80101955 <iget+0x7f>
80101945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101948:	8b 40 08             	mov    0x8(%eax),%eax
8010194b:	85 c0                	test   %eax,%eax
8010194d:	75 06                	jne    80101955 <iget+0x7f>
      empty = ip;
8010194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101952:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101955:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010195c:	81 7d f4 b4 40 19 80 	cmpl   $0x801940b4,-0xc(%ebp)
80101963:	72 97                	jb     801018fc <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101965:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101969:	75 0d                	jne    80101978 <iget+0xa2>
    panic("iget: no inodes");
8010196b:	83 ec 0c             	sub    $0xc,%esp
8010196e:	68 7d a3 10 80       	push   $0x8010a37d
80101973:	e8 31 ec ff ff       	call   801005a9 <panic>

  ip = empty;
80101978:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101981:	8b 55 08             	mov    0x8(%ebp),%edx
80101984:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101989:	8b 55 0c             	mov    0xc(%ebp),%edx
8010198c:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101992:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199c:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019a3:	83 ec 0c             	sub    $0xc,%esp
801019a6:	68 60 24 19 80       	push   $0x80192460
801019ab:	e8 06 30 00 00       	call   801049b6 <release>
801019b0:	83 c4 10             	add    $0x10,%esp

  return ip;
801019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019b6:	c9                   	leave
801019b7:	c3                   	ret

801019b8 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019b8:	55                   	push   %ebp
801019b9:	89 e5                	mov    %esp,%ebp
801019bb:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019be:	83 ec 0c             	sub    $0xc,%esp
801019c1:	68 60 24 19 80       	push   $0x80192460
801019c6:	e8 7d 2f 00 00       	call   80104948 <acquire>
801019cb:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ce:	8b 45 08             	mov    0x8(%ebp),%eax
801019d1:	8b 40 08             	mov    0x8(%eax),%eax
801019d4:	8d 50 01             	lea    0x1(%eax),%edx
801019d7:	8b 45 08             	mov    0x8(%ebp),%eax
801019da:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019dd:	83 ec 0c             	sub    $0xc,%esp
801019e0:	68 60 24 19 80       	push   $0x80192460
801019e5:	e8 cc 2f 00 00       	call   801049b6 <release>
801019ea:	83 c4 10             	add    $0x10,%esp
  return ip;
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019f0:	c9                   	leave
801019f1:	c3                   	ret

801019f2 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019f2:	55                   	push   %ebp
801019f3:	89 e5                	mov    %esp,%ebp
801019f5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019fc:	74 0a                	je     80101a08 <ilock+0x16>
801019fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101a01:	8b 40 08             	mov    0x8(%eax),%eax
80101a04:	85 c0                	test   %eax,%eax
80101a06:	7f 0d                	jg     80101a15 <ilock+0x23>
    panic("ilock");
80101a08:	83 ec 0c             	sub    $0xc,%esp
80101a0b:	68 8d a3 10 80       	push   $0x8010a38d
80101a10:	e8 94 eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	83 c0 0c             	add    $0xc,%eax
80101a1b:	83 ec 0c             	sub    $0xc,%esp
80101a1e:	50                   	push   %eax
80101a1f:	e8 e1 2d 00 00       	call   80104805 <acquiresleep>
80101a24:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a2d:	85 c0                	test   %eax,%eax
80101a2f:	0f 85 cd 00 00 00    	jne    80101b02 <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a35:	8b 45 08             	mov    0x8(%ebp),%eax
80101a38:	8b 40 04             	mov    0x4(%eax),%eax
80101a3b:	c1 e8 03             	shr    $0x3,%eax
80101a3e:	89 c2                	mov    %eax,%edx
80101a40:	a1 54 24 19 80       	mov    0x80192454,%eax
80101a45:	01 c2                	add    %eax,%edx
80101a47:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4a:	8b 00                	mov    (%eax),%eax
80101a4c:	83 ec 08             	sub    $0x8,%esp
80101a4f:	52                   	push   %edx
80101a50:	50                   	push   %eax
80101a51:	e8 ab e7 ff ff       	call   80100201 <bread>
80101a56:	83 c4 10             	add    $0x10,%esp
80101a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5f:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	8b 40 04             	mov    0x4(%eax),%eax
80101a68:	83 e0 07             	and    $0x7,%eax
80101a6b:	c1 e0 06             	shl    $0x6,%eax
80101a6e:	01 d0                	add    %edx,%eax
80101a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a76:	0f b7 10             	movzwl (%eax),%edx
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a83:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a91:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a9f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aad:	8b 50 08             	mov    0x8(%eax),%edx
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab9:	8d 50 0c             	lea    0xc(%eax),%edx
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	83 c0 5c             	add    $0x5c,%eax
80101ac2:	83 ec 04             	sub    $0x4,%esp
80101ac5:	6a 34                	push   $0x34
80101ac7:	52                   	push   %edx
80101ac8:	50                   	push   %eax
80101ac9:	e8 af 31 00 00       	call   80104c7d <memmove>
80101ace:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ad1:	83 ec 0c             	sub    $0xc,%esp
80101ad4:	ff 75 f4             	push   -0xc(%ebp)
80101ad7:	e8 a7 e7 ff ff       	call   80100283 <brelse>
80101adc:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101adf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101af0:	66 85 c0             	test   %ax,%ax
80101af3:	75 0d                	jne    80101b02 <ilock+0x110>
      panic("ilock: no type");
80101af5:	83 ec 0c             	sub    $0xc,%esp
80101af8:	68 93 a3 10 80       	push   $0x8010a393
80101afd:	e8 a7 ea ff ff       	call   801005a9 <panic>
  }
}
80101b02:	90                   	nop
80101b03:	c9                   	leave
80101b04:	c3                   	ret

80101b05 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b05:	55                   	push   %ebp
80101b06:	89 e5                	mov    %esp,%ebp
80101b08:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b0f:	74 20                	je     80101b31 <iunlock+0x2c>
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	83 c0 0c             	add    $0xc,%eax
80101b17:	83 ec 0c             	sub    $0xc,%esp
80101b1a:	50                   	push   %eax
80101b1b:	e8 97 2d 00 00       	call   801048b7 <holdingsleep>
80101b20:	83 c4 10             	add    $0x10,%esp
80101b23:	85 c0                	test   %eax,%eax
80101b25:	74 0a                	je     80101b31 <iunlock+0x2c>
80101b27:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2a:	8b 40 08             	mov    0x8(%eax),%eax
80101b2d:	85 c0                	test   %eax,%eax
80101b2f:	7f 0d                	jg     80101b3e <iunlock+0x39>
    panic("iunlock");
80101b31:	83 ec 0c             	sub    $0xc,%esp
80101b34:	68 a2 a3 10 80       	push   $0x8010a3a2
80101b39:	e8 6b ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b41:	83 c0 0c             	add    $0xc,%eax
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	50                   	push   %eax
80101b48:	e8 1c 2d 00 00       	call   80104869 <releasesleep>
80101b4d:	83 c4 10             	add    $0x10,%esp
}
80101b50:	90                   	nop
80101b51:	c9                   	leave
80101b52:	c3                   	ret

80101b53 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b53:	55                   	push   %ebp
80101b54:	89 e5                	mov    %esp,%ebp
80101b56:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	83 c0 0c             	add    $0xc,%eax
80101b5f:	83 ec 0c             	sub    $0xc,%esp
80101b62:	50                   	push   %eax
80101b63:	e8 9d 2c 00 00       	call   80104805 <acquiresleep>
80101b68:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 6a                	je     80101bdf <iput+0x8c>
80101b75:	8b 45 08             	mov    0x8(%ebp),%eax
80101b78:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b7c:	66 85 c0             	test   %ax,%ax
80101b7f:	75 5e                	jne    80101bdf <iput+0x8c>
    acquire(&icache.lock);
80101b81:	83 ec 0c             	sub    $0xc,%esp
80101b84:	68 60 24 19 80       	push   $0x80192460
80101b89:	e8 ba 2d 00 00       	call   80104948 <acquire>
80101b8e:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b91:	8b 45 08             	mov    0x8(%ebp),%eax
80101b94:	8b 40 08             	mov    0x8(%eax),%eax
80101b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 60 24 19 80       	push   $0x80192460
80101ba2:	e8 0f 2e 00 00       	call   801049b6 <release>
80101ba7:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101baa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bae:	75 2f                	jne    80101bdf <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bb0:	83 ec 0c             	sub    $0xc,%esp
80101bb3:	ff 75 08             	push   0x8(%ebp)
80101bb6:	e8 ad 01 00 00       	call   80101d68 <itrunc>
80101bbb:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc1:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bc7:	83 ec 0c             	sub    $0xc,%esp
80101bca:	ff 75 08             	push   0x8(%ebp)
80101bcd:	e8 43 fc ff ff       	call   80101815 <iupdate>
80101bd2:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80101be2:	83 c0 0c             	add    $0xc,%eax
80101be5:	83 ec 0c             	sub    $0xc,%esp
80101be8:	50                   	push   %eax
80101be9:	e8 7b 2c 00 00       	call   80104869 <releasesleep>
80101bee:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	68 60 24 19 80       	push   $0x80192460
80101bf9:	e8 4a 2d 00 00       	call   80104948 <acquire>
80101bfe:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	8b 40 08             	mov    0x8(%eax),%eax
80101c07:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c10:	83 ec 0c             	sub    $0xc,%esp
80101c13:	68 60 24 19 80       	push   $0x80192460
80101c18:	e8 99 2d 00 00       	call   801049b6 <release>
80101c1d:	83 c4 10             	add    $0x10,%esp
}
80101c20:	90                   	nop
80101c21:	c9                   	leave
80101c22:	c3                   	ret

80101c23 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c23:	55                   	push   %ebp
80101c24:	89 e5                	mov    %esp,%ebp
80101c26:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c29:	83 ec 0c             	sub    $0xc,%esp
80101c2c:	ff 75 08             	push   0x8(%ebp)
80101c2f:	e8 d1 fe ff ff       	call   80101b05 <iunlock>
80101c34:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	ff 75 08             	push   0x8(%ebp)
80101c3d:	e8 11 ff ff ff       	call   80101b53 <iput>
80101c42:	83 c4 10             	add    $0x10,%esp
}
80101c45:	90                   	nop
80101c46:	c9                   	leave
80101c47:	c3                   	ret

80101c48 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c48:	55                   	push   %ebp
80101c49:	89 e5                	mov    %esp,%ebp
80101c4b:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c4e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c52:	77 42                	ja     80101c96 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c5a:	83 c2 14             	add    $0x14,%edx
80101c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c68:	75 24                	jne    80101c8e <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 00                	mov    (%eax),%eax
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	50                   	push   %eax
80101c73:	e8 f6 f7 ff ff       	call   8010146e <balloc>
80101c78:	83 c4 10             	add    $0x10,%esp
80101c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c81:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c84:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c91:	e9 d0 00 00 00       	jmp    80101d66 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101c96:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c9a:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c9e:	0f 87 b5 00 00 00    	ja     80101d59 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cb4:	75 20                	jne    80101cd6 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 00                	mov    (%eax),%eax
80101cbb:	83 ec 0c             	sub    $0xc,%esp
80101cbe:	50                   	push   %eax
80101cbf:	e8 aa f7 ff ff       	call   8010146e <balloc>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd0:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd9:	8b 00                	mov    (%eax),%eax
80101cdb:	83 ec 08             	sub    $0x8,%esp
80101cde:	ff 75 f4             	push   -0xc(%ebp)
80101ce1:	50                   	push   %eax
80101ce2:	e8 1a e5 ff ff       	call   80100201 <bread>
80101ce7:	83 c4 10             	add    $0x10,%esp
80101cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cf0:	83 c0 5c             	add    $0x5c,%eax
80101cf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d03:	01 d0                	add    %edx,%eax
80101d05:	8b 00                	mov    (%eax),%eax
80101d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d0e:	75 36                	jne    80101d46 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	8b 00                	mov    (%eax),%eax
80101d15:	83 ec 0c             	sub    $0xc,%esp
80101d18:	50                   	push   %eax
80101d19:	e8 50 f7 ff ff       	call   8010146e <balloc>
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d31:	01 c2                	add    %eax,%edx
80101d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d36:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	ff 75 f0             	push   -0x10(%ebp)
80101d3e:	e8 34 15 00 00       	call   80103277 <log_write>
80101d43:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d46:	83 ec 0c             	sub    $0xc,%esp
80101d49:	ff 75 f0             	push   -0x10(%ebp)
80101d4c:	e8 32 e5 ff ff       	call   80100283 <brelse>
80101d51:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d57:	eb 0d                	jmp    80101d66 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d59:	83 ec 0c             	sub    $0xc,%esp
80101d5c:	68 aa a3 10 80       	push   $0x8010a3aa
80101d61:	e8 43 e8 ff ff       	call   801005a9 <panic>
}
80101d66:	c9                   	leave
80101d67:	c3                   	ret

80101d68 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d68:	55                   	push   %ebp
80101d69:	89 e5                	mov    %esp,%ebp
80101d6b:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d75:	eb 45                	jmp    80101dbc <itrunc+0x54>
    if(ip->addrs[i]){
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d7d:	83 c2 14             	add    $0x14,%edx
80101d80:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d84:	85 c0                	test   %eax,%eax
80101d86:	74 30                	je     80101db8 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d88:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d8e:	83 c2 14             	add    $0x14,%edx
80101d91:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d95:	8b 55 08             	mov    0x8(%ebp),%edx
80101d98:	8b 12                	mov    (%edx),%edx
80101d9a:	83 ec 08             	sub    $0x8,%esp
80101d9d:	50                   	push   %eax
80101d9e:	52                   	push   %edx
80101d9f:	e8 0d f8 ff ff       	call   801015b1 <bfree>
80101da4:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101da7:	8b 45 08             	mov    0x8(%ebp),%eax
80101daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dad:	83 c2 14             	add    $0x14,%edx
80101db0:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101db7:	00 
  for(i = 0; i < NDIRECT; i++){
80101db8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dbc:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dc0:	7e b5                	jle    80101d77 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc5:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	0f 84 aa 00 00 00    	je     80101e7d <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 00                	mov    (%eax),%eax
80101de1:	83 ec 08             	sub    $0x8,%esp
80101de4:	52                   	push   %edx
80101de5:	50                   	push   %eax
80101de6:	e8 16 e4 ff ff       	call   80100201 <bread>
80101deb:	83 c4 10             	add    $0x10,%esp
80101dee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101df4:	83 c0 5c             	add    $0x5c,%eax
80101df7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e01:	eb 3c                	jmp    80101e3f <itrunc+0xd7>
      if(a[j])
80101e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e10:	01 d0                	add    %edx,%eax
80101e12:	8b 00                	mov    (%eax),%eax
80101e14:	85 c0                	test   %eax,%eax
80101e16:	74 23                	je     80101e3b <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e25:	01 d0                	add    %edx,%eax
80101e27:	8b 00                	mov    (%eax),%eax
80101e29:	8b 55 08             	mov    0x8(%ebp),%edx
80101e2c:	8b 12                	mov    (%edx),%edx
80101e2e:	83 ec 08             	sub    $0x8,%esp
80101e31:	50                   	push   %eax
80101e32:	52                   	push   %edx
80101e33:	e8 79 f7 ff ff       	call   801015b1 <bfree>
80101e38:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e3b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e42:	83 f8 7f             	cmp    $0x7f,%eax
80101e45:	76 bc                	jbe    80101e03 <itrunc+0x9b>
    }
    brelse(bp);
80101e47:	83 ec 0c             	sub    $0xc,%esp
80101e4a:	ff 75 ec             	push   -0x14(%ebp)
80101e4d:	e8 31 e4 ff ff       	call   80100283 <brelse>
80101e52:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e55:	8b 45 08             	mov    0x8(%ebp),%eax
80101e58:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e61:	8b 12                	mov    (%edx),%edx
80101e63:	83 ec 08             	sub    $0x8,%esp
80101e66:	50                   	push   %eax
80101e67:	52                   	push   %edx
80101e68:	e8 44 f7 ff ff       	call   801015b1 <bfree>
80101e6d:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e7a:	00 00 00 
  }

  ip->size = 0;
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	ff 75 08             	push   0x8(%ebp)
80101e8d:	e8 83 f9 ff ff       	call   80101815 <iupdate>
80101e92:	83 c4 10             	add    $0x10,%esp
}
80101e95:	90                   	nop
80101e96:	c9                   	leave
80101e97:	c3                   	ret

80101e98 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e98:	55                   	push   %ebp
80101e99:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	8b 00                	mov    (%eax),%eax
80101ea0:	89 c2                	mov    %eax,%edx
80101ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea5:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eab:	8b 50 04             	mov    0x4(%eax),%edx
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb7:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ebe:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ecb:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	8b 50 58             	mov    0x58(%eax),%edx
80101ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed8:	89 50 10             	mov    %edx,0x10(%eax)
}
80101edb:	90                   	nop
80101edc:	5d                   	pop    %ebp
80101edd:	c3                   	ret

80101ede <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ede:	55                   	push   %ebp
80101edf:	89 e5                	mov    %esp,%ebp
80101ee1:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101eeb:	66 83 f8 03          	cmp    $0x3,%ax
80101eef:	75 5c                	jne    80101f4d <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef4:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ef8:	66 85 c0             	test   %ax,%ax
80101efb:	78 20                	js     80101f1d <readi+0x3f>
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	7f 13                	jg     80101f1d <readi+0x3f>
80101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f11:	98                   	cwtl
80101f12:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f19:	85 c0                	test   %eax,%eax
80101f1b:	75 0a                	jne    80101f27 <readi+0x49>
      return -1;
80101f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f22:	e9 0a 01 00 00       	jmp    80102031 <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f2e:	98                   	cwtl
80101f2f:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f36:	8b 55 14             	mov    0x14(%ebp),%edx
80101f39:	83 ec 04             	sub    $0x4,%esp
80101f3c:	52                   	push   %edx
80101f3d:	ff 75 0c             	push   0xc(%ebp)
80101f40:	ff 75 08             	push   0x8(%ebp)
80101f43:	ff d0                	call   *%eax
80101f45:	83 c4 10             	add    $0x10,%esp
80101f48:	e9 e4 00 00 00       	jmp    80102031 <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f50:	8b 40 58             	mov    0x58(%eax),%eax
80101f53:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f56:	72 0d                	jb     80101f65 <readi+0x87>
80101f58:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5e:	01 d0                	add    %edx,%eax
80101f60:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f63:	73 0a                	jae    80101f6f <readi+0x91>
    return -1;
80101f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6a:	e9 c2 00 00 00       	jmp    80102031 <readi+0x153>
  if(off + n > ip->size)
80101f6f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f72:	8b 45 14             	mov    0x14(%ebp),%eax
80101f75:	01 c2                	add    %eax,%edx
80101f77:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7a:	8b 40 58             	mov    0x58(%eax),%eax
80101f7d:	39 d0                	cmp    %edx,%eax
80101f7f:	73 0c                	jae    80101f8d <readi+0xaf>
    n = ip->size - off;
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	8b 40 58             	mov    0x58(%eax),%eax
80101f87:	2b 45 10             	sub    0x10(%ebp),%eax
80101f8a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f94:	e9 89 00 00 00       	jmp    80102022 <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f99:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9c:	c1 e8 09             	shr    $0x9,%eax
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 75 08             	push   0x8(%ebp)
80101fa6:	e8 9d fc ff ff       	call   80101c48 <bmap>
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	8b 55 08             	mov    0x8(%ebp),%edx
80101fb1:	8b 12                	mov    (%edx),%edx
80101fb3:	83 ec 08             	sub    $0x8,%esp
80101fb6:	50                   	push   %eax
80101fb7:	52                   	push   %edx
80101fb8:	e8 44 e2 ff ff       	call   80100201 <bread>
80101fbd:	83 c4 10             	add    $0x10,%esp
80101fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fcb:	ba 00 02 00 00       	mov    $0x200,%edx
80101fd0:	29 c2                	sub    %eax,%edx
80101fd2:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd5:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fd8:	39 c2                	cmp    %eax,%edx
80101fda:	0f 46 c2             	cmovbe %edx,%eax
80101fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe3:	8d 50 5c             	lea    0x5c(%eax),%edx
80101fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fee:	01 d0                	add    %edx,%eax
80101ff0:	83 ec 04             	sub    $0x4,%esp
80101ff3:	ff 75 ec             	push   -0x14(%ebp)
80101ff6:	50                   	push   %eax
80101ff7:	ff 75 0c             	push   0xc(%ebp)
80101ffa:	e8 7e 2c 00 00       	call   80104c7d <memmove>
80101fff:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102002:	83 ec 0c             	sub    $0xc,%esp
80102005:	ff 75 f0             	push   -0x10(%ebp)
80102008:	e8 76 e2 ff ff       	call   80100283 <brelse>
8010200d:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102010:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102013:	01 45 f4             	add    %eax,-0xc(%ebp)
80102016:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102019:	01 45 10             	add    %eax,0x10(%ebp)
8010201c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201f:	01 45 0c             	add    %eax,0xc(%ebp)
80102022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102025:	3b 45 14             	cmp    0x14(%ebp),%eax
80102028:	0f 82 6b ff ff ff    	jb     80101f99 <readi+0xbb>
  }
  return n;
8010202e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102031:	c9                   	leave
80102032:	c3                   	ret

80102033 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102033:	55                   	push   %ebp
80102034:	89 e5                	mov    %esp,%ebp
80102036:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102040:	66 83 f8 03          	cmp    $0x3,%ax
80102044:	75 5c                	jne    801020a2 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102046:	8b 45 08             	mov    0x8(%ebp),%eax
80102049:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010204d:	66 85 c0             	test   %ax,%ax
80102050:	78 20                	js     80102072 <writei+0x3f>
80102052:	8b 45 08             	mov    0x8(%ebp),%eax
80102055:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102059:	66 83 f8 09          	cmp    $0x9,%ax
8010205d:	7f 13                	jg     80102072 <writei+0x3f>
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
80102062:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102066:	98                   	cwtl
80102067:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
8010206e:	85 c0                	test   %eax,%eax
80102070:	75 0a                	jne    8010207c <writei+0x49>
      return -1;
80102072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102077:	e9 3b 01 00 00       	jmp    801021b7 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102083:	98                   	cwtl
80102084:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
8010208b:	8b 55 14             	mov    0x14(%ebp),%edx
8010208e:	83 ec 04             	sub    $0x4,%esp
80102091:	52                   	push   %edx
80102092:	ff 75 0c             	push   0xc(%ebp)
80102095:	ff 75 08             	push   0x8(%ebp)
80102098:	ff d0                	call   *%eax
8010209a:	83 c4 10             	add    $0x10,%esp
8010209d:	e9 15 01 00 00       	jmp    801021b7 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
801020a2:	8b 45 08             	mov    0x8(%ebp),%eax
801020a5:	8b 40 58             	mov    0x58(%eax),%eax
801020a8:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ab:	72 0d                	jb     801020ba <writei+0x87>
801020ad:	8b 55 10             	mov    0x10(%ebp),%edx
801020b0:	8b 45 14             	mov    0x14(%ebp),%eax
801020b3:	01 d0                	add    %edx,%eax
801020b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801020b8:	73 0a                	jae    801020c4 <writei+0x91>
    return -1;
801020ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020bf:	e9 f3 00 00 00       	jmp    801021b7 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020c4:	8b 55 10             	mov    0x10(%ebp),%edx
801020c7:	8b 45 14             	mov    0x14(%ebp),%eax
801020ca:	01 d0                	add    %edx,%eax
801020cc:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020d1:	76 0a                	jbe    801020dd <writei+0xaa>
    return -1;
801020d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d8:	e9 da 00 00 00       	jmp    801021b7 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020e4:	e9 97 00 00 00       	jmp    80102180 <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020e9:	8b 45 10             	mov    0x10(%ebp),%eax
801020ec:	c1 e8 09             	shr    $0x9,%eax
801020ef:	83 ec 08             	sub    $0x8,%esp
801020f2:	50                   	push   %eax
801020f3:	ff 75 08             	push   0x8(%ebp)
801020f6:	e8 4d fb ff ff       	call   80101c48 <bmap>
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	8b 55 08             	mov    0x8(%ebp),%edx
80102101:	8b 12                	mov    (%edx),%edx
80102103:	83 ec 08             	sub    $0x8,%esp
80102106:	50                   	push   %eax
80102107:	52                   	push   %edx
80102108:	e8 f4 e0 ff ff       	call   80100201 <bread>
8010210d:	83 c4 10             	add    $0x10,%esp
80102110:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	25 ff 01 00 00       	and    $0x1ff,%eax
8010211b:	ba 00 02 00 00       	mov    $0x200,%edx
80102120:	29 c2                	sub    %eax,%edx
80102122:	8b 45 14             	mov    0x14(%ebp),%eax
80102125:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102128:	39 c2                	cmp    %eax,%edx
8010212a:	0f 46 c2             	cmovbe %edx,%eax
8010212d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102130:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102133:	8d 50 5c             	lea    0x5c(%eax),%edx
80102136:	8b 45 10             	mov    0x10(%ebp),%eax
80102139:	25 ff 01 00 00       	and    $0x1ff,%eax
8010213e:	01 d0                	add    %edx,%eax
80102140:	83 ec 04             	sub    $0x4,%esp
80102143:	ff 75 ec             	push   -0x14(%ebp)
80102146:	ff 75 0c             	push   0xc(%ebp)
80102149:	50                   	push   %eax
8010214a:	e8 2e 2b 00 00       	call   80104c7d <memmove>
8010214f:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102152:	83 ec 0c             	sub    $0xc,%esp
80102155:	ff 75 f0             	push   -0x10(%ebp)
80102158:	e8 1a 11 00 00       	call   80103277 <log_write>
8010215d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	ff 75 f0             	push   -0x10(%ebp)
80102166:	e8 18 e1 ff ff       	call   80100283 <brelse>
8010216b:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010216e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102171:	01 45 f4             	add    %eax,-0xc(%ebp)
80102174:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102177:	01 45 10             	add    %eax,0x10(%ebp)
8010217a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010217d:	01 45 0c             	add    %eax,0xc(%ebp)
80102180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102183:	3b 45 14             	cmp    0x14(%ebp),%eax
80102186:	0f 82 5d ff ff ff    	jb     801020e9 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
8010218c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102190:	74 22                	je     801021b4 <writei+0x181>
80102192:	8b 45 08             	mov    0x8(%ebp),%eax
80102195:	8b 40 58             	mov    0x58(%eax),%eax
80102198:	3b 45 10             	cmp    0x10(%ebp),%eax
8010219b:	73 17                	jae    801021b4 <writei+0x181>
    ip->size = off;
8010219d:	8b 45 08             	mov    0x8(%ebp),%eax
801021a0:	8b 55 10             	mov    0x10(%ebp),%edx
801021a3:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	ff 75 08             	push   0x8(%ebp)
801021ac:	e8 64 f6 ff ff       	call   80101815 <iupdate>
801021b1:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021b4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021b7:	c9                   	leave
801021b8:	c3                   	ret

801021b9 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b9:	55                   	push   %ebp
801021ba:	89 e5                	mov    %esp,%ebp
801021bc:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021bf:	83 ec 04             	sub    $0x4,%esp
801021c2:	6a 0e                	push   $0xe
801021c4:	ff 75 0c             	push   0xc(%ebp)
801021c7:	ff 75 08             	push   0x8(%ebp)
801021ca:	e8 44 2b 00 00       	call   80104d13 <strncmp>
801021cf:	83 c4 10             	add    $0x10,%esp
}
801021d2:	c9                   	leave
801021d3:	c3                   	ret

801021d4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d4:	55                   	push   %ebp
801021d5:	89 e5                	mov    %esp,%ebp
801021d7:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021da:	8b 45 08             	mov    0x8(%ebp),%eax
801021dd:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021e1:	66 83 f8 01          	cmp    $0x1,%ax
801021e5:	74 0d                	je     801021f4 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021e7:	83 ec 0c             	sub    $0xc,%esp
801021ea:	68 bd a3 10 80       	push   $0x8010a3bd
801021ef:	e8 b5 e3 ff ff       	call   801005a9 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021fb:	eb 7b                	jmp    80102278 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fd:	6a 10                	push   $0x10
801021ff:	ff 75 f4             	push   -0xc(%ebp)
80102202:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102205:	50                   	push   %eax
80102206:	ff 75 08             	push   0x8(%ebp)
80102209:	e8 d0 fc ff ff       	call   80101ede <readi>
8010220e:	83 c4 10             	add    $0x10,%esp
80102211:	83 f8 10             	cmp    $0x10,%eax
80102214:	74 0d                	je     80102223 <dirlookup+0x4f>
      panic("dirlookup read");
80102216:	83 ec 0c             	sub    $0xc,%esp
80102219:	68 cf a3 10 80       	push   $0x8010a3cf
8010221e:	e8 86 e3 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
80102223:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102227:	66 85 c0             	test   %ax,%ax
8010222a:	74 47                	je     80102273 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010222c:	83 ec 08             	sub    $0x8,%esp
8010222f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102232:	83 c0 02             	add    $0x2,%eax
80102235:	50                   	push   %eax
80102236:	ff 75 0c             	push   0xc(%ebp)
80102239:	e8 7b ff ff ff       	call   801021b9 <namecmp>
8010223e:	83 c4 10             	add    $0x10,%esp
80102241:	85 c0                	test   %eax,%eax
80102243:	75 2f                	jne    80102274 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102245:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102249:	74 08                	je     80102253 <dirlookup+0x7f>
        *poff = off;
8010224b:	8b 45 10             	mov    0x10(%ebp),%eax
8010224e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102251:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102253:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102257:	0f b7 c0             	movzwl %ax,%eax
8010225a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010225d:	8b 45 08             	mov    0x8(%ebp),%eax
80102260:	8b 00                	mov    (%eax),%eax
80102262:	83 ec 08             	sub    $0x8,%esp
80102265:	ff 75 f0             	push   -0x10(%ebp)
80102268:	50                   	push   %eax
80102269:	e8 68 f6 ff ff       	call   801018d6 <iget>
8010226e:	83 c4 10             	add    $0x10,%esp
80102271:	eb 19                	jmp    8010228c <dirlookup+0xb8>
      continue;
80102273:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102274:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	8b 40 58             	mov    0x58(%eax),%eax
8010227e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102281:	0f 82 76 ff ff ff    	jb     801021fd <dirlookup+0x29>
    }
  }

  return 0;
80102287:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010228c:	c9                   	leave
8010228d:	c3                   	ret

8010228e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010228e:	55                   	push   %ebp
8010228f:	89 e5                	mov    %esp,%ebp
80102291:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102294:	83 ec 04             	sub    $0x4,%esp
80102297:	6a 00                	push   $0x0
80102299:	ff 75 0c             	push   0xc(%ebp)
8010229c:	ff 75 08             	push   0x8(%ebp)
8010229f:	e8 30 ff ff ff       	call   801021d4 <dirlookup>
801022a4:	83 c4 10             	add    $0x10,%esp
801022a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022ae:	74 18                	je     801022c8 <dirlink+0x3a>
    iput(ip);
801022b0:	83 ec 0c             	sub    $0xc,%esp
801022b3:	ff 75 f0             	push   -0x10(%ebp)
801022b6:	e8 98 f8 ff ff       	call   80101b53 <iput>
801022bb:	83 c4 10             	add    $0x10,%esp
    return -1;
801022be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c3:	e9 9c 00 00 00       	jmp    80102364 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022cf:	eb 39                	jmp    8010230a <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d4:	6a 10                	push   $0x10
801022d6:	50                   	push   %eax
801022d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022da:	50                   	push   %eax
801022db:	ff 75 08             	push   0x8(%ebp)
801022de:	e8 fb fb ff ff       	call   80101ede <readi>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	83 f8 10             	cmp    $0x10,%eax
801022e9:	74 0d                	je     801022f8 <dirlink+0x6a>
      panic("dirlink read");
801022eb:	83 ec 0c             	sub    $0xc,%esp
801022ee:	68 de a3 10 80       	push   $0x8010a3de
801022f3:	e8 b1 e2 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
801022f8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022fc:	66 85 c0             	test   %ax,%ax
801022ff:	74 18                	je     80102319 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102304:	83 c0 10             	add    $0x10,%eax
80102307:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010230a:	8b 45 08             	mov    0x8(%ebp),%eax
8010230d:	8b 40 58             	mov    0x58(%eax),%eax
80102310:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102313:	39 c2                	cmp    %eax,%edx
80102315:	72 ba                	jb     801022d1 <dirlink+0x43>
80102317:	eb 01                	jmp    8010231a <dirlink+0x8c>
      break;
80102319:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010231a:	83 ec 04             	sub    $0x4,%esp
8010231d:	6a 0e                	push   $0xe
8010231f:	ff 75 0c             	push   0xc(%ebp)
80102322:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102325:	83 c0 02             	add    $0x2,%eax
80102328:	50                   	push   %eax
80102329:	e8 3b 2a 00 00       	call   80104d69 <strncpy>
8010232e:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102331:	8b 45 10             	mov    0x10(%ebp),%eax
80102334:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233b:	6a 10                	push   $0x10
8010233d:	50                   	push   %eax
8010233e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102341:	50                   	push   %eax
80102342:	ff 75 08             	push   0x8(%ebp)
80102345:	e8 e9 fc ff ff       	call   80102033 <writei>
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 f8 10             	cmp    $0x10,%eax
80102350:	74 0d                	je     8010235f <dirlink+0xd1>
    panic("dirlink");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 eb a3 10 80       	push   $0x8010a3eb
8010235a:	e8 4a e2 ff ff       	call   801005a9 <panic>

  return 0;
8010235f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102364:	c9                   	leave
80102365:	c3                   	ret

80102366 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102366:	55                   	push   %ebp
80102367:	89 e5                	mov    %esp,%ebp
80102369:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010236c:	eb 04                	jmp    80102372 <skipelem+0xc>
    path++;
8010236e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102372:	8b 45 08             	mov    0x8(%ebp),%eax
80102375:	0f b6 00             	movzbl (%eax),%eax
80102378:	3c 2f                	cmp    $0x2f,%al
8010237a:	74 f2                	je     8010236e <skipelem+0x8>
  if(*path == 0)
8010237c:	8b 45 08             	mov    0x8(%ebp),%eax
8010237f:	0f b6 00             	movzbl (%eax),%eax
80102382:	84 c0                	test   %al,%al
80102384:	75 07                	jne    8010238d <skipelem+0x27>
    return 0;
80102386:	b8 00 00 00 00       	mov    $0x0,%eax
8010238b:	eb 77                	jmp    80102404 <skipelem+0x9e>
  s = path;
8010238d:	8b 45 08             	mov    0x8(%ebp),%eax
80102390:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102393:	eb 04                	jmp    80102399 <skipelem+0x33>
    path++;
80102395:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	0f b6 00             	movzbl (%eax),%eax
8010239f:	3c 2f                	cmp    $0x2f,%al
801023a1:	74 0a                	je     801023ad <skipelem+0x47>
801023a3:	8b 45 08             	mov    0x8(%ebp),%eax
801023a6:	0f b6 00             	movzbl (%eax),%eax
801023a9:	84 c0                	test   %al,%al
801023ab:	75 e8                	jne    80102395 <skipelem+0x2f>
  len = path - s;
801023ad:	8b 45 08             	mov    0x8(%ebp),%eax
801023b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023b6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023ba:	7e 15                	jle    801023d1 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023bc:	83 ec 04             	sub    $0x4,%esp
801023bf:	6a 0e                	push   $0xe
801023c1:	ff 75 f4             	push   -0xc(%ebp)
801023c4:	ff 75 0c             	push   0xc(%ebp)
801023c7:	e8 b1 28 00 00       	call   80104c7d <memmove>
801023cc:	83 c4 10             	add    $0x10,%esp
801023cf:	eb 26                	jmp    801023f7 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	50                   	push   %eax
801023d8:	ff 75 f4             	push   -0xc(%ebp)
801023db:	ff 75 0c             	push   0xc(%ebp)
801023de:	e8 9a 28 00 00       	call   80104c7d <memmove>
801023e3:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ec:	01 d0                	add    %edx,%eax
801023ee:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023f1:	eb 04                	jmp    801023f7 <skipelem+0x91>
    path++;
801023f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023f7:	8b 45 08             	mov    0x8(%ebp),%eax
801023fa:	0f b6 00             	movzbl (%eax),%eax
801023fd:	3c 2f                	cmp    $0x2f,%al
801023ff:	74 f2                	je     801023f3 <skipelem+0x8d>
  return path;
80102401:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102404:	c9                   	leave
80102405:	c3                   	ret

80102406 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102406:	55                   	push   %ebp
80102407:	89 e5                	mov    %esp,%ebp
80102409:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010240c:	8b 45 08             	mov    0x8(%ebp),%eax
8010240f:	0f b6 00             	movzbl (%eax),%eax
80102412:	3c 2f                	cmp    $0x2f,%al
80102414:	75 17                	jne    8010242d <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102416:	83 ec 08             	sub    $0x8,%esp
80102419:	6a 01                	push   $0x1
8010241b:	6a 01                	push   $0x1
8010241d:	e8 b4 f4 ff ff       	call   801018d6 <iget>
80102422:	83 c4 10             	add    $0x10,%esp
80102425:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102428:	e9 ba 00 00 00       	jmp    801024e7 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
8010242d:	e8 fe 15 00 00       	call   80103a30 <myproc>
80102432:	8b 40 68             	mov    0x68(%eax),%eax
80102435:	83 ec 0c             	sub    $0xc,%esp
80102438:	50                   	push   %eax
80102439:	e8 7a f5 ff ff       	call   801019b8 <idup>
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102444:	e9 9e 00 00 00       	jmp    801024e7 <namex+0xe1>
    ilock(ip);
80102449:	83 ec 0c             	sub    $0xc,%esp
8010244c:	ff 75 f4             	push   -0xc(%ebp)
8010244f:	e8 9e f5 ff ff       	call   801019f2 <ilock>
80102454:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010245e:	66 83 f8 01          	cmp    $0x1,%ax
80102462:	74 18                	je     8010247c <namex+0x76>
      iunlockput(ip);
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	ff 75 f4             	push   -0xc(%ebp)
8010246a:	e8 b4 f7 ff ff       	call   80101c23 <iunlockput>
8010246f:	83 c4 10             	add    $0x10,%esp
      return 0;
80102472:	b8 00 00 00 00       	mov    $0x0,%eax
80102477:	e9 a7 00 00 00       	jmp    80102523 <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
8010247c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102480:	74 20                	je     801024a2 <namex+0x9c>
80102482:	8b 45 08             	mov    0x8(%ebp),%eax
80102485:	0f b6 00             	movzbl (%eax),%eax
80102488:	84 c0                	test   %al,%al
8010248a:	75 16                	jne    801024a2 <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
8010248c:	83 ec 0c             	sub    $0xc,%esp
8010248f:	ff 75 f4             	push   -0xc(%ebp)
80102492:	e8 6e f6 ff ff       	call   80101b05 <iunlock>
80102497:	83 c4 10             	add    $0x10,%esp
      return ip;
8010249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010249d:	e9 81 00 00 00       	jmp    80102523 <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024a2:	83 ec 04             	sub    $0x4,%esp
801024a5:	6a 00                	push   $0x0
801024a7:	ff 75 10             	push   0x10(%ebp)
801024aa:	ff 75 f4             	push   -0xc(%ebp)
801024ad:	e8 22 fd ff ff       	call   801021d4 <dirlookup>
801024b2:	83 c4 10             	add    $0x10,%esp
801024b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024bc:	75 15                	jne    801024d3 <namex+0xcd>
      iunlockput(ip);
801024be:	83 ec 0c             	sub    $0xc,%esp
801024c1:	ff 75 f4             	push   -0xc(%ebp)
801024c4:	e8 5a f7 ff ff       	call   80101c23 <iunlockput>
801024c9:	83 c4 10             	add    $0x10,%esp
      return 0;
801024cc:	b8 00 00 00 00       	mov    $0x0,%eax
801024d1:	eb 50                	jmp    80102523 <namex+0x11d>
    }
    iunlockput(ip);
801024d3:	83 ec 0c             	sub    $0xc,%esp
801024d6:	ff 75 f4             	push   -0xc(%ebp)
801024d9:	e8 45 f7 ff ff       	call   80101c23 <iunlockput>
801024de:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024e7:	83 ec 08             	sub    $0x8,%esp
801024ea:	ff 75 10             	push   0x10(%ebp)
801024ed:	ff 75 08             	push   0x8(%ebp)
801024f0:	e8 71 fe ff ff       	call   80102366 <skipelem>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	89 45 08             	mov    %eax,0x8(%ebp)
801024fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024ff:	0f 85 44 ff ff ff    	jne    80102449 <namex+0x43>
  }
  if(nameiparent){
80102505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102509:	74 15                	je     80102520 <namex+0x11a>
    iput(ip);
8010250b:	83 ec 0c             	sub    $0xc,%esp
8010250e:	ff 75 f4             	push   -0xc(%ebp)
80102511:	e8 3d f6 ff ff       	call   80101b53 <iput>
80102516:	83 c4 10             	add    $0x10,%esp
    return 0;
80102519:	b8 00 00 00 00       	mov    $0x0,%eax
8010251e:	eb 03                	jmp    80102523 <namex+0x11d>
  }
  return ip;
80102520:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102523:	c9                   	leave
80102524:	c3                   	ret

80102525 <namei>:

struct inode*
namei(char *path)
{
80102525:	55                   	push   %ebp
80102526:	89 e5                	mov    %esp,%ebp
80102528:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010252b:	83 ec 04             	sub    $0x4,%esp
8010252e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102531:	50                   	push   %eax
80102532:	6a 00                	push   $0x0
80102534:	ff 75 08             	push   0x8(%ebp)
80102537:	e8 ca fe ff ff       	call   80102406 <namex>
8010253c:	83 c4 10             	add    $0x10,%esp
}
8010253f:	c9                   	leave
80102540:	c3                   	ret

80102541 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102541:	55                   	push   %ebp
80102542:	89 e5                	mov    %esp,%ebp
80102544:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	ff 75 0c             	push   0xc(%ebp)
8010254d:	6a 01                	push   $0x1
8010254f:	ff 75 08             	push   0x8(%ebp)
80102552:	e8 af fe ff ff       	call   80102406 <namex>
80102557:	83 c4 10             	add    $0x10,%esp
}
8010255a:	c9                   	leave
8010255b:	c3                   	ret

8010255c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010255f:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102564:	8b 55 08             	mov    0x8(%ebp),%edx
80102567:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102569:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010256e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102571:	5d                   	pop    %ebp
80102572:	c3                   	ret

80102573 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102573:	55                   	push   %ebp
80102574:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102576:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010257b:	8b 55 08             	mov    0x8(%ebp),%edx
8010257e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102580:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102585:	8b 55 0c             	mov    0xc(%ebp),%edx
80102588:	89 50 10             	mov    %edx,0x10(%eax)
}
8010258b:	90                   	nop
8010258c:	5d                   	pop    %ebp
8010258d:	c3                   	ret

8010258e <ioapicinit>:

void
ioapicinit(void)
{
8010258e:	55                   	push   %ebp
8010258f:	89 e5                	mov    %esp,%ebp
80102591:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102594:	c7 05 b4 40 19 80 00 	movl   $0xfec00000,0x801940b4
8010259b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010259e:	6a 01                	push   $0x1
801025a0:	e8 b7 ff ff ff       	call   8010255c <ioapicread>
801025a5:	83 c4 04             	add    $0x4,%esp
801025a8:	c1 e8 10             	shr    $0x10,%eax
801025ab:	25 ff 00 00 00       	and    $0xff,%eax
801025b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801025b3:	6a 00                	push   $0x0
801025b5:	e8 a2 ff ff ff       	call   8010255c <ioapicread>
801025ba:	83 c4 04             	add    $0x4,%esp
801025bd:	c1 e8 18             	shr    $0x18,%eax
801025c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801025c3:	0f b6 05 44 6d 19 80 	movzbl 0x80196d44,%eax
801025ca:	0f b6 c0             	movzbl %al,%eax
801025cd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025d0:	74 10                	je     801025e2 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025d2:	83 ec 0c             	sub    $0xc,%esp
801025d5:	68 f4 a3 10 80       	push   $0x8010a3f4
801025da:	e8 15 de ff ff       	call   801003f4 <cprintf>
801025df:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801025e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025e9:	eb 3f                	jmp    8010262a <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ee:	83 c0 20             	add    $0x20,%eax
801025f1:	0d 00 00 01 00       	or     $0x10000,%eax
801025f6:	89 c2                	mov    %eax,%edx
801025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025fb:	83 c0 08             	add    $0x8,%eax
801025fe:	01 c0                	add    %eax,%eax
80102600:	83 ec 08             	sub    $0x8,%esp
80102603:	52                   	push   %edx
80102604:	50                   	push   %eax
80102605:	e8 69 ff ff ff       	call   80102573 <ioapicwrite>
8010260a:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102610:	83 c0 08             	add    $0x8,%eax
80102613:	01 c0                	add    %eax,%eax
80102615:	83 c0 01             	add    $0x1,%eax
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	6a 00                	push   $0x0
8010261d:	50                   	push   %eax
8010261e:	e8 50 ff ff ff       	call   80102573 <ioapicwrite>
80102623:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102626:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010262d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102630:	7e b9                	jle    801025eb <ioapicinit+0x5d>
  }
}
80102632:	90                   	nop
80102633:	90                   	nop
80102634:	c9                   	leave
80102635:	c3                   	ret

80102636 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102636:	55                   	push   %ebp
80102637:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102639:	8b 45 08             	mov    0x8(%ebp),%eax
8010263c:	83 c0 20             	add    $0x20,%eax
8010263f:	89 c2                	mov    %eax,%edx
80102641:	8b 45 08             	mov    0x8(%ebp),%eax
80102644:	83 c0 08             	add    $0x8,%eax
80102647:	01 c0                	add    %eax,%eax
80102649:	52                   	push   %edx
8010264a:	50                   	push   %eax
8010264b:	e8 23 ff ff ff       	call   80102573 <ioapicwrite>
80102650:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102653:	8b 45 0c             	mov    0xc(%ebp),%eax
80102656:	c1 e0 18             	shl    $0x18,%eax
80102659:	89 c2                	mov    %eax,%edx
8010265b:	8b 45 08             	mov    0x8(%ebp),%eax
8010265e:	83 c0 08             	add    $0x8,%eax
80102661:	01 c0                	add    %eax,%eax
80102663:	83 c0 01             	add    $0x1,%eax
80102666:	52                   	push   %edx
80102667:	50                   	push   %eax
80102668:	e8 06 ff ff ff       	call   80102573 <ioapicwrite>
8010266d:	83 c4 08             	add    $0x8,%esp
}
80102670:	90                   	nop
80102671:	c9                   	leave
80102672:	c3                   	ret

80102673 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102673:	55                   	push   %ebp
80102674:	89 e5                	mov    %esp,%ebp
80102676:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102679:	83 ec 08             	sub    $0x8,%esp
8010267c:	68 26 a4 10 80       	push   $0x8010a426
80102681:	68 c0 40 19 80       	push   $0x801940c0
80102686:	e8 9b 22 00 00       	call   80104926 <initlock>
8010268b:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
8010268e:	c7 05 f4 40 19 80 00 	movl   $0x0,0x801940f4
80102695:	00 00 00 
  freerange(vstart, vend);
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	ff 75 0c             	push   0xc(%ebp)
8010269e:	ff 75 08             	push   0x8(%ebp)
801026a1:	e8 2a 00 00 00       	call   801026d0 <freerange>
801026a6:	83 c4 10             	add    $0x10,%esp
}
801026a9:	90                   	nop
801026aa:	c9                   	leave
801026ab:	c3                   	ret

801026ac <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801026ac:	55                   	push   %ebp
801026ad:	89 e5                	mov    %esp,%ebp
801026af:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
801026b2:	83 ec 08             	sub    $0x8,%esp
801026b5:	ff 75 0c             	push   0xc(%ebp)
801026b8:	ff 75 08             	push   0x8(%ebp)
801026bb:	e8 10 00 00 00       	call   801026d0 <freerange>
801026c0:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
801026c3:	c7 05 f4 40 19 80 01 	movl   $0x1,0x801940f4
801026ca:	00 00 00 
}
801026cd:	90                   	nop
801026ce:	c9                   	leave
801026cf:	c3                   	ret

801026d0 <freerange>:

void
freerange(void *vstart, void *vend)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801026d6:	8b 45 08             	mov    0x8(%ebp),%eax
801026d9:	05 ff 0f 00 00       	add    $0xfff,%eax
801026de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e6:	eb 15                	jmp    801026fd <freerange+0x2d>
    kfree(p);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	ff 75 f4             	push   -0xc(%ebp)
801026ee:	e8 1b 00 00 00       	call   8010270e <kfree>
801026f3:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102700:	05 00 10 00 00       	add    $0x1000,%eax
80102705:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102708:	73 de                	jae    801026e8 <freerange+0x18>
}
8010270a:	90                   	nop
8010270b:	90                   	nop
8010270c:	c9                   	leave
8010270d:	c3                   	ret

8010270e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010270e:	55                   	push   %ebp
8010270f:	89 e5                	mov    %esp,%ebp
80102711:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102714:	8b 45 08             	mov    0x8(%ebp),%eax
80102717:	25 ff 0f 00 00       	and    $0xfff,%eax
8010271c:	85 c0                	test   %eax,%eax
8010271e:	75 18                	jne    80102738 <kfree+0x2a>
80102720:	81 7d 08 00 90 19 80 	cmpl   $0x80199000,0x8(%ebp)
80102727:	72 0f                	jb     80102738 <kfree+0x2a>
80102729:	8b 45 08             	mov    0x8(%ebp),%eax
8010272c:	05 00 00 00 80       	add    $0x80000000,%eax
80102731:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80102736:	76 0d                	jbe    80102745 <kfree+0x37>
    panic("kfree");
80102738:	83 ec 0c             	sub    $0xc,%esp
8010273b:	68 2b a4 10 80       	push   $0x8010a42b
80102740:	e8 64 de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102745:	83 ec 04             	sub    $0x4,%esp
80102748:	68 00 10 00 00       	push   $0x1000
8010274d:	6a 01                	push   $0x1
8010274f:	ff 75 08             	push   0x8(%ebp)
80102752:	e8 67 24 00 00       	call   80104bbe <memset>
80102757:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
8010275a:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010275f:	85 c0                	test   %eax,%eax
80102761:	74 10                	je     80102773 <kfree+0x65>
    acquire(&kmem.lock);
80102763:	83 ec 0c             	sub    $0xc,%esp
80102766:	68 c0 40 19 80       	push   $0x801940c0
8010276b:	e8 d8 21 00 00       	call   80104948 <acquire>
80102770:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102773:	8b 45 08             	mov    0x8(%ebp),%eax
80102776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102779:	8b 15 f8 40 19 80    	mov    0x801940f8,%edx
8010277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102782:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102787:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
8010278c:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102791:	85 c0                	test   %eax,%eax
80102793:	74 10                	je     801027a5 <kfree+0x97>
    release(&kmem.lock);
80102795:	83 ec 0c             	sub    $0xc,%esp
80102798:	68 c0 40 19 80       	push   $0x801940c0
8010279d:	e8 14 22 00 00       	call   801049b6 <release>
801027a2:	83 c4 10             	add    $0x10,%esp
}
801027a5:	90                   	nop
801027a6:	c9                   	leave
801027a7:	c3                   	ret

801027a8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027a8:	55                   	push   %ebp
801027a9:	89 e5                	mov    %esp,%ebp
801027ab:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
801027ae:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027b3:	85 c0                	test   %eax,%eax
801027b5:	74 10                	je     801027c7 <kalloc+0x1f>
    acquire(&kmem.lock);
801027b7:	83 ec 0c             	sub    $0xc,%esp
801027ba:	68 c0 40 19 80       	push   $0x801940c0
801027bf:	e8 84 21 00 00       	call   80104948 <acquire>
801027c4:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
801027c7:	a1 f8 40 19 80       	mov    0x801940f8,%eax
801027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
801027cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027d3:	74 0a                	je     801027df <kalloc+0x37>
    kmem.freelist = r->next;
801027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d8:	8b 00                	mov    (%eax),%eax
801027da:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
801027df:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027e4:	85 c0                	test   %eax,%eax
801027e6:	74 10                	je     801027f8 <kalloc+0x50>
    release(&kmem.lock);
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	68 c0 40 19 80       	push   $0x801940c0
801027f0:	e8 c1 21 00 00       	call   801049b6 <release>
801027f5:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027fb:	c9                   	leave
801027fc:	c3                   	ret

801027fd <inb>:
{
801027fd:	55                   	push   %ebp
801027fe:	89 e5                	mov    %esp,%ebp
80102800:	83 ec 14             	sub    $0x14,%esp
80102803:	8b 45 08             	mov    0x8(%ebp),%eax
80102806:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010280e:	89 c2                	mov    %eax,%edx
80102810:	ec                   	in     (%dx),%al
80102811:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102814:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102818:	c9                   	leave
80102819:	c3                   	ret

8010281a <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
8010281a:	55                   	push   %ebp
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102820:	6a 64                	push   $0x64
80102822:	e8 d6 ff ff ff       	call   801027fd <inb>
80102827:	83 c4 04             	add    $0x4,%esp
8010282a:	0f b6 c0             	movzbl %al,%eax
8010282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102833:	83 e0 01             	and    $0x1,%eax
80102836:	85 c0                	test   %eax,%eax
80102838:	75 0a                	jne    80102844 <kbdgetc+0x2a>
    return -1;
8010283a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010283f:	e9 23 01 00 00       	jmp    80102967 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102844:	6a 60                	push   $0x60
80102846:	e8 b2 ff ff ff       	call   801027fd <inb>
8010284b:	83 c4 04             	add    $0x4,%esp
8010284e:	0f b6 c0             	movzbl %al,%eax
80102851:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102854:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010285b:	75 17                	jne    80102874 <kbdgetc+0x5a>
    shift |= E0ESC;
8010285d:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102862:	83 c8 40             	or     $0x40,%eax
80102865:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
8010286a:	b8 00 00 00 00       	mov    $0x0,%eax
8010286f:	e9 f3 00 00 00       	jmp    80102967 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102874:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102877:	25 80 00 00 00       	and    $0x80,%eax
8010287c:	85 c0                	test   %eax,%eax
8010287e:	74 45                	je     801028c5 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102880:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102885:	83 e0 40             	and    $0x40,%eax
80102888:	85 c0                	test   %eax,%eax
8010288a:	75 08                	jne    80102894 <kbdgetc+0x7a>
8010288c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010288f:	83 e0 7f             	and    $0x7f,%eax
80102892:	eb 03                	jmp    80102897 <kbdgetc+0x7d>
80102894:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102897:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010289a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010289d:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028a2:	0f b6 00             	movzbl (%eax),%eax
801028a5:	83 c8 40             	or     $0x40,%eax
801028a8:	0f b6 c0             	movzbl %al,%eax
801028ab:	f7 d0                	not    %eax
801028ad:	89 c2                	mov    %eax,%edx
801028af:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028b4:	21 d0                	and    %edx,%eax
801028b6:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
801028bb:	b8 00 00 00 00       	mov    $0x0,%eax
801028c0:	e9 a2 00 00 00       	jmp    80102967 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801028c5:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028ca:	83 e0 40             	and    $0x40,%eax
801028cd:	85 c0                	test   %eax,%eax
801028cf:	74 14                	je     801028e5 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028d1:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801028d8:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028dd:	83 e0 bf             	and    $0xffffffbf,%eax
801028e0:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  }

  shift |= shiftcode[data];
801028e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028e8:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028ed:	0f b6 00             	movzbl (%eax),%eax
801028f0:	0f b6 d0             	movzbl %al,%edx
801028f3:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028f8:	09 d0                	or     %edx,%eax
801028fa:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  shift ^= togglecode[data];
801028ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102902:	05 20 d1 10 80       	add    $0x8010d120,%eax
80102907:	0f b6 00             	movzbl (%eax),%eax
8010290a:	0f b6 d0             	movzbl %al,%edx
8010290d:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102912:	31 d0                	xor    %edx,%eax
80102914:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102919:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010291e:	83 e0 03             	and    $0x3,%eax
80102921:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010292b:	01 d0                	add    %edx,%eax
8010292d:	0f b6 00             	movzbl (%eax),%eax
80102930:	0f b6 c0             	movzbl %al,%eax
80102933:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102936:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010293b:	83 e0 08             	and    $0x8,%eax
8010293e:	85 c0                	test   %eax,%eax
80102940:	74 22                	je     80102964 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102942:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102946:	76 0c                	jbe    80102954 <kbdgetc+0x13a>
80102948:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
8010294c:	77 06                	ja     80102954 <kbdgetc+0x13a>
      c += 'A' - 'a';
8010294e:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102952:	eb 10                	jmp    80102964 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102954:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102958:	76 0a                	jbe    80102964 <kbdgetc+0x14a>
8010295a:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
8010295e:	77 04                	ja     80102964 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102960:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102964:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102967:	c9                   	leave
80102968:	c3                   	ret

80102969 <kbdintr>:

void
kbdintr(void)
{
80102969:	55                   	push   %ebp
8010296a:	89 e5                	mov    %esp,%ebp
8010296c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
8010296f:	83 ec 0c             	sub    $0xc,%esp
80102972:	68 1a 28 10 80       	push   $0x8010281a
80102977:	e8 5a de ff ff       	call   801007d6 <consoleintr>
8010297c:	83 c4 10             	add    $0x10,%esp
}
8010297f:	90                   	nop
80102980:	c9                   	leave
80102981:	c3                   	ret

80102982 <inb>:
{
80102982:	55                   	push   %ebp
80102983:	89 e5                	mov    %esp,%ebp
80102985:	83 ec 14             	sub    $0x14,%esp
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
8010298b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102993:	89 c2                	mov    %eax,%edx
80102995:	ec                   	in     (%dx),%al
80102996:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102999:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010299d:	c9                   	leave
8010299e:	c3                   	ret

8010299f <outb>:
{
8010299f:	55                   	push   %ebp
801029a0:	89 e5                	mov    %esp,%ebp
801029a2:	83 ec 08             	sub    $0x8,%esp
801029a5:	8b 55 08             	mov    0x8(%ebp),%edx
801029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ab:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801029af:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801029b6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801029ba:	ee                   	out    %al,(%dx)
}
801029bb:	90                   	nop
801029bc:	c9                   	leave
801029bd:	c3                   	ret

801029be <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801029c1:	a1 00 41 19 80       	mov    0x80194100,%eax
801029c6:	8b 55 08             	mov    0x8(%ebp),%edx
801029c9:	c1 e2 02             	shl    $0x2,%edx
801029cc:	01 c2                	add    %eax,%edx
801029ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d1:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801029d3:	a1 00 41 19 80       	mov    0x80194100,%eax
801029d8:	83 c0 20             	add    $0x20,%eax
801029db:	8b 00                	mov    (%eax),%eax
}
801029dd:	90                   	nop
801029de:	5d                   	pop    %ebp
801029df:	c3                   	ret

801029e0 <lapicinit>:

void
lapicinit(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029e3:	a1 00 41 19 80       	mov    0x80194100,%eax
801029e8:	85 c0                	test   %eax,%eax
801029ea:	0f 84 09 01 00 00    	je     80102af9 <lapicinit+0x119>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801029f0:	68 3f 01 00 00       	push   $0x13f
801029f5:	6a 3c                	push   $0x3c
801029f7:	e8 c2 ff ff ff       	call   801029be <lapicw>
801029fc:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801029ff:	6a 0b                	push   $0xb
80102a01:	68 f8 00 00 00       	push   $0xf8
80102a06:	e8 b3 ff ff ff       	call   801029be <lapicw>
80102a0b:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102a0e:	68 20 00 02 00       	push   $0x20020
80102a13:	68 c8 00 00 00       	push   $0xc8
80102a18:	e8 a1 ff ff ff       	call   801029be <lapicw>
80102a1d:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102a20:	68 80 96 98 00       	push   $0x989680
80102a25:	68 e0 00 00 00       	push   $0xe0
80102a2a:	e8 8f ff ff ff       	call   801029be <lapicw>
80102a2f:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102a32:	68 00 00 01 00       	push   $0x10000
80102a37:	68 d4 00 00 00       	push   $0xd4
80102a3c:	e8 7d ff ff ff       	call   801029be <lapicw>
80102a41:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102a44:	68 00 00 01 00       	push   $0x10000
80102a49:	68 d8 00 00 00       	push   $0xd8
80102a4e:	e8 6b ff ff ff       	call   801029be <lapicw>
80102a53:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a56:	a1 00 41 19 80       	mov    0x80194100,%eax
80102a5b:	83 c0 30             	add    $0x30,%eax
80102a5e:	8b 00                	mov    (%eax),%eax
80102a60:	25 00 00 fc 00       	and    $0xfc0000,%eax
80102a65:	85 c0                	test   %eax,%eax
80102a67:	74 12                	je     80102a7b <lapicinit+0x9b>
    lapicw(PCINT, MASKED);
80102a69:	68 00 00 01 00       	push   $0x10000
80102a6e:	68 d0 00 00 00       	push   $0xd0
80102a73:	e8 46 ff ff ff       	call   801029be <lapicw>
80102a78:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102a7b:	6a 33                	push   $0x33
80102a7d:	68 dc 00 00 00       	push   $0xdc
80102a82:	e8 37 ff ff ff       	call   801029be <lapicw>
80102a87:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102a8a:	6a 00                	push   $0x0
80102a8c:	68 a0 00 00 00       	push   $0xa0
80102a91:	e8 28 ff ff ff       	call   801029be <lapicw>
80102a96:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102a99:	6a 00                	push   $0x0
80102a9b:	68 a0 00 00 00       	push   $0xa0
80102aa0:	e8 19 ff ff ff       	call   801029be <lapicw>
80102aa5:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102aa8:	6a 00                	push   $0x0
80102aaa:	6a 2c                	push   $0x2c
80102aac:	e8 0d ff ff ff       	call   801029be <lapicw>
80102ab1:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ab4:	6a 00                	push   $0x0
80102ab6:	68 c4 00 00 00       	push   $0xc4
80102abb:	e8 fe fe ff ff       	call   801029be <lapicw>
80102ac0:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ac3:	68 00 85 08 00       	push   $0x88500
80102ac8:	68 c0 00 00 00       	push   $0xc0
80102acd:	e8 ec fe ff ff       	call   801029be <lapicw>
80102ad2:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ad5:	90                   	nop
80102ad6:	a1 00 41 19 80       	mov    0x80194100,%eax
80102adb:	05 00 03 00 00       	add    $0x300,%eax
80102ae0:	8b 00                	mov    (%eax),%eax
80102ae2:	25 00 10 00 00       	and    $0x1000,%eax
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	75 eb                	jne    80102ad6 <lapicinit+0xf6>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102aeb:	6a 00                	push   $0x0
80102aed:	6a 20                	push   $0x20
80102aef:	e8 ca fe ff ff       	call   801029be <lapicw>
80102af4:	83 c4 08             	add    $0x8,%esp
80102af7:	eb 01                	jmp    80102afa <lapicinit+0x11a>
    return;
80102af9:	90                   	nop
}
80102afa:	c9                   	leave
80102afb:	c3                   	ret

80102afc <lapicid>:

int
lapicid(void)
{
80102afc:	55                   	push   %ebp
80102afd:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102aff:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b04:	85 c0                	test   %eax,%eax
80102b06:	75 07                	jne    80102b0f <lapicid+0x13>
    return 0;
80102b08:	b8 00 00 00 00       	mov    $0x0,%eax
80102b0d:	eb 0d                	jmp    80102b1c <lapicid+0x20>
  }
  return lapic[ID] >> 24;
80102b0f:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b14:	83 c0 20             	add    $0x20,%eax
80102b17:	8b 00                	mov    (%eax),%eax
80102b19:	c1 e8 18             	shr    $0x18,%eax
}
80102b1c:	5d                   	pop    %ebp
80102b1d:	c3                   	ret

80102b1e <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b1e:	55                   	push   %ebp
80102b1f:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b21:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b26:	85 c0                	test   %eax,%eax
80102b28:	74 0c                	je     80102b36 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102b2a:	6a 00                	push   $0x0
80102b2c:	6a 2c                	push   $0x2c
80102b2e:	e8 8b fe ff ff       	call   801029be <lapicw>
80102b33:	83 c4 08             	add    $0x8,%esp
}
80102b36:	90                   	nop
80102b37:	c9                   	leave
80102b38:	c3                   	ret

80102b39 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b39:	55                   	push   %ebp
80102b3a:	89 e5                	mov    %esp,%ebp
}
80102b3c:	90                   	nop
80102b3d:	5d                   	pop    %ebp
80102b3e:	c3                   	ret

80102b3f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b3f:	55                   	push   %ebp
80102b40:	89 e5                	mov    %esp,%ebp
80102b42:	83 ec 14             	sub    $0x14,%esp
80102b45:	8b 45 08             	mov    0x8(%ebp),%eax
80102b48:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102b4b:	6a 0f                	push   $0xf
80102b4d:	6a 70                	push   $0x70
80102b4f:	e8 4b fe ff ff       	call   8010299f <outb>
80102b54:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102b57:	6a 0a                	push   $0xa
80102b59:	6a 71                	push   $0x71
80102b5b:	e8 3f fe ff ff       	call   8010299f <outb>
80102b60:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102b63:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102b6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b6d:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102b72:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b75:	c1 e8 04             	shr    $0x4,%eax
80102b78:	89 c2                	mov    %eax,%edx
80102b7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b7d:	83 c0 02             	add    $0x2,%eax
80102b80:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b83:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102b87:	c1 e0 18             	shl    $0x18,%eax
80102b8a:	50                   	push   %eax
80102b8b:	68 c4 00 00 00       	push   $0xc4
80102b90:	e8 29 fe ff ff       	call   801029be <lapicw>
80102b95:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102b98:	68 00 c5 00 00       	push   $0xc500
80102b9d:	68 c0 00 00 00       	push   $0xc0
80102ba2:	e8 17 fe ff ff       	call   801029be <lapicw>
80102ba7:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102baa:	68 c8 00 00 00       	push   $0xc8
80102baf:	e8 85 ff ff ff       	call   80102b39 <microdelay>
80102bb4:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102bb7:	68 00 85 00 00       	push   $0x8500
80102bbc:	68 c0 00 00 00       	push   $0xc0
80102bc1:	e8 f8 fd ff ff       	call   801029be <lapicw>
80102bc6:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102bc9:	6a 64                	push   $0x64
80102bcb:	e8 69 ff ff ff       	call   80102b39 <microdelay>
80102bd0:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102bd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102bda:	eb 3d                	jmp    80102c19 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80102bdc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102be0:	c1 e0 18             	shl    $0x18,%eax
80102be3:	50                   	push   %eax
80102be4:	68 c4 00 00 00       	push   $0xc4
80102be9:	e8 d0 fd ff ff       	call   801029be <lapicw>
80102bee:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bf4:	c1 e8 0c             	shr    $0xc,%eax
80102bf7:	80 cc 06             	or     $0x6,%ah
80102bfa:	50                   	push   %eax
80102bfb:	68 c0 00 00 00       	push   $0xc0
80102c00:	e8 b9 fd ff ff       	call   801029be <lapicw>
80102c05:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102c08:	68 c8 00 00 00       	push   $0xc8
80102c0d:	e8 27 ff ff ff       	call   80102b39 <microdelay>
80102c12:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80102c15:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102c19:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102c1d:	7e bd                	jle    80102bdc <lapicstartap+0x9d>
  }
}
80102c1f:	90                   	nop
80102c20:	90                   	nop
80102c21:	c9                   	leave
80102c22:	c3                   	ret

80102c23 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102c23:	55                   	push   %ebp
80102c24:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80102c26:	8b 45 08             	mov    0x8(%ebp),%eax
80102c29:	0f b6 c0             	movzbl %al,%eax
80102c2c:	50                   	push   %eax
80102c2d:	6a 70                	push   $0x70
80102c2f:	e8 6b fd ff ff       	call   8010299f <outb>
80102c34:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102c37:	68 c8 00 00 00       	push   $0xc8
80102c3c:	e8 f8 fe ff ff       	call   80102b39 <microdelay>
80102c41:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80102c44:	6a 71                	push   $0x71
80102c46:	e8 37 fd ff ff       	call   80102982 <inb>
80102c4b:	83 c4 04             	add    $0x4,%esp
80102c4e:	0f b6 c0             	movzbl %al,%eax
}
80102c51:	c9                   	leave
80102c52:	c3                   	ret

80102c53 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102c53:	55                   	push   %ebp
80102c54:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80102c56:	6a 00                	push   $0x0
80102c58:	e8 c6 ff ff ff       	call   80102c23 <cmos_read>
80102c5d:	83 c4 04             	add    $0x4,%esp
80102c60:	8b 55 08             	mov    0x8(%ebp),%edx
80102c63:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80102c65:	6a 02                	push   $0x2
80102c67:	e8 b7 ff ff ff       	call   80102c23 <cmos_read>
80102c6c:	83 c4 04             	add    $0x4,%esp
80102c6f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c72:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80102c75:	6a 04                	push   $0x4
80102c77:	e8 a7 ff ff ff       	call   80102c23 <cmos_read>
80102c7c:	83 c4 04             	add    $0x4,%esp
80102c7f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c82:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80102c85:	6a 07                	push   $0x7
80102c87:	e8 97 ff ff ff       	call   80102c23 <cmos_read>
80102c8c:	83 c4 04             	add    $0x4,%esp
80102c8f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c92:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80102c95:	6a 08                	push   $0x8
80102c97:	e8 87 ff ff ff       	call   80102c23 <cmos_read>
80102c9c:	83 c4 04             	add    $0x4,%esp
80102c9f:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca2:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80102ca5:	6a 09                	push   $0x9
80102ca7:	e8 77 ff ff ff       	call   80102c23 <cmos_read>
80102cac:	83 c4 04             	add    $0x4,%esp
80102caf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cb2:	89 42 14             	mov    %eax,0x14(%edx)
}
80102cb5:	90                   	nop
80102cb6:	c9                   	leave
80102cb7:	c3                   	ret

80102cb8 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102cb8:	55                   	push   %ebp
80102cb9:	89 e5                	mov    %esp,%ebp
80102cbb:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102cbe:	6a 0b                	push   $0xb
80102cc0:	e8 5e ff ff ff       	call   80102c23 <cmos_read>
80102cc5:	83 c4 04             	add    $0x4,%esp
80102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80102ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cce:	83 e0 04             	and    $0x4,%eax
80102cd1:	85 c0                	test   %eax,%eax
80102cd3:	0f 94 c0             	sete   %al
80102cd6:	0f b6 c0             	movzbl %al,%eax
80102cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102cdc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cdf:	50                   	push   %eax
80102ce0:	e8 6e ff ff ff       	call   80102c53 <fill_rtcdate>
80102ce5:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ce8:	6a 0a                	push   $0xa
80102cea:	e8 34 ff ff ff       	call   80102c23 <cmos_read>
80102cef:	83 c4 04             	add    $0x4,%esp
80102cf2:	25 80 00 00 00       	and    $0x80,%eax
80102cf7:	85 c0                	test   %eax,%eax
80102cf9:	75 27                	jne    80102d22 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80102cfb:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102cfe:	50                   	push   %eax
80102cff:	e8 4f ff ff ff       	call   80102c53 <fill_rtcdate>
80102d04:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d07:	83 ec 04             	sub    $0x4,%esp
80102d0a:	6a 18                	push   $0x18
80102d0c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102d0f:	50                   	push   %eax
80102d10:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102d13:	50                   	push   %eax
80102d14:	e8 0c 1f 00 00       	call   80104c25 <memcmp>
80102d19:	83 c4 10             	add    $0x10,%esp
80102d1c:	85 c0                	test   %eax,%eax
80102d1e:	74 05                	je     80102d25 <cmostime+0x6d>
80102d20:	eb ba                	jmp    80102cdc <cmostime+0x24>
        continue;
80102d22:	90                   	nop
    fill_rtcdate(&t1);
80102d23:	eb b7                	jmp    80102cdc <cmostime+0x24>
      break;
80102d25:	90                   	nop
  }

  // convert
  if(bcd) {
80102d26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102d2a:	0f 84 b4 00 00 00    	je     80102de4 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d30:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d33:	c1 e8 04             	shr    $0x4,%eax
80102d36:	89 c2                	mov    %eax,%edx
80102d38:	89 d0                	mov    %edx,%eax
80102d3a:	c1 e0 02             	shl    $0x2,%eax
80102d3d:	01 d0                	add    %edx,%eax
80102d3f:	01 c0                	add    %eax,%eax
80102d41:	89 c2                	mov    %eax,%edx
80102d43:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d46:	83 e0 0f             	and    $0xf,%eax
80102d49:	01 d0                	add    %edx,%eax
80102d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80102d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d51:	c1 e8 04             	shr    $0x4,%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	89 d0                	mov    %edx,%eax
80102d58:	c1 e0 02             	shl    $0x2,%eax
80102d5b:	01 d0                	add    %edx,%eax
80102d5d:	01 c0                	add    %eax,%eax
80102d5f:	89 c2                	mov    %eax,%edx
80102d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d64:	83 e0 0f             	and    $0xf,%eax
80102d67:	01 d0                	add    %edx,%eax
80102d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80102d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d6f:	c1 e8 04             	shr    $0x4,%eax
80102d72:	89 c2                	mov    %eax,%edx
80102d74:	89 d0                	mov    %edx,%eax
80102d76:	c1 e0 02             	shl    $0x2,%eax
80102d79:	01 d0                	add    %edx,%eax
80102d7b:	01 c0                	add    %eax,%eax
80102d7d:	89 c2                	mov    %eax,%edx
80102d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d82:	83 e0 0f             	and    $0xf,%eax
80102d85:	01 d0                	add    %edx,%eax
80102d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80102d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d8d:	c1 e8 04             	shr    $0x4,%eax
80102d90:	89 c2                	mov    %eax,%edx
80102d92:	89 d0                	mov    %edx,%eax
80102d94:	c1 e0 02             	shl    $0x2,%eax
80102d97:	01 d0                	add    %edx,%eax
80102d99:	01 c0                	add    %eax,%eax
80102d9b:	89 c2                	mov    %eax,%edx
80102d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102da0:	83 e0 0f             	and    $0xf,%eax
80102da3:	01 d0                	add    %edx,%eax
80102da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80102da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dab:	c1 e8 04             	shr    $0x4,%eax
80102dae:	89 c2                	mov    %eax,%edx
80102db0:	89 d0                	mov    %edx,%eax
80102db2:	c1 e0 02             	shl    $0x2,%eax
80102db5:	01 d0                	add    %edx,%eax
80102db7:	01 c0                	add    %eax,%eax
80102db9:	89 c2                	mov    %eax,%edx
80102dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dbe:	83 e0 0f             	and    $0xf,%eax
80102dc1:	01 d0                	add    %edx,%eax
80102dc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80102dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dc9:	c1 e8 04             	shr    $0x4,%eax
80102dcc:	89 c2                	mov    %eax,%edx
80102dce:	89 d0                	mov    %edx,%eax
80102dd0:	c1 e0 02             	shl    $0x2,%eax
80102dd3:	01 d0                	add    %edx,%eax
80102dd5:	01 c0                	add    %eax,%eax
80102dd7:	89 c2                	mov    %eax,%edx
80102dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ddc:	83 e0 0f             	and    $0xf,%eax
80102ddf:	01 d0                	add    %edx,%eax
80102de1:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80102de4:	8b 45 08             	mov    0x8(%ebp),%eax
80102de7:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102dea:	89 10                	mov    %edx,(%eax)
80102dec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102def:	89 50 04             	mov    %edx,0x4(%eax)
80102df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102df5:	89 50 08             	mov    %edx,0x8(%eax)
80102df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102dfb:	89 50 0c             	mov    %edx,0xc(%eax)
80102dfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102e01:	89 50 10             	mov    %edx,0x10(%eax)
80102e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102e07:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80102e0a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0d:	8b 40 14             	mov    0x14(%eax),%eax
80102e10:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102e16:	8b 45 08             	mov    0x8(%ebp),%eax
80102e19:	89 50 14             	mov    %edx,0x14(%eax)
}
80102e1c:	90                   	nop
80102e1d:	c9                   	leave
80102e1e:	c3                   	ret

80102e1f <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e1f:	55                   	push   %ebp
80102e20:	89 e5                	mov    %esp,%ebp
80102e22:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e25:	83 ec 08             	sub    $0x8,%esp
80102e28:	68 31 a4 10 80       	push   $0x8010a431
80102e2d:	68 20 41 19 80       	push   $0x80194120
80102e32:	e8 ef 1a 00 00       	call   80104926 <initlock>
80102e37:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80102e3a:	83 ec 08             	sub    $0x8,%esp
80102e3d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e40:	50                   	push   %eax
80102e41:	ff 75 08             	push   0x8(%ebp)
80102e44:	e8 8f e5 ff ff       	call   801013d8 <readsb>
80102e49:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80102e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e4f:	a3 54 41 19 80       	mov    %eax,0x80194154
  log.size = sb.nlog;
80102e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102e57:	a3 58 41 19 80       	mov    %eax,0x80194158
  log.dev = dev;
80102e5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102e5f:	a3 64 41 19 80       	mov    %eax,0x80194164
  recover_from_log();
80102e64:	e8 b3 01 00 00       	call   8010301c <recover_from_log>
}
80102e69:	90                   	nop
80102e6a:	c9                   	leave
80102e6b:	c3                   	ret

80102e6c <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e6c:	55                   	push   %ebp
80102e6d:	89 e5                	mov    %esp,%ebp
80102e6f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e79:	e9 95 00 00 00       	jmp    80102f13 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e7e:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80102e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e87:	01 d0                	add    %edx,%eax
80102e89:	83 c0 01             	add    $0x1,%eax
80102e8c:	89 c2                	mov    %eax,%edx
80102e8e:	a1 64 41 19 80       	mov    0x80194164,%eax
80102e93:	83 ec 08             	sub    $0x8,%esp
80102e96:	52                   	push   %edx
80102e97:	50                   	push   %eax
80102e98:	e8 64 d3 ff ff       	call   80100201 <bread>
80102e9d:	83 c4 10             	add    $0x10,%esp
80102ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ea6:	83 c0 10             	add    $0x10,%eax
80102ea9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
80102eb0:	89 c2                	mov    %eax,%edx
80102eb2:	a1 64 41 19 80       	mov    0x80194164,%eax
80102eb7:	83 ec 08             	sub    $0x8,%esp
80102eba:	52                   	push   %edx
80102ebb:	50                   	push   %eax
80102ebc:	e8 40 d3 ff ff       	call   80100201 <bread>
80102ec1:	83 c4 10             	add    $0x10,%esp
80102ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102eca:	8d 50 5c             	lea    0x5c(%eax),%edx
80102ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ed0:	83 c0 5c             	add    $0x5c,%eax
80102ed3:	83 ec 04             	sub    $0x4,%esp
80102ed6:	68 00 02 00 00       	push   $0x200
80102edb:	52                   	push   %edx
80102edc:	50                   	push   %eax
80102edd:	e8 9b 1d 00 00       	call   80104c7d <memmove>
80102ee2:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80102ee5:	83 ec 0c             	sub    $0xc,%esp
80102ee8:	ff 75 ec             	push   -0x14(%ebp)
80102eeb:	e8 4a d3 ff ff       	call   8010023a <bwrite>
80102ef0:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80102ef3:	83 ec 0c             	sub    $0xc,%esp
80102ef6:	ff 75 f0             	push   -0x10(%ebp)
80102ef9:	e8 85 d3 ff ff       	call   80100283 <brelse>
80102efe:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80102f01:	83 ec 0c             	sub    $0xc,%esp
80102f04:	ff 75 ec             	push   -0x14(%ebp)
80102f07:	e8 77 d3 ff ff       	call   80100283 <brelse>
80102f0c:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f13:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f18:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f1b:	0f 8c 5d ff ff ff    	jl     80102e7e <install_trans+0x12>
  }
}
80102f21:	90                   	nop
80102f22:	90                   	nop
80102f23:	c9                   	leave
80102f24:	c3                   	ret

80102f25 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102f25:	55                   	push   %ebp
80102f26:	89 e5                	mov    %esp,%ebp
80102f28:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f2b:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f30:	89 c2                	mov    %eax,%edx
80102f32:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f37:	83 ec 08             	sub    $0x8,%esp
80102f3a:	52                   	push   %edx
80102f3b:	50                   	push   %eax
80102f3c:	e8 c0 d2 ff ff       	call   80100201 <bread>
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80102f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f4a:	83 c0 5c             	add    $0x5c,%eax
80102f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80102f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f53:	8b 00                	mov    (%eax),%eax
80102f55:	a3 68 41 19 80       	mov    %eax,0x80194168
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f61:	eb 1b                	jmp    80102f7e <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80102f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f69:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f70:	83 c2 10             	add    $0x10,%edx
80102f73:	89 04 95 2c 41 19 80 	mov    %eax,-0x7fe6bed4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f7e:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f83:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f86:	7c db                	jl     80102f63 <read_head+0x3e>
  }
  brelse(buf);
80102f88:	83 ec 0c             	sub    $0xc,%esp
80102f8b:	ff 75 f0             	push   -0x10(%ebp)
80102f8e:	e8 f0 d2 ff ff       	call   80100283 <brelse>
80102f93:	83 c4 10             	add    $0x10,%esp
}
80102f96:	90                   	nop
80102f97:	c9                   	leave
80102f98:	c3                   	ret

80102f99 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f99:	55                   	push   %ebp
80102f9a:	89 e5                	mov    %esp,%ebp
80102f9c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f9f:	a1 54 41 19 80       	mov    0x80194154,%eax
80102fa4:	89 c2                	mov    %eax,%edx
80102fa6:	a1 64 41 19 80       	mov    0x80194164,%eax
80102fab:	83 ec 08             	sub    $0x8,%esp
80102fae:	52                   	push   %edx
80102faf:	50                   	push   %eax
80102fb0:	e8 4c d2 ff ff       	call   80100201 <bread>
80102fb5:	83 c4 10             	add    $0x10,%esp
80102fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80102fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102fbe:	83 c0 5c             	add    $0x5c,%eax
80102fc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80102fc4:	8b 15 68 41 19 80    	mov    0x80194168,%edx
80102fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fcd:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fd6:	eb 1b                	jmp    80102ff3 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80102fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fdb:	83 c0 10             	add    $0x10,%eax
80102fde:	8b 0c 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%ecx
80102fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102feb:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ff3:	a1 68 41 19 80       	mov    0x80194168,%eax
80102ff8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102ffb:	7c db                	jl     80102fd8 <write_head+0x3f>
  }
  bwrite(buf);
80102ffd:	83 ec 0c             	sub    $0xc,%esp
80103000:	ff 75 f0             	push   -0x10(%ebp)
80103003:	e8 32 d2 ff ff       	call   8010023a <bwrite>
80103008:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	ff 75 f0             	push   -0x10(%ebp)
80103011:	e8 6d d2 ff ff       	call   80100283 <brelse>
80103016:	83 c4 10             	add    $0x10,%esp
}
80103019:	90                   	nop
8010301a:	c9                   	leave
8010301b:	c3                   	ret

8010301c <recover_from_log>:

static void
recover_from_log(void)
{
8010301c:	55                   	push   %ebp
8010301d:	89 e5                	mov    %esp,%ebp
8010301f:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103022:	e8 fe fe ff ff       	call   80102f25 <read_head>
  install_trans(); // if committed, copy from log to disk
80103027:	e8 40 fe ff ff       	call   80102e6c <install_trans>
  log.lh.n = 0;
8010302c:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
80103033:	00 00 00 
  write_head(); // clear the log
80103036:	e8 5e ff ff ff       	call   80102f99 <write_head>
}
8010303b:	90                   	nop
8010303c:	c9                   	leave
8010303d:	c3                   	ret

8010303e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010303e:	55                   	push   %ebp
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103044:	83 ec 0c             	sub    $0xc,%esp
80103047:	68 20 41 19 80       	push   $0x80194120
8010304c:	e8 f7 18 00 00       	call   80104948 <acquire>
80103051:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103054:	a1 60 41 19 80       	mov    0x80194160,%eax
80103059:	85 c0                	test   %eax,%eax
8010305b:	74 17                	je     80103074 <begin_op+0x36>
      sleep(&log, &log.lock);
8010305d:	83 ec 08             	sub    $0x8,%esp
80103060:	68 20 41 19 80       	push   $0x80194120
80103065:	68 20 41 19 80       	push   $0x80194120
8010306a:	e8 6a 12 00 00       	call   801042d9 <sleep>
8010306f:	83 c4 10             	add    $0x10,%esp
80103072:	eb e0                	jmp    80103054 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103074:	8b 0d 68 41 19 80    	mov    0x80194168,%ecx
8010307a:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010307f:	8d 50 01             	lea    0x1(%eax),%edx
80103082:	89 d0                	mov    %edx,%eax
80103084:	c1 e0 02             	shl    $0x2,%eax
80103087:	01 d0                	add    %edx,%eax
80103089:	01 c0                	add    %eax,%eax
8010308b:	01 c8                	add    %ecx,%eax
8010308d:	83 f8 1e             	cmp    $0x1e,%eax
80103090:	7e 17                	jle    801030a9 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103092:	83 ec 08             	sub    $0x8,%esp
80103095:	68 20 41 19 80       	push   $0x80194120
8010309a:	68 20 41 19 80       	push   $0x80194120
8010309f:	e8 35 12 00 00       	call   801042d9 <sleep>
801030a4:	83 c4 10             	add    $0x10,%esp
801030a7:	eb ab                	jmp    80103054 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801030a9:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ae:	83 c0 01             	add    $0x1,%eax
801030b1:	a3 5c 41 19 80       	mov    %eax,0x8019415c
      release(&log.lock);
801030b6:	83 ec 0c             	sub    $0xc,%esp
801030b9:	68 20 41 19 80       	push   $0x80194120
801030be:	e8 f3 18 00 00       	call   801049b6 <release>
801030c3:	83 c4 10             	add    $0x10,%esp
      break;
801030c6:	90                   	nop
    }
  }
}
801030c7:	90                   	nop
801030c8:	c9                   	leave
801030c9:	c3                   	ret

801030ca <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801030d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801030d7:	83 ec 0c             	sub    $0xc,%esp
801030da:	68 20 41 19 80       	push   $0x80194120
801030df:	e8 64 18 00 00       	call   80104948 <acquire>
801030e4:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030e7:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ec:	83 e8 01             	sub    $0x1,%eax
801030ef:	a3 5c 41 19 80       	mov    %eax,0x8019415c
  if(log.committing)
801030f4:	a1 60 41 19 80       	mov    0x80194160,%eax
801030f9:	85 c0                	test   %eax,%eax
801030fb:	74 0d                	je     8010310a <end_op+0x40>
    panic("log.committing");
801030fd:	83 ec 0c             	sub    $0xc,%esp
80103100:	68 35 a4 10 80       	push   $0x8010a435
80103105:	e8 9f d4 ff ff       	call   801005a9 <panic>
  if(log.outstanding == 0){
8010310a:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010310f:	85 c0                	test   %eax,%eax
80103111:	75 13                	jne    80103126 <end_op+0x5c>
    do_commit = 1;
80103113:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010311a:	c7 05 60 41 19 80 01 	movl   $0x1,0x80194160
80103121:	00 00 00 
80103124:	eb 10                	jmp    80103136 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103126:	83 ec 0c             	sub    $0xc,%esp
80103129:	68 20 41 19 80       	push   $0x80194120
8010312e:	e8 8d 12 00 00       	call   801043c0 <wakeup>
80103133:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 20 41 19 80       	push   $0x80194120
8010313e:	e8 73 18 00 00       	call   801049b6 <release>
80103143:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010314a:	74 3f                	je     8010318b <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010314c:	e8 f6 00 00 00       	call   80103247 <commit>
    acquire(&log.lock);
80103151:	83 ec 0c             	sub    $0xc,%esp
80103154:	68 20 41 19 80       	push   $0x80194120
80103159:	e8 ea 17 00 00       	call   80104948 <acquire>
8010315e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103161:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103168:	00 00 00 
    wakeup(&log);
8010316b:	83 ec 0c             	sub    $0xc,%esp
8010316e:	68 20 41 19 80       	push   $0x80194120
80103173:	e8 48 12 00 00       	call   801043c0 <wakeup>
80103178:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010317b:	83 ec 0c             	sub    $0xc,%esp
8010317e:	68 20 41 19 80       	push   $0x80194120
80103183:	e8 2e 18 00 00       	call   801049b6 <release>
80103188:	83 c4 10             	add    $0x10,%esp
  }
}
8010318b:	90                   	nop
8010318c:	c9                   	leave
8010318d:	c3                   	ret

8010318e <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010318e:	55                   	push   %ebp
8010318f:	89 e5                	mov    %esp,%ebp
80103191:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010319b:	e9 95 00 00 00       	jmp    80103235 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031a0:	8b 15 54 41 19 80    	mov    0x80194154,%edx
801031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031a9:	01 d0                	add    %edx,%eax
801031ab:	83 c0 01             	add    $0x1,%eax
801031ae:	89 c2                	mov    %eax,%edx
801031b0:	a1 64 41 19 80       	mov    0x80194164,%eax
801031b5:	83 ec 08             	sub    $0x8,%esp
801031b8:	52                   	push   %edx
801031b9:	50                   	push   %eax
801031ba:	e8 42 d0 ff ff       	call   80100201 <bread>
801031bf:	83 c4 10             	add    $0x10,%esp
801031c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c8:	83 c0 10             	add    $0x10,%eax
801031cb:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801031d2:	89 c2                	mov    %eax,%edx
801031d4:	a1 64 41 19 80       	mov    0x80194164,%eax
801031d9:	83 ec 08             	sub    $0x8,%esp
801031dc:	52                   	push   %edx
801031dd:	50                   	push   %eax
801031de:	e8 1e d0 ff ff       	call   80100201 <bread>
801031e3:	83 c4 10             	add    $0x10,%esp
801031e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ec:	8d 50 5c             	lea    0x5c(%eax),%edx
801031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f2:	83 c0 5c             	add    $0x5c,%eax
801031f5:	83 ec 04             	sub    $0x4,%esp
801031f8:	68 00 02 00 00       	push   $0x200
801031fd:	52                   	push   %edx
801031fe:	50                   	push   %eax
801031ff:	e8 79 1a 00 00       	call   80104c7d <memmove>
80103204:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103207:	83 ec 0c             	sub    $0xc,%esp
8010320a:	ff 75 f0             	push   -0x10(%ebp)
8010320d:	e8 28 d0 ff ff       	call   8010023a <bwrite>
80103212:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103215:	83 ec 0c             	sub    $0xc,%esp
80103218:	ff 75 ec             	push   -0x14(%ebp)
8010321b:	e8 63 d0 ff ff       	call   80100283 <brelse>
80103220:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103223:	83 ec 0c             	sub    $0xc,%esp
80103226:	ff 75 f0             	push   -0x10(%ebp)
80103229:	e8 55 d0 ff ff       	call   80100283 <brelse>
8010322e:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103235:	a1 68 41 19 80       	mov    0x80194168,%eax
8010323a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010323d:	0f 8c 5d ff ff ff    	jl     801031a0 <write_log+0x12>
  }
}
80103243:	90                   	nop
80103244:	90                   	nop
80103245:	c9                   	leave
80103246:	c3                   	ret

80103247 <commit>:

static void
commit()
{
80103247:	55                   	push   %ebp
80103248:	89 e5                	mov    %esp,%ebp
8010324a:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010324d:	a1 68 41 19 80       	mov    0x80194168,%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	7e 1e                	jle    80103274 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103256:	e8 33 ff ff ff       	call   8010318e <write_log>
    write_head();    // Write header to disk -- the real commit
8010325b:	e8 39 fd ff ff       	call   80102f99 <write_head>
    install_trans(); // Now install writes to home locations
80103260:	e8 07 fc ff ff       	call   80102e6c <install_trans>
    log.lh.n = 0;
80103265:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
8010326c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010326f:	e8 25 fd ff ff       	call   80102f99 <write_head>
  }
}
80103274:	90                   	nop
80103275:	c9                   	leave
80103276:	c3                   	ret

80103277 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103277:	55                   	push   %ebp
80103278:	89 e5                	mov    %esp,%ebp
8010327a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010327d:	a1 68 41 19 80       	mov    0x80194168,%eax
80103282:	83 f8 1d             	cmp    $0x1d,%eax
80103285:	7f 12                	jg     80103299 <log_write+0x22>
80103287:	8b 15 68 41 19 80    	mov    0x80194168,%edx
8010328d:	a1 58 41 19 80       	mov    0x80194158,%eax
80103292:	83 e8 01             	sub    $0x1,%eax
80103295:	39 c2                	cmp    %eax,%edx
80103297:	7c 0d                	jl     801032a6 <log_write+0x2f>
    panic("too big a transaction");
80103299:	83 ec 0c             	sub    $0xc,%esp
8010329c:	68 44 a4 10 80       	push   $0x8010a444
801032a1:	e8 03 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a6:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032ab:	85 c0                	test   %eax,%eax
801032ad:	7f 0d                	jg     801032bc <log_write+0x45>
    panic("log_write outside of trans");
801032af:	83 ec 0c             	sub    $0xc,%esp
801032b2:	68 5a a4 10 80       	push   $0x8010a45a
801032b7:	e8 ed d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032bc:	83 ec 0c             	sub    $0xc,%esp
801032bf:	68 20 41 19 80       	push   $0x80194120
801032c4:	e8 7f 16 00 00       	call   80104948 <acquire>
801032c9:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801032cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032d3:	eb 1d                	jmp    801032f2 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d8:	83 c0 10             	add    $0x10,%eax
801032db:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801032e2:	89 c2                	mov    %eax,%edx
801032e4:	8b 45 08             	mov    0x8(%ebp),%eax
801032e7:	8b 40 08             	mov    0x8(%eax),%eax
801032ea:	39 c2                	cmp    %eax,%edx
801032ec:	74 10                	je     801032fe <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801032ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032f2:	a1 68 41 19 80       	mov    0x80194168,%eax
801032f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801032fa:	7c d9                	jl     801032d5 <log_write+0x5e>
801032fc:	eb 01                	jmp    801032ff <log_write+0x88>
      break;
801032fe:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801032ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103302:	8b 40 08             	mov    0x8(%eax),%eax
80103305:	89 c2                	mov    %eax,%edx
80103307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330a:	83 c0 10             	add    $0x10,%eax
8010330d:	89 14 85 2c 41 19 80 	mov    %edx,-0x7fe6bed4(,%eax,4)
  if (i == log.lh.n)
80103314:	a1 68 41 19 80       	mov    0x80194168,%eax
80103319:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010331c:	75 0d                	jne    8010332b <log_write+0xb4>
    log.lh.n++;
8010331e:	a1 68 41 19 80       	mov    0x80194168,%eax
80103323:	83 c0 01             	add    $0x1,%eax
80103326:	a3 68 41 19 80       	mov    %eax,0x80194168
  b->flags |= B_DIRTY; // prevent eviction
8010332b:	8b 45 08             	mov    0x8(%ebp),%eax
8010332e:	8b 00                	mov    (%eax),%eax
80103330:	83 c8 04             	or     $0x4,%eax
80103333:	89 c2                	mov    %eax,%edx
80103335:	8b 45 08             	mov    0x8(%ebp),%eax
80103338:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010333a:	83 ec 0c             	sub    $0xc,%esp
8010333d:	68 20 41 19 80       	push   $0x80194120
80103342:	e8 6f 16 00 00       	call   801049b6 <release>
80103347:	83 c4 10             	add    $0x10,%esp
}
8010334a:	90                   	nop
8010334b:	c9                   	leave
8010334c:	c3                   	ret

8010334d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010334d:	55                   	push   %ebp
8010334e:	89 e5                	mov    %esp,%ebp
80103350:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103353:	8b 55 08             	mov    0x8(%ebp),%edx
80103356:	8b 45 0c             	mov    0xc(%ebp),%eax
80103359:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010335c:	f0 87 02             	lock xchg %eax,(%edx)
8010335f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103362:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103365:	c9                   	leave
80103366:	c3                   	ret

80103367 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103367:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010336b:	83 e4 f0             	and    $0xfffffff0,%esp
8010336e:	ff 71 fc             	push   -0x4(%ecx)
80103371:	55                   	push   %ebp
80103372:	89 e5                	mov    %esp,%ebp
80103374:	51                   	push   %ecx
80103375:	83 ec 04             	sub    $0x4,%esp
  graphic_init();
80103378:	e8 5b 4c 00 00       	call   80107fd8 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337d:	83 ec 08             	sub    $0x8,%esp
80103380:	68 00 00 40 80       	push   $0x80400000
80103385:	68 00 90 19 80       	push   $0x80199000
8010338a:	e8 e4 f2 ff ff       	call   80102673 <kinit1>
8010338f:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103392:	e8 5e 42 00 00       	call   801075f5 <kvmalloc>
  mpinit_uefi();
80103397:	e8 05 4a 00 00       	call   80107da1 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339c:	e8 3f f6 ff ff       	call   801029e0 <lapicinit>
  seginit();       // segment descriptors
801033a1:	e8 e6 3c 00 00       	call   8010708c <seginit>
  picinit();    // disable pic
801033a6:	e8 9b 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033ab:	e8 de f1 ff ff       	call   8010258e <ioapicinit>
  consoleinit();   // console hardware
801033b0:	e8 54 d7 ff ff       	call   80100b09 <consoleinit>
  uartinit();      // serial port
801033b5:	e8 6b 30 00 00       	call   80106425 <uartinit>
  pinit();         // process table
801033ba:	e8 c0 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors
801033bf:	e8 34 2c 00 00       	call   80105ff8 <tvinit>
  binit();         // buffer cache
801033c4:	e8 9d cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c9:	e8 fb db ff ff       	call   80100fc9 <fileinit>
  ideinit();       // disk 
801033ce:	e8 30 6d 00 00       	call   8010a103 <ideinit>
  startothers();   // start other processors
801033d3:	e8 8a 00 00 00       	call   80103462 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d8:	83 ec 08             	sub    $0x8,%esp
801033db:	68 00 00 00 a0       	push   $0xa0000000
801033e0:	68 00 00 40 80       	push   $0x80400000
801033e5:	e8 c2 f2 ff ff       	call   801026ac <kinit2>
801033ea:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033ed:	e8 41 4e 00 00       	call   80108233 <pci_init>
  arp_scan();
801033f2:	e8 76 5b 00 00       	call   80108f6d <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801033f7:	e8 61 07 00 00       	call   80103b5d <userinit>

  mpmain();        // finish this processor's setup
801033fc:	e8 1a 00 00 00       	call   8010341b <mpmain>

80103401 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103401:	55                   	push   %ebp
80103402:	89 e5                	mov    %esp,%ebp
80103404:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103407:	e8 01 42 00 00       	call   8010760d <switchkvm>
  seginit();
8010340c:	e8 7b 3c 00 00       	call   8010708c <seginit>
  lapicinit();
80103411:	e8 ca f5 ff ff       	call   801029e0 <lapicinit>
  mpmain();
80103416:	e8 00 00 00 00       	call   8010341b <mpmain>

8010341b <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010341b:	55                   	push   %ebp
8010341c:	89 e5                	mov    %esp,%ebp
8010341e:	53                   	push   %ebx
8010341f:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103422:	e8 76 05 00 00       	call   8010399d <cpuid>
80103427:	89 c3                	mov    %eax,%ebx
80103429:	e8 6f 05 00 00       	call   8010399d <cpuid>
8010342e:	83 ec 04             	sub    $0x4,%esp
80103431:	53                   	push   %ebx
80103432:	50                   	push   %eax
80103433:	68 75 a4 10 80       	push   $0x8010a475
80103438:	e8 b7 cf ff ff       	call   801003f4 <cprintf>
8010343d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103440:	e8 29 2d 00 00       	call   8010616e <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103445:	e8 6e 05 00 00       	call   801039b8 <mycpu>
8010344a:	05 a0 00 00 00       	add    $0xa0,%eax
8010344f:	83 ec 08             	sub    $0x8,%esp
80103452:	6a 01                	push   $0x1
80103454:	50                   	push   %eax
80103455:	e8 f3 fe ff ff       	call   8010334d <xchg>
8010345a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345d:	e8 86 0c 00 00       	call   801040e8 <scheduler>

80103462 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103462:	55                   	push   %ebp
80103463:	89 e5                	mov    %esp,%ebp
80103465:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103468:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010346f:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103474:	83 ec 04             	sub    $0x4,%esp
80103477:	50                   	push   %eax
80103478:	68 18 f5 10 80       	push   $0x8010f518
8010347d:	ff 75 f0             	push   -0x10(%ebp)
80103480:	e8 f8 17 00 00       	call   80104c7d <memmove>
80103485:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103488:	c7 45 f4 80 6a 19 80 	movl   $0x80196a80,-0xc(%ebp)
8010348f:	eb 79                	jmp    8010350a <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
80103491:	e8 22 05 00 00       	call   801039b8 <mycpu>
80103496:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103499:	74 67                	je     80103502 <startothers+0xa0>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010349b:	e8 08 f3 ff ff       	call   801027a8 <kalloc>
801034a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801034a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a6:	83 e8 04             	sub    $0x4,%eax
801034a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034ac:	81 c2 00 10 00 00    	add    $0x1000,%edx
801034b2:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b7:	83 e8 08             	sub    $0x8,%eax
801034ba:	c7 00 01 34 10 80    	movl   $0x80103401,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034c0:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801034c5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ce:	83 e8 0c             	sub    $0xc,%eax
801034d1:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034d6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034df:	0f b6 00             	movzbl (%eax),%eax
801034e2:	0f b6 c0             	movzbl %al,%eax
801034e5:	83 ec 08             	sub    $0x8,%esp
801034e8:	52                   	push   %edx
801034e9:	50                   	push   %eax
801034ea:	e8 50 f6 ff ff       	call   80102b3f <lapicstartap>
801034ef:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034f2:	90                   	nop
801034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f6:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801034fc:	85 c0                	test   %eax,%eax
801034fe:	74 f3                	je     801034f3 <startothers+0x91>
80103500:	eb 01                	jmp    80103503 <startothers+0xa1>
      continue;
80103502:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103503:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
8010350a:	a1 40 6d 19 80       	mov    0x80196d40,%eax
8010350f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103515:	05 80 6a 19 80       	add    $0x80196a80,%eax
8010351a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010351d:	0f 82 6e ff ff ff    	jb     80103491 <startothers+0x2f>
      ;
  }
}
80103523:	90                   	nop
80103524:	90                   	nop
80103525:	c9                   	leave
80103526:	c3                   	ret

80103527 <outb>:
{
80103527:	55                   	push   %ebp
80103528:	89 e5                	mov    %esp,%ebp
8010352a:	83 ec 08             	sub    $0x8,%esp
8010352d:	8b 55 08             	mov    0x8(%ebp),%edx
80103530:	8b 45 0c             	mov    0xc(%ebp),%eax
80103533:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103537:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010353e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103542:	ee                   	out    %al,(%dx)
}
80103543:	90                   	nop
80103544:	c9                   	leave
80103545:	c3                   	ret

80103546 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103549:	68 ff 00 00 00       	push   $0xff
8010354e:	6a 21                	push   $0x21
80103550:	e8 d2 ff ff ff       	call   80103527 <outb>
80103555:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103558:	68 ff 00 00 00       	push   $0xff
8010355d:	68 a1 00 00 00       	push   $0xa1
80103562:	e8 c0 ff ff ff       	call   80103527 <outb>
80103567:	83 c4 08             	add    $0x8,%esp
}
8010356a:	90                   	nop
8010356b:	c9                   	leave
8010356c:	c3                   	ret

8010356d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010356d:	55                   	push   %ebp
8010356e:	89 e5                	mov    %esp,%ebp
80103570:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103573:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010357a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010357d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103583:	8b 45 0c             	mov    0xc(%ebp),%eax
80103586:	8b 10                	mov    (%eax),%edx
80103588:	8b 45 08             	mov    0x8(%ebp),%eax
8010358b:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010358d:	e8 55 da ff ff       	call   80100fe7 <filealloc>
80103592:	8b 55 08             	mov    0x8(%ebp),%edx
80103595:	89 02                	mov    %eax,(%edx)
80103597:	8b 45 08             	mov    0x8(%ebp),%eax
8010359a:	8b 00                	mov    (%eax),%eax
8010359c:	85 c0                	test   %eax,%eax
8010359e:	0f 84 c8 00 00 00    	je     8010366c <pipealloc+0xff>
801035a4:	e8 3e da ff ff       	call   80100fe7 <filealloc>
801035a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801035ac:	89 02                	mov    %eax,(%edx)
801035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801035b1:	8b 00                	mov    (%eax),%eax
801035b3:	85 c0                	test   %eax,%eax
801035b5:	0f 84 b1 00 00 00    	je     8010366c <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035bb:	e8 e8 f1 ff ff       	call   801027a8 <kalloc>
801035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c7:	0f 84 a2 00 00 00    	je     8010366f <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d0:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035d7:	00 00 00 
  p->writeopen = 1;
801035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035e4:	00 00 00 
  p->nwrite = 0;
801035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ea:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f1:	00 00 00 
  p->nread = 0;
801035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035f7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035fe:	00 00 00 
  initlock(&p->lock, "pipe");
80103601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103604:	83 ec 08             	sub    $0x8,%esp
80103607:	68 89 a4 10 80       	push   $0x8010a489
8010360c:	50                   	push   %eax
8010360d:	e8 14 13 00 00       	call   80104926 <initlock>
80103612:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103615:	8b 45 08             	mov    0x8(%ebp),%eax
80103618:	8b 00                	mov    (%eax),%eax
8010361a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103620:	8b 45 08             	mov    0x8(%ebp),%eax
80103623:	8b 00                	mov    (%eax),%eax
80103625:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103629:	8b 45 08             	mov    0x8(%ebp),%eax
8010362c:	8b 00                	mov    (%eax),%eax
8010362e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103632:	8b 45 08             	mov    0x8(%ebp),%eax
80103635:	8b 00                	mov    (%eax),%eax
80103637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010363a:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010363d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103640:	8b 00                	mov    (%eax),%eax
80103642:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364b:	8b 00                	mov    (%eax),%eax
8010364d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103651:	8b 45 0c             	mov    0xc(%ebp),%eax
80103654:	8b 00                	mov    (%eax),%eax
80103656:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010365a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010365d:	8b 00                	mov    (%eax),%eax
8010365f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103662:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103665:	b8 00 00 00 00       	mov    $0x0,%eax
8010366a:	eb 51                	jmp    801036bd <pipealloc+0x150>
    goto bad;
8010366c:	90                   	nop
8010366d:	eb 01                	jmp    80103670 <pipealloc+0x103>
    goto bad;
8010366f:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103674:	74 0e                	je     80103684 <pipealloc+0x117>
    kfree((char*)p);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	ff 75 f4             	push   -0xc(%ebp)
8010367c:	e8 8d f0 ff ff       	call   8010270e <kfree>
80103681:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103684:	8b 45 08             	mov    0x8(%ebp),%eax
80103687:	8b 00                	mov    (%eax),%eax
80103689:	85 c0                	test   %eax,%eax
8010368b:	74 11                	je     8010369e <pipealloc+0x131>
    fileclose(*f0);
8010368d:	8b 45 08             	mov    0x8(%ebp),%eax
80103690:	8b 00                	mov    (%eax),%eax
80103692:	83 ec 0c             	sub    $0xc,%esp
80103695:	50                   	push   %eax
80103696:	e8 0a da ff ff       	call   801010a5 <fileclose>
8010369b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010369e:	8b 45 0c             	mov    0xc(%ebp),%eax
801036a1:	8b 00                	mov    (%eax),%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	74 11                	je     801036b8 <pipealloc+0x14b>
    fileclose(*f1);
801036a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801036aa:	8b 00                	mov    (%eax),%eax
801036ac:	83 ec 0c             	sub    $0xc,%esp
801036af:	50                   	push   %eax
801036b0:	e8 f0 d9 ff ff       	call   801010a5 <fileclose>
801036b5:	83 c4 10             	add    $0x10,%esp
  return -1;
801036b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036bd:	c9                   	leave
801036be:	c3                   	ret

801036bf <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036bf:	55                   	push   %ebp
801036c0:	89 e5                	mov    %esp,%ebp
801036c2:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801036c5:	8b 45 08             	mov    0x8(%ebp),%eax
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	50                   	push   %eax
801036cc:	e8 77 12 00 00       	call   80104948 <acquire>
801036d1:	83 c4 10             	add    $0x10,%esp
  if(writable){
801036d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801036d8:	74 23                	je     801036fd <pipeclose+0x3e>
    p->writeopen = 0;
801036da:	8b 45 08             	mov    0x8(%ebp),%eax
801036dd:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801036e4:	00 00 00 
    wakeup(&p->nread);
801036e7:	8b 45 08             	mov    0x8(%ebp),%eax
801036ea:	05 34 02 00 00       	add    $0x234,%eax
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	50                   	push   %eax
801036f3:	e8 c8 0c 00 00       	call   801043c0 <wakeup>
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	eb 21                	jmp    8010371e <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801036fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103700:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103707:	00 00 00 
    wakeup(&p->nwrite);
8010370a:	8b 45 08             	mov    0x8(%ebp),%eax
8010370d:	05 38 02 00 00       	add    $0x238,%eax
80103712:	83 ec 0c             	sub    $0xc,%esp
80103715:	50                   	push   %eax
80103716:	e8 a5 0c 00 00       	call   801043c0 <wakeup>
8010371b:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010371e:	8b 45 08             	mov    0x8(%ebp),%eax
80103721:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	75 2c                	jne    80103757 <pipeclose+0x98>
8010372b:	8b 45 08             	mov    0x8(%ebp),%eax
8010372e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	75 1f                	jne    80103757 <pipeclose+0x98>
    release(&p->lock);
80103738:	8b 45 08             	mov    0x8(%ebp),%eax
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	50                   	push   %eax
8010373f:	e8 72 12 00 00       	call   801049b6 <release>
80103744:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	ff 75 08             	push   0x8(%ebp)
8010374d:	e8 bc ef ff ff       	call   8010270e <kfree>
80103752:	83 c4 10             	add    $0x10,%esp
80103755:	eb 10                	jmp    80103767 <pipeclose+0xa8>
  } else
    release(&p->lock);
80103757:	8b 45 08             	mov    0x8(%ebp),%eax
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	50                   	push   %eax
8010375e:	e8 53 12 00 00       	call   801049b6 <release>
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	90                   	nop
80103767:	90                   	nop
80103768:	c9                   	leave
80103769:	c3                   	ret

8010376a <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010376a:	55                   	push   %ebp
8010376b:	89 e5                	mov    %esp,%ebp
8010376d:	53                   	push   %ebx
8010376e:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103771:	8b 45 08             	mov    0x8(%ebp),%eax
80103774:	83 ec 0c             	sub    $0xc,%esp
80103777:	50                   	push   %eax
80103778:	e8 cb 11 00 00       	call   80104948 <acquire>
8010377d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103787:	e9 ad 00 00 00       	jmp    80103839 <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010378c:	8b 45 08             	mov    0x8(%ebp),%eax
8010378f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103795:	85 c0                	test   %eax,%eax
80103797:	74 0c                	je     801037a5 <pipewrite+0x3b>
80103799:	e8 92 02 00 00       	call   80103a30 <myproc>
8010379e:	8b 40 24             	mov    0x24(%eax),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	74 19                	je     801037be <pipewrite+0x54>
        release(&p->lock);
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 05 12 00 00       	call   801049b6 <release>
801037b1:	83 c4 10             	add    $0x10,%esp
        return -1;
801037b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037b9:	e9 a9 00 00 00       	jmp    80103867 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
801037be:	8b 45 08             	mov    0x8(%ebp),%eax
801037c1:	05 34 02 00 00       	add    $0x234,%eax
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	50                   	push   %eax
801037ca:	e8 f1 0b 00 00       	call   801043c0 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 f1 0a 00 00       	call   801042d9 <sleep>
801037e8:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037eb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ee:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801037f4:	8b 45 08             	mov    0x8(%ebp),%eax
801037f7:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801037fd:	05 00 02 00 00       	add    $0x200,%eax
80103802:	39 c2                	cmp    %eax,%edx
80103804:	74 86                	je     8010378c <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010380c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010380f:	8b 45 08             	mov    0x8(%ebp),%eax
80103812:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103818:	8d 48 01             	lea    0x1(%eax),%ecx
8010381b:	8b 55 08             	mov    0x8(%ebp),%edx
8010381e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103824:	25 ff 01 00 00       	and    $0x1ff,%eax
80103829:	89 c1                	mov    %eax,%ecx
8010382b:	0f b6 13             	movzbl (%ebx),%edx
8010382e:	8b 45 08             	mov    0x8(%ebp),%eax
80103831:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010383f:	7c aa                	jl     801037eb <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103841:	8b 45 08             	mov    0x8(%ebp),%eax
80103844:	05 34 02 00 00       	add    $0x234,%eax
80103849:	83 ec 0c             	sub    $0xc,%esp
8010384c:	50                   	push   %eax
8010384d:	e8 6e 0b 00 00       	call   801043c0 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 55 11 00 00       	call   801049b6 <release>
80103861:	83 c4 10             	add    $0x10,%esp
  return n;
80103864:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386a:	c9                   	leave
8010386b:	c3                   	ret

8010386c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103872:	8b 45 08             	mov    0x8(%ebp),%eax
80103875:	83 ec 0c             	sub    $0xc,%esp
80103878:	50                   	push   %eax
80103879:	e8 ca 10 00 00       	call   80104948 <acquire>
8010387e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103881:	eb 3e                	jmp    801038c1 <piperead+0x55>
    if(myproc()->killed){
80103883:	e8 a8 01 00 00       	call   80103a30 <myproc>
80103888:	8b 40 24             	mov    0x24(%eax),%eax
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 19                	je     801038a8 <piperead+0x3c>
      release(&p->lock);
8010388f:	8b 45 08             	mov    0x8(%ebp),%eax
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	50                   	push   %eax
80103896:	e8 1b 11 00 00       	call   801049b6 <release>
8010389b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010389e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a3:	e9 be 00 00 00       	jmp    80103966 <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038a8:	8b 45 08             	mov    0x8(%ebp),%eax
801038ab:	8b 55 08             	mov    0x8(%ebp),%edx
801038ae:	81 c2 34 02 00 00    	add    $0x234,%edx
801038b4:	83 ec 08             	sub    $0x8,%esp
801038b7:	50                   	push   %eax
801038b8:	52                   	push   %edx
801038b9:	e8 1b 0a 00 00       	call   801042d9 <sleep>
801038be:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038c1:	8b 45 08             	mov    0x8(%ebp),%eax
801038c4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038ca:	8b 45 08             	mov    0x8(%ebp),%eax
801038cd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038d3:	39 c2                	cmp    %eax,%edx
801038d5:	75 0d                	jne    801038e4 <piperead+0x78>
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801038e0:	85 c0                	test   %eax,%eax
801038e2:	75 9f                	jne    80103883 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038eb:	eb 48                	jmp    80103935 <piperead+0xc9>
    if(p->nread == p->nwrite)
801038ed:	8b 45 08             	mov    0x8(%ebp),%eax
801038f0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038f6:	8b 45 08             	mov    0x8(%ebp),%eax
801038f9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038ff:	39 c2                	cmp    %eax,%edx
80103901:	74 3c                	je     8010393f <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
80103906:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010390c:	8d 48 01             	lea    0x1(%eax),%ecx
8010390f:	8b 55 08             	mov    0x8(%ebp),%edx
80103912:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103918:	25 ff 01 00 00       	and    $0x1ff,%eax
8010391d:	89 c1                	mov    %eax,%ecx
8010391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103922:	8b 45 0c             	mov    0xc(%ebp),%eax
80103925:	01 c2                	add    %eax,%edx
80103927:	8b 45 08             	mov    0x8(%ebp),%eax
8010392a:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010392f:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103938:	3b 45 10             	cmp    0x10(%ebp),%eax
8010393b:	7c b0                	jl     801038ed <piperead+0x81>
8010393d:	eb 01                	jmp    80103940 <piperead+0xd4>
      break;
8010393f:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103940:	8b 45 08             	mov    0x8(%ebp),%eax
80103943:	05 38 02 00 00       	add    $0x238,%eax
80103948:	83 ec 0c             	sub    $0xc,%esp
8010394b:	50                   	push   %eax
8010394c:	e8 6f 0a 00 00       	call   801043c0 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 56 10 00 00       	call   801049b6 <release>
80103960:	83 c4 10             	add    $0x10,%esp
  return i;
80103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103966:	c9                   	leave
80103967:	c3                   	ret

80103968 <readeflags>:
{
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010396e:	9c                   	pushf
8010396f:	58                   	pop    %eax
80103970:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103973:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103976:	c9                   	leave
80103977:	c3                   	ret

80103978 <sti>:
{
80103978:	55                   	push   %ebp
80103979:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010397b:	fb                   	sti
}
8010397c:	90                   	nop
8010397d:	5d                   	pop    %ebp
8010397e:	c3                   	ret

8010397f <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010397f:	55                   	push   %ebp
80103980:	89 e5                	mov    %esp,%ebp
80103982:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103985:	83 ec 08             	sub    $0x8,%esp
80103988:	68 90 a4 10 80       	push   $0x8010a490
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 8f 0f 00 00       	call   80104926 <initlock>
80103997:	83 c4 10             	add    $0x10,%esp
}
8010399a:	90                   	nop
8010399b:	c9                   	leave
8010399c:	c3                   	ret

8010399d <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010399d:	55                   	push   %ebp
8010399e:	89 e5                	mov    %esp,%ebp
801039a0:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039a3:	e8 10 00 00 00       	call   801039b8 <mycpu>
801039a8:	2d 80 6a 19 80       	sub    $0x80196a80,%eax
801039ad:	c1 f8 04             	sar    $0x4,%eax
801039b0:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039b6:	c9                   	leave
801039b7:	c3                   	ret

801039b8 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801039b8:	55                   	push   %ebp
801039b9:	89 e5                	mov    %esp,%ebp
801039bb:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
801039be:	e8 a5 ff ff ff       	call   80103968 <readeflags>
801039c3:	25 00 02 00 00       	and    $0x200,%eax
801039c8:	85 c0                	test   %eax,%eax
801039ca:	74 0d                	je     801039d9 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801039cc:	83 ec 0c             	sub    $0xc,%esp
801039cf:	68 98 a4 10 80       	push   $0x8010a498
801039d4:	e8 d0 cb ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
801039d9:	e8 1e f1 ff ff       	call   80102afc <lapicid>
801039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039e8:	eb 2d                	jmp    80103a17 <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f3:	05 80 6a 19 80       	add    $0x80196a80,%eax
801039f8:	0f b6 00             	movzbl (%eax),%eax
801039fb:	0f b6 c0             	movzbl %al,%eax
801039fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103a01:	75 10                	jne    80103a13 <mycpu+0x5b>
      return &cpus[i];
80103a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a06:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a0c:	05 80 6a 19 80       	add    $0x80196a80,%eax
80103a11:	eb 1b                	jmp    80103a2e <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103a13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a17:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80103a1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a1f:	7c c9                	jl     801039ea <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a21:	83 ec 0c             	sub    $0xc,%esp
80103a24:	68 be a4 10 80       	push   $0x8010a4be
80103a29:	e8 7b cb ff ff       	call   801005a9 <panic>
}
80103a2e:	c9                   	leave
80103a2f:	c3                   	ret

80103a30 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a36:	e8 78 10 00 00       	call   80104ab3 <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 ac 10 00 00       	call   80104b00 <popcli>
  return p;
80103a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103a57:	c9                   	leave
80103a58:	c3                   	ret

80103a59 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	68 00 42 19 80       	push   $0x80194200
80103a67:	e8 dc 0e 00 00       	call   80104948 <acquire>
80103a6c:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a6f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a76:	eb 0e                	jmp    80103a86 <allocproc+0x2d>
    if(p->state == UNUSED){
80103a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7b:	8b 40 0c             	mov    0xc(%eax),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	74 27                	je     80103aa9 <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a82:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103a86:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103a8d:	72 e9                	jb     80103a78 <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	68 00 42 19 80       	push   $0x80194200
80103a97:	e8 1a 0f 00 00       	call   801049b6 <release>
80103a9c:	83 c4 10             	add    $0x10,%esp
  return 0;
80103a9f:	b8 00 00 00 00       	mov    $0x0,%eax
80103aa4:	e9 b2 00 00 00       	jmp    80103b5b <allocproc+0x102>
      goto found;
80103aa9:	90                   	nop

found:
  p->state = EMBRYO;
80103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aad:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103ab4:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103ab9:	8d 50 01             	lea    0x1(%eax),%edx
80103abc:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ac5:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 00 42 19 80       	push   $0x80194200
80103ad0:	e8 e1 0e 00 00       	call   801049b6 <release>
80103ad5:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ad8:	e8 cb ec ff ff       	call   801027a8 <kalloc>
80103add:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ae0:	89 42 08             	mov    %eax,0x8(%edx)
80103ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae6:	8b 40 08             	mov    0x8(%eax),%eax
80103ae9:	85 c0                	test   %eax,%eax
80103aeb:	75 11                	jne    80103afe <allocproc+0xa5>
    p->state = UNUSED;
80103aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103af7:	b8 00 00 00 00       	mov    $0x0,%eax
80103afc:	eb 5d                	jmp    80103b5b <allocproc+0x102>
  }
  sp = p->kstack + KSTACKSIZE;
80103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b01:	8b 40 08             	mov    0x8(%eax),%eax
80103b04:	05 00 10 00 00       	add    $0x1000,%eax
80103b09:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b0c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b16:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b19:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103b1d:	ba b2 5f 10 80       	mov    $0x80105fb2,%edx
80103b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b25:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b27:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b31:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b37:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b3a:	83 ec 04             	sub    $0x4,%esp
80103b3d:	6a 14                	push   $0x14
80103b3f:	6a 00                	push   $0x0
80103b41:	50                   	push   %eax
80103b42:	e8 77 10 00 00       	call   80104bbe <memset>
80103b47:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4d:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b50:	ba 93 42 10 80       	mov    $0x80104293,%edx
80103b55:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b5b:	c9                   	leave
80103b5c:	c3                   	ret

80103b5d <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b5d:	55                   	push   %ebp
80103b5e:	89 e5                	mov    %esp,%ebp
80103b60:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b63:	e8 f1 fe ff ff       	call   80103a59 <allocproc>
80103b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6e:	a3 34 62 19 80       	mov    %eax,0x80196234
  if((p->pgdir = setupkvm()) == 0){
80103b73:	e8 90 39 00 00       	call   80107508 <setupkvm>
80103b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7b:	89 42 04             	mov    %eax,0x4(%edx)
80103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b81:	8b 40 04             	mov    0x4(%eax),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	75 0d                	jne    80103b95 <userinit+0x38>
    panic("userinit: out of memory?");
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	68 ce a4 10 80       	push   $0x8010a4ce
80103b90:	e8 14 ca ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b95:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9d:	8b 40 04             	mov    0x4(%eax),%eax
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	52                   	push   %edx
80103ba4:	68 ec f4 10 80       	push   $0x8010f4ec
80103ba9:	50                   	push   %eax
80103baa:	e8 16 3c 00 00       	call   801077c5 <inituvm>
80103baf:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	8b 40 18             	mov    0x18(%eax),%eax
80103bc1:	83 ec 04             	sub    $0x4,%esp
80103bc4:	6a 4c                	push   $0x4c
80103bc6:	6a 00                	push   $0x0
80103bc8:	50                   	push   %eax
80103bc9:	e8 f0 0f 00 00       	call   80104bbe <memset>
80103bce:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd4:	8b 40 18             	mov    0x18(%eax),%eax
80103bd7:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be0:	8b 40 18             	mov    0x18(%eax),%eax
80103be3:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bec:	8b 50 18             	mov    0x18(%eax),%edx
80103bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf2:	8b 40 18             	mov    0x18(%eax),%eax
80103bf5:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103bf9:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c00:	8b 50 18             	mov    0x18(%eax),%edx
80103c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c06:	8b 40 18             	mov    0x18(%eax),%eax
80103c09:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c0d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c14:	8b 40 18             	mov    0x18(%eax),%eax
80103c17:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c21:	8b 40 18             	mov    0x18(%eax),%eax
80103c24:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2e:	8b 40 18             	mov    0x18(%eax),%eax
80103c31:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3b:	83 c0 6c             	add    $0x6c,%eax
80103c3e:	83 ec 04             	sub    $0x4,%esp
80103c41:	6a 10                	push   $0x10
80103c43:	68 e7 a4 10 80       	push   $0x8010a4e7
80103c48:	50                   	push   %eax
80103c49:	e8 73 11 00 00       	call   80104dc1 <safestrcpy>
80103c4e:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c51:	83 ec 0c             	sub    $0xc,%esp
80103c54:	68 f0 a4 10 80       	push   $0x8010a4f0
80103c59:	e8 c7 e8 ff ff       	call   80102525 <namei>
80103c5e:	83 c4 10             	add    $0x10,%esp
80103c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c64:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	68 00 42 19 80       	push   $0x80194200
80103c6f:	e8 d4 0c 00 00       	call   80104948 <acquire>
80103c74:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c81:	83 ec 0c             	sub    $0xc,%esp
80103c84:	68 00 42 19 80       	push   $0x80194200
80103c89:	e8 28 0d 00 00       	call   801049b6 <release>
80103c8e:	83 c4 10             	add    $0x10,%esp
}
80103c91:	90                   	nop
80103c92:	c9                   	leave
80103c93:	c3                   	ret

80103c94 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103c9a:	e8 91 fd ff ff       	call   80103a30 <myproc>
80103c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca5:	8b 00                	mov    (%eax),%eax
80103ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103caa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cae:	7e 2e                	jle    80103cde <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80103cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb6:	01 c2                	add    %eax,%edx
80103cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbb:	8b 40 04             	mov    0x4(%eax),%eax
80103cbe:	83 ec 04             	sub    $0x4,%esp
80103cc1:	52                   	push   %edx
80103cc2:	ff 75 f4             	push   -0xc(%ebp)
80103cc5:	50                   	push   %eax
80103cc6:	e8 37 3c 00 00       	call   80107902 <allocuvm>
80103ccb:	83 c4 10             	add    $0x10,%esp
80103cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd5:	75 3b                	jne    80103d12 <growproc+0x7e>
      return -1;
80103cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdc:	eb 4f                	jmp    80103d2d <growproc+0x99>
  } else if(n < 0){
80103cde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103ce2:	79 2e                	jns    80103d12 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cea:	01 c2                	add    %eax,%edx
80103cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cef:	8b 40 04             	mov    0x4(%eax),%eax
80103cf2:	83 ec 04             	sub    $0x4,%esp
80103cf5:	52                   	push   %edx
80103cf6:	ff 75 f4             	push   -0xc(%ebp)
80103cf9:	50                   	push   %eax
80103cfa:	e8 08 3d 00 00       	call   80107a07 <deallocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d09:	75 07                	jne    80103d12 <growproc+0x7e>
      return -1;
80103d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d10:	eb 1b                	jmp    80103d2d <growproc+0x99>
  }
  curproc->sz = sz;
80103d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d18:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	ff 75 f0             	push   -0x10(%ebp)
80103d20:	e8 01 39 00 00       	call   80107626 <switchuvm>
80103d25:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d2d:	c9                   	leave
80103d2e:	c3                   	ret

80103d2f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d2f:	55                   	push   %ebp
80103d30:	89 e5                	mov    %esp,%ebp
80103d32:	57                   	push   %edi
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d38:	e8 f3 fc ff ff       	call   80103a30 <myproc>
80103d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d40:	e8 14 fd ff ff       	call   80103a59 <allocproc>
80103d45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103d48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103d4c:	75 0a                	jne    80103d58 <fork+0x29>
    return -1;
80103d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d53:	e9 48 01 00 00       	jmp    80103ea0 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d5b:	8b 10                	mov    (%eax),%edx
80103d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d60:	8b 40 04             	mov    0x4(%eax),%eax
80103d63:	83 ec 08             	sub    $0x8,%esp
80103d66:	52                   	push   %edx
80103d67:	50                   	push   %eax
80103d68:	e8 38 3e 00 00       	call   80107ba5 <copyuvm>
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103d73:	89 42 04             	mov    %eax,0x4(%edx)
80103d76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d79:	8b 40 04             	mov    0x4(%eax),%eax
80103d7c:	85 c0                	test   %eax,%eax
80103d7e:	75 30                	jne    80103db0 <fork+0x81>
    kfree(np->kstack);
80103d80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d83:	8b 40 08             	mov    0x8(%eax),%eax
80103d86:	83 ec 0c             	sub    $0xc,%esp
80103d89:	50                   	push   %eax
80103d8a:	e8 7f e9 ff ff       	call   8010270e <kfree>
80103d8f:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	e9 f0 00 00 00       	jmp    80103ea0 <fork+0x171>
  }
  np->sz = curproc->sz;
80103db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db3:	8b 10                	mov    (%eax),%edx
80103db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103db8:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103dc0:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dc6:	8b 48 18             	mov    0x18(%eax),%ecx
80103dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dcc:	8b 40 18             	mov    0x18(%eax),%eax
80103dcf:	89 c2                	mov    %eax,%edx
80103dd1:	89 cb                	mov    %ecx,%ebx
80103dd3:	b8 13 00 00 00       	mov    $0x13,%eax
80103dd8:	89 d7                	mov    %edx,%edi
80103dda:	89 de                	mov    %ebx,%esi
80103ddc:	89 c1                	mov    %eax,%ecx
80103dde:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103de3:	8b 40 18             	mov    0x18(%eax),%eax
80103de6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103ded:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103df4:	eb 3b                	jmp    80103e31 <fork+0x102>
    if(curproc->ofile[i])
80103df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103df9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dfc:	83 c2 08             	add    $0x8,%edx
80103dff:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e03:	85 c0                	test   %eax,%eax
80103e05:	74 26                	je     80103e2d <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e0d:	83 c2 08             	add    $0x8,%edx
80103e10:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	50                   	push   %eax
80103e18:	e8 37 d2 ff ff       	call   80101054 <filedup>
80103e1d:	83 c4 10             	add    $0x10,%esp
80103e20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e23:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e26:	83 c1 08             	add    $0x8,%ecx
80103e29:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e2d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e31:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e35:	7e bf                	jle    80103df6 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e3a:	8b 40 68             	mov    0x68(%eax),%eax
80103e3d:	83 ec 0c             	sub    $0xc,%esp
80103e40:	50                   	push   %eax
80103e41:	e8 72 db ff ff       	call   801019b8 <idup>
80103e46:	83 c4 10             	add    $0x10,%esp
80103e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e4c:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e52:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e58:	83 c0 6c             	add    $0x6c,%eax
80103e5b:	83 ec 04             	sub    $0x4,%esp
80103e5e:	6a 10                	push   $0x10
80103e60:	52                   	push   %edx
80103e61:	50                   	push   %eax
80103e62:	e8 5a 0f 00 00       	call   80104dc1 <safestrcpy>
80103e67:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e6d:	8b 40 10             	mov    0x10(%eax),%eax
80103e70:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	68 00 42 19 80       	push   $0x80194200
80103e7b:	e8 c8 0a 00 00       	call   80104948 <acquire>
80103e80:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e86:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 00 42 19 80       	push   $0x80194200
80103e95:	e8 1c 0b 00 00       	call   801049b6 <release>
80103e9a:	83 c4 10             	add    $0x10,%esp

  return pid;
80103e9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80103ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea3:	5b                   	pop    %ebx
80103ea4:	5e                   	pop    %esi
80103ea5:	5f                   	pop    %edi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret

80103ea8 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
80103ea8:	55                   	push   %ebp
80103ea9:	89 e5                	mov    %esp,%ebp
80103eab:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103eae:	e8 7d fb ff ff       	call   80103a30 <myproc>
80103eb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103eb6:	a1 34 62 19 80       	mov    0x80196234,%eax
80103ebb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ebe:	75 0d                	jne    80103ecd <exit+0x25>
    panic("init exiting");
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	68 f2 a4 10 80       	push   $0x8010a4f2
80103ec8:	e8 dc c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ecd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103ed4:	eb 3f                	jmp    80103f15 <exit+0x6d>
    if(curproc->ofile[fd]){
80103ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103edc:	83 c2 08             	add    $0x8,%edx
80103edf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ee3:	85 c0                	test   %eax,%eax
80103ee5:	74 2a                	je     80103f11 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103eed:	83 c2 08             	add    $0x8,%edx
80103ef0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	50                   	push   %eax
80103ef8:	e8 a8 d1 ff ff       	call   801010a5 <fileclose>
80103efd:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f06:	83 c2 08             	add    $0x8,%edx
80103f09:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f10:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103f11:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f15:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f19:	7e bb                	jle    80103ed6 <exit+0x2e>
    }
  }

  begin_op();
80103f1b:	e8 1e f1 ff ff       	call   8010303e <begin_op>
  iput(curproc->cwd);
80103f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f23:	8b 40 68             	mov    0x68(%eax),%eax
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	50                   	push   %eax
80103f2a:	e8 24 dc ff ff       	call   80101b53 <iput>
80103f2f:	83 c4 10             	add    $0x10,%esp
  end_op();
80103f32:	e8 93 f1 ff ff       	call   801030ca <end_op>
  curproc->cwd = 0;
80103f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f3a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 00 42 19 80       	push   $0x80194200
80103f49:	e8 fa 09 00 00       	call   80104948 <acquire>
80103f4e:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f54:	8b 40 14             	mov    0x14(%eax),%eax
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	50                   	push   %eax
80103f5b:	e8 20 04 00 00       	call   80104380 <wakeup1>
80103f60:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f63:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103f6a:	eb 37                	jmp    80103fa3 <exit+0xfb>
    if(p->parent == curproc){
80103f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f6f:	8b 40 14             	mov    0x14(%eax),%eax
80103f72:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f75:	75 28                	jne    80103f9f <exit+0xf7>
      p->parent = initproc;
80103f77:	8b 15 34 62 19 80    	mov    0x80196234,%edx
80103f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f80:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80103f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f86:	8b 40 0c             	mov    0xc(%eax),%eax
80103f89:	83 f8 05             	cmp    $0x5,%eax
80103f8c:	75 11                	jne    80103f9f <exit+0xf7>
        wakeup1(initproc);
80103f8e:	a1 34 62 19 80       	mov    0x80196234,%eax
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	50                   	push   %eax
80103f97:	e8 e4 03 00 00       	call   80104380 <wakeup1>
80103f9c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103fa3:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103faa:	72 c0                	jb     80103f6c <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103faf:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80103fb6:	e8 e5 01 00 00       	call   801041a0 <sched>
  panic("zombie exit");
80103fbb:	83 ec 0c             	sub    $0xc,%esp
80103fbe:	68 ff a4 10 80       	push   $0x8010a4ff
80103fc3:	e8 e1 c5 ff ff       	call   801005a9 <panic>

80103fc8 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103fc8:	55                   	push   %ebp
80103fc9:	89 e5                	mov    %esp,%ebp
80103fcb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103fce:	e8 5d fa ff ff       	call   80103a30 <myproc>
80103fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	68 00 42 19 80       	push   $0x80194200
80103fde:	e8 65 09 00 00       	call   80104948 <acquire>
80103fe3:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103fe6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fed:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103ff4:	e9 a1 00 00 00       	jmp    8010409a <wait+0xd2>
      if(p->parent != curproc)
80103ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffc:	8b 40 14             	mov    0x14(%eax),%eax
80103fff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104002:	0f 85 8d 00 00 00    	jne    80104095 <wait+0xcd>
        continue;
      havekids = 1;
80104008:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010400f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104012:	8b 40 0c             	mov    0xc(%eax),%eax
80104015:	83 f8 05             	cmp    $0x5,%eax
80104018:	75 7c                	jne    80104096 <wait+0xce>
        // Found one.
        pid = p->pid;
8010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401d:	8b 40 10             	mov    0x10(%eax),%eax
80104020:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104026:	8b 40 08             	mov    0x8(%eax),%eax
80104029:	83 ec 0c             	sub    $0xc,%esp
8010402c:	50                   	push   %eax
8010402d:	e8 dc e6 ff ff       	call   8010270e <kfree>
80104032:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104038:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010403f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104042:	8b 40 04             	mov    0x4(%eax),%eax
80104045:	83 ec 0c             	sub    $0xc,%esp
80104048:	50                   	push   %eax
80104049:	e8 7d 3a 00 00       	call   80107acb <freevm>
8010404e:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104054:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010405b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104068:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104079:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104080:	83 ec 0c             	sub    $0xc,%esp
80104083:	68 00 42 19 80       	push   $0x80194200
80104088:	e8 29 09 00 00       	call   801049b6 <release>
8010408d:	83 c4 10             	add    $0x10,%esp
        return pid;
80104090:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104093:	eb 51                	jmp    801040e6 <wait+0x11e>
        continue;
80104095:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104096:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010409a:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801040a1:	0f 82 52 ff ff ff    	jb     80103ff9 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801040a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801040ab:	74 0a                	je     801040b7 <wait+0xef>
801040ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040b0:	8b 40 24             	mov    0x24(%eax),%eax
801040b3:	85 c0                	test   %eax,%eax
801040b5:	74 17                	je     801040ce <wait+0x106>
      release(&ptable.lock);
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 00 42 19 80       	push   $0x80194200
801040bf:	e8 f2 08 00 00       	call   801049b6 <release>
801040c4:	83 c4 10             	add    $0x10,%esp
      return -1;
801040c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040cc:	eb 18                	jmp    801040e6 <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040ce:	83 ec 08             	sub    $0x8,%esp
801040d1:	68 00 42 19 80       	push   $0x80194200
801040d6:	ff 75 ec             	push   -0x14(%ebp)
801040d9:	e8 fb 01 00 00       	call   801042d9 <sleep>
801040de:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040e1:	e9 00 ff ff ff       	jmp    80103fe6 <wait+0x1e>
  }
}
801040e6:	c9                   	leave
801040e7:	c3                   	ret

801040e8 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801040e8:	55                   	push   %ebp
801040e9:	89 e5                	mov    %esp,%ebp
801040eb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801040ee:	e8 c5 f8 ff ff       	call   801039b8 <mycpu>
801040f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801040f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040f9:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104100:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104103:	e8 70 f8 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	68 00 42 19 80       	push   $0x80194200
80104110:	e8 33 08 00 00       	call   80104948 <acquire>
80104115:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104118:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010411f:	eb 61                	jmp    80104182 <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104124:	8b 40 0c             	mov    0xc(%eax),%eax
80104127:	83 f8 03             	cmp    $0x3,%eax
8010412a:	75 51                	jne    8010417d <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
8010412c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010412f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104132:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	ff 75 f4             	push   -0xc(%ebp)
8010413e:	e8 e3 34 00 00       	call   80107626 <switchuvm>
80104143:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104149:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104153:	8b 40 1c             	mov    0x1c(%eax),%eax
80104156:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104159:	83 c2 04             	add    $0x4,%edx
8010415c:	83 ec 08             	sub    $0x8,%esp
8010415f:	50                   	push   %eax
80104160:	52                   	push   %edx
80104161:	e8 cd 0c 00 00       	call   80104e33 <swtch>
80104166:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104169:	e8 9f 34 00 00       	call   8010760d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010416e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104171:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104178:	00 00 00 
8010417b:	eb 01                	jmp    8010417e <scheduler+0x96>
        continue;
8010417d:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417e:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104182:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104189:	72 96                	jb     80104121 <scheduler+0x39>
    }
    release(&ptable.lock);
8010418b:	83 ec 0c             	sub    $0xc,%esp
8010418e:	68 00 42 19 80       	push   $0x80194200
80104193:	e8 1e 08 00 00       	call   801049b6 <release>
80104198:	83 c4 10             	add    $0x10,%esp
    sti();
8010419b:	e9 63 ff ff ff       	jmp    80104103 <scheduler+0x1b>

801041a0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
801041a6:	e8 85 f8 ff ff       	call   80103a30 <myproc>
801041ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
801041ae:	83 ec 0c             	sub    $0xc,%esp
801041b1:	68 00 42 19 80       	push   $0x80194200
801041b6:	e8 c8 08 00 00       	call   80104a83 <holding>
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	85 c0                	test   %eax,%eax
801041c0:	75 0d                	jne    801041cf <sched+0x2f>
    panic("sched ptable.lock");
801041c2:	83 ec 0c             	sub    $0xc,%esp
801041c5:	68 0b a5 10 80       	push   $0x8010a50b
801041ca:	e8 da c3 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
801041cf:	e8 e4 f7 ff ff       	call   801039b8 <mycpu>
801041d4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041da:	83 f8 01             	cmp    $0x1,%eax
801041dd:	74 0d                	je     801041ec <sched+0x4c>
    panic("sched locks");
801041df:	83 ec 0c             	sub    $0xc,%esp
801041e2:	68 1d a5 10 80       	push   $0x8010a51d
801041e7:	e8 bd c3 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
801041ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ef:	8b 40 0c             	mov    0xc(%eax),%eax
801041f2:	83 f8 04             	cmp    $0x4,%eax
801041f5:	75 0d                	jne    80104204 <sched+0x64>
    panic("sched running");
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	68 29 a5 10 80       	push   $0x8010a529
801041ff:	e8 a5 c3 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104204:	e8 5f f7 ff ff       	call   80103968 <readeflags>
80104209:	25 00 02 00 00       	and    $0x200,%eax
8010420e:	85 c0                	test   %eax,%eax
80104210:	74 0d                	je     8010421f <sched+0x7f>
    panic("sched interruptible");
80104212:	83 ec 0c             	sub    $0xc,%esp
80104215:	68 37 a5 10 80       	push   $0x8010a537
8010421a:	e8 8a c3 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
8010421f:	e8 94 f7 ff ff       	call   801039b8 <mycpu>
80104224:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010422a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
8010422d:	e8 86 f7 ff ff       	call   801039b8 <mycpu>
80104232:	8b 40 04             	mov    0x4(%eax),%eax
80104235:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104238:	83 c2 1c             	add    $0x1c,%edx
8010423b:	83 ec 08             	sub    $0x8,%esp
8010423e:	50                   	push   %eax
8010423f:	52                   	push   %edx
80104240:	e8 ee 0b 00 00       	call   80104e33 <swtch>
80104245:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104248:	e8 6b f7 ff ff       	call   801039b8 <mycpu>
8010424d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104250:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104256:	90                   	nop
80104257:	c9                   	leave
80104258:	c3                   	ret

80104259 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104259:	55                   	push   %ebp
8010425a:	89 e5                	mov    %esp,%ebp
8010425c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010425f:	83 ec 0c             	sub    $0xc,%esp
80104262:	68 00 42 19 80       	push   $0x80194200
80104267:	e8 dc 06 00 00       	call   80104948 <acquire>
8010426c:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
8010426f:	e8 bc f7 ff ff       	call   80103a30 <myproc>
80104274:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010427b:	e8 20 ff ff ff       	call   801041a0 <sched>
  release(&ptable.lock);
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	68 00 42 19 80       	push   $0x80194200
80104288:	e8 29 07 00 00       	call   801049b6 <release>
8010428d:	83 c4 10             	add    $0x10,%esp
}
80104290:	90                   	nop
80104291:	c9                   	leave
80104292:	c3                   	ret

80104293 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104293:	55                   	push   %ebp
80104294:	89 e5                	mov    %esp,%ebp
80104296:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104299:	83 ec 0c             	sub    $0xc,%esp
8010429c:	68 00 42 19 80       	push   $0x80194200
801042a1:	e8 10 07 00 00       	call   801049b6 <release>
801042a6:	83 c4 10             	add    $0x10,%esp

  if (first) {
801042a9:	a1 04 f0 10 80       	mov    0x8010f004,%eax
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 24                	je     801042d6 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801042b2:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
801042b9:	00 00 00 
    iinit(ROOTDEV);
801042bc:	83 ec 0c             	sub    $0xc,%esp
801042bf:	6a 01                	push   $0x1
801042c1:	e8 bb d3 ff ff       	call   80101681 <iinit>
801042c6:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801042c9:	83 ec 0c             	sub    $0xc,%esp
801042cc:	6a 01                	push   $0x1
801042ce:	e8 4c eb ff ff       	call   80102e1f <initlog>
801042d3:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801042d6:	90                   	nop
801042d7:	c9                   	leave
801042d8:	c3                   	ret

801042d9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801042d9:	55                   	push   %ebp
801042da:	89 e5                	mov    %esp,%ebp
801042dc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
801042df:	e8 4c f7 ff ff       	call   80103a30 <myproc>
801042e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801042e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042eb:	75 0d                	jne    801042fa <sleep+0x21>
    panic("sleep");
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	68 4b a5 10 80       	push   $0x8010a54b
801042f5:	e8 af c2 ff ff       	call   801005a9 <panic>

  if(lk == 0)
801042fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801042fe:	75 0d                	jne    8010430d <sleep+0x34>
    panic("sleep without lk");
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 51 a5 10 80       	push   $0x8010a551
80104308:	e8 9c c2 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010430d:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104314:	74 1e                	je     80104334 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 00 42 19 80       	push   $0x80194200
8010431e:	e8 25 06 00 00       	call   80104948 <acquire>
80104323:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	ff 75 0c             	push   0xc(%ebp)
8010432c:	e8 85 06 00 00       	call   801049b6 <release>
80104331:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104337:	8b 55 08             	mov    0x8(%ebp),%edx
8010433a:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
8010433d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104340:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104347:	e8 54 fe ff ff       	call   801041a0 <sched>

  // Tidy up.
  p->chan = 0;
8010434c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104356:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
8010435d:	74 1e                	je     8010437d <sleep+0xa4>
    release(&ptable.lock);
8010435f:	83 ec 0c             	sub    $0xc,%esp
80104362:	68 00 42 19 80       	push   $0x80194200
80104367:	e8 4a 06 00 00       	call   801049b6 <release>
8010436c:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	ff 75 0c             	push   0xc(%ebp)
80104375:	e8 ce 05 00 00       	call   80104948 <acquire>
8010437a:	83 c4 10             	add    $0x10,%esp
  }
}
8010437d:	90                   	nop
8010437e:	c9                   	leave
8010437f:	c3                   	ret

80104380 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104386:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
8010438d:	eb 24                	jmp    801043b3 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
8010438f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104392:	8b 40 0c             	mov    0xc(%eax),%eax
80104395:	83 f8 02             	cmp    $0x2,%eax
80104398:	75 15                	jne    801043af <wakeup1+0x2f>
8010439a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010439d:	8b 40 20             	mov    0x20(%eax),%eax
801043a0:	39 45 08             	cmp    %eax,0x8(%ebp)
801043a3:	75 0a                	jne    801043af <wakeup1+0x2f>
      p->state = RUNNABLE;
801043a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801043a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043af:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
801043b3:	81 7d fc 34 62 19 80 	cmpl   $0x80196234,-0x4(%ebp)
801043ba:	72 d3                	jb     8010438f <wakeup1+0xf>
}
801043bc:	90                   	nop
801043bd:	90                   	nop
801043be:	c9                   	leave
801043bf:	c3                   	ret

801043c0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 00 42 19 80       	push   $0x80194200
801043ce:	e8 75 05 00 00       	call   80104948 <acquire>
801043d3:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	ff 75 08             	push   0x8(%ebp)
801043dc:	e8 9f ff ff ff       	call   80104380 <wakeup1>
801043e1:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	68 00 42 19 80       	push   $0x80194200
801043ec:	e8 c5 05 00 00       	call   801049b6 <release>
801043f1:	83 c4 10             	add    $0x10,%esp
}
801043f4:	90                   	nop
801043f5:	c9                   	leave
801043f6:	c3                   	ret

801043f7 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043f7:	55                   	push   %ebp
801043f8:	89 e5                	mov    %esp,%ebp
801043fa:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	68 00 42 19 80       	push   $0x80194200
80104405:	e8 3e 05 00 00       	call   80104948 <acquire>
8010440a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010440d:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104414:	eb 45                	jmp    8010445b <kill+0x64>
    if(p->pid == pid){
80104416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104419:	8b 40 10             	mov    0x10(%eax),%eax
8010441c:	39 45 08             	cmp    %eax,0x8(%ebp)
8010441f:	75 36                	jne    80104457 <kill+0x60>
      p->killed = 1;
80104421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104424:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442e:	8b 40 0c             	mov    0xc(%eax),%eax
80104431:	83 f8 02             	cmp    $0x2,%eax
80104434:	75 0a                	jne    80104440 <kill+0x49>
        p->state = RUNNABLE;
80104436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104439:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 00 42 19 80       	push   $0x80194200
80104448:	e8 69 05 00 00       	call   801049b6 <release>
8010444d:	83 c4 10             	add    $0x10,%esp
      return 0;
80104450:	b8 00 00 00 00       	mov    $0x0,%eax
80104455:	eb 22                	jmp    80104479 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104457:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010445b:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104462:	72 b2                	jb     80104416 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	68 00 42 19 80       	push   $0x80194200
8010446c:	e8 45 05 00 00       	call   801049b6 <release>
80104471:	83 c4 10             	add    $0x10,%esp
  return -1;
80104474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104479:	c9                   	leave
8010447a:	c3                   	ret

8010447b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010447b:	55                   	push   %ebp
8010447c:	89 e5                	mov    %esp,%ebp
8010447e:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104481:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
80104488:	e9 d7 00 00 00       	jmp    80104564 <procdump+0xe9>
    if(p->state == UNUSED)
8010448d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104490:	8b 40 0c             	mov    0xc(%eax),%eax
80104493:	85 c0                	test   %eax,%eax
80104495:	0f 84 c4 00 00 00    	je     8010455f <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010449b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010449e:	8b 40 0c             	mov    0xc(%eax),%eax
801044a1:	83 f8 05             	cmp    $0x5,%eax
801044a4:	77 23                	ja     801044c9 <procdump+0x4e>
801044a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a9:	8b 40 0c             	mov    0xc(%eax),%eax
801044ac:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801044b3:	85 c0                	test   %eax,%eax
801044b5:	74 12                	je     801044c9 <procdump+0x4e>
      state = states[p->state];
801044b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044ba:	8b 40 0c             	mov    0xc(%eax),%eax
801044bd:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801044c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801044c7:	eb 07                	jmp    801044d0 <procdump+0x55>
    else
      state = "???";
801044c9:	c7 45 ec 62 a5 10 80 	movl   $0x8010a562,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801044d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d3:	8d 50 6c             	lea    0x6c(%eax),%edx
801044d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d9:	8b 40 10             	mov    0x10(%eax),%eax
801044dc:	52                   	push   %edx
801044dd:	ff 75 ec             	push   -0x14(%ebp)
801044e0:	50                   	push   %eax
801044e1:	68 66 a5 10 80       	push   $0x8010a566
801044e6:	e8 09 bf ff ff       	call   801003f4 <cprintf>
801044eb:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801044ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044f1:	8b 40 0c             	mov    0xc(%eax),%eax
801044f4:	83 f8 02             	cmp    $0x2,%eax
801044f7:	75 54                	jne    8010454d <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044fc:	8b 40 1c             	mov    0x1c(%eax),%eax
801044ff:	8b 40 0c             	mov    0xc(%eax),%eax
80104502:	83 c0 08             	add    $0x8,%eax
80104505:	89 c2                	mov    %eax,%edx
80104507:	83 ec 08             	sub    $0x8,%esp
8010450a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010450d:	50                   	push   %eax
8010450e:	52                   	push   %edx
8010450f:	e8 f4 04 00 00       	call   80104a08 <getcallerpcs>
80104514:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104517:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010451e:	eb 1c                	jmp    8010453c <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104523:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104527:	83 ec 08             	sub    $0x8,%esp
8010452a:	50                   	push   %eax
8010452b:	68 6f a5 10 80       	push   $0x8010a56f
80104530:	e8 bf be ff ff       	call   801003f4 <cprintf>
80104535:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104538:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010453c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104540:	7f 0b                	jg     8010454d <procdump+0xd2>
80104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104545:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104549:	85 c0                	test   %eax,%eax
8010454b:	75 d3                	jne    80104520 <procdump+0xa5>
    }
    cprintf("\n");
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	68 73 a5 10 80       	push   $0x8010a573
80104555:	e8 9a be ff ff       	call   801003f4 <cprintf>
8010455a:	83 c4 10             	add    $0x10,%esp
8010455d:	eb 01                	jmp    80104560 <procdump+0xe5>
      continue;
8010455f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104560:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104564:	81 7d f0 34 62 19 80 	cmpl   $0x80196234,-0x10(%ebp)
8010456b:	0f 82 1c ff ff ff    	jb     8010448d <procdump+0x12>
  }
}
80104571:	90                   	nop
80104572:	90                   	nop
80104573:	c9                   	leave
80104574:	c3                   	ret

80104575 <exit2>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit2(int status)
{
80104575:	55                   	push   %ebp
80104576:	89 e5                	mov    %esp,%ebp
80104578:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010457b:	e8 b0 f4 ff ff       	call   80103a30 <myproc>
80104580:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104583:	a1 34 62 19 80       	mov    0x80196234,%eax
80104588:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010458b:	75 0d                	jne    8010459a <exit2+0x25>
    panic("init exiting");
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 f2 a4 10 80       	push   $0x8010a4f2
80104595:	e8 0f c0 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010459a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801045a1:	eb 3f                	jmp    801045e2 <exit2+0x6d>
    if(curproc->ofile[fd]){
801045a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045a9:	83 c2 08             	add    $0x8,%edx
801045ac:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045b0:	85 c0                	test   %eax,%eax
801045b2:	74 2a                	je     801045de <exit2+0x69>
      fileclose(curproc->ofile[fd]);
801045b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045ba:	83 c2 08             	add    $0x8,%edx
801045bd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045c1:	83 ec 0c             	sub    $0xc,%esp
801045c4:	50                   	push   %eax
801045c5:	e8 db ca ff ff       	call   801010a5 <fileclose>
801045ca:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801045cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045d3:	83 c2 08             	add    $0x8,%edx
801045d6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045dd:	00 
  for(fd = 0; fd < NOFILE; fd++){
801045de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801045e2:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801045e6:	7e bb                	jle    801045a3 <exit2+0x2e>
    }
  }

  begin_op();
801045e8:	e8 51 ea ff ff       	call   8010303e <begin_op>
  iput(curproc->cwd);
801045ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045f0:	8b 40 68             	mov    0x68(%eax),%eax
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	50                   	push   %eax
801045f7:	e8 57 d5 ff ff       	call   80101b53 <iput>
801045fc:	83 c4 10             	add    $0x10,%esp
  end_op();
801045ff:	e8 c6 ea ff ff       	call   801030ca <end_op>
  curproc->cwd = 0;
80104604:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104607:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  
  acquire(&ptable.lock);
8010460e:	83 ec 0c             	sub    $0xc,%esp
80104611:	68 00 42 19 80       	push   $0x80194200
80104616:	e8 2d 03 00 00       	call   80104948 <acquire>
8010461b:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010461e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104621:	8b 40 14             	mov    0x14(%eax),%eax
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	50                   	push   %eax
80104628:	e8 53 fd ff ff       	call   80104380 <wakeup1>
8010462d:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104630:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104637:	eb 37                	jmp    80104670 <exit2+0xfb>
    if(p->parent == curproc){
80104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463c:	8b 40 14             	mov    0x14(%eax),%eax
8010463f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104642:	75 28                	jne    8010466c <exit2+0xf7>
      p->parent = initproc;
80104644:	8b 15 34 62 19 80    	mov    0x80196234,%edx
8010464a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464d:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104653:	8b 40 0c             	mov    0xc(%eax),%eax
80104656:	83 f8 05             	cmp    $0x5,%eax
80104659:	75 11                	jne    8010466c <exit2+0xf7>
        wakeup1(initproc);
8010465b:	a1 34 62 19 80       	mov    0x80196234,%eax
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	50                   	push   %eax
80104664:	e8 17 fd ff ff       	call   80104380 <wakeup1>
80104669:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010466c:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104670:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104677:	72 c0                	jb     80104639 <exit2+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->xstate = status;
80104679:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010467c:	8b 55 08             	mov    0x8(%ebp),%edx
8010467f:	89 50 7c             	mov    %edx,0x7c(%eax)
  curproc->state = ZOMBIE;
80104682:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104685:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010468c:	e8 0f fb ff ff       	call   801041a0 <sched>
  panic("zombie exit2");
80104691:	83 ec 0c             	sub    $0xc,%esp
80104694:	68 75 a5 10 80       	push   $0x8010a575
80104699:	e8 0b bf ff ff       	call   801005a9 <panic>

8010469e <wait2>:
}

// Wait for a child process to exit2 and return its pid.
// Return -1 if this process has no children.
int wait2(int* status)
{
8010469e:	55                   	push   %ebp
8010469f:	89 e5                	mov    %esp,%ebp
801046a1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801046a4:	e8 87 f3 ff ff       	call   80103a30 <myproc>
801046a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	68 00 42 19 80       	push   $0x80194200
801046b4:	e8 8f 02 00 00       	call   80104948 <acquire>
801046b9:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c3:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046ca:	e9 ac 00 00 00       	jmp    8010477b <wait2+0xdd>
      *status = p->xstate;
801046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d2:	8b 50 7c             	mov    0x7c(%eax),%edx
801046d5:	8b 45 08             	mov    0x8(%ebp),%eax
801046d8:	89 10                	mov    %edx,(%eax)
      if(p->parent != curproc)
801046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dd:	8b 40 14             	mov    0x14(%eax),%eax
801046e0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801046e3:	0f 85 8d 00 00 00    	jne    80104776 <wait2+0xd8>
        continue;
      havekids = 1;
801046e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f3:	8b 40 0c             	mov    0xc(%eax),%eax
801046f6:	83 f8 05             	cmp    $0x5,%eax
801046f9:	75 7c                	jne    80104777 <wait2+0xd9>
        // Found one.
        pid = p->pid;
801046fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fe:	8b 40 10             	mov    0x10(%eax),%eax
80104701:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104707:	8b 40 08             	mov    0x8(%eax),%eax
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	50                   	push   %eax
8010470e:	e8 fb df ff ff       	call   8010270e <kfree>
80104713:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104719:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104723:	8b 40 04             	mov    0x4(%eax),%eax
80104726:	83 ec 0c             	sub    $0xc,%esp
80104729:	50                   	push   %eax
8010472a:	e8 9c 33 00 00       	call   80107acb <freevm>
8010472f:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104735:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104749:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010474d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104750:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104761:	83 ec 0c             	sub    $0xc,%esp
80104764:	68 00 42 19 80       	push   $0x80194200
80104769:	e8 48 02 00 00       	call   801049b6 <release>
8010476e:	83 c4 10             	add    $0x10,%esp
        return pid;
80104771:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104774:	eb 51                	jmp    801047c7 <wait2+0x129>
        continue;
80104776:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104777:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010477b:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104782:	0f 82 47 ff ff ff    	jb     801046cf <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010478c:	74 0a                	je     80104798 <wait2+0xfa>
8010478e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104791:	8b 40 24             	mov    0x24(%eax),%eax
80104794:	85 c0                	test   %eax,%eax
80104796:	74 17                	je     801047af <wait2+0x111>
      release(&ptable.lock);
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 00 42 19 80       	push   $0x80194200
801047a0:	e8 11 02 00 00       	call   801049b6 <release>
801047a5:	83 c4 10             	add    $0x10,%esp
      return -1;
801047a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ad:	eb 18                	jmp    801047c7 <wait2+0x129>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801047af:	83 ec 08             	sub    $0x8,%esp
801047b2:	68 00 42 19 80       	push   $0x80194200
801047b7:	ff 75 ec             	push   -0x14(%ebp)
801047ba:	e8 1a fb ff ff       	call   801042d9 <sleep>
801047bf:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047c2:	e9 f5 fe ff ff       	jmp    801046bc <wait2+0x1e>
  }
}
801047c7:	c9                   	leave
801047c8:	c3                   	ret

801047c9 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047c9:	55                   	push   %ebp
801047ca:	89 e5                	mov    %esp,%ebp
801047cc:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801047cf:	8b 45 08             	mov    0x8(%ebp),%eax
801047d2:	83 c0 04             	add    $0x4,%eax
801047d5:	83 ec 08             	sub    $0x8,%esp
801047d8:	68 ac a5 10 80       	push   $0x8010a5ac
801047dd:	50                   	push   %eax
801047de:	e8 43 01 00 00       	call   80104926 <initlock>
801047e3:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801047e6:	8b 45 08             	mov    0x8(%ebp),%eax
801047e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801047ec:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801047ef:	8b 45 08             	mov    0x8(%ebp),%eax
801047f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801047f8:	8b 45 08             	mov    0x8(%ebp),%eax
801047fb:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104802:	90                   	nop
80104803:	c9                   	leave
80104804:	c3                   	ret

80104805 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104805:	55                   	push   %ebp
80104806:	89 e5                	mov    %esp,%ebp
80104808:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010480b:	8b 45 08             	mov    0x8(%ebp),%eax
8010480e:	83 c0 04             	add    $0x4,%eax
80104811:	83 ec 0c             	sub    $0xc,%esp
80104814:	50                   	push   %eax
80104815:	e8 2e 01 00 00       	call   80104948 <acquire>
8010481a:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010481d:	eb 15                	jmp    80104834 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
8010481f:	8b 45 08             	mov    0x8(%ebp),%eax
80104822:	83 c0 04             	add    $0x4,%eax
80104825:	83 ec 08             	sub    $0x8,%esp
80104828:	50                   	push   %eax
80104829:	ff 75 08             	push   0x8(%ebp)
8010482c:	e8 a8 fa ff ff       	call   801042d9 <sleep>
80104831:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104834:	8b 45 08             	mov    0x8(%ebp),%eax
80104837:	8b 00                	mov    (%eax),%eax
80104839:	85 c0                	test   %eax,%eax
8010483b:	75 e2                	jne    8010481f <acquiresleep+0x1a>
  }
  lk->locked = 1;
8010483d:	8b 45 08             	mov    0x8(%ebp),%eax
80104840:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104846:	e8 e5 f1 ff ff       	call   80103a30 <myproc>
8010484b:	8b 50 10             	mov    0x10(%eax),%edx
8010484e:	8b 45 08             	mov    0x8(%ebp),%eax
80104851:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104854:	8b 45 08             	mov    0x8(%ebp),%eax
80104857:	83 c0 04             	add    $0x4,%eax
8010485a:	83 ec 0c             	sub    $0xc,%esp
8010485d:	50                   	push   %eax
8010485e:	e8 53 01 00 00       	call   801049b6 <release>
80104863:	83 c4 10             	add    $0x10,%esp
}
80104866:	90                   	nop
80104867:	c9                   	leave
80104868:	c3                   	ret

80104869 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104869:	55                   	push   %ebp
8010486a:	89 e5                	mov    %esp,%ebp
8010486c:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010486f:	8b 45 08             	mov    0x8(%ebp),%eax
80104872:	83 c0 04             	add    $0x4,%eax
80104875:	83 ec 0c             	sub    $0xc,%esp
80104878:	50                   	push   %eax
80104879:	e8 ca 00 00 00       	call   80104948 <acquire>
8010487e:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104881:	8b 45 08             	mov    0x8(%ebp),%eax
80104884:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010488a:	8b 45 08             	mov    0x8(%ebp),%eax
8010488d:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104894:	83 ec 0c             	sub    $0xc,%esp
80104897:	ff 75 08             	push   0x8(%ebp)
8010489a:	e8 21 fb ff ff       	call   801043c0 <wakeup>
8010489f:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801048a2:	8b 45 08             	mov    0x8(%ebp),%eax
801048a5:	83 c0 04             	add    $0x4,%eax
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	50                   	push   %eax
801048ac:	e8 05 01 00 00       	call   801049b6 <release>
801048b1:	83 c4 10             	add    $0x10,%esp
}
801048b4:	90                   	nop
801048b5:	c9                   	leave
801048b6:	c3                   	ret

801048b7 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048b7:	55                   	push   %ebp
801048b8:	89 e5                	mov    %esp,%ebp
801048ba:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
801048bd:	8b 45 08             	mov    0x8(%ebp),%eax
801048c0:	83 c0 04             	add    $0x4,%eax
801048c3:	83 ec 0c             	sub    $0xc,%esp
801048c6:	50                   	push   %eax
801048c7:	e8 7c 00 00 00       	call   80104948 <acquire>
801048cc:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
801048cf:	8b 45 08             	mov    0x8(%ebp),%eax
801048d2:	8b 00                	mov    (%eax),%eax
801048d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801048d7:	8b 45 08             	mov    0x8(%ebp),%eax
801048da:	83 c0 04             	add    $0x4,%eax
801048dd:	83 ec 0c             	sub    $0xc,%esp
801048e0:	50                   	push   %eax
801048e1:	e8 d0 00 00 00       	call   801049b6 <release>
801048e6:	83 c4 10             	add    $0x10,%esp
  return r;
801048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801048ec:	c9                   	leave
801048ed:	c3                   	ret

801048ee <readeflags>:
{
801048ee:	55                   	push   %ebp
801048ef:	89 e5                	mov    %esp,%ebp
801048f1:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048f4:	9c                   	pushf
801048f5:	58                   	pop    %eax
801048f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801048f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801048fc:	c9                   	leave
801048fd:	c3                   	ret

801048fe <cli>:
{
801048fe:	55                   	push   %ebp
801048ff:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104901:	fa                   	cli
}
80104902:	90                   	nop
80104903:	5d                   	pop    %ebp
80104904:	c3                   	ret

80104905 <sti>:
{
80104905:	55                   	push   %ebp
80104906:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104908:	fb                   	sti
}
80104909:	90                   	nop
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret

8010490c <xchg>:
{
8010490c:	55                   	push   %ebp
8010490d:	89 e5                	mov    %esp,%ebp
8010490f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104912:	8b 55 08             	mov    0x8(%ebp),%edx
80104915:	8b 45 0c             	mov    0xc(%ebp),%eax
80104918:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010491b:	f0 87 02             	lock xchg %eax,(%edx)
8010491e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104921:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104924:	c9                   	leave
80104925:	c3                   	ret

80104926 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104926:	55                   	push   %ebp
80104927:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104929:	8b 45 08             	mov    0x8(%ebp),%eax
8010492c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010492f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104932:	8b 45 08             	mov    0x8(%ebp),%eax
80104935:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010493b:	8b 45 08             	mov    0x8(%ebp),%eax
8010493e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104945:	90                   	nop
80104946:	5d                   	pop    %ebp
80104947:	c3                   	ret

80104948 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104948:	55                   	push   %ebp
80104949:	89 e5                	mov    %esp,%ebp
8010494b:	53                   	push   %ebx
8010494c:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010494f:	e8 5f 01 00 00       	call   80104ab3 <pushcli>
  if(holding(lk)){
80104954:	8b 45 08             	mov    0x8(%ebp),%eax
80104957:	83 ec 0c             	sub    $0xc,%esp
8010495a:	50                   	push   %eax
8010495b:	e8 23 01 00 00       	call   80104a83 <holding>
80104960:	83 c4 10             	add    $0x10,%esp
80104963:	85 c0                	test   %eax,%eax
80104965:	74 0d                	je     80104974 <acquire+0x2c>
    panic("acquire");
80104967:	83 ec 0c             	sub    $0xc,%esp
8010496a:	68 b7 a5 10 80       	push   $0x8010a5b7
8010496f:	e8 35 bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104974:	90                   	nop
80104975:	8b 45 08             	mov    0x8(%ebp),%eax
80104978:	83 ec 08             	sub    $0x8,%esp
8010497b:	6a 01                	push   $0x1
8010497d:	50                   	push   %eax
8010497e:	e8 89 ff ff ff       	call   8010490c <xchg>
80104983:	83 c4 10             	add    $0x10,%esp
80104986:	85 c0                	test   %eax,%eax
80104988:	75 eb                	jne    80104975 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010498a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010498f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104992:	e8 21 f0 ff ff       	call   801039b8 <mycpu>
80104997:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010499a:	8b 45 08             	mov    0x8(%ebp),%eax
8010499d:	83 c0 0c             	add    $0xc,%eax
801049a0:	83 ec 08             	sub    $0x8,%esp
801049a3:	50                   	push   %eax
801049a4:	8d 45 08             	lea    0x8(%ebp),%eax
801049a7:	50                   	push   %eax
801049a8:	e8 5b 00 00 00       	call   80104a08 <getcallerpcs>
801049ad:	83 c4 10             	add    $0x10,%esp
}
801049b0:	90                   	nop
801049b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b4:	c9                   	leave
801049b5:	c3                   	ret

801049b6 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801049b6:	55                   	push   %ebp
801049b7:	89 e5                	mov    %esp,%ebp
801049b9:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801049bc:	83 ec 0c             	sub    $0xc,%esp
801049bf:	ff 75 08             	push   0x8(%ebp)
801049c2:	e8 bc 00 00 00       	call   80104a83 <holding>
801049c7:	83 c4 10             	add    $0x10,%esp
801049ca:	85 c0                	test   %eax,%eax
801049cc:	75 0d                	jne    801049db <release+0x25>
    panic("release");
801049ce:	83 ec 0c             	sub    $0xc,%esp
801049d1:	68 bf a5 10 80       	push   $0x8010a5bf
801049d6:	e8 ce bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
801049db:	8b 45 08             	mov    0x8(%ebp),%eax
801049de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801049e5:	8b 45 08             	mov    0x8(%ebp),%eax
801049e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801049ef:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049f4:	8b 45 08             	mov    0x8(%ebp),%eax
801049f7:	8b 55 08             	mov    0x8(%ebp),%edx
801049fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a00:	e8 fb 00 00 00       	call   80104b00 <popcli>
}
80104a05:	90                   	nop
80104a06:	c9                   	leave
80104a07:	c3                   	ret

80104a08 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a08:	55                   	push   %ebp
80104a09:	89 e5                	mov    %esp,%ebp
80104a0b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80104a11:	83 e8 08             	sub    $0x8,%eax
80104a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a1e:	eb 38                	jmp    80104a58 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a24:	74 53                	je     80104a79 <getcallerpcs+0x71>
80104a26:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a2d:	76 4a                	jbe    80104a79 <getcallerpcs+0x71>
80104a2f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104a33:	74 44                	je     80104a79 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a42:	01 c2                	add    %eax,%edx
80104a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a47:	8b 40 04             	mov    0x4(%eax),%eax
80104a4a:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a4f:	8b 00                	mov    (%eax),%eax
80104a51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a54:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a58:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a5c:	7e c2                	jle    80104a20 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104a5e:	eb 19                	jmp    80104a79 <getcallerpcs+0x71>
    pcs[i] = 0;
80104a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a6d:	01 d0                	add    %edx,%eax
80104a6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a75:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a79:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a7d:	7e e1                	jle    80104a60 <getcallerpcs+0x58>
}
80104a7f:	90                   	nop
80104a80:	90                   	nop
80104a81:	c9                   	leave
80104a82:	c3                   	ret

80104a83 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a83:	55                   	push   %ebp
80104a84:	89 e5                	mov    %esp,%ebp
80104a86:	53                   	push   %ebx
80104a87:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80104a8d:	8b 00                	mov    (%eax),%eax
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	74 16                	je     80104aa9 <holding+0x26>
80104a93:	8b 45 08             	mov    0x8(%ebp),%eax
80104a96:	8b 58 08             	mov    0x8(%eax),%ebx
80104a99:	e8 1a ef ff ff       	call   801039b8 <mycpu>
80104a9e:	39 c3                	cmp    %eax,%ebx
80104aa0:	75 07                	jne    80104aa9 <holding+0x26>
80104aa2:	b8 01 00 00 00       	mov    $0x1,%eax
80104aa7:	eb 05                	jmp    80104aae <holding+0x2b>
80104aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab1:	c9                   	leave
80104ab2:	c3                   	ret

80104ab3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ab3:	55                   	push   %ebp
80104ab4:	89 e5                	mov    %esp,%ebp
80104ab6:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104ab9:	e8 30 fe ff ff       	call   801048ee <readeflags>
80104abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104ac1:	e8 38 fe ff ff       	call   801048fe <cli>
  if(mycpu()->ncli == 0)
80104ac6:	e8 ed ee ff ff       	call   801039b8 <mycpu>
80104acb:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ad1:	85 c0                	test   %eax,%eax
80104ad3:	75 14                	jne    80104ae9 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104ad5:	e8 de ee ff ff       	call   801039b8 <mycpu>
80104ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104add:	81 e2 00 02 00 00    	and    $0x200,%edx
80104ae3:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104ae9:	e8 ca ee ff ff       	call   801039b8 <mycpu>
80104aee:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104af4:	83 c2 01             	add    $0x1,%edx
80104af7:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104afd:	90                   	nop
80104afe:	c9                   	leave
80104aff:	c3                   	ret

80104b00 <popcli>:

void
popcli(void)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b06:	e8 e3 fd ff ff       	call   801048ee <readeflags>
80104b0b:	25 00 02 00 00       	and    $0x200,%eax
80104b10:	85 c0                	test   %eax,%eax
80104b12:	74 0d                	je     80104b21 <popcli+0x21>
    panic("popcli - interruptible");
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	68 c7 a5 10 80       	push   $0x8010a5c7
80104b1c:	e8 88 ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b21:	e8 92 ee ff ff       	call   801039b8 <mycpu>
80104b26:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b2c:	83 ea 01             	sub    $0x1,%edx
80104b2f:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b35:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	79 0d                	jns    80104b4c <popcli+0x4c>
    panic("popcli");
80104b3f:	83 ec 0c             	sub    $0xc,%esp
80104b42:	68 de a5 10 80       	push   $0x8010a5de
80104b47:	e8 5d ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b4c:	e8 67 ee ff ff       	call   801039b8 <mycpu>
80104b51:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b57:	85 c0                	test   %eax,%eax
80104b59:	75 14                	jne    80104b6f <popcli+0x6f>
80104b5b:	e8 58 ee ff ff       	call   801039b8 <mycpu>
80104b60:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b66:	85 c0                	test   %eax,%eax
80104b68:	74 05                	je     80104b6f <popcli+0x6f>
    sti();
80104b6a:	e8 96 fd ff ff       	call   80104905 <sti>
}
80104b6f:	90                   	nop
80104b70:	c9                   	leave
80104b71:	c3                   	ret

80104b72 <stosb>:
{
80104b72:	55                   	push   %ebp
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	57                   	push   %edi
80104b76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104b77:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b7a:	8b 55 10             	mov    0x10(%ebp),%edx
80104b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b80:	89 cb                	mov    %ecx,%ebx
80104b82:	89 df                	mov    %ebx,%edi
80104b84:	89 d1                	mov    %edx,%ecx
80104b86:	fc                   	cld
80104b87:	f3 aa                	rep stos %al,%es:(%edi)
80104b89:	89 ca                	mov    %ecx,%edx
80104b8b:	89 fb                	mov    %edi,%ebx
80104b8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b90:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b93:	90                   	nop
80104b94:	5b                   	pop    %ebx
80104b95:	5f                   	pop    %edi
80104b96:	5d                   	pop    %ebp
80104b97:	c3                   	ret

80104b98 <stosl>:
{
80104b98:	55                   	push   %ebp
80104b99:	89 e5                	mov    %esp,%ebp
80104b9b:	57                   	push   %edi
80104b9c:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104b9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ba0:	8b 55 10             	mov    0x10(%ebp),%edx
80104ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba6:	89 cb                	mov    %ecx,%ebx
80104ba8:	89 df                	mov    %ebx,%edi
80104baa:	89 d1                	mov    %edx,%ecx
80104bac:	fc                   	cld
80104bad:	f3 ab                	rep stos %eax,%es:(%edi)
80104baf:	89 ca                	mov    %ecx,%edx
80104bb1:	89 fb                	mov    %edi,%ebx
80104bb3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bb6:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104bb9:	90                   	nop
80104bba:	5b                   	pop    %ebx
80104bbb:	5f                   	pop    %edi
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret

80104bbe <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bbe:	55                   	push   %ebp
80104bbf:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc4:	83 e0 03             	and    $0x3,%eax
80104bc7:	85 c0                	test   %eax,%eax
80104bc9:	75 43                	jne    80104c0e <memset+0x50>
80104bcb:	8b 45 10             	mov    0x10(%ebp),%eax
80104bce:	83 e0 03             	and    $0x3,%eax
80104bd1:	85 c0                	test   %eax,%eax
80104bd3:	75 39                	jne    80104c0e <memset+0x50>
    c &= 0xFF;
80104bd5:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104bdc:	8b 45 10             	mov    0x10(%ebp),%eax
80104bdf:	c1 e8 02             	shr    $0x2,%eax
80104be2:	89 c1                	mov    %eax,%ecx
80104be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104be7:	c1 e0 18             	shl    $0x18,%eax
80104bea:	89 c2                	mov    %eax,%edx
80104bec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bef:	c1 e0 10             	shl    $0x10,%eax
80104bf2:	09 c2                	or     %eax,%edx
80104bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf7:	c1 e0 08             	shl    $0x8,%eax
80104bfa:	09 d0                	or     %edx,%eax
80104bfc:	0b 45 0c             	or     0xc(%ebp),%eax
80104bff:	51                   	push   %ecx
80104c00:	50                   	push   %eax
80104c01:	ff 75 08             	push   0x8(%ebp)
80104c04:	e8 8f ff ff ff       	call   80104b98 <stosl>
80104c09:	83 c4 0c             	add    $0xc,%esp
80104c0c:	eb 12                	jmp    80104c20 <memset+0x62>
  } else
    stosb(dst, c, n);
80104c0e:	8b 45 10             	mov    0x10(%ebp),%eax
80104c11:	50                   	push   %eax
80104c12:	ff 75 0c             	push   0xc(%ebp)
80104c15:	ff 75 08             	push   0x8(%ebp)
80104c18:	e8 55 ff ff ff       	call   80104b72 <stosb>
80104c1d:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104c20:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104c23:	c9                   	leave
80104c24:	c3                   	ret

80104c25 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c25:	55                   	push   %ebp
80104c26:	89 e5                	mov    %esp,%ebp
80104c28:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104c31:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c34:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104c37:	eb 2e                	jmp    80104c67 <memcmp+0x42>
    if(*s1 != *s2)
80104c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c3c:	0f b6 10             	movzbl (%eax),%edx
80104c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c42:	0f b6 00             	movzbl (%eax),%eax
80104c45:	38 c2                	cmp    %al,%dl
80104c47:	74 16                	je     80104c5f <memcmp+0x3a>
      return *s1 - *s2;
80104c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c4c:	0f b6 00             	movzbl (%eax),%eax
80104c4f:	0f b6 d0             	movzbl %al,%edx
80104c52:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c55:	0f b6 00             	movzbl (%eax),%eax
80104c58:	0f b6 c0             	movzbl %al,%eax
80104c5b:	29 c2                	sub    %eax,%edx
80104c5d:	eb 1a                	jmp    80104c79 <memcmp+0x54>
    s1++, s2++;
80104c5f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104c63:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104c67:	8b 45 10             	mov    0x10(%ebp),%eax
80104c6a:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c6d:	89 55 10             	mov    %edx,0x10(%ebp)
80104c70:	85 c0                	test   %eax,%eax
80104c72:	75 c5                	jne    80104c39 <memcmp+0x14>
  }

  return 0;
80104c74:	ba 00 00 00 00       	mov    $0x0,%edx
}
80104c79:	89 d0                	mov    %edx,%eax
80104c7b:	c9                   	leave
80104c7c:	c3                   	ret

80104c7d <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c7d:	55                   	push   %ebp
80104c7e:	89 e5                	mov    %esp,%ebp
80104c80:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104c83:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104c89:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104c95:	73 54                	jae    80104ceb <memmove+0x6e>
80104c97:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c9a:	8b 45 10             	mov    0x10(%ebp),%eax
80104c9d:	01 d0                	add    %edx,%eax
80104c9f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104ca2:	73 47                	jae    80104ceb <memmove+0x6e>
    s += n;
80104ca4:	8b 45 10             	mov    0x10(%ebp),%eax
80104ca7:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104caa:	8b 45 10             	mov    0x10(%ebp),%eax
80104cad:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104cb0:	eb 13                	jmp    80104cc5 <memmove+0x48>
      *--d = *--s;
80104cb2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104cb6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cbd:	0f b6 10             	movzbl (%eax),%edx
80104cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cc3:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104cc5:	8b 45 10             	mov    0x10(%ebp),%eax
80104cc8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ccb:	89 55 10             	mov    %edx,0x10(%ebp)
80104cce:	85 c0                	test   %eax,%eax
80104cd0:	75 e0                	jne    80104cb2 <memmove+0x35>
  if(s < d && s + n > d){
80104cd2:	eb 24                	jmp    80104cf8 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104cd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cd7:	8d 42 01             	lea    0x1(%edx),%eax
80104cda:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ce0:	8d 48 01             	lea    0x1(%eax),%ecx
80104ce3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104ce6:	0f b6 12             	movzbl (%edx),%edx
80104ce9:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104ceb:	8b 45 10             	mov    0x10(%ebp),%eax
80104cee:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cf1:	89 55 10             	mov    %edx,0x10(%ebp)
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	75 dc                	jne    80104cd4 <memmove+0x57>

  return dst;
80104cf8:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104cfb:	c9                   	leave
80104cfc:	c3                   	ret

80104cfd <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104cfd:	55                   	push   %ebp
80104cfe:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104d00:	ff 75 10             	push   0x10(%ebp)
80104d03:	ff 75 0c             	push   0xc(%ebp)
80104d06:	ff 75 08             	push   0x8(%ebp)
80104d09:	e8 6f ff ff ff       	call   80104c7d <memmove>
80104d0e:	83 c4 0c             	add    $0xc,%esp
}
80104d11:	c9                   	leave
80104d12:	c3                   	ret

80104d13 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d13:	55                   	push   %ebp
80104d14:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104d16:	eb 0c                	jmp    80104d24 <strncmp+0x11>
    n--, p++, q++;
80104d18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d1c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d28:	74 1a                	je     80104d44 <strncmp+0x31>
80104d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d2d:	0f b6 00             	movzbl (%eax),%eax
80104d30:	84 c0                	test   %al,%al
80104d32:	74 10                	je     80104d44 <strncmp+0x31>
80104d34:	8b 45 08             	mov    0x8(%ebp),%eax
80104d37:	0f b6 10             	movzbl (%eax),%edx
80104d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3d:	0f b6 00             	movzbl (%eax),%eax
80104d40:	38 c2                	cmp    %al,%dl
80104d42:	74 d4                	je     80104d18 <strncmp+0x5>
  if(n == 0)
80104d44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d48:	75 07                	jne    80104d51 <strncmp+0x3e>
    return 0;
80104d4a:	ba 00 00 00 00       	mov    $0x0,%edx
80104d4f:	eb 14                	jmp    80104d65 <strncmp+0x52>
  return (uchar)*p - (uchar)*q;
80104d51:	8b 45 08             	mov    0x8(%ebp),%eax
80104d54:	0f b6 00             	movzbl (%eax),%eax
80104d57:	0f b6 d0             	movzbl %al,%edx
80104d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d5d:	0f b6 00             	movzbl (%eax),%eax
80104d60:	0f b6 c0             	movzbl %al,%eax
80104d63:	29 c2                	sub    %eax,%edx
}
80104d65:	89 d0                	mov    %edx,%eax
80104d67:	5d                   	pop    %ebp
80104d68:	c3                   	ret

80104d69 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d69:	55                   	push   %ebp
80104d6a:	89 e5                	mov    %esp,%ebp
80104d6c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d72:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d75:	90                   	nop
80104d76:	8b 45 10             	mov    0x10(%ebp),%eax
80104d79:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d7c:	89 55 10             	mov    %edx,0x10(%ebp)
80104d7f:	85 c0                	test   %eax,%eax
80104d81:	7e 2c                	jle    80104daf <strncpy+0x46>
80104d83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d86:	8d 42 01             	lea    0x1(%edx),%eax
80104d89:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8f:	8d 48 01             	lea    0x1(%eax),%ecx
80104d92:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d95:	0f b6 12             	movzbl (%edx),%edx
80104d98:	88 10                	mov    %dl,(%eax)
80104d9a:	0f b6 00             	movzbl (%eax),%eax
80104d9d:	84 c0                	test   %al,%al
80104d9f:	75 d5                	jne    80104d76 <strncpy+0xd>
    ;
  while(n-- > 0)
80104da1:	eb 0c                	jmp    80104daf <strncpy+0x46>
    *s++ = 0;
80104da3:	8b 45 08             	mov    0x8(%ebp),%eax
80104da6:	8d 50 01             	lea    0x1(%eax),%edx
80104da9:	89 55 08             	mov    %edx,0x8(%ebp)
80104dac:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104daf:	8b 45 10             	mov    0x10(%ebp),%eax
80104db2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104db5:	89 55 10             	mov    %edx,0x10(%ebp)
80104db8:	85 c0                	test   %eax,%eax
80104dba:	7f e7                	jg     80104da3 <strncpy+0x3a>
  return os;
80104dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104dbf:	c9                   	leave
80104dc0:	c3                   	ret

80104dc1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104dc1:	55                   	push   %ebp
80104dc2:	89 e5                	mov    %esp,%ebp
80104dc4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104dd1:	7f 05                	jg     80104dd8 <safestrcpy+0x17>
    return os;
80104dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dd6:	eb 32                	jmp    80104e0a <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80104dd8:	90                   	nop
80104dd9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104ddd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104de1:	7e 1e                	jle    80104e01 <safestrcpy+0x40>
80104de3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104de6:	8d 42 01             	lea    0x1(%edx),%eax
80104de9:	89 45 0c             	mov    %eax,0xc(%ebp)
80104dec:	8b 45 08             	mov    0x8(%ebp),%eax
80104def:	8d 48 01             	lea    0x1(%eax),%ecx
80104df2:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104df5:	0f b6 12             	movzbl (%edx),%edx
80104df8:	88 10                	mov    %dl,(%eax)
80104dfa:	0f b6 00             	movzbl (%eax),%eax
80104dfd:	84 c0                	test   %al,%al
80104dff:	75 d8                	jne    80104dd9 <safestrcpy+0x18>
    ;
  *s = 0;
80104e01:	8b 45 08             	mov    0x8(%ebp),%eax
80104e04:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e0a:	c9                   	leave
80104e0b:	c3                   	ret

80104e0c <strlen>:

int
strlen(const char *s)
{
80104e0c:	55                   	push   %ebp
80104e0d:	89 e5                	mov    %esp,%ebp
80104e0f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e19:	eb 04                	jmp    80104e1f <strlen+0x13>
80104e1b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e22:	8b 45 08             	mov    0x8(%ebp),%eax
80104e25:	01 d0                	add    %edx,%eax
80104e27:	0f b6 00             	movzbl (%eax),%eax
80104e2a:	84 c0                	test   %al,%al
80104e2c:	75 ed                	jne    80104e1b <strlen+0xf>
    ;
  return n;
80104e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e31:	c9                   	leave
80104e32:	c3                   	ret

80104e33 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e33:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e37:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104e3b:	55                   	push   %ebp
  pushl %ebx
80104e3c:	53                   	push   %ebx
  pushl %esi
80104e3d:	56                   	push   %esi
  pushl %edi
80104e3e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e3f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e41:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104e43:	5f                   	pop    %edi
  popl %esi
80104e44:	5e                   	pop    %esi
  popl %ebx
80104e45:	5b                   	pop    %ebx
  popl %ebp
80104e46:	5d                   	pop    %ebp
  ret
80104e47:	c3                   	ret

80104e48 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e48:	55                   	push   %ebp
80104e49:	89 e5                	mov    %esp,%ebp
80104e4b:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104e4e:	e8 dd eb ff ff       	call   80103a30 <myproc>
80104e53:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e59:	8b 00                	mov    (%eax),%eax
80104e5b:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e5e:	73 0f                	jae    80104e6f <fetchint+0x27>
80104e60:	8b 45 08             	mov    0x8(%ebp),%eax
80104e63:	8d 50 04             	lea    0x4(%eax),%edx
80104e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e69:	8b 00                	mov    (%eax),%eax
80104e6b:	39 d0                	cmp    %edx,%eax
80104e6d:	73 07                	jae    80104e76 <fetchint+0x2e>
    return -1;
80104e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e74:	eb 0f                	jmp    80104e85 <fetchint+0x3d>
  *ip = *(int*)(addr);
80104e76:	8b 45 08             	mov    0x8(%ebp),%eax
80104e79:	8b 10                	mov    (%eax),%edx
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7e:	89 10                	mov    %edx,(%eax)
  return 0;
80104e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e85:	c9                   	leave
80104e86:	c3                   	ret

80104e87 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e87:	55                   	push   %ebp
80104e88:	89 e5                	mov    %esp,%ebp
80104e8a:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104e8d:	e8 9e eb ff ff       	call   80103a30 <myproc>
80104e92:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e98:	8b 00                	mov    (%eax),%eax
80104e9a:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e9d:	72 07                	jb     80104ea6 <fetchstr+0x1f>
    return -1;
80104e9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea4:	eb 41                	jmp    80104ee7 <fetchstr+0x60>
  *pp = (char*)addr;
80104ea6:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eac:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb1:	8b 00                	mov    (%eax),%eax
80104eb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eb9:	8b 00                	mov    (%eax),%eax
80104ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ebe:	eb 1a                	jmp    80104eda <fetchstr+0x53>
    if(*s == 0)
80104ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec3:	0f b6 00             	movzbl (%eax),%eax
80104ec6:	84 c0                	test   %al,%al
80104ec8:	75 0c                	jne    80104ed6 <fetchstr+0x4f>
      return s - *pp;
80104eca:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ecd:	8b 10                	mov    (%eax),%edx
80104ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed2:	29 d0                	sub    %edx,%eax
80104ed4:	eb 11                	jmp    80104ee7 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104ed6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104ee0:	72 de                	jb     80104ec0 <fetchstr+0x39>
  }
  return -1;
80104ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ee7:	c9                   	leave
80104ee8:	c3                   	ret

80104ee9 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ee9:	55                   	push   %ebp
80104eea:	89 e5                	mov    %esp,%ebp
80104eec:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eef:	e8 3c eb ff ff       	call   80103a30 <myproc>
80104ef4:	8b 40 18             	mov    0x18(%eax),%eax
80104ef7:	8b 40 44             	mov    0x44(%eax),%eax
80104efa:	8b 55 08             	mov    0x8(%ebp),%edx
80104efd:	c1 e2 02             	shl    $0x2,%edx
80104f00:	01 d0                	add    %edx,%eax
80104f02:	83 c0 04             	add    $0x4,%eax
80104f05:	83 ec 08             	sub    $0x8,%esp
80104f08:	ff 75 0c             	push   0xc(%ebp)
80104f0b:	50                   	push   %eax
80104f0c:	e8 37 ff ff ff       	call   80104e48 <fetchint>
80104f11:	83 c4 10             	add    $0x10,%esp
}
80104f14:	c9                   	leave
80104f15:	c3                   	ret

80104f16 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f16:	55                   	push   %ebp
80104f17:	89 e5                	mov    %esp,%ebp
80104f19:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f1c:	e8 0f eb ff ff       	call   80103a30 <myproc>
80104f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f24:	83 ec 08             	sub    $0x8,%esp
80104f27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f2a:	50                   	push   %eax
80104f2b:	ff 75 08             	push   0x8(%ebp)
80104f2e:	e8 b6 ff ff ff       	call   80104ee9 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	79 07                	jns    80104f41 <argptr+0x2b>
    return -1;
80104f3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3f:	eb 3b                	jmp    80104f7c <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f45:	78 1f                	js     80104f66 <argptr+0x50>
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	8b 00                	mov    (%eax),%eax
80104f4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f4f:	39 c2                	cmp    %eax,%edx
80104f51:	73 13                	jae    80104f66 <argptr+0x50>
80104f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f56:	89 c2                	mov    %eax,%edx
80104f58:	8b 45 10             	mov    0x10(%ebp),%eax
80104f5b:	01 c2                	add    %eax,%edx
80104f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f60:	8b 00                	mov    (%eax),%eax
80104f62:	39 d0                	cmp    %edx,%eax
80104f64:	73 07                	jae    80104f6d <argptr+0x57>
    return -1;
80104f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6b:	eb 0f                	jmp    80104f7c <argptr+0x66>
  *pp = (char*)i;
80104f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f70:	89 c2                	mov    %eax,%edx
80104f72:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f75:	89 10                	mov    %edx,(%eax)
  return 0;
80104f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f7c:	c9                   	leave
80104f7d:	c3                   	ret

80104f7e <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f7e:	55                   	push   %ebp
80104f7f:	89 e5                	mov    %esp,%ebp
80104f81:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f84:	83 ec 08             	sub    $0x8,%esp
80104f87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f8a:	50                   	push   %eax
80104f8b:	ff 75 08             	push   0x8(%ebp)
80104f8e:	e8 56 ff ff ff       	call   80104ee9 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	79 07                	jns    80104fa1 <argstr+0x23>
    return -1;
80104f9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9f:	eb 12                	jmp    80104fb3 <argstr+0x35>
  return fetchstr(addr, pp);
80104fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa4:	83 ec 08             	sub    $0x8,%esp
80104fa7:	ff 75 0c             	push   0xc(%ebp)
80104faa:	50                   	push   %eax
80104fab:	e8 d7 fe ff ff       	call   80104e87 <fetchstr>
80104fb0:	83 c4 10             	add    $0x10,%esp
}
80104fb3:	c9                   	leave
80104fb4:	c3                   	ret

80104fb5 <syscall>:
[SYS_wait2]   sys_wait2,
};

void
syscall(void)
{
80104fb5:	55                   	push   %ebp
80104fb6:	89 e5                	mov    %esp,%ebp
80104fb8:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104fbb:	e8 70 ea ff ff       	call   80103a30 <myproc>
80104fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc6:	8b 40 18             	mov    0x18(%eax),%eax
80104fc9:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104fcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104fd3:	7e 2f                	jle    80105004 <syscall+0x4f>
80104fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd8:	83 f8 17             	cmp    $0x17,%eax
80104fdb:	77 27                	ja     80105004 <syscall+0x4f>
80104fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe0:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104fe7:	85 c0                	test   %eax,%eax
80104fe9:	74 19                	je     80105004 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fee:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104ff5:	ff d0                	call   *%eax
80104ff7:	89 c2                	mov    %eax,%edx
80104ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffc:	8b 40 18             	mov    0x18(%eax),%eax
80104fff:	89 50 1c             	mov    %edx,0x1c(%eax)
80105002:	eb 2c                	jmp    80105030 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105007:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010500a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500d:	8b 40 10             	mov    0x10(%eax),%eax
80105010:	ff 75 f0             	push   -0x10(%ebp)
80105013:	52                   	push   %edx
80105014:	50                   	push   %eax
80105015:	68 e5 a5 10 80       	push   $0x8010a5e5
8010501a:	e8 d5 b3 ff ff       	call   801003f4 <cprintf>
8010501f:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105025:	8b 40 18             	mov    0x18(%eax),%eax
80105028:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010502f:	90                   	nop
80105030:	90                   	nop
80105031:	c9                   	leave
80105032:	c3                   	ret

80105033 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105033:	55                   	push   %ebp
80105034:	89 e5                	mov    %esp,%ebp
80105036:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105039:	83 ec 08             	sub    $0x8,%esp
8010503c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010503f:	50                   	push   %eax
80105040:	ff 75 08             	push   0x8(%ebp)
80105043:	e8 a1 fe ff ff       	call   80104ee9 <argint>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	79 07                	jns    80105056 <argfd+0x23>
    return -1;
8010504f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105054:	eb 4f                	jmp    801050a5 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105056:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105059:	85 c0                	test   %eax,%eax
8010505b:	78 20                	js     8010507d <argfd+0x4a>
8010505d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105060:	83 f8 0f             	cmp    $0xf,%eax
80105063:	7f 18                	jg     8010507d <argfd+0x4a>
80105065:	e8 c6 e9 ff ff       	call   80103a30 <myproc>
8010506a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010506d:	83 c2 08             	add    $0x8,%edx
80105070:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105074:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010507b:	75 07                	jne    80105084 <argfd+0x51>
    return -1;
8010507d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105082:	eb 21                	jmp    801050a5 <argfd+0x72>
  if(pfd)
80105084:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105088:	74 08                	je     80105092 <argfd+0x5f>
    *pfd = fd;
8010508a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010508d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105090:	89 10                	mov    %edx,(%eax)
  if(pf)
80105092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105096:	74 08                	je     801050a0 <argfd+0x6d>
    *pf = f;
80105098:	8b 45 10             	mov    0x10(%ebp),%eax
8010509b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010509e:	89 10                	mov    %edx,(%eax)
  return 0;
801050a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050a5:	c9                   	leave
801050a6:	c3                   	ret

801050a7 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801050a7:	55                   	push   %ebp
801050a8:	89 e5                	mov    %esp,%ebp
801050aa:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801050ad:	e8 7e e9 ff ff       	call   80103a30 <myproc>
801050b2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801050b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050bc:	eb 2a                	jmp    801050e8 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801050be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c4:	83 c2 08             	add    $0x8,%edx
801050c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050cb:	85 c0                	test   %eax,%eax
801050cd:	75 15                	jne    801050e4 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801050cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050d5:	8d 4a 08             	lea    0x8(%edx),%ecx
801050d8:	8b 55 08             	mov    0x8(%ebp),%edx
801050db:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801050df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e2:	eb 0f                	jmp    801050f3 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
801050e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050e8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ec:	7e d0                	jle    801050be <fdalloc+0x17>
    }
  }
  return -1;
801050ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f3:	c9                   	leave
801050f4:	c3                   	ret

801050f5 <sys_dup>:

int
sys_dup(void)
{
801050f5:	55                   	push   %ebp
801050f6:	89 e5                	mov    %esp,%ebp
801050f8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050fb:	83 ec 04             	sub    $0x4,%esp
801050fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105101:	50                   	push   %eax
80105102:	6a 00                	push   $0x0
80105104:	6a 00                	push   $0x0
80105106:	e8 28 ff ff ff       	call   80105033 <argfd>
8010510b:	83 c4 10             	add    $0x10,%esp
8010510e:	85 c0                	test   %eax,%eax
80105110:	79 07                	jns    80105119 <sys_dup+0x24>
    return -1;
80105112:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105117:	eb 31                	jmp    8010514a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	50                   	push   %eax
80105120:	e8 82 ff ff ff       	call   801050a7 <fdalloc>
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010512b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010512f:	79 07                	jns    80105138 <sys_dup+0x43>
    return -1;
80105131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105136:	eb 12                	jmp    8010514a <sys_dup+0x55>
  filedup(f);
80105138:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513b:	83 ec 0c             	sub    $0xc,%esp
8010513e:	50                   	push   %eax
8010513f:	e8 10 bf ff ff       	call   80101054 <filedup>
80105144:	83 c4 10             	add    $0x10,%esp
  return fd;
80105147:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010514a:	c9                   	leave
8010514b:	c3                   	ret

8010514c <sys_read>:

int
sys_read(void)
{
8010514c:	55                   	push   %ebp
8010514d:	89 e5                	mov    %esp,%ebp
8010514f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105152:	83 ec 04             	sub    $0x4,%esp
80105155:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105158:	50                   	push   %eax
80105159:	6a 00                	push   $0x0
8010515b:	6a 00                	push   $0x0
8010515d:	e8 d1 fe ff ff       	call   80105033 <argfd>
80105162:	83 c4 10             	add    $0x10,%esp
80105165:	85 c0                	test   %eax,%eax
80105167:	78 2e                	js     80105197 <sys_read+0x4b>
80105169:	83 ec 08             	sub    $0x8,%esp
8010516c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010516f:	50                   	push   %eax
80105170:	6a 02                	push   $0x2
80105172:	e8 72 fd ff ff       	call   80104ee9 <argint>
80105177:	83 c4 10             	add    $0x10,%esp
8010517a:	85 c0                	test   %eax,%eax
8010517c:	78 19                	js     80105197 <sys_read+0x4b>
8010517e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105181:	83 ec 04             	sub    $0x4,%esp
80105184:	50                   	push   %eax
80105185:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105188:	50                   	push   %eax
80105189:	6a 01                	push   $0x1
8010518b:	e8 86 fd ff ff       	call   80104f16 <argptr>
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	85 c0                	test   %eax,%eax
80105195:	79 07                	jns    8010519e <sys_read+0x52>
    return -1;
80105197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519c:	eb 17                	jmp    801051b5 <sys_read+0x69>
  return fileread(f, p, n);
8010519e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801051a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a7:	83 ec 04             	sub    $0x4,%esp
801051aa:	51                   	push   %ecx
801051ab:	52                   	push   %edx
801051ac:	50                   	push   %eax
801051ad:	e8 32 c0 ff ff       	call   801011e4 <fileread>
801051b2:	83 c4 10             	add    $0x10,%esp
}
801051b5:	c9                   	leave
801051b6:	c3                   	ret

801051b7 <sys_write>:

int
sys_write(void)
{
801051b7:	55                   	push   %ebp
801051b8:	89 e5                	mov    %esp,%ebp
801051ba:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051bd:	83 ec 04             	sub    $0x4,%esp
801051c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c3:	50                   	push   %eax
801051c4:	6a 00                	push   $0x0
801051c6:	6a 00                	push   $0x0
801051c8:	e8 66 fe ff ff       	call   80105033 <argfd>
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	85 c0                	test   %eax,%eax
801051d2:	78 2e                	js     80105202 <sys_write+0x4b>
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051da:	50                   	push   %eax
801051db:	6a 02                	push   $0x2
801051dd:	e8 07 fd ff ff       	call   80104ee9 <argint>
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	85 c0                	test   %eax,%eax
801051e7:	78 19                	js     80105202 <sys_write+0x4b>
801051e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ec:	83 ec 04             	sub    $0x4,%esp
801051ef:	50                   	push   %eax
801051f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051f3:	50                   	push   %eax
801051f4:	6a 01                	push   $0x1
801051f6:	e8 1b fd ff ff       	call   80104f16 <argptr>
801051fb:	83 c4 10             	add    $0x10,%esp
801051fe:	85 c0                	test   %eax,%eax
80105200:	79 07                	jns    80105209 <sys_write+0x52>
    return -1;
80105202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105207:	eb 17                	jmp    80105220 <sys_write+0x69>
  return filewrite(f, p, n);
80105209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010520c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010520f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105212:	83 ec 04             	sub    $0x4,%esp
80105215:	51                   	push   %ecx
80105216:	52                   	push   %edx
80105217:	50                   	push   %eax
80105218:	e8 7f c0 ff ff       	call   8010129c <filewrite>
8010521d:	83 c4 10             	add    $0x10,%esp
}
80105220:	c9                   	leave
80105221:	c3                   	ret

80105222 <sys_close>:

int
sys_close(void)
{
80105222:	55                   	push   %ebp
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105228:	83 ec 04             	sub    $0x4,%esp
8010522b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010522e:	50                   	push   %eax
8010522f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105232:	50                   	push   %eax
80105233:	6a 00                	push   $0x0
80105235:	e8 f9 fd ff ff       	call   80105033 <argfd>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	79 07                	jns    80105248 <sys_close+0x26>
    return -1;
80105241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105246:	eb 27                	jmp    8010526f <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
80105248:	e8 e3 e7 ff ff       	call   80103a30 <myproc>
8010524d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105250:	83 c2 08             	add    $0x8,%edx
80105253:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010525a:	00 
  fileclose(f);
8010525b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525e:	83 ec 0c             	sub    $0xc,%esp
80105261:	50                   	push   %eax
80105262:	e8 3e be ff ff       	call   801010a5 <fileclose>
80105267:	83 c4 10             	add    $0x10,%esp
  return 0;
8010526a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010526f:	c9                   	leave
80105270:	c3                   	ret

80105271 <sys_fstat>:

int
sys_fstat(void)
{
80105271:	55                   	push   %ebp
80105272:	89 e5                	mov    %esp,%ebp
80105274:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105277:	83 ec 04             	sub    $0x4,%esp
8010527a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010527d:	50                   	push   %eax
8010527e:	6a 00                	push   $0x0
80105280:	6a 00                	push   $0x0
80105282:	e8 ac fd ff ff       	call   80105033 <argfd>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	85 c0                	test   %eax,%eax
8010528c:	78 17                	js     801052a5 <sys_fstat+0x34>
8010528e:	83 ec 04             	sub    $0x4,%esp
80105291:	6a 14                	push   $0x14
80105293:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105296:	50                   	push   %eax
80105297:	6a 01                	push   $0x1
80105299:	e8 78 fc ff ff       	call   80104f16 <argptr>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	79 07                	jns    801052ac <sys_fstat+0x3b>
    return -1;
801052a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052aa:	eb 13                	jmp    801052bf <sys_fstat+0x4e>
  return filestat(f, st);
801052ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801052af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b2:	83 ec 08             	sub    $0x8,%esp
801052b5:	52                   	push   %edx
801052b6:	50                   	push   %eax
801052b7:	e8 d1 be ff ff       	call   8010118d <filestat>
801052bc:	83 c4 10             	add    $0x10,%esp
}
801052bf:	c9                   	leave
801052c0:	c3                   	ret

801052c1 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052c1:	55                   	push   %ebp
801052c2:	89 e5                	mov    %esp,%ebp
801052c4:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052cd:	50                   	push   %eax
801052ce:	6a 00                	push   $0x0
801052d0:	e8 a9 fc ff ff       	call   80104f7e <argstr>
801052d5:	83 c4 10             	add    $0x10,%esp
801052d8:	85 c0                	test   %eax,%eax
801052da:	78 15                	js     801052f1 <sys_link+0x30>
801052dc:	83 ec 08             	sub    $0x8,%esp
801052df:	8d 45 dc             	lea    -0x24(%ebp),%eax
801052e2:	50                   	push   %eax
801052e3:	6a 01                	push   $0x1
801052e5:	e8 94 fc ff ff       	call   80104f7e <argstr>
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	85 c0                	test   %eax,%eax
801052ef:	79 0a                	jns    801052fb <sys_link+0x3a>
    return -1;
801052f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f6:	e9 68 01 00 00       	jmp    80105463 <sys_link+0x1a2>

  begin_op();
801052fb:	e8 3e dd ff ff       	call   8010303e <begin_op>
  if((ip = namei(old)) == 0){
80105300:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105303:	83 ec 0c             	sub    $0xc,%esp
80105306:	50                   	push   %eax
80105307:	e8 19 d2 ff ff       	call   80102525 <namei>
8010530c:	83 c4 10             	add    $0x10,%esp
8010530f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105316:	75 0f                	jne    80105327 <sys_link+0x66>
    end_op();
80105318:	e8 ad dd ff ff       	call   801030ca <end_op>
    return -1;
8010531d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105322:	e9 3c 01 00 00       	jmp    80105463 <sys_link+0x1a2>
  }

  ilock(ip);
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	ff 75 f4             	push   -0xc(%ebp)
8010532d:	e8 c0 c6 ff ff       	call   801019f2 <ilock>
80105332:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010533c:	66 83 f8 01          	cmp    $0x1,%ax
80105340:	75 1d                	jne    8010535f <sys_link+0x9e>
    iunlockput(ip);
80105342:	83 ec 0c             	sub    $0xc,%esp
80105345:	ff 75 f4             	push   -0xc(%ebp)
80105348:	e8 d6 c8 ff ff       	call   80101c23 <iunlockput>
8010534d:	83 c4 10             	add    $0x10,%esp
    end_op();
80105350:	e8 75 dd ff ff       	call   801030ca <end_op>
    return -1;
80105355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535a:	e9 04 01 00 00       	jmp    80105463 <sys_link+0x1a2>
  }

  ip->nlink++;
8010535f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105362:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105366:	83 c0 01             	add    $0x1,%eax
80105369:	89 c2                	mov    %eax,%edx
8010536b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105372:	83 ec 0c             	sub    $0xc,%esp
80105375:	ff 75 f4             	push   -0xc(%ebp)
80105378:	e8 98 c4 ff ff       	call   80101815 <iupdate>
8010537d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	ff 75 f4             	push   -0xc(%ebp)
80105386:	e8 7a c7 ff ff       	call   80101b05 <iunlock>
8010538b:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
8010538e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105391:	83 ec 08             	sub    $0x8,%esp
80105394:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105397:	52                   	push   %edx
80105398:	50                   	push   %eax
80105399:	e8 a3 d1 ff ff       	call   80102541 <nameiparent>
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801053a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053a8:	74 71                	je     8010541b <sys_link+0x15a>
    goto bad;
  ilock(dp);
801053aa:	83 ec 0c             	sub    $0xc,%esp
801053ad:	ff 75 f0             	push   -0x10(%ebp)
801053b0:	e8 3d c6 ff ff       	call   801019f2 <ilock>
801053b5:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053bb:	8b 10                	mov    (%eax),%edx
801053bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c0:	8b 00                	mov    (%eax),%eax
801053c2:	39 c2                	cmp    %eax,%edx
801053c4:	75 1d                	jne    801053e3 <sys_link+0x122>
801053c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c9:	8b 40 04             	mov    0x4(%eax),%eax
801053cc:	83 ec 04             	sub    $0x4,%esp
801053cf:	50                   	push   %eax
801053d0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801053d3:	50                   	push   %eax
801053d4:	ff 75 f0             	push   -0x10(%ebp)
801053d7:	e8 b2 ce ff ff       	call   8010228e <dirlink>
801053dc:	83 c4 10             	add    $0x10,%esp
801053df:	85 c0                	test   %eax,%eax
801053e1:	79 10                	jns    801053f3 <sys_link+0x132>
    iunlockput(dp);
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	ff 75 f0             	push   -0x10(%ebp)
801053e9:	e8 35 c8 ff ff       	call   80101c23 <iunlockput>
801053ee:	83 c4 10             	add    $0x10,%esp
    goto bad;
801053f1:	eb 29                	jmp    8010541c <sys_link+0x15b>
  }
  iunlockput(dp);
801053f3:	83 ec 0c             	sub    $0xc,%esp
801053f6:	ff 75 f0             	push   -0x10(%ebp)
801053f9:	e8 25 c8 ff ff       	call   80101c23 <iunlockput>
801053fe:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
80105404:	ff 75 f4             	push   -0xc(%ebp)
80105407:	e8 47 c7 ff ff       	call   80101b53 <iput>
8010540c:	83 c4 10             	add    $0x10,%esp

  end_op();
8010540f:	e8 b6 dc ff ff       	call   801030ca <end_op>

  return 0;
80105414:	b8 00 00 00 00       	mov    $0x0,%eax
80105419:	eb 48                	jmp    80105463 <sys_link+0x1a2>
    goto bad;
8010541b:	90                   	nop

bad:
  ilock(ip);
8010541c:	83 ec 0c             	sub    $0xc,%esp
8010541f:	ff 75 f4             	push   -0xc(%ebp)
80105422:	e8 cb c5 ff ff       	call   801019f2 <ilock>
80105427:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010542a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010542d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105431:	83 e8 01             	sub    $0x1,%eax
80105434:	89 c2                	mov    %eax,%edx
80105436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105439:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010543d:	83 ec 0c             	sub    $0xc,%esp
80105440:	ff 75 f4             	push   -0xc(%ebp)
80105443:	e8 cd c3 ff ff       	call   80101815 <iupdate>
80105448:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	ff 75 f4             	push   -0xc(%ebp)
80105451:	e8 cd c7 ff ff       	call   80101c23 <iunlockput>
80105456:	83 c4 10             	add    $0x10,%esp
  end_op();
80105459:	e8 6c dc ff ff       	call   801030ca <end_op>
  return -1;
8010545e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105463:	c9                   	leave
80105464:	c3                   	ret

80105465 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105465:	55                   	push   %ebp
80105466:	89 e5                	mov    %esp,%ebp
80105468:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010546b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105472:	eb 40                	jmp    801054b4 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105474:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105477:	6a 10                	push   $0x10
80105479:	50                   	push   %eax
8010547a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010547d:	50                   	push   %eax
8010547e:	ff 75 08             	push   0x8(%ebp)
80105481:	e8 58 ca ff ff       	call   80101ede <readi>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	83 f8 10             	cmp    $0x10,%eax
8010548c:	74 0d                	je     8010549b <isdirempty+0x36>
      panic("isdirempty: readi");
8010548e:	83 ec 0c             	sub    $0xc,%esp
80105491:	68 01 a6 10 80       	push   $0x8010a601
80105496:	e8 0e b1 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
8010549b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010549f:	66 85 c0             	test   %ax,%ax
801054a2:	74 07                	je     801054ab <isdirempty+0x46>
      return 0;
801054a4:	b8 00 00 00 00       	mov    $0x0,%eax
801054a9:	eb 1b                	jmp    801054c6 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ae:	83 c0 10             	add    $0x10,%eax
801054b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054b4:	8b 45 08             	mov    0x8(%ebp),%eax
801054b7:	8b 40 58             	mov    0x58(%eax),%eax
801054ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054bd:	39 c2                	cmp    %eax,%edx
801054bf:	72 b3                	jb     80105474 <isdirempty+0xf>
  }
  return 1;
801054c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054c6:	c9                   	leave
801054c7:	c3                   	ret

801054c8 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801054c8:	55                   	push   %ebp
801054c9:	89 e5                	mov    %esp,%ebp
801054cb:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054ce:	83 ec 08             	sub    $0x8,%esp
801054d1:	8d 45 cc             	lea    -0x34(%ebp),%eax
801054d4:	50                   	push   %eax
801054d5:	6a 00                	push   $0x0
801054d7:	e8 a2 fa ff ff       	call   80104f7e <argstr>
801054dc:	83 c4 10             	add    $0x10,%esp
801054df:	85 c0                	test   %eax,%eax
801054e1:	79 0a                	jns    801054ed <sys_unlink+0x25>
    return -1;
801054e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e8:	e9 bf 01 00 00       	jmp    801056ac <sys_unlink+0x1e4>

  begin_op();
801054ed:	e8 4c db ff ff       	call   8010303e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801054f5:	83 ec 08             	sub    $0x8,%esp
801054f8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801054fb:	52                   	push   %edx
801054fc:	50                   	push   %eax
801054fd:	e8 3f d0 ff ff       	call   80102541 <nameiparent>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010550c:	75 0f                	jne    8010551d <sys_unlink+0x55>
    end_op();
8010550e:	e8 b7 db ff ff       	call   801030ca <end_op>
    return -1;
80105513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105518:	e9 8f 01 00 00       	jmp    801056ac <sys_unlink+0x1e4>
  }

  ilock(dp);
8010551d:	83 ec 0c             	sub    $0xc,%esp
80105520:	ff 75 f4             	push   -0xc(%ebp)
80105523:	e8 ca c4 ff ff       	call   801019f2 <ilock>
80105528:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010552b:	83 ec 08             	sub    $0x8,%esp
8010552e:	68 13 a6 10 80       	push   $0x8010a613
80105533:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105536:	50                   	push   %eax
80105537:	e8 7d cc ff ff       	call   801021b9 <namecmp>
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	85 c0                	test   %eax,%eax
80105541:	0f 84 49 01 00 00    	je     80105690 <sys_unlink+0x1c8>
80105547:	83 ec 08             	sub    $0x8,%esp
8010554a:	68 15 a6 10 80       	push   $0x8010a615
8010554f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105552:	50                   	push   %eax
80105553:	e8 61 cc ff ff       	call   801021b9 <namecmp>
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	85 c0                	test   %eax,%eax
8010555d:	0f 84 2d 01 00 00    	je     80105690 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105563:	83 ec 04             	sub    $0x4,%esp
80105566:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105569:	50                   	push   %eax
8010556a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010556d:	50                   	push   %eax
8010556e:	ff 75 f4             	push   -0xc(%ebp)
80105571:	e8 5e cc ff ff       	call   801021d4 <dirlookup>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010557c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105580:	0f 84 0d 01 00 00    	je     80105693 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105586:	83 ec 0c             	sub    $0xc,%esp
80105589:	ff 75 f0             	push   -0x10(%ebp)
8010558c:	e8 61 c4 ff ff       	call   801019f2 <ilock>
80105591:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105594:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105597:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010559b:	66 85 c0             	test   %ax,%ax
8010559e:	7f 0d                	jg     801055ad <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	68 18 a6 10 80       	push   $0x8010a618
801055a8:	e8 fc af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801055b4:	66 83 f8 01          	cmp    $0x1,%ax
801055b8:	75 25                	jne    801055df <sys_unlink+0x117>
801055ba:	83 ec 0c             	sub    $0xc,%esp
801055bd:	ff 75 f0             	push   -0x10(%ebp)
801055c0:	e8 a0 fe ff ff       	call   80105465 <isdirempty>
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	85 c0                	test   %eax,%eax
801055ca:	75 13                	jne    801055df <sys_unlink+0x117>
    iunlockput(ip);
801055cc:	83 ec 0c             	sub    $0xc,%esp
801055cf:	ff 75 f0             	push   -0x10(%ebp)
801055d2:	e8 4c c6 ff ff       	call   80101c23 <iunlockput>
801055d7:	83 c4 10             	add    $0x10,%esp
    goto bad;
801055da:	e9 b5 00 00 00       	jmp    80105694 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
801055df:	83 ec 04             	sub    $0x4,%esp
801055e2:	6a 10                	push   $0x10
801055e4:	6a 00                	push   $0x0
801055e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055e9:	50                   	push   %eax
801055ea:	e8 cf f5 ff ff       	call   80104bbe <memset>
801055ef:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
801055f5:	6a 10                	push   $0x10
801055f7:	50                   	push   %eax
801055f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055fb:	50                   	push   %eax
801055fc:	ff 75 f4             	push   -0xc(%ebp)
801055ff:	e8 2f ca ff ff       	call   80102033 <writei>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	83 f8 10             	cmp    $0x10,%eax
8010560a:	74 0d                	je     80105619 <sys_unlink+0x151>
    panic("unlink: writei");
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	68 2a a6 10 80       	push   $0x8010a62a
80105614:	e8 90 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010561c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105620:	66 83 f8 01          	cmp    $0x1,%ax
80105624:	75 21                	jne    80105647 <sys_unlink+0x17f>
    dp->nlink--;
80105626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105629:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010562d:	83 e8 01             	sub    $0x1,%eax
80105630:	89 c2                	mov    %eax,%edx
80105632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105635:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	ff 75 f4             	push   -0xc(%ebp)
8010563f:	e8 d1 c1 ff ff       	call   80101815 <iupdate>
80105644:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105647:	83 ec 0c             	sub    $0xc,%esp
8010564a:	ff 75 f4             	push   -0xc(%ebp)
8010564d:	e8 d1 c5 ff ff       	call   80101c23 <iunlockput>
80105652:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105655:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105658:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010565c:	83 e8 01             	sub    $0x1,%eax
8010565f:	89 c2                	mov    %eax,%edx
80105661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105664:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	ff 75 f0             	push   -0x10(%ebp)
8010566e:	e8 a2 c1 ff ff       	call   80101815 <iupdate>
80105673:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105676:	83 ec 0c             	sub    $0xc,%esp
80105679:	ff 75 f0             	push   -0x10(%ebp)
8010567c:	e8 a2 c5 ff ff       	call   80101c23 <iunlockput>
80105681:	83 c4 10             	add    $0x10,%esp

  end_op();
80105684:	e8 41 da ff ff       	call   801030ca <end_op>

  return 0;
80105689:	b8 00 00 00 00       	mov    $0x0,%eax
8010568e:	eb 1c                	jmp    801056ac <sys_unlink+0x1e4>
    goto bad;
80105690:	90                   	nop
80105691:	eb 01                	jmp    80105694 <sys_unlink+0x1cc>
    goto bad;
80105693:	90                   	nop

bad:
  iunlockput(dp);
80105694:	83 ec 0c             	sub    $0xc,%esp
80105697:	ff 75 f4             	push   -0xc(%ebp)
8010569a:	e8 84 c5 ff ff       	call   80101c23 <iunlockput>
8010569f:	83 c4 10             	add    $0x10,%esp
  end_op();
801056a2:	e8 23 da ff ff       	call   801030ca <end_op>
  return -1;
801056a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ac:	c9                   	leave
801056ad:	c3                   	ret

801056ae <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801056ae:	55                   	push   %ebp
801056af:	89 e5                	mov    %esp,%ebp
801056b1:	83 ec 38             	sub    $0x38,%esp
801056b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801056b7:	8b 55 10             	mov    0x10(%ebp),%edx
801056ba:	8b 45 14             	mov    0x14(%ebp),%eax
801056bd:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801056c1:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801056c5:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056c9:	83 ec 08             	sub    $0x8,%esp
801056cc:	8d 45 de             	lea    -0x22(%ebp),%eax
801056cf:	50                   	push   %eax
801056d0:	ff 75 08             	push   0x8(%ebp)
801056d3:	e8 69 ce ff ff       	call   80102541 <nameiparent>
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056e2:	75 0a                	jne    801056ee <create+0x40>
    return 0;
801056e4:	b8 00 00 00 00       	mov    $0x0,%eax
801056e9:	e9 90 01 00 00       	jmp    8010587e <create+0x1d0>
  ilock(dp);
801056ee:	83 ec 0c             	sub    $0xc,%esp
801056f1:	ff 75 f4             	push   -0xc(%ebp)
801056f4:	e8 f9 c2 ff ff       	call   801019f2 <ilock>
801056f9:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801056fc:	83 ec 04             	sub    $0x4,%esp
801056ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105702:	50                   	push   %eax
80105703:	8d 45 de             	lea    -0x22(%ebp),%eax
80105706:	50                   	push   %eax
80105707:	ff 75 f4             	push   -0xc(%ebp)
8010570a:	e8 c5 ca ff ff       	call   801021d4 <dirlookup>
8010570f:	83 c4 10             	add    $0x10,%esp
80105712:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105719:	74 50                	je     8010576b <create+0xbd>
    iunlockput(dp);
8010571b:	83 ec 0c             	sub    $0xc,%esp
8010571e:	ff 75 f4             	push   -0xc(%ebp)
80105721:	e8 fd c4 ff ff       	call   80101c23 <iunlockput>
80105726:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	ff 75 f0             	push   -0x10(%ebp)
8010572f:	e8 be c2 ff ff       	call   801019f2 <ilock>
80105734:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105737:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010573c:	75 15                	jne    80105753 <create+0xa5>
8010573e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105741:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105745:	66 83 f8 02          	cmp    $0x2,%ax
80105749:	75 08                	jne    80105753 <create+0xa5>
      return ip;
8010574b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574e:	e9 2b 01 00 00       	jmp    8010587e <create+0x1d0>
    iunlockput(ip);
80105753:	83 ec 0c             	sub    $0xc,%esp
80105756:	ff 75 f0             	push   -0x10(%ebp)
80105759:	e8 c5 c4 ff ff       	call   80101c23 <iunlockput>
8010575e:	83 c4 10             	add    $0x10,%esp
    return 0;
80105761:	b8 00 00 00 00       	mov    $0x0,%eax
80105766:	e9 13 01 00 00       	jmp    8010587e <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010576b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010576f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105772:	8b 00                	mov    (%eax),%eax
80105774:	83 ec 08             	sub    $0x8,%esp
80105777:	52                   	push   %edx
80105778:	50                   	push   %eax
80105779:	e8 c1 bf ff ff       	call   8010173f <ialloc>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105784:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105788:	75 0d                	jne    80105797 <create+0xe9>
    panic("create: ialloc");
8010578a:	83 ec 0c             	sub    $0xc,%esp
8010578d:	68 39 a6 10 80       	push   $0x8010a639
80105792:	e8 12 ae ff ff       	call   801005a9 <panic>

  ilock(ip);
80105797:	83 ec 0c             	sub    $0xc,%esp
8010579a:	ff 75 f0             	push   -0x10(%ebp)
8010579d:	e8 50 c2 ff ff       	call   801019f2 <ilock>
801057a2:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801057a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a8:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801057ac:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801057b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b3:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801057b7:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801057bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057be:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801057c4:	83 ec 0c             	sub    $0xc,%esp
801057c7:	ff 75 f0             	push   -0x10(%ebp)
801057ca:	e8 46 c0 ff ff       	call   80101815 <iupdate>
801057cf:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801057d2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057d7:	75 6a                	jne    80105843 <create+0x195>
    dp->nlink++;  // for ".."
801057d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057dc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801057e0:	83 c0 01             	add    $0x1,%eax
801057e3:	89 c2                	mov    %eax,%edx
801057e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e8:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801057ec:	83 ec 0c             	sub    $0xc,%esp
801057ef:	ff 75 f4             	push   -0xc(%ebp)
801057f2:	e8 1e c0 ff ff       	call   80101815 <iupdate>
801057f7:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057fd:	8b 40 04             	mov    0x4(%eax),%eax
80105800:	83 ec 04             	sub    $0x4,%esp
80105803:	50                   	push   %eax
80105804:	68 13 a6 10 80       	push   $0x8010a613
80105809:	ff 75 f0             	push   -0x10(%ebp)
8010580c:	e8 7d ca ff ff       	call   8010228e <dirlink>
80105811:	83 c4 10             	add    $0x10,%esp
80105814:	85 c0                	test   %eax,%eax
80105816:	78 1e                	js     80105836 <create+0x188>
80105818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581b:	8b 40 04             	mov    0x4(%eax),%eax
8010581e:	83 ec 04             	sub    $0x4,%esp
80105821:	50                   	push   %eax
80105822:	68 15 a6 10 80       	push   $0x8010a615
80105827:	ff 75 f0             	push   -0x10(%ebp)
8010582a:	e8 5f ca ff ff       	call   8010228e <dirlink>
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	85 c0                	test   %eax,%eax
80105834:	79 0d                	jns    80105843 <create+0x195>
      panic("create dots");
80105836:	83 ec 0c             	sub    $0xc,%esp
80105839:	68 48 a6 10 80       	push   $0x8010a648
8010583e:	e8 66 ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105846:	8b 40 04             	mov    0x4(%eax),%eax
80105849:	83 ec 04             	sub    $0x4,%esp
8010584c:	50                   	push   %eax
8010584d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105850:	50                   	push   %eax
80105851:	ff 75 f4             	push   -0xc(%ebp)
80105854:	e8 35 ca ff ff       	call   8010228e <dirlink>
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	85 c0                	test   %eax,%eax
8010585e:	79 0d                	jns    8010586d <create+0x1bf>
    panic("create: dirlink");
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	68 54 a6 10 80       	push   $0x8010a654
80105868:	e8 3c ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	ff 75 f4             	push   -0xc(%ebp)
80105873:	e8 ab c3 ff ff       	call   80101c23 <iunlockput>
80105878:	83 c4 10             	add    $0x10,%esp

  return ip;
8010587b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010587e:	c9                   	leave
8010587f:	c3                   	ret

80105880 <sys_open>:

int
sys_open(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105886:	83 ec 08             	sub    $0x8,%esp
80105889:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010588c:	50                   	push   %eax
8010588d:	6a 00                	push   $0x0
8010588f:	e8 ea f6 ff ff       	call   80104f7e <argstr>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	78 15                	js     801058b0 <sys_open+0x30>
8010589b:	83 ec 08             	sub    $0x8,%esp
8010589e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a1:	50                   	push   %eax
801058a2:	6a 01                	push   $0x1
801058a4:	e8 40 f6 ff ff       	call   80104ee9 <argint>
801058a9:	83 c4 10             	add    $0x10,%esp
801058ac:	85 c0                	test   %eax,%eax
801058ae:	79 0a                	jns    801058ba <sys_open+0x3a>
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	e9 61 01 00 00       	jmp    80105a1b <sys_open+0x19b>

  begin_op();
801058ba:	e8 7f d7 ff ff       	call   8010303e <begin_op>

  if(omode & O_CREATE){
801058bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058c2:	25 00 02 00 00       	and    $0x200,%eax
801058c7:	85 c0                	test   %eax,%eax
801058c9:	74 2a                	je     801058f5 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801058cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801058ce:	6a 00                	push   $0x0
801058d0:	6a 00                	push   $0x0
801058d2:	6a 02                	push   $0x2
801058d4:	50                   	push   %eax
801058d5:	e8 d4 fd ff ff       	call   801056ae <create>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801058e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058e4:	75 75                	jne    8010595b <sys_open+0xdb>
      end_op();
801058e6:	e8 df d7 ff ff       	call   801030ca <end_op>
      return -1;
801058eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f0:	e9 26 01 00 00       	jmp    80105a1b <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801058f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801058f8:	83 ec 0c             	sub    $0xc,%esp
801058fb:	50                   	push   %eax
801058fc:	e8 24 cc ff ff       	call   80102525 <namei>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010590b:	75 0f                	jne    8010591c <sys_open+0x9c>
      end_op();
8010590d:	e8 b8 d7 ff ff       	call   801030ca <end_op>
      return -1;
80105912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105917:	e9 ff 00 00 00       	jmp    80105a1b <sys_open+0x19b>
    }
    ilock(ip);
8010591c:	83 ec 0c             	sub    $0xc,%esp
8010591f:	ff 75 f4             	push   -0xc(%ebp)
80105922:	e8 cb c0 ff ff       	call   801019f2 <ilock>
80105927:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010592a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105931:	66 83 f8 01          	cmp    $0x1,%ax
80105935:	75 24                	jne    8010595b <sys_open+0xdb>
80105937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010593a:	85 c0                	test   %eax,%eax
8010593c:	74 1d                	je     8010595b <sys_open+0xdb>
      iunlockput(ip);
8010593e:	83 ec 0c             	sub    $0xc,%esp
80105941:	ff 75 f4             	push   -0xc(%ebp)
80105944:	e8 da c2 ff ff       	call   80101c23 <iunlockput>
80105949:	83 c4 10             	add    $0x10,%esp
      end_op();
8010594c:	e8 79 d7 ff ff       	call   801030ca <end_op>
      return -1;
80105951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105956:	e9 c0 00 00 00       	jmp    80105a1b <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010595b:	e8 87 b6 ff ff       	call   80100fe7 <filealloc>
80105960:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105963:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105967:	74 17                	je     80105980 <sys_open+0x100>
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	ff 75 f0             	push   -0x10(%ebp)
8010596f:	e8 33 f7 ff ff       	call   801050a7 <fdalloc>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010597a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010597e:	79 2e                	jns    801059ae <sys_open+0x12e>
    if(f)
80105980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105984:	74 0e                	je     80105994 <sys_open+0x114>
      fileclose(f);
80105986:	83 ec 0c             	sub    $0xc,%esp
80105989:	ff 75 f0             	push   -0x10(%ebp)
8010598c:	e8 14 b7 ff ff       	call   801010a5 <fileclose>
80105991:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105994:	83 ec 0c             	sub    $0xc,%esp
80105997:	ff 75 f4             	push   -0xc(%ebp)
8010599a:	e8 84 c2 ff ff       	call   80101c23 <iunlockput>
8010599f:	83 c4 10             	add    $0x10,%esp
    end_op();
801059a2:	e8 23 d7 ff ff       	call   801030ca <end_op>
    return -1;
801059a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ac:	eb 6d                	jmp    80105a1b <sys_open+0x19b>
  }
  iunlock(ip);
801059ae:	83 ec 0c             	sub    $0xc,%esp
801059b1:	ff 75 f4             	push   -0xc(%ebp)
801059b4:	e8 4c c1 ff ff       	call   80101b05 <iunlock>
801059b9:	83 c4 10             	add    $0x10,%esp
  end_op();
801059bc:	e8 09 d7 ff ff       	call   801030ca <end_op>

  f->type = FD_INODE;
801059c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c4:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801059ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059d0:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801059d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801059dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059e0:	83 e0 01             	and    $0x1,%eax
801059e3:	85 c0                	test   %eax,%eax
801059e5:	0f 94 c0             	sete   %al
801059e8:	89 c2                	mov    %eax,%edx
801059ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ed:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059f3:	83 e0 01             	and    $0x1,%eax
801059f6:	85 c0                	test   %eax,%eax
801059f8:	75 0a                	jne    80105a04 <sys_open+0x184>
801059fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059fd:	83 e0 02             	and    $0x2,%eax
80105a00:	85 c0                	test   %eax,%eax
80105a02:	74 07                	je     80105a0b <sys_open+0x18b>
80105a04:	b8 01 00 00 00       	mov    $0x1,%eax
80105a09:	eb 05                	jmp    80105a10 <sys_open+0x190>
80105a0b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a10:	89 c2                	mov    %eax,%edx
80105a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a15:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a1b:	c9                   	leave
80105a1c:	c3                   	ret

80105a1d <sys_mkdir>:

int
sys_mkdir(void)
{
80105a1d:	55                   	push   %ebp
80105a1e:	89 e5                	mov    %esp,%ebp
80105a20:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a23:	e8 16 d6 ff ff       	call   8010303e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a28:	83 ec 08             	sub    $0x8,%esp
80105a2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a2e:	50                   	push   %eax
80105a2f:	6a 00                	push   $0x0
80105a31:	e8 48 f5 ff ff       	call   80104f7e <argstr>
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	78 1b                	js     80105a58 <sys_mkdir+0x3b>
80105a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a40:	6a 00                	push   $0x0
80105a42:	6a 00                	push   $0x0
80105a44:	6a 01                	push   $0x1
80105a46:	50                   	push   %eax
80105a47:	e8 62 fc ff ff       	call   801056ae <create>
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a56:	75 0c                	jne    80105a64 <sys_mkdir+0x47>
    end_op();
80105a58:	e8 6d d6 ff ff       	call   801030ca <end_op>
    return -1;
80105a5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a62:	eb 18                	jmp    80105a7c <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105a64:	83 ec 0c             	sub    $0xc,%esp
80105a67:	ff 75 f4             	push   -0xc(%ebp)
80105a6a:	e8 b4 c1 ff ff       	call   80101c23 <iunlockput>
80105a6f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a72:	e8 53 d6 ff ff       	call   801030ca <end_op>
  return 0;
80105a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a7c:	c9                   	leave
80105a7d:	c3                   	ret

80105a7e <sys_mknod>:

int
sys_mknod(void)
{
80105a7e:	55                   	push   %ebp
80105a7f:	89 e5                	mov    %esp,%ebp
80105a81:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a84:	e8 b5 d5 ff ff       	call   8010303e <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a8f:	50                   	push   %eax
80105a90:	6a 00                	push   $0x0
80105a92:	e8 e7 f4 ff ff       	call   80104f7e <argstr>
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	78 4f                	js     80105aed <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105a9e:	83 ec 08             	sub    $0x8,%esp
80105aa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aa4:	50                   	push   %eax
80105aa5:	6a 01                	push   $0x1
80105aa7:	e8 3d f4 ff ff       	call   80104ee9 <argint>
80105aac:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105aaf:	85 c0                	test   %eax,%eax
80105ab1:	78 3a                	js     80105aed <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105ab3:	83 ec 08             	sub    $0x8,%esp
80105ab6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ab9:	50                   	push   %eax
80105aba:	6a 02                	push   $0x2
80105abc:	e8 28 f4 ff ff       	call   80104ee9 <argint>
80105ac1:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 25                	js     80105aed <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105acb:	0f bf c8             	movswl %ax,%ecx
80105ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ad1:	0f bf d0             	movswl %ax,%edx
80105ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad7:	51                   	push   %ecx
80105ad8:	52                   	push   %edx
80105ad9:	6a 03                	push   $0x3
80105adb:	50                   	push   %eax
80105adc:	e8 cd fb ff ff       	call   801056ae <create>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aeb:	75 0c                	jne    80105af9 <sys_mknod+0x7b>
    end_op();
80105aed:	e8 d8 d5 ff ff       	call   801030ca <end_op>
    return -1;
80105af2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af7:	eb 18                	jmp    80105b11 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	ff 75 f4             	push   -0xc(%ebp)
80105aff:	e8 1f c1 ff ff       	call   80101c23 <iunlockput>
80105b04:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b07:	e8 be d5 ff ff       	call   801030ca <end_op>
  return 0;
80105b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b11:	c9                   	leave
80105b12:	c3                   	ret

80105b13 <sys_chdir>:

int
sys_chdir(void)
{
80105b13:	55                   	push   %ebp
80105b14:	89 e5                	mov    %esp,%ebp
80105b16:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b19:	e8 12 df ff ff       	call   80103a30 <myproc>
80105b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b21:	e8 18 d5 ff ff       	call   8010303e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b26:	83 ec 08             	sub    $0x8,%esp
80105b29:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b2c:	50                   	push   %eax
80105b2d:	6a 00                	push   $0x0
80105b2f:	e8 4a f4 ff ff       	call   80104f7e <argstr>
80105b34:	83 c4 10             	add    $0x10,%esp
80105b37:	85 c0                	test   %eax,%eax
80105b39:	78 18                	js     80105b53 <sys_chdir+0x40>
80105b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b3e:	83 ec 0c             	sub    $0xc,%esp
80105b41:	50                   	push   %eax
80105b42:	e8 de c9 ff ff       	call   80102525 <namei>
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b51:	75 0c                	jne    80105b5f <sys_chdir+0x4c>
    end_op();
80105b53:	e8 72 d5 ff ff       	call   801030ca <end_op>
    return -1;
80105b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5d:	eb 68                	jmp    80105bc7 <sys_chdir+0xb4>
  }
  ilock(ip);
80105b5f:	83 ec 0c             	sub    $0xc,%esp
80105b62:	ff 75 f0             	push   -0x10(%ebp)
80105b65:	e8 88 be ff ff       	call   801019f2 <ilock>
80105b6a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b70:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b74:	66 83 f8 01          	cmp    $0x1,%ax
80105b78:	74 1a                	je     80105b94 <sys_chdir+0x81>
    iunlockput(ip);
80105b7a:	83 ec 0c             	sub    $0xc,%esp
80105b7d:	ff 75 f0             	push   -0x10(%ebp)
80105b80:	e8 9e c0 ff ff       	call   80101c23 <iunlockput>
80105b85:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b88:	e8 3d d5 ff ff       	call   801030ca <end_op>
    return -1;
80105b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b92:	eb 33                	jmp    80105bc7 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105b94:	83 ec 0c             	sub    $0xc,%esp
80105b97:	ff 75 f0             	push   -0x10(%ebp)
80105b9a:	e8 66 bf ff ff       	call   80101b05 <iunlock>
80105b9f:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba5:	8b 40 68             	mov    0x68(%eax),%eax
80105ba8:	83 ec 0c             	sub    $0xc,%esp
80105bab:	50                   	push   %eax
80105bac:	e8 a2 bf ff ff       	call   80101b53 <iput>
80105bb1:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bb4:	e8 11 d5 ff ff       	call   801030ca <end_op>
  curproc->cwd = ip;
80105bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bbf:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bc7:	c9                   	leave
80105bc8:	c3                   	ret

80105bc9 <sys_exec>:

int
sys_exec(void)
{
80105bc9:	55                   	push   %ebp
80105bca:	89 e5                	mov    %esp,%ebp
80105bcc:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bd2:	83 ec 08             	sub    $0x8,%esp
80105bd5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bd8:	50                   	push   %eax
80105bd9:	6a 00                	push   $0x0
80105bdb:	e8 9e f3 ff ff       	call   80104f7e <argstr>
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	85 c0                	test   %eax,%eax
80105be5:	78 18                	js     80105bff <sys_exec+0x36>
80105be7:	83 ec 08             	sub    $0x8,%esp
80105bea:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105bf0:	50                   	push   %eax
80105bf1:	6a 01                	push   $0x1
80105bf3:	e8 f1 f2 ff ff       	call   80104ee9 <argint>
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	85 c0                	test   %eax,%eax
80105bfd:	79 0a                	jns    80105c09 <sys_exec+0x40>
    return -1;
80105bff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c04:	e9 c6 00 00 00       	jmp    80105ccf <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c09:	83 ec 04             	sub    $0x4,%esp
80105c0c:	68 80 00 00 00       	push   $0x80
80105c11:	6a 00                	push   $0x0
80105c13:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c19:	50                   	push   %eax
80105c1a:	e8 9f ef ff ff       	call   80104bbe <memset>
80105c1f:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2c:	83 f8 1f             	cmp    $0x1f,%eax
80105c2f:	76 0a                	jbe    80105c3b <sys_exec+0x72>
      return -1;
80105c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c36:	e9 94 00 00 00       	jmp    80105ccf <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3e:	c1 e0 02             	shl    $0x2,%eax
80105c41:	89 c2                	mov    %eax,%edx
80105c43:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105c49:	01 c2                	add    %eax,%edx
80105c4b:	83 ec 08             	sub    $0x8,%esp
80105c4e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c54:	50                   	push   %eax
80105c55:	52                   	push   %edx
80105c56:	e8 ed f1 ff ff       	call   80104e48 <fetchint>
80105c5b:	83 c4 10             	add    $0x10,%esp
80105c5e:	85 c0                	test   %eax,%eax
80105c60:	79 07                	jns    80105c69 <sys_exec+0xa0>
      return -1;
80105c62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c67:	eb 66                	jmp    80105ccf <sys_exec+0x106>
    if(uarg == 0){
80105c69:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c6f:	85 c0                	test   %eax,%eax
80105c71:	75 27                	jne    80105c9a <sys_exec+0xd1>
      argv[i] = 0;
80105c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c76:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105c7d:	00 00 00 00 
      break;
80105c81:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c85:	83 ec 08             	sub    $0x8,%esp
80105c88:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105c8e:	52                   	push   %edx
80105c8f:	50                   	push   %eax
80105c90:	e8 f5 ae ff ff       	call   80100b8a <exec>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	eb 35                	jmp    80105ccf <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105c9a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ca3:	c1 e2 02             	shl    $0x2,%edx
80105ca6:	01 c2                	add    %eax,%edx
80105ca8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105cae:	83 ec 08             	sub    $0x8,%esp
80105cb1:	52                   	push   %edx
80105cb2:	50                   	push   %eax
80105cb3:	e8 cf f1 ff ff       	call   80104e87 <fetchstr>
80105cb8:	83 c4 10             	add    $0x10,%esp
80105cbb:	85 c0                	test   %eax,%eax
80105cbd:	79 07                	jns    80105cc6 <sys_exec+0xfd>
      return -1;
80105cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc4:	eb 09                	jmp    80105ccf <sys_exec+0x106>
  for(i=0;; i++){
80105cc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105cca:	e9 5a ff ff ff       	jmp    80105c29 <sys_exec+0x60>
}
80105ccf:	c9                   	leave
80105cd0:	c3                   	ret

80105cd1 <sys_pipe>:

int
sys_pipe(void)
{
80105cd1:	55                   	push   %ebp
80105cd2:	89 e5                	mov    %esp,%ebp
80105cd4:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cd7:	83 ec 04             	sub    $0x4,%esp
80105cda:	6a 08                	push   $0x8
80105cdc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cdf:	50                   	push   %eax
80105ce0:	6a 00                	push   $0x0
80105ce2:	e8 2f f2 ff ff       	call   80104f16 <argptr>
80105ce7:	83 c4 10             	add    $0x10,%esp
80105cea:	85 c0                	test   %eax,%eax
80105cec:	79 0a                	jns    80105cf8 <sys_pipe+0x27>
    return -1;
80105cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf3:	e9 ae 00 00 00       	jmp    80105da6 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105cf8:	83 ec 08             	sub    $0x8,%esp
80105cfb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cfe:	50                   	push   %eax
80105cff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d02:	50                   	push   %eax
80105d03:	e8 65 d8 ff ff       	call   8010356d <pipealloc>
80105d08:	83 c4 10             	add    $0x10,%esp
80105d0b:	85 c0                	test   %eax,%eax
80105d0d:	79 0a                	jns    80105d19 <sys_pipe+0x48>
    return -1;
80105d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d14:	e9 8d 00 00 00       	jmp    80105da6 <sys_pipe+0xd5>
  fd0 = -1;
80105d19:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d23:	83 ec 0c             	sub    $0xc,%esp
80105d26:	50                   	push   %eax
80105d27:	e8 7b f3 ff ff       	call   801050a7 <fdalloc>
80105d2c:	83 c4 10             	add    $0x10,%esp
80105d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d36:	78 18                	js     80105d50 <sys_pipe+0x7f>
80105d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d3b:	83 ec 0c             	sub    $0xc,%esp
80105d3e:	50                   	push   %eax
80105d3f:	e8 63 f3 ff ff       	call   801050a7 <fdalloc>
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d4e:	79 3e                	jns    80105d8e <sys_pipe+0xbd>
    if(fd0 >= 0)
80105d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d54:	78 13                	js     80105d69 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d56:	e8 d5 dc ff ff       	call   80103a30 <myproc>
80105d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d5e:	83 c2 08             	add    $0x8,%edx
80105d61:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105d68:	00 
    fileclose(rf);
80105d69:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d6c:	83 ec 0c             	sub    $0xc,%esp
80105d6f:	50                   	push   %eax
80105d70:	e8 30 b3 ff ff       	call   801010a5 <fileclose>
80105d75:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d7b:	83 ec 0c             	sub    $0xc,%esp
80105d7e:	50                   	push   %eax
80105d7f:	e8 21 b3 ff ff       	call   801010a5 <fileclose>
80105d84:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8c:	eb 18                	jmp    80105da6 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d94:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d99:	8d 50 04             	lea    0x4(%eax),%edx
80105d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9f:	89 02                	mov    %eax,(%edx)
  return 0;
80105da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105da6:	c9                   	leave
80105da7:	c3                   	ret

80105da8 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105da8:	55                   	push   %ebp
80105da9:	89 e5                	mov    %esp,%ebp
80105dab:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105dae:	e8 7c df ff ff       	call   80103d2f <fork>
}
80105db3:	c9                   	leave
80105db4:	c3                   	ret

80105db5 <sys_exit>:

int
sys_exit(void)
{
80105db5:	55                   	push   %ebp
80105db6:	89 e5                	mov    %esp,%ebp
80105db8:	83 ec 08             	sub    $0x8,%esp
  exit();
80105dbb:	e8 e8 e0 ff ff       	call   80103ea8 <exit>
  return 0;  // not reached
80105dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dc5:	c9                   	leave
80105dc6:	c3                   	ret

80105dc7 <sys_wait>:

int
sys_wait(void)
{
80105dc7:	55                   	push   %ebp
80105dc8:	89 e5                	mov    %esp,%ebp
80105dca:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105dcd:	e8 f6 e1 ff ff       	call   80103fc8 <wait>
}
80105dd2:	c9                   	leave
80105dd3:	c3                   	ret

80105dd4 <sys_kill>:

int
sys_kill(void)
{
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105dda:	83 ec 08             	sub    $0x8,%esp
80105ddd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de0:	50                   	push   %eax
80105de1:	6a 00                	push   $0x0
80105de3:	e8 01 f1 ff ff       	call   80104ee9 <argint>
80105de8:	83 c4 10             	add    $0x10,%esp
80105deb:	85 c0                	test   %eax,%eax
80105ded:	79 07                	jns    80105df6 <sys_kill+0x22>
    return -1;
80105def:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df4:	eb 0f                	jmp    80105e05 <sys_kill+0x31>
  return kill(pid);
80105df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df9:	83 ec 0c             	sub    $0xc,%esp
80105dfc:	50                   	push   %eax
80105dfd:	e8 f5 e5 ff ff       	call   801043f7 <kill>
80105e02:	83 c4 10             	add    $0x10,%esp
}
80105e05:	c9                   	leave
80105e06:	c3                   	ret

80105e07 <sys_getpid>:

int
sys_getpid(void)
{
80105e07:	55                   	push   %ebp
80105e08:	89 e5                	mov    %esp,%ebp
80105e0a:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e0d:	e8 1e dc ff ff       	call   80103a30 <myproc>
80105e12:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e15:	c9                   	leave
80105e16:	c3                   	ret

80105e17 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e17:	55                   	push   %ebp
80105e18:	89 e5                	mov    %esp,%ebp
80105e1a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e1d:	83 ec 08             	sub    $0x8,%esp
80105e20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e23:	50                   	push   %eax
80105e24:	6a 00                	push   $0x0
80105e26:	e8 be f0 ff ff       	call   80104ee9 <argint>
80105e2b:	83 c4 10             	add    $0x10,%esp
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	79 07                	jns    80105e39 <sys_sbrk+0x22>
    return -1;
80105e32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e37:	eb 27                	jmp    80105e60 <sys_sbrk+0x49>
  addr = myproc()->sz;
80105e39:	e8 f2 db ff ff       	call   80103a30 <myproc>
80105e3e:	8b 00                	mov    (%eax),%eax
80105e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e46:	83 ec 0c             	sub    $0xc,%esp
80105e49:	50                   	push   %eax
80105e4a:	e8 45 de ff ff       	call   80103c94 <growproc>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	85 c0                	test   %eax,%eax
80105e54:	79 07                	jns    80105e5d <sys_sbrk+0x46>
    return -1;
80105e56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5b:	eb 03                	jmp    80105e60 <sys_sbrk+0x49>
  return addr;
80105e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e60:	c9                   	leave
80105e61:	c3                   	ret

80105e62 <sys_sleep>:

int
sys_sleep(void)
{
80105e62:	55                   	push   %ebp
80105e63:	89 e5                	mov    %esp,%ebp
80105e65:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e68:	83 ec 08             	sub    $0x8,%esp
80105e6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e6e:	50                   	push   %eax
80105e6f:	6a 00                	push   $0x0
80105e71:	e8 73 f0 ff ff       	call   80104ee9 <argint>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	79 07                	jns    80105e84 <sys_sleep+0x22>
    return -1;
80105e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e82:	eb 76                	jmp    80105efa <sys_sleep+0x98>
  acquire(&tickslock);
80105e84:	83 ec 0c             	sub    $0xc,%esp
80105e87:	68 40 6a 19 80       	push   $0x80196a40
80105e8c:	e8 b7 ea ff ff       	call   80104948 <acquire>
80105e91:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e94:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105e9c:	eb 38                	jmp    80105ed6 <sys_sleep+0x74>
    if(myproc()->killed){
80105e9e:	e8 8d db ff ff       	call   80103a30 <myproc>
80105ea3:	8b 40 24             	mov    0x24(%eax),%eax
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	74 17                	je     80105ec1 <sys_sleep+0x5f>
      release(&tickslock);
80105eaa:	83 ec 0c             	sub    $0xc,%esp
80105ead:	68 40 6a 19 80       	push   $0x80196a40
80105eb2:	e8 ff ea ff ff       	call   801049b6 <release>
80105eb7:	83 c4 10             	add    $0x10,%esp
      return -1;
80105eba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebf:	eb 39                	jmp    80105efa <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105ec1:	83 ec 08             	sub    $0x8,%esp
80105ec4:	68 40 6a 19 80       	push   $0x80196a40
80105ec9:	68 74 6a 19 80       	push   $0x80196a74
80105ece:	e8 06 e4 ff ff       	call   801042d9 <sleep>
80105ed3:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105ed6:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105edb:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105ede:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ee1:	39 d0                	cmp    %edx,%eax
80105ee3:	72 b9                	jb     80105e9e <sys_sleep+0x3c>
  }
  release(&tickslock);
80105ee5:	83 ec 0c             	sub    $0xc,%esp
80105ee8:	68 40 6a 19 80       	push   $0x80196a40
80105eed:	e8 c4 ea ff ff       	call   801049b6 <release>
80105ef2:	83 c4 10             	add    $0x10,%esp
  return 0;
80105ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105efa:	c9                   	leave
80105efb:	c3                   	ret

80105efc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105efc:	55                   	push   %ebp
80105efd:	89 e5                	mov    %esp,%ebp
80105eff:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	68 40 6a 19 80       	push   $0x80196a40
80105f0a:	e8 39 ea ff ff       	call   80104948 <acquire>
80105f0f:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105f12:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105f1a:	83 ec 0c             	sub    $0xc,%esp
80105f1d:	68 40 6a 19 80       	push   $0x80196a40
80105f22:	e8 8f ea ff ff       	call   801049b6 <release>
80105f27:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f2d:	c9                   	leave
80105f2e:	c3                   	ret

80105f2f <sys_exit2>:

int
sys_exit2(void)
{
80105f2f:	55                   	push   %ebp
80105f30:	89 e5                	mov    %esp,%ebp
80105f32:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if(argint(0,&pid)<0){
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f3b:	50                   	push   %eax
80105f3c:	6a 00                	push   $0x0
80105f3e:	e8 a6 ef ff ff       	call   80104ee9 <argint>
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 c0                	test   %eax,%eax
80105f48:	79 07                	jns    80105f51 <sys_exit2+0x22>
    return -1;
80105f4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f4f:	eb 14                	jmp    80105f65 <sys_exit2+0x36>
  }
  exit2(pid);
80105f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	50                   	push   %eax
80105f58:	e8 18 e6 ff ff       	call   80104575 <exit2>
80105f5d:	83 c4 10             	add    $0x10,%esp
  return 0;  // not reached
80105f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f65:	c9                   	leave
80105f66:	c3                   	ret

80105f67 <sys_wait2>:

int
sys_wait2(void)
{
80105f67:	55                   	push   %ebp
80105f68:	89 e5                	mov    %esp,%ebp
80105f6a:	83 ec 18             	sub    $0x18,%esp
  int* pid;
  if(argint(0,(int*)&pid)<0){
80105f6d:	83 ec 08             	sub    $0x8,%esp
80105f70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f73:	50                   	push   %eax
80105f74:	6a 00                	push   $0x0
80105f76:	e8 6e ef ff ff       	call   80104ee9 <argint>
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	79 07                	jns    80105f89 <sys_wait2+0x22>
    return -1;
80105f82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f87:	eb 0f                	jmp    80105f98 <sys_wait2+0x31>
  }
  return wait2(pid);
80105f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	50                   	push   %eax
80105f90:	e8 09 e7 ff ff       	call   8010469e <wait2>
80105f95:	83 c4 10             	add    $0x10,%esp
}
80105f98:	c9                   	leave
80105f99:	c3                   	ret

80105f9a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f9a:	1e                   	push   %ds
  pushl %es
80105f9b:	06                   	push   %es
  pushl %fs
80105f9c:	0f a0                	push   %fs
  pushl %gs
80105f9e:	0f a8                	push   %gs
  pushal
80105fa0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fa1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fa5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fa7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fa9:	54                   	push   %esp
  call trap
80105faa:	e8 d7 01 00 00       	call   80106186 <trap>
  addl $4, %esp
80105faf:	83 c4 04             	add    $0x4,%esp

80105fb2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fb2:	61                   	popa
  popl %gs
80105fb3:	0f a9                	pop    %gs
  popl %fs
80105fb5:	0f a1                	pop    %fs
  popl %es
80105fb7:	07                   	pop    %es
  popl %ds
80105fb8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fb9:	83 c4 08             	add    $0x8,%esp
  iret
80105fbc:	cf                   	iret

80105fbd <lidt>:
{
80105fbd:	55                   	push   %ebp
80105fbe:	89 e5                	mov    %esp,%ebp
80105fc0:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fc6:	83 e8 01             	sub    $0x1,%eax
80105fc9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80105fd0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80105fd7:	c1 e8 10             	shr    $0x10,%eax
80105fda:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fde:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fe1:	0f 01 18             	lidtl  (%eax)
}
80105fe4:	90                   	nop
80105fe5:	c9                   	leave
80105fe6:	c3                   	ret

80105fe7 <rcr2>:

static inline uint
rcr2(void)
{
80105fe7:	55                   	push   %ebp
80105fe8:	89 e5                	mov    %esp,%ebp
80105fea:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fed:	0f 20 d0             	mov    %cr2,%eax
80105ff0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80105ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ff6:	c9                   	leave
80105ff7:	c3                   	ret

80105ff8 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ff8:	55                   	push   %ebp
80105ff9:	89 e5                	mov    %esp,%ebp
80105ffb:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80105ffe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106005:	e9 c3 00 00 00       	jmp    801060cd <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010600a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600d:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
80106014:	89 c2                	mov    %eax,%edx
80106016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106019:	66 89 14 c5 40 62 19 	mov    %dx,-0x7fe69dc0(,%eax,8)
80106020:	80 
80106021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106024:	66 c7 04 c5 42 62 19 	movw   $0x8,-0x7fe69dbe(,%eax,8)
8010602b:	80 08 00 
8010602e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106031:	0f b6 14 c5 44 62 19 	movzbl -0x7fe69dbc(,%eax,8),%edx
80106038:	80 
80106039:	83 e2 e0             	and    $0xffffffe0,%edx
8010603c:	88 14 c5 44 62 19 80 	mov    %dl,-0x7fe69dbc(,%eax,8)
80106043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106046:	0f b6 14 c5 44 62 19 	movzbl -0x7fe69dbc(,%eax,8),%edx
8010604d:	80 
8010604e:	83 e2 1f             	and    $0x1f,%edx
80106051:	88 14 c5 44 62 19 80 	mov    %dl,-0x7fe69dbc(,%eax,8)
80106058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605b:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
80106062:	80 
80106063:	83 e2 f0             	and    $0xfffffff0,%edx
80106066:	83 ca 0e             	or     $0xe,%edx
80106069:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
80106070:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106073:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
8010607a:	80 
8010607b:	83 e2 ef             	and    $0xffffffef,%edx
8010607e:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
80106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106088:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
8010608f:	80 
80106090:	83 e2 9f             	and    $0xffffff9f,%edx
80106093:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
8010609a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609d:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
801060a4:	80 
801060a5:	83 ca 80             	or     $0xffffff80,%edx
801060a8:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
801060af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b2:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
801060b9:	c1 e8 10             	shr    $0x10,%eax
801060bc:	89 c2                	mov    %eax,%edx
801060be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c1:	66 89 14 c5 46 62 19 	mov    %dx,-0x7fe69dba(,%eax,8)
801060c8:	80 
  for(i = 0; i < 256; i++)
801060c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801060cd:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801060d4:	0f 8e 30 ff ff ff    	jle    8010600a <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060da:	a1 80 f1 10 80       	mov    0x8010f180,%eax
801060df:	66 a3 40 64 19 80    	mov    %ax,0x80196440
801060e5:	66 c7 05 42 64 19 80 	movw   $0x8,0x80196442
801060ec:	08 00 
801060ee:	0f b6 05 44 64 19 80 	movzbl 0x80196444,%eax
801060f5:	83 e0 e0             	and    $0xffffffe0,%eax
801060f8:	a2 44 64 19 80       	mov    %al,0x80196444
801060fd:	0f b6 05 44 64 19 80 	movzbl 0x80196444,%eax
80106104:	83 e0 1f             	and    $0x1f,%eax
80106107:	a2 44 64 19 80       	mov    %al,0x80196444
8010610c:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106113:	83 c8 0f             	or     $0xf,%eax
80106116:	a2 45 64 19 80       	mov    %al,0x80196445
8010611b:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106122:	83 e0 ef             	and    $0xffffffef,%eax
80106125:	a2 45 64 19 80       	mov    %al,0x80196445
8010612a:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106131:	83 c8 60             	or     $0x60,%eax
80106134:	a2 45 64 19 80       	mov    %al,0x80196445
80106139:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106140:	83 c8 80             	or     $0xffffff80,%eax
80106143:	a2 45 64 19 80       	mov    %al,0x80196445
80106148:	a1 80 f1 10 80       	mov    0x8010f180,%eax
8010614d:	c1 e8 10             	shr    $0x10,%eax
80106150:	66 a3 46 64 19 80    	mov    %ax,0x80196446

  initlock(&tickslock, "time");
80106156:	83 ec 08             	sub    $0x8,%esp
80106159:	68 64 a6 10 80       	push   $0x8010a664
8010615e:	68 40 6a 19 80       	push   $0x80196a40
80106163:	e8 be e7 ff ff       	call   80104926 <initlock>
80106168:	83 c4 10             	add    $0x10,%esp
}
8010616b:	90                   	nop
8010616c:	c9                   	leave
8010616d:	c3                   	ret

8010616e <idtinit>:

void
idtinit(void)
{
8010616e:	55                   	push   %ebp
8010616f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106171:	68 00 08 00 00       	push   $0x800
80106176:	68 40 62 19 80       	push   $0x80196240
8010617b:	e8 3d fe ff ff       	call   80105fbd <lidt>
80106180:	83 c4 08             	add    $0x8,%esp
}
80106183:	90                   	nop
80106184:	c9                   	leave
80106185:	c3                   	ret

80106186 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106186:	55                   	push   %ebp
80106187:	89 e5                	mov    %esp,%ebp
80106189:	57                   	push   %edi
8010618a:	56                   	push   %esi
8010618b:	53                   	push   %ebx
8010618c:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010618f:	8b 45 08             	mov    0x8(%ebp),%eax
80106192:	8b 40 30             	mov    0x30(%eax),%eax
80106195:	83 f8 40             	cmp    $0x40,%eax
80106198:	75 3b                	jne    801061d5 <trap+0x4f>
    if(myproc()->killed)
8010619a:	e8 91 d8 ff ff       	call   80103a30 <myproc>
8010619f:	8b 40 24             	mov    0x24(%eax),%eax
801061a2:	85 c0                	test   %eax,%eax
801061a4:	74 05                	je     801061ab <trap+0x25>
      exit();
801061a6:	e8 fd dc ff ff       	call   80103ea8 <exit>
    myproc()->tf = tf;
801061ab:	e8 80 d8 ff ff       	call   80103a30 <myproc>
801061b0:	8b 55 08             	mov    0x8(%ebp),%edx
801061b3:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801061b6:	e8 fa ed ff ff       	call   80104fb5 <syscall>
    if(myproc()->killed)
801061bb:	e8 70 d8 ff ff       	call   80103a30 <myproc>
801061c0:	8b 40 24             	mov    0x24(%eax),%eax
801061c3:	85 c0                	test   %eax,%eax
801061c5:	0f 84 15 02 00 00    	je     801063e0 <trap+0x25a>
      exit();
801061cb:	e8 d8 dc ff ff       	call   80103ea8 <exit>
    return;
801061d0:	e9 0b 02 00 00       	jmp    801063e0 <trap+0x25a>
  }

  switch(tf->trapno){
801061d5:	8b 45 08             	mov    0x8(%ebp),%eax
801061d8:	8b 40 30             	mov    0x30(%eax),%eax
801061db:	83 e8 20             	sub    $0x20,%eax
801061de:	83 f8 1f             	cmp    $0x1f,%eax
801061e1:	0f 87 c4 00 00 00    	ja     801062ab <trap+0x125>
801061e7:	8b 04 85 0c a7 10 80 	mov    -0x7fef58f4(,%eax,4),%eax
801061ee:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801061f0:	e8 a8 d7 ff ff       	call   8010399d <cpuid>
801061f5:	85 c0                	test   %eax,%eax
801061f7:	75 3d                	jne    80106236 <trap+0xb0>
      acquire(&tickslock);
801061f9:	83 ec 0c             	sub    $0xc,%esp
801061fc:	68 40 6a 19 80       	push   $0x80196a40
80106201:	e8 42 e7 ff ff       	call   80104948 <acquire>
80106206:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106209:	a1 74 6a 19 80       	mov    0x80196a74,%eax
8010620e:	83 c0 01             	add    $0x1,%eax
80106211:	a3 74 6a 19 80       	mov    %eax,0x80196a74
      wakeup(&ticks);
80106216:	83 ec 0c             	sub    $0xc,%esp
80106219:	68 74 6a 19 80       	push   $0x80196a74
8010621e:	e8 9d e1 ff ff       	call   801043c0 <wakeup>
80106223:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106226:	83 ec 0c             	sub    $0xc,%esp
80106229:	68 40 6a 19 80       	push   $0x80196a40
8010622e:	e8 83 e7 ff ff       	call   801049b6 <release>
80106233:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106236:	e8 e3 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
8010623b:	e9 20 01 00 00       	jmp    80106360 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106240:	e8 db 3e 00 00       	call   8010a120 <ideintr>
    lapiceoi();
80106245:	e8 d4 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
8010624a:	e9 11 01 00 00       	jmp    80106360 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010624f:	e8 15 c7 ff ff       	call   80102969 <kbdintr>
    lapiceoi();
80106254:	e8 c5 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106259:	e9 02 01 00 00       	jmp    80106360 <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010625e:	e8 51 03 00 00       	call   801065b4 <uartintr>
    lapiceoi();
80106263:	e8 b6 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106268:	e9 f3 00 00 00       	jmp    80106360 <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
8010626d:	e8 77 2b 00 00       	call   80108de9 <i8254_intr>
    lapiceoi();
80106272:	e8 a7 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106277:	e9 e4 00 00 00       	jmp    80106360 <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010627c:	8b 45 08             	mov    0x8(%ebp),%eax
8010627f:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106282:	8b 45 08             	mov    0x8(%ebp),%eax
80106285:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106289:	0f b7 d8             	movzwl %ax,%ebx
8010628c:	e8 0c d7 ff ff       	call   8010399d <cpuid>
80106291:	56                   	push   %esi
80106292:	53                   	push   %ebx
80106293:	50                   	push   %eax
80106294:	68 6c a6 10 80       	push   $0x8010a66c
80106299:	e8 56 a1 ff ff       	call   801003f4 <cprintf>
8010629e:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062a1:	e8 78 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
801062a6:	e9 b5 00 00 00       	jmp    80106360 <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062ab:	e8 80 d7 ff ff       	call   80103a30 <myproc>
801062b0:	85 c0                	test   %eax,%eax
801062b2:	74 11                	je     801062c5 <trap+0x13f>
801062b4:	8b 45 08             	mov    0x8(%ebp),%eax
801062b7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801062bb:	0f b7 c0             	movzwl %ax,%eax
801062be:	83 e0 03             	and    $0x3,%eax
801062c1:	85 c0                	test   %eax,%eax
801062c3:	75 39                	jne    801062fe <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062c5:	e8 1d fd ff ff       	call   80105fe7 <rcr2>
801062ca:	89 c3                	mov    %eax,%ebx
801062cc:	8b 45 08             	mov    0x8(%ebp),%eax
801062cf:	8b 70 38             	mov    0x38(%eax),%esi
801062d2:	e8 c6 d6 ff ff       	call   8010399d <cpuid>
801062d7:	8b 55 08             	mov    0x8(%ebp),%edx
801062da:	8b 52 30             	mov    0x30(%edx),%edx
801062dd:	83 ec 0c             	sub    $0xc,%esp
801062e0:	53                   	push   %ebx
801062e1:	56                   	push   %esi
801062e2:	50                   	push   %eax
801062e3:	52                   	push   %edx
801062e4:	68 90 a6 10 80       	push   $0x8010a690
801062e9:	e8 06 a1 ff ff       	call   801003f4 <cprintf>
801062ee:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801062f1:	83 ec 0c             	sub    $0xc,%esp
801062f4:	68 c2 a6 10 80       	push   $0x8010a6c2
801062f9:	e8 ab a2 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062fe:	e8 e4 fc ff ff       	call   80105fe7 <rcr2>
80106303:	89 c6                	mov    %eax,%esi
80106305:	8b 45 08             	mov    0x8(%ebp),%eax
80106308:	8b 40 38             	mov    0x38(%eax),%eax
8010630b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010630e:	e8 8a d6 ff ff       	call   8010399d <cpuid>
80106313:	89 c3                	mov    %eax,%ebx
80106315:	8b 45 08             	mov    0x8(%ebp),%eax
80106318:	8b 48 34             	mov    0x34(%eax),%ecx
8010631b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010631e:	8b 45 08             	mov    0x8(%ebp),%eax
80106321:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106324:	e8 07 d7 ff ff       	call   80103a30 <myproc>
80106329:	8d 50 6c             	lea    0x6c(%eax),%edx
8010632c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010632f:	e8 fc d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106334:	8b 40 10             	mov    0x10(%eax),%eax
80106337:	56                   	push   %esi
80106338:	ff 75 e4             	push   -0x1c(%ebp)
8010633b:	53                   	push   %ebx
8010633c:	ff 75 e0             	push   -0x20(%ebp)
8010633f:	57                   	push   %edi
80106340:	ff 75 dc             	push   -0x24(%ebp)
80106343:	50                   	push   %eax
80106344:	68 c8 a6 10 80       	push   $0x8010a6c8
80106349:	e8 a6 a0 ff ff       	call   801003f4 <cprintf>
8010634e:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106351:	e8 da d6 ff ff       	call   80103a30 <myproc>
80106356:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010635d:	eb 01                	jmp    80106360 <trap+0x1da>
    break;
8010635f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106360:	e8 cb d6 ff ff       	call   80103a30 <myproc>
80106365:	85 c0                	test   %eax,%eax
80106367:	74 23                	je     8010638c <trap+0x206>
80106369:	e8 c2 d6 ff ff       	call   80103a30 <myproc>
8010636e:	8b 40 24             	mov    0x24(%eax),%eax
80106371:	85 c0                	test   %eax,%eax
80106373:	74 17                	je     8010638c <trap+0x206>
80106375:	8b 45 08             	mov    0x8(%ebp),%eax
80106378:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010637c:	0f b7 c0             	movzwl %ax,%eax
8010637f:	83 e0 03             	and    $0x3,%eax
80106382:	83 f8 03             	cmp    $0x3,%eax
80106385:	75 05                	jne    8010638c <trap+0x206>
    exit();
80106387:	e8 1c db ff ff       	call   80103ea8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010638c:	e8 9f d6 ff ff       	call   80103a30 <myproc>
80106391:	85 c0                	test   %eax,%eax
80106393:	74 1d                	je     801063b2 <trap+0x22c>
80106395:	e8 96 d6 ff ff       	call   80103a30 <myproc>
8010639a:	8b 40 0c             	mov    0xc(%eax),%eax
8010639d:	83 f8 04             	cmp    $0x4,%eax
801063a0:	75 10                	jne    801063b2 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801063a2:	8b 45 08             	mov    0x8(%ebp),%eax
801063a5:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801063a8:	83 f8 20             	cmp    $0x20,%eax
801063ab:	75 05                	jne    801063b2 <trap+0x22c>
    yield();
801063ad:	e8 a7 de ff ff       	call   80104259 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063b2:	e8 79 d6 ff ff       	call   80103a30 <myproc>
801063b7:	85 c0                	test   %eax,%eax
801063b9:	74 26                	je     801063e1 <trap+0x25b>
801063bb:	e8 70 d6 ff ff       	call   80103a30 <myproc>
801063c0:	8b 40 24             	mov    0x24(%eax),%eax
801063c3:	85 c0                	test   %eax,%eax
801063c5:	74 1a                	je     801063e1 <trap+0x25b>
801063c7:	8b 45 08             	mov    0x8(%ebp),%eax
801063ca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801063ce:	0f b7 c0             	movzwl %ax,%eax
801063d1:	83 e0 03             	and    $0x3,%eax
801063d4:	83 f8 03             	cmp    $0x3,%eax
801063d7:	75 08                	jne    801063e1 <trap+0x25b>
    exit();
801063d9:	e8 ca da ff ff       	call   80103ea8 <exit>
801063de:	eb 01                	jmp    801063e1 <trap+0x25b>
    return;
801063e0:	90                   	nop
}
801063e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e4:	5b                   	pop    %ebx
801063e5:	5e                   	pop    %esi
801063e6:	5f                   	pop    %edi
801063e7:	5d                   	pop    %ebp
801063e8:	c3                   	ret

801063e9 <inb>:
{
801063e9:	55                   	push   %ebp
801063ea:	89 e5                	mov    %esp,%ebp
801063ec:	83 ec 14             	sub    $0x14,%esp
801063ef:	8b 45 08             	mov    0x8(%ebp),%eax
801063f2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801063fa:	89 c2                	mov    %eax,%edx
801063fc:	ec                   	in     (%dx),%al
801063fd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106400:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106404:	c9                   	leave
80106405:	c3                   	ret

80106406 <outb>:
{
80106406:	55                   	push   %ebp
80106407:	89 e5                	mov    %esp,%ebp
80106409:	83 ec 08             	sub    $0x8,%esp
8010640c:	8b 55 08             	mov    0x8(%ebp),%edx
8010640f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106412:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106416:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106419:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010641d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106421:	ee                   	out    %al,(%dx)
}
80106422:	90                   	nop
80106423:	c9                   	leave
80106424:	c3                   	ret

80106425 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106425:	55                   	push   %ebp
80106426:	89 e5                	mov    %esp,%ebp
80106428:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010642b:	6a 00                	push   $0x0
8010642d:	68 fa 03 00 00       	push   $0x3fa
80106432:	e8 cf ff ff ff       	call   80106406 <outb>
80106437:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010643a:	68 80 00 00 00       	push   $0x80
8010643f:	68 fb 03 00 00       	push   $0x3fb
80106444:	e8 bd ff ff ff       	call   80106406 <outb>
80106449:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010644c:	6a 0c                	push   $0xc
8010644e:	68 f8 03 00 00       	push   $0x3f8
80106453:	e8 ae ff ff ff       	call   80106406 <outb>
80106458:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010645b:	6a 00                	push   $0x0
8010645d:	68 f9 03 00 00       	push   $0x3f9
80106462:	e8 9f ff ff ff       	call   80106406 <outb>
80106467:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010646a:	6a 03                	push   $0x3
8010646c:	68 fb 03 00 00       	push   $0x3fb
80106471:	e8 90 ff ff ff       	call   80106406 <outb>
80106476:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106479:	6a 00                	push   $0x0
8010647b:	68 fc 03 00 00       	push   $0x3fc
80106480:	e8 81 ff ff ff       	call   80106406 <outb>
80106485:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106488:	6a 01                	push   $0x1
8010648a:	68 f9 03 00 00       	push   $0x3f9
8010648f:	e8 72 ff ff ff       	call   80106406 <outb>
80106494:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106497:	68 fd 03 00 00       	push   $0x3fd
8010649c:	e8 48 ff ff ff       	call   801063e9 <inb>
801064a1:	83 c4 04             	add    $0x4,%esp
801064a4:	3c ff                	cmp    $0xff,%al
801064a6:	74 61                	je     80106509 <uartinit+0xe4>
    return;
  uart = 1;
801064a8:	c7 05 78 6a 19 80 01 	movl   $0x1,0x80196a78
801064af:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801064b2:	68 fa 03 00 00       	push   $0x3fa
801064b7:	e8 2d ff ff ff       	call   801063e9 <inb>
801064bc:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801064bf:	68 f8 03 00 00       	push   $0x3f8
801064c4:	e8 20 ff ff ff       	call   801063e9 <inb>
801064c9:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801064cc:	83 ec 08             	sub    $0x8,%esp
801064cf:	6a 00                	push   $0x0
801064d1:	6a 04                	push   $0x4
801064d3:	e8 5e c1 ff ff       	call   80102636 <ioapicenable>
801064d8:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801064db:	c7 45 f4 8c a7 10 80 	movl   $0x8010a78c,-0xc(%ebp)
801064e2:	eb 19                	jmp    801064fd <uartinit+0xd8>
    uartputc(*p);
801064e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e7:	0f b6 00             	movzbl (%eax),%eax
801064ea:	0f be c0             	movsbl %al,%eax
801064ed:	83 ec 0c             	sub    $0xc,%esp
801064f0:	50                   	push   %eax
801064f1:	e8 16 00 00 00       	call   8010650c <uartputc>
801064f6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801064f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801064fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106500:	0f b6 00             	movzbl (%eax),%eax
80106503:	84 c0                	test   %al,%al
80106505:	75 dd                	jne    801064e4 <uartinit+0xbf>
80106507:	eb 01                	jmp    8010650a <uartinit+0xe5>
    return;
80106509:	90                   	nop
}
8010650a:	c9                   	leave
8010650b:	c3                   	ret

8010650c <uartputc>:

void
uartputc(int c)
{
8010650c:	55                   	push   %ebp
8010650d:	89 e5                	mov    %esp,%ebp
8010650f:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106512:	a1 78 6a 19 80       	mov    0x80196a78,%eax
80106517:	85 c0                	test   %eax,%eax
80106519:	74 53                	je     8010656e <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010651b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106522:	eb 11                	jmp    80106535 <uartputc+0x29>
    microdelay(10);
80106524:	83 ec 0c             	sub    $0xc,%esp
80106527:	6a 0a                	push   $0xa
80106529:	e8 0b c6 ff ff       	call   80102b39 <microdelay>
8010652e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106531:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106535:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106539:	7f 1a                	jg     80106555 <uartputc+0x49>
8010653b:	83 ec 0c             	sub    $0xc,%esp
8010653e:	68 fd 03 00 00       	push   $0x3fd
80106543:	e8 a1 fe ff ff       	call   801063e9 <inb>
80106548:	83 c4 10             	add    $0x10,%esp
8010654b:	0f b6 c0             	movzbl %al,%eax
8010654e:	83 e0 20             	and    $0x20,%eax
80106551:	85 c0                	test   %eax,%eax
80106553:	74 cf                	je     80106524 <uartputc+0x18>
  outb(COM1+0, c);
80106555:	8b 45 08             	mov    0x8(%ebp),%eax
80106558:	0f b6 c0             	movzbl %al,%eax
8010655b:	83 ec 08             	sub    $0x8,%esp
8010655e:	50                   	push   %eax
8010655f:	68 f8 03 00 00       	push   $0x3f8
80106564:	e8 9d fe ff ff       	call   80106406 <outb>
80106569:	83 c4 10             	add    $0x10,%esp
8010656c:	eb 01                	jmp    8010656f <uartputc+0x63>
    return;
8010656e:	90                   	nop
}
8010656f:	c9                   	leave
80106570:	c3                   	ret

80106571 <uartgetc>:

static int
uartgetc(void)
{
80106571:	55                   	push   %ebp
80106572:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106574:	a1 78 6a 19 80       	mov    0x80196a78,%eax
80106579:	85 c0                	test   %eax,%eax
8010657b:	75 07                	jne    80106584 <uartgetc+0x13>
    return -1;
8010657d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106582:	eb 2e                	jmp    801065b2 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106584:	68 fd 03 00 00       	push   $0x3fd
80106589:	e8 5b fe ff ff       	call   801063e9 <inb>
8010658e:	83 c4 04             	add    $0x4,%esp
80106591:	0f b6 c0             	movzbl %al,%eax
80106594:	83 e0 01             	and    $0x1,%eax
80106597:	85 c0                	test   %eax,%eax
80106599:	75 07                	jne    801065a2 <uartgetc+0x31>
    return -1;
8010659b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a0:	eb 10                	jmp    801065b2 <uartgetc+0x41>
  return inb(COM1+0);
801065a2:	68 f8 03 00 00       	push   $0x3f8
801065a7:	e8 3d fe ff ff       	call   801063e9 <inb>
801065ac:	83 c4 04             	add    $0x4,%esp
801065af:	0f b6 c0             	movzbl %al,%eax
}
801065b2:	c9                   	leave
801065b3:	c3                   	ret

801065b4 <uartintr>:

void
uartintr(void)
{
801065b4:	55                   	push   %ebp
801065b5:	89 e5                	mov    %esp,%ebp
801065b7:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801065ba:	83 ec 0c             	sub    $0xc,%esp
801065bd:	68 71 65 10 80       	push   $0x80106571
801065c2:	e8 0f a2 ff ff       	call   801007d6 <consoleintr>
801065c7:	83 c4 10             	add    $0x10,%esp
}
801065ca:	90                   	nop
801065cb:	c9                   	leave
801065cc:	c3                   	ret

801065cd <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $0
801065cf:	6a 00                	push   $0x0
  jmp alltraps
801065d1:	e9 c4 f9 ff ff       	jmp    80105f9a <alltraps>

801065d6 <vector1>:
.globl vector1
vector1:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $1
801065d8:	6a 01                	push   $0x1
  jmp alltraps
801065da:	e9 bb f9 ff ff       	jmp    80105f9a <alltraps>

801065df <vector2>:
.globl vector2
vector2:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $2
801065e1:	6a 02                	push   $0x2
  jmp alltraps
801065e3:	e9 b2 f9 ff ff       	jmp    80105f9a <alltraps>

801065e8 <vector3>:
.globl vector3
vector3:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $3
801065ea:	6a 03                	push   $0x3
  jmp alltraps
801065ec:	e9 a9 f9 ff ff       	jmp    80105f9a <alltraps>

801065f1 <vector4>:
.globl vector4
vector4:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $4
801065f3:	6a 04                	push   $0x4
  jmp alltraps
801065f5:	e9 a0 f9 ff ff       	jmp    80105f9a <alltraps>

801065fa <vector5>:
.globl vector5
vector5:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $5
801065fc:	6a 05                	push   $0x5
  jmp alltraps
801065fe:	e9 97 f9 ff ff       	jmp    80105f9a <alltraps>

80106603 <vector6>:
.globl vector6
vector6:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $6
80106605:	6a 06                	push   $0x6
  jmp alltraps
80106607:	e9 8e f9 ff ff       	jmp    80105f9a <alltraps>

8010660c <vector7>:
.globl vector7
vector7:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $7
8010660e:	6a 07                	push   $0x7
  jmp alltraps
80106610:	e9 85 f9 ff ff       	jmp    80105f9a <alltraps>

80106615 <vector8>:
.globl vector8
vector8:
  pushl $8
80106615:	6a 08                	push   $0x8
  jmp alltraps
80106617:	e9 7e f9 ff ff       	jmp    80105f9a <alltraps>

8010661c <vector9>:
.globl vector9
vector9:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $9
8010661e:	6a 09                	push   $0x9
  jmp alltraps
80106620:	e9 75 f9 ff ff       	jmp    80105f9a <alltraps>

80106625 <vector10>:
.globl vector10
vector10:
  pushl $10
80106625:	6a 0a                	push   $0xa
  jmp alltraps
80106627:	e9 6e f9 ff ff       	jmp    80105f9a <alltraps>

8010662c <vector11>:
.globl vector11
vector11:
  pushl $11
8010662c:	6a 0b                	push   $0xb
  jmp alltraps
8010662e:	e9 67 f9 ff ff       	jmp    80105f9a <alltraps>

80106633 <vector12>:
.globl vector12
vector12:
  pushl $12
80106633:	6a 0c                	push   $0xc
  jmp alltraps
80106635:	e9 60 f9 ff ff       	jmp    80105f9a <alltraps>

8010663a <vector13>:
.globl vector13
vector13:
  pushl $13
8010663a:	6a 0d                	push   $0xd
  jmp alltraps
8010663c:	e9 59 f9 ff ff       	jmp    80105f9a <alltraps>

80106641 <vector14>:
.globl vector14
vector14:
  pushl $14
80106641:	6a 0e                	push   $0xe
  jmp alltraps
80106643:	e9 52 f9 ff ff       	jmp    80105f9a <alltraps>

80106648 <vector15>:
.globl vector15
vector15:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $15
8010664a:	6a 0f                	push   $0xf
  jmp alltraps
8010664c:	e9 49 f9 ff ff       	jmp    80105f9a <alltraps>

80106651 <vector16>:
.globl vector16
vector16:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $16
80106653:	6a 10                	push   $0x10
  jmp alltraps
80106655:	e9 40 f9 ff ff       	jmp    80105f9a <alltraps>

8010665a <vector17>:
.globl vector17
vector17:
  pushl $17
8010665a:	6a 11                	push   $0x11
  jmp alltraps
8010665c:	e9 39 f9 ff ff       	jmp    80105f9a <alltraps>

80106661 <vector18>:
.globl vector18
vector18:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $18
80106663:	6a 12                	push   $0x12
  jmp alltraps
80106665:	e9 30 f9 ff ff       	jmp    80105f9a <alltraps>

8010666a <vector19>:
.globl vector19
vector19:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $19
8010666c:	6a 13                	push   $0x13
  jmp alltraps
8010666e:	e9 27 f9 ff ff       	jmp    80105f9a <alltraps>

80106673 <vector20>:
.globl vector20
vector20:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $20
80106675:	6a 14                	push   $0x14
  jmp alltraps
80106677:	e9 1e f9 ff ff       	jmp    80105f9a <alltraps>

8010667c <vector21>:
.globl vector21
vector21:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $21
8010667e:	6a 15                	push   $0x15
  jmp alltraps
80106680:	e9 15 f9 ff ff       	jmp    80105f9a <alltraps>

80106685 <vector22>:
.globl vector22
vector22:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $22
80106687:	6a 16                	push   $0x16
  jmp alltraps
80106689:	e9 0c f9 ff ff       	jmp    80105f9a <alltraps>

8010668e <vector23>:
.globl vector23
vector23:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $23
80106690:	6a 17                	push   $0x17
  jmp alltraps
80106692:	e9 03 f9 ff ff       	jmp    80105f9a <alltraps>

80106697 <vector24>:
.globl vector24
vector24:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $24
80106699:	6a 18                	push   $0x18
  jmp alltraps
8010669b:	e9 fa f8 ff ff       	jmp    80105f9a <alltraps>

801066a0 <vector25>:
.globl vector25
vector25:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $25
801066a2:	6a 19                	push   $0x19
  jmp alltraps
801066a4:	e9 f1 f8 ff ff       	jmp    80105f9a <alltraps>

801066a9 <vector26>:
.globl vector26
vector26:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $26
801066ab:	6a 1a                	push   $0x1a
  jmp alltraps
801066ad:	e9 e8 f8 ff ff       	jmp    80105f9a <alltraps>

801066b2 <vector27>:
.globl vector27
vector27:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $27
801066b4:	6a 1b                	push   $0x1b
  jmp alltraps
801066b6:	e9 df f8 ff ff       	jmp    80105f9a <alltraps>

801066bb <vector28>:
.globl vector28
vector28:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $28
801066bd:	6a 1c                	push   $0x1c
  jmp alltraps
801066bf:	e9 d6 f8 ff ff       	jmp    80105f9a <alltraps>

801066c4 <vector29>:
.globl vector29
vector29:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $29
801066c6:	6a 1d                	push   $0x1d
  jmp alltraps
801066c8:	e9 cd f8 ff ff       	jmp    80105f9a <alltraps>

801066cd <vector30>:
.globl vector30
vector30:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $30
801066cf:	6a 1e                	push   $0x1e
  jmp alltraps
801066d1:	e9 c4 f8 ff ff       	jmp    80105f9a <alltraps>

801066d6 <vector31>:
.globl vector31
vector31:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $31
801066d8:	6a 1f                	push   $0x1f
  jmp alltraps
801066da:	e9 bb f8 ff ff       	jmp    80105f9a <alltraps>

801066df <vector32>:
.globl vector32
vector32:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $32
801066e1:	6a 20                	push   $0x20
  jmp alltraps
801066e3:	e9 b2 f8 ff ff       	jmp    80105f9a <alltraps>

801066e8 <vector33>:
.globl vector33
vector33:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $33
801066ea:	6a 21                	push   $0x21
  jmp alltraps
801066ec:	e9 a9 f8 ff ff       	jmp    80105f9a <alltraps>

801066f1 <vector34>:
.globl vector34
vector34:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $34
801066f3:	6a 22                	push   $0x22
  jmp alltraps
801066f5:	e9 a0 f8 ff ff       	jmp    80105f9a <alltraps>

801066fa <vector35>:
.globl vector35
vector35:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $35
801066fc:	6a 23                	push   $0x23
  jmp alltraps
801066fe:	e9 97 f8 ff ff       	jmp    80105f9a <alltraps>

80106703 <vector36>:
.globl vector36
vector36:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $36
80106705:	6a 24                	push   $0x24
  jmp alltraps
80106707:	e9 8e f8 ff ff       	jmp    80105f9a <alltraps>

8010670c <vector37>:
.globl vector37
vector37:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $37
8010670e:	6a 25                	push   $0x25
  jmp alltraps
80106710:	e9 85 f8 ff ff       	jmp    80105f9a <alltraps>

80106715 <vector38>:
.globl vector38
vector38:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $38
80106717:	6a 26                	push   $0x26
  jmp alltraps
80106719:	e9 7c f8 ff ff       	jmp    80105f9a <alltraps>

8010671e <vector39>:
.globl vector39
vector39:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $39
80106720:	6a 27                	push   $0x27
  jmp alltraps
80106722:	e9 73 f8 ff ff       	jmp    80105f9a <alltraps>

80106727 <vector40>:
.globl vector40
vector40:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $40
80106729:	6a 28                	push   $0x28
  jmp alltraps
8010672b:	e9 6a f8 ff ff       	jmp    80105f9a <alltraps>

80106730 <vector41>:
.globl vector41
vector41:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $41
80106732:	6a 29                	push   $0x29
  jmp alltraps
80106734:	e9 61 f8 ff ff       	jmp    80105f9a <alltraps>

80106739 <vector42>:
.globl vector42
vector42:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $42
8010673b:	6a 2a                	push   $0x2a
  jmp alltraps
8010673d:	e9 58 f8 ff ff       	jmp    80105f9a <alltraps>

80106742 <vector43>:
.globl vector43
vector43:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $43
80106744:	6a 2b                	push   $0x2b
  jmp alltraps
80106746:	e9 4f f8 ff ff       	jmp    80105f9a <alltraps>

8010674b <vector44>:
.globl vector44
vector44:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $44
8010674d:	6a 2c                	push   $0x2c
  jmp alltraps
8010674f:	e9 46 f8 ff ff       	jmp    80105f9a <alltraps>

80106754 <vector45>:
.globl vector45
vector45:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $45
80106756:	6a 2d                	push   $0x2d
  jmp alltraps
80106758:	e9 3d f8 ff ff       	jmp    80105f9a <alltraps>

8010675d <vector46>:
.globl vector46
vector46:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $46
8010675f:	6a 2e                	push   $0x2e
  jmp alltraps
80106761:	e9 34 f8 ff ff       	jmp    80105f9a <alltraps>

80106766 <vector47>:
.globl vector47
vector47:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $47
80106768:	6a 2f                	push   $0x2f
  jmp alltraps
8010676a:	e9 2b f8 ff ff       	jmp    80105f9a <alltraps>

8010676f <vector48>:
.globl vector48
vector48:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $48
80106771:	6a 30                	push   $0x30
  jmp alltraps
80106773:	e9 22 f8 ff ff       	jmp    80105f9a <alltraps>

80106778 <vector49>:
.globl vector49
vector49:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $49
8010677a:	6a 31                	push   $0x31
  jmp alltraps
8010677c:	e9 19 f8 ff ff       	jmp    80105f9a <alltraps>

80106781 <vector50>:
.globl vector50
vector50:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $50
80106783:	6a 32                	push   $0x32
  jmp alltraps
80106785:	e9 10 f8 ff ff       	jmp    80105f9a <alltraps>

8010678a <vector51>:
.globl vector51
vector51:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $51
8010678c:	6a 33                	push   $0x33
  jmp alltraps
8010678e:	e9 07 f8 ff ff       	jmp    80105f9a <alltraps>

80106793 <vector52>:
.globl vector52
vector52:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $52
80106795:	6a 34                	push   $0x34
  jmp alltraps
80106797:	e9 fe f7 ff ff       	jmp    80105f9a <alltraps>

8010679c <vector53>:
.globl vector53
vector53:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $53
8010679e:	6a 35                	push   $0x35
  jmp alltraps
801067a0:	e9 f5 f7 ff ff       	jmp    80105f9a <alltraps>

801067a5 <vector54>:
.globl vector54
vector54:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $54
801067a7:	6a 36                	push   $0x36
  jmp alltraps
801067a9:	e9 ec f7 ff ff       	jmp    80105f9a <alltraps>

801067ae <vector55>:
.globl vector55
vector55:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $55
801067b0:	6a 37                	push   $0x37
  jmp alltraps
801067b2:	e9 e3 f7 ff ff       	jmp    80105f9a <alltraps>

801067b7 <vector56>:
.globl vector56
vector56:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $56
801067b9:	6a 38                	push   $0x38
  jmp alltraps
801067bb:	e9 da f7 ff ff       	jmp    80105f9a <alltraps>

801067c0 <vector57>:
.globl vector57
vector57:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $57
801067c2:	6a 39                	push   $0x39
  jmp alltraps
801067c4:	e9 d1 f7 ff ff       	jmp    80105f9a <alltraps>

801067c9 <vector58>:
.globl vector58
vector58:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $58
801067cb:	6a 3a                	push   $0x3a
  jmp alltraps
801067cd:	e9 c8 f7 ff ff       	jmp    80105f9a <alltraps>

801067d2 <vector59>:
.globl vector59
vector59:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $59
801067d4:	6a 3b                	push   $0x3b
  jmp alltraps
801067d6:	e9 bf f7 ff ff       	jmp    80105f9a <alltraps>

801067db <vector60>:
.globl vector60
vector60:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $60
801067dd:	6a 3c                	push   $0x3c
  jmp alltraps
801067df:	e9 b6 f7 ff ff       	jmp    80105f9a <alltraps>

801067e4 <vector61>:
.globl vector61
vector61:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $61
801067e6:	6a 3d                	push   $0x3d
  jmp alltraps
801067e8:	e9 ad f7 ff ff       	jmp    80105f9a <alltraps>

801067ed <vector62>:
.globl vector62
vector62:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $62
801067ef:	6a 3e                	push   $0x3e
  jmp alltraps
801067f1:	e9 a4 f7 ff ff       	jmp    80105f9a <alltraps>

801067f6 <vector63>:
.globl vector63
vector63:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $63
801067f8:	6a 3f                	push   $0x3f
  jmp alltraps
801067fa:	e9 9b f7 ff ff       	jmp    80105f9a <alltraps>

801067ff <vector64>:
.globl vector64
vector64:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $64
80106801:	6a 40                	push   $0x40
  jmp alltraps
80106803:	e9 92 f7 ff ff       	jmp    80105f9a <alltraps>

80106808 <vector65>:
.globl vector65
vector65:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $65
8010680a:	6a 41                	push   $0x41
  jmp alltraps
8010680c:	e9 89 f7 ff ff       	jmp    80105f9a <alltraps>

80106811 <vector66>:
.globl vector66
vector66:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $66
80106813:	6a 42                	push   $0x42
  jmp alltraps
80106815:	e9 80 f7 ff ff       	jmp    80105f9a <alltraps>

8010681a <vector67>:
.globl vector67
vector67:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $67
8010681c:	6a 43                	push   $0x43
  jmp alltraps
8010681e:	e9 77 f7 ff ff       	jmp    80105f9a <alltraps>

80106823 <vector68>:
.globl vector68
vector68:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $68
80106825:	6a 44                	push   $0x44
  jmp alltraps
80106827:	e9 6e f7 ff ff       	jmp    80105f9a <alltraps>

8010682c <vector69>:
.globl vector69
vector69:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $69
8010682e:	6a 45                	push   $0x45
  jmp alltraps
80106830:	e9 65 f7 ff ff       	jmp    80105f9a <alltraps>

80106835 <vector70>:
.globl vector70
vector70:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $70
80106837:	6a 46                	push   $0x46
  jmp alltraps
80106839:	e9 5c f7 ff ff       	jmp    80105f9a <alltraps>

8010683e <vector71>:
.globl vector71
vector71:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $71
80106840:	6a 47                	push   $0x47
  jmp alltraps
80106842:	e9 53 f7 ff ff       	jmp    80105f9a <alltraps>

80106847 <vector72>:
.globl vector72
vector72:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $72
80106849:	6a 48                	push   $0x48
  jmp alltraps
8010684b:	e9 4a f7 ff ff       	jmp    80105f9a <alltraps>

80106850 <vector73>:
.globl vector73
vector73:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $73
80106852:	6a 49                	push   $0x49
  jmp alltraps
80106854:	e9 41 f7 ff ff       	jmp    80105f9a <alltraps>

80106859 <vector74>:
.globl vector74
vector74:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $74
8010685b:	6a 4a                	push   $0x4a
  jmp alltraps
8010685d:	e9 38 f7 ff ff       	jmp    80105f9a <alltraps>

80106862 <vector75>:
.globl vector75
vector75:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $75
80106864:	6a 4b                	push   $0x4b
  jmp alltraps
80106866:	e9 2f f7 ff ff       	jmp    80105f9a <alltraps>

8010686b <vector76>:
.globl vector76
vector76:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $76
8010686d:	6a 4c                	push   $0x4c
  jmp alltraps
8010686f:	e9 26 f7 ff ff       	jmp    80105f9a <alltraps>

80106874 <vector77>:
.globl vector77
vector77:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $77
80106876:	6a 4d                	push   $0x4d
  jmp alltraps
80106878:	e9 1d f7 ff ff       	jmp    80105f9a <alltraps>

8010687d <vector78>:
.globl vector78
vector78:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $78
8010687f:	6a 4e                	push   $0x4e
  jmp alltraps
80106881:	e9 14 f7 ff ff       	jmp    80105f9a <alltraps>

80106886 <vector79>:
.globl vector79
vector79:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $79
80106888:	6a 4f                	push   $0x4f
  jmp alltraps
8010688a:	e9 0b f7 ff ff       	jmp    80105f9a <alltraps>

8010688f <vector80>:
.globl vector80
vector80:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $80
80106891:	6a 50                	push   $0x50
  jmp alltraps
80106893:	e9 02 f7 ff ff       	jmp    80105f9a <alltraps>

80106898 <vector81>:
.globl vector81
vector81:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $81
8010689a:	6a 51                	push   $0x51
  jmp alltraps
8010689c:	e9 f9 f6 ff ff       	jmp    80105f9a <alltraps>

801068a1 <vector82>:
.globl vector82
vector82:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $82
801068a3:	6a 52                	push   $0x52
  jmp alltraps
801068a5:	e9 f0 f6 ff ff       	jmp    80105f9a <alltraps>

801068aa <vector83>:
.globl vector83
vector83:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $83
801068ac:	6a 53                	push   $0x53
  jmp alltraps
801068ae:	e9 e7 f6 ff ff       	jmp    80105f9a <alltraps>

801068b3 <vector84>:
.globl vector84
vector84:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $84
801068b5:	6a 54                	push   $0x54
  jmp alltraps
801068b7:	e9 de f6 ff ff       	jmp    80105f9a <alltraps>

801068bc <vector85>:
.globl vector85
vector85:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $85
801068be:	6a 55                	push   $0x55
  jmp alltraps
801068c0:	e9 d5 f6 ff ff       	jmp    80105f9a <alltraps>

801068c5 <vector86>:
.globl vector86
vector86:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $86
801068c7:	6a 56                	push   $0x56
  jmp alltraps
801068c9:	e9 cc f6 ff ff       	jmp    80105f9a <alltraps>

801068ce <vector87>:
.globl vector87
vector87:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $87
801068d0:	6a 57                	push   $0x57
  jmp alltraps
801068d2:	e9 c3 f6 ff ff       	jmp    80105f9a <alltraps>

801068d7 <vector88>:
.globl vector88
vector88:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $88
801068d9:	6a 58                	push   $0x58
  jmp alltraps
801068db:	e9 ba f6 ff ff       	jmp    80105f9a <alltraps>

801068e0 <vector89>:
.globl vector89
vector89:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $89
801068e2:	6a 59                	push   $0x59
  jmp alltraps
801068e4:	e9 b1 f6 ff ff       	jmp    80105f9a <alltraps>

801068e9 <vector90>:
.globl vector90
vector90:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $90
801068eb:	6a 5a                	push   $0x5a
  jmp alltraps
801068ed:	e9 a8 f6 ff ff       	jmp    80105f9a <alltraps>

801068f2 <vector91>:
.globl vector91
vector91:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $91
801068f4:	6a 5b                	push   $0x5b
  jmp alltraps
801068f6:	e9 9f f6 ff ff       	jmp    80105f9a <alltraps>

801068fb <vector92>:
.globl vector92
vector92:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $92
801068fd:	6a 5c                	push   $0x5c
  jmp alltraps
801068ff:	e9 96 f6 ff ff       	jmp    80105f9a <alltraps>

80106904 <vector93>:
.globl vector93
vector93:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $93
80106906:	6a 5d                	push   $0x5d
  jmp alltraps
80106908:	e9 8d f6 ff ff       	jmp    80105f9a <alltraps>

8010690d <vector94>:
.globl vector94
vector94:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $94
8010690f:	6a 5e                	push   $0x5e
  jmp alltraps
80106911:	e9 84 f6 ff ff       	jmp    80105f9a <alltraps>

80106916 <vector95>:
.globl vector95
vector95:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $95
80106918:	6a 5f                	push   $0x5f
  jmp alltraps
8010691a:	e9 7b f6 ff ff       	jmp    80105f9a <alltraps>

8010691f <vector96>:
.globl vector96
vector96:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $96
80106921:	6a 60                	push   $0x60
  jmp alltraps
80106923:	e9 72 f6 ff ff       	jmp    80105f9a <alltraps>

80106928 <vector97>:
.globl vector97
vector97:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $97
8010692a:	6a 61                	push   $0x61
  jmp alltraps
8010692c:	e9 69 f6 ff ff       	jmp    80105f9a <alltraps>

80106931 <vector98>:
.globl vector98
vector98:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $98
80106933:	6a 62                	push   $0x62
  jmp alltraps
80106935:	e9 60 f6 ff ff       	jmp    80105f9a <alltraps>

8010693a <vector99>:
.globl vector99
vector99:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $99
8010693c:	6a 63                	push   $0x63
  jmp alltraps
8010693e:	e9 57 f6 ff ff       	jmp    80105f9a <alltraps>

80106943 <vector100>:
.globl vector100
vector100:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $100
80106945:	6a 64                	push   $0x64
  jmp alltraps
80106947:	e9 4e f6 ff ff       	jmp    80105f9a <alltraps>

8010694c <vector101>:
.globl vector101
vector101:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $101
8010694e:	6a 65                	push   $0x65
  jmp alltraps
80106950:	e9 45 f6 ff ff       	jmp    80105f9a <alltraps>

80106955 <vector102>:
.globl vector102
vector102:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $102
80106957:	6a 66                	push   $0x66
  jmp alltraps
80106959:	e9 3c f6 ff ff       	jmp    80105f9a <alltraps>

8010695e <vector103>:
.globl vector103
vector103:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $103
80106960:	6a 67                	push   $0x67
  jmp alltraps
80106962:	e9 33 f6 ff ff       	jmp    80105f9a <alltraps>

80106967 <vector104>:
.globl vector104
vector104:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $104
80106969:	6a 68                	push   $0x68
  jmp alltraps
8010696b:	e9 2a f6 ff ff       	jmp    80105f9a <alltraps>

80106970 <vector105>:
.globl vector105
vector105:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $105
80106972:	6a 69                	push   $0x69
  jmp alltraps
80106974:	e9 21 f6 ff ff       	jmp    80105f9a <alltraps>

80106979 <vector106>:
.globl vector106
vector106:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $106
8010697b:	6a 6a                	push   $0x6a
  jmp alltraps
8010697d:	e9 18 f6 ff ff       	jmp    80105f9a <alltraps>

80106982 <vector107>:
.globl vector107
vector107:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $107
80106984:	6a 6b                	push   $0x6b
  jmp alltraps
80106986:	e9 0f f6 ff ff       	jmp    80105f9a <alltraps>

8010698b <vector108>:
.globl vector108
vector108:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $108
8010698d:	6a 6c                	push   $0x6c
  jmp alltraps
8010698f:	e9 06 f6 ff ff       	jmp    80105f9a <alltraps>

80106994 <vector109>:
.globl vector109
vector109:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $109
80106996:	6a 6d                	push   $0x6d
  jmp alltraps
80106998:	e9 fd f5 ff ff       	jmp    80105f9a <alltraps>

8010699d <vector110>:
.globl vector110
vector110:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $110
8010699f:	6a 6e                	push   $0x6e
  jmp alltraps
801069a1:	e9 f4 f5 ff ff       	jmp    80105f9a <alltraps>

801069a6 <vector111>:
.globl vector111
vector111:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $111
801069a8:	6a 6f                	push   $0x6f
  jmp alltraps
801069aa:	e9 eb f5 ff ff       	jmp    80105f9a <alltraps>

801069af <vector112>:
.globl vector112
vector112:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $112
801069b1:	6a 70                	push   $0x70
  jmp alltraps
801069b3:	e9 e2 f5 ff ff       	jmp    80105f9a <alltraps>

801069b8 <vector113>:
.globl vector113
vector113:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $113
801069ba:	6a 71                	push   $0x71
  jmp alltraps
801069bc:	e9 d9 f5 ff ff       	jmp    80105f9a <alltraps>

801069c1 <vector114>:
.globl vector114
vector114:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $114
801069c3:	6a 72                	push   $0x72
  jmp alltraps
801069c5:	e9 d0 f5 ff ff       	jmp    80105f9a <alltraps>

801069ca <vector115>:
.globl vector115
vector115:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $115
801069cc:	6a 73                	push   $0x73
  jmp alltraps
801069ce:	e9 c7 f5 ff ff       	jmp    80105f9a <alltraps>

801069d3 <vector116>:
.globl vector116
vector116:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $116
801069d5:	6a 74                	push   $0x74
  jmp alltraps
801069d7:	e9 be f5 ff ff       	jmp    80105f9a <alltraps>

801069dc <vector117>:
.globl vector117
vector117:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $117
801069de:	6a 75                	push   $0x75
  jmp alltraps
801069e0:	e9 b5 f5 ff ff       	jmp    80105f9a <alltraps>

801069e5 <vector118>:
.globl vector118
vector118:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $118
801069e7:	6a 76                	push   $0x76
  jmp alltraps
801069e9:	e9 ac f5 ff ff       	jmp    80105f9a <alltraps>

801069ee <vector119>:
.globl vector119
vector119:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $119
801069f0:	6a 77                	push   $0x77
  jmp alltraps
801069f2:	e9 a3 f5 ff ff       	jmp    80105f9a <alltraps>

801069f7 <vector120>:
.globl vector120
vector120:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $120
801069f9:	6a 78                	push   $0x78
  jmp alltraps
801069fb:	e9 9a f5 ff ff       	jmp    80105f9a <alltraps>

80106a00 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $121
80106a02:	6a 79                	push   $0x79
  jmp alltraps
80106a04:	e9 91 f5 ff ff       	jmp    80105f9a <alltraps>

80106a09 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $122
80106a0b:	6a 7a                	push   $0x7a
  jmp alltraps
80106a0d:	e9 88 f5 ff ff       	jmp    80105f9a <alltraps>

80106a12 <vector123>:
.globl vector123
vector123:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $123
80106a14:	6a 7b                	push   $0x7b
  jmp alltraps
80106a16:	e9 7f f5 ff ff       	jmp    80105f9a <alltraps>

80106a1b <vector124>:
.globl vector124
vector124:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $124
80106a1d:	6a 7c                	push   $0x7c
  jmp alltraps
80106a1f:	e9 76 f5 ff ff       	jmp    80105f9a <alltraps>

80106a24 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $125
80106a26:	6a 7d                	push   $0x7d
  jmp alltraps
80106a28:	e9 6d f5 ff ff       	jmp    80105f9a <alltraps>

80106a2d <vector126>:
.globl vector126
vector126:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $126
80106a2f:	6a 7e                	push   $0x7e
  jmp alltraps
80106a31:	e9 64 f5 ff ff       	jmp    80105f9a <alltraps>

80106a36 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $127
80106a38:	6a 7f                	push   $0x7f
  jmp alltraps
80106a3a:	e9 5b f5 ff ff       	jmp    80105f9a <alltraps>

80106a3f <vector128>:
.globl vector128
vector128:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $128
80106a41:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a46:	e9 4f f5 ff ff       	jmp    80105f9a <alltraps>

80106a4b <vector129>:
.globl vector129
vector129:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $129
80106a4d:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a52:	e9 43 f5 ff ff       	jmp    80105f9a <alltraps>

80106a57 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $130
80106a59:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a5e:	e9 37 f5 ff ff       	jmp    80105f9a <alltraps>

80106a63 <vector131>:
.globl vector131
vector131:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $131
80106a65:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a6a:	e9 2b f5 ff ff       	jmp    80105f9a <alltraps>

80106a6f <vector132>:
.globl vector132
vector132:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $132
80106a71:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a76:	e9 1f f5 ff ff       	jmp    80105f9a <alltraps>

80106a7b <vector133>:
.globl vector133
vector133:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $133
80106a7d:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a82:	e9 13 f5 ff ff       	jmp    80105f9a <alltraps>

80106a87 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $134
80106a89:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a8e:	e9 07 f5 ff ff       	jmp    80105f9a <alltraps>

80106a93 <vector135>:
.globl vector135
vector135:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $135
80106a95:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a9a:	e9 fb f4 ff ff       	jmp    80105f9a <alltraps>

80106a9f <vector136>:
.globl vector136
vector136:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $136
80106aa1:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106aa6:	e9 ef f4 ff ff       	jmp    80105f9a <alltraps>

80106aab <vector137>:
.globl vector137
vector137:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $137
80106aad:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ab2:	e9 e3 f4 ff ff       	jmp    80105f9a <alltraps>

80106ab7 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $138
80106ab9:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106abe:	e9 d7 f4 ff ff       	jmp    80105f9a <alltraps>

80106ac3 <vector139>:
.globl vector139
vector139:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $139
80106ac5:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106aca:	e9 cb f4 ff ff       	jmp    80105f9a <alltraps>

80106acf <vector140>:
.globl vector140
vector140:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $140
80106ad1:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ad6:	e9 bf f4 ff ff       	jmp    80105f9a <alltraps>

80106adb <vector141>:
.globl vector141
vector141:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $141
80106add:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ae2:	e9 b3 f4 ff ff       	jmp    80105f9a <alltraps>

80106ae7 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $142
80106ae9:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106aee:	e9 a7 f4 ff ff       	jmp    80105f9a <alltraps>

80106af3 <vector143>:
.globl vector143
vector143:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $143
80106af5:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106afa:	e9 9b f4 ff ff       	jmp    80105f9a <alltraps>

80106aff <vector144>:
.globl vector144
vector144:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $144
80106b01:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b06:	e9 8f f4 ff ff       	jmp    80105f9a <alltraps>

80106b0b <vector145>:
.globl vector145
vector145:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $145
80106b0d:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b12:	e9 83 f4 ff ff       	jmp    80105f9a <alltraps>

80106b17 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $146
80106b19:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b1e:	e9 77 f4 ff ff       	jmp    80105f9a <alltraps>

80106b23 <vector147>:
.globl vector147
vector147:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $147
80106b25:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b2a:	e9 6b f4 ff ff       	jmp    80105f9a <alltraps>

80106b2f <vector148>:
.globl vector148
vector148:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $148
80106b31:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b36:	e9 5f f4 ff ff       	jmp    80105f9a <alltraps>

80106b3b <vector149>:
.globl vector149
vector149:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $149
80106b3d:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b42:	e9 53 f4 ff ff       	jmp    80105f9a <alltraps>

80106b47 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $150
80106b49:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b4e:	e9 47 f4 ff ff       	jmp    80105f9a <alltraps>

80106b53 <vector151>:
.globl vector151
vector151:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $151
80106b55:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b5a:	e9 3b f4 ff ff       	jmp    80105f9a <alltraps>

80106b5f <vector152>:
.globl vector152
vector152:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $152
80106b61:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b66:	e9 2f f4 ff ff       	jmp    80105f9a <alltraps>

80106b6b <vector153>:
.globl vector153
vector153:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $153
80106b6d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b72:	e9 23 f4 ff ff       	jmp    80105f9a <alltraps>

80106b77 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $154
80106b79:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b7e:	e9 17 f4 ff ff       	jmp    80105f9a <alltraps>

80106b83 <vector155>:
.globl vector155
vector155:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $155
80106b85:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b8a:	e9 0b f4 ff ff       	jmp    80105f9a <alltraps>

80106b8f <vector156>:
.globl vector156
vector156:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $156
80106b91:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b96:	e9 ff f3 ff ff       	jmp    80105f9a <alltraps>

80106b9b <vector157>:
.globl vector157
vector157:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $157
80106b9d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ba2:	e9 f3 f3 ff ff       	jmp    80105f9a <alltraps>

80106ba7 <vector158>:
.globl vector158
vector158:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $158
80106ba9:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bae:	e9 e7 f3 ff ff       	jmp    80105f9a <alltraps>

80106bb3 <vector159>:
.globl vector159
vector159:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $159
80106bb5:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bba:	e9 db f3 ff ff       	jmp    80105f9a <alltraps>

80106bbf <vector160>:
.globl vector160
vector160:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $160
80106bc1:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bc6:	e9 cf f3 ff ff       	jmp    80105f9a <alltraps>

80106bcb <vector161>:
.globl vector161
vector161:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $161
80106bcd:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bd2:	e9 c3 f3 ff ff       	jmp    80105f9a <alltraps>

80106bd7 <vector162>:
.globl vector162
vector162:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $162
80106bd9:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bde:	e9 b7 f3 ff ff       	jmp    80105f9a <alltraps>

80106be3 <vector163>:
.globl vector163
vector163:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $163
80106be5:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bea:	e9 ab f3 ff ff       	jmp    80105f9a <alltraps>

80106bef <vector164>:
.globl vector164
vector164:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $164
80106bf1:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bf6:	e9 9f f3 ff ff       	jmp    80105f9a <alltraps>

80106bfb <vector165>:
.globl vector165
vector165:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $165
80106bfd:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c02:	e9 93 f3 ff ff       	jmp    80105f9a <alltraps>

80106c07 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $166
80106c09:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c0e:	e9 87 f3 ff ff       	jmp    80105f9a <alltraps>

80106c13 <vector167>:
.globl vector167
vector167:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $167
80106c15:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c1a:	e9 7b f3 ff ff       	jmp    80105f9a <alltraps>

80106c1f <vector168>:
.globl vector168
vector168:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $168
80106c21:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c26:	e9 6f f3 ff ff       	jmp    80105f9a <alltraps>

80106c2b <vector169>:
.globl vector169
vector169:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $169
80106c2d:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c32:	e9 63 f3 ff ff       	jmp    80105f9a <alltraps>

80106c37 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $170
80106c39:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c3e:	e9 57 f3 ff ff       	jmp    80105f9a <alltraps>

80106c43 <vector171>:
.globl vector171
vector171:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $171
80106c45:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c4a:	e9 4b f3 ff ff       	jmp    80105f9a <alltraps>

80106c4f <vector172>:
.globl vector172
vector172:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $172
80106c51:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c56:	e9 3f f3 ff ff       	jmp    80105f9a <alltraps>

80106c5b <vector173>:
.globl vector173
vector173:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $173
80106c5d:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c62:	e9 33 f3 ff ff       	jmp    80105f9a <alltraps>

80106c67 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $174
80106c69:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c6e:	e9 27 f3 ff ff       	jmp    80105f9a <alltraps>

80106c73 <vector175>:
.globl vector175
vector175:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $175
80106c75:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c7a:	e9 1b f3 ff ff       	jmp    80105f9a <alltraps>

80106c7f <vector176>:
.globl vector176
vector176:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $176
80106c81:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c86:	e9 0f f3 ff ff       	jmp    80105f9a <alltraps>

80106c8b <vector177>:
.globl vector177
vector177:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $177
80106c8d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c92:	e9 03 f3 ff ff       	jmp    80105f9a <alltraps>

80106c97 <vector178>:
.globl vector178
vector178:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $178
80106c99:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c9e:	e9 f7 f2 ff ff       	jmp    80105f9a <alltraps>

80106ca3 <vector179>:
.globl vector179
vector179:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $179
80106ca5:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106caa:	e9 eb f2 ff ff       	jmp    80105f9a <alltraps>

80106caf <vector180>:
.globl vector180
vector180:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $180
80106cb1:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cb6:	e9 df f2 ff ff       	jmp    80105f9a <alltraps>

80106cbb <vector181>:
.globl vector181
vector181:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $181
80106cbd:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cc2:	e9 d3 f2 ff ff       	jmp    80105f9a <alltraps>

80106cc7 <vector182>:
.globl vector182
vector182:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $182
80106cc9:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cce:	e9 c7 f2 ff ff       	jmp    80105f9a <alltraps>

80106cd3 <vector183>:
.globl vector183
vector183:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $183
80106cd5:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cda:	e9 bb f2 ff ff       	jmp    80105f9a <alltraps>

80106cdf <vector184>:
.globl vector184
vector184:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $184
80106ce1:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ce6:	e9 af f2 ff ff       	jmp    80105f9a <alltraps>

80106ceb <vector185>:
.globl vector185
vector185:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $185
80106ced:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cf2:	e9 a3 f2 ff ff       	jmp    80105f9a <alltraps>

80106cf7 <vector186>:
.globl vector186
vector186:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $186
80106cf9:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cfe:	e9 97 f2 ff ff       	jmp    80105f9a <alltraps>

80106d03 <vector187>:
.globl vector187
vector187:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $187
80106d05:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d0a:	e9 8b f2 ff ff       	jmp    80105f9a <alltraps>

80106d0f <vector188>:
.globl vector188
vector188:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $188
80106d11:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d16:	e9 7f f2 ff ff       	jmp    80105f9a <alltraps>

80106d1b <vector189>:
.globl vector189
vector189:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $189
80106d1d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d22:	e9 73 f2 ff ff       	jmp    80105f9a <alltraps>

80106d27 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $190
80106d29:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d2e:	e9 67 f2 ff ff       	jmp    80105f9a <alltraps>

80106d33 <vector191>:
.globl vector191
vector191:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $191
80106d35:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d3a:	e9 5b f2 ff ff       	jmp    80105f9a <alltraps>

80106d3f <vector192>:
.globl vector192
vector192:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $192
80106d41:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d46:	e9 4f f2 ff ff       	jmp    80105f9a <alltraps>

80106d4b <vector193>:
.globl vector193
vector193:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $193
80106d4d:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d52:	e9 43 f2 ff ff       	jmp    80105f9a <alltraps>

80106d57 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $194
80106d59:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d5e:	e9 37 f2 ff ff       	jmp    80105f9a <alltraps>

80106d63 <vector195>:
.globl vector195
vector195:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $195
80106d65:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d6a:	e9 2b f2 ff ff       	jmp    80105f9a <alltraps>

80106d6f <vector196>:
.globl vector196
vector196:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $196
80106d71:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d76:	e9 1f f2 ff ff       	jmp    80105f9a <alltraps>

80106d7b <vector197>:
.globl vector197
vector197:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $197
80106d7d:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d82:	e9 13 f2 ff ff       	jmp    80105f9a <alltraps>

80106d87 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $198
80106d89:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d8e:	e9 07 f2 ff ff       	jmp    80105f9a <alltraps>

80106d93 <vector199>:
.globl vector199
vector199:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $199
80106d95:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d9a:	e9 fb f1 ff ff       	jmp    80105f9a <alltraps>

80106d9f <vector200>:
.globl vector200
vector200:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $200
80106da1:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106da6:	e9 ef f1 ff ff       	jmp    80105f9a <alltraps>

80106dab <vector201>:
.globl vector201
vector201:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $201
80106dad:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106db2:	e9 e3 f1 ff ff       	jmp    80105f9a <alltraps>

80106db7 <vector202>:
.globl vector202
vector202:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $202
80106db9:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dbe:	e9 d7 f1 ff ff       	jmp    80105f9a <alltraps>

80106dc3 <vector203>:
.globl vector203
vector203:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $203
80106dc5:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dca:	e9 cb f1 ff ff       	jmp    80105f9a <alltraps>

80106dcf <vector204>:
.globl vector204
vector204:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $204
80106dd1:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dd6:	e9 bf f1 ff ff       	jmp    80105f9a <alltraps>

80106ddb <vector205>:
.globl vector205
vector205:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $205
80106ddd:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106de2:	e9 b3 f1 ff ff       	jmp    80105f9a <alltraps>

80106de7 <vector206>:
.globl vector206
vector206:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $206
80106de9:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106dee:	e9 a7 f1 ff ff       	jmp    80105f9a <alltraps>

80106df3 <vector207>:
.globl vector207
vector207:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $207
80106df5:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106dfa:	e9 9b f1 ff ff       	jmp    80105f9a <alltraps>

80106dff <vector208>:
.globl vector208
vector208:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $208
80106e01:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e06:	e9 8f f1 ff ff       	jmp    80105f9a <alltraps>

80106e0b <vector209>:
.globl vector209
vector209:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $209
80106e0d:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e12:	e9 83 f1 ff ff       	jmp    80105f9a <alltraps>

80106e17 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $210
80106e19:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e1e:	e9 77 f1 ff ff       	jmp    80105f9a <alltraps>

80106e23 <vector211>:
.globl vector211
vector211:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $211
80106e25:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e2a:	e9 6b f1 ff ff       	jmp    80105f9a <alltraps>

80106e2f <vector212>:
.globl vector212
vector212:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $212
80106e31:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e36:	e9 5f f1 ff ff       	jmp    80105f9a <alltraps>

80106e3b <vector213>:
.globl vector213
vector213:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $213
80106e3d:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e42:	e9 53 f1 ff ff       	jmp    80105f9a <alltraps>

80106e47 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $214
80106e49:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e4e:	e9 47 f1 ff ff       	jmp    80105f9a <alltraps>

80106e53 <vector215>:
.globl vector215
vector215:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $215
80106e55:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e5a:	e9 3b f1 ff ff       	jmp    80105f9a <alltraps>

80106e5f <vector216>:
.globl vector216
vector216:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $216
80106e61:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e66:	e9 2f f1 ff ff       	jmp    80105f9a <alltraps>

80106e6b <vector217>:
.globl vector217
vector217:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $217
80106e6d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e72:	e9 23 f1 ff ff       	jmp    80105f9a <alltraps>

80106e77 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $218
80106e79:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e7e:	e9 17 f1 ff ff       	jmp    80105f9a <alltraps>

80106e83 <vector219>:
.globl vector219
vector219:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $219
80106e85:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e8a:	e9 0b f1 ff ff       	jmp    80105f9a <alltraps>

80106e8f <vector220>:
.globl vector220
vector220:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $220
80106e91:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e96:	e9 ff f0 ff ff       	jmp    80105f9a <alltraps>

80106e9b <vector221>:
.globl vector221
vector221:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $221
80106e9d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ea2:	e9 f3 f0 ff ff       	jmp    80105f9a <alltraps>

80106ea7 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $222
80106ea9:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eae:	e9 e7 f0 ff ff       	jmp    80105f9a <alltraps>

80106eb3 <vector223>:
.globl vector223
vector223:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $223
80106eb5:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106eba:	e9 db f0 ff ff       	jmp    80105f9a <alltraps>

80106ebf <vector224>:
.globl vector224
vector224:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $224
80106ec1:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ec6:	e9 cf f0 ff ff       	jmp    80105f9a <alltraps>

80106ecb <vector225>:
.globl vector225
vector225:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $225
80106ecd:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106ed2:	e9 c3 f0 ff ff       	jmp    80105f9a <alltraps>

80106ed7 <vector226>:
.globl vector226
vector226:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $226
80106ed9:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ede:	e9 b7 f0 ff ff       	jmp    80105f9a <alltraps>

80106ee3 <vector227>:
.globl vector227
vector227:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $227
80106ee5:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106eea:	e9 ab f0 ff ff       	jmp    80105f9a <alltraps>

80106eef <vector228>:
.globl vector228
vector228:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $228
80106ef1:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ef6:	e9 9f f0 ff ff       	jmp    80105f9a <alltraps>

80106efb <vector229>:
.globl vector229
vector229:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $229
80106efd:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f02:	e9 93 f0 ff ff       	jmp    80105f9a <alltraps>

80106f07 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $230
80106f09:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f0e:	e9 87 f0 ff ff       	jmp    80105f9a <alltraps>

80106f13 <vector231>:
.globl vector231
vector231:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $231
80106f15:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f1a:	e9 7b f0 ff ff       	jmp    80105f9a <alltraps>

80106f1f <vector232>:
.globl vector232
vector232:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $232
80106f21:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f26:	e9 6f f0 ff ff       	jmp    80105f9a <alltraps>

80106f2b <vector233>:
.globl vector233
vector233:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $233
80106f2d:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f32:	e9 63 f0 ff ff       	jmp    80105f9a <alltraps>

80106f37 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $234
80106f39:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f3e:	e9 57 f0 ff ff       	jmp    80105f9a <alltraps>

80106f43 <vector235>:
.globl vector235
vector235:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $235
80106f45:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f4a:	e9 4b f0 ff ff       	jmp    80105f9a <alltraps>

80106f4f <vector236>:
.globl vector236
vector236:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $236
80106f51:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f56:	e9 3f f0 ff ff       	jmp    80105f9a <alltraps>

80106f5b <vector237>:
.globl vector237
vector237:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $237
80106f5d:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f62:	e9 33 f0 ff ff       	jmp    80105f9a <alltraps>

80106f67 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $238
80106f69:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f6e:	e9 27 f0 ff ff       	jmp    80105f9a <alltraps>

80106f73 <vector239>:
.globl vector239
vector239:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $239
80106f75:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f7a:	e9 1b f0 ff ff       	jmp    80105f9a <alltraps>

80106f7f <vector240>:
.globl vector240
vector240:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $240
80106f81:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f86:	e9 0f f0 ff ff       	jmp    80105f9a <alltraps>

80106f8b <vector241>:
.globl vector241
vector241:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $241
80106f8d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f92:	e9 03 f0 ff ff       	jmp    80105f9a <alltraps>

80106f97 <vector242>:
.globl vector242
vector242:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $242
80106f99:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f9e:	e9 f7 ef ff ff       	jmp    80105f9a <alltraps>

80106fa3 <vector243>:
.globl vector243
vector243:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $243
80106fa5:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106faa:	e9 eb ef ff ff       	jmp    80105f9a <alltraps>

80106faf <vector244>:
.globl vector244
vector244:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $244
80106fb1:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fb6:	e9 df ef ff ff       	jmp    80105f9a <alltraps>

80106fbb <vector245>:
.globl vector245
vector245:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $245
80106fbd:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fc2:	e9 d3 ef ff ff       	jmp    80105f9a <alltraps>

80106fc7 <vector246>:
.globl vector246
vector246:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $246
80106fc9:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fce:	e9 c7 ef ff ff       	jmp    80105f9a <alltraps>

80106fd3 <vector247>:
.globl vector247
vector247:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $247
80106fd5:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fda:	e9 bb ef ff ff       	jmp    80105f9a <alltraps>

80106fdf <vector248>:
.globl vector248
vector248:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $248
80106fe1:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fe6:	e9 af ef ff ff       	jmp    80105f9a <alltraps>

80106feb <vector249>:
.globl vector249
vector249:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $249
80106fed:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ff2:	e9 a3 ef ff ff       	jmp    80105f9a <alltraps>

80106ff7 <vector250>:
.globl vector250
vector250:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $250
80106ff9:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ffe:	e9 97 ef ff ff       	jmp    80105f9a <alltraps>

80107003 <vector251>:
.globl vector251
vector251:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $251
80107005:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010700a:	e9 8b ef ff ff       	jmp    80105f9a <alltraps>

8010700f <vector252>:
.globl vector252
vector252:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $252
80107011:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107016:	e9 7f ef ff ff       	jmp    80105f9a <alltraps>

8010701b <vector253>:
.globl vector253
vector253:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $253
8010701d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107022:	e9 73 ef ff ff       	jmp    80105f9a <alltraps>

80107027 <vector254>:
.globl vector254
vector254:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $254
80107029:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010702e:	e9 67 ef ff ff       	jmp    80105f9a <alltraps>

80107033 <vector255>:
.globl vector255
vector255:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $255
80107035:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010703a:	e9 5b ef ff ff       	jmp    80105f9a <alltraps>

8010703f <lgdt>:
{
8010703f:	55                   	push   %ebp
80107040:	89 e5                	mov    %esp,%ebp
80107042:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107045:	8b 45 0c             	mov    0xc(%ebp),%eax
80107048:	83 e8 01             	sub    $0x1,%eax
8010704b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010704f:	8b 45 08             	mov    0x8(%ebp),%eax
80107052:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107056:	8b 45 08             	mov    0x8(%ebp),%eax
80107059:	c1 e8 10             	shr    $0x10,%eax
8010705c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107060:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107063:	0f 01 10             	lgdtl  (%eax)
}
80107066:	90                   	nop
80107067:	c9                   	leave
80107068:	c3                   	ret

80107069 <ltr>:
{
80107069:	55                   	push   %ebp
8010706a:	89 e5                	mov    %esp,%ebp
8010706c:	83 ec 04             	sub    $0x4,%esp
8010706f:	8b 45 08             	mov    0x8(%ebp),%eax
80107072:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107076:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010707a:	0f 00 d8             	ltr    %eax
}
8010707d:	90                   	nop
8010707e:	c9                   	leave
8010707f:	c3                   	ret

80107080 <lcr3>:

static inline void
lcr3(uint val)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107083:	8b 45 08             	mov    0x8(%ebp),%eax
80107086:	0f 22 d8             	mov    %eax,%cr3
}
80107089:	90                   	nop
8010708a:	5d                   	pop    %ebp
8010708b:	c3                   	ret

8010708c <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010708c:	55                   	push   %ebp
8010708d:	89 e5                	mov    %esp,%ebp
8010708f:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107092:	e8 06 c9 ff ff       	call   8010399d <cpuid>
80107097:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010709d:	05 80 6a 19 80       	add    $0x80196a80,%eax
801070a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070a8:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801070ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b1:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801070b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ba:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801070be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070c5:	83 e2 f0             	and    $0xfffffff0,%edx
801070c8:	83 ca 0a             	or     $0xa,%edx
801070cb:	88 50 7d             	mov    %dl,0x7d(%eax)
801070ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070d1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070d5:	83 ca 10             	or     $0x10,%edx
801070d8:	88 50 7d             	mov    %dl,0x7d(%eax)
801070db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070de:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070e2:	83 e2 9f             	and    $0xffffff9f,%edx
801070e5:	88 50 7d             	mov    %dl,0x7d(%eax)
801070e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070eb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070ef:	83 ca 80             	or     $0xffffff80,%edx
801070f2:	88 50 7d             	mov    %dl,0x7d(%eax)
801070f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801070fc:	83 ca 0f             	or     $0xf,%edx
801070ff:	88 50 7e             	mov    %dl,0x7e(%eax)
80107102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107105:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107109:	83 e2 ef             	and    $0xffffffef,%edx
8010710c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010710f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107112:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107116:	83 e2 df             	and    $0xffffffdf,%edx
80107119:	88 50 7e             	mov    %dl,0x7e(%eax)
8010711c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107123:	83 ca 40             	or     $0x40,%edx
80107126:	88 50 7e             	mov    %dl,0x7e(%eax)
80107129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107130:	83 ca 80             	or     $0xffffff80,%edx
80107133:	88 50 7e             	mov    %dl,0x7e(%eax)
80107136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107139:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010713d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107140:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107147:	ff ff 
80107149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714c:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107153:	00 00 
80107155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107158:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010715f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107162:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107169:	83 e2 f0             	and    $0xfffffff0,%edx
8010716c:	83 ca 02             	or     $0x2,%edx
8010716f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107178:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010717f:	83 ca 10             	or     $0x10,%edx
80107182:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107192:	83 e2 9f             	and    $0xffffff9f,%edx
80107195:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010719b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071a5:	83 ca 80             	or     $0xffffff80,%edx
801071a8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071b8:	83 ca 0f             	or     $0xf,%edx
801071bb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071cb:	83 e2 ef             	and    $0xffffffef,%edx
801071ce:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071de:	83 e2 df             	and    $0xffffffdf,%edx
801071e1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ea:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071f1:	83 ca 40             	or     $0x40,%edx
801071f4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071fd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107204:	83 ca 80             	or     $0xffffff80,%edx
80107207:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010720d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107210:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721a:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107221:	ff ff 
80107223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107226:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
8010722d:	00 00 
8010722f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107232:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107243:	83 e2 f0             	and    $0xfffffff0,%edx
80107246:	83 ca 0a             	or     $0xa,%edx
80107249:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010724f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107252:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107259:	83 ca 10             	or     $0x10,%edx
8010725c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107265:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010726c:	83 ca 60             	or     $0x60,%edx
8010726f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107278:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010727f:	83 ca 80             	or     $0xffffff80,%edx
80107282:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010728b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107292:	83 ca 0f             	or     $0xf,%edx
80107295:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010729b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072a5:	83 e2 ef             	and    $0xffffffef,%edx
801072a8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072b8:	83 e2 df             	and    $0xffffffdf,%edx
801072bb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072cb:	83 ca 40             	or     $0x40,%edx
801072ce:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072de:	83 ca 80             	or     $0xffffff80,%edx
801072e1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ea:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f4:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801072fb:	ff ff 
801072fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107300:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107307:	00 00 
80107309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107316:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010731d:	83 e2 f0             	and    $0xfffffff0,%edx
80107320:	83 ca 02             	or     $0x2,%edx
80107323:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107333:	83 ca 10             	or     $0x10,%edx
80107336:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010733c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107346:	83 ca 60             	or     $0x60,%edx
80107349:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010734f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107352:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107359:	83 ca 80             	or     $0xffffff80,%edx
8010735c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107365:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010736c:	83 ca 0f             	or     $0xf,%edx
8010736f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107378:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010737f:	83 e2 ef             	and    $0xffffffef,%edx
80107382:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107392:	83 e2 df             	and    $0xffffffdf,%edx
80107395:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010739b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073a5:	83 ca 40             	or     $0x40,%edx
801073a8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073b8:	83 ca 80             	or     $0xffffff80,%edx
801073bb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c4:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801073cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ce:	83 c0 70             	add    $0x70,%eax
801073d1:	83 ec 08             	sub    $0x8,%esp
801073d4:	6a 30                	push   $0x30
801073d6:	50                   	push   %eax
801073d7:	e8 63 fc ff ff       	call   8010703f <lgdt>
801073dc:	83 c4 10             	add    $0x10,%esp
}
801073df:	90                   	nop
801073e0:	c9                   	leave
801073e1:	c3                   	ret

801073e2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801073e2:	55                   	push   %ebp
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801073e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801073eb:	c1 e8 16             	shr    $0x16,%eax
801073ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801073f5:	8b 45 08             	mov    0x8(%ebp),%eax
801073f8:	01 d0                	add    %edx,%eax
801073fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801073fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107400:	8b 00                	mov    (%eax),%eax
80107402:	83 e0 01             	and    $0x1,%eax
80107405:	85 c0                	test   %eax,%eax
80107407:	74 14                	je     8010741d <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010740c:	8b 00                	mov    (%eax),%eax
8010740e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107413:	05 00 00 00 80       	add    $0x80000000,%eax
80107418:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010741b:	eb 42                	jmp    8010745f <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010741d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107421:	74 0e                	je     80107431 <walkpgdir+0x4f>
80107423:	e8 80 b3 ff ff       	call   801027a8 <kalloc>
80107428:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010742b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010742f:	75 07                	jne    80107438 <walkpgdir+0x56>
      return 0;
80107431:	b8 00 00 00 00       	mov    $0x0,%eax
80107436:	eb 3e                	jmp    80107476 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107438:	83 ec 04             	sub    $0x4,%esp
8010743b:	68 00 10 00 00       	push   $0x1000
80107440:	6a 00                	push   $0x0
80107442:	ff 75 f4             	push   -0xc(%ebp)
80107445:	e8 74 d7 ff ff       	call   80104bbe <memset>
8010744a:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010744d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107450:	05 00 00 00 80       	add    $0x80000000,%eax
80107455:	83 c8 07             	or     $0x7,%eax
80107458:	89 c2                	mov    %eax,%edx
8010745a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010745d:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010745f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107462:	c1 e8 0c             	shr    $0xc,%eax
80107465:	25 ff 03 00 00       	and    $0x3ff,%eax
8010746a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107474:	01 d0                	add    %edx,%eax
}
80107476:	c9                   	leave
80107477:	c3                   	ret

80107478 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107478:	55                   	push   %ebp
80107479:	89 e5                	mov    %esp,%ebp
8010747b:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010747e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107489:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748c:	8b 45 10             	mov    0x10(%ebp),%eax
8010748f:	01 d0                	add    %edx,%eax
80107491:	83 e8 01             	sub    $0x1,%eax
80107494:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107499:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010749c:	83 ec 04             	sub    $0x4,%esp
8010749f:	6a 01                	push   $0x1
801074a1:	ff 75 f4             	push   -0xc(%ebp)
801074a4:	ff 75 08             	push   0x8(%ebp)
801074a7:	e8 36 ff ff ff       	call   801073e2 <walkpgdir>
801074ac:	83 c4 10             	add    $0x10,%esp
801074af:	89 45 ec             	mov    %eax,-0x14(%ebp)
801074b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801074b6:	75 07                	jne    801074bf <mappages+0x47>
      return -1;
801074b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074bd:	eb 47                	jmp    80107506 <mappages+0x8e>
    if(*pte & PTE_P)
801074bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801074c2:	8b 00                	mov    (%eax),%eax
801074c4:	83 e0 01             	and    $0x1,%eax
801074c7:	85 c0                	test   %eax,%eax
801074c9:	74 0d                	je     801074d8 <mappages+0x60>
      panic("remap");
801074cb:	83 ec 0c             	sub    $0xc,%esp
801074ce:	68 94 a7 10 80       	push   $0x8010a794
801074d3:	e8 d1 90 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
801074d8:	8b 45 18             	mov    0x18(%ebp),%eax
801074db:	0b 45 14             	or     0x14(%ebp),%eax
801074de:	83 c8 01             	or     $0x1,%eax
801074e1:	89 c2                	mov    %eax,%edx
801074e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801074e6:	89 10                	mov    %edx,(%eax)
    if(a == last)
801074e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801074ee:	74 10                	je     80107500 <mappages+0x88>
      break;
    a += PGSIZE;
801074f0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801074f7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801074fe:	eb 9c                	jmp    8010749c <mappages+0x24>
      break;
80107500:	90                   	nop
  }
  return 0;
80107501:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107506:	c9                   	leave
80107507:	c3                   	ret

80107508 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107508:	55                   	push   %ebp
80107509:	89 e5                	mov    %esp,%ebp
8010750b:	53                   	push   %ebx
8010750c:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
8010750f:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107516:	a1 50 6d 19 80       	mov    0x80196d50,%eax
8010751b:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
80107520:	29 c2                	sub    %eax,%edx
80107522:	89 d0                	mov    %edx,%eax
80107524:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107527:	a1 48 6d 19 80       	mov    0x80196d48,%eax
8010752c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010752f:	8b 15 48 6d 19 80    	mov    0x80196d48,%edx
80107535:	a1 50 6d 19 80       	mov    0x80196d50,%eax
8010753a:	01 d0                	add    %edx,%eax
8010753c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010753f:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107549:	83 c0 30             	add    $0x30,%eax
8010754c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010754f:	89 10                	mov    %edx,(%eax)
80107551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107554:	89 50 04             	mov    %edx,0x4(%eax)
80107557:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010755a:	89 50 08             	mov    %edx,0x8(%eax)
8010755d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107560:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107563:	e8 40 b2 ff ff       	call   801027a8 <kalloc>
80107568:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010756b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010756f:	75 07                	jne    80107578 <setupkvm+0x70>
    return 0;
80107571:	b8 00 00 00 00       	mov    $0x0,%eax
80107576:	eb 78                	jmp    801075f0 <setupkvm+0xe8>
  }
  memset(pgdir, 0, PGSIZE);
80107578:	83 ec 04             	sub    $0x4,%esp
8010757b:	68 00 10 00 00       	push   $0x1000
80107580:	6a 00                	push   $0x0
80107582:	ff 75 f0             	push   -0x10(%ebp)
80107585:	e8 34 d6 ff ff       	call   80104bbe <memset>
8010758a:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010758d:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
80107594:	eb 4e                	jmp    801075e4 <setupkvm+0xdc>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107599:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
8010759c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759f:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a5:	8b 58 08             	mov    0x8(%eax),%ebx
801075a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ab:	8b 40 04             	mov    0x4(%eax),%eax
801075ae:	29 c3                	sub    %eax,%ebx
801075b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b3:	8b 00                	mov    (%eax),%eax
801075b5:	83 ec 0c             	sub    $0xc,%esp
801075b8:	51                   	push   %ecx
801075b9:	52                   	push   %edx
801075ba:	53                   	push   %ebx
801075bb:	50                   	push   %eax
801075bc:	ff 75 f0             	push   -0x10(%ebp)
801075bf:	e8 b4 fe ff ff       	call   80107478 <mappages>
801075c4:	83 c4 20             	add    $0x20,%esp
801075c7:	85 c0                	test   %eax,%eax
801075c9:	79 15                	jns    801075e0 <setupkvm+0xd8>
      freevm(pgdir);
801075cb:	83 ec 0c             	sub    $0xc,%esp
801075ce:	ff 75 f0             	push   -0x10(%ebp)
801075d1:	e8 f5 04 00 00       	call   80107acb <freevm>
801075d6:	83 c4 10             	add    $0x10,%esp
      return 0;
801075d9:	b8 00 00 00 00       	mov    $0x0,%eax
801075de:	eb 10                	jmp    801075f0 <setupkvm+0xe8>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075e0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801075e4:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
801075eb:	72 a9                	jb     80107596 <setupkvm+0x8e>
    }
  return pgdir;
801075ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801075f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801075f3:	c9                   	leave
801075f4:	c3                   	ret

801075f5 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801075f5:	55                   	push   %ebp
801075f6:	89 e5                	mov    %esp,%ebp
801075f8:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075fb:	e8 08 ff ff ff       	call   80107508 <setupkvm>
80107600:	a3 7c 6a 19 80       	mov    %eax,0x80196a7c
  switchkvm();
80107605:	e8 03 00 00 00       	call   8010760d <switchkvm>
}
8010760a:	90                   	nop
8010760b:	c9                   	leave
8010760c:	c3                   	ret

8010760d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010760d:	55                   	push   %ebp
8010760e:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107610:	a1 7c 6a 19 80       	mov    0x80196a7c,%eax
80107615:	05 00 00 00 80       	add    $0x80000000,%eax
8010761a:	50                   	push   %eax
8010761b:	e8 60 fa ff ff       	call   80107080 <lcr3>
80107620:	83 c4 04             	add    $0x4,%esp
}
80107623:	90                   	nop
80107624:	c9                   	leave
80107625:	c3                   	ret

80107626 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107626:	55                   	push   %ebp
80107627:	89 e5                	mov    %esp,%ebp
80107629:	56                   	push   %esi
8010762a:	53                   	push   %ebx
8010762b:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010762e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107632:	75 0d                	jne    80107641 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107634:	83 ec 0c             	sub    $0xc,%esp
80107637:	68 9a a7 10 80       	push   $0x8010a79a
8010763c:	e8 68 8f ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
80107641:	8b 45 08             	mov    0x8(%ebp),%eax
80107644:	8b 40 08             	mov    0x8(%eax),%eax
80107647:	85 c0                	test   %eax,%eax
80107649:	75 0d                	jne    80107658 <switchuvm+0x32>
    panic("switchuvm: no kstack");
8010764b:	83 ec 0c             	sub    $0xc,%esp
8010764e:	68 b0 a7 10 80       	push   $0x8010a7b0
80107653:	e8 51 8f ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107658:	8b 45 08             	mov    0x8(%ebp),%eax
8010765b:	8b 40 04             	mov    0x4(%eax),%eax
8010765e:	85 c0                	test   %eax,%eax
80107660:	75 0d                	jne    8010766f <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107662:	83 ec 0c             	sub    $0xc,%esp
80107665:	68 c5 a7 10 80       	push   $0x8010a7c5
8010766a:	e8 3a 8f ff ff       	call   801005a9 <panic>

  pushcli();
8010766f:	e8 3f d4 ff ff       	call   80104ab3 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107674:	e8 3f c3 ff ff       	call   801039b8 <mycpu>
80107679:	89 c3                	mov    %eax,%ebx
8010767b:	e8 38 c3 ff ff       	call   801039b8 <mycpu>
80107680:	83 c0 08             	add    $0x8,%eax
80107683:	89 c6                	mov    %eax,%esi
80107685:	e8 2e c3 ff ff       	call   801039b8 <mycpu>
8010768a:	83 c0 08             	add    $0x8,%eax
8010768d:	c1 e8 10             	shr    $0x10,%eax
80107690:	88 45 f7             	mov    %al,-0x9(%ebp)
80107693:	e8 20 c3 ff ff       	call   801039b8 <mycpu>
80107698:	83 c0 08             	add    $0x8,%eax
8010769b:	c1 e8 18             	shr    $0x18,%eax
8010769e:	89 c2                	mov    %eax,%edx
801076a0:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801076a7:	67 00 
801076a9:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801076b0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801076b4:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801076ba:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076c1:	83 e0 f0             	and    $0xfffffff0,%eax
801076c4:	83 c8 09             	or     $0x9,%eax
801076c7:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076cd:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076d4:	83 c8 10             	or     $0x10,%eax
801076d7:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076dd:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076e4:	83 e0 9f             	and    $0xffffff9f,%eax
801076e7:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076ed:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076f4:	83 c8 80             	or     $0xffffff80,%eax
801076f7:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076fd:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107704:	83 e0 f0             	and    $0xfffffff0,%eax
80107707:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010770d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107714:	83 e0 ef             	and    $0xffffffef,%eax
80107717:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010771d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107724:	83 e0 df             	and    $0xffffffdf,%eax
80107727:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010772d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107734:	83 c8 40             	or     $0x40,%eax
80107737:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010773d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107744:	83 e0 7f             	and    $0x7f,%eax
80107747:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010774d:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107753:	e8 60 c2 ff ff       	call   801039b8 <mycpu>
80107758:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010775f:	83 e2 ef             	and    $0xffffffef,%edx
80107762:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107768:	e8 4b c2 ff ff       	call   801039b8 <mycpu>
8010776d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107773:	8b 45 08             	mov    0x8(%ebp),%eax
80107776:	8b 40 08             	mov    0x8(%eax),%eax
80107779:	89 c3                	mov    %eax,%ebx
8010777b:	e8 38 c2 ff ff       	call   801039b8 <mycpu>
80107780:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107786:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107789:	e8 2a c2 ff ff       	call   801039b8 <mycpu>
8010778e:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107794:	83 ec 0c             	sub    $0xc,%esp
80107797:	6a 28                	push   $0x28
80107799:	e8 cb f8 ff ff       	call   80107069 <ltr>
8010779e:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801077a1:	8b 45 08             	mov    0x8(%ebp),%eax
801077a4:	8b 40 04             	mov    0x4(%eax),%eax
801077a7:	05 00 00 00 80       	add    $0x80000000,%eax
801077ac:	83 ec 0c             	sub    $0xc,%esp
801077af:	50                   	push   %eax
801077b0:	e8 cb f8 ff ff       	call   80107080 <lcr3>
801077b5:	83 c4 10             	add    $0x10,%esp
  popcli();
801077b8:	e8 43 d3 ff ff       	call   80104b00 <popcli>
}
801077bd:	90                   	nop
801077be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077c1:	5b                   	pop    %ebx
801077c2:	5e                   	pop    %esi
801077c3:	5d                   	pop    %ebp
801077c4:	c3                   	ret

801077c5 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801077c5:	55                   	push   %ebp
801077c6:	89 e5                	mov    %esp,%ebp
801077c8:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801077cb:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801077d2:	76 0d                	jbe    801077e1 <inituvm+0x1c>
    panic("inituvm: more than a page");
801077d4:	83 ec 0c             	sub    $0xc,%esp
801077d7:	68 d9 a7 10 80       	push   $0x8010a7d9
801077dc:	e8 c8 8d ff ff       	call   801005a9 <panic>
  mem = kalloc();
801077e1:	e8 c2 af ff ff       	call   801027a8 <kalloc>
801077e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801077e9:	83 ec 04             	sub    $0x4,%esp
801077ec:	68 00 10 00 00       	push   $0x1000
801077f1:	6a 00                	push   $0x0
801077f3:	ff 75 f4             	push   -0xc(%ebp)
801077f6:	e8 c3 d3 ff ff       	call   80104bbe <memset>
801077fb:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801077fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107801:	05 00 00 00 80       	add    $0x80000000,%eax
80107806:	83 ec 0c             	sub    $0xc,%esp
80107809:	6a 06                	push   $0x6
8010780b:	50                   	push   %eax
8010780c:	68 00 10 00 00       	push   $0x1000
80107811:	6a 00                	push   $0x0
80107813:	ff 75 08             	push   0x8(%ebp)
80107816:	e8 5d fc ff ff       	call   80107478 <mappages>
8010781b:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010781e:	83 ec 04             	sub    $0x4,%esp
80107821:	ff 75 10             	push   0x10(%ebp)
80107824:	ff 75 0c             	push   0xc(%ebp)
80107827:	ff 75 f4             	push   -0xc(%ebp)
8010782a:	e8 4e d4 ff ff       	call   80104c7d <memmove>
8010782f:	83 c4 10             	add    $0x10,%esp
}
80107832:	90                   	nop
80107833:	c9                   	leave
80107834:	c3                   	ret

80107835 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107835:	55                   	push   %ebp
80107836:	89 e5                	mov    %esp,%ebp
80107838:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010783b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010783e:	25 ff 0f 00 00       	and    $0xfff,%eax
80107843:	85 c0                	test   %eax,%eax
80107845:	74 0d                	je     80107854 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107847:	83 ec 0c             	sub    $0xc,%esp
8010784a:	68 f4 a7 10 80       	push   $0x8010a7f4
8010784f:	e8 55 8d ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107854:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010785b:	e9 8f 00 00 00       	jmp    801078ef <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107860:	8b 55 0c             	mov    0xc(%ebp),%edx
80107863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107866:	01 d0                	add    %edx,%eax
80107868:	83 ec 04             	sub    $0x4,%esp
8010786b:	6a 00                	push   $0x0
8010786d:	50                   	push   %eax
8010786e:	ff 75 08             	push   0x8(%ebp)
80107871:	e8 6c fb ff ff       	call   801073e2 <walkpgdir>
80107876:	83 c4 10             	add    $0x10,%esp
80107879:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010787c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107880:	75 0d                	jne    8010788f <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107882:	83 ec 0c             	sub    $0xc,%esp
80107885:	68 17 a8 10 80       	push   $0x8010a817
8010788a:	e8 1a 8d ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
8010788f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107892:	8b 00                	mov    (%eax),%eax
80107894:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107899:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010789c:	8b 45 18             	mov    0x18(%ebp),%eax
8010789f:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078a2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801078a7:	77 0b                	ja     801078b4 <loaduvm+0x7f>
      n = sz - i;
801078a9:	8b 45 18             	mov    0x18(%ebp),%eax
801078ac:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078af:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078b2:	eb 07                	jmp    801078bb <loaduvm+0x86>
    else
      n = PGSIZE;
801078b4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801078bb:	8b 55 14             	mov    0x14(%ebp),%edx
801078be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c1:	01 d0                	add    %edx,%eax
801078c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801078c6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801078cc:	ff 75 f0             	push   -0x10(%ebp)
801078cf:	50                   	push   %eax
801078d0:	52                   	push   %edx
801078d1:	ff 75 10             	push   0x10(%ebp)
801078d4:	e8 05 a6 ff ff       	call   80101ede <readi>
801078d9:	83 c4 10             	add    $0x10,%esp
801078dc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801078df:	74 07                	je     801078e8 <loaduvm+0xb3>
      return -1;
801078e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078e6:	eb 18                	jmp    80107900 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
801078e8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801078ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f2:	3b 45 18             	cmp    0x18(%ebp),%eax
801078f5:	0f 82 65 ff ff ff    	jb     80107860 <loaduvm+0x2b>
  }
  return 0;
801078fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107900:	c9                   	leave
80107901:	c3                   	ret

80107902 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107902:	55                   	push   %ebp
80107903:	89 e5                	mov    %esp,%ebp
80107905:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107908:	8b 45 10             	mov    0x10(%ebp),%eax
8010790b:	85 c0                	test   %eax,%eax
8010790d:	79 0a                	jns    80107919 <allocuvm+0x17>
    return 0;
8010790f:	b8 00 00 00 00       	mov    $0x0,%eax
80107914:	e9 ec 00 00 00       	jmp    80107a05 <allocuvm+0x103>
  if(newsz < oldsz)
80107919:	8b 45 10             	mov    0x10(%ebp),%eax
8010791c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010791f:	73 08                	jae    80107929 <allocuvm+0x27>
    return oldsz;
80107921:	8b 45 0c             	mov    0xc(%ebp),%eax
80107924:	e9 dc 00 00 00       	jmp    80107a05 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107929:	8b 45 0c             	mov    0xc(%ebp),%eax
8010792c:	05 ff 0f 00 00       	add    $0xfff,%eax
80107931:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107936:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107939:	e9 b8 00 00 00       	jmp    801079f6 <allocuvm+0xf4>
    mem = kalloc();
8010793e:	e8 65 ae ff ff       	call   801027a8 <kalloc>
80107943:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107946:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010794a:	75 2e                	jne    8010797a <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
8010794c:	83 ec 0c             	sub    $0xc,%esp
8010794f:	68 35 a8 10 80       	push   $0x8010a835
80107954:	e8 9b 8a ff ff       	call   801003f4 <cprintf>
80107959:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010795c:	83 ec 04             	sub    $0x4,%esp
8010795f:	ff 75 0c             	push   0xc(%ebp)
80107962:	ff 75 10             	push   0x10(%ebp)
80107965:	ff 75 08             	push   0x8(%ebp)
80107968:	e8 9a 00 00 00       	call   80107a07 <deallocuvm>
8010796d:	83 c4 10             	add    $0x10,%esp
      return 0;
80107970:	b8 00 00 00 00       	mov    $0x0,%eax
80107975:	e9 8b 00 00 00       	jmp    80107a05 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
8010797a:	83 ec 04             	sub    $0x4,%esp
8010797d:	68 00 10 00 00       	push   $0x1000
80107982:	6a 00                	push   $0x0
80107984:	ff 75 f0             	push   -0x10(%ebp)
80107987:	e8 32 d2 ff ff       	call   80104bbe <memset>
8010798c:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010798f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107992:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799b:	83 ec 0c             	sub    $0xc,%esp
8010799e:	6a 06                	push   $0x6
801079a0:	52                   	push   %edx
801079a1:	68 00 10 00 00       	push   $0x1000
801079a6:	50                   	push   %eax
801079a7:	ff 75 08             	push   0x8(%ebp)
801079aa:	e8 c9 fa ff ff       	call   80107478 <mappages>
801079af:	83 c4 20             	add    $0x20,%esp
801079b2:	85 c0                	test   %eax,%eax
801079b4:	79 39                	jns    801079ef <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
801079b6:	83 ec 0c             	sub    $0xc,%esp
801079b9:	68 4d a8 10 80       	push   $0x8010a84d
801079be:	e8 31 8a ff ff       	call   801003f4 <cprintf>
801079c3:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801079c6:	83 ec 04             	sub    $0x4,%esp
801079c9:	ff 75 0c             	push   0xc(%ebp)
801079cc:	ff 75 10             	push   0x10(%ebp)
801079cf:	ff 75 08             	push   0x8(%ebp)
801079d2:	e8 30 00 00 00       	call   80107a07 <deallocuvm>
801079d7:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	ff 75 f0             	push   -0x10(%ebp)
801079e0:	e8 29 ad ff ff       	call   8010270e <kfree>
801079e5:	83 c4 10             	add    $0x10,%esp
      return 0;
801079e8:	b8 00 00 00 00       	mov    $0x0,%eax
801079ed:	eb 16                	jmp    80107a05 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
801079ef:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801079f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f9:	3b 45 10             	cmp    0x10(%ebp),%eax
801079fc:	0f 82 3c ff ff ff    	jb     8010793e <allocuvm+0x3c>
    }
  }
  return newsz;
80107a02:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107a05:	c9                   	leave
80107a06:	c3                   	ret

80107a07 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107a07:	55                   	push   %ebp
80107a08:	89 e5                	mov    %esp,%ebp
80107a0a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107a0d:	8b 45 10             	mov    0x10(%ebp),%eax
80107a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107a13:	72 08                	jb     80107a1d <deallocuvm+0x16>
    return oldsz;
80107a15:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a18:	e9 ac 00 00 00       	jmp    80107ac9 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107a1d:	8b 45 10             	mov    0x10(%ebp),%eax
80107a20:	05 ff 0f 00 00       	add    $0xfff,%eax
80107a25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a2d:	e9 88 00 00 00       	jmp    80107aba <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a35:	83 ec 04             	sub    $0x4,%esp
80107a38:	6a 00                	push   $0x0
80107a3a:	50                   	push   %eax
80107a3b:	ff 75 08             	push   0x8(%ebp)
80107a3e:	e8 9f f9 ff ff       	call   801073e2 <walkpgdir>
80107a43:	83 c4 10             	add    $0x10,%esp
80107a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a4d:	75 16                	jne    80107a65 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a52:	c1 e8 16             	shr    $0x16,%eax
80107a55:	83 c0 01             	add    $0x1,%eax
80107a58:	c1 e0 16             	shl    $0x16,%eax
80107a5b:	2d 00 10 00 00       	sub    $0x1000,%eax
80107a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a63:	eb 4e                	jmp    80107ab3 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a68:	8b 00                	mov    (%eax),%eax
80107a6a:	83 e0 01             	and    $0x1,%eax
80107a6d:	85 c0                	test   %eax,%eax
80107a6f:	74 42                	je     80107ab3 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a74:	8b 00                	mov    (%eax),%eax
80107a76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107a7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a82:	75 0d                	jne    80107a91 <deallocuvm+0x8a>
        panic("kfree");
80107a84:	83 ec 0c             	sub    $0xc,%esp
80107a87:	68 69 a8 10 80       	push   $0x8010a869
80107a8c:	e8 18 8b ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a94:	05 00 00 00 80       	add    $0x80000000,%eax
80107a99:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107a9c:	83 ec 0c             	sub    $0xc,%esp
80107a9f:	ff 75 e8             	push   -0x18(%ebp)
80107aa2:	e8 67 ac ff ff       	call   8010270e <kfree>
80107aa7:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107ab3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ac0:	0f 82 6c ff ff ff    	jb     80107a32 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107ac6:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ac9:	c9                   	leave
80107aca:	c3                   	ret

80107acb <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107acb:	55                   	push   %ebp
80107acc:	89 e5                	mov    %esp,%ebp
80107ace:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107ad1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ad5:	75 0d                	jne    80107ae4 <freevm+0x19>
    panic("freevm: no pgdir");
80107ad7:	83 ec 0c             	sub    $0xc,%esp
80107ada:	68 6f a8 10 80       	push   $0x8010a86f
80107adf:	e8 c5 8a ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107ae4:	83 ec 04             	sub    $0x4,%esp
80107ae7:	6a 00                	push   $0x0
80107ae9:	68 00 00 00 80       	push   $0x80000000
80107aee:	ff 75 08             	push   0x8(%ebp)
80107af1:	e8 11 ff ff ff       	call   80107a07 <deallocuvm>
80107af6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b00:	eb 48                	jmp    80107b4a <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b0f:	01 d0                	add    %edx,%eax
80107b11:	8b 00                	mov    (%eax),%eax
80107b13:	83 e0 01             	and    $0x1,%eax
80107b16:	85 c0                	test   %eax,%eax
80107b18:	74 2c                	je     80107b46 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b24:	8b 45 08             	mov    0x8(%ebp),%eax
80107b27:	01 d0                	add    %edx,%eax
80107b29:	8b 00                	mov    (%eax),%eax
80107b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b30:	05 00 00 00 80       	add    $0x80000000,%eax
80107b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107b38:	83 ec 0c             	sub    $0xc,%esp
80107b3b:	ff 75 f0             	push   -0x10(%ebp)
80107b3e:	e8 cb ab ff ff       	call   8010270e <kfree>
80107b43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107b4a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107b51:	76 af                	jbe    80107b02 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107b53:	83 ec 0c             	sub    $0xc,%esp
80107b56:	ff 75 08             	push   0x8(%ebp)
80107b59:	e8 b0 ab ff ff       	call   8010270e <kfree>
80107b5e:	83 c4 10             	add    $0x10,%esp
}
80107b61:	90                   	nop
80107b62:	c9                   	leave
80107b63:	c3                   	ret

80107b64 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b64:	55                   	push   %ebp
80107b65:	89 e5                	mov    %esp,%ebp
80107b67:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b6a:	83 ec 04             	sub    $0x4,%esp
80107b6d:	6a 00                	push   $0x0
80107b6f:	ff 75 0c             	push   0xc(%ebp)
80107b72:	ff 75 08             	push   0x8(%ebp)
80107b75:	e8 68 f8 ff ff       	call   801073e2 <walkpgdir>
80107b7a:	83 c4 10             	add    $0x10,%esp
80107b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107b80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b84:	75 0d                	jne    80107b93 <clearpteu+0x2f>
    panic("clearpteu");
80107b86:	83 ec 0c             	sub    $0xc,%esp
80107b89:	68 80 a8 10 80       	push   $0x8010a880
80107b8e:	e8 16 8a ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b96:	8b 00                	mov    (%eax),%eax
80107b98:	83 e0 fb             	and    $0xfffffffb,%eax
80107b9b:	89 c2                	mov    %eax,%edx
80107b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba0:	89 10                	mov    %edx,(%eax)
}
80107ba2:	90                   	nop
80107ba3:	c9                   	leave
80107ba4:	c3                   	ret

80107ba5 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107ba5:	55                   	push   %ebp
80107ba6:	89 e5                	mov    %esp,%ebp
80107ba8:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107bab:	e8 58 f9 ff ff       	call   80107508 <setupkvm>
80107bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107bb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bb7:	75 0a                	jne    80107bc3 <copyuvm+0x1e>
    return 0;
80107bb9:	b8 00 00 00 00       	mov    $0x0,%eax
80107bbe:	e9 eb 00 00 00       	jmp    80107cae <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107bc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bca:	e9 b7 00 00 00       	jmp    80107c86 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd2:	83 ec 04             	sub    $0x4,%esp
80107bd5:	6a 00                	push   $0x0
80107bd7:	50                   	push   %eax
80107bd8:	ff 75 08             	push   0x8(%ebp)
80107bdb:	e8 02 f8 ff ff       	call   801073e2 <walkpgdir>
80107be0:	83 c4 10             	add    $0x10,%esp
80107be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107be6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bea:	75 0d                	jne    80107bf9 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107bec:	83 ec 0c             	sub    $0xc,%esp
80107bef:	68 8a a8 10 80       	push   $0x8010a88a
80107bf4:	e8 b0 89 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bfc:	8b 00                	mov    (%eax),%eax
80107bfe:	83 e0 01             	and    $0x1,%eax
80107c01:	85 c0                	test   %eax,%eax
80107c03:	75 0d                	jne    80107c12 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107c05:	83 ec 0c             	sub    $0xc,%esp
80107c08:	68 a4 a8 10 80       	push   $0x8010a8a4
80107c0d:	e8 97 89 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c15:	8b 00                	mov    (%eax),%eax
80107c17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c22:	8b 00                	mov    (%eax),%eax
80107c24:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107c2c:	e8 77 ab ff ff       	call   801027a8 <kalloc>
80107c31:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107c38:	74 5d                	je     80107c97 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c3d:	05 00 00 00 80       	add    $0x80000000,%eax
80107c42:	83 ec 04             	sub    $0x4,%esp
80107c45:	68 00 10 00 00       	push   $0x1000
80107c4a:	50                   	push   %eax
80107c4b:	ff 75 e0             	push   -0x20(%ebp)
80107c4e:	e8 2a d0 ff ff       	call   80104c7d <memmove>
80107c53:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107c56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c5c:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c65:	83 ec 0c             	sub    $0xc,%esp
80107c68:	52                   	push   %edx
80107c69:	51                   	push   %ecx
80107c6a:	68 00 10 00 00       	push   $0x1000
80107c6f:	50                   	push   %eax
80107c70:	ff 75 f0             	push   -0x10(%ebp)
80107c73:	e8 00 f8 ff ff       	call   80107478 <mappages>
80107c78:	83 c4 20             	add    $0x20,%esp
80107c7b:	85 c0                	test   %eax,%eax
80107c7d:	78 1b                	js     80107c9a <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107c7f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c89:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c8c:	0f 82 3d ff ff ff    	jb     80107bcf <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c95:	eb 17                	jmp    80107cae <copyuvm+0x109>
      goto bad;
80107c97:	90                   	nop
80107c98:	eb 01                	jmp    80107c9b <copyuvm+0xf6>
      goto bad;
80107c9a:	90                   	nop

bad:
  freevm(d);
80107c9b:	83 ec 0c             	sub    $0xc,%esp
80107c9e:	ff 75 f0             	push   -0x10(%ebp)
80107ca1:	e8 25 fe ff ff       	call   80107acb <freevm>
80107ca6:	83 c4 10             	add    $0x10,%esp
  return 0;
80107ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cae:	c9                   	leave
80107caf:	c3                   	ret

80107cb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107cb6:	83 ec 04             	sub    $0x4,%esp
80107cb9:	6a 00                	push   $0x0
80107cbb:	ff 75 0c             	push   0xc(%ebp)
80107cbe:	ff 75 08             	push   0x8(%ebp)
80107cc1:	e8 1c f7 ff ff       	call   801073e2 <walkpgdir>
80107cc6:	83 c4 10             	add    $0x10,%esp
80107cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccf:	8b 00                	mov    (%eax),%eax
80107cd1:	83 e0 01             	and    $0x1,%eax
80107cd4:	85 c0                	test   %eax,%eax
80107cd6:	75 07                	jne    80107cdf <uva2ka+0x2f>
    return 0;
80107cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80107cdd:	eb 22                	jmp    80107d01 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce2:	8b 00                	mov    (%eax),%eax
80107ce4:	83 e0 04             	and    $0x4,%eax
80107ce7:	85 c0                	test   %eax,%eax
80107ce9:	75 07                	jne    80107cf2 <uva2ka+0x42>
    return 0;
80107ceb:	b8 00 00 00 00       	mov    $0x0,%eax
80107cf0:	eb 0f                	jmp    80107d01 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf5:	8b 00                	mov    (%eax),%eax
80107cf7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cfc:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107d01:	c9                   	leave
80107d02:	c3                   	ret

80107d03 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107d03:	55                   	push   %ebp
80107d04:	89 e5                	mov    %esp,%ebp
80107d06:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107d09:	8b 45 10             	mov    0x10(%ebp),%eax
80107d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107d0f:	eb 7f                	jmp    80107d90 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107d11:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d1f:	83 ec 08             	sub    $0x8,%esp
80107d22:	50                   	push   %eax
80107d23:	ff 75 08             	push   0x8(%ebp)
80107d26:	e8 85 ff ff ff       	call   80107cb0 <uva2ka>
80107d2b:	83 c4 10             	add    $0x10,%esp
80107d2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107d31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107d35:	75 07                	jne    80107d3e <copyout+0x3b>
      return -1;
80107d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d3c:	eb 61                	jmp    80107d9f <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d41:	2b 45 0c             	sub    0xc(%ebp),%eax
80107d44:	05 00 10 00 00       	add    $0x1000,%eax
80107d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d4f:	39 45 14             	cmp    %eax,0x14(%ebp)
80107d52:	73 06                	jae    80107d5a <copyout+0x57>
      n = len;
80107d54:	8b 45 14             	mov    0x14(%ebp),%eax
80107d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107d60:	89 c2                	mov    %eax,%edx
80107d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d65:	01 d0                	add    %edx,%eax
80107d67:	83 ec 04             	sub    $0x4,%esp
80107d6a:	ff 75 f0             	push   -0x10(%ebp)
80107d6d:	ff 75 f4             	push   -0xc(%ebp)
80107d70:	50                   	push   %eax
80107d71:	e8 07 cf ff ff       	call   80104c7d <memmove>
80107d76:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d7c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d82:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d88:	05 00 10 00 00       	add    $0x1000,%eax
80107d8d:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107d90:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107d94:	0f 85 77 ff ff ff    	jne    80107d11 <copyout+0xe>
  }
  return 0;
80107d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d9f:	c9                   	leave
80107da0:	c3                   	ret

80107da1 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107da1:	55                   	push   %ebp
80107da2:	89 e5                	mov    %esp,%ebp
80107da4:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107da7:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107db1:	8b 40 08             	mov    0x8(%eax),%eax
80107db4:	05 00 00 00 80       	add    $0x80000000,%eax
80107db9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107dbc:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc6:	8b 40 24             	mov    0x24(%eax),%eax
80107dc9:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107dce:	c7 05 40 6d 19 80 00 	movl   $0x0,0x80196d40
80107dd5:	00 00 00 

  while(i<madt->len){
80107dd8:	e9 bd 00 00 00       	jmp    80107e9a <mpinit_uefi+0xf9>
    uchar *entry_type = ((uchar *)madt)+i;
80107ddd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107de3:	01 d0                	add    %edx,%eax
80107de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107deb:	0f b6 00             	movzbl (%eax),%eax
80107dee:	0f b6 c0             	movzbl %al,%eax
80107df1:	83 f8 05             	cmp    $0x5,%eax
80107df4:	0f 87 a0 00 00 00    	ja     80107e9a <mpinit_uefi+0xf9>
80107dfa:	8b 04 85 c0 a8 10 80 	mov    -0x7fef5740(,%eax,4),%eax
80107e01:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107e09:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80107e0e:	83 f8 03             	cmp    $0x3,%eax
80107e11:	7f 28                	jg     80107e3b <mpinit_uefi+0x9a>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107e13:	8b 15 40 6d 19 80    	mov    0x80196d40,%edx
80107e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e1c:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107e20:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107e26:	81 c2 80 6a 19 80    	add    $0x80196a80,%edx
80107e2c:	88 02                	mov    %al,(%edx)
          ncpu++;
80107e2e:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80107e33:	83 c0 01             	add    $0x1,%eax
80107e36:	a3 40 6d 19 80       	mov    %eax,0x80196d40
        }
        i += lapic_entry->record_len;
80107e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e3e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e42:	0f b6 c0             	movzbl %al,%eax
80107e45:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e48:	eb 50                	jmp    80107e9a <mpinit_uefi+0xf9>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e53:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107e57:	a2 44 6d 19 80       	mov    %al,0x80196d44
        i += ioapic->record_len;
80107e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e5f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e63:	0f b6 c0             	movzbl %al,%eax
80107e66:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e69:	eb 2f                	jmp    80107e9a <mpinit_uefi+0xf9>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e74:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e78:	0f b6 c0             	movzbl %al,%eax
80107e7b:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e7e:	eb 1a                	jmp    80107e9a <mpinit_uefi+0xf9>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e83:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e89:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e8d:	0f b6 c0             	movzbl %al,%eax
80107e90:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e93:	eb 05                	jmp    80107e9a <mpinit_uefi+0xf9>

      case 5:
        i = i + 0xC;
80107e95:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107e99:	90                   	nop
  while(i<madt->len){
80107e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9d:	8b 40 04             	mov    0x4(%eax),%eax
80107ea0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107ea3:	0f 82 34 ff ff ff    	jb     80107ddd <mpinit_uefi+0x3c>
    }
  }

}
80107ea9:	90                   	nop
80107eaa:	90                   	nop
80107eab:	c9                   	leave
80107eac:	c3                   	ret

80107ead <inb>:
{
80107ead:	55                   	push   %ebp
80107eae:	89 e5                	mov    %esp,%ebp
80107eb0:	83 ec 14             	sub    $0x14,%esp
80107eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107eba:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107ebe:	89 c2                	mov    %eax,%edx
80107ec0:	ec                   	in     (%dx),%al
80107ec1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107ec4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107ec8:	c9                   	leave
80107ec9:	c3                   	ret

80107eca <outb>:
{
80107eca:	55                   	push   %ebp
80107ecb:	89 e5                	mov    %esp,%ebp
80107ecd:	83 ec 08             	sub    $0x8,%esp
80107ed0:	8b 55 08             	mov    0x8(%ebp),%edx
80107ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ed6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107eda:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107edd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107ee1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ee5:	ee                   	out    %al,(%dx)
}
80107ee6:	90                   	nop
80107ee7:	c9                   	leave
80107ee8:	c3                   	ret

80107ee9 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107ee9:	55                   	push   %ebp
80107eea:	89 e5                	mov    %esp,%ebp
80107eec:	83 ec 28             	sub    $0x28,%esp
80107eef:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef2:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107ef5:	6a 00                	push   $0x0
80107ef7:	68 fa 03 00 00       	push   $0x3fa
80107efc:	e8 c9 ff ff ff       	call   80107eca <outb>
80107f01:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f04:	68 80 00 00 00       	push   $0x80
80107f09:	68 fb 03 00 00       	push   $0x3fb
80107f0e:	e8 b7 ff ff ff       	call   80107eca <outb>
80107f13:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107f16:	6a 0c                	push   $0xc
80107f18:	68 f8 03 00 00       	push   $0x3f8
80107f1d:	e8 a8 ff ff ff       	call   80107eca <outb>
80107f22:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107f25:	6a 00                	push   $0x0
80107f27:	68 f9 03 00 00       	push   $0x3f9
80107f2c:	e8 99 ff ff ff       	call   80107eca <outb>
80107f31:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107f34:	6a 03                	push   $0x3
80107f36:	68 fb 03 00 00       	push   $0x3fb
80107f3b:	e8 8a ff ff ff       	call   80107eca <outb>
80107f40:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107f43:	6a 00                	push   $0x0
80107f45:	68 fc 03 00 00       	push   $0x3fc
80107f4a:	e8 7b ff ff ff       	call   80107eca <outb>
80107f4f:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107f52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f59:	eb 11                	jmp    80107f6c <uart_debug+0x83>
80107f5b:	83 ec 0c             	sub    $0xc,%esp
80107f5e:	6a 0a                	push   $0xa
80107f60:	e8 d4 ab ff ff       	call   80102b39 <microdelay>
80107f65:	83 c4 10             	add    $0x10,%esp
80107f68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f6c:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107f70:	7f 1a                	jg     80107f8c <uart_debug+0xa3>
80107f72:	83 ec 0c             	sub    $0xc,%esp
80107f75:	68 fd 03 00 00       	push   $0x3fd
80107f7a:	e8 2e ff ff ff       	call   80107ead <inb>
80107f7f:	83 c4 10             	add    $0x10,%esp
80107f82:	0f b6 c0             	movzbl %al,%eax
80107f85:	83 e0 20             	and    $0x20,%eax
80107f88:	85 c0                	test   %eax,%eax
80107f8a:	74 cf                	je     80107f5b <uart_debug+0x72>
  outb(COM1+0, p);
80107f8c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80107f90:	0f b6 c0             	movzbl %al,%eax
80107f93:	83 ec 08             	sub    $0x8,%esp
80107f96:	50                   	push   %eax
80107f97:	68 f8 03 00 00       	push   $0x3f8
80107f9c:	e8 29 ff ff ff       	call   80107eca <outb>
80107fa1:	83 c4 10             	add    $0x10,%esp
}
80107fa4:	90                   	nop
80107fa5:	c9                   	leave
80107fa6:	c3                   	ret

80107fa7 <uart_debugs>:

void uart_debugs(char *p){
80107fa7:	55                   	push   %ebp
80107fa8:	89 e5                	mov    %esp,%ebp
80107faa:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80107fad:	eb 1b                	jmp    80107fca <uart_debugs+0x23>
    uart_debug(*p++);
80107faf:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb2:	8d 50 01             	lea    0x1(%eax),%edx
80107fb5:	89 55 08             	mov    %edx,0x8(%ebp)
80107fb8:	0f b6 00             	movzbl (%eax),%eax
80107fbb:	0f be c0             	movsbl %al,%eax
80107fbe:	83 ec 0c             	sub    $0xc,%esp
80107fc1:	50                   	push   %eax
80107fc2:	e8 22 ff ff ff       	call   80107ee9 <uart_debug>
80107fc7:	83 c4 10             	add    $0x10,%esp
  while(*p){
80107fca:	8b 45 08             	mov    0x8(%ebp),%eax
80107fcd:	0f b6 00             	movzbl (%eax),%eax
80107fd0:	84 c0                	test   %al,%al
80107fd2:	75 db                	jne    80107faf <uart_debugs+0x8>
  }
}
80107fd4:	90                   	nop
80107fd5:	90                   	nop
80107fd6:	c9                   	leave
80107fd7:	c3                   	ret

80107fd8 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80107fd8:	55                   	push   %ebp
80107fd9:	89 e5                	mov    %esp,%ebp
80107fdb:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107fde:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80107fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107fe8:	8b 50 14             	mov    0x14(%eax),%edx
80107feb:	8b 40 10             	mov    0x10(%eax),%eax
80107fee:	a3 48 6d 19 80       	mov    %eax,0x80196d48
  gpu.vram_size = boot_param->graphic_config.frame_size;
80107ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ff6:	8b 50 1c             	mov    0x1c(%eax),%edx
80107ff9:	8b 40 18             	mov    0x18(%eax),%eax
80107ffc:	a3 50 6d 19 80       	mov    %eax,0x80196d50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
80108001:	a1 50 6d 19 80       	mov    0x80196d50,%eax
80108006:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
8010800b:	29 c2                	sub    %eax,%edx
8010800d:	89 15 4c 6d 19 80    	mov    %edx,0x80196d4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
80108013:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108016:	8b 50 24             	mov    0x24(%eax),%edx
80108019:	8b 40 20             	mov    0x20(%eax),%eax
8010801c:	a3 54 6d 19 80       	mov    %eax,0x80196d54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
80108021:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108024:	8b 50 2c             	mov    0x2c(%eax),%edx
80108027:	8b 40 28             	mov    0x28(%eax),%eax
8010802a:	a3 58 6d 19 80       	mov    %eax,0x80196d58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
8010802f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108032:	8b 50 34             	mov    0x34(%eax),%edx
80108035:	8b 40 30             	mov    0x30(%eax),%eax
80108038:	a3 5c 6d 19 80       	mov    %eax,0x80196d5c
}
8010803d:	90                   	nop
8010803e:	c9                   	leave
8010803f:	c3                   	ret

80108040 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
80108040:	55                   	push   %ebp
80108041:	89 e5                	mov    %esp,%ebp
80108043:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80108046:	8b 15 5c 6d 19 80    	mov    0x80196d5c,%edx
8010804c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010804f:	0f af d0             	imul   %eax,%edx
80108052:	8b 45 08             	mov    0x8(%ebp),%eax
80108055:	01 d0                	add    %edx,%eax
80108057:	c1 e0 02             	shl    $0x2,%eax
8010805a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
8010805d:	8b 15 4c 6d 19 80    	mov    0x80196d4c,%edx
80108063:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108066:	01 d0                	add    %edx,%eax
80108068:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
8010806b:	8b 45 10             	mov    0x10(%ebp),%eax
8010806e:	0f b6 10             	movzbl (%eax),%edx
80108071:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108074:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80108076:	8b 45 10             	mov    0x10(%ebp),%eax
80108079:	0f b6 50 01          	movzbl 0x1(%eax),%edx
8010807d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108080:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108083:	8b 45 10             	mov    0x10(%ebp),%eax
80108086:	0f b6 50 02          	movzbl 0x2(%eax),%edx
8010808a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010808d:	88 50 02             	mov    %dl,0x2(%eax)
}
80108090:	90                   	nop
80108091:	c9                   	leave
80108092:	c3                   	ret

80108093 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108093:	55                   	push   %ebp
80108094:	89 e5                	mov    %esp,%ebp
80108096:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108099:	8b 15 5c 6d 19 80    	mov    0x80196d5c,%edx
8010809f:	8b 45 08             	mov    0x8(%ebp),%eax
801080a2:	0f af c2             	imul   %edx,%eax
801080a5:	c1 e0 02             	shl    $0x2,%eax
801080a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
801080ab:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
801080b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b4:	29 c2                	sub    %eax,%edx
801080b6:	8b 0d 4c 6d 19 80    	mov    0x80196d4c,%ecx
801080bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bf:	01 c8                	add    %ecx,%eax
801080c1:	89 c1                	mov    %eax,%ecx
801080c3:	a1 4c 6d 19 80       	mov    0x80196d4c,%eax
801080c8:	83 ec 04             	sub    $0x4,%esp
801080cb:	52                   	push   %edx
801080cc:	51                   	push   %ecx
801080cd:	50                   	push   %eax
801080ce:	e8 aa cb ff ff       	call   80104c7d <memmove>
801080d3:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
801080d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d9:	8b 0d 4c 6d 19 80    	mov    0x80196d4c,%ecx
801080df:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
801080e5:	01 d1                	add    %edx,%ecx
801080e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080ea:	29 d1                	sub    %edx,%ecx
801080ec:	89 ca                	mov    %ecx,%edx
801080ee:	83 ec 04             	sub    $0x4,%esp
801080f1:	50                   	push   %eax
801080f2:	6a 00                	push   $0x0
801080f4:	52                   	push   %edx
801080f5:	e8 c4 ca ff ff       	call   80104bbe <memset>
801080fa:	83 c4 10             	add    $0x10,%esp
}
801080fd:	90                   	nop
801080fe:	c9                   	leave
801080ff:	c3                   	ret

80108100 <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
80108100:	55                   	push   %ebp
80108101:	89 e5                	mov    %esp,%ebp
80108103:	53                   	push   %ebx
80108104:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
80108107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010810e:	e9 b1 00 00 00       	jmp    801081c4 <font_render+0xc4>
    for(int j=14;j>-1;j--){
80108113:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
8010811a:	e9 97 00 00 00       	jmp    801081b6 <font_render+0xb6>
      bin = (font_bin[index-0x20][i])&(1 << j);
8010811f:	8b 45 10             	mov    0x10(%ebp),%eax
80108122:	83 e8 20             	sub    $0x20,%eax
80108125:	6b d0 1e             	imul   $0x1e,%eax,%edx
80108128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812b:	01 d0                	add    %edx,%eax
8010812d:	0f b7 84 00 e0 a8 10 	movzwl -0x7fef5720(%eax,%eax,1),%eax
80108134:	80 
80108135:	0f b7 d0             	movzwl %ax,%edx
80108138:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010813b:	bb 01 00 00 00       	mov    $0x1,%ebx
80108140:	89 c1                	mov    %eax,%ecx
80108142:	d3 e3                	shl    %cl,%ebx
80108144:	89 d8                	mov    %ebx,%eax
80108146:	21 d0                	and    %edx,%eax
80108148:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
8010814b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010814e:	ba 01 00 00 00       	mov    $0x1,%edx
80108153:	89 c1                	mov    %eax,%ecx
80108155:	d3 e2                	shl    %cl,%edx
80108157:	89 d0                	mov    %edx,%eax
80108159:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010815c:	75 2b                	jne    80108189 <font_render+0x89>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
8010815e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108164:	01 c2                	add    %eax,%edx
80108166:	b8 0e 00 00 00       	mov    $0xe,%eax
8010816b:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010816e:	89 c1                	mov    %eax,%ecx
80108170:	8b 45 08             	mov    0x8(%ebp),%eax
80108173:	01 c8                	add    %ecx,%eax
80108175:	83 ec 04             	sub    $0x4,%esp
80108178:	68 e0 f4 10 80       	push   $0x8010f4e0
8010817d:	52                   	push   %edx
8010817e:	50                   	push   %eax
8010817f:	e8 bc fe ff ff       	call   80108040 <graphic_draw_pixel>
80108184:	83 c4 10             	add    $0x10,%esp
80108187:	eb 29                	jmp    801081b2 <font_render+0xb2>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
80108189:	8b 55 0c             	mov    0xc(%ebp),%edx
8010818c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818f:	01 c2                	add    %eax,%edx
80108191:	b8 0e 00 00 00       	mov    $0xe,%eax
80108196:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108199:	89 c1                	mov    %eax,%ecx
8010819b:	8b 45 08             	mov    0x8(%ebp),%eax
8010819e:	01 c8                	add    %ecx,%eax
801081a0:	83 ec 04             	sub    $0x4,%esp
801081a3:	68 60 6d 19 80       	push   $0x80196d60
801081a8:	52                   	push   %edx
801081a9:	50                   	push   %eax
801081aa:	e8 91 fe ff ff       	call   80108040 <graphic_draw_pixel>
801081af:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
801081b2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
801081b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081ba:	0f 89 5f ff ff ff    	jns    8010811f <font_render+0x1f>
  for(int i=0;i<30;i++){
801081c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801081c4:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
801081c8:	0f 8e 45 ff ff ff    	jle    80108113 <font_render+0x13>
      }
    }
  }
}
801081ce:	90                   	nop
801081cf:	90                   	nop
801081d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081d3:	c9                   	leave
801081d4:	c3                   	ret

801081d5 <font_render_string>:

void font_render_string(char *string,int row){
801081d5:	55                   	push   %ebp
801081d6:	89 e5                	mov    %esp,%ebp
801081d8:	53                   	push   %ebx
801081d9:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
801081dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
801081e3:	eb 33                	jmp    80108218 <font_render_string+0x43>
    font_render(i*15+2,row*30,string[i]);
801081e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081e8:	8b 45 08             	mov    0x8(%ebp),%eax
801081eb:	01 d0                	add    %edx,%eax
801081ed:	0f b6 00             	movzbl (%eax),%eax
801081f0:	0f be d8             	movsbl %al,%ebx
801081f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801081f6:	6b c8 1e             	imul   $0x1e,%eax,%ecx
801081f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081fc:	89 d0                	mov    %edx,%eax
801081fe:	c1 e0 04             	shl    $0x4,%eax
80108201:	29 d0                	sub    %edx,%eax
80108203:	83 c0 02             	add    $0x2,%eax
80108206:	83 ec 04             	sub    $0x4,%esp
80108209:	53                   	push   %ebx
8010820a:	51                   	push   %ecx
8010820b:	50                   	push   %eax
8010820c:	e8 ef fe ff ff       	call   80108100 <font_render>
80108211:	83 c4 10             	add    $0x10,%esp
    i++;
80108214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
80108218:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010821b:	8b 45 08             	mov    0x8(%ebp),%eax
8010821e:	01 d0                	add    %edx,%eax
80108220:	0f b6 00             	movzbl (%eax),%eax
80108223:	84 c0                	test   %al,%al
80108225:	74 06                	je     8010822d <font_render_string+0x58>
80108227:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
8010822b:	7e b8                	jle    801081e5 <font_render_string+0x10>
  }
}
8010822d:	90                   	nop
8010822e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108231:	c9                   	leave
80108232:	c3                   	ret

80108233 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
80108233:	55                   	push   %ebp
80108234:	89 e5                	mov    %esp,%ebp
80108236:	53                   	push   %ebx
80108237:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
8010823a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108241:	eb 6b                	jmp    801082ae <pci_init+0x7b>
    for(int j=0;j<32;j++){
80108243:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010824a:	eb 58                	jmp    801082a4 <pci_init+0x71>
      for(int k=0;k<8;k++){
8010824c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108253:	eb 45                	jmp    8010829a <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
80108255:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108258:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010825b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825e:	83 ec 0c             	sub    $0xc,%esp
80108261:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80108264:	53                   	push   %ebx
80108265:	6a 00                	push   $0x0
80108267:	51                   	push   %ecx
80108268:	52                   	push   %edx
80108269:	50                   	push   %eax
8010826a:	e8 b0 00 00 00       	call   8010831f <pci_access_config>
8010826f:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108272:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108275:	0f b7 c0             	movzwl %ax,%eax
80108278:	3d ff ff 00 00       	cmp    $0xffff,%eax
8010827d:	74 17                	je     80108296 <pci_init+0x63>
        pci_init_device(i,j,k);
8010827f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108282:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108288:	83 ec 04             	sub    $0x4,%esp
8010828b:	51                   	push   %ecx
8010828c:	52                   	push   %edx
8010828d:	50                   	push   %eax
8010828e:	e8 37 01 00 00       	call   801083ca <pci_init_device>
80108293:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
80108296:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010829a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
8010829e:	7e b5                	jle    80108255 <pci_init+0x22>
    for(int j=0;j<32;j++){
801082a0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801082a4:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801082a8:	7e a2                	jle    8010824c <pci_init+0x19>
  for(int i=0;i<256;i++){
801082aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082ae:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801082b5:	7e 8c                	jle    80108243 <pci_init+0x10>
      }
      }
    }
  }
}
801082b7:	90                   	nop
801082b8:	90                   	nop
801082b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082bc:	c9                   	leave
801082bd:	c3                   	ret

801082be <pci_write_config>:

void pci_write_config(uint config){
801082be:	55                   	push   %ebp
801082bf:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
801082c1:	8b 45 08             	mov    0x8(%ebp),%eax
801082c4:	ba f8 0c 00 00       	mov    $0xcf8,%edx
801082c9:	89 c0                	mov    %eax,%eax
801082cb:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801082cc:	90                   	nop
801082cd:	5d                   	pop    %ebp
801082ce:	c3                   	ret

801082cf <pci_write_data>:

void pci_write_data(uint config){
801082cf:	55                   	push   %ebp
801082d0:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
801082d2:	8b 45 08             	mov    0x8(%ebp),%eax
801082d5:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801082da:	89 c0                	mov    %eax,%eax
801082dc:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801082dd:	90                   	nop
801082de:	5d                   	pop    %ebp
801082df:	c3                   	ret

801082e0 <pci_read_config>:
uint pci_read_config(){
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801082e6:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801082eb:	ed                   	in     (%dx),%eax
801082ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801082ef:	83 ec 0c             	sub    $0xc,%esp
801082f2:	68 c8 00 00 00       	push   $0xc8
801082f7:	e8 3d a8 ff ff       	call   80102b39 <microdelay>
801082fc:	83 c4 10             	add    $0x10,%esp
  return data;
801082ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80108302:	c9                   	leave
80108303:	c3                   	ret

80108304 <pci_test>:


void pci_test(){
80108304:	55                   	push   %ebp
80108305:	89 e5                	mov    %esp,%ebp
80108307:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
8010830a:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
80108311:	ff 75 fc             	push   -0x4(%ebp)
80108314:	e8 a5 ff ff ff       	call   801082be <pci_write_config>
80108319:	83 c4 04             	add    $0x4,%esp
}
8010831c:	90                   	nop
8010831d:	c9                   	leave
8010831e:	c3                   	ret

8010831f <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
8010831f:	55                   	push   %ebp
80108320:	89 e5                	mov    %esp,%ebp
80108322:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108325:	8b 45 08             	mov    0x8(%ebp),%eax
80108328:	c1 e0 10             	shl    $0x10,%eax
8010832b:	25 00 00 ff 00       	and    $0xff0000,%eax
80108330:	89 c2                	mov    %eax,%edx
80108332:	8b 45 0c             	mov    0xc(%ebp),%eax
80108335:	c1 e0 0b             	shl    $0xb,%eax
80108338:	0f b7 c0             	movzwl %ax,%eax
8010833b:	09 c2                	or     %eax,%edx
8010833d:	8b 45 10             	mov    0x10(%ebp),%eax
80108340:	c1 e0 08             	shl    $0x8,%eax
80108343:	25 00 07 00 00       	and    $0x700,%eax
80108348:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
8010834a:	8b 45 14             	mov    0x14(%ebp),%eax
8010834d:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108352:	09 d0                	or     %edx,%eax
80108354:	0d 00 00 00 80       	or     $0x80000000,%eax
80108359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
8010835c:	ff 75 f4             	push   -0xc(%ebp)
8010835f:	e8 5a ff ff ff       	call   801082be <pci_write_config>
80108364:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
80108367:	e8 74 ff ff ff       	call   801082e0 <pci_read_config>
8010836c:	8b 55 18             	mov    0x18(%ebp),%edx
8010836f:	89 02                	mov    %eax,(%edx)
}
80108371:	90                   	nop
80108372:	c9                   	leave
80108373:	c3                   	ret

80108374 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108374:	55                   	push   %ebp
80108375:	89 e5                	mov    %esp,%ebp
80108377:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010837a:	8b 45 08             	mov    0x8(%ebp),%eax
8010837d:	c1 e0 10             	shl    $0x10,%eax
80108380:	25 00 00 ff 00       	and    $0xff0000,%eax
80108385:	89 c2                	mov    %eax,%edx
80108387:	8b 45 0c             	mov    0xc(%ebp),%eax
8010838a:	c1 e0 0b             	shl    $0xb,%eax
8010838d:	0f b7 c0             	movzwl %ax,%eax
80108390:	09 c2                	or     %eax,%edx
80108392:	8b 45 10             	mov    0x10(%ebp),%eax
80108395:	c1 e0 08             	shl    $0x8,%eax
80108398:	25 00 07 00 00       	and    $0x700,%eax
8010839d:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
8010839f:	8b 45 14             	mov    0x14(%ebp),%eax
801083a2:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083a7:	09 d0                	or     %edx,%eax
801083a9:	0d 00 00 00 80       	or     $0x80000000,%eax
801083ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
801083b1:	ff 75 fc             	push   -0x4(%ebp)
801083b4:	e8 05 ff ff ff       	call   801082be <pci_write_config>
801083b9:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
801083bc:	ff 75 18             	push   0x18(%ebp)
801083bf:	e8 0b ff ff ff       	call   801082cf <pci_write_data>
801083c4:	83 c4 04             	add    $0x4,%esp
}
801083c7:	90                   	nop
801083c8:	c9                   	leave
801083c9:	c3                   	ret

801083ca <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
801083ca:	55                   	push   %ebp
801083cb:	89 e5                	mov    %esp,%ebp
801083cd:	53                   	push   %ebx
801083ce:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
801083d1:	8b 45 08             	mov    0x8(%ebp),%eax
801083d4:	a2 64 6d 19 80       	mov    %al,0x80196d64
  dev.device_num = device_num;
801083d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083dc:	a2 65 6d 19 80       	mov    %al,0x80196d65
  dev.function_num = function_num;
801083e1:	8b 45 10             	mov    0x10(%ebp),%eax
801083e4:	a2 66 6d 19 80       	mov    %al,0x80196d66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801083e9:	ff 75 10             	push   0x10(%ebp)
801083ec:	ff 75 0c             	push   0xc(%ebp)
801083ef:	ff 75 08             	push   0x8(%ebp)
801083f2:	68 24 bf 10 80       	push   $0x8010bf24
801083f7:	e8 f8 7f ff ff       	call   801003f4 <cprintf>
801083fc:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801083ff:	83 ec 0c             	sub    $0xc,%esp
80108402:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108405:	50                   	push   %eax
80108406:	6a 00                	push   $0x0
80108408:	ff 75 10             	push   0x10(%ebp)
8010840b:	ff 75 0c             	push   0xc(%ebp)
8010840e:	ff 75 08             	push   0x8(%ebp)
80108411:	e8 09 ff ff ff       	call   8010831f <pci_access_config>
80108416:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
80108419:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010841c:	c1 e8 10             	shr    $0x10,%eax
8010841f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
80108422:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108425:	25 ff ff 00 00       	and    $0xffff,%eax
8010842a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
8010842d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108430:	a3 68 6d 19 80       	mov    %eax,0x80196d68
  dev.vendor_id = vendor_id;
80108435:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108438:	a3 6c 6d 19 80       	mov    %eax,0x80196d6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
8010843d:	83 ec 04             	sub    $0x4,%esp
80108440:	ff 75 f0             	push   -0x10(%ebp)
80108443:	ff 75 f4             	push   -0xc(%ebp)
80108446:	68 58 bf 10 80       	push   $0x8010bf58
8010844b:	e8 a4 7f ff ff       	call   801003f4 <cprintf>
80108450:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
80108453:	83 ec 0c             	sub    $0xc,%esp
80108456:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108459:	50                   	push   %eax
8010845a:	6a 08                	push   $0x8
8010845c:	ff 75 10             	push   0x10(%ebp)
8010845f:	ff 75 0c             	push   0xc(%ebp)
80108462:	ff 75 08             	push   0x8(%ebp)
80108465:	e8 b5 fe ff ff       	call   8010831f <pci_access_config>
8010846a:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010846d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108470:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108473:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108476:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108479:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010847c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010847f:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108482:	0f b6 c0             	movzbl %al,%eax
80108485:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108488:	c1 eb 18             	shr    $0x18,%ebx
8010848b:	83 ec 0c             	sub    $0xc,%esp
8010848e:	51                   	push   %ecx
8010848f:	52                   	push   %edx
80108490:	50                   	push   %eax
80108491:	53                   	push   %ebx
80108492:	68 7c bf 10 80       	push   $0x8010bf7c
80108497:	e8 58 7f ff ff       	call   801003f4 <cprintf>
8010849c:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
8010849f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084a2:	c1 e8 18             	shr    $0x18,%eax
801084a5:	a2 70 6d 19 80       	mov    %al,0x80196d70
  dev.sub_class = (data>>16)&0xFF;
801084aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ad:	c1 e8 10             	shr    $0x10,%eax
801084b0:	a2 71 6d 19 80       	mov    %al,0x80196d71
  dev.interface = (data>>8)&0xFF;
801084b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084b8:	c1 e8 08             	shr    $0x8,%eax
801084bb:	a2 72 6d 19 80       	mov    %al,0x80196d72
  dev.revision_id = data&0xFF;
801084c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c3:	a2 73 6d 19 80       	mov    %al,0x80196d73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
801084c8:	83 ec 0c             	sub    $0xc,%esp
801084cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084ce:	50                   	push   %eax
801084cf:	6a 10                	push   $0x10
801084d1:	ff 75 10             	push   0x10(%ebp)
801084d4:	ff 75 0c             	push   0xc(%ebp)
801084d7:	ff 75 08             	push   0x8(%ebp)
801084da:	e8 40 fe ff ff       	call   8010831f <pci_access_config>
801084df:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801084e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084e5:	a3 74 6d 19 80       	mov    %eax,0x80196d74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801084ea:	83 ec 0c             	sub    $0xc,%esp
801084ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084f0:	50                   	push   %eax
801084f1:	6a 14                	push   $0x14
801084f3:	ff 75 10             	push   0x10(%ebp)
801084f6:	ff 75 0c             	push   0xc(%ebp)
801084f9:	ff 75 08             	push   0x8(%ebp)
801084fc:	e8 1e fe ff ff       	call   8010831f <pci_access_config>
80108501:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108507:	a3 78 6d 19 80       	mov    %eax,0x80196d78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
8010850c:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
80108513:	75 5a                	jne    8010856f <pci_init_device+0x1a5>
80108515:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
8010851c:	75 51                	jne    8010856f <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
8010851e:	83 ec 0c             	sub    $0xc,%esp
80108521:	68 c1 bf 10 80       	push   $0x8010bfc1
80108526:	e8 c9 7e ff ff       	call   801003f4 <cprintf>
8010852b:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
8010852e:	83 ec 0c             	sub    $0xc,%esp
80108531:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108534:	50                   	push   %eax
80108535:	68 f0 00 00 00       	push   $0xf0
8010853a:	ff 75 10             	push   0x10(%ebp)
8010853d:	ff 75 0c             	push   0xc(%ebp)
80108540:	ff 75 08             	push   0x8(%ebp)
80108543:	e8 d7 fd ff ff       	call   8010831f <pci_access_config>
80108548:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
8010854b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010854e:	83 ec 08             	sub    $0x8,%esp
80108551:	50                   	push   %eax
80108552:	68 db bf 10 80       	push   $0x8010bfdb
80108557:	e8 98 7e ff ff       	call   801003f4 <cprintf>
8010855c:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
8010855f:	83 ec 0c             	sub    $0xc,%esp
80108562:	68 64 6d 19 80       	push   $0x80196d64
80108567:	e8 09 00 00 00       	call   80108575 <i8254_init>
8010856c:	83 c4 10             	add    $0x10,%esp
  }
}
8010856f:	90                   	nop
80108570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108573:	c9                   	leave
80108574:	c3                   	ret

80108575 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108575:	55                   	push   %ebp
80108576:	89 e5                	mov    %esp,%ebp
80108578:	53                   	push   %ebx
80108579:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
8010857c:	8b 45 08             	mov    0x8(%ebp),%eax
8010857f:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108583:	0f b6 c8             	movzbl %al,%ecx
80108586:	8b 45 08             	mov    0x8(%ebp),%eax
80108589:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010858d:	0f b6 d0             	movzbl %al,%edx
80108590:	8b 45 08             	mov    0x8(%ebp),%eax
80108593:	0f b6 00             	movzbl (%eax),%eax
80108596:	0f b6 c0             	movzbl %al,%eax
80108599:	83 ec 0c             	sub    $0xc,%esp
8010859c:	8d 5d ec             	lea    -0x14(%ebp),%ebx
8010859f:	53                   	push   %ebx
801085a0:	6a 04                	push   $0x4
801085a2:	51                   	push   %ecx
801085a3:	52                   	push   %edx
801085a4:	50                   	push   %eax
801085a5:	e8 75 fd ff ff       	call   8010831f <pci_access_config>
801085aa:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
801085ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085b0:	83 c8 04             	or     $0x4,%eax
801085b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
801085b6:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801085b9:	8b 45 08             	mov    0x8(%ebp),%eax
801085bc:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801085c0:	0f b6 c8             	movzbl %al,%ecx
801085c3:	8b 45 08             	mov    0x8(%ebp),%eax
801085c6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801085ca:	0f b6 d0             	movzbl %al,%edx
801085cd:	8b 45 08             	mov    0x8(%ebp),%eax
801085d0:	0f b6 00             	movzbl (%eax),%eax
801085d3:	0f b6 c0             	movzbl %al,%eax
801085d6:	83 ec 0c             	sub    $0xc,%esp
801085d9:	53                   	push   %ebx
801085da:	6a 04                	push   $0x4
801085dc:	51                   	push   %ecx
801085dd:	52                   	push   %edx
801085de:	50                   	push   %eax
801085df:	e8 90 fd ff ff       	call   80108374 <pci_write_config_register>
801085e4:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
801085e7:	8b 45 08             	mov    0x8(%ebp),%eax
801085ea:	8b 40 10             	mov    0x10(%eax),%eax
801085ed:	05 00 00 00 40       	add    $0x40000000,%eax
801085f2:	a3 7c 6d 19 80       	mov    %eax,0x80196d7c
  uint *ctrl = (uint *)base_addr;
801085f7:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801085fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801085ff:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108604:	05 d8 00 00 00       	add    $0xd8,%eax
80108609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
8010860c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010860f:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
80108615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108618:	8b 00                	mov    (%eax),%eax
8010861a:	0d 00 00 00 04       	or     $0x4000000,%eax
8010861f:	89 c2                	mov    %eax,%edx
80108621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108624:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
80108626:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108629:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
8010862f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108632:	8b 00                	mov    (%eax),%eax
80108634:	83 c8 40             	or     $0x40,%eax
80108637:	89 c2                	mov    %eax,%edx
80108639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010863c:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
8010863e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108641:	8b 10                	mov    (%eax),%edx
80108643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108646:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108648:	83 ec 0c             	sub    $0xc,%esp
8010864b:	68 f0 bf 10 80       	push   $0x8010bff0
80108650:	e8 9f 7d ff ff       	call   801003f4 <cprintf>
80108655:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108658:	e8 4b a1 ff ff       	call   801027a8 <kalloc>
8010865d:	a3 88 6d 19 80       	mov    %eax,0x80196d88
  *intr_addr = 0;
80108662:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
8010866d:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108672:	83 ec 08             	sub    $0x8,%esp
80108675:	50                   	push   %eax
80108676:	68 12 c0 10 80       	push   $0x8010c012
8010867b:	e8 74 7d ff ff       	call   801003f4 <cprintf>
80108680:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108683:	e8 50 00 00 00       	call   801086d8 <i8254_init_recv>
  i8254_init_send();
80108688:	e8 69 03 00 00       	call   801089f6 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
8010868d:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108694:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108697:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010869e:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
801086a1:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086a8:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
801086ab:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086b2:	0f b6 c0             	movzbl %al,%eax
801086b5:	83 ec 0c             	sub    $0xc,%esp
801086b8:	53                   	push   %ebx
801086b9:	51                   	push   %ecx
801086ba:	52                   	push   %edx
801086bb:	50                   	push   %eax
801086bc:	68 20 c0 10 80       	push   $0x8010c020
801086c1:	e8 2e 7d ff ff       	call   801003f4 <cprintf>
801086c6:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
801086c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
801086d2:	90                   	nop
801086d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086d6:	c9                   	leave
801086d7:	c3                   	ret

801086d8 <i8254_init_recv>:

void i8254_init_recv(){
801086d8:	55                   	push   %ebp
801086d9:	89 e5                	mov    %esp,%ebp
801086db:	57                   	push   %edi
801086dc:	56                   	push   %esi
801086dd:	53                   	push   %ebx
801086de:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
801086e1:	83 ec 0c             	sub    $0xc,%esp
801086e4:	6a 00                	push   $0x0
801086e6:	e8 e8 04 00 00       	call   80108bd3 <i8254_read_eeprom>
801086eb:	83 c4 10             	add    $0x10,%esp
801086ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
801086f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801086f4:	a2 80 6d 19 80       	mov    %al,0x80196d80
  mac_addr[1] = data_l>>8;
801086f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801086fc:	c1 e8 08             	shr    $0x8,%eax
801086ff:	a2 81 6d 19 80       	mov    %al,0x80196d81
  uint data_m = i8254_read_eeprom(0x1);
80108704:	83 ec 0c             	sub    $0xc,%esp
80108707:	6a 01                	push   $0x1
80108709:	e8 c5 04 00 00       	call   80108bd3 <i8254_read_eeprom>
8010870e:	83 c4 10             	add    $0x10,%esp
80108711:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108714:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108717:	a2 82 6d 19 80       	mov    %al,0x80196d82
  mac_addr[3] = data_m>>8;
8010871c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010871f:	c1 e8 08             	shr    $0x8,%eax
80108722:	a2 83 6d 19 80       	mov    %al,0x80196d83
  uint data_h = i8254_read_eeprom(0x2);
80108727:	83 ec 0c             	sub    $0xc,%esp
8010872a:	6a 02                	push   $0x2
8010872c:	e8 a2 04 00 00       	call   80108bd3 <i8254_read_eeprom>
80108731:	83 c4 10             	add    $0x10,%esp
80108734:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108737:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010873a:	a2 84 6d 19 80       	mov    %al,0x80196d84
  mac_addr[5] = data_h>>8;
8010873f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108742:	c1 e8 08             	shr    $0x8,%eax
80108745:	a2 85 6d 19 80       	mov    %al,0x80196d85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
8010874a:	0f b6 05 85 6d 19 80 	movzbl 0x80196d85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108751:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108754:	0f b6 05 84 6d 19 80 	movzbl 0x80196d84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010875b:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
8010875e:	0f b6 05 83 6d 19 80 	movzbl 0x80196d83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108765:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108768:	0f b6 05 82 6d 19 80 	movzbl 0x80196d82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010876f:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108772:	0f b6 05 81 6d 19 80 	movzbl 0x80196d81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108779:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
8010877c:	0f b6 05 80 6d 19 80 	movzbl 0x80196d80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108783:	0f b6 c0             	movzbl %al,%eax
80108786:	83 ec 04             	sub    $0x4,%esp
80108789:	57                   	push   %edi
8010878a:	56                   	push   %esi
8010878b:	53                   	push   %ebx
8010878c:	51                   	push   %ecx
8010878d:	52                   	push   %edx
8010878e:	50                   	push   %eax
8010878f:	68 38 c0 10 80       	push   $0x8010c038
80108794:	e8 5b 7c ff ff       	call   801003f4 <cprintf>
80108799:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
8010879c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087a1:	05 00 54 00 00       	add    $0x5400,%eax
801087a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
801087a9:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087ae:	05 04 54 00 00       	add    $0x5404,%eax
801087b3:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
801087b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087b9:	c1 e0 10             	shl    $0x10,%eax
801087bc:	0b 45 d8             	or     -0x28(%ebp),%eax
801087bf:	89 c2                	mov    %eax,%edx
801087c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801087c4:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
801087c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087c9:	0d 00 00 00 80       	or     $0x80000000,%eax
801087ce:	89 c2                	mov    %eax,%edx
801087d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801087d3:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
801087d5:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087da:	05 00 52 00 00       	add    $0x5200,%eax
801087df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
801087e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801087e9:	eb 19                	jmp    80108804 <i8254_init_recv+0x12c>
    mta[i] = 0;
801087eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801087ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801087f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801087f8:	01 d0                	add    %edx,%eax
801087fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108800:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108804:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108808:	7e e1                	jle    801087eb <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
8010880a:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010880f:	05 d0 00 00 00       	add    $0xd0,%eax
80108814:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108817:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010881a:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108820:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108825:	05 c8 00 00 00       	add    $0xc8,%eax
8010882a:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
8010882d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108830:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108836:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010883b:	05 28 28 00 00       	add    $0x2828,%eax
80108840:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108843:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
8010884c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108851:	05 00 01 00 00       	add    $0x100,%eax
80108856:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108859:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010885c:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108862:	e8 41 9f ff ff       	call   801027a8 <kalloc>
80108867:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
8010886a:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010886f:	05 00 28 00 00       	add    $0x2800,%eax
80108874:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108877:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010887c:	05 04 28 00 00       	add    $0x2804,%eax
80108881:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108884:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108889:	05 08 28 00 00       	add    $0x2808,%eax
8010888e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108891:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108896:	05 10 28 00 00       	add    $0x2810,%eax
8010889b:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
8010889e:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801088a3:	05 18 28 00 00       	add    $0x2818,%eax
801088a8:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
801088ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
801088ae:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801088b4:	8b 45 ac             	mov    -0x54(%ebp),%eax
801088b7:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
801088b9:	8b 45 a8             	mov    -0x58(%ebp),%eax
801088bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
801088c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801088c5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
801088cb:	8b 45 a0             	mov    -0x60(%ebp),%eax
801088ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
801088d4:	8b 45 9c             	mov    -0x64(%ebp),%eax
801088d7:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
801088dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
801088e0:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801088e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801088ea:	eb 73                	jmp    8010895f <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
801088ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088ef:	c1 e0 04             	shl    $0x4,%eax
801088f2:	89 c2                	mov    %eax,%edx
801088f4:	8b 45 98             	mov    -0x68(%ebp),%eax
801088f7:	01 d0                	add    %edx,%eax
801088f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108900:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108903:	c1 e0 04             	shl    $0x4,%eax
80108906:	89 c2                	mov    %eax,%edx
80108908:	8b 45 98             	mov    -0x68(%ebp),%eax
8010890b:	01 d0                	add    %edx,%eax
8010890d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108913:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108916:	c1 e0 04             	shl    $0x4,%eax
80108919:	89 c2                	mov    %eax,%edx
8010891b:	8b 45 98             	mov    -0x68(%ebp),%eax
8010891e:	01 d0                	add    %edx,%eax
80108920:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108926:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108929:	c1 e0 04             	shl    $0x4,%eax
8010892c:	89 c2                	mov    %eax,%edx
8010892e:	8b 45 98             	mov    -0x68(%ebp),%eax
80108931:	01 d0                	add    %edx,%eax
80108933:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108937:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010893a:	c1 e0 04             	shl    $0x4,%eax
8010893d:	89 c2                	mov    %eax,%edx
8010893f:	8b 45 98             	mov    -0x68(%ebp),%eax
80108942:	01 d0                	add    %edx,%eax
80108944:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108948:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010894b:	c1 e0 04             	shl    $0x4,%eax
8010894e:	89 c2                	mov    %eax,%edx
80108950:	8b 45 98             	mov    -0x68(%ebp),%eax
80108953:	01 d0                	add    %edx,%eax
80108955:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
8010895b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
8010895f:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108966:	7e 84                	jle    801088ec <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108968:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010896f:	eb 57                	jmp    801089c8 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108971:	e8 32 9e ff ff       	call   801027a8 <kalloc>
80108976:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108979:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
8010897d:	75 12                	jne    80108991 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
8010897f:	83 ec 0c             	sub    $0xc,%esp
80108982:	68 58 c0 10 80       	push   $0x8010c058
80108987:	e8 68 7a ff ff       	call   801003f4 <cprintf>
8010898c:	83 c4 10             	add    $0x10,%esp
      break;
8010898f:	eb 3d                	jmp    801089ce <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108991:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108994:	c1 e0 04             	shl    $0x4,%eax
80108997:	89 c2                	mov    %eax,%edx
80108999:	8b 45 98             	mov    -0x68(%ebp),%eax
8010899c:	01 d0                	add    %edx,%eax
8010899e:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089a1:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801089a7:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
801089a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089ac:	83 c0 01             	add    $0x1,%eax
801089af:	c1 e0 04             	shl    $0x4,%eax
801089b2:	89 c2                	mov    %eax,%edx
801089b4:	8b 45 98             	mov    -0x68(%ebp),%eax
801089b7:	01 d0                	add    %edx,%eax
801089b9:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089bc:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
801089c2:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
801089c4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801089c8:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
801089cc:	7e a3                	jle    80108971 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
801089ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801089d1:	8b 00                	mov    (%eax),%eax
801089d3:	83 c8 02             	or     $0x2,%eax
801089d6:	89 c2                	mov    %eax,%edx
801089d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801089db:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
801089dd:	83 ec 0c             	sub    $0xc,%esp
801089e0:	68 78 c0 10 80       	push   $0x8010c078
801089e5:	e8 0a 7a ff ff       	call   801003f4 <cprintf>
801089ea:	83 c4 10             	add    $0x10,%esp
}
801089ed:	90                   	nop
801089ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089f1:	5b                   	pop    %ebx
801089f2:	5e                   	pop    %esi
801089f3:	5f                   	pop    %edi
801089f4:	5d                   	pop    %ebp
801089f5:	c3                   	ret

801089f6 <i8254_init_send>:

void i8254_init_send(){
801089f6:	55                   	push   %ebp
801089f7:	89 e5                	mov    %esp,%ebp
801089f9:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
801089fc:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a01:	05 28 38 00 00       	add    $0x3828,%eax
80108a06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a0c:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108a12:	e8 91 9d ff ff       	call   801027a8 <kalloc>
80108a17:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108a1a:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a1f:	05 00 38 00 00       	add    $0x3800,%eax
80108a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108a27:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a2c:	05 04 38 00 00       	add    $0x3804,%eax
80108a31:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108a34:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a39:	05 08 38 00 00       	add    $0x3808,%eax
80108a3e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a44:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a4d:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a5b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108a61:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a66:	05 10 38 00 00       	add    $0x3810,%eax
80108a6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108a6e:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a73:	05 18 38 00 00       	add    $0x3818,%eax
80108a78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108a7b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108a7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108a84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108a87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a90:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a9a:	e9 82 00 00 00       	jmp    80108b21 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa2:	c1 e0 04             	shl    $0x4,%eax
80108aa5:	89 c2                	mov    %eax,%edx
80108aa7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108aaa:	01 d0                	add    %edx,%eax
80108aac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ab6:	c1 e0 04             	shl    $0x4,%eax
80108ab9:	89 c2                	mov    %eax,%edx
80108abb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108abe:	01 d0                	add    %edx,%eax
80108ac0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac9:	c1 e0 04             	shl    $0x4,%eax
80108acc:	89 c2                	mov    %eax,%edx
80108ace:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ad1:	01 d0                	add    %edx,%eax
80108ad3:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ada:	c1 e0 04             	shl    $0x4,%eax
80108add:	89 c2                	mov    %eax,%edx
80108adf:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ae2:	01 d0                	add    %edx,%eax
80108ae4:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aeb:	c1 e0 04             	shl    $0x4,%eax
80108aee:	89 c2                	mov    %eax,%edx
80108af0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108af3:	01 d0                	add    %edx,%eax
80108af5:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afc:	c1 e0 04             	shl    $0x4,%eax
80108aff:	89 c2                	mov    %eax,%edx
80108b01:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b04:	01 d0                	add    %edx,%eax
80108b06:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0d:	c1 e0 04             	shl    $0x4,%eax
80108b10:	89 c2                	mov    %eax,%edx
80108b12:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b15:	01 d0                	add    %edx,%eax
80108b17:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b1d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b21:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108b28:	0f 8e 71 ff ff ff    	jle    80108a9f <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108b2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108b35:	eb 57                	jmp    80108b8e <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108b37:	e8 6c 9c ff ff       	call   801027a8 <kalloc>
80108b3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108b3f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108b43:	75 12                	jne    80108b57 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108b45:	83 ec 0c             	sub    $0xc,%esp
80108b48:	68 58 c0 10 80       	push   $0x8010c058
80108b4d:	e8 a2 78 ff ff       	call   801003f4 <cprintf>
80108b52:	83 c4 10             	add    $0x10,%esp
      break;
80108b55:	eb 3d                	jmp    80108b94 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b5a:	c1 e0 04             	shl    $0x4,%eax
80108b5d:	89 c2                	mov    %eax,%edx
80108b5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b62:	01 d0                	add    %edx,%eax
80108b64:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108b67:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108b6d:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b72:	83 c0 01             	add    $0x1,%eax
80108b75:	c1 e0 04             	shl    $0x4,%eax
80108b78:	89 c2                	mov    %eax,%edx
80108b7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b7d:	01 d0                	add    %edx,%eax
80108b7f:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108b82:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108b88:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108b8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108b8e:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108b92:	7e a3                	jle    80108b37 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108b94:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108b99:	05 00 04 00 00       	add    $0x400,%eax
80108b9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108ba1:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108ba4:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108baa:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108baf:	05 10 04 00 00       	add    $0x410,%eax
80108bb4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108bb7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108bba:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108bc0:	83 ec 0c             	sub    $0xc,%esp
80108bc3:	68 98 c0 10 80       	push   $0x8010c098
80108bc8:	e8 27 78 ff ff       	call   801003f4 <cprintf>
80108bcd:	83 c4 10             	add    $0x10,%esp

}
80108bd0:	90                   	nop
80108bd1:	c9                   	leave
80108bd2:	c3                   	ret

80108bd3 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108bd3:	55                   	push   %ebp
80108bd4:	89 e5                	mov    %esp,%ebp
80108bd6:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108bd9:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108bde:	83 c0 14             	add    $0x14,%eax
80108be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108be4:	8b 45 08             	mov    0x8(%ebp),%eax
80108be7:	c1 e0 08             	shl    $0x8,%eax
80108bea:	0f b7 c0             	movzwl %ax,%eax
80108bed:	83 c8 01             	or     $0x1,%eax
80108bf0:	89 c2                	mov    %eax,%edx
80108bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf5:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108bf7:	83 ec 0c             	sub    $0xc,%esp
80108bfa:	68 b8 c0 10 80       	push   $0x8010c0b8
80108bff:	e8 f0 77 ff ff       	call   801003f4 <cprintf>
80108c04:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c0a:	8b 00                	mov    (%eax),%eax
80108c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c12:	83 e0 10             	and    $0x10,%eax
80108c15:	85 c0                	test   %eax,%eax
80108c17:	75 02                	jne    80108c1b <i8254_read_eeprom+0x48>
  while(1){
80108c19:	eb dc                	jmp    80108bf7 <i8254_read_eeprom+0x24>
      break;
80108c1b:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c1f:	8b 00                	mov    (%eax),%eax
80108c21:	c1 e8 10             	shr    $0x10,%eax
}
80108c24:	c9                   	leave
80108c25:	c3                   	ret

80108c26 <i8254_recv>:
void i8254_recv(){
80108c26:	55                   	push   %ebp
80108c27:	89 e5                	mov    %esp,%ebp
80108c29:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108c2c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c31:	05 10 28 00 00       	add    $0x2810,%eax
80108c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108c39:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c3e:	05 18 28 00 00       	add    $0x2818,%eax
80108c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108c46:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c4b:	05 00 28 00 00       	add    $0x2800,%eax
80108c50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c56:	8b 00                	mov    (%eax),%eax
80108c58:	05 00 00 00 80       	add    $0x80000000,%eax
80108c5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c63:	8b 10                	mov    (%eax),%edx
80108c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c68:	8b 00                	mov    (%eax),%eax
80108c6a:	29 c2                	sub    %eax,%edx
80108c6c:	89 d0                	mov    %edx,%eax
80108c6e:	25 ff 00 00 00       	and    $0xff,%eax
80108c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108c76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108c7a:	7e 37                	jle    80108cb3 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c7f:	8b 00                	mov    (%eax),%eax
80108c81:	c1 e0 04             	shl    $0x4,%eax
80108c84:	89 c2                	mov    %eax,%edx
80108c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c89:	01 d0                	add    %edx,%eax
80108c8b:	8b 00                	mov    (%eax),%eax
80108c8d:	05 00 00 00 80       	add    $0x80000000,%eax
80108c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c98:	8b 00                	mov    (%eax),%eax
80108c9a:	83 c0 01             	add    $0x1,%eax
80108c9d:	0f b6 d0             	movzbl %al,%edx
80108ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ca3:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108ca5:	83 ec 0c             	sub    $0xc,%esp
80108ca8:	ff 75 e0             	push   -0x20(%ebp)
80108cab:	e8 13 09 00 00       	call   801095c3 <eth_proc>
80108cb0:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cb6:	8b 10                	mov    (%eax),%edx
80108cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cbb:	8b 00                	mov    (%eax),%eax
80108cbd:	39 c2                	cmp    %eax,%edx
80108cbf:	75 9f                	jne    80108c60 <i8254_recv+0x3a>
      (*rdt)--;
80108cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc4:	8b 00                	mov    (%eax),%eax
80108cc6:	8d 50 ff             	lea    -0x1(%eax),%edx
80108cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ccc:	89 10                	mov    %edx,(%eax)
  while(1){
80108cce:	eb 90                	jmp    80108c60 <i8254_recv+0x3a>

80108cd0 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108cd0:	55                   	push   %ebp
80108cd1:	89 e5                	mov    %esp,%ebp
80108cd3:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108cd6:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108cdb:	05 10 38 00 00       	add    $0x3810,%eax
80108ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108ce3:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108ce8:	05 18 38 00 00       	add    $0x3818,%eax
80108ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108cf0:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108cf5:	05 00 38 00 00       	add    $0x3800,%eax
80108cfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d00:	8b 00                	mov    (%eax),%eax
80108d02:	05 00 00 00 80       	add    $0x80000000,%eax
80108d07:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d0d:	8b 10                	mov    (%eax),%edx
80108d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d12:	8b 00                	mov    (%eax),%eax
80108d14:	29 c2                	sub    %eax,%edx
80108d16:	0f b6 c2             	movzbl %dl,%eax
80108d19:	ba 00 01 00 00       	mov    $0x100,%edx
80108d1e:	29 c2                	sub    %eax,%edx
80108d20:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d26:	8b 00                	mov    (%eax),%eax
80108d28:	25 ff 00 00 00       	and    $0xff,%eax
80108d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108d30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d34:	0f 8e a8 00 00 00    	jle    80108de2 <i8254_send+0x112>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80108d3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108d40:	89 d1                	mov    %edx,%ecx
80108d42:	c1 e1 04             	shl    $0x4,%ecx
80108d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108d48:	01 ca                	add    %ecx,%edx
80108d4a:	8b 12                	mov    (%edx),%edx
80108d4c:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108d52:	83 ec 04             	sub    $0x4,%esp
80108d55:	ff 75 0c             	push   0xc(%ebp)
80108d58:	50                   	push   %eax
80108d59:	52                   	push   %edx
80108d5a:	e8 1e bf ff ff       	call   80104c7d <memmove>
80108d5f:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d65:	c1 e0 04             	shl    $0x4,%eax
80108d68:	89 c2                	mov    %eax,%edx
80108d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d6d:	01 d0                	add    %edx,%eax
80108d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d72:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d79:	c1 e0 04             	shl    $0x4,%eax
80108d7c:	89 c2                	mov    %eax,%edx
80108d7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d81:	01 d0                	add    %edx,%eax
80108d83:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108d87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d8a:	c1 e0 04             	shl    $0x4,%eax
80108d8d:	89 c2                	mov    %eax,%edx
80108d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d92:	01 d0                	add    %edx,%eax
80108d94:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d9b:	c1 e0 04             	shl    $0x4,%eax
80108d9e:	89 c2                	mov    %eax,%edx
80108da0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108da3:	01 d0                	add    %edx,%eax
80108da5:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108da9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dac:	c1 e0 04             	shl    $0x4,%eax
80108daf:	89 c2                	mov    %eax,%edx
80108db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108db4:	01 d0                	add    %edx,%eax
80108db6:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dbf:	c1 e0 04             	shl    $0x4,%eax
80108dc2:	89 c2                	mov    %eax,%edx
80108dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dc7:	01 d0                	add    %edx,%eax
80108dc9:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dd0:	8b 00                	mov    (%eax),%eax
80108dd2:	83 c0 01             	add    $0x1,%eax
80108dd5:	0f b6 d0             	movzbl %al,%edx
80108dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ddb:	89 10                	mov    %edx,(%eax)
    return len;
80108ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108de0:	eb 05                	jmp    80108de7 <i8254_send+0x117>
  }else{
    return -1;
80108de2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108de7:	c9                   	leave
80108de8:	c3                   	ret

80108de9 <i8254_intr>:

void i8254_intr(){
80108de9:	55                   	push   %ebp
80108dea:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108dec:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108df1:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108df7:	90                   	nop
80108df8:	5d                   	pop    %ebp
80108df9:	c3                   	ret

80108dfa <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108dfa:	55                   	push   %ebp
80108dfb:	89 e5                	mov    %esp,%ebp
80108dfd:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108e00:	8b 45 08             	mov    0x8(%ebp),%eax
80108e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e09:	0f b7 00             	movzwl (%eax),%eax
80108e0c:	66 3d 00 01          	cmp    $0x100,%ax
80108e10:	74 0a                	je     80108e1c <arp_proc+0x22>
80108e12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e17:	e9 4f 01 00 00       	jmp    80108f6b <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e1f:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108e23:	66 83 f8 08          	cmp    $0x8,%ax
80108e27:	74 0a                	je     80108e33 <arp_proc+0x39>
80108e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e2e:	e9 38 01 00 00       	jmp    80108f6b <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e36:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108e3a:	3c 06                	cmp    $0x6,%al
80108e3c:	74 0a                	je     80108e48 <arp_proc+0x4e>
80108e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e43:	e9 23 01 00 00       	jmp    80108f6b <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e4b:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108e4f:	3c 04                	cmp    $0x4,%al
80108e51:	74 0a                	je     80108e5d <arp_proc+0x63>
80108e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e58:	e9 0e 01 00 00       	jmp    80108f6b <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e60:	83 c0 18             	add    $0x18,%eax
80108e63:	83 ec 04             	sub    $0x4,%esp
80108e66:	6a 04                	push   $0x4
80108e68:	50                   	push   %eax
80108e69:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e6e:	e8 b2 bd ff ff       	call   80104c25 <memcmp>
80108e73:	83 c4 10             	add    $0x10,%esp
80108e76:	85 c0                	test   %eax,%eax
80108e78:	74 27                	je     80108ea1 <arp_proc+0xa7>
80108e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e7d:	83 c0 0e             	add    $0xe,%eax
80108e80:	83 ec 04             	sub    $0x4,%esp
80108e83:	6a 04                	push   $0x4
80108e85:	50                   	push   %eax
80108e86:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e8b:	e8 95 bd ff ff       	call   80104c25 <memcmp>
80108e90:	83 c4 10             	add    $0x10,%esp
80108e93:	85 c0                	test   %eax,%eax
80108e95:	74 0a                	je     80108ea1 <arp_proc+0xa7>
80108e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e9c:	e9 ca 00 00 00       	jmp    80108f6b <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108ea8:	66 3d 00 01          	cmp    $0x100,%ax
80108eac:	75 69                	jne    80108f17 <arp_proc+0x11d>
80108eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb1:	83 c0 18             	add    $0x18,%eax
80108eb4:	83 ec 04             	sub    $0x4,%esp
80108eb7:	6a 04                	push   $0x4
80108eb9:	50                   	push   %eax
80108eba:	68 e4 f4 10 80       	push   $0x8010f4e4
80108ebf:	e8 61 bd ff ff       	call   80104c25 <memcmp>
80108ec4:	83 c4 10             	add    $0x10,%esp
80108ec7:	85 c0                	test   %eax,%eax
80108ec9:	75 4c                	jne    80108f17 <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108ecb:	e8 d8 98 ff ff       	call   801027a8 <kalloc>
80108ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108ed3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108eda:	83 ec 04             	sub    $0x4,%esp
80108edd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108ee0:	50                   	push   %eax
80108ee1:	ff 75 f0             	push   -0x10(%ebp)
80108ee4:	ff 75 f4             	push   -0xc(%ebp)
80108ee7:	e8 1f 04 00 00       	call   8010930b <arp_reply_pkt_create>
80108eec:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ef2:	83 ec 08             	sub    $0x8,%esp
80108ef5:	50                   	push   %eax
80108ef6:	ff 75 f0             	push   -0x10(%ebp)
80108ef9:	e8 d2 fd ff ff       	call   80108cd0 <i8254_send>
80108efe:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f04:	83 ec 0c             	sub    $0xc,%esp
80108f07:	50                   	push   %eax
80108f08:	e8 01 98 ff ff       	call   8010270e <kfree>
80108f0d:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108f10:	b8 02 00 00 00       	mov    $0x2,%eax
80108f15:	eb 54                	jmp    80108f6b <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f1a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f1e:	66 3d 00 02          	cmp    $0x200,%ax
80108f22:	75 42                	jne    80108f66 <arp_proc+0x16c>
80108f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f27:	83 c0 18             	add    $0x18,%eax
80108f2a:	83 ec 04             	sub    $0x4,%esp
80108f2d:	6a 04                	push   $0x4
80108f2f:	50                   	push   %eax
80108f30:	68 e4 f4 10 80       	push   $0x8010f4e4
80108f35:	e8 eb bc ff ff       	call   80104c25 <memcmp>
80108f3a:	83 c4 10             	add    $0x10,%esp
80108f3d:	85 c0                	test   %eax,%eax
80108f3f:	75 25                	jne    80108f66 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108f41:	83 ec 0c             	sub    $0xc,%esp
80108f44:	68 bc c0 10 80       	push   $0x8010c0bc
80108f49:	e8 a6 74 ff ff       	call   801003f4 <cprintf>
80108f4e:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108f51:	83 ec 0c             	sub    $0xc,%esp
80108f54:	ff 75 f4             	push   -0xc(%ebp)
80108f57:	e8 af 01 00 00       	call   8010910b <arp_table_update>
80108f5c:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80108f5f:	b8 01 00 00 00       	mov    $0x1,%eax
80108f64:	eb 05                	jmp    80108f6b <arp_proc+0x171>
  }else{
    return -1;
80108f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80108f6b:	c9                   	leave
80108f6c:	c3                   	ret

80108f6d <arp_scan>:

void arp_scan(){
80108f6d:	55                   	push   %ebp
80108f6e:	89 e5                	mov    %esp,%ebp
80108f70:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80108f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108f7a:	eb 6f                	jmp    80108feb <arp_scan+0x7e>
    uint send = (uint)kalloc();
80108f7c:	e8 27 98 ff ff       	call   801027a8 <kalloc>
80108f81:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80108f84:	83 ec 04             	sub    $0x4,%esp
80108f87:	ff 75 f4             	push   -0xc(%ebp)
80108f8a:	8d 45 e8             	lea    -0x18(%ebp),%eax
80108f8d:	50                   	push   %eax
80108f8e:	ff 75 ec             	push   -0x14(%ebp)
80108f91:	e8 62 00 00 00       	call   80108ff8 <arp_broadcast>
80108f96:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80108f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f9c:	83 ec 08             	sub    $0x8,%esp
80108f9f:	50                   	push   %eax
80108fa0:	ff 75 ec             	push   -0x14(%ebp)
80108fa3:	e8 28 fd ff ff       	call   80108cd0 <i8254_send>
80108fa8:	83 c4 10             	add    $0x10,%esp
80108fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108fae:	eb 22                	jmp    80108fd2 <arp_scan+0x65>
      microdelay(1);
80108fb0:	83 ec 0c             	sub    $0xc,%esp
80108fb3:	6a 01                	push   $0x1
80108fb5:	e8 7f 9b ff ff       	call   80102b39 <microdelay>
80108fba:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80108fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fc0:	83 ec 08             	sub    $0x8,%esp
80108fc3:	50                   	push   %eax
80108fc4:	ff 75 ec             	push   -0x14(%ebp)
80108fc7:	e8 04 fd ff ff       	call   80108cd0 <i8254_send>
80108fcc:	83 c4 10             	add    $0x10,%esp
80108fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108fd2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80108fd6:	74 d8                	je     80108fb0 <arp_scan+0x43>
    }
    kfree((char *)send);
80108fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fdb:	83 ec 0c             	sub    $0xc,%esp
80108fde:	50                   	push   %eax
80108fdf:	e8 2a 97 ff ff       	call   8010270e <kfree>
80108fe4:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
80108fe7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108feb:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108ff2:	7e 88                	jle    80108f7c <arp_scan+0xf>
  }
}
80108ff4:	90                   	nop
80108ff5:	90                   	nop
80108ff6:	c9                   	leave
80108ff7:	c3                   	ret

80108ff8 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
80108ff8:	55                   	push   %ebp
80108ff9:	89 e5                	mov    %esp,%ebp
80108ffb:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
80108ffe:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80109002:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80109006:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
8010900a:	8b 45 10             	mov    0x10(%ebp),%eax
8010900d:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
80109010:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
80109017:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
8010901d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80109024:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
8010902a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010902d:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109033:	8b 45 08             	mov    0x8(%ebp),%eax
80109036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109039:	8b 45 08             	mov    0x8(%ebp),%eax
8010903c:	83 c0 0e             	add    $0xe,%eax
8010903f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
80109042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109045:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010904c:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
80109050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109053:	83 ec 04             	sub    $0x4,%esp
80109056:	6a 06                	push   $0x6
80109058:	8d 55 e6             	lea    -0x1a(%ebp),%edx
8010905b:	52                   	push   %edx
8010905c:	50                   	push   %eax
8010905d:	e8 1b bc ff ff       	call   80104c7d <memmove>
80109062:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109068:	83 c0 06             	add    $0x6,%eax
8010906b:	83 ec 04             	sub    $0x4,%esp
8010906e:	6a 06                	push   $0x6
80109070:	68 80 6d 19 80       	push   $0x80196d80
80109075:	50                   	push   %eax
80109076:	e8 02 bc ff ff       	call   80104c7d <memmove>
8010907b:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
8010907e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109081:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109089:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010908f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109092:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109096:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109099:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
8010909d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090a0:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
801090a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090a9:	8d 50 12             	lea    0x12(%eax),%edx
801090ac:	83 ec 04             	sub    $0x4,%esp
801090af:	6a 06                	push   $0x6
801090b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801090b4:	50                   	push   %eax
801090b5:	52                   	push   %edx
801090b6:	e8 c2 bb ff ff       	call   80104c7d <memmove>
801090bb:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
801090be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090c1:	8d 50 18             	lea    0x18(%eax),%edx
801090c4:	83 ec 04             	sub    $0x4,%esp
801090c7:	6a 04                	push   $0x4
801090c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801090cc:	50                   	push   %eax
801090cd:	52                   	push   %edx
801090ce:	e8 aa bb ff ff       	call   80104c7d <memmove>
801090d3:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801090d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d9:	83 c0 08             	add    $0x8,%eax
801090dc:	83 ec 04             	sub    $0x4,%esp
801090df:	6a 06                	push   $0x6
801090e1:	68 80 6d 19 80       	push   $0x80196d80
801090e6:	50                   	push   %eax
801090e7:	e8 91 bb ff ff       	call   80104c7d <memmove>
801090ec:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801090ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090f2:	83 c0 0e             	add    $0xe,%eax
801090f5:	83 ec 04             	sub    $0x4,%esp
801090f8:	6a 04                	push   $0x4
801090fa:	68 e4 f4 10 80       	push   $0x8010f4e4
801090ff:	50                   	push   %eax
80109100:	e8 78 bb ff ff       	call   80104c7d <memmove>
80109105:	83 c4 10             	add    $0x10,%esp
}
80109108:	90                   	nop
80109109:	c9                   	leave
8010910a:	c3                   	ret

8010910b <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
8010910b:	55                   	push   %ebp
8010910c:	89 e5                	mov    %esp,%ebp
8010910e:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
80109111:	8b 45 08             	mov    0x8(%ebp),%eax
80109114:	83 c0 0e             	add    $0xe,%eax
80109117:	83 ec 0c             	sub    $0xc,%esp
8010911a:	50                   	push   %eax
8010911b:	e8 bc 00 00 00       	call   801091dc <arp_table_search>
80109120:	83 c4 10             	add    $0x10,%esp
80109123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
80109126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010912a:	78 2d                	js     80109159 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010912c:	8b 45 08             	mov    0x8(%ebp),%eax
8010912f:	8d 48 08             	lea    0x8(%eax),%ecx
80109132:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109135:	89 d0                	mov    %edx,%eax
80109137:	c1 e0 02             	shl    $0x2,%eax
8010913a:	01 d0                	add    %edx,%eax
8010913c:	01 c0                	add    %eax,%eax
8010913e:	01 d0                	add    %edx,%eax
80109140:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109145:	83 c0 04             	add    $0x4,%eax
80109148:	83 ec 04             	sub    $0x4,%esp
8010914b:	6a 06                	push   $0x6
8010914d:	51                   	push   %ecx
8010914e:	50                   	push   %eax
8010914f:	e8 29 bb ff ff       	call   80104c7d <memmove>
80109154:	83 c4 10             	add    $0x10,%esp
80109157:	eb 70                	jmp    801091c9 <arp_table_update+0xbe>
  }else{
    index += 1;
80109159:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
8010915d:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109160:	8b 45 08             	mov    0x8(%ebp),%eax
80109163:	8d 48 08             	lea    0x8(%eax),%ecx
80109166:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109169:	89 d0                	mov    %edx,%eax
8010916b:	c1 e0 02             	shl    $0x2,%eax
8010916e:	01 d0                	add    %edx,%eax
80109170:	01 c0                	add    %eax,%eax
80109172:	01 d0                	add    %edx,%eax
80109174:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109179:	83 c0 04             	add    $0x4,%eax
8010917c:	83 ec 04             	sub    $0x4,%esp
8010917f:	6a 06                	push   $0x6
80109181:	51                   	push   %ecx
80109182:	50                   	push   %eax
80109183:	e8 f5 ba ff ff       	call   80104c7d <memmove>
80109188:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
8010918b:	8b 45 08             	mov    0x8(%ebp),%eax
8010918e:	8d 48 0e             	lea    0xe(%eax),%ecx
80109191:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109194:	89 d0                	mov    %edx,%eax
80109196:	c1 e0 02             	shl    $0x2,%eax
80109199:	01 d0                	add    %edx,%eax
8010919b:	01 c0                	add    %eax,%eax
8010919d:	01 d0                	add    %edx,%eax
8010919f:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801091a4:	83 ec 04             	sub    $0x4,%esp
801091a7:	6a 04                	push   $0x4
801091a9:	51                   	push   %ecx
801091aa:	50                   	push   %eax
801091ab:	e8 cd ba ff ff       	call   80104c7d <memmove>
801091b0:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
801091b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091b6:	89 d0                	mov    %edx,%eax
801091b8:	c1 e0 02             	shl    $0x2,%eax
801091bb:	01 d0                	add    %edx,%eax
801091bd:	01 c0                	add    %eax,%eax
801091bf:	01 d0                	add    %edx,%eax
801091c1:	05 aa 6d 19 80       	add    $0x80196daa,%eax
801091c6:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
801091c9:	83 ec 0c             	sub    $0xc,%esp
801091cc:	68 a0 6d 19 80       	push   $0x80196da0
801091d1:	e8 83 00 00 00       	call   80109259 <print_arp_table>
801091d6:	83 c4 10             	add    $0x10,%esp
}
801091d9:	90                   	nop
801091da:	c9                   	leave
801091db:	c3                   	ret

801091dc <arp_table_search>:

int arp_table_search(uchar *ip){
801091dc:	55                   	push   %ebp
801091dd:	89 e5                	mov    %esp,%ebp
801091df:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801091e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801091e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801091f0:	eb 59                	jmp    8010924b <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801091f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801091f5:	89 d0                	mov    %edx,%eax
801091f7:	c1 e0 02             	shl    $0x2,%eax
801091fa:	01 d0                	add    %edx,%eax
801091fc:	01 c0                	add    %eax,%eax
801091fe:	01 d0                	add    %edx,%eax
80109200:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109205:	83 ec 04             	sub    $0x4,%esp
80109208:	6a 04                	push   $0x4
8010920a:	ff 75 08             	push   0x8(%ebp)
8010920d:	50                   	push   %eax
8010920e:	e8 12 ba ff ff       	call   80104c25 <memcmp>
80109213:	83 c4 10             	add    $0x10,%esp
80109216:	85 c0                	test   %eax,%eax
80109218:	75 05                	jne    8010921f <arp_table_search+0x43>
      return i;
8010921a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010921d:	eb 38                	jmp    80109257 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
8010921f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109222:	89 d0                	mov    %edx,%eax
80109224:	c1 e0 02             	shl    $0x2,%eax
80109227:	01 d0                	add    %edx,%eax
80109229:	01 c0                	add    %eax,%eax
8010922b:	01 d0                	add    %edx,%eax
8010922d:	05 aa 6d 19 80       	add    $0x80196daa,%eax
80109232:	0f b6 00             	movzbl (%eax),%eax
80109235:	84 c0                	test   %al,%al
80109237:	75 0e                	jne    80109247 <arp_table_search+0x6b>
80109239:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010923d:	75 08                	jne    80109247 <arp_table_search+0x6b>
      empty = -i;
8010923f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109242:	f7 d8                	neg    %eax
80109244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109247:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010924b:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010924f:	7e a1                	jle    801091f2 <arp_table_search+0x16>
    }
  }
  return empty-1;
80109251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109254:	83 e8 01             	sub    $0x1,%eax
}
80109257:	c9                   	leave
80109258:	c3                   	ret

80109259 <print_arp_table>:

void print_arp_table(){
80109259:	55                   	push   %ebp
8010925a:	89 e5                	mov    %esp,%ebp
8010925c:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010925f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109266:	e9 92 00 00 00       	jmp    801092fd <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
8010926b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010926e:	89 d0                	mov    %edx,%eax
80109270:	c1 e0 02             	shl    $0x2,%eax
80109273:	01 d0                	add    %edx,%eax
80109275:	01 c0                	add    %eax,%eax
80109277:	01 d0                	add    %edx,%eax
80109279:	05 aa 6d 19 80       	add    $0x80196daa,%eax
8010927e:	0f b6 00             	movzbl (%eax),%eax
80109281:	84 c0                	test   %al,%al
80109283:	74 74                	je     801092f9 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109285:	83 ec 08             	sub    $0x8,%esp
80109288:	ff 75 f4             	push   -0xc(%ebp)
8010928b:	68 cf c0 10 80       	push   $0x8010c0cf
80109290:	e8 5f 71 ff ff       	call   801003f4 <cprintf>
80109295:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109298:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010929b:	89 d0                	mov    %edx,%eax
8010929d:	c1 e0 02             	shl    $0x2,%eax
801092a0:	01 d0                	add    %edx,%eax
801092a2:	01 c0                	add    %eax,%eax
801092a4:	01 d0                	add    %edx,%eax
801092a6:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801092ab:	83 ec 0c             	sub    $0xc,%esp
801092ae:	50                   	push   %eax
801092af:	e8 54 02 00 00       	call   80109508 <print_ipv4>
801092b4:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
801092b7:	83 ec 0c             	sub    $0xc,%esp
801092ba:	68 de c0 10 80       	push   $0x8010c0de
801092bf:	e8 30 71 ff ff       	call   801003f4 <cprintf>
801092c4:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
801092c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092ca:	89 d0                	mov    %edx,%eax
801092cc:	c1 e0 02             	shl    $0x2,%eax
801092cf:	01 d0                	add    %edx,%eax
801092d1:	01 c0                	add    %eax,%eax
801092d3:	01 d0                	add    %edx,%eax
801092d5:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801092da:	83 c0 04             	add    $0x4,%eax
801092dd:	83 ec 0c             	sub    $0xc,%esp
801092e0:	50                   	push   %eax
801092e1:	e8 70 02 00 00       	call   80109556 <print_mac>
801092e6:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801092e9:	83 ec 0c             	sub    $0xc,%esp
801092ec:	68 e0 c0 10 80       	push   $0x8010c0e0
801092f1:	e8 fe 70 ff ff       	call   801003f4 <cprintf>
801092f6:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801092f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801092fd:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80109301:	0f 8e 64 ff ff ff    	jle    8010926b <print_arp_table+0x12>
    }
  }
}
80109307:	90                   	nop
80109308:	90                   	nop
80109309:	c9                   	leave
8010930a:	c3                   	ret

8010930b <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
8010930b:	55                   	push   %ebp
8010930c:	89 e5                	mov    %esp,%ebp
8010930e:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109311:	8b 45 10             	mov    0x10(%ebp),%eax
80109314:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
8010931a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010931d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109320:	8b 45 0c             	mov    0xc(%ebp),%eax
80109323:	83 c0 0e             	add    $0xe,%eax
80109326:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
80109329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010932c:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109333:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
80109337:	8b 45 08             	mov    0x8(%ebp),%eax
8010933a:	8d 50 08             	lea    0x8(%eax),%edx
8010933d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109340:	83 ec 04             	sub    $0x4,%esp
80109343:	6a 06                	push   $0x6
80109345:	52                   	push   %edx
80109346:	50                   	push   %eax
80109347:	e8 31 b9 ff ff       	call   80104c7d <memmove>
8010934c:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010934f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109352:	83 c0 06             	add    $0x6,%eax
80109355:	83 ec 04             	sub    $0x4,%esp
80109358:	6a 06                	push   $0x6
8010935a:	68 80 6d 19 80       	push   $0x80196d80
8010935f:	50                   	push   %eax
80109360:	e8 18 b9 ff ff       	call   80104c7d <memmove>
80109365:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010936b:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109370:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109373:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109379:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010937c:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109383:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010938a:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109390:	8b 45 08             	mov    0x8(%ebp),%eax
80109393:	8d 50 08             	lea    0x8(%eax),%edx
80109396:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109399:	83 c0 12             	add    $0x12,%eax
8010939c:	83 ec 04             	sub    $0x4,%esp
8010939f:	6a 06                	push   $0x6
801093a1:	52                   	push   %edx
801093a2:	50                   	push   %eax
801093a3:	e8 d5 b8 ff ff       	call   80104c7d <memmove>
801093a8:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
801093ab:	8b 45 08             	mov    0x8(%ebp),%eax
801093ae:	8d 50 0e             	lea    0xe(%eax),%edx
801093b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093b4:	83 c0 18             	add    $0x18,%eax
801093b7:	83 ec 04             	sub    $0x4,%esp
801093ba:	6a 04                	push   $0x4
801093bc:	52                   	push   %edx
801093bd:	50                   	push   %eax
801093be:	e8 ba b8 ff ff       	call   80104c7d <memmove>
801093c3:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801093c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093c9:	83 c0 08             	add    $0x8,%eax
801093cc:	83 ec 04             	sub    $0x4,%esp
801093cf:	6a 06                	push   $0x6
801093d1:	68 80 6d 19 80       	push   $0x80196d80
801093d6:	50                   	push   %eax
801093d7:	e8 a1 b8 ff ff       	call   80104c7d <memmove>
801093dc:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801093df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093e2:	83 c0 0e             	add    $0xe,%eax
801093e5:	83 ec 04             	sub    $0x4,%esp
801093e8:	6a 04                	push   $0x4
801093ea:	68 e4 f4 10 80       	push   $0x8010f4e4
801093ef:	50                   	push   %eax
801093f0:	e8 88 b8 ff ff       	call   80104c7d <memmove>
801093f5:	83 c4 10             	add    $0x10,%esp
}
801093f8:	90                   	nop
801093f9:	c9                   	leave
801093fa:	c3                   	ret

801093fb <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801093fb:	55                   	push   %ebp
801093fc:	89 e5                	mov    %esp,%ebp
801093fe:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
80109401:	83 ec 0c             	sub    $0xc,%esp
80109404:	68 e2 c0 10 80       	push   $0x8010c0e2
80109409:	e8 e6 6f ff ff       	call   801003f4 <cprintf>
8010940e:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
80109411:	8b 45 08             	mov    0x8(%ebp),%eax
80109414:	83 c0 0e             	add    $0xe,%eax
80109417:	83 ec 0c             	sub    $0xc,%esp
8010941a:	50                   	push   %eax
8010941b:	e8 e8 00 00 00       	call   80109508 <print_ipv4>
80109420:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109423:	83 ec 0c             	sub    $0xc,%esp
80109426:	68 e0 c0 10 80       	push   $0x8010c0e0
8010942b:	e8 c4 6f ff ff       	call   801003f4 <cprintf>
80109430:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
80109433:	8b 45 08             	mov    0x8(%ebp),%eax
80109436:	83 c0 08             	add    $0x8,%eax
80109439:	83 ec 0c             	sub    $0xc,%esp
8010943c:	50                   	push   %eax
8010943d:	e8 14 01 00 00       	call   80109556 <print_mac>
80109442:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109445:	83 ec 0c             	sub    $0xc,%esp
80109448:	68 e0 c0 10 80       	push   $0x8010c0e0
8010944d:	e8 a2 6f ff ff       	call   801003f4 <cprintf>
80109452:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
80109455:	83 ec 0c             	sub    $0xc,%esp
80109458:	68 f9 c0 10 80       	push   $0x8010c0f9
8010945d:	e8 92 6f ff ff       	call   801003f4 <cprintf>
80109462:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109465:	8b 45 08             	mov    0x8(%ebp),%eax
80109468:	83 c0 18             	add    $0x18,%eax
8010946b:	83 ec 0c             	sub    $0xc,%esp
8010946e:	50                   	push   %eax
8010946f:	e8 94 00 00 00       	call   80109508 <print_ipv4>
80109474:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109477:	83 ec 0c             	sub    $0xc,%esp
8010947a:	68 e0 c0 10 80       	push   $0x8010c0e0
8010947f:	e8 70 6f ff ff       	call   801003f4 <cprintf>
80109484:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109487:	8b 45 08             	mov    0x8(%ebp),%eax
8010948a:	83 c0 12             	add    $0x12,%eax
8010948d:	83 ec 0c             	sub    $0xc,%esp
80109490:	50                   	push   %eax
80109491:	e8 c0 00 00 00       	call   80109556 <print_mac>
80109496:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109499:	83 ec 0c             	sub    $0xc,%esp
8010949c:	68 e0 c0 10 80       	push   $0x8010c0e0
801094a1:	e8 4e 6f ff ff       	call   801003f4 <cprintf>
801094a6:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
801094a9:	83 ec 0c             	sub    $0xc,%esp
801094ac:	68 10 c1 10 80       	push   $0x8010c110
801094b1:	e8 3e 6f ff ff       	call   801003f4 <cprintf>
801094b6:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
801094b9:	8b 45 08             	mov    0x8(%ebp),%eax
801094bc:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801094c0:	66 3d 00 01          	cmp    $0x100,%ax
801094c4:	75 12                	jne    801094d8 <print_arp_info+0xdd>
801094c6:	83 ec 0c             	sub    $0xc,%esp
801094c9:	68 1c c1 10 80       	push   $0x8010c11c
801094ce:	e8 21 6f ff ff       	call   801003f4 <cprintf>
801094d3:	83 c4 10             	add    $0x10,%esp
801094d6:	eb 1d                	jmp    801094f5 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
801094d8:	8b 45 08             	mov    0x8(%ebp),%eax
801094db:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801094df:	66 3d 00 02          	cmp    $0x200,%ax
801094e3:	75 10                	jne    801094f5 <print_arp_info+0xfa>
    cprintf("Reply\n");
801094e5:	83 ec 0c             	sub    $0xc,%esp
801094e8:	68 25 c1 10 80       	push   $0x8010c125
801094ed:	e8 02 6f ff ff       	call   801003f4 <cprintf>
801094f2:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801094f5:	83 ec 0c             	sub    $0xc,%esp
801094f8:	68 e0 c0 10 80       	push   $0x8010c0e0
801094fd:	e8 f2 6e ff ff       	call   801003f4 <cprintf>
80109502:	83 c4 10             	add    $0x10,%esp
}
80109505:	90                   	nop
80109506:	c9                   	leave
80109507:	c3                   	ret

80109508 <print_ipv4>:

void print_ipv4(uchar *ip){
80109508:	55                   	push   %ebp
80109509:	89 e5                	mov    %esp,%ebp
8010950b:	53                   	push   %ebx
8010950c:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
8010950f:	8b 45 08             	mov    0x8(%ebp),%eax
80109512:	83 c0 03             	add    $0x3,%eax
80109515:	0f b6 00             	movzbl (%eax),%eax
80109518:	0f b6 d8             	movzbl %al,%ebx
8010951b:	8b 45 08             	mov    0x8(%ebp),%eax
8010951e:	83 c0 02             	add    $0x2,%eax
80109521:	0f b6 00             	movzbl (%eax),%eax
80109524:	0f b6 c8             	movzbl %al,%ecx
80109527:	8b 45 08             	mov    0x8(%ebp),%eax
8010952a:	83 c0 01             	add    $0x1,%eax
8010952d:	0f b6 00             	movzbl (%eax),%eax
80109530:	0f b6 d0             	movzbl %al,%edx
80109533:	8b 45 08             	mov    0x8(%ebp),%eax
80109536:	0f b6 00             	movzbl (%eax),%eax
80109539:	0f b6 c0             	movzbl %al,%eax
8010953c:	83 ec 0c             	sub    $0xc,%esp
8010953f:	53                   	push   %ebx
80109540:	51                   	push   %ecx
80109541:	52                   	push   %edx
80109542:	50                   	push   %eax
80109543:	68 2c c1 10 80       	push   $0x8010c12c
80109548:	e8 a7 6e ff ff       	call   801003f4 <cprintf>
8010954d:	83 c4 20             	add    $0x20,%esp
}
80109550:	90                   	nop
80109551:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109554:	c9                   	leave
80109555:	c3                   	ret

80109556 <print_mac>:

void print_mac(uchar *mac){
80109556:	55                   	push   %ebp
80109557:	89 e5                	mov    %esp,%ebp
80109559:	57                   	push   %edi
8010955a:	56                   	push   %esi
8010955b:	53                   	push   %ebx
8010955c:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
8010955f:	8b 45 08             	mov    0x8(%ebp),%eax
80109562:	83 c0 05             	add    $0x5,%eax
80109565:	0f b6 00             	movzbl (%eax),%eax
80109568:	0f b6 f8             	movzbl %al,%edi
8010956b:	8b 45 08             	mov    0x8(%ebp),%eax
8010956e:	83 c0 04             	add    $0x4,%eax
80109571:	0f b6 00             	movzbl (%eax),%eax
80109574:	0f b6 f0             	movzbl %al,%esi
80109577:	8b 45 08             	mov    0x8(%ebp),%eax
8010957a:	83 c0 03             	add    $0x3,%eax
8010957d:	0f b6 00             	movzbl (%eax),%eax
80109580:	0f b6 d8             	movzbl %al,%ebx
80109583:	8b 45 08             	mov    0x8(%ebp),%eax
80109586:	83 c0 02             	add    $0x2,%eax
80109589:	0f b6 00             	movzbl (%eax),%eax
8010958c:	0f b6 c8             	movzbl %al,%ecx
8010958f:	8b 45 08             	mov    0x8(%ebp),%eax
80109592:	83 c0 01             	add    $0x1,%eax
80109595:	0f b6 00             	movzbl (%eax),%eax
80109598:	0f b6 d0             	movzbl %al,%edx
8010959b:	8b 45 08             	mov    0x8(%ebp),%eax
8010959e:	0f b6 00             	movzbl (%eax),%eax
801095a1:	0f b6 c0             	movzbl %al,%eax
801095a4:	83 ec 04             	sub    $0x4,%esp
801095a7:	57                   	push   %edi
801095a8:	56                   	push   %esi
801095a9:	53                   	push   %ebx
801095aa:	51                   	push   %ecx
801095ab:	52                   	push   %edx
801095ac:	50                   	push   %eax
801095ad:	68 44 c1 10 80       	push   $0x8010c144
801095b2:	e8 3d 6e ff ff       	call   801003f4 <cprintf>
801095b7:	83 c4 20             	add    $0x20,%esp
}
801095ba:	90                   	nop
801095bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801095be:	5b                   	pop    %ebx
801095bf:	5e                   	pop    %esi
801095c0:	5f                   	pop    %edi
801095c1:	5d                   	pop    %ebp
801095c2:	c3                   	ret

801095c3 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
801095c3:	55                   	push   %ebp
801095c4:	89 e5                	mov    %esp,%ebp
801095c6:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
801095c9:	8b 45 08             	mov    0x8(%ebp),%eax
801095cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
801095cf:	8b 45 08             	mov    0x8(%ebp),%eax
801095d2:	83 c0 0e             	add    $0xe,%eax
801095d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
801095d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095db:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801095df:	3c 08                	cmp    $0x8,%al
801095e1:	75 1b                	jne    801095fe <eth_proc+0x3b>
801095e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e6:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801095ea:	3c 06                	cmp    $0x6,%al
801095ec:	75 10                	jne    801095fe <eth_proc+0x3b>
    arp_proc(pkt_addr);
801095ee:	83 ec 0c             	sub    $0xc,%esp
801095f1:	ff 75 f0             	push   -0x10(%ebp)
801095f4:	e8 01 f8 ff ff       	call   80108dfa <arp_proc>
801095f9:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801095fc:	eb 24                	jmp    80109622 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801095fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109601:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109605:	3c 08                	cmp    $0x8,%al
80109607:	75 19                	jne    80109622 <eth_proc+0x5f>
80109609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960c:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109610:	84 c0                	test   %al,%al
80109612:	75 0e                	jne    80109622 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
80109614:	83 ec 0c             	sub    $0xc,%esp
80109617:	ff 75 08             	push   0x8(%ebp)
8010961a:	e8 8d 00 00 00       	call   801096ac <ipv4_proc>
8010961f:	83 c4 10             	add    $0x10,%esp
}
80109622:	90                   	nop
80109623:	c9                   	leave
80109624:	c3                   	ret

80109625 <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109625:	55                   	push   %ebp
80109626:	89 e5                	mov    %esp,%ebp
80109628:	83 ec 04             	sub    $0x4,%esp
8010962b:	8b 45 08             	mov    0x8(%ebp),%eax
8010962e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109632:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109636:	66 c1 c0 08          	rol    $0x8,%ax
}
8010963a:	c9                   	leave
8010963b:	c3                   	ret

8010963c <H2N_ushort>:

ushort H2N_ushort(ushort value){
8010963c:	55                   	push   %ebp
8010963d:	89 e5                	mov    %esp,%ebp
8010963f:	83 ec 04             	sub    $0x4,%esp
80109642:	8b 45 08             	mov    0x8(%ebp),%eax
80109645:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109649:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010964d:	66 c1 c0 08          	rol    $0x8,%ax
}
80109651:	c9                   	leave
80109652:	c3                   	ret

80109653 <H2N_uint>:

uint H2N_uint(uint value){
80109653:	55                   	push   %ebp
80109654:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109656:	8b 45 08             	mov    0x8(%ebp),%eax
80109659:	c1 e0 18             	shl    $0x18,%eax
8010965c:	25 00 00 00 0f       	and    $0xf000000,%eax
80109661:	89 c2                	mov    %eax,%edx
80109663:	8b 45 08             	mov    0x8(%ebp),%eax
80109666:	c1 e0 08             	shl    $0x8,%eax
80109669:	25 00 f0 00 00       	and    $0xf000,%eax
8010966e:	09 c2                	or     %eax,%edx
80109670:	8b 45 08             	mov    0x8(%ebp),%eax
80109673:	c1 e8 08             	shr    $0x8,%eax
80109676:	83 e0 0f             	and    $0xf,%eax
80109679:	01 d0                	add    %edx,%eax
}
8010967b:	5d                   	pop    %ebp
8010967c:	c3                   	ret

8010967d <N2H_uint>:

uint N2H_uint(uint value){
8010967d:	55                   	push   %ebp
8010967e:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
80109680:	8b 45 08             	mov    0x8(%ebp),%eax
80109683:	c1 e0 18             	shl    $0x18,%eax
80109686:	89 c2                	mov    %eax,%edx
80109688:	8b 45 08             	mov    0x8(%ebp),%eax
8010968b:	c1 e0 08             	shl    $0x8,%eax
8010968e:	25 00 00 ff 00       	and    $0xff0000,%eax
80109693:	01 c2                	add    %eax,%edx
80109695:	8b 45 08             	mov    0x8(%ebp),%eax
80109698:	c1 e8 08             	shr    $0x8,%eax
8010969b:	25 00 ff 00 00       	and    $0xff00,%eax
801096a0:	01 c2                	add    %eax,%edx
801096a2:	8b 45 08             	mov    0x8(%ebp),%eax
801096a5:	c1 e8 18             	shr    $0x18,%eax
801096a8:	01 d0                	add    %edx,%eax
}
801096aa:	5d                   	pop    %ebp
801096ab:	c3                   	ret

801096ac <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
801096ac:	55                   	push   %ebp
801096ad:	89 e5                	mov    %esp,%ebp
801096af:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
801096b2:	8b 45 08             	mov    0x8(%ebp),%eax
801096b5:	83 c0 0e             	add    $0xe,%eax
801096b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
801096bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096be:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801096c2:	0f b7 d0             	movzwl %ax,%edx
801096c5:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
801096ca:	39 c2                	cmp    %eax,%edx
801096cc:	74 60                	je     8010972e <ipv4_proc+0x82>
801096ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d1:	83 c0 0c             	add    $0xc,%eax
801096d4:	83 ec 04             	sub    $0x4,%esp
801096d7:	6a 04                	push   $0x4
801096d9:	50                   	push   %eax
801096da:	68 e4 f4 10 80       	push   $0x8010f4e4
801096df:	e8 41 b5 ff ff       	call   80104c25 <memcmp>
801096e4:	83 c4 10             	add    $0x10,%esp
801096e7:	85 c0                	test   %eax,%eax
801096e9:	74 43                	je     8010972e <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801096eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ee:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801096f2:	0f b7 c0             	movzwl %ax,%eax
801096f5:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801096fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096fd:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109701:	3c 01                	cmp    $0x1,%al
80109703:	75 10                	jne    80109715 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
80109705:	83 ec 0c             	sub    $0xc,%esp
80109708:	ff 75 08             	push   0x8(%ebp)
8010970b:	e8 a3 00 00 00       	call   801097b3 <icmp_proc>
80109710:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
80109713:	eb 19                	jmp    8010972e <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109718:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010971c:	3c 06                	cmp    $0x6,%al
8010971e:	75 0e                	jne    8010972e <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
80109720:	83 ec 0c             	sub    $0xc,%esp
80109723:	ff 75 08             	push   0x8(%ebp)
80109726:	e8 b3 03 00 00       	call   80109ade <tcp_proc>
8010972b:	83 c4 10             	add    $0x10,%esp
}
8010972e:	90                   	nop
8010972f:	c9                   	leave
80109730:	c3                   	ret

80109731 <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
80109731:	55                   	push   %ebp
80109732:	89 e5                	mov    %esp,%ebp
80109734:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109737:	8b 45 08             	mov    0x8(%ebp),%eax
8010973a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
8010973d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109740:	0f b6 00             	movzbl (%eax),%eax
80109743:	83 e0 0f             	and    $0xf,%eax
80109746:	01 c0                	add    %eax,%eax
80109748:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
8010974b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109752:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109759:	eb 48                	jmp    801097a3 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010975b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010975e:	01 c0                	add    %eax,%eax
80109760:	89 c2                	mov    %eax,%edx
80109762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109765:	01 d0                	add    %edx,%eax
80109767:	0f b6 00             	movzbl (%eax),%eax
8010976a:	0f b6 c0             	movzbl %al,%eax
8010976d:	c1 e0 08             	shl    $0x8,%eax
80109770:	89 c2                	mov    %eax,%edx
80109772:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109775:	01 c0                	add    %eax,%eax
80109777:	8d 48 01             	lea    0x1(%eax),%ecx
8010977a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010977d:	01 c8                	add    %ecx,%eax
8010977f:	0f b6 00             	movzbl (%eax),%eax
80109782:	0f b6 c0             	movzbl %al,%eax
80109785:	01 d0                	add    %edx,%eax
80109787:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
8010978a:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109791:	76 0c                	jbe    8010979f <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109793:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109796:	0f b7 c0             	movzwl %ax,%eax
80109799:	83 c0 01             	add    $0x1,%eax
8010979c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010979f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801097a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801097a7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801097aa:	7c af                	jl     8010975b <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
801097ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801097af:	f7 d0                	not    %eax
}
801097b1:	c9                   	leave
801097b2:	c3                   	ret

801097b3 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
801097b3:	55                   	push   %ebp
801097b4:	89 e5                	mov    %esp,%ebp
801097b6:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
801097b9:	8b 45 08             	mov    0x8(%ebp),%eax
801097bc:	83 c0 0e             	add    $0xe,%eax
801097bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
801097c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097c5:	0f b6 00             	movzbl (%eax),%eax
801097c8:	0f b6 c0             	movzbl %al,%eax
801097cb:	83 e0 0f             	and    $0xf,%eax
801097ce:	c1 e0 02             	shl    $0x2,%eax
801097d1:	89 c2                	mov    %eax,%edx
801097d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d6:	01 d0                	add    %edx,%eax
801097d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
801097db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097de:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801097e2:	84 c0                	test   %al,%al
801097e4:	75 4f                	jne    80109835 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
801097e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097e9:	0f b6 00             	movzbl (%eax),%eax
801097ec:	3c 08                	cmp    $0x8,%al
801097ee:	75 45                	jne    80109835 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
801097f0:	e8 b3 8f ff ff       	call   801027a8 <kalloc>
801097f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
801097f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
801097ff:	83 ec 04             	sub    $0x4,%esp
80109802:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109805:	50                   	push   %eax
80109806:	ff 75 ec             	push   -0x14(%ebp)
80109809:	ff 75 08             	push   0x8(%ebp)
8010980c:	e8 78 00 00 00       	call   80109889 <icmp_reply_pkt_create>
80109811:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109814:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109817:	83 ec 08             	sub    $0x8,%esp
8010981a:	50                   	push   %eax
8010981b:	ff 75 ec             	push   -0x14(%ebp)
8010981e:	e8 ad f4 ff ff       	call   80108cd0 <i8254_send>
80109823:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109826:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109829:	83 ec 0c             	sub    $0xc,%esp
8010982c:	50                   	push   %eax
8010982d:	e8 dc 8e ff ff       	call   8010270e <kfree>
80109832:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109835:	90                   	nop
80109836:	c9                   	leave
80109837:	c3                   	ret

80109838 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109838:	55                   	push   %ebp
80109839:	89 e5                	mov    %esp,%ebp
8010983b:	53                   	push   %ebx
8010983c:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
8010983f:	8b 45 08             	mov    0x8(%ebp),%eax
80109842:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109846:	0f b7 c0             	movzwl %ax,%eax
80109849:	83 ec 0c             	sub    $0xc,%esp
8010984c:	50                   	push   %eax
8010984d:	e8 d3 fd ff ff       	call   80109625 <N2H_ushort>
80109852:	83 c4 10             	add    $0x10,%esp
80109855:	0f b7 d8             	movzwl %ax,%ebx
80109858:	8b 45 08             	mov    0x8(%ebp),%eax
8010985b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010985f:	0f b7 c0             	movzwl %ax,%eax
80109862:	83 ec 0c             	sub    $0xc,%esp
80109865:	50                   	push   %eax
80109866:	e8 ba fd ff ff       	call   80109625 <N2H_ushort>
8010986b:	83 c4 10             	add    $0x10,%esp
8010986e:	0f b7 c0             	movzwl %ax,%eax
80109871:	83 ec 04             	sub    $0x4,%esp
80109874:	53                   	push   %ebx
80109875:	50                   	push   %eax
80109876:	68 63 c1 10 80       	push   $0x8010c163
8010987b:	e8 74 6b ff ff       	call   801003f4 <cprintf>
80109880:	83 c4 10             	add    $0x10,%esp
}
80109883:	90                   	nop
80109884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109887:	c9                   	leave
80109888:	c3                   	ret

80109889 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109889:	55                   	push   %ebp
8010988a:	89 e5                	mov    %esp,%ebp
8010988c:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010988f:	8b 45 08             	mov    0x8(%ebp),%eax
80109892:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109895:	8b 45 08             	mov    0x8(%ebp),%eax
80109898:	83 c0 0e             	add    $0xe,%eax
8010989b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
8010989e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098a1:	0f b6 00             	movzbl (%eax),%eax
801098a4:	0f b6 c0             	movzbl %al,%eax
801098a7:	83 e0 0f             	and    $0xf,%eax
801098aa:	c1 e0 02             	shl    $0x2,%eax
801098ad:	89 c2                	mov    %eax,%edx
801098af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098b2:	01 d0                	add    %edx,%eax
801098b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
801098b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801098ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
801098bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801098c0:	83 c0 0e             	add    $0xe,%eax
801098c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
801098c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801098c9:	83 c0 14             	add    $0x14,%eax
801098cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
801098cf:	8b 45 10             	mov    0x10(%ebp),%eax
801098d2:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
801098d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098db:	8d 50 06             	lea    0x6(%eax),%edx
801098de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098e1:	83 ec 04             	sub    $0x4,%esp
801098e4:	6a 06                	push   $0x6
801098e6:	52                   	push   %edx
801098e7:	50                   	push   %eax
801098e8:	e8 90 b3 ff ff       	call   80104c7d <memmove>
801098ed:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
801098f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098f3:	83 c0 06             	add    $0x6,%eax
801098f6:	83 ec 04             	sub    $0x4,%esp
801098f9:	6a 06                	push   $0x6
801098fb:	68 80 6d 19 80       	push   $0x80196d80
80109900:	50                   	push   %eax
80109901:	e8 77 b3 ff ff       	call   80104c7d <memmove>
80109906:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109909:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010990c:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109910:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109913:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010991a:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010991d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109920:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109924:	83 ec 0c             	sub    $0xc,%esp
80109927:	6a 54                	push   $0x54
80109929:	e8 0e fd ff ff       	call   8010963c <H2N_ushort>
8010992e:	83 c4 10             	add    $0x10,%esp
80109931:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109934:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109938:	0f b7 15 60 70 19 80 	movzwl 0x80197060,%edx
8010993f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109942:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109946:	0f b7 05 60 70 19 80 	movzwl 0x80197060,%eax
8010994d:	83 c0 01             	add    $0x1,%eax
80109950:	66 a3 60 70 19 80    	mov    %ax,0x80197060
  ipv4_send->fragment = H2N_ushort(0x4000);
80109956:	83 ec 0c             	sub    $0xc,%esp
80109959:	68 00 40 00 00       	push   $0x4000
8010995e:	e8 d9 fc ff ff       	call   8010963c <H2N_ushort>
80109963:	83 c4 10             	add    $0x10,%esp
80109966:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109969:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010996d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109970:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109977:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010997b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010997e:	83 c0 0c             	add    $0xc,%eax
80109981:	83 ec 04             	sub    $0x4,%esp
80109984:	6a 04                	push   $0x4
80109986:	68 e4 f4 10 80       	push   $0x8010f4e4
8010998b:	50                   	push   %eax
8010998c:	e8 ec b2 ff ff       	call   80104c7d <memmove>
80109991:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109997:	8d 50 0c             	lea    0xc(%eax),%edx
8010999a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010999d:	83 c0 10             	add    $0x10,%eax
801099a0:	83 ec 04             	sub    $0x4,%esp
801099a3:	6a 04                	push   $0x4
801099a5:	52                   	push   %edx
801099a6:	50                   	push   %eax
801099a7:	e8 d1 b2 ff ff       	call   80104c7d <memmove>
801099ac:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
801099af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099b2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
801099b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099bb:	83 ec 0c             	sub    $0xc,%esp
801099be:	50                   	push   %eax
801099bf:	e8 6d fd ff ff       	call   80109731 <ipv4_chksum>
801099c4:	83 c4 10             	add    $0x10,%esp
801099c7:	0f b7 c0             	movzwl %ax,%eax
801099ca:	83 ec 0c             	sub    $0xc,%esp
801099cd:	50                   	push   %eax
801099ce:	e8 69 fc ff ff       	call   8010963c <H2N_ushort>
801099d3:	83 c4 10             	add    $0x10,%esp
801099d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801099d9:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
801099dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099e0:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
801099e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099e6:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
801099ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801099ed:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801099f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099f4:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
801099f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801099fb:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801099ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a02:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a09:	8d 50 08             	lea    0x8(%eax),%edx
80109a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a0f:	83 c0 08             	add    $0x8,%eax
80109a12:	83 ec 04             	sub    $0x4,%esp
80109a15:	6a 08                	push   $0x8
80109a17:	52                   	push   %edx
80109a18:	50                   	push   %eax
80109a19:	e8 5f b2 ff ff       	call   80104c7d <memmove>
80109a1e:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a24:	8d 50 10             	lea    0x10(%eax),%edx
80109a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a2a:	83 c0 10             	add    $0x10,%eax
80109a2d:	83 ec 04             	sub    $0x4,%esp
80109a30:	6a 30                	push   $0x30
80109a32:	52                   	push   %edx
80109a33:	50                   	push   %eax
80109a34:	e8 44 b2 ff ff       	call   80104c7d <memmove>
80109a39:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a3f:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a48:	83 ec 0c             	sub    $0xc,%esp
80109a4b:	50                   	push   %eax
80109a4c:	e8 1c 00 00 00       	call   80109a6d <icmp_chksum>
80109a51:	83 c4 10             	add    $0x10,%esp
80109a54:	0f b7 c0             	movzwl %ax,%eax
80109a57:	83 ec 0c             	sub    $0xc,%esp
80109a5a:	50                   	push   %eax
80109a5b:	e8 dc fb ff ff       	call   8010963c <H2N_ushort>
80109a60:	83 c4 10             	add    $0x10,%esp
80109a63:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109a66:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109a6a:	90                   	nop
80109a6b:	c9                   	leave
80109a6c:	c3                   	ret

80109a6d <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109a6d:	55                   	push   %ebp
80109a6e:	89 e5                	mov    %esp,%ebp
80109a70:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109a73:	8b 45 08             	mov    0x8(%ebp),%eax
80109a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109a80:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109a87:	eb 48                	jmp    80109ad1 <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a8c:	01 c0                	add    %eax,%eax
80109a8e:	89 c2                	mov    %eax,%edx
80109a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a93:	01 d0                	add    %edx,%eax
80109a95:	0f b6 00             	movzbl (%eax),%eax
80109a98:	0f b6 c0             	movzbl %al,%eax
80109a9b:	c1 e0 08             	shl    $0x8,%eax
80109a9e:	89 c2                	mov    %eax,%edx
80109aa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109aa3:	01 c0                	add    %eax,%eax
80109aa5:	8d 48 01             	lea    0x1(%eax),%ecx
80109aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109aab:	01 c8                	add    %ecx,%eax
80109aad:	0f b6 00             	movzbl (%eax),%eax
80109ab0:	0f b6 c0             	movzbl %al,%eax
80109ab3:	01 d0                	add    %edx,%eax
80109ab5:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109ab8:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109abf:	76 0c                	jbe    80109acd <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109ac4:	0f b7 c0             	movzwl %ax,%eax
80109ac7:	83 c0 01             	add    $0x1,%eax
80109aca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109acd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109ad1:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109ad5:	7e b2                	jle    80109a89 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109ada:	f7 d0                	not    %eax
}
80109adc:	c9                   	leave
80109add:	c3                   	ret

80109ade <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109ade:	55                   	push   %ebp
80109adf:	89 e5                	mov    %esp,%ebp
80109ae1:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80109ae7:	83 c0 0e             	add    $0xe,%eax
80109aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109af0:	0f b6 00             	movzbl (%eax),%eax
80109af3:	0f b6 c0             	movzbl %al,%eax
80109af6:	83 e0 0f             	and    $0xf,%eax
80109af9:	c1 e0 02             	shl    $0x2,%eax
80109afc:	89 c2                	mov    %eax,%edx
80109afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b01:	01 d0                	add    %edx,%eax
80109b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b09:	83 c0 14             	add    $0x14,%eax
80109b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109b0f:	e8 94 8c ff ff       	call   801027a8 <kalloc>
80109b14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109b17:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b21:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b25:	0f b6 c0             	movzbl %al,%eax
80109b28:	83 e0 02             	and    $0x2,%eax
80109b2b:	85 c0                	test   %eax,%eax
80109b2d:	74 3d                	je     80109b6c <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109b2f:	83 ec 0c             	sub    $0xc,%esp
80109b32:	6a 00                	push   $0x0
80109b34:	6a 12                	push   $0x12
80109b36:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b39:	50                   	push   %eax
80109b3a:	ff 75 e8             	push   -0x18(%ebp)
80109b3d:	ff 75 08             	push   0x8(%ebp)
80109b40:	e8 a2 01 00 00       	call   80109ce7 <tcp_pkt_create>
80109b45:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109b48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b4b:	83 ec 08             	sub    $0x8,%esp
80109b4e:	50                   	push   %eax
80109b4f:	ff 75 e8             	push   -0x18(%ebp)
80109b52:	e8 79 f1 ff ff       	call   80108cd0 <i8254_send>
80109b57:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109b5a:	a1 64 70 19 80       	mov    0x80197064,%eax
80109b5f:	83 c0 01             	add    $0x1,%eax
80109b62:	a3 64 70 19 80       	mov    %eax,0x80197064
80109b67:	e9 69 01 00 00       	jmp    80109cd5 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b6f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b73:	3c 18                	cmp    $0x18,%al
80109b75:	0f 85 10 01 00 00    	jne    80109c8b <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109b7b:	83 ec 04             	sub    $0x4,%esp
80109b7e:	6a 03                	push   $0x3
80109b80:	68 7e c1 10 80       	push   $0x8010c17e
80109b85:	ff 75 ec             	push   -0x14(%ebp)
80109b88:	e8 98 b0 ff ff       	call   80104c25 <memcmp>
80109b8d:	83 c4 10             	add    $0x10,%esp
80109b90:	85 c0                	test   %eax,%eax
80109b92:	74 74                	je     80109c08 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109b94:	83 ec 0c             	sub    $0xc,%esp
80109b97:	68 82 c1 10 80       	push   $0x8010c182
80109b9c:	e8 53 68 ff ff       	call   801003f4 <cprintf>
80109ba1:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109ba4:	83 ec 0c             	sub    $0xc,%esp
80109ba7:	6a 00                	push   $0x0
80109ba9:	6a 10                	push   $0x10
80109bab:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109bae:	50                   	push   %eax
80109baf:	ff 75 e8             	push   -0x18(%ebp)
80109bb2:	ff 75 08             	push   0x8(%ebp)
80109bb5:	e8 2d 01 00 00       	call   80109ce7 <tcp_pkt_create>
80109bba:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109bbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109bc0:	83 ec 08             	sub    $0x8,%esp
80109bc3:	50                   	push   %eax
80109bc4:	ff 75 e8             	push   -0x18(%ebp)
80109bc7:	e8 04 f1 ff ff       	call   80108cd0 <i8254_send>
80109bcc:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bd2:	83 c0 36             	add    $0x36,%eax
80109bd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109bd8:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109bdb:	50                   	push   %eax
80109bdc:	ff 75 e0             	push   -0x20(%ebp)
80109bdf:	6a 00                	push   $0x0
80109be1:	6a 00                	push   $0x0
80109be3:	e8 5a 04 00 00       	call   8010a042 <http_proc>
80109be8:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109beb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109bee:	83 ec 0c             	sub    $0xc,%esp
80109bf1:	50                   	push   %eax
80109bf2:	6a 18                	push   $0x18
80109bf4:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109bf7:	50                   	push   %eax
80109bf8:	ff 75 e8             	push   -0x18(%ebp)
80109bfb:	ff 75 08             	push   0x8(%ebp)
80109bfe:	e8 e4 00 00 00       	call   80109ce7 <tcp_pkt_create>
80109c03:	83 c4 20             	add    $0x20,%esp
80109c06:	eb 62                	jmp    80109c6a <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c08:	83 ec 0c             	sub    $0xc,%esp
80109c0b:	6a 00                	push   $0x0
80109c0d:	6a 10                	push   $0x10
80109c0f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c12:	50                   	push   %eax
80109c13:	ff 75 e8             	push   -0x18(%ebp)
80109c16:	ff 75 08             	push   0x8(%ebp)
80109c19:	e8 c9 00 00 00       	call   80109ce7 <tcp_pkt_create>
80109c1e:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c24:	83 ec 08             	sub    $0x8,%esp
80109c27:	50                   	push   %eax
80109c28:	ff 75 e8             	push   -0x18(%ebp)
80109c2b:	e8 a0 f0 ff ff       	call   80108cd0 <i8254_send>
80109c30:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c36:	83 c0 36             	add    $0x36,%eax
80109c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109c3c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109c3f:	50                   	push   %eax
80109c40:	ff 75 e4             	push   -0x1c(%ebp)
80109c43:	6a 00                	push   $0x0
80109c45:	6a 00                	push   $0x0
80109c47:	e8 f6 03 00 00       	call   8010a042 <http_proc>
80109c4c:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109c52:	83 ec 0c             	sub    $0xc,%esp
80109c55:	50                   	push   %eax
80109c56:	6a 18                	push   $0x18
80109c58:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c5b:	50                   	push   %eax
80109c5c:	ff 75 e8             	push   -0x18(%ebp)
80109c5f:	ff 75 08             	push   0x8(%ebp)
80109c62:	e8 80 00 00 00       	call   80109ce7 <tcp_pkt_create>
80109c67:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109c6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c6d:	83 ec 08             	sub    $0x8,%esp
80109c70:	50                   	push   %eax
80109c71:	ff 75 e8             	push   -0x18(%ebp)
80109c74:	e8 57 f0 ff ff       	call   80108cd0 <i8254_send>
80109c79:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109c7c:	a1 64 70 19 80       	mov    0x80197064,%eax
80109c81:	83 c0 01             	add    $0x1,%eax
80109c84:	a3 64 70 19 80       	mov    %eax,0x80197064
80109c89:	eb 4a                	jmp    80109cd5 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c8e:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c92:	3c 10                	cmp    $0x10,%al
80109c94:	75 3f                	jne    80109cd5 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109c96:	a1 68 70 19 80       	mov    0x80197068,%eax
80109c9b:	83 f8 01             	cmp    $0x1,%eax
80109c9e:	75 35                	jne    80109cd5 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109ca0:	83 ec 0c             	sub    $0xc,%esp
80109ca3:	6a 00                	push   $0x0
80109ca5:	6a 01                	push   $0x1
80109ca7:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109caa:	50                   	push   %eax
80109cab:	ff 75 e8             	push   -0x18(%ebp)
80109cae:	ff 75 08             	push   0x8(%ebp)
80109cb1:	e8 31 00 00 00       	call   80109ce7 <tcp_pkt_create>
80109cb6:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109cb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109cbc:	83 ec 08             	sub    $0x8,%esp
80109cbf:	50                   	push   %eax
80109cc0:	ff 75 e8             	push   -0x18(%ebp)
80109cc3:	e8 08 f0 ff ff       	call   80108cd0 <i8254_send>
80109cc8:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109ccb:	c7 05 68 70 19 80 00 	movl   $0x0,0x80197068
80109cd2:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109cd8:	83 ec 0c             	sub    $0xc,%esp
80109cdb:	50                   	push   %eax
80109cdc:	e8 2d 8a ff ff       	call   8010270e <kfree>
80109ce1:	83 c4 10             	add    $0x10,%esp
}
80109ce4:	90                   	nop
80109ce5:	c9                   	leave
80109ce6:	c3                   	ret

80109ce7 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109ce7:	55                   	push   %ebp
80109ce8:	89 e5                	mov    %esp,%ebp
80109cea:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109ced:	8b 45 08             	mov    0x8(%ebp),%eax
80109cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80109cf6:	83 c0 0e             	add    $0xe,%eax
80109cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cff:	0f b6 00             	movzbl (%eax),%eax
80109d02:	0f b6 c0             	movzbl %al,%eax
80109d05:	83 e0 0f             	and    $0xf,%eax
80109d08:	c1 e0 02             	shl    $0x2,%eax
80109d0b:	89 c2                	mov    %eax,%edx
80109d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d10:	01 d0                	add    %edx,%eax
80109d12:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109d15:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d18:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d1e:	83 c0 0e             	add    $0xe,%eax
80109d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109d24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d27:	83 c0 14             	add    $0x14,%eax
80109d2a:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109d2d:	8b 45 18             	mov    0x18(%ebp),%eax
80109d30:	8d 50 36             	lea    0x36(%eax),%edx
80109d33:	8b 45 10             	mov    0x10(%ebp),%eax
80109d36:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d3b:	8d 50 06             	lea    0x6(%eax),%edx
80109d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d41:	83 ec 04             	sub    $0x4,%esp
80109d44:	6a 06                	push   $0x6
80109d46:	52                   	push   %edx
80109d47:	50                   	push   %eax
80109d48:	e8 30 af ff ff       	call   80104c7d <memmove>
80109d4d:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d53:	83 c0 06             	add    $0x6,%eax
80109d56:	83 ec 04             	sub    $0x4,%esp
80109d59:	6a 06                	push   $0x6
80109d5b:	68 80 6d 19 80       	push   $0x80196d80
80109d60:	50                   	push   %eax
80109d61:	e8 17 af ff ff       	call   80104c7d <memmove>
80109d66:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109d69:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d6c:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d73:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d7a:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d80:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109d84:	8b 45 18             	mov    0x18(%ebp),%eax
80109d87:	83 c0 28             	add    $0x28,%eax
80109d8a:	0f b7 c0             	movzwl %ax,%eax
80109d8d:	83 ec 0c             	sub    $0xc,%esp
80109d90:	50                   	push   %eax
80109d91:	e8 a6 f8 ff ff       	call   8010963c <H2N_ushort>
80109d96:	83 c4 10             	add    $0x10,%esp
80109d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109d9c:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109da0:	0f b7 15 60 70 19 80 	movzwl 0x80197060,%edx
80109da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109daa:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109dae:	0f b7 05 60 70 19 80 	movzwl 0x80197060,%eax
80109db5:	83 c0 01             	add    $0x1,%eax
80109db8:	66 a3 60 70 19 80    	mov    %ax,0x80197060
  ipv4_send->fragment = H2N_ushort(0x0000);
80109dbe:	83 ec 0c             	sub    $0xc,%esp
80109dc1:	6a 00                	push   $0x0
80109dc3:	e8 74 f8 ff ff       	call   8010963c <H2N_ushort>
80109dc8:	83 c4 10             	add    $0x10,%esp
80109dcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109dce:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dd5:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ddc:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de3:	83 c0 0c             	add    $0xc,%eax
80109de6:	83 ec 04             	sub    $0x4,%esp
80109de9:	6a 04                	push   $0x4
80109deb:	68 e4 f4 10 80       	push   $0x8010f4e4
80109df0:	50                   	push   %eax
80109df1:	e8 87 ae ff ff       	call   80104c7d <memmove>
80109df6:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dfc:	8d 50 0c             	lea    0xc(%eax),%edx
80109dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e02:	83 c0 10             	add    $0x10,%eax
80109e05:	83 ec 04             	sub    $0x4,%esp
80109e08:	6a 04                	push   $0x4
80109e0a:	52                   	push   %edx
80109e0b:	50                   	push   %eax
80109e0c:	e8 6c ae ff ff       	call   80104c7d <memmove>
80109e11:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e17:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e20:	83 ec 0c             	sub    $0xc,%esp
80109e23:	50                   	push   %eax
80109e24:	e8 08 f9 ff ff       	call   80109731 <ipv4_chksum>
80109e29:	83 c4 10             	add    $0x10,%esp
80109e2c:	0f b7 c0             	movzwl %ax,%eax
80109e2f:	83 ec 0c             	sub    $0xc,%esp
80109e32:	50                   	push   %eax
80109e33:	e8 04 f8 ff ff       	call   8010963c <H2N_ushort>
80109e38:	83 c4 10             	add    $0x10,%esp
80109e3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e3e:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e45:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e4c:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e52:	0f b7 10             	movzwl (%eax),%edx
80109e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e58:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109e5c:	a1 64 70 19 80       	mov    0x80197064,%eax
80109e61:	83 ec 0c             	sub    $0xc,%esp
80109e64:	50                   	push   %eax
80109e65:	e8 e9 f7 ff ff       	call   80109653 <H2N_uint>
80109e6a:	83 c4 10             	add    $0x10,%esp
80109e6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109e70:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e76:	8b 40 04             	mov    0x4(%eax),%eax
80109e79:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109e7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e82:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e88:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e8f:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109e93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e96:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109e9a:	8b 45 14             	mov    0x14(%ebp),%eax
80109e9d:	89 c2                	mov    %eax,%edx
80109e9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ea2:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109ea5:	83 ec 0c             	sub    $0xc,%esp
80109ea8:	68 90 38 00 00       	push   $0x3890
80109ead:	e8 8a f7 ff ff       	call   8010963c <H2N_ushort>
80109eb2:	83 c4 10             	add    $0x10,%esp
80109eb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109eb8:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ebf:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ec8:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ed1:	83 ec 0c             	sub    $0xc,%esp
80109ed4:	50                   	push   %eax
80109ed5:	e8 1f 00 00 00       	call   80109ef9 <tcp_chksum>
80109eda:	83 c4 10             	add    $0x10,%esp
80109edd:	83 c0 08             	add    $0x8,%eax
80109ee0:	0f b7 c0             	movzwl %ax,%eax
80109ee3:	83 ec 0c             	sub    $0xc,%esp
80109ee6:	50                   	push   %eax
80109ee7:	e8 50 f7 ff ff       	call   8010963c <H2N_ushort>
80109eec:	83 c4 10             	add    $0x10,%esp
80109eef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109ef2:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109ef6:	90                   	nop
80109ef7:	c9                   	leave
80109ef8:	c3                   	ret

80109ef9 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109ef9:	55                   	push   %ebp
80109efa:	89 e5                	mov    %esp,%ebp
80109efc:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109eff:	8b 45 08             	mov    0x8(%ebp),%eax
80109f02:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f08:	83 c0 14             	add    $0x14,%eax
80109f0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109f0e:	83 ec 04             	sub    $0x4,%esp
80109f11:	6a 04                	push   $0x4
80109f13:	68 e4 f4 10 80       	push   $0x8010f4e4
80109f18:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f1b:	50                   	push   %eax
80109f1c:	e8 5c ad ff ff       	call   80104c7d <memmove>
80109f21:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f27:	83 c0 0c             	add    $0xc,%eax
80109f2a:	83 ec 04             	sub    $0x4,%esp
80109f2d:	6a 04                	push   $0x4
80109f2f:	50                   	push   %eax
80109f30:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f33:	83 c0 04             	add    $0x4,%eax
80109f36:	50                   	push   %eax
80109f37:	e8 41 ad ff ff       	call   80104c7d <memmove>
80109f3c:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109f3f:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
80109f43:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
80109f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f4a:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109f4e:	0f b7 c0             	movzwl %ax,%eax
80109f51:	83 ec 0c             	sub    $0xc,%esp
80109f54:	50                   	push   %eax
80109f55:	e8 cb f6 ff ff       	call   80109625 <N2H_ushort>
80109f5a:	83 c4 10             	add    $0x10,%esp
80109f5d:	83 e8 14             	sub    $0x14,%eax
80109f60:	0f b7 c0             	movzwl %ax,%eax
80109f63:	83 ec 0c             	sub    $0xc,%esp
80109f66:	50                   	push   %eax
80109f67:	e8 d0 f6 ff ff       	call   8010963c <H2N_ushort>
80109f6c:	83 c4 10             	add    $0x10,%esp
80109f6f:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
80109f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
80109f7a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
80109f80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109f87:	eb 33                	jmp    80109fbc <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f8c:	01 c0                	add    %eax,%eax
80109f8e:	89 c2                	mov    %eax,%edx
80109f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f93:	01 d0                	add    %edx,%eax
80109f95:	0f b6 00             	movzbl (%eax),%eax
80109f98:	0f b6 c0             	movzbl %al,%eax
80109f9b:	c1 e0 08             	shl    $0x8,%eax
80109f9e:	89 c2                	mov    %eax,%edx
80109fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fa3:	01 c0                	add    %eax,%eax
80109fa5:	8d 48 01             	lea    0x1(%eax),%ecx
80109fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fab:	01 c8                	add    %ecx,%eax
80109fad:	0f b6 00             	movzbl (%eax),%eax
80109fb0:	0f b6 c0             	movzbl %al,%eax
80109fb3:	01 d0                	add    %edx,%eax
80109fb5:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
80109fb8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109fbc:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80109fc0:	7e c7                	jle    80109f89 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
80109fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109fc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
80109fc8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80109fcf:	eb 33                	jmp    8010a004 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109fd4:	01 c0                	add    %eax,%eax
80109fd6:	89 c2                	mov    %eax,%edx
80109fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fdb:	01 d0                	add    %edx,%eax
80109fdd:	0f b6 00             	movzbl (%eax),%eax
80109fe0:	0f b6 c0             	movzbl %al,%eax
80109fe3:	c1 e0 08             	shl    $0x8,%eax
80109fe6:	89 c2                	mov    %eax,%edx
80109fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109feb:	01 c0                	add    %eax,%eax
80109fed:	8d 48 01             	lea    0x1(%eax),%ecx
80109ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ff3:	01 c8                	add    %ecx,%eax
80109ff5:	0f b6 00             	movzbl (%eax),%eax
80109ff8:	0f b6 c0             	movzbl %al,%eax
80109ffb:	01 d0                	add    %edx,%eax
80109ffd:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a000:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a004:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a008:	0f b7 c0             	movzwl %ax,%eax
8010a00b:	83 ec 0c             	sub    $0xc,%esp
8010a00e:	50                   	push   %eax
8010a00f:	e8 11 f6 ff ff       	call   80109625 <N2H_ushort>
8010a014:	83 c4 10             	add    $0x10,%esp
8010a017:	66 d1 e8             	shr    $1,%ax
8010a01a:	0f b7 c0             	movzwl %ax,%eax
8010a01d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a020:	7c af                	jl     80109fd1 <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a022:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a025:	c1 e8 10             	shr    $0x10,%eax
8010a028:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a02b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a02e:	f7 d0                	not    %eax
}
8010a030:	c9                   	leave
8010a031:	c3                   	ret

8010a032 <tcp_fin>:

void tcp_fin(){
8010a032:	55                   	push   %ebp
8010a033:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a035:	c7 05 68 70 19 80 01 	movl   $0x1,0x80197068
8010a03c:	00 00 00 
}
8010a03f:	90                   	nop
8010a040:	5d                   	pop    %ebp
8010a041:	c3                   	ret

8010a042 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a042:	55                   	push   %ebp
8010a043:	89 e5                	mov    %esp,%ebp
8010a045:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a048:	8b 45 10             	mov    0x10(%ebp),%eax
8010a04b:	83 ec 04             	sub    $0x4,%esp
8010a04e:	6a 00                	push   $0x0
8010a050:	68 8b c1 10 80       	push   $0x8010c18b
8010a055:	50                   	push   %eax
8010a056:	e8 65 00 00 00       	call   8010a0c0 <http_strcpy>
8010a05b:	83 c4 10             	add    $0x10,%esp
8010a05e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a061:	8b 45 10             	mov    0x10(%ebp),%eax
8010a064:	83 ec 04             	sub    $0x4,%esp
8010a067:	ff 75 f4             	push   -0xc(%ebp)
8010a06a:	68 9e c1 10 80       	push   $0x8010c19e
8010a06f:	50                   	push   %eax
8010a070:	e8 4b 00 00 00       	call   8010a0c0 <http_strcpy>
8010a075:	83 c4 10             	add    $0x10,%esp
8010a078:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a07b:	8b 45 10             	mov    0x10(%ebp),%eax
8010a07e:	83 ec 04             	sub    $0x4,%esp
8010a081:	ff 75 f4             	push   -0xc(%ebp)
8010a084:	68 b9 c1 10 80       	push   $0x8010c1b9
8010a089:	50                   	push   %eax
8010a08a:	e8 31 00 00 00       	call   8010a0c0 <http_strcpy>
8010a08f:	83 c4 10             	add    $0x10,%esp
8010a092:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a095:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a098:	83 e0 01             	and    $0x1,%eax
8010a09b:	85 c0                	test   %eax,%eax
8010a09d:	74 11                	je     8010a0b0 <http_proc+0x6e>
    char *payload = (char *)send;
8010a09f:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a0a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a0a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0ab:	01 d0                	add    %edx,%eax
8010a0ad:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a0b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a0b3:	8b 45 14             	mov    0x14(%ebp),%eax
8010a0b6:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a0b8:	e8 75 ff ff ff       	call   8010a032 <tcp_fin>
}
8010a0bd:	90                   	nop
8010a0be:	c9                   	leave
8010a0bf:	c3                   	ret

8010a0c0 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a0c0:	55                   	push   %ebp
8010a0c1:	89 e5                	mov    %esp,%ebp
8010a0c3:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a0c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a0cd:	eb 20                	jmp    8010a0ef <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a0cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a0d2:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a0d5:	01 d0                	add    %edx,%eax
8010a0d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a0da:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a0dd:	01 ca                	add    %ecx,%edx
8010a0df:	89 d1                	mov    %edx,%ecx
8010a0e1:	8b 55 08             	mov    0x8(%ebp),%edx
8010a0e4:	01 ca                	add    %ecx,%edx
8010a0e6:	0f b6 00             	movzbl (%eax),%eax
8010a0e9:	88 02                	mov    %al,(%edx)
    i++;
8010a0eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a0ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a0f2:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a0f5:	01 d0                	add    %edx,%eax
8010a0f7:	0f b6 00             	movzbl (%eax),%eax
8010a0fa:	84 c0                	test   %al,%al
8010a0fc:	75 d1                	jne    8010a0cf <http_strcpy+0xf>
  }
  return i;
8010a0fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a101:	c9                   	leave
8010a102:	c3                   	ret

8010a103 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a103:	55                   	push   %ebp
8010a104:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a106:	c7 05 70 70 19 80 a2 	movl   $0x8010f5a2,0x80197070
8010a10d:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a110:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a115:	c1 e8 09             	shr    $0x9,%eax
8010a118:	a3 6c 70 19 80       	mov    %eax,0x8019706c
}
8010a11d:	90                   	nop
8010a11e:	5d                   	pop    %ebp
8010a11f:	c3                   	ret

8010a120 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a120:	55                   	push   %ebp
8010a121:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a123:	90                   	nop
8010a124:	5d                   	pop    %ebp
8010a125:	c3                   	ret

8010a126 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a126:	55                   	push   %ebp
8010a127:	89 e5                	mov    %esp,%ebp
8010a129:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a12c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a12f:	83 c0 0c             	add    $0xc,%eax
8010a132:	83 ec 0c             	sub    $0xc,%esp
8010a135:	50                   	push   %eax
8010a136:	e8 7c a7 ff ff       	call   801048b7 <holdingsleep>
8010a13b:	83 c4 10             	add    $0x10,%esp
8010a13e:	85 c0                	test   %eax,%eax
8010a140:	75 0d                	jne    8010a14f <iderw+0x29>
    panic("iderw: buf not locked");
8010a142:	83 ec 0c             	sub    $0xc,%esp
8010a145:	68 ca c1 10 80       	push   $0x8010c1ca
8010a14a:	e8 5a 64 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a14f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a152:	8b 00                	mov    (%eax),%eax
8010a154:	83 e0 06             	and    $0x6,%eax
8010a157:	83 f8 02             	cmp    $0x2,%eax
8010a15a:	75 0d                	jne    8010a169 <iderw+0x43>
    panic("iderw: nothing to do");
8010a15c:	83 ec 0c             	sub    $0xc,%esp
8010a15f:	68 e0 c1 10 80       	push   $0x8010c1e0
8010a164:	e8 40 64 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a169:	8b 45 08             	mov    0x8(%ebp),%eax
8010a16c:	8b 40 04             	mov    0x4(%eax),%eax
8010a16f:	83 f8 01             	cmp    $0x1,%eax
8010a172:	74 0d                	je     8010a181 <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a174:	83 ec 0c             	sub    $0xc,%esp
8010a177:	68 f5 c1 10 80       	push   $0x8010c1f5
8010a17c:	e8 28 64 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a181:	8b 45 08             	mov    0x8(%ebp),%eax
8010a184:	8b 40 08             	mov    0x8(%eax),%eax
8010a187:	8b 15 6c 70 19 80    	mov    0x8019706c,%edx
8010a18d:	39 d0                	cmp    %edx,%eax
8010a18f:	72 0d                	jb     8010a19e <iderw+0x78>
    panic("iderw: block out of range");
8010a191:	83 ec 0c             	sub    $0xc,%esp
8010a194:	68 13 c2 10 80       	push   $0x8010c213
8010a199:	e8 0b 64 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a19e:	8b 15 70 70 19 80    	mov    0x80197070,%edx
8010a1a4:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1a7:	8b 40 08             	mov    0x8(%eax),%eax
8010a1aa:	c1 e0 09             	shl    $0x9,%eax
8010a1ad:	01 d0                	add    %edx,%eax
8010a1af:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a1b2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1b5:	8b 00                	mov    (%eax),%eax
8010a1b7:	83 e0 04             	and    $0x4,%eax
8010a1ba:	85 c0                	test   %eax,%eax
8010a1bc:	74 2b                	je     8010a1e9 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a1be:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1c1:	8b 00                	mov    (%eax),%eax
8010a1c3:	83 e0 fb             	and    $0xfffffffb,%eax
8010a1c6:	89 c2                	mov    %eax,%edx
8010a1c8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1cb:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a1cd:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1d0:	83 c0 5c             	add    $0x5c,%eax
8010a1d3:	83 ec 04             	sub    $0x4,%esp
8010a1d6:	68 00 02 00 00       	push   $0x200
8010a1db:	50                   	push   %eax
8010a1dc:	ff 75 f4             	push   -0xc(%ebp)
8010a1df:	e8 99 aa ff ff       	call   80104c7d <memmove>
8010a1e4:	83 c4 10             	add    $0x10,%esp
8010a1e7:	eb 1a                	jmp    8010a203 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a1e9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1ec:	83 c0 5c             	add    $0x5c,%eax
8010a1ef:	83 ec 04             	sub    $0x4,%esp
8010a1f2:	68 00 02 00 00       	push   $0x200
8010a1f7:	ff 75 f4             	push   -0xc(%ebp)
8010a1fa:	50                   	push   %eax
8010a1fb:	e8 7d aa ff ff       	call   80104c7d <memmove>
8010a200:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a203:	8b 45 08             	mov    0x8(%ebp),%eax
8010a206:	8b 00                	mov    (%eax),%eax
8010a208:	83 c8 02             	or     $0x2,%eax
8010a20b:	89 c2                	mov    %eax,%edx
8010a20d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a210:	89 10                	mov    %edx,(%eax)
}
8010a212:	90                   	nop
8010a213:	c9                   	leave
8010a214:	c3                   	ret
