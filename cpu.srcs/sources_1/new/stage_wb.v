`timescale 1ns / 1ps
module stage_wb (
    input mem_to_reg,
    output reg [31:0] read_data,
    input oiread,
    input oiwrite,
    input switch_control,
    input led_control,
    input [31:0]sw_data,
    input [31:0] mem_write_addr,
    output [31:0] tmp_data
);

    always @(*) begin
        if(oiread)begin
            if(mem_write_addr[15:2]=`SWITCH_MEM)begin
                mem_write_addr=sw_data;
                switch_control=1b'1;
            end
        end else begin
                switch_control=1b'0;
        end
        if(oiwrite)begin
            if(mem_write_addr[15:2]=`LED_MEM)led_control=1b'1;
        end else begin
                led_control=1b'0;
        end
        if (mem_to_reg) begin
            read_data = tmp_data;
        end else begin
            read_data = mem_write_addr;
        end
    end

endmodule
