`timescale 1ns / 1ps
`include "define.v"

module cpu (
    input              clk_in,
    input              fpga_rst,
    input       [23:0] switch2N4,
    output wire [23:0] led2N4,

    // UART ports
    input  start_pg,
    input  rx,
    output tx,

    // VGA ports
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output hs,
    output vs,

    // 7-Seg ports    
    output [7:0] seg_out,
    output [7:0] tub_sel
);

    wire [31:0] Reg_out1, Reg_out2, Reg_tmp;
    wire [31:0] Result, Instruction, Imm, pc, next_pc, pc_plus_4;
    wire Branch, Memread, Memtoreg, Memwrite, ALUSRC, RegWrite, Signed;
    wire oiread, oiwrite;
    wire [3:0] ALUop;
    wire [6:0] func7;
    wire [2:0] func3;
    wire zero, upg_clk_o, Jump, rst_in;
    reg clk, upg_clk;  // the using clock signals
    wire upg_wen_o, upg_done_o;  // uart write out enable, rx data have done
    wire [14:0] upg_adr_o;  // data to which mem unit of prgrom / dmem32
    wire [31:0] upg_dat_o;  // data to prgrom / dmem32
    wire [31:0] data_switch;
    wire [2:0] led_control, switch_control;
    reg [25:0] divider_clk, divider_upg;
    reg [23:0] dclk_mem;
    reg clk_mem;
    wire [1:0]a7;
    initial begin
        divider_clk = 0;
        divider_upg = 0;
        clk = 0;
        upg_clk = 0;
        dclk_mem = 0;
        clk_mem = 0;
    end

    always @(posedge clk_in) begin
        divider_clk <= divider_clk + 1;
        if (divider_clk == 4) begin
            clk <= ~clk;
//            divider_clk <= 0;
        end
    end
    always @(posedge clk_in) begin
        dclk_mem <= dclk_mem + 1;
        if (dclk_mem == 1) begin
            clk_mem <= ~clk_mem;
//            dclk_mem<=0;
        end
    end
    always @(posedge clk_in) begin
        divider_upg <= divider_upg + 1;
        if (divider_upg == 9) begin
            upg_clk <= ~upg_clk;
            divider_upg <= 0;
        end
    end

    wire spg_bufg;
    debouncer deb1 (
        .clk  (clk_in),
        .k_in (start_pg),
        .k_out(spg_bufg)
    );

    reg upg_rst;
    always @(posedge clk_in) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
    assign rst_in = fpga_rst | (!upg_rst & !upg_done_o);
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
        .Jump(Jump),
        .imm(Imm),
        .instruct(Instruction),
        .pc(pc),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & !upg_adr_o[14]),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );
    wire [31:0] Check;
    // ID part: Instruction decode
    stage_id ID (
        .Check(Check),
        .clk(clk),
        .rst(rst_in),
        .Instruction(Instruction),
        .mem_write_addr(Result),
        .tmp_data(Reg_tmp),
        .sw_data(data_switch),
        .switch_control(switch_control),
        .Branch(Branch),
        .Memread(Memread),
        .Memtoreg(Memtoreg),
        .ALUop(ALUop),
        .Memwrite(Memwrite),
        .ALUSRC(ALUSRC),
        .RegWrite(RegWrite),
        .Signed(Signed),
        .Jump(Jump),
        .Reg_out1(Reg_out1),
        .Reg_out2(Reg_out2),
        .Imm(Imm),
        .func7(func7),
        .func3(func3),
        .a7(a7)
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
        .clk(clk_mem),
        .rst(rst_in),
        .mem_read(Memread),
        .mem_write(Memwrite),
        .data_switch(data_switch),
        .switch_control(switch_control),
        .led_control(led_control),
        .mem_write_addr(Result),
        .mem_write_data(Reg_out2),
        .a7(a7),
        .tmp_data(Reg_tmp),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & upg_adr_o[14]),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );

    // WB part: Write back
    // stage_wb WB (
    //     .mem_to_reg(Memtoreg),
    //     .read_data(Reg_con),
    //     .oiread(oiread),
    //     .oiwrite(oiwrite),
    //     .switch_control(switch_control),
    //     .led_control(led_control),
    //     .sw_data(data_switch),
    //     .mem_write_addr(Result),
    //     .tmp_data(Reg_tmp)
    // );

    led u_led (
        .clk(clk),
        .rst(rst_in),
        .control(pc[7:2]),
        .led_control(led_control),
        .ledwdata(Reg_out2),
        .ledout_w(led2N4[23:16]),
        .ledout(led2N4[15:0])
    );

    switch u_sw (
        .clk(clk),
        .rst(rst_in),
        .switch_control(switch_control),
        .switch_rdata(switch2N4),
        .Signed(Signed),
        .switch_wdata(data_switch)
    );

    vga u_vga (
        .clk(clk_in),
        .rst(rst_in),
        .val(pc[23:0]),
        .r  (r),
        .g  (g),
        .b  (b),
        .hs (hs),
        .vs (vs)
    );

    seg u_seg (
        .clk(clk_in),
        .rst(rst_in),
        .val(Instruction),
        .seg_out(seg_out),
        .tub_sel(tub_sel)
    );

endmodule
