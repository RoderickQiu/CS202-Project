`timescale 1ns / 1ps
`include "define.v"

module mem_or_io (
    // input clk,
    input mem_read,
    input mem_write,

    output reg oi_read,
    output reg oi_write,
    input [13:0]alu_result_addr,
    output  [2:0]led_control,
    // output Result  // data to register
    // output [31:0] addr_output,  // address to memory
    // output reg [31:0] data_write_output,  // data to memory or io
    output  [2:0]switch_control
);

    // assign addr_output = alu_result_addr;
    // assign Result = mem_read ? mem_read_data : {16'h0000, io_read_data};
    // assign led_ctrl = io_write ? 1'b1 : 1'b0;
    // assign switch_ctrl = io_read ? 1'b1 : 1'b0;
    assign switch_control = (mem_read && alu_result_addr[13:2]==`SWITCH_MEM) ?
    {1'b1,alu_result_addr[1:0]}:3'b000;
    assign led_control = (mem_write && alu_result_addr[13:2]==`LED_MEM) ?
    {1'b1,alu_result_addr[1:0]}:3'b000;

endmodule
