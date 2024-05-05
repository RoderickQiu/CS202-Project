`timescale 1ns / 1ps

module stage_mem (
    input clk,
    input rst,
    input mem_write,
    input [31:0] mem_write_addr,  // orgininate from ALU
    input [31:0] mem_write_data,
    output reg [31:0] read_data,
    output [31:0] tmp_data
);

    wire trans_clk;
    assign trans_clk = !clk;

    dmem32 dmem (
        .clka (trans_clk),
        .wea  (mem_write),
        .addra(mem_write_addr[15:2]),
        .dina (mem_write_data),
        .douta(tmp_data)
    );

    always @(*) begin
        if (mem_write) begin
            read_data = tmp_data;
        end else begin
            read_data = mem_write_addr;
        end
    end

endmodule
