`timescale 1ns / 1ps
module stage_id (
    input clk,
    input [31:0] Instruction,
    input [31:0] Reg_con,
    output Branch,
    output Memread,
    output Memtoreg,
    output [3:0] ALUop,
    output Memwrite,
    output ALUSRC,
    output RegWrite,
    output OIread,
    output OIwrite,
    output [31:0] Reg_out1,
    output [31:0] Reg_out2,
    output [31:0] Imm,
    output [6:0] func7,
    output [2:0] func3
);

    wire [4:0] Reg_id1, Reg_id2, Reg_idwr;
    wire [6:0] opcode;
    wire zero,oi;

    parse_instruction PI (  // ID Part: Parse the instruction
        .instruction(Instruction),
        .opcode(opcode),
        .imm(Imm),
        .rs1(Reg_id1),
        .rs2(Reg_id2),
        .rd(Reg_idwr),
        .func7(func7),
        .func3(func3),
        .oi(oi)
    );

    instruction_control IC (  // ID part: Instruction control
        .opcode(opcode),
        .oi(oi),
        .Branch(Branch),
        .Memread(Memread),
        .Memtoreg(Memtoreg),
        .ALUop(ALUop),
        .Memwrite(Memwrite),
        .ALUSRC(ALUSRC),
        .RegWrite(RegWrite),
        .OIread(OIread),
        .OIwrite(OIwrite)
    );

    register REG (  // ID part: Register file
        .id1(Reg_id1),
        .id2(Reg_id2),
        .idwr(Reg_idwr),
        .con(Reg_con),
        .RegWrite(RegWrite),
        .clk(clk),
        .rd1(Reg_out1),
        .rd2(Reg_out2)
    );

endmodule
