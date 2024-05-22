.data
    Switch: .word 0xfffffc00
    Led: .word 0xfffffc10
    Audio: .word 0xfffffe00
    Melody: .string "0101011011001100100000000101011011001100100100000101011011001100011101010110000010011000000001010110110011001000000001010110110011001001000010001001101100001001000000000101011011001100100000001100110111001100100100000101011011001100000011101100111000000101011011001100100000000110010101011011000001111000\000"

.text

main:
	addi s5, x0, 0
	addi s6, x0, 255
	lui s1, 0x1

    # switch init
    lui t0, 0xfffff
    addi t0, t0, -1024
    add t0, t0, s1

    # led init
    lui t1, 0xfffff
    addi t1, t1, -1008
    add t1, t1, s1

    # audio init
    lui t2, 0xfffff
    addi t2, t2, -512
    add t2, t2, s1
    
    # melody init
    la t3, Melody

loop:
    # check (null terminator)
    lbu t1, 0(t3)
    beqz t1, exit_loop  # if t1 == 0, exit loop

    lw a0, 0(t3)
    sw a0, 0(t2)

    # next note
    addi t3, t3, 4

    j loop
    
exit_loop:
