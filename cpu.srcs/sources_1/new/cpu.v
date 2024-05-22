`timescale 1ns / 1ps
`include "define.v"

module cpu (
    input              clk_in,
    input              fpga_rst,
    input       [23:0] switch2N4,
    output wire [23:0] led2N4,


    // VGA ports
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output hs,
    output vs,

    // 7-Seg ports    
    output [7:0] seg_out,
    output [7:0] tub_sel,

    // Audio ports
    output buzzer
);

    wire [31:0] Reg_out1, Reg_out2, Reg_tmp;
    wire [31:0] Result, Instruction, Imm, pc, next_pc, pc_plus_4;
    wire Branch, Memread, Memtoreg, Memwrite, ALUSRC, RegWrite, Signed, JR;
    wire oiread, oiwrite;
    wire [3:0] ALUop;
    wire [6:0] func7;
    wire [2:0] func3;
    wire zero,  Jump, rst_in;
    reg clk, audio_clk;  // the using clock signals
    wire [31:0] data_switch;
    wire [2:0] led_control, switch_control;
    wire audio_control;
    reg [25:0] divider_clk, divider_audio;
    reg [23:0] dclk_mem;
    reg clk_mem;
    wire [1:0] a7;
    wire [31:0]p_out;
    wire Stop;
    initial begin
        divider_clk = 0;
        divider_audio = 0;
        clk = 0;
        audio_clk = 0;
        dclk_mem = 0;
        clk_mem = 0;
    end

    always @(posedge clk_in) begin
        divider_clk <= divider_clk + 1;
        if (divider_clk == 4) begin
            clk <= ~clk;
            divider_clk <= 0;
        end
    end

    always @(posedge clk_in) begin
        dclk_mem <= dclk_mem + 1;
        if (dclk_mem == 1) begin
            clk_mem  <= ~clk_mem;
            dclk_mem <= 0;
        end
    end
    always @(posedge clk_in) begin
        divider_audio <= divider_audio + 1;
        if (divider_audio == 99) begin
            audio_clk <= ~audio_clk;
            divider_audio <= 0;
        end
    end

    assign rst_in = fpga_rst;
    
    // IF part: Instruction fetch
    stage_if IF (
        .clk(clk),
        .rst(rst_in),
        .clk_p(clk_p),
        .branch(Branch),
        .zero(zero),
        .Jump(Jump),
        .imm(Imm),
        .instruct(Instruction),
        .pc(pc),
        .rs1(Reg_out1),
        .JR(JR),
        .Stop(Stop)
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
        .a7(a7),
        .JR(JR)
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
        .clk_p(clk_p),
        .Stop(Stop),
        .mem_read(Memread),
        .mem_write(Memwrite),
        .data_switch(data_switch),
        .switch_control(switch_control),
        .led_control(led_control),
        .audio_control(audio_control),
        .mem_write_addr(Result),
        .mem_write_data(Reg_out2),
        .a7(a7),
        .tmp_data(Reg_tmp)
    );


    led u_led (
        .clk(clk),
        .rst(rst_in),
        .control(pc[7:2]),
        .led_control(led_control),
        .ledwdata(Reg_out2[23:0]),
        .ledout_w(led2N4[23:16]),
        .ledout(led2N4ing)
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
        .val({16'b0000_0000_0000_0000,led2N4[15:0]}),
        .seg_out(seg_out),
        .tub_sel(tub_sel)
    );

    audio u_audio (
        .clk(clk_in),
        .slow_clk(audio_clk),
        .rst(rst_in),
        .enable(audio_control),
        .cur_note(Reg_out2),
        .buzzer(buzzer)
    );

    print u_print(.Stop(Stop),
            .clk(clk_p),
            .in_init(led2N4[15:0]),
            .new(Reg_tmp),
            .out(p_out));

endmodule
