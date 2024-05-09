`timescale 1ns / 1ps
`include "define.v"
module stage_wb (
    input mem_to_reg,
    output reg [31:0] read_data,
    input oiread,
    input oiwrite,
    output reg switch_control,
    output reg led_control,
    input [31:0]sw_data,
    input [31:0] mem_write_addr,
    input [31:0] tmp_data
);

    always @(*) begin
        if(oiread)begin
            if(mem_write_addr[15:2]==`SWITCH_MEM)begin
                switch_control=1'b1;
            end
        end else begin
                switch_control=1'b0;
        end
        if(oiwrite)begin
            if(mem_write_addr[15:2]==`LED_MEM)led_control=1'b1;
        end else begin
                led_control=1'b0;
        end
        if(switch_control)begin
            read_data=sw_data;
        end if (mem_to_reg) begin
            read_data = tmp_data;
        end else begin
            read_data = mem_write_addr;
        end
    end

endmodule
