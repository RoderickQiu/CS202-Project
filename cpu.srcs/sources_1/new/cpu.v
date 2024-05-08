`timescale 1ns / 1ps
`include "define.v"

module cpu (
    input clk_in,
    input rst,
    input [23:0] switch2N4,
    output wire [23:0]led2N4
);
    wire [31:0] Reg_out1, Reg_out2, Reg_con, Reg_tmp;
    wire [31:0] Result, Instruction, Imm, pc, next_pc, pc_plus_4;
    wire Branch, Memread, Memtoreg, Memwrite, ALUSRC, RegWrite;
    wire [3:0] ALUop;
    wire [6:0] func7;
    wire [2:0] func3;
    wire zero;

    wire clk;  // the using clock signal

    cpu_clk cpuclk (  // Maintain the clock signal
        .clk_in1 (clk_in),
        .clk_out1(clk)
    );

    // IF part: Instruction fetch
    stage_if IF (
        .clk(clk),
        .rst(rst),
        .branch(Branch),
        .zero(zero),
        .imm(Imm),
        .instruct(Instruction),
        .pc(pc)
    );

    // ID part: Instruction decode
    stage_id ID (
        .Instruction(Instruction),
        .Reg_con(Reg_con),
        .Branch(Branch),
        .Memread(Memread),
        .Memtoreg(Memtoreg),
        .ALUop(ALUop),
        .Memwrite(Memwrite),
        .ALUSRC(ALUSRC),
        .RegWrite(RegWrite),
        .Reg_out1(Reg_out1),
        .Reg_out2(Reg_out2),
        .Imm(Imm),
        .func7(func7),
        .func3(func3)
    );

    // EX part: ALU
    stage_ex EX (
        .read_data1(Reg_out1),
        .read_data2(Reg_out2),
        .pc(pc),
        .imm32(Imm),
        .aluop(ALUop),
        .func7(func7),
        .func3(func3),
        .alu_src(ALUSRC),
        .alu_result(Result),
        .zero(zero)
    );

    // MEM part: Data memory
    stage_mem MEM (
        .clk(clk),
        .rst(rst),
        .mem_write(Memwrite),
        .mem_write_addr(Result),
        .mem_write_data(Reg_out2),
        .tmp_data(Reg_tmp)
    );

    // WB part: Write back
    stage_wb WB (
        .mem_to_reg(Memtoreg),
        .read_data(Reg_con),
        .mem_write_addr(Result),
        .tmp_data(Reg_tmp)
    );

endmodule
