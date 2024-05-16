`timescale 1ns / 1ps
`include "define.v"

module mem_or_io (
    input oi_read,
    input oi_write,
    input [13:0]alu_result_addr,
    output [2:0]led_control,
    // output Result  // data to register
    // output [31:0] addr_output,  // address to memory
    // output reg [31:0] data_write_output,  // data to memory or io
    output [2:0]switch_ctrl
);

    // assign addr_output = alu_result_addr;
    // assign Result = mem_read ? mem_read_data : {16'h0000, io_read_data};
    // assign led_ctrl = io_write ? 1'b1 : 1'b0;
    // assign switch_ctrl = io_read ? 1'b1 : 1'b0;

    always @(*) begin
        if (oi_read && alu_result_addr[13:2]==SWITCH_MEM) begin
            switch_control = {alu_result_addr[1:0],1'b1};
        end else begin
            switch_control = 3'b000;
        end
        if (oi_write && alu_result_addr[13:2]==LED_MEM) begin
            led_control = {alu_result_addr[1:0],1'b1};
        end else begin
            led_control = 3'b000;
        end
        
    end

endmodule
