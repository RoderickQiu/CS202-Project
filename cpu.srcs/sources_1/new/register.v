`timescale 1ns / 1ps
`include "define.v"

module register (
    input [4:0] id1,
    input [4:0] id2,
    input [4:0] idwr,
    input [31:0] con,
    input RegWrite,
    input clk,
    input rst,
    output reg [31:0] rd1,
    output reg [31:0] rd2
);
    reg [31:0] Reg[31:0];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (i == 1) Reg[i] <= `SP_REG_INITIAL;
                else Reg[i] <= 0;
            end
        end
        rd1 <= Reg[id1];
        rd2 <= Reg[id2];
    end

    always @(posedge !clk) begin
        if (RegWrite && idwr != 5'b00000) begin
            Reg[idwr] <= con;
        end
    end
endmodule
