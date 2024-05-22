module print (
    input clk,  // 时钟信号
    input rst,  // 复位信号
    input [5:0]control,
    input [2:0]led_control,
    input [23:0] ledwdata,  
    output  [7:0] ledout_w, 
    output reg [15:0] ledout 
);

    int i=0;
    assign ledout_w={rst,clk,control};
    // assign ledout=ledwdata[15:0];
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledout <= 16'h000000;
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
