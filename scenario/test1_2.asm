.data
	Switch: .word 0xfffffc00
	Led: .word 0xfffffc10
.text
	addi s5, x0, 0
	addi s6, x0, 255
	lui t2, 0x1
    lui t0, 0xfffff
    addi t0, t0, -1024
    add t0, t0, t2
    lui t1, 0xfffff
    addi t1, t1, -1008
    add t1, t1, t2
b0_001:
	addi t2, t0, 4
	lb t3, 0(t2) # read a
	# bind t3 to VGA or other displayer
	addi s1, t1, 4
	sw t3, 0(s1)