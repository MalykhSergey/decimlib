  SECTION .text:CODE

  EXPORT decimator_nx_bufferless
decimator_nx_bufferless
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
  sub lr, r6
  mov r6, #0
  str r6, [r0, #20] // save that remainder is used
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
  str r3, [r0, #20] // save remainder_size
  mov r4,  #0
save_buffer_loop_by_8
  subs r3, #8
  bcc save_buffer_loop_by_1_init
  ldm r1!, {r5-r12}
  add r4, r5
  add r4, r6
  add r4, r7
  add r4, r8
  add r4, r9
  add r4, r10
  add r4, r11
  add r4, r12
  bneq save_buffer_loop_by_8
  b return
  
save_buffer_loop_by_1_init
  add r3, #8
save_buffer_loop_by_1
  ldr r5, [r1], #4
  add r4, r5
  subs r3, #1
  bneq save_buffer_loop_by_1
  
return
  str r4, [r0, #12]
  pop {r1-r12,lr, r0} // count of sums
  bx lr

save_return
  str r4, [r2], #4
  str r3, [r0, #12] // save 0 to sum
  pop {r1-r12,lr,r0}
  bx lr
  END
  .END
