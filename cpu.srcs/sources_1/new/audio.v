`timescale 1ns / 1ps

module audio (
    input clk,
    input rst,
    input stop,
    input [3:0] cur_note,
    output reg [0:0] buzzer = 0
 );

parameter do_low = 382225;
parameter re_low = 340524;
parameter me_low = 303372;
parameter fa_low = 286345;
parameter so_low = 255105;
parameter la_low = 227272;
parameter si_low = 202476;

parameter do = 191110;
parameter re = 170259;
parameter me = 151685;
parameter fa = 143172;
parameter so = 127554;
parameter la = 113636;
parameter si = 101239;

parameter note_period = 15_000_000;

parameter silence = 30'h3fff_ffff;

reg[29:0] cur_half_period = note_period;

integer cur_half_period_count = 0;      // inverse buzzer if cur_half_period_count > note_period

always @(posedge clk) begin
    if(rst) begin
        cur_half_period_count <= 0;
        buzzer <= 0;
    end else begin
        if(cur_half_period_count >= cur_half_period) begin
            cur_half_period_count <= 0;
            buzzer <= ~buzzer;
         end
        else cur_half_period_count <= cur_half_period_count + 1;
    end
end

always @(*) begin
    case(cur_note)
        4'd0 : cur_half_period = silence; // 0000
        4'd1 : cur_half_period = do_low; // 0001
        4'd2 : cur_half_period = re_low; // 0010
        4'd3 : cur_half_period = me_low; // 0011
        4'd4 : cur_half_period = fa_low; // 0100
        4'd5 : cur_half_period = so_low; // 0101
        4'd6 : cur_half_period = la_low; // 0110
        4'd7 : cur_half_period = si_low; // 0111
        4'd8 : cur_half_period = do; // 1000
        4'd9 : cur_half_period = re; // 1001
        4'd10 : cur_half_period = me; // 1010
        4'd11 : cur_half_period = fa; // 1011
        4'd12 : cur_half_period = so; // 1100
        4'd13 : cur_half_period = la; // 1101
        4'd14 : cur_half_period = si; // 1110
        default : cur_half_period = silence;
    endcase 
end

endmodule