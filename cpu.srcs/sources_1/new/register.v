`timescale 1ns / 1ps
`include "define.v"

module register (
    input [4:0] id1,
    input [4:0] id2,
    input [4:0] idwr,
    input RegWrite,
    input clk,
    input rst,
    input [2:0]switch_control,
    input mem_to_reg,
    input [31:0]mem_write_addr,
    input [31:0]tmp_data,
    input [31:0]sw_data,
    output  [31:0] rd1,
    output  [31:0] rd2,
    output a7
);
    reg [31:0] Reg[31:0];
    integer i;
    // wire [31:0]Check;

    reg [31:0] w_data;
    reg [4:0] pre;
    
    always @(*)begin
        if(switch_control!=3'b000)begin
            w_data =sw_data;
        end else if (mem_to_reg) begin
            w_data= tmp_data;
        end else begin
            w_data= mem_write_addr;
        end
    end
    always @(*)begin
        pre=idwr;
    end

    assign    rd1 = Reg[id1];
    assign    rd2 = Reg[id2];
    assign    a7 = Reg[17][0];   
    always @(negedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (i == 2) Reg[i] <= `SP_REG_INITIAL;
                else Reg[i] <= 0;
            end
        end else if (RegWrite && idwr != 5'b00000) begin
            Reg[pre] <=w_data;
        end
    end
endmodule
