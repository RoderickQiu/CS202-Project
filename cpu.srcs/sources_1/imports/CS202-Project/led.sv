module led (
    input clk,  // 时钟信号
    input rst,  // 复位信号
    input led_control,
    input [23:0] ledwdata,  //  写到LED模块的数据，注意数据线只有16根
    output reg [23:0] ledout  //  向板子上输出的24位LED信号
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledout <= 24'h000000;
        end else if (led_control) begin
            ledout[23:0] <= ledwdata;
        end else begin
            ledout <= ledout;
        end
    end
endmodule
