`timescale 1ns / 1ps

module stage_mem (
    input clk,
    input rst,
    input clk_p,
    input Stop,
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
    // CPU work on normal mode when kickOff is 1
    // CPU work on Uart communicate mode when kickOff is 0

    // wire [31:0] out_mem;
    // wire [15:0] out_oi;
    //    wire write = mem_write | oi_write;
    wire [13:0] _0;
    reg [13:0]mem_p=OUT_START;
    always @(negedge clk_p ) begin
        if(Stop)begin
            mem_p=mem_p+4;
        end else begin
            mem_p=OUT_START-4;
        end
    end
    assign _0 = 0;
    dmem32 dmem (
        .clka (trans_clk),
        .wea  (mem_write),
        .addra(Stop?mem_p:(a7[1] ? _0 : mem_write_addr[15:2])),
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
