`include "define.v"
module parse_instruction (
    input [31:0] instruction,
    output wire [6:0] opcode,
    output reg [31:0] imm,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [6:0] func7,
    output reg [2:0] func3,
    output reg oi

);

    assign opcode = instruction[6:0];

    always @* begin
        rd = 5'b0;
        func3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        func7 = 7'b0;
        imm = 32'b0;
        case (opcode)
            `R_TYPE: begin  // R-type
                rd <= instruction[11:7];
                func3 <= instruction[14:12];
                rs1 <= instruction[19:15];
                rs2 <= instruction[24:20];
                func7 <= instruction[31:25];
            end
            `I_TYPE_1: begin  // I-type 1
                rd <= instruction[11:7];
                func3 <= instruction[14:12];
                rs1 <= instruction[19:15];
                imm <= {{20{instruction[31]}}, instruction[31:20]};
            end
            `I_TYPE_2: begin  // I-type 2
                rd <= instruction[11:7];
                func3 <= instruction[14:12];
                rs1 <= instruction[19:15];
                imm <= {{20{instruction[31]}}, instruction[31:20]};
            end
            `S_TYPE: begin  // S-type
                func3 <= instruction[14:12];
                rs1   <= instruction[19:15];
                rs2   <= instruction[24:20];
                imm   <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            `B_TYPE: begin  // B-type
                func3 <= instruction[14:12];
                rs1 <= instruction[19:15];
                rs2 <= instruction[24:20];
                imm <= {
                    {19{instruction[31]}},
                    instruction[31],
                    instruction[7],
                    instruction[30:25],
                    instruction[11:8],
                    instruction[7]
                };
            end
            `U_TYPE_LUI: begin  // U-type lui
                rd <= instruction[11:7];
                imm[31:12] <= instruction[31:12];
            end
            `U_TYPE_AUIPC: begin  // U-type auipc
                rd <= instruction[11:7];
                imm[31:12] <= instruction[31:12];
            end
            `ECALL: begin  //ecall
                func3 <= 3'b000;
                imm   <= 0;
            end
        endcase
        oi= (imm[31:10]=22'b0000_0000_0000_0000_0000_00) ? 1'b1 :1'b0;
    end

endmodule

//`timescale 1ns / 1ps

/*module tb_parse_instruction;
    reg [31:0] instruction;
    wire [31:0] imm;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [6:0] opcode;
    wire [6:0] func7;
    wire [2:0] func3;

    // 实例化被测模块
    parse_instruction uut (
        .instruction(instruction),
        .imm(imm),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .func7(func7),
        .func3(func3)
    );

    initial begin
        // 初始化指令
        instruction = 32'b01000000110001011000010100110011; // R-type sub x10, x11, x12
        #10;

        instruction = 32'b00000000101010011000100100110011; // R-type add x18,x19,x10
        #10;

        instruction = 32'b11111100111000001000011110010011; //I-type addi x15,x1,-50
        #10;

        instruction = 32'b00000000010101000001101000010011; // I-type slli x20, x8, 5
        #10;

        instruction = 32'b00000000100000010010011100000011; // I-type lw x14, 8(x2)
        #10;

        instruction = 32'b00000000111000010010010000100011; // S-type sw x14, 8(x2)
        #10;

        instruction = 32'b00000000101010011000100001100011; // B-type beq x19,x10, 16
        #10;

        instruction = 32'h00000037; // U-type lui
        #10;

        instruction = 32'h00000017; // U-type auipc
        #10;

        instruction = 32'h00000073; // ecall
        #10;

        $finish; // 结束模拟
    end

    // 监视输出
    initial begin
        $monitor("At time %d: opcode=%b, rd=%b, func3=%b, rs1=%b, rs2=%b, func7=%b, imm=%b",
                 $time, opcode, rd, func3, rs1, rs2, func7, imm);
    end
endmodule*/
