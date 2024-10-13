  SECTION .text:CODE

  EXPORT decimator_16x_bufferless
decimator_16x_bufferless
// Sum of lengths of input and buffer should be > decim_count!
  // Sum of lengths of input and buffer should be > decim_count!
  // r1 - in array
  // r2 - out array
  // r3 - array length (n)
  // r4 - sum
  // r5 - buffer
  // r6 - buffer_size
  // lr - decim_count
  push {r1-r12,lr}
  ldm   r0, {r1-r6, lr}
  add r7, r3, r6
  udiv r7, lr
  push {r7}  // save count sum  
  mov r10, #0
  str r10, [r0, #20] // save that remainder is used
  adds r6, #0
  beq loop
  sub lr, r6
sum_remainder
  ldr r7, [r1], #4
  add r4, r7
  sub r3, #1
  subs lr, #1
  bneq sum_remainder
  str r4, [r2], #4
  b loop_after_sum
loop
  ldm r1!, {r4-r12, lr}
  add r4, r5
  add r4, r6
  add r4, r7
  add r4, r8
  add r4, r9
  add r4, r10
  add r4, r11
  add r4, r12
  add r4, lr

  ldm r1!, {r5-r10}
  add r4, r5
  add r4, r6
  add r4, r7
  add r4, r8
  add r4, r9
  add r4, r10

  str r4, [r2], #4

  subs r3, #16
  beq save_return // reach end

loop_after_sum
  // if N < m then save_buffer
  subs r5, r3, #16
  bcc save_buffer
  b loop
  

// save remainder
save_buffer
  ldr r2, [r0, #16]
  str r3, [r0, #20]
  mov r4, #0
save_buffer_loop
  ldr r5, [r1], #4
  add r4, r5
  subs r3, #1
  bneq save_buffer_loop
  str r4, [r0, #12] // save sum
return  
  pop {r1-r12,lr, r0} // count of sums
  bx lr

save_return
  str r3, [r0, #12] // save sum is 0;
  pop {r1-r12,lr,r0}
  bx lr
  END
  .END
