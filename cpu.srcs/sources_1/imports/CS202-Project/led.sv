`timescale 1ns / 1ps
module led (
    input clk,  // 时钟信号
    input rst,  // 复位信号
    input [5:0]control,
    input [2:0]led_control,
    input [31:0] ledwdata,  //  写到LED模块的数据，注意数据线只�????????16�????????
    output  [7:0] ledout_w,  //  向板子上输出�????????24位LED信号
    output reg [15:0] ledout,  //  向板子上输出�????????24位LED信号
    output reg [31:0] ledtoseg  //  向板子上输出�????????24位LED信号
);

    int i=0;
    assign ledout_w={rst,clk,control};
    // assign ledout=ledwdata[15:0];
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledtoseg <= 0;
            ledout <= 16'h000000;
        end else if (led_control==3'b100) begin
            ledout[15:0] <= ledwdata[15:0];
            ledtoseg <= ledwdata;
            
        end else if (led_control==3'b101) begin
            ledout[15:8] <= ledwdata[7:0];
            ledtoseg[15:8]<=ledwdata[7:0];
        end else if (led_control==3'b110) begin
            ledout[7:0] <= ledwdata[7:0];
            ledtoseg[7:0]<=ledwdata[7:0];
        end else if (led_control==3'b111) begin
            for(i=0;i<=11;i=i+1)begin
                ledout[i] <= ledwdata[11-i];
                ledtoseg[i] <= ledwdata[11-i];
            end
        end else begin
            ledout <= ledout;
            ledtoseg<=ledtoseg;
        end
    end
endmodule
