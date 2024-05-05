`timescale 1ns / 1ps
`include "define.v"
module light_val_controller (
    input clk,
    input rst,
    input seg_alter_ctrl,
    input [15:0] origin_val,
    output reg [31:0] val_7seg
);

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            val_7seg = 32'b0;
        end else begin
            if (seg_alter_ctrl) begin
                val_7seg = origin_val;
            end else begin
                val_7seg = val_7seg;
            end
        end
    end

endmodule
