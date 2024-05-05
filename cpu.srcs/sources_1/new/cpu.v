`timescale 1ns / 1ps
module cpu (
    input clk_in,
    input rst
);
    wire [31:0] Reg_out1, Reg_out2, Reg_con;
    wire [31:0] Result, Instruction, Imm, pc, next_pc, pc_plus_4;
    wire [4:0] Reg_id1, Reg_id2, Reg_idwr;
    wire [6:0] opcode;
    wire Branch, Memread, Memtoreg, Memwrite, ALUSRC, RegWrite;
    wire [3:0] ALUop, aluctrl;
    wire [6:0] func7;
    wire [2:0] func3;
    wire zero;

    wire clk;  // the using clock signal

    cpu_clk cpuclk ( // Maintain the clock signal
        .clk_in1 (clk_in),
        .clk_out1(clk)
    );

    instruct_mem Imem ( // IF part: PC update + instruction fetch 
        .clk(clk),
        .rst(rst),
        .branch(Branch),
        .zero(zero),
        .imm(Imm),
        .instruct(Instruction),
        .pc(pc)
    );

    parse_instruction PI ( // ID Part: Parse the instruction
        .instruction(Instruction),
        .opcode(opcode),
        .imm(Imm),
        .rs1(Reg_id1),
        .rs2(Reg_id2),
        .rd(Reg_idwr),
        .funct7(func7),
        .func3(func3)
    );

    instruction_control IC ( // ID part: Instruction control
        .opcode(opcode),
        .Branch(Branch),
        .Memread(Memread),
        .Memtoreg(Memtoreg),
        .ALUop(ALUop),
        .Memwrite(Memwrite),
        .ALUSRC(ALUSRC),
        .RegWrite(RegWrite)
    );

    register REG ( // ID part: Register file
        .id1(Reg_id1),
        .id1(Reg_id1),
        .idwr(Reg_idwr),
        .con(Reg_idwr),
        .RegWrite(RegWrite),
        .clk(clk),
        .rd1(Reg_out1),
        .rd2(Reg_out2)
    );

    alu ALU ( // EX part: ALU
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

    data_mem Dmem ( // MEM part: Data memory
        .clk(clk),
        .rst(rst),
        .mem_write(Memwrite),
        .mem_write_addr(Result),
        .mem_write_data(Reg_out2),
        .mem_to_reg(Memtoreg),
        .read_data(Reg_con)
    );

endmodule
