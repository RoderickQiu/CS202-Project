module print (
    input clk,  // 时钟信号
    input Stop,  // 复位信号
    input [31:0]in_init,
    input [31:0]new,
    output reg [31:0]  out
);
    reg [15:0]cnt=0;
    reg f=0;
    always @(posedge clk ) begin
        if(Stop&& (f || new!=0))begin
            cnt<=cnt+1;
            f<=1;
            out<={cnt,new[15:0]};
        end else begin
            out<=in_init;
            cnt<=0;
        end
    end
endmodule
