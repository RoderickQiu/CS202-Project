`include "define.v"

module instruction_control (
    input [6:0] opcode,
    input [2:0] func3,
    input clk,
    input rst,
    output reg Branch,
    output reg Memread,
    output reg Memtoreg,
    output reg [3:0] ALUop,
    output reg Memwrite,
    output reg ALUSRC,
    output reg RegWrite,
    output reg Signed,
    output reg Jump
);

    always @(posedge clk) begin
        if (!rst) begin
            case (opcode)
                `R_TYPE: begin
                    ALUSRC <= 1'b0;
                    Memtoreg <= 1'b0;
                    RegWrite <= 1'b1;
                    Memread <= 1'b0;
                    Memwrite <= 1'b0;
                    Branch <= 1'b0;
                    Signed <= 1'b0;
                    ALUop <= `ALU_OP_R;
                    Jump <= 1'b0;
                end
                `I_TYPE_1: begin
                    ALUSRC   <= 1'b1;
                    Memtoreg <= 1'b0;
                    RegWrite <= 1'b1;
                    Memread  <= 1'b1;
                    Memwrite <= 1'b0;
                    Branch   <= 1'b0;
                    Signed   <= 1'b0;
                    ALUop    <= `ALU_OP_I;
                    Jump     <= 1'b0;
                end
                `I_TYPE_2: begin
                    ALUSRC <= 1'b1;
                    Memtoreg <= 1'b1;
                    RegWrite <= 1'b1;
                    Memread <= 1'b1;
                    Memwrite <= 1'b0;
                    Branch <= 1'b0;
                    Signed <= func3 == 3'b100 ? 1'b1 : 1'b0;
                    ALUop <= `ALU_OP_LW;
                    Jump <= 1'b0;
                end
                `S_TYPE: begin
                    ALUSRC <= 1'b1;
                    Memtoreg <= 1'b0;
                    RegWrite <= 1'b0;
                    Memread <= 1'b0;
                    Memwrite <= 1'b1;
                    Branch <= 1'b0;
                    Signed <= 1'b0;
                    ALUop <= `ALU_OP_SW;
                    Jump <= 1'b0;
                end
                `B_TYPE: begin
                    ALUSRC <= 1'b0;
                    Memtoreg <= 1'b0;
                    RegWrite <= 1'b0;
                    Memread <= 1'b0;
                    Memwrite <= 1'b0;
                    Branch <= 1'b1;
                    Signed <= 1'b0;
                    ALUop <= `ALU_OP_B;
                    Jump <= 1'b0;
                end
                `J_TYPE: begin
                    ALUSRC <= 1'b1;
                    Memtoreg <= 1'b0;
                    RegWrite <= 1'b0;
                    Memread <= 1'b0;
                    Memwrite <= 1'b0;
                    Branch <= 1'b0;
                    Signed <= 1'b0;
                    ALUop <= `ALU_OP_J;
                    Jump <= 1'b1;
                end
                `U_TYPE_LUI: begin
                    ALUSRC <= 1'b1;
                    Memtoreg <= 1'b0;
                    RegWrite <= 1'b1;
                    Memread <= 1'b0;
                    Memwrite <= 1'b0;
                    Branch <= 1'b0;
                    Signed <= 1'b0;
                    ALUop <= `ALU_OP_LUI;
                    Jump <= 1'b0;
                end
                `U_TYPE_AUIPC: begin
                    //ToDo
                end
                `ECALL: begin
                    //ToDo
                end
            endcase
        end else begin
            Branch <= 1'b0;
            Memread <= 1'b0;
            Memtoreg <= 1'b0;
            ALUop <= 4'b0;
            Memwrite <= 1'b0;
            ALUSRC <= 1'b0;
            RegWrite <= 1'b0;
            Signed <= 1'b0;
            Jump <= 1'b0;
        end
    end

endmodule
