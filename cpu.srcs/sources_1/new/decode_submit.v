`timescale 1ns / 1ps
`define R_TYPE 7'b0110011
`define I_TYPE_1 7'b0010011
`define I_TYPE_2 7'b0000011
`define S_TYPE 7'b0100011
`define B_TYPE 7'b1100011
`define J_TYPE 7'b1101111
`define U_TYPE_LUI 7'b0110111
`define U_TYPE_AUIPC 7'b0010111
`define ECALL 7'b1110011

module Decoder(
      input clk, rst,
      input regWrite,
      input [31:0] inst,
      input [31:0] writeData,
      output [31:0] rs1Data, rs2Data,
      output reg [31:0] imm32 
    );
    wire [6:0] opcode;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    assign opcode = inst[6:0];

    always @* begin
        rd = 5'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        imm32 = 32'b0;
        case (opcode)
            `R_TYPE: begin  // R-type
                rd = inst[11:7];
                rs1 = inst[19:15];
                rs2 = inst[24:20];
            end
            `I_TYPE_1: begin  // I-type 1
                rd = inst[11:7];
                rs1 = inst[19:15];
                imm32 = {{20{inst[31]}}, inst[31:20]};
            end
            `I_TYPE_2: begin  // I-type 2
                rd = inst[11:7];
                rs1 = inst[19:15];
                imm32 = {{20{inst[31]}}, inst[31:20]};
            end
            `S_TYPE: begin  // S-type
                rs1   = inst[19:15];
                rs2   = inst[24:20];
                imm32   = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end
            `B_TYPE: begin  // B-type

                rs1 = inst[19:15];
                rs2 = inst[24:20];
                imm32 = {{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
            end
            `J_TYPE: begin // J-type
                rd = inst[11:7];
                imm32 = {{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21], 1'b0};
            end
            `U_TYPE_LUI: begin  // U-type lui
                rd = inst[11:7];
                imm32 = {{12{inst[31]}},inst[31:12]};
            end
            `U_TYPE_AUIPC: begin  // U-type auipc
                rd = inst[11:7];
                imm32 = {{12{inst[31]}},inst[31:12]};
            end
            `ECALL: begin  //ecall
                imm32   = 0;
            end
        endcase
    end



    reg [31:0] Reg[31:0];
    integer i;
    wire [31:0]Check;
    assign rs1Data = Reg[rs1];
    assign rs2Data = Reg[rs2];
    assign Check = Reg[rd];

    always @(negedge clk) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                Reg[i] <= 0;
            end
        end else if (regWrite && rd != 5'b00000) begin
            Reg[rd] <=writeData;
        end
    end
endmodule
