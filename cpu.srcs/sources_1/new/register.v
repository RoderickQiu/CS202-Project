`timescale 1ns / 1ps
module Register (
    input [4:0] id1,
    input [4:0] id2,
    input [4:0] idwr,
    input [31:0] con,
    input RegWrite,
    input clk,
    output reg [31:0] rd1,
    output reg [31:0] rd2
);
    reg [31:0] Reg[31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Reg[i] = 0;
        end
    end
    always @(posedge clk) begin
        if (RegWrite && idwr != 5'b00000) begin
            Reg[idwr] <= con;
        end
        rd1 <= Reg[id1];
        rd2 <= Reg[id2];
    end
endmodule
