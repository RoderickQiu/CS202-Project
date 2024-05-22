`timescale 1ns / 1ps
module test ();
    reg clk = 0, fpga_rst = 1, start_pg = 0, rx = 0;
    reg [23:0] switch2N4 = 1024;
    wire [23:0] led2N4 ;
    wire tx = 0;
    wire [3:0] key_row = 4'b0, key_col = 4'b0;
    wire [3:0] r , g,b;
    wire x,xx,xxx;
    assign {x,xx,xxx}=3'b100;
    wire [7:0] seg_an, seg_out;
    cpu cpu1 (
        .clk_in(clk),
        // input clk_in_i,
        .fpga_rst(fpga_rst),
        // input fpga_rst_i, 
        .switch2N4(switch2N4),
        .led2N4(led2N4),
        .seg_out(seg_out),
        // UART ports
        .start_pg(start_pg),
        .rx(rx),
        .tx(tx),
        .r(r),
        .g(g),
        .b(b),
        .hs(hs),
        .vs(vs)
    );
    always begin
        #5 clk = !clk;
    end
    initial begin
        #50 begin
            fpga_rst = 0;
            switch2N4 = 24'b110_00000_0000_0000_0000_0010;
        end
    end

endmodule
