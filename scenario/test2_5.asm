.data
	Switch: .word 0xfffffc00
	Led: .word 0xfffffc10
.text
	lui t2, 0x1
    lui s0, 0xfffff
    addi s0, s0, -1024
    add s0, s0, t2
    lui s1, 0xfffff
    addi s1, s1, -1008
    add s1, s1, t2
	
Calc5:
 	addi s2, s0, 8
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
 	addi s2, s1, 0
	sw a0, 0(s2)