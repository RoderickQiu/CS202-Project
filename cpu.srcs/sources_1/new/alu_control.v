`timescale 1ns / 1ps
`include "define.v"

module alu_control (
    input [3:0] aluop,
    input [6:0] func7,
    input [2:0] func3,
    output reg [3:0] alu_ctrl
);

    always @(*) begin
        case (aluop)
            `ALU_OP_LW, `ALU_OP_BEQ: alu_ctrl = {aluop, 2'b10};
            `ALU_OP_R: begin
                if (func7 == 7'b0 && func3 == 3'b000) alu_ctrl = `ALU_CTRL_ADD;
                else if (func7 == 7'b0100000 && func3 == 3'b000) alu_ctrl = `ALU_CTRL_SUB;
                else if (func7 == 7'b0 && func3 == 3'b111) alu_ctrl = `ALU_CTRL_AND;
                else if (func7 == 7'b0 && func3 == 3'b110) alu_ctrl = `ALU_CTRL_OR;
            end
            `ALU_OP_LUI: alu_ctrl = `ALU_CTRL_LUI;
            `ALU_OP_AUIPC: alu_ctrl = `ALU_CTRL_AUIPC;
        endcase
    end

endmodule
