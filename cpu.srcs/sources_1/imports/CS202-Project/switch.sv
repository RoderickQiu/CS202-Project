`timescale 1ns / 1ps
module switch (
    input clk,
    input rst,
    input [2:0]switch_control,
    input [23:0] switch_rdata,
    input Signed,
    output reg [31:0] switch_wdata  //  传入给memorio的data
);
    /*
        100:all unsigned
        101:8bit mid�??signed
        001:8bit right signed
        110:16bit unsigned
        111:12bit unsigned
    */
    always @(*) begin
        if (rst) begin
            switch_wdata = 0;
        end else if (switch_control==3'b100) begin
            switch_wdata={8'b0000_0000,switch_rdata};
        end else if (switch_control==3'b101) begin
            switch_wdata={{24{switch_rdata[15]}},switch_rdata[15:8]};
        end else if (switch_control==3'b001) begin
            switch_wdata={{24{switch_rdata[7]}},switch_rdata[7:0]};
        end else if (switch_control==3'b110) begin
            switch_wdata={16'b0000_0000_0000_0000,switch_rdata[15:0]};
        end else if (switch_control==3'b111) begin
            switch_wdata={20'b0000_0000_0000_0000_0000,switch_rdata[11:0]};
        end else begin
            switch_wdata = switch_wdata;
        end
    end
endmodule
