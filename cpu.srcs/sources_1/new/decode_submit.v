`timescale 1ns / 1ps
`include "define.v"

module Decoder(
      input clk, rst,
      input regWrite,
      input [31:0] inst,
      input [31:0] writeData,
      output [31:0] rs1Data, rs2Data,
      output reg [31:0] imm32 
    );

    reg [31:0] Reg[31:0];
    integer i;
    wire [31:0]Check;
    assign rd1 = Reg[id1];
    assign rd2 = Reg[id2];
    assign Check = Reg[idwr];

    always @(negedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                Reg[i] <= 0;
            end
        end
    end
    always @(negedge clk) begin
        if (regWrite && idwr != 5'b00000) begin
            Reg[idwr] <=writeData;
        end
    end
endmodule
