`timescale 1ns / 1ps
`include "define.v"

module mem_or_io (
    input mem_read,
    input mem_write,
    input io_read,
    input io_write,
    input [31:0] alu_result_addr,
    input [31:0] mem_read_data,
    input [15:0] io_read_data,
    input [31:0] data_to_write,
    output [31:0] data_read_output,  // data to register
    output [31:0] addr_output,  // address to memory
    output reg [31:0] data_write_output,  // data to memory or io
    output led_ctrl,
    output switch_ctrl
);

    assign addr_output = alu_result_addr;
    assign data_read_output = mem_read ? mem_read_data : {16'h0000, io_read_data};
    assign led_ctrl = io_write ? 1'b1 : 1'b0;
    assign switch_ctrl = io_read ? 1'b1 : 1'b0;

    always @(*) begin
        if (mem_write || io_write) begin
            data_write_output = data_to_write;
        end else begin
            data_write_output = 32'b0;
        end
    end

endmodule
