  SECTION .text:CODE

  EXPORT summer_5x
summer_5x
  // Sum of lengths of input and buffer should be >= 5+8
  // r1 - in array
  // r2 - out array
  // r3 - array length (n)
  // r4 - sum
  // r5 - buffer
  // r6 - buffer_size
  // lr - decim_count
  push {r1-r12, lr, r0}
  ldm   r0, {r1-r4,r5}
  
sum_remainder
  ldm r5!, {r0,r3,r6-r8}
  ldm r1!, {r9-r12, lr}
  sub r4, r0
  add r4, r9
  str r4, [r2], #4

  sub r4, r3
  add r4, r10
  str r4, [r2], #4

  sub r4, r6
  add r4, r11
  str r4, [r2], #4

  sub r4, r7
  add r4, r12
  str r4, [r2], #4

  sub r4, r8
  add r4, lr
  str r4, [r2], #4

  ldr r0, [sp]
  ldr r3, [r0, #8] // load input size
  subs r3, #5
  ldr r0, [r0] // load start of input buffer
loop
  ldm r0!, {r5-r8}
  ldm r1!, {r9-r12}
  
  sub r4,r5
  add r4, r9
  str r4, [r2], #4
  
  sub r4,r6
  add r4, r10
  str r4, [r2], #4
  
  sub r4,r7
  add r4, r11
  str r4, [r2], #4
  
  sub r4,r8
  add r4, r12
  str r4, [r2], #4
  
  ldm r0!, {r5-r8}
  ldm r1!, {r9-r12}
  
  sub r4,r5
  add r4, r9
  str r4, [r2], #4
  
  sub r4,r6
  add r4, r10
  str r4, [r2], #4
  
  sub r4,r7
  add r4, r11
  str r4, [r2], #4
  
  sub r4,r8
  add r4, r12
  str r4, [r2], #4

  subs r3, #8
  beq save_return_init
  subs r5, r3, #8
  bcc end_sum_loop
  b loop

save_return_init
  mov r1, r0
  pop {r0}
  str r4, [r0, #12]  // sum
  ldr r5, [r0, #16]  // buffer
  ldr lr, [r0, #20]  // buffer_size
save_return  
  ldm r1, {r6-r10}
  stm r5, {r6-r10}
  pop {r1-r12,lr}
  ldr r0, [r0, #8]
  bx lr

end_sum_loop
  ldr r7, [r0], #4
  ldr r8, [r1], #4
  sub r4, r7
  add r4, r8
  str r4, [r2], #4
  subs r3, #1
  beq save_return_init
  b end_sum_loop
  
  END
  .END