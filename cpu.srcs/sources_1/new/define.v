`define ALU_CTRL_AND 4'b0000
`define ALU_CTRL_OR 4'b0001
`define ALU_CTRL_ADD 4'b0010
`define ALU_CTRL_SLL 4'b0011
`define ALU_CTRL_SRL 4'b0100
`define ALU_CTRL_AUIPC 4'b0101
`define ALU_CTRL_SUB 4'b0110
`define ALU_CTRL_LUI 4'b0111
`define ALU_CTRL_ADD_SIGNED 4'b1000
`define ALU_CTRL_SUB_SIGNED 4'b1001
`define ALU_CTRL_XOR 4'b1010
`define ALU_CTRL_ECALL 4'b1011

`define ALU_OP_LW 4'b0000
`define ALU_OP_SW 4'b0000

`define seg_val_freq 200000 
`define seg_val_0 8'b1111_1100  
`define seg_val_1 8'b0110_0000   
`define seg_val_2 8'b1101_1010  
`define seg_val_3 8'b1111_0010  
`define seg_val_4 8'b0110_0110  
`define seg_val_5 8'b1011_0110  
`define seg_val_6 8'b1011_1110   
`define seg_val_7 8'b1110_0000  
`define seg_val_8 8'b1111_1110 
`define seg_val_9 8'b1111_0110   
`define seg_val_A 8'b1110_1110    
`define seg_val_B 8'b0011_1110 
`define seg_val_C 8'b1001_1100
`define seg_val_D 8'b0111_1010   
`define seg_val_E 8'b1001_1110  
`define seg_val_F 8'b1000_1110    

`define in_0 4'b0000     
`define in_1 4'b0001   
`define in_2 4'b0010  
`define in_3 4'b0011 
`define in_4 4'b0100      
`define in_5 4'b0101   
`define in_6 4'b0110   
`define in_7 4'b0111  
`define in_8 4'b1000   
`define in_9 4'b1001     
`define in_A 4'b1010   
`define in_B 4'b1011     
`define in_C 4'b1100 
`define in_D 4'b1101     
`define in_E 4'b1110  
`define in_F 4'b1111 

`define ALU_OP_B 4'b0001
`define ALU_OP_R 4'b0010
`define ALU_OP_LUI 4'b0011
`define ALU_OP_J 4'b0101
`define ALU_OP_I 4'b0111
`define ALU_OP_AUIPC 4'b0100
`define ALU_OP_ECALL 4'b1000

`define R_TYPE 7'b0110011
`define I_TYPE_1 7'b0010011
`define I_TYPE_2 7'b0000011
`define S_TYPE 7'b0100011
`define B_TYPE 7'b1100011
`define J_TYPE 7'b1101111
`define U_TYPE_LUI 7'b0110111
`define U_TYPE_AUIPC 7'b0010111
`define ECALL 7'b1110011


`define SWITCH_MEM 11'b1111_1100_000
`define LED_MEM 11'b1111_1100_001
`define SP_REG_INITIAL 14'b1111_1000_0000_00
`define DEB_DELAY 21'd1500000