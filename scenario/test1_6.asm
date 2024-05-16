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
    #la a0, Switch
    #la a1, Led
    #lw t0, 0(a0)
    #lw t1, 0(a1)
    #t0 the address of Switch 
    #t1 the address of Led
    
	addi t2, t0, 8
	lw t3, 0(t2) # read a and b
	srli t4, t3, 8
	andi t3, t3, 255
	addi s1, t1, 4
	bge t3, t4, led_1_1
	led_1_0:
		sw s5, 0(s1) # LED = dark
		j next_1
	led_1_1:
		sw s6, 0(s1) # LED = light
	next_1:	