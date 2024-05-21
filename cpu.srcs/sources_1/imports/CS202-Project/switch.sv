module switch (
    input clk,
    input rst,
    input [2:0]switch_control,
    input [23:0] switch_rdata,
    input Signed,
    output [31:0] switch_wdata  //  传入给memorio的data
);
    reg signed[23:0] sw_data;
    assign switch_wdata = sw_data;
    always @(*) begin
        if (rst) begin
            sw_data = 0;
        end else if (switch_control==3'b100) begin
            sw_data=switch_rdata;
        end else if (switch_control==3'b101&&Signed==1'b0) begin
            sw_data={16'b00000000_00000000,switch_rdata[7:0]};
        end else if (switch_control==3'b101&&Signed==1'b1) begin
            sw_data= $signed(switch_rdata[7:0]);
        end else if (switch_control==3'b110) begin
            sw_data={8'b00000000,switch_rdata[15:0]};
        end else if (switch_control==3'b111) begin
            sw_data={12'b0000_0000_0000,switch_rdata[11:0]};
        end else begin
            sw_data = sw_data;
        end
    end
endmodule
