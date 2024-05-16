`timescale 1ns / 1ps
`include "define.v"

module stage_ex (
    input [31:0] read_data1,
    input [31:0] read_data2,
    input [31:0] pc,
    input [31:0] imm32,
    input [3:0] aluop,  // ALUOp is 3 bits here
    input [6:0] func7,
    input [2:0] func3,
    input alu_src,
    output reg [31:0] alu_result,
    output zero
);

    wire [ 3:0] alu_ctrl;
    wire [31:0] operand2;

    alu_control control (
        aluop,
        func7,
        func3,
        alu_ctrl
    );
    assign operand2 = (alu_src == 1'b0) ? read_data2 : imm32;
    assign zero = (alu_result == 32'b0) ? 1'b1 : 1'b0;

    always @(*) begin
        case (alu_ctrl)
            `ALU_CTRL_ADD: alu_result = read_data1 + operand2;
            `ALU_CTRL_SUB: alu_result = read_data1 - operand2;
            `ALU_CTRL_ADD_SIGNED: alu_result = $signed(read_data1) + $signed(operand2);
            `ALU_CTRL_SUB_SIGNED: alu_result = $signed(read_data1) - $signed(operand2);
            `ALU_CTRL_AND: alu_result = read_data1 & operand2;
            `ALU_CTRL_OR: alu_result = read_data1 | operand2;
            `ALU_CTRL_SLL: alu_result = read_data1 << operand2[4:0];
            `ALU_CTRL_SRL: alu_result = read_data1 >> operand2[4:0];
            `ALU_CTRL_LUI: alu_result = operand2 << 12;
            `ALU_CTRL_XOR: alu_result = read_data1 ^ operand2;
            `ALU_CTRL_AUIPC: alu_result = pc + operand2;
        endcase
    end

endmodule
