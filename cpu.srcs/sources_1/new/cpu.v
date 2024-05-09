`timescale 1ns / 1ps
`include "define.v"

module cpu (
    input clk_in,
    input fpga_rst,
    input [23:0] switch2N4,
    output wire [23:0] led2N4,

    // UART ports
    input  start_pg,
    input  rx,
    output tx
);
    wire [31:0] Reg_out1, Reg_out2, Reg_con, Reg_tmp;
    wire [31:0] Result, Instruction, Imm, pc, next_pc, pc_plus_4;
    wire Branch, Memread, Memtoreg, Memwrite, ALUSRC, RegWrite;
    wire Oiread, Oiwrite;
    wire [3:0] ALUop;
    wire [6:0] func7;
    wire [2:0] func3;
    wire zero;
    wire clk, upg_clk, upg_clk_o;  // the using clock signals
    wire upg_wen_o, upg_done_o;  // uart write out enable, rx data have done
    wire [14:0] upg_adr_o;  // data to which mem unit of prgrom / dmem32
    wire [31:0] upg_dat_o;  // data to prgrom / dmem32

    cpu_clk cpuclk (  // Maintain the clock signal
        .clk_in1 (clk_in),
        .clk_out1(clk),
        .clk_out2(upg_clk)
    );

    wire spg_bufg, rst_in;
    BUFG U1 (
        .I(start_pg),
        .O(spg_bufg)
    );

    reg upg_rst;
    always @(posedge clk_in) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
    assign rst_in = fpga_rst | upg_rst;

    uart_bmpg_0 uart (
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i (rx),

        .upg_clk_o (upg_clk_o),
        .upg_wen_o (upg_wen_o),
        .upg_adr_o (upg_adr_o),
        .upg_dat_o (upg_dat_o),
        .upg_done_o(upg_done_o),
        .upg_tx_o  (tx)
    );

    // IF part: Instruction fetch
    stage_if IF (
        .clk(clk),
        .rst(rst_in),
        .branch(Branch),
        .zero(zero),
        .imm(Imm),
        .instruct(Instruction),
        .pc(pc),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_o),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
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
        .OIread(Oiread),
        .OIwrite(Oiwrite),
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
        .rst(rst_in),
        .mem_read(Memread),
        .mem_write(Memwrite),
        .oi_read(Oiread),
        .oi_write(Oiwrite),
        .mem_write_addr(Result),
        .mem_write_data(Reg_out2),
        .tmp_data(Reg_tmp),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_o),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );

    // WB part: Write back
    stage_wb WB (
        .mem_to_reg(Memtoreg),
        .read_data(Reg_con),
        .mem_write_addr(Result),
        .tmp_data(Reg_tmp)
    );

    led Led (
        .mem_to_reg(Memtoreg),
        .read_data(Reg_con),
        .mem_write_addr(Result),
        .tmp_data(Reg_tmp)
    );

endmodule
