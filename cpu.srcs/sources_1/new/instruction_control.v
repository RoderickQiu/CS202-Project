`include "define.v"

module instruction_control (
    input [6:0] opcode,
    input [2:0]funct3,
    input rst,
    input oi,
    output reg Branch,
    output reg Memread,
    output reg Memtoreg,
    output reg [3:0] ALUop,
    output reg Memwrite,
    output reg ALUSRC,
    output reg RegWrite,
    output reg OIread,
    output reg OIwrite,
    output reg Signed
);

    always @* begin
        if (!rst) begin
            case (opcode)
                `R_TYPE: begin
                    ALUSRC = 1'b0;
                    Memtoreg = 1'b0;
                    RegWrite = 1'b1;
                    Memread = 1'b0;
                    Memwrite = 1'b0;
                    OIread = 1'b0;
                    OIwrite = 1'b0;
                    Branch = 1'b0;
                    Signed=1'b0;
                    ALUop = `ALU_OP_R;
                end
                `I_TYPE_1: begin
                    ALUSRC   = 1'b1;
                    Memtoreg = 1'b1;
                    RegWrite = 1'b1;
                    Memread  = !oi;
                    Memwrite = 1'b0;
                    OIread   = oi;
                    OIwrite  = 1'b0;
                    Branch   = 1'b0;
                    Signed=1'b0;
                    //ALUop = 
                end
                `I_TYPE_2: begin
                    ALUSRC = 1'b1;
                    Memtoreg = 1'b1;
                    RegWrite = 1'b1;
                    Memread = !oi;
                    Memwrite = 1'b0;
                    OIread = oi;
                    OIwrite = 1'b0;
                    Branch = 1'b0;
                    Signed=funct3==3'b100 ? 1'b1 :1'b0;
                    ALUop = `ALU_OP_LW;
                end
                `S_TYPE: begin
                    ALUSRC = 1'b1;
                    Memtoreg = 1'b0;
                    RegWrite = 1'b0;
                    Memread = 1'b0;
                    Memwrite = 1'b1;
                    OIread = 1'b0;
                    OIwrite = oi;
                    Branch = 1'b0;
                    Signed=1'b0;
                    ALUop = `ALU_OP_SW;
                end
                `B_TYPE: begin
                    ALUSRC = 1'b0;
                    Memtoreg = 1'b0;
                    RegWrite = 1'b0;
                    Memread = 1'b0;
                    Memwrite = 1'b0;
                    OIread = 1'b0;
                    OIwrite = 1'b0;
                    Branch = 1'b1;
                    Signed=1'b0;
                    ALUop = `ALU_OP_BEQ;
                end
                `U_TYPE_LUI: begin
                    ALUSRC = 1'b1;
                    Memtoreg = 1'b0;
                    RegWrite = 1'b1;
                    Memread = 1'b0;
                    Memwrite = 1'b0;
                    OIread = 1'b0;
                    OIwrite = 1'b0;
                    Branch = 1'b0;
                    Signed=1'b0;
                    ALUop = `ALU_OP_LUI;
                end
                `U_TYPE_AUIPC: begin
                    //ToDo
                end
                `ECALL: begin
                    //ToDo
                end
            endcase
        end else begin
            Branch = 1'b0;
            Memread = 1'b0;
            Memtoreg = 1'b0;
            ALUop = 4'b0;
            Memwrite = 1'b0;
            ALUSRC = 1'b0;
            RegWrite = 1'b0;
            OIread = 1'b0;
            OIwrite = 1'b0;
            Signed=1'b0;
        end
    end

endmodule
