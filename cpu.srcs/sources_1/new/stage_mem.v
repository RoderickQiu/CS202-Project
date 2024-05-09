`timescale 1ns / 1ps

module stage_mem (
    input clk,
    input rst,
    input mem_read,
    input mem_write,
    input oi_read,
    input oi_write,
    input [31:0] mem_write_addr,  // orgininate from ALU
    input [31:0] mem_write_data,
    output [31:0] tmp_data
);

    wire trans_clk;
    assign trans_clk = !clk;
    wire [31:0]out_mem;
    wire [15:0]out_oi;
    dmem32 dmem (
        .clka (trans_clk),
        .read  (mem_read),
        .wea  (mem_write),
        .addra(mem_write_addr[15:2]),
        .dina (mem_write_data),
        .douta(out_mem)
    );
    oi24 IO (
        .clka (trans_clk),
        .read  (mem_read),
        .wea  (mem_write),
        .addra(mem_write_addr[15:2]),
        .dina (mem_write_data),
        .douta(tmp_out_oi)
    );
    
    mem_or_io dmemio (
        .mem_read (mem_read),
        .mem_write  (mem_write),
        .oi_read(oi_read),
        .oi_write (oi_write),
        .alu_result_addr(mem_write_addr),
        .mem_read_data(out_mem),
        .io_read_data(out_oi),
        .data_read_output(tmp_data),
    );
endmodule
