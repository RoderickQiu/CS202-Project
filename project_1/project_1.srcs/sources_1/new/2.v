`timescale 1ns / 1ps
`include "define.v"
module seg (
    input clk,
    input rst,
    input [23:0] val,
    output [7:0] seg_out,
    output reg [7:0] tub_sel
);

    reg [63:0] timer;
    reg [ 3:0] sw;

    seg_char_set slv (
        sw,
        rst,
        seg_out
    );

    always @(posedge clk or negedge rst) begin
        if (rst) timer <= 64'd0;
        else if (timer == `S_DELAY_8) timer <= 64'd0;
        else timer <= timer + 1'b1;
    end

    always @(posedge clk) begin
        if (rst) begin
            tub_sel <= 8'b0;  //all not setting
            sw <= 4'b0;
        end else if (timer <= `S_DELAY_0) begin
            tub_sel <= 8'b0000_0001;  //rightmost
            sw <= 4'b0001;
        end else if (timer <= `S_DELAY_1) begin
            tub_sel <= 8'b0000_0010;
            sw <= 4'b0011;;
        end else if (timer <= `S_DELAY_2) begin
            tub_sel <= 8'b0000_0100;
            sw <= 4'b0110;
        end else if (timer <= `S_DELAY_3) begin
            tub_sel <= 8'b0000_1000;
            sw <= 4'b1100;
        end else if (timer <= `S_DELAY_4) begin
            tub_sel <= 8'b0001_0000;
            sw <= 4'b1001;
        end else if (timer <= `S_DELAY_5) begin
            tub_sel <= 8'b0010_0000;
            sw <= 4'b1011;
        end else if (timer <= `S_DELAY_6) begin
            tub_sel <= 8'b0100_0000;
            sw <= 4'b0111;
        end else if (timer <= `S_DELAY_7) begin
            tub_sel <= 8'b1000_0000;
            sw <= 4'b1101;
        end else begin
            tub_sel <= 8'b0;  //all not setting
            sw <= 4'b0;
        end
    end

endmodule
