module led (
    input clk,  // 时钟信号
    input rst,  // 复位信号
    input fpga_rst,  // 复位信号
    input upg_rst,  // 复位信号
    input [31:0]pc,
    input [2:0]led_control,
    input [23:0] ledwdata,  //  写到LED模块的数据，注意数据线只�????16�????
    output  [7:0] ledout_w,  //  向板子上输出�????24位LED信号
    output reg [15:0] ledout  //  向板子上输出�????24位LED信号
);

    int i=0;
    assign ledout_w={fpga_rst,upg_rst,rst,clk,pc[5:2]};
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledout <= 24'h000000;
        end else if (led_control==3'b100) begin
            ledout[15:0] <= ledwdata;
        end else if (led_control==3'b101) begin
            ledout[15:8] <= ledwdata[7:0];
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
