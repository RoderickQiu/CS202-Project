module led (
    input clk,  // 时钟信号
    input rst,  // 复位信号
    input [2:0]led_control,
    input [23:0] ledwdata,  //  写到LED模块的数据，注意数据线只有16根
    output reg [23:0] ledout  //  向板子上输出的24位LED信号
);
    int i=0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledout <= 24'h000000;
        end else if (led_control==3'b100) begin
            ledout[23:0] <= ledwdata;
        end else if (led_control==3'b101) begin
            ledout[23:16] <= ledwdata[23:16];
        end else if (led_control==3'b110) begin
            ledout[7:0] <= ledwdata[7:0];
        end else if (led_control==3'b111) begin
            for(i=0;i<=11;i=i+1)begin
                ledout[i] <= ledwdata[11-i];
            end
        end else begin
            ledout <= ledout;
        end
    end
endmodule
