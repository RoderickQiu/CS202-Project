.text
main:
    addi t3, x0, -1
    li a7, 5
    ecall
    addi t4, a0, 1
    addi t5, zero, 0 #i
    addi t6, zero, 0 #ans
    loop:
    	addi t5, t5, 1
    	addi a0, t5, 0
    	jal solve
    	slt a2, a0, t4
    	sgt a3, a0, t2
    	and a4, a2, a3
    	add t6, t6, a4
    	bnez a2, loopt5
    addi a0, a6, 0
    li a7, 1
    ecall
solve:
    addi sp, sp, -12
    addi a6, a6, 3
    sw ra, 4(sp)
    sw a0, 0(sp)
    slti t0, a0, 2
    beq t0, zero, L1 # >=2 further process
    addi a0, zero, 1
    addi sp, sp, 12
    addi a6, a6, 3
    jr ra
L1:
    addi a0, a0, -1 # f(n-1)
    jal solve # call
    sw a0, 8(sp) # store f(n-1)
    lw a0, 0(sp)  #get n from memory
    addi a0, a0, -2 #f(n-2)
    jal solve #call
    lw t1, 8(sp) #get f(n-1) from memory
    add a0, a0, t1 #f(n)=f(n-1)+f(n-2)
    lw ra, 4(sp) #load ra from memory
    addi sp, sp, 12
    addi a6, a6, 3
    jr ra
    