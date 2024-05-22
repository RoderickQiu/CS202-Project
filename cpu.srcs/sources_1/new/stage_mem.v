`timescale 1ns / 1ps

module stage_mem (
    input clk,
    input rst,
    input mem_read,
    input mem_write,
    input [31:0] data_switch,
    input [31:0] mem_write_addr,  // orgininate from ALU
    input [31:0] mem_write_data,
    input [1:0] a7,
    output [31:0] tmp_data,
    output [2:0] switch_control,
    output [2:0] led_control,
    output audio_control
);

    wire trans_clk;
    assign trans_clk = !clk;

    wire [13:0] _0;
    assign _0 = 0;
    dmem32 dmem (
        .clka (trans_clk),
        .wea  (mem_write),
        .addra(a7[1] ? _0 : mem_write_addr[15:2]),
        .dina (mem_write_data),
        .douta(tmp_data)
    );

    mem_or_io dmemio (
        // .clk(clk),
        .a7(a7),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_result_addr(mem_write_addr[15:2]),
        .led_control(led_control),
        .switch_control(switch_control),
        .audio_control(audio_control)
        // .Result(tmp_data)
    );
endmodule
