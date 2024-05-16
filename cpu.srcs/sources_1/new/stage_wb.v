`timescale 1ns / 1ps
`include "define.v"
module stage_wb (
    input clk,
    input mem_to_reg,
    output reg [31:0] read_data,
    input oiread,
    input oiwrite,
    input [2:0]switch_control,
    input [2:0]led_control,
    input [31:0]sw_data,
    input [31:0] mem_write_addr,
    input [31:0] tmp_data
);

    always @(posedge clk) begin
       
    end

endmodule
