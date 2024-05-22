#Test2_0: input: 001:8bit right signed     output: 110:8bit_right
#Test2_1:input:  110:16bit unsigned  output: 110:8bit_right
#Test2_2:input:  110:16bit unsigned output: 110:8bit_right
#Test2_3:input:  110:16bit unsigned  output: 110:8bit_right
#Test2_4:input:  110:16bit unsigne output: 110:16bit unsigned 
#Test2_5:input: 111:12bit unsigned output: 111:12bit_res
#Test2_6:input:  16bit unsigned  output: 110:8bit_right
#Test2_7:input:  16bit unsigned  output: 110:8bit_right
.data
	array: .space 5000
.text
	lui t2, 0x1
    lui t0, 0xfffff
    addi t0, t0, -1024
    add t0, t0, t2
    lui t1, 0xfffff
    addi t1, t1, -992
    add t1, t1, t2
    addi s10, t0, 256
    
    lw s9, 16(t0)
    srli s9, s9, 21 # the index of testcase
    beq s9, x0, T1
    addi s9, s9, -1
    beq s9, x0, T2
    addi s9, s9, -1
    beq s9, x0, T3
    addi s9, s9, -1
    beq s9, x0, T4
    addi s9, s9, -1
    beq s9, x0, T5
    addi s9, s9, -1
    beq s9, x0, T6
    addi s9, s9, -1
    beq s9, x0, T7
    addi s9, s9, -1
    beq s9, x0, T8
T1:
	Calc1:
 		addi t2, t0, 4
		lw t3, 0(t2) # read a
		addi a0, x0, 0 # ans
		addi a1, x0, 128 # standard
		addi a2, x0, 1
	loop1:
		bge t3, a1, end1
		addi a0, a0, 1
		beq a1, a2, end1
		srli a1, a1, 1
		j loop1
	end1:
		addi s1, t1, 24
		sw a0, 0(s1)
	j end
T2:
	Calc2:
 		addi t2, t0, 24
		lw t3, 0(t2) # read
		lui a0, 0x8
		lui a1, 0x8
		addi a1, a1, -1024
		addi a2, x0, 1023
		and a0, a0, t3 # S
		srli a0, a0, 15
		and a1, a1, t3 # Exponent
		srli a1, a1, 10
		and a2, a2, t3 # Fraction
		addi a2, a2, 1024 # add abbreviatory 1
		addi a1, a1, -15 # deduct bias
		bge a1, x0, positive_exp_2
	negative_exp_2:
		sub a1, x0, a1
		srl a2, a2, a1
		addi a4, x0, 10
		srl a2, a2, a4 
		j end_2
	positive_exp_2:
		sll a2, a2, a1
		addi a4, x0, 10
		srl a2, a2, a4
	end_2:
		bne a0, x0, output_2
	add1_2:
		addi a2, a2, 1
	output_2:
		add a0, x0, a2
		addi s1, t1, 24
		sw a0, 0(s1)
	j end
T3:
	Calc3:
 		addi t2, t0, 24
		lw t3, 0(t2) # read
		lui a0, 0x8
		lui a1, 0x8
		addi a1, a1, -1024
		addi a2, x0, 1023
		and a0, a0, t3 # S
		srli a0, a0, 15
		and a1, a1, t3 # Exponent
		srli a1, a1, 10
		and a2, a2, t3 # Fraction
		addi a2, a2, 1024 # add abbreviatory 1
		addi a1, a1, -15 # deduct bias
		bge a1, x0, positive_exp_3
	negative_exp_3:
		sub a1, x0, a1
		srl a2, a2, a1
		addi a4, x0, 10
		srl a2, a2, a4 
		j end_3
	positive_exp_3:
		sll a2, a2, a1
		addi a4, x0, 10
		srl a2, a2, a4
	end_3:
		beq a0, x0, output_3
	add1_3:
		addi a2, a2, 1
	output_3:
		add a0, x0, a2
		addi s1, t1, 24
		sw a0, 0(s1)
	j end
T4:
	Calc4:
 		addi t2, t0, 24
		lw t3, 0(t2) # read
		lui a0, 0x8
		lui a1, 0x8
		addi a1, a1, -1024
		addi a2, x0, 1023
		and a0, a0, t3 # S
		srli a0, a0, 15
		and a1, a1, t3 # Exponent
		srli a1, a1, 10
		and a2, a2, t3 # Fraction
		addi a2, a2, 1024 # add abbreviatory 1
		addi a1, a1, -15 # deduct bias
		bge a1, x0, positive_exp_4
	negative_exp_4:
		sub a1, x0, a1
		srl a2, a2, a1
		addi a4, x0, 10
		srl a2, a2, a4 
		j end_4
	positive_exp_4:
		sll a2, a2, a1
		addi a4, x0, 9
		srl a2, a2, a4
		addi a0, x0, 1
		and a0, a2, a0
		addi a4, x0, 1
		srl a2, a2, a4
	end_4:
		beq a0, x0, output_4
	add1_4:
		addi a2, a2, 1
	output_4:
		add a0, x0, a2
		addi s1, t1, 24
		sw a0, 0(s1)	
	j end
T5:
	addi s0, t0, 0
	addi s1, t1, 0
	Calc5:
 		addi s2, s0, 24
		lw t0, 0(s2) # read a and b
		srli t1, t0, 8
		andi t0, t0, 255
 		add t2, t0, t1
 		addi t3, x0, 256
 		and t3, t2, t3
 		andi t2, t2, 255
 		beq t3, x0, output_5
 		addi t2, t2, 1
 	output_5:
 		xori t2, t2, 255
 		add a0, x0, t2
 		addi s2, s1, 24
		sw a0, 0(s2)
	j end
T6:
	addi s0, t0, 0
	addi s1, t1, 0
	addi s2, s0, 28
	lw t0, 0(s2) # read a and b
	sw t0, 28(s1) # write a to Led
	j end
T7:
	addi s0, t0, 0
	addi s1, t1, 0
	Calc7:
    	addi t3, x0, -1
    	lw t4, 24(s0)
    	addi t4, t4, 1
    	addi t5, zero, 0 #i
    	addi t6, zero, 0 #ans
    loop_7:
    	addi t5, t5, 1
    	addi a0, t5, 0
    	jal solve_7
    	slt a2, a0, t4
    	sgt a3, a0, t2
    	and a4, a2, a3
    	add t6, t6, a4
    	bnez a2, loop_7
    addi a0, a6, 0
    sw a0, 24(s1)
    j end
solve_7:
    addi sp, sp, -12
    addi a6, a6, 3
    sw ra, 4(sp)
    sw a0, 0(sp)
    slti t0, a0, 2
    beq t0, zero, L1_7 # >=2 further process
    addi a0, zero, 1
    addi sp, sp, 12
    addi a6, a6, 3
    jr ra
L1_7:
    addi a0, a0, -1 # f(n-1)
    jal solve_7 # call
    sw a0, 8(sp) # store f(n-1)
    lw a0, 0(sp)  #get n from memory
    addi a0, a0, -2 #f(n-2)
    jal solve_7 #call
    lw t1, 8(sp) #get f(n-1) from memory
    add a0, a0, t1 #f(n)=f(n-1)+f(n-2)
    lw ra, 4(sp) #load ra from memory
    addi sp, sp, 12
    addi a6, a6, 3
    jr ra
    
T8:
	addi s0, t0, 0
	addi s1, t1, 0
	Calc8:
		addi a6, s10, 0
    	addi a0, x0, 0
    	addi t3, a0, -1
    	lw t4, 24(s0)
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
    j end
    
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
end: