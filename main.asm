.include beta.uasm

CMOVE(stack__, SP)      |; Initialize stack pointer (SP) 
MOVE(SP, BP)            |; Initialize base of frame pointer (BP)
BR(main)                |; Go to 'main' code segment

.include util.asm
.include heapsort.asm
.include introsort.asm

ARRAY_SIZE = 10

array_size: 
  LONG(ARRAY_SIZE)

array:
  STORAGE(ARRAY_SIZE)   |; Reserve space for storage

main:
  CMOVE(array, R1)      |; Reg[R1] <- Address of array[0]
  LDR(array_size, R2)   |; Reg[R2] <- Array size
  PUSH(R2) PUSH(R1)     |; Last-argument-pushed-first (LAPF) convention
  CALL(fill)
  CALL(shuffle)
  CALL(sort, 2)         |; You must implement sort
.breakpoint             |; Use .breakpoint instruction to debug
  HALT()

  LONG(0xDEADCAFE)       |; 0xDEADCAFE constant indicates the base of the stack
stack__:
  STORAGE(1024)