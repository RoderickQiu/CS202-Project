`timescale 1ns / 1ps
`include "define.v"

module mem_or_io (
    // input clk,
    input mem_read,
    input mem_write,


    input [13:0]alu_result_addr,
    output  [2:0]led_control,
    output  [2:0]switch_control
);

    assign switch_control = (mem_read && alu_result_addr[13:2]==`SWITCH_MEM) ?
    {1'b1,alu_result_addr[1:0]}:3'b000;
    assign led_control = (mem_write && alu_result_addr[13:2]==`LED_MEM) ?
    {1'b1,alu_result_addr[1:0]}:3'b000;

endmodule
