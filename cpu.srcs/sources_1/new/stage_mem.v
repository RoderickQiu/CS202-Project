`timescale 1ns / 1ps

module stage_mem (
    input clk,
    input rst,
    input mem_read,
    input mem_write,
    input [31:0] data_switch,
    input [31:0] mem_write_addr,  // orgininate from ALU
    input [31:0] mem_write_data,
    output [31:0] tmp_data,
    output [2:0] switch_control,
    output [2:0] led_control,
    input upg_rst_i,  // UPG reset (Active High)
    input upg_clk_i,  // UPG ram_clk_i (10MHz)
    input upg_wen_i,  // UPG write enable
    input [14:0] upg_adr_i,  // UPG write address
    input [31:0] upg_dat_i,  // UPG write data
    input upg_done_i  // 1 if programming is finished
);

    wire trans_clk;
    assign trans_clk = !clk;
    // CPU work on normal mode when kickOff is 1
    // CPU work on Uart communicate mode when kickOff is 0
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

    // wire [31:0] out_mem;
    // wire [15:0] out_oi;
//    wire write = mem_write | oi_write;
    dmem32 dmem (
        .clka (kickOff ? trans_clk : upg_clk_i),
        .wea  (kickOff ? mem_write : upg_wen_i),
        .addra(kickOff ? mem_write_addr[15:2] : upg_adr_i[13:0]),
        .dina (kickOff ? mem_write : upg_dat_i),
        .douta(tmp_data)
    );

    // oi24 IO (
    //     .clka (trans_clk),
    //     .read (mem_read),
    //     .wea  (mem_write),
    //     .addra(mem_write_addr[15:2]),
    //     .dina (mem_write_data),
    //     .douta(tmp_out_oi)
    // );

    mem_or_io dmemio (
        // .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_result_addr(kickOff ? mem_write_addr[15:2] : upg_adr_i[13:0]),
        .led_control(led_control),
        .switch_control(switch_control)
        // .Result(tmp_data)
    );
endmodule
