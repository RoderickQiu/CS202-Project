`include "define.v"

module instruction_control (
    input [6:0] opcode,
    output reg Branch,
    output reg Memread,
    output reg Memtoreg,
    output reg [3:0] ALUop,
    output reg Memwrite,
    output reg ALUSRC,
    output reg RegWrite
);

always @* begin
    case (opcode)
        `R_TYPE: begin
            ALUSRC = 1'b0;
            Memtoreg = 1'b0;
            RegWrite = 1'b1;
            Memread = 1'b0;
            Memwrite = 1'b0;
            Branch = 1'b0;
            ALUop = `ALU_OP_R;    
        end
        `I_TYPE_1: begin
            ALUSRC = 1'b1;
            Memtoreg = 1'b1;
            RegWrite = 1'b1;
            Memread = 1'b1;
            Memwrite = 1'b0;
            Branch = 1'b0;
            //ALUop = 
        end
        `I_TYPE_2: begin
            ALUSRC = 1'b1;
            Memtoreg = 1'b1;
            RegWrite = 1'b1;
            Memread = 1'b1;
            Memwrite = 1'b0;
            Branch = 1'b0;
            ALUop = `ALU_OP_LW;
        end
        `S_TYPE: begin
            ALUSRC = 1'b1;
            Memtoreg = 1'b0;
            RegWrite = 1'b0;
            Memread = 1'b0;
            Memwrite = 1'b1;
            Branch = 1'b0;
            ALUop = `ALU_OP_SW;
        end
        `B_TYPE: begin
            ALUSRC = 1'b0;
            Memtoreg = 1'b0;
            RegWrite = 1'b0;
            Memread = 1'b0;
            Memwrite = 1'b0;
            Branch = 1'b1;
            ALUop = `ALU_OP_BEQ;
        end
        `U_TYPE_LUI: begin
            ALUSRC = 1'b1;
            Memtoreg = 1'b0;
            RegWrite = 1'b1;
            Memread = 1'b0;
            Memwrite = 1'b0;
            Branch = 1'b0;
            ALUop = `ALU_OP_LUI;
        end
        `U_TYPE_AUIPC: begin
            //ToDo
        end
        `ECALL: begin
            //ToDo
        end
    endcase
end

endmodule