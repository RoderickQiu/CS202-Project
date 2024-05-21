#switch:1111_1100_000x_xx00
#led:1111_1100_001x_xx00
#switch: 100:all unsigned
#        101:8bit mid signed
#        001:8bit right signed
#        110:16bit unsigned
#        111:12bit unsigned
#led:    100:16bit
#        101:8bit_mid
#        110:8bit_right
#        111:12bit_res.text
#Test1_0: input: 16bit unsigned     output: 100:all
#Test1_1:input: 110:16bit unsigned    output:100:16bit_right
#Test1_2:input: 110:16bit unsigned    output: 100:16bit_right
#Test1_3:input: mid signed and right signed.   output: 110:8bit_right
#Test1_4:input: mid signed and right signed.   output: 110:8bit_right
#Test1_5:input: mid signed and right signed.   output: 110:8bit_right
#Test1_6:input: 110:16bit unsigned   output: 110:8bit_right
#Test1_7:input: 110:16bit unsigned   output: 110:8bit_right
.text
	addi s5, x0, 0
	addi s6, x0, 255
	lui t2, 0x1
    lui t0, 0xfffff
    addi t0, t0, -1024
    add t0, t0, t2
    lui t1, 0xfffff
    addi t1, t1, -992
    add t1, t1, t2
    
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
	addi t2, t0, 24
	lw t3, 0(t2) # read a and b
	addi s1, t1, 16
	sw t3, 0(s1)
	j end
T2:
	addi t2, t0, 24
	lb t3, 0(t2) # read a
	# bind t3 to VGA or other displayer
	addi s1, t1, 16
	sw t3, 0(s1)
	j end
T3:
	addi t2, t0, 24
	lbu t3, 0(t2) # read a
	# bind t3 to VGA or other displayer
	addi s1, t1, 16
	sw t3, 0(s1)
	j end
T4:
	lw t3, 20(t0)
	lw t4, 4(t0)
	beq t3, t4, led_1_1
	led_1_0:
		sw s5, 24(t1) # LED = dark
		j next_1
	led_1_1:
		sw s6, 24(t1) # LED = light
	next_1:	
	j end
T5:
	lw t3, 20(t0)
	lw t4, 4(t0)
	blt t3, t4, led_2_1
	led_2_0:
		sw s5, 24(t1) # LED = dark
		j next_2
	led_2_1:
		sw s6, 24(t1) # LED = light
	next_2:	
	j end
T6:
	lw t3, 20(t0)
	lw t4, 4(t0)
	bge t3, t4, led_3_1
	led_3_0:
		sw s5, 24(t1) # LED = dark
		j next_3
	led_3_1:
		sw s6, 24(t1) # LED = light
	next_3:	
	j end
T7:
	addi t2, t0, 24
	lw t3, 0(t2) # read a and b
	srli t4, t3, 8
	andi t3, t3, 255
	bltu t3, t4, led_4_1
	led_4_0:
		sw s5, 24(t1) # LED = dark
		j next_4
	led_4_1:
		sw s6, 24(t1) # LED = light
	next_4:	
	j end
T8:
	addi t2, t0, 24
	lw t3, 0(t2) # read a and b
	srli t4, t3, 8
	andi t3, t3, 255
	bgeu t3, t4, led_5_1
	led_5_0:
		sw s5, 24(t1) # LED = dark
		j next_5
	led_5_1:
		sw s6, 24(t1) # LED = light
	next_5:
	j end	
end:
