// (a-b)*3 + 2^c
.syntax unified
.cpu cortex-m4
.thumb
 
#define a #7
#define b #4
#define c #3
 
.global vtable_kernel
.global __kernel_reset__
 
.type vtable_kernel, %object
.type __kernel_reset__, %function
 
.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel
 
.section .rodata
    data:  .asciz "kernel started!\n"
    final: .asciz "Value in register #3: "
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
 
    // calculate
    mov r3, a
    mov r1, b
    mov r2, c
 
    //r3 = a - b
    sub r3, r1
 
    //r3 = (a - b) * 3
    mov r1, #3
    mul r3, r1
 
    //r4 = 2^c
   mov r4, #2
   pow:
    cmp r2, #1
    beq sum
    lsl r4, r4, #1
    sub r2, #1
    bne pow
    sum:
        //r3 = (a-b)*3 + 2^c (result)
    add r3, r4
 
    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num
 
    end:
    b end

