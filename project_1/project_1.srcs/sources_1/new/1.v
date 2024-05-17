`timescale 1ns / 1ps
`include "define.v"

module cpu (
    input              clk_in,
    input              fpga_rst,  
    output [7:0] seg_out,
    output [7:0] tub_sel
);
    wire [23:0]val;
    assign val=24'b0001_0010_0011_0100_0101_0110;
    seg u_seg (
        .clk(clk_in),
        .rst(fpga_rst),
        .val(val),
        .seg_out(seg_out),
        .tub_sel(tub_sel)
    );

endmodule
