  SECTION .text:CODE

  EXPORT decimator_nx
decimator_nx
  // Sum of lengths of input and buffer should be > decim_count!
  // r1 - in array
  // r2 - out array
  // r3 - array length (n)
  // r4 - sum (not saved in buffered functions)
  // r5 - buffer
  // r6 - buffer_size
  // lr - decim
  push {r1-r12,lr}
  ldm   r0, {r1-r6, lr}
  add r7, r3, r6
  udiv r7, lr
  push {r7}  // save count sum
  mov r4, #0
  adds r6, #0 // if has remainder from previous
  beq loop

sum_remainder_init
  str r4, [r0, #20] // save that remainder is used
sum_remainder
  ldr r7, [r5], #4
  add r4, r7
  subs lr, #1
  bneq skip_save
  str r4, [r2], #4
  mov r4, #0
  ldr lr, [r0, #24]
  b loop_after_sum
  
loop
  // if m < 8 then sum_slice
  subs r5, lr, #8
  bcc sum_slice
  ldm r1!, {r5-r12}
  add r4, r5
  add r4, r6
  add r4, r7
  add r4, r8
  add r4, r9
  add r4, r10
  add r4, r11
  add r4, r12
  subs r3, #8
  beq save_return // reach end
  subs lr, #8 
  beq out_result  // count = m
  
loop_after_sum
  // if N < m then save_buffer
  subs r5, r3, lr
  bcc save_buffer
  b loop
  
// when counts to next sum < 8
sum_slice
  subs r3, lr // check if elements is enough for sum (always enough - min length = 4+decim; in begin always r3>lr, after checks after at loop_after_sum)
  bneq sum_slice_loop // -> enough
  
sum_slice_loop_if_end // if enough but in the end
  ldr r5, [r1], #4
  add r4, r5
  subs lr, #1
  bneq sum_slice_loop_if_end
  b save_return
  
sum_slice_loop
  ldr r5, [r1], #4
  add r4, r5
  subs lr, #1
  bneq sum_slice_loop

out_result
  str r4, [r2], #4
  mov r4, #0
  ldr lr, [r0, #24]
  b loop_after_sum

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

skip_save
  subs r6, #1
  bneq sum_remainder
  b loop

save_return
  str r4, [r2], #4
  pop {r1-r12,lr,r0}
  bx lr
  END
  .END
