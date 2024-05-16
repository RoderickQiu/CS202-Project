.data
	Switch: .word 0xfffffc00
	Led: .word 0xfffffc10
.text
Calc:
 	li a7, 5
 	ecall
 	add t0, x0, a0
 	li a7, 5
 	ecall 
 	add t1, x0, a0
 	add t2, t0, t1
 	addi t3, x0, 256
 	and t3, t2, t3
 	andi t2, t2, 255
 	beq t3, x0, output
 	addi t2, t2, 1
 output:
 	xori t2, t2, 255
 	add a0, x0, t2
 	li a7, 1
 	ecall