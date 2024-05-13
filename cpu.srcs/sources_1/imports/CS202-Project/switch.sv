module switch (
    input clk,
    input rst,
    input switch_control,
    input [23:0] switch_rdata,
    output [31:0] switch_wdata  //  传入给memorio的data
);
    reg [23:0] sw_data;
    assign switch_wdata = {sw_data,8'b00000000};
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            sw_data <= 0;
        end else if (switch_control) begin
            sw_data<=switch_rdata;
        end else begin
            sw_data <= sw_data;
        end
    end
endmodule
