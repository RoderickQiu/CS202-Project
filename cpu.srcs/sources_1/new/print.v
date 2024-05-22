module print (
    input clk,  // 时钟信号
    input Stop,  // 复位信号
    input [15:0]in_init,
    input [31:0]new,
    output reg [31:0]  out
);

    always @(posedge clk ) begin
        if(Stop&& new!=0)begin
            out=new;
        end else begin
            out={16'b00000000_00000000,in_init};
        end
    end
endmodule
