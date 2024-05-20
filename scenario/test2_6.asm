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
Calc6:
 	lui t2, 0x1
    lui s0, 0xfffff
    addi s0, s0, -1024
    add s0, s0, t2
    lui s1, 0xfffff
    addi s1, s1, -1008
    add s1, s1, t2
    #la a0, Switch
    #la a1, Led
    #lw s0, 0(a0)
    #lw s1, 0(a1)
    #s0 the address of Switch 
    #s1 the address of Led
	
 	
 	addi s2, s0, 12
	lw t0, 0(s2) # read a and b
	
	sw t0, 12(s1) # write a to Led