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
	
    #la a0, Switch
    #la a1, Led
    #lw t0, 0(a0)
    #lw t1, 0(a1)
    #t0 the address of Switch 
    #t1 the address of Led
Calc:
 	addi t2, t0, 4
	lw t3, 0(t2) # read a
	addi a0, x0, 0 # ans
	addi a1, x0, 128 # standard
	addi a2, x0, 1
loop:
	bge t3, a1, end
	addi a0, a0, 1
	beq a1, a2, end
	srli a1, a1, 1
	j loop
end:
	addi s1, t1, 4
	sw t3, 0(s1)