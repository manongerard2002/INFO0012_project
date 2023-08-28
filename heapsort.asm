|; void heapsort(int* array, int size)
|;   @param array A pointer to the array
|;   @param size Size of the array
heapsort:
  PUSH(LP) PUSH(BP)  |; Save and update LP and BP
  MOVE(SP, BP)

  PUSH(R1)           |; Save registers
  PUSH(R2)
  PUSH(R3)
  PUSH(R4)           |; temporary storage
  PUSH(R5)

  LD(BP, -12, R1)    |; Reg[R1] <- array
  LD(BP, -16, R2)    |; Reg[R2] <- size

  MOVE(R2, R3)       |; Reg[R3] <- i = size
  DIVC(R3, 2, R3)    |; Reg[R3] <- i = size / 2
  SUBC(R3, 1, R3)    |; Reg[R3] <- i = (size / 2) - 1

heapsort_while1:
  CMPLE(R31, R3, R0) |; i >= 0 (0 <= i)
  BF(R0, heapsort_afterwhile1) |; if R0 = 0: !(i >= 0) -> jump to heapsort_afterwhile1

  PUSH(R3)           |; Push parameter 3: i
  PUSH(R2)           |; Push parameter 2: size
  PUSH(R1)           |; Push parameter 1: address of array
  CALL(heapify, 3)   |; heapify(array, size, i);

  SUBC(R3, 1, R3)    |; --i

  BR(heapsort_while1)

heapsort_afterwhile1:
  MOVE(R2, R3)       |; Reg[R3] <- i = size
  SUBC(R3, 1, R3)    |; Reg[R3] <- i = size - 1

heapsort_while2:
  CMPLT(R31, R3, R0) |; i > 0 (0 < i)
  BF(R0, heapsort_end) |; if R0 = 0: !(i > 0) -> jump to heapsort_end

  ADDR(R1, R3, R0)   |; array + i

  SWAP(R1, R0, R4, R5) |; swap(array, array + i);

  PUSH(R31)          |; Push parameter 3: 0
  PUSH(R3)           |; Push parameter 2: i
  PUSH(R1)           |; Push parameter 1: address of array
  CALL(heapify, 3)   |; heapify(array, i, 0);

  SUBC(R3, 1, R3)    |; --i
  BR(heapsort_while2)

heapsort_end:
  POP(R5)            |; Restore registers
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()


|; void heapify(int* array, int size, int index)
|;   @param array A pointer to the array
|;   @param size Size of the array
|;   @param index Index of the array
heapify:
  PUSH(LP) PUSH(BP)  |; Save and update LP and BP
  MOVE(SP, BP)

  PUSH(R1)           |; Save registers
  PUSH(R2)
  PUSH(R3)
  PUSH(R4)           |; largest
  PUSH(R5)           |; left
  PUSH(R6)           |; right

  PUSH(R7)           |; array[largest]

  LD(BP, -12, R1)    |; Reg[R1] <- array
  LD(BP, -16, R2)    |; Reg[R2] <- size
  LD(BP, -20, R3)    |; Reg[R3] <- index

heapify_while:
  CMPLT(R3, R2, R0)  |; index < size
  BF(R0, heapify_end) |; if R0 = 0: !(index < size) -> jump to heapsort_end

  MOVE(R3, R4)       |; largest = index

  MOVE(R3, R5)
  MULC(R5, 2, R5)
  ADDC(R5, 1, R5)    |; left = index * 2 + 1

  MOVE(R3, R6)
  ADDC(R6, 1, R6)
  MULC(R6, 2, R6)    |; right = (index + 1) * 2

heapify_if1_cond1:
  CMPLT(R5, R2, R0)  |; left < size
  BF(R0, heapify_if2_cond1) |; if R0 = 0: !(left < size) -> jump to heapsort_if2_cond1

heapify_if1_cond2:
  LDARR(R1, R4, R7)  |; array[largest]
  LDARR(R1, R5, R0)  |; array[left]

  CMPLT(R7, R0, R0)  |; array[largest] < array[left]
  BF(R0, heapify_if2_cond1) |; if R0 = 0: !(array[largest] < array[left]) -> jump to heapsort_if2_cond1
  MOVE(R5, R4)       |; largest = left

heapify_if2_cond1:
  CMPLT(R6, R2, R0)  |; right < size
  BF(R0, heapify_if3) |; if R0 = 0: !(right < size) -> jump to heapsort_if3

heapify_if2_cond2:
  LDARR(R1, R4, R7)  |; array[largest]
  LDARR(R1, R6, R0)  |; array[right]

  CMPLT(R7, R0, R0)  |; array[largest] < array[right]
  BF(R0, heapify_if3) |; if R0 = 0: !(array[largest] < array[right]) -> jump to heapsort_if3
  MOVE(R6, R4)       |; largest = right

heapify_if3:
  CMPEQ(R4, R3, R0)  |; largest = index
  BT(R0, heapify_end) |; if R0 =/= 0: largest = index : else: break -> jump to heapify_end

  ADDR(R1, R4, R7)   |; array + largest
  ADDR(R1, R3, R0)   |; array + index

  SWAP(R7, R0, R5, R6) |; swap(array + largest, array + index) & R5, R6 values not needed anymore -> can be use for Rtmps
  MOVE(R4, R3)       |; index = largest
  BR(heapify_while)

heapify_end:
  POP(R7)            |; Restore registers
  POP(R6)
  POP(R5)
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()

