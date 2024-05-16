#switch: 00:all
#        01:8bit
#        10:16bit
#        10:16bit_signed
#        11:12bit
#led:    00:all
#        01:8bit_left
#        10:8bit_right
#        11:12bit_res
.data
	Switch: .word 0xfffffc00
	Led: .word 0xfffffc10
.text
Calc:
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
	bge a1, x0, positive_exp
negative_exp:
	sub a1, x0, a1
	srl a2, a2, a1
	addi a4, x0, 10
	srl a2, a2, a4 
	j end
positive_exp:
	sll a2, a2, a1
	addi a4, x0, 10
	srl a2, a2, a4
end:
	bne a0, x0, output
add1:
	addi a2, a2, 1
output:
	add a0, x0, a2
	addi s1, t1, 4
	sw a0, 0(s1)