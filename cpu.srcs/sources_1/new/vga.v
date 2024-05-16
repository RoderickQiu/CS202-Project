`timescale 1ns / 1ps


module vga (
    input clk,
    input rst,
    input [23:0] val,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b,
    output hs,
    output vs
);

    //vga bound
    parameter UP_BOUND = 31;
    parameter DOWN_BOUND = 510;
    parameter LEFT_BOUND = 144;
    parameter RIGHT_BOUND = 783;

    parameter up_pos_0 = 267;  //first line
    parameter down_pos_0 = 274;
    parameter up_pos_1 = 280;  //second line
    parameter down_pos_1 = 287;
    parameter left_pos = 429;
    parameter right_pos = 498;

    wire pclk;
    reg [1:0] count;
    reg [9:0] hcount, vcount;
    wire [7:0] p0[41:0];
    wire [35:0] data0;

    //control data from val
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            data0 <= 35'b0;  //reset, all zero
        end else begin
            data0[35:30] = val[23:20];
            data0[29:24] = val[19:16];
            data0[23:18] = val[15:12];
            data0[17:12] = val[11:8];
            data0[11:6]  = val[7:4];
            data0[5:0]   = val[3:0];
        end
    end

    // set chars, len = 6 for every digit
    vga_char_set p_1 (
        .clk (clk),
        .rst (rst),
        .data(data0[35:30]),
        .col0(p0[0]),
        .col1(p0[1]),
        .col2(p0[2]),
        .col3(p0[3]),
        .col4(p0[4]),
        .col5(p0[5]),
        .col6(p0[6])
    );
    vga_char_set p_2 (
        .clk (clk),
        .rst (rst),
        .data(data0[29:24]),
        .col0(p0[7]),
        .col1(p0[8]),
        .col2(p0[9]),
        .col3(p0[10]),
        .col4(p0[11]),
        .col5(p0[12]),
        .col6(p0[13])
    );
    vga_char_set p_3 (
        .clk (clk),
        .rst (rst),
        .data(data0[23:18]),
        .col0(p0[14]),
        .col1(p0[15]),
        .col2(p0[16]),
        .col3(p0[17]),
        .col4(p0[18]),
        .col5(p0[19]),
        .col6(p0[20])
    );
    vga_char_set p_4 (
        .clk (clk),
        .rst (rst),
        .data(data0[17:12]),
        .col0(p0[21]),
        .col1(p0[22]),
        .col2(p0[23]),
        .col3(p0[24]),
        .col4(p0[25]),
        .col5(p0[26]),
        .col6(p0[27])
    );
    vga_char_set p_5 (
        .clk (clk),
        .rst (rst),
        .data(data0[11:6]),
        .col0(p0[28]),
        .col1(p0[29]),
        .col2(p0[30]),
        .col3(p0[31]),
        .col4(p0[32]),
        .col5(p0[33]),
        .col6(p0[34])
    );
    vga_char_set p_6 (
        .clk (clk),
        .rst (rst),
        .data(data0[5:0]),
        .col0(p0[35]),
        .col1(p0[36]),
        .col2(p0[37]),
        .col3(p0[38]),
        .col4(p0[39]),
        .col5(p0[40]),
        .col6(p0[41])
    );


    assign pclk = count[1];
    always @(posedge clk or negedge rst) begin
        if (!rst) count <= 0;
        else count <= count + 1;
    end

    // count horizontal and vertical length
    assign hs = (hcount < 96) ? 0 : 1;
    always @(posedge pclk or negedge rst) begin
        if (!rst) hcount <= 0;
        else if (hcount == 799) hcount <= 0;
        else hcount <= hcount + 1;
    end
    assign vs = (vcount < 2) ? 0 : 1;
    always @(posedge pclk or negedge rst) begin
        if (!rst) vcount <= 0;
        else if (hcount == 799) begin
            if (vcount == 520) vcount <= 0;
            else vcount <= vcount + 1;
        end else vcount <= vcount;
    end

    //analyze and get output, for 1 being lit up
    always @(posedge pclk or negedge rst) begin
        if (!rst) begin
            r <= 0;
            g <= 0;
            b <= 0;
        end
        else if (vcount>=UP_BOUND && vcount<=DOWN_BOUND
                 && hcount>=LEFT_BOUND && hcount<=RIGHT_BOUND) begin
            if (hcount >= left_pos && hcount <= right_pos) begin
                if (vcount >= up_pos_0 && vcount <= down_pos_0) begin
                    if (p0[hcount-left_pos][vcount-up_pos_0]) begin
                        r <= 4'b1111;
                        g <= 4'b1111;
                        b <= 4'b1111;
                    end else begin
                        r <= 4'b0000;
                        g <= 4'b0000;
                        b <= 4'b0000;
                    end
                end else begin
                    r <= 4'b0000;
                    g <= 4'b0000;
                    b <= 4'b0000;
                end
            end else begin
                r <= 4'b0000;
                g <= 4'b0000;
                b <= 4'b0000;
            end
        end else begin
            r <= 4'b0000;
            g <= 4'b0000;
            b <= 4'b0000;
        end
    end

endmodule
