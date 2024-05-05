`timescale 1ns / 1ps
module stage_wb (
    input mem_to_reg,
    output reg [31:0] read_data,
    input [31:0] mem_write_addr,
    output [31:0] tmp_data
);

    always @(*) begin
        if (mem_to_reg) begin
            read_data = tmp_data;
        end else begin
            read_data = mem_write_addr;
        end
    end

endmodule
