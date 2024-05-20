.data
	Switch: .word 0xfffffc00
	Led: .word 0xfffffc10
.text
	lui t2, 0x1
    lui t0, 0xfffff
    addi t0, t0, -1024
    add t0, t0, t2
    lui t1, 0xfffff
    addi t1, t1, -1008
    add t1, t1, t2
	
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
	addi s1, t1, 4
	sw t3, 0(s1)