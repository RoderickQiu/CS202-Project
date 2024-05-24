`timescale 1ns / 1ps
`include "define.v"

module mem_or_io (
    // input clk,
    input [1:0] a7,
    input mem_read,
    input mem_write,


    input  [13:0] alu_result_addr,
    output [ 2:0] led_control,
    output [ 2:0] switch_control,
    output audio_control
);

    assign switch_control = a7==2'b10 ? 3'b110:
    ((mem_read && alu_result_addr[13:3]==`SWITCH_MEM) ?
    alu_result_addr[2:0]:3'b000);
    assign led_control = a7==2'b11 ? 3'b100:
    ((mem_write && alu_result_addr[13:3]==`LED_MEM) ?
    alu_result_addr[2:0]:3'b000);
    assign audio_control = a7 == 2'b01 ? 1'b1 :
    ((mem_write && alu_result_addr[13:6] == `AUDIO_MEM) ? 1'b1 : 1'b0);


endmodule
