`timescale 1ns / 1ps
module cpu (
    input clk_in,
    input rst
);

    wire clk;  // the using clock signal

    cpu_clk cpuclk (
        .clk_in1 (clk_in),
        .clk_out1(clk)
    );

endmodule
