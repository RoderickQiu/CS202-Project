`define ALU_CTRL_ADD 4'b0010
`define ALU_CTRL_SUB 4'b0110
`define ALU_CTRL_AND 4'b0000
`define ALU_CTRL_OR 4'b0001
`define ALU_CTRL_LUI 4'b0111
`define ALU_CTRL_AUIPC 4'b0101

`define ALU_OP_LW 3'b000
`define ALU_OP_SW 3'b000
`define ALU_OP_BEQ 3'b001
`define ALU_OP_R 3'b010
`define ALU_OP_LUI 3'b011
`define ALU_OP_AUIPC 3'b100

`define R_TYPE 7'b0110011
`define I_TYPE_1 7'b0010011
`define I_TYPE_2 7'b0000011
`define S_TYPE 7'b0100011
`define B_TYPE 7'b1100011
`define U_TYPE_LUI 7'b0110111
`define U_TYPE_AUIPC 7'b0010111
`define ECALL 7'b1110011
