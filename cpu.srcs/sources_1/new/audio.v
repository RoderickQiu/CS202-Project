`timescale 1ns / 1ps

module audio (
    input clk,
    input slow_clk,
    input rst,
    input enable, 
    input [31:0] cur_note,
    output reg[0:0] buzzer = 0
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
parameter rest =  3_750_000;
parameter index_period = note_period + rest;

parameter silence = 30'h3fff_ffff;

reg[29:0] cur_half_period = note_period;
reg[31:0] cur_note_play;

integer cur_half_period_count = 0;      // inverse buzzer if cur_half_period_count > note_period
integer index_count = 0;      // add index by 1 if index_count > index_period

always @(posedge clk) begin
    if(rst) begin
        index_count = 0;
        cur_half_period_count = 0;
        buzzer = 0;
    end else begin
        if(cur_half_period_count >= cur_half_period) begin
            cur_half_period_count = 0;
            buzzer = ~buzzer;
         end
        else cur_half_period_count = cur_half_period_count + 1;
        if(index_count > index_period) begin
            index_count = 0;
        end
    end
    index_count = index_count + 1;
end


// Audio buffer memory
reg [31:0] read_ptr = 0, write_ptr = 0;
reg [31:0] ram[0:255];

initial begin
    ram[0] = 0;
    read_ptr = 0;
    cur_note_play = 0;
    write_ptr = 0;
end

// Write data to RAM when input changes
// Write without waiting for a clock edge
always @(cur_note) begin
    if (ram[write_ptr] != cur_note && cur_note != 0) begin
        write_ptr = write_ptr + 1;
        ram[write_ptr] = cur_note;
    end
end

// Read data from RAM on slow clock edge
always @(posedge slow_clk) begin
    cur_note_play <= ram[read_ptr];
    read_ptr <= read_ptr + 1;
end

always @(*) begin
    case(cur_note_play)
        32'h30303030 : cur_half_period = silence; // 0000
        32'h30303031 : cur_half_period = do_low; // 0001
        32'h30303130 : cur_half_period = re_low; // 0010
        32'h30303131 : cur_half_period = me_low; // 0011
        32'h30313030 : cur_half_period = fa_low; // 0100
        32'h30313031 : cur_half_period = so_low; // 0101
        32'h30313130 : cur_half_period = la_low; // 0110
        32'h30313131 : cur_half_period = si_low; // 0111
        32'h31303030 : cur_half_period = do; // 1000
        32'h31303031 : cur_half_period = re; // 1001
        32'h31303130 : cur_half_period = me; // 1010
        32'h31303131 : cur_half_period = fa; // 1011
        32'h31313030 : cur_half_period = so; // 1100
        32'h31313031 : cur_half_period = la; // 1101
        32'h31313130 : cur_half_period = si; // 1110
        default : cur_half_period = silence;
    endcase 
end

endmodule