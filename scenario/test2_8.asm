.data
	array: .space 5000
.text
main:
    lui t2, 0x1
    lui s0, 0xfffff
    addi s0, s0, -1024
    add s0, s0, t2
    lui s1, 0xfffff
    addi s1, s1, -1008
    add s1, s1, t2
Calc8:
	la a6, array
    addi a0, x0, 0
    addi t3, a0, -1
    lw t4, 0(s0)
    addi t4, t4, 1

    addi t5, zero, 0 #i
    addi t6, zero, 0 #ans
    loop_8:
    	addi t5, t5, 1
    	addi a0, t5, 0
    	jal solve_8
    	slt a2, a0, t4
    	sgt a3, a0, t2
    	and a4, a2, a3
    	add t6, t6, a4
    	bnez a2, loop_8
    
output_8: # many data stored in array end point = a6 start point = la array
#TODO
    li a7, 10
    ecall
solve_8:
    addi sp, sp, -12
    sw ra, 4(sp)

    sw a0, 0(a6)
    addi a6, a6, 4

    sw a0, 0(sp)
    slti t0, a0, 2
    beq t0, zero, L1_8 # >=2 further process
    addi a0, zero, 1
    addi sp, sp, 12
    jr ra
L1_8:
    addi a0, a0, -1 # f(n-1)
    jal solve_8 # call
    sw a0, 8(sp) # store f(n-1)

    sw a0, 0(a6)
    addi a6, a6, 4

    lw a0, 0(sp)  #get n from memory
    addi a0, a0, -2 #f(n-2)
    jal solve_8 #call
    lw t1, 8(sp) #get f(n-1) from memory
    add a0, a0, t1 #f(n)=f(n-1)+f(n-2)
    lw ra, 4(sp) #load ra from memory
    addi sp, sp, 12
    jr ra
    