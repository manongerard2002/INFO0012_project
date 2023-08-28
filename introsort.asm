|; void sort(int* array, int size)
|;   @param array A pointer to the array
|;   @param size Size of the array 
sort:
  PUSH(LP) PUSH(BP)  |; Save and update LP and BP
  MOVE(SP, BP)

  PUSH(R1)           |; Save registers
  PUSH(R2)

  LD(BP, -12, R1)    |; Reg[R1] <- array
  LD(BP, -16, R2)    |; Reg[R2] <- size
  
sort_if:
  CMPEQ(R2, R31, R0) |; size == 0
  BT(R0, sort_end)   |; if R0 =/= 0: (size == 0) -> jump to sort_end

  PUSH(R2)           |; Push parameter 1: size
  CALL(log2, 1)      |; Reg[R0] <- log2(size)
  MULC(R0, 2, R0)    |; Reg[R0] <- maxd = 2 * log2(size)

  PUSH(R0)           |; Push parameter 3: maxd
  PUSH(R2)           |; Push parameter 2: size
  PUSH(R1)           |; Push parameter 1: address of array
  CALL(introsort, 3) |; introsort(array, size, maxd);
  
sort_end:
  POP(R2)            |; Restore registers
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()


|; void introsort(int* array, int size, int maxd)
|;   @param array A pointer to the array
|;   @param size Size of the array
|;   @param maxd Maximum number of recursive calls
introsort:
  PUSH(LP) PUSH(BP)  |; Save and update LP and BP
  MOVE(SP, BP)

  PUSH(R1)           |; Save registers
  PUSH(R2)
  PUSH(R3)
  PUSH(R4)           |; pivot
  PUSH(R5)           |; i
  PUSH(R6)           |; l
  PUSH(R7)           |; r
  PUSH(R8)           |; array[i]
  PUSH(R9)           |; array + i
  PUSH(R10)          |; array + l or array + r

  LD(BP, -12, R1)    |; Reg[R1] <- array
  LD(BP, -16, R2)    |; Reg[R2] <- size
  LD(BP, -20, R3)    |; Reg[R3] <- maxd
  
introsort_while1:
  CMOVE(1, R0)
  CMPLT(R0, R2, R0)  |; 1 < size (size > 1)
  BF(R0, introsort_end) |; if R0 = 0: !(size > 1) -> jump to introsort_end

introsort_if1:
  CMPLE(R3, R31, R0) |; maxd <= 0
  BF(R0, introsort_afterif1) |; if R0 = 0: !(a < b) -> jump to introsort_afterif1

  PUSH(R2)           |; Push parameter 2: size
  PUSH(R1)           |; Push parameter 1: address of array
  CALL(heapsort, 2)  |; heapsort(array, size);

  BR(introsort_end)  |; return

introsort_afterif1:
  SUBC(R3, 1, R3)    |; maxd -= 1
  PUSH(R2)           |; Push parameter 2: size
  PUSH(R1)           |; Push parameter 1: address of array
  CALL(median3, 2)   |; median3(array, size);
  MOVE(R0, R4)       |; Reg[R4] <- pivot = median3(array, size)

  |; Three-way partition
  CMOVE(0, R5)       |; Reg[R5] <- i = 0
  CMOVE(0, R6)       |; Reg[R6] <- l = 0
  MOVE(R2, R7)       |; Reg[R7] <- r = size

introsort_while2:
  CMPLT(R5, R7, R0)  |; i < r
  BF(R0, introsort_afterwhile2) |; if R0 = 0: !(i < r) -> jump to introsort_afterwhile2

  ADDR(R1, R5, R9)   |; Reg[R9] <- array + i
  LD(R9, 0, R8)      |; Reg[R8] <- array[i]
  CMPLT(R8, R4, R0)  |; array[i] < pivot
  BF(R0, introsort_elseif) |; if R0 = 0: !(array[i] < pivot) -> jump to introsort_elseif

  |; array + i calculated higher
  ADDR(R1, R6, R10)  |; Reg[R10] <- array + l
  SWAP(R9, R10, R8, R0) |; swap(array + i, array + l);
  ADDC(R5, 1, R5)    |; i += 1
  ADDC(R6, 1, R6)    |; l += 1

  BR(introsort_while2)

introsort_elseif:
  ADDR(R1, R5, R9)   |; Reg[R9] <- array + i
  LD(R9, 0, R8)      |; Reg[R8] <- array[i]
  CMPLT(R4, R8, R0)  |; pivot < array[i] (array[i] > pivot)
  BF(R0, introsort_else) |; if R0 = 0: !(array[i] > pivot) -> jump to introsort_else

  SUBC(R7, 1, R7)    |; r -= 1
  |; array + i calculated higher
  ADDR(R1, R7, R10)  |; Reg[R10] <- array + r
  SWAP(R9, R10, R8, R0) |; swap(array + i, array + r);

  BR(introsort_while2)

introsort_else:
  ADDC(R5, 1, R5)    |; i += 1
  BR(introsort_while2)

introsort_afterwhile2:
  PUSH(R3)           |; Push parameter 3: maxd
  PUSH(R6)           |; Push parameter 2: l
  PUSH(R1)           |; Push parameter 1: address of array
  CALL(introsort, 3) |; introsort(array, l, maxd)

  ADDR(R1, R7, R0)   |; Reg[R0] <- array + r
  MOVE(R0, R1)       |; array += r
  SUB(R2, R7, R2)    |; size -= r

  BR(introsort_while1)
  
introsort_end:
  POP(R10)           |; Restore registers
  POP(R9)
  POP(R8)
  POP(R7)
  POP(R6)
  POP(R5)
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()


|; tested for all case
|; void median3(int* array, int n)
|;   @param array A pointer to the array
|;   @param n Size of the array
median3:
  PUSH(LP) PUSH(BP)  |; Save and update LP and BP
  MOVE(SP, BP)

  PUSH(R1)           |; Save registers
  PUSH(R2)
  PUSH(R3)
  PUSH(R4)
  PUSH(R5)

  LD(BP, -12, R1)    |; Reg[R1] <- array
  LD(BP, -16, R2)    |; Reg[R2] <- size

  LDARR(R1, R31, R3) |; Reg[R3] <- a = array[0]
  DIVC(R2, 2, R0)   
  LDARR(R1, R0, R4)  |; Reg[R4] <- b = array[size / 2]
  SUBC(R2, 1, R0)
  LDARR(R1, R0, R5)  |; Reg[R5] <- c = array[size - 1]
  
median3_if:
  CMPLT(R3, R4, R0)  |; a < b
  BF(R0, median3_elseif) |; if R0 = 0: !(a < b) -> jump to median3_elseif

  CMPLT(R4, R5, R0)  |; b < c
  BT(R0, median3_b)  |; if R0 =/= 0: (b < c) -> return b

  CMPLT(R3, R5, R0)  |; a < c
  BT(R0, median3_c)  |; if R0 =/= 0: (a < c) -> return c
  BR(median3_a)

median3_elseif:
  CMPLT(R4, R5, R0)  |; b < c
  BF(R0, median3_else) |; if R0 = 0: !(b < c) -> jump to median3_else

  CMPLT(R3, R5, R0)  |; a < c
  BT(R0, median3_a)  |; if R0 =/= 0: (a < c) -> return a

  BR(median3_c)      |; else: return c

median3_else:
  BR(median3_b)      |; else: return b

median3_a:
  MOVE(R3, R0)
  BR(median3_end)

median3_b:
  MOVE(R4, R0)
  BR(median3_end)

median3_c:
  MOVE(R5, R0)
  
median3_end:
  POP(R5)            |; Restore registers
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()

