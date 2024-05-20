`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 16:42:11
// Design Name: 
// Module Name: dmem_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dmem_tb(

    );

        reg clk = 0;
        reg [13:0] i = 0;
        reg f = 0;
                
        wire [31:0] out ;
        wire [31:0] in;
        dmem32 dmem (
                .clka (clk ),
                .wea  (f),
                .addra(i),
                .dina (in),
                .douta(out)
            );
        always begin
            #5 clk = !clk;         
        end
        always begin
            #40 i = i+1;         
        end    

endmodule
