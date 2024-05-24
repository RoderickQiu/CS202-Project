.data
    Audio: .word 0xfffffd00
    Melody: .word 8, 0, 9, 0, 7, 0, 8, 0, 5, 0, 6, 0, 3, 0, 0, 0, 8, 0, 9, 0, 5, 0, 8, 0, 5, 0, 6, 0, 3, 0, 1, 0, 1, 0, 8, 0, 8, 0, 6, 0, 8, 0, 9, 0, 10, 0, 8, 0, 0, 0, 2, 0, 3, 0, 4, 0, 8, 0, 7, 0, 6, 0, 5, 0, 0, 0, 8, 0, 9, 0, 7, 0, 8, 0, 5, 0, 6, 0, 3, 0, 8, 0, 9, 0, 7, 0, 8, 0, 5, 0, 6, 0, 3, 0, 1, 0, 8, 0, 6, 0, 8, 0, 9, 0, 10, 0, 5, 0, 8, 0, 0, 0, 8, 0, 8, 0, 8, 0, 9, 0, 6, 0, 7, 0, 8, 0, 15

.text
main:
    lui s1, 0x1
    addi t4, zero, 15

    # audio init
    lui t2, 0xfffff
    addi t2, t2, -768
    add t2, t2, s1
    
    # melody init
    addi t3, zero, 4

loop:
    # check (null terminator)
    lw t1, 0(t3)
    beq t1, t4, exit_loop  # if t1 == 15, exit loop

    lw a0, 0(t3)
    sw a0, 0(t2)

    # next note
    addi t3, t3, 4
    addi t2, t2, 4

    j loop
    
exit_loop:
