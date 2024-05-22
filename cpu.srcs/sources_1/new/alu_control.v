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
            `ALU_OP_LW: alu_ctrl = `ALU_CTRL_ADD;
            `ALU_OP_J: alu_ctrl = `ALU_CTRL_JR;
            `ALU_OP_R: begin
                if (func7 == 7'b0000000 && func3 == 3'b000) alu_ctrl = `ALU_CTRL_ADD;
                else if (func7 == 7'b0100000 && func3 == 3'b000) alu_ctrl = `ALU_CTRL_SUB;
                else if (func7 == 7'b0000000 && func3 == 3'b111) alu_ctrl = `ALU_CTRL_AND;
                else if (func7 == 7'b0000000 && func3 == 3'b110) alu_ctrl = `ALU_CTRL_OR;
                else if (func7 == 7'b0000000 && func3 == 3'b001) alu_ctrl = `ALU_CTRL_SLL;
                else if (func7 == 7'b0000000 && func3 == 3'b101) alu_ctrl = `ALU_CTRL_SRL;
                else if (func7 == 7'b0000000 && func3 == 3'b100) alu_ctrl = `ALU_CTRL_XOR;
                else if (func7 == 7'b0000000 && func3 == 3'b010) alu_ctrl = `ALU_CTRL_SL;
            end
            `ALU_OP_I: begin
                if (func3 == 3'b000) alu_ctrl = `ALU_CTRL_ADD;
                else if (func3 == 3'b100) alu_ctrl = `ALU_CTRL_XOR;
                else if (func3 == 3'b110) alu_ctrl = `ALU_CTRL_OR;
                else if (func3 == 3'b111) alu_ctrl = `ALU_CTRL_AND;
                else if (func3 == 3'b001) alu_ctrl = `ALU_CTRL_SLL;
                else if (func3 == 3'b101) alu_ctrl = `ALU_CTRL_SRL;
                else if (func3 == 3'b010) alu_ctrl = `ALU_CTRL_SL;
            end
            `ALU_OP_B: begin
                if (func3 == 3'b110 || func3 == 3'b111) alu_ctrl = `ALU_CTRL_SUB;
                else alu_ctrl = `ALU_CTRL_SUB_SIGNED;
            end
            `ALU_OP_LUI: alu_ctrl = `ALU_CTRL_LUI;
            `ALU_OP_AUIPC: alu_ctrl = `ALU_CTRL_AUIPC;
            `ALU_OP_JR: alu_ctrl = `ALU_CTRL_JR;
        endcase
    end

endmodule
