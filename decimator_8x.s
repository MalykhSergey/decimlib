  SECTION .text:CODE

  EXPORT decimator_8x
decimator_8x
  // Sum of lengths of input and buffer should be > decim_count!
  // r1 - in array
  // r2 - out array
  // r3 - array length (n)
  // r4 - sum (not saved in buffered functions)
  // r5 - buffer
  // r6 - buffer_size
  // lr - decim_count
  push {r1-r12,lr}
  ldm   r0, {r1-r6, lr}
  add r7, r3, r6
  udiv r7, lr
  push {r7}  // save count sum
  mov r4, #0
  adds r6, #0 // if has remainder from previous
  bneq sum_remainder_init
  
loop
  ldm r1!, {r4-r11}
  add r4, r5
  add r4, r6
  add r4, r7
  add r4, r8
  add r4, r9
  add r4, r10
  add r4, r11

  str r4, [r2], #4

  subs r3, #8
  beq save_return // reach end

loop_after_sum
  // if N < m then save_buffer
  subs r5, r3, #8
  bcc save_buffer
  b loop
  

// save remainder
save_buffer
  ldr r2, [r0, #16]
  str r3, [r0, #20]
save_buffer_loop
  ldr r4, [r1], #4
  str r4, [r2], #4
  subs r3, #1
  bneq save_buffer_loop

return
  pop {r1-r12,lr, r0} // count of sums
  bx lr

sum_remainder_init
  str r4, [r0, #20] // save that remainder is used
sum_remainder
  ldr r7, [r5], #4
  add r4, r7
  subs lr, #1
  bneq skip_save
  str r4, [r2], #4
  ldr lr, [r0, #24]
  b loop_after_sum

skip_save
  subs r6, #1
  bneq sum_remainder
switch_source
  ldr r7, [r1], #4
  add r4, r7
  sub r3, #1
  subs lr, #1
  bneq switch_source
  str r4, [r2], #4
  mov r4, #0
  b loop_after_sum
  
save_return
  pop {r1-r12,lr,r0}
  bx lr
  END
  .END
