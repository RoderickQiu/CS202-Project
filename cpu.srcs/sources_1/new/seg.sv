`timescale 1ns / 1ps
`include "define.v"

module seg (
    input clk,
    input rst,
    input [31:0] val,
    output logic [7:0] seg_out,
    output logic [7:0] tub_sel
);

    logic [3:0] p0, p1, p2, p3, p4, p5, p6, p7;
    logic        clk_slow; 
    logic [31:0] cnt; 
    logic [ 2:0] divider_clk; 
    logic [ 7:0] seg_in;  
    // logic rst_n;
    parameter period = `seg_val_freq; 
    assign p7 = val[3:0];
    assign p6 = val[7:4];
    assign p5 = val[11:8];
    assign p4 = val[15:12];
    assign p3 = val[19:16];
    assign p2 = val[23:20];
    assign p1 = val[27:24];
    assign p0 = val[31:28];
    // assign rst_n = ~rst;

    always_comb begin
        case (seg_in)
            `in_0: seg_out = ~`seg_val_0; // Display '0'
            `in_1: seg_out = ~`seg_val_1; // Display '1'
            `in_2: seg_out = ~`seg_val_2; // Display '2'
            `in_3: seg_out = ~`seg_val_3; // Display '3'
            `in_4: seg_out = ~`seg_val_4; // Display '4'
            `in_5: seg_out = ~`seg_val_5; // Display 'S'
            `in_6: seg_out = ~`seg_val_6; // Display '6'
            `in_7: seg_out = ~`seg_val_7; // Display '7'
            `in_8: seg_out = ~`seg_val_8; // Display '8'
            `in_9: seg_out = ~`seg_val_9; // Display '9'
            `in_A: seg_out = ~`seg_val_A; // Display 'A'
            `in_B: seg_out = ~`seg_val_B; // Display 'b'
            `in_C: seg_out = ~`seg_val_C; // Display 'C'
            `in_D: seg_out = ~`seg_val_D; // Display 'd'
            `in_E: seg_out = ~`seg_val_E; // Display 'E'
            `in_F: seg_out = ~`seg_val_F; // Display 'F'
            default: seg_out = ~0;     // Display nothing
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            clk_slow <= 0;
            cnt <= 0;
        end else begin
            if (cnt == (period >> 1) - 1) begin
                clk_slow <= ~clk_slow;
                cnt <= 32'd0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    always @(posedge clk_slow, posedge rst) begin
        if (rst) begin
            divider_clk <= 0;
        end else begin
            if (divider_clk == 3'd7) begin
                divider_clk <= 0;
            end else begin
                divider_clk <= divider_clk + 1;
            end
        end
    end

    always @(*) begin
        case (divider_clk)
            3'b000: begin
                tub_sel = ~8'b00000001;
                seg_in = p0;
            end
            3'b001: begin
                tub_sel = ~8'b00000010;
                seg_in = p1;
            end
            3'b010: begin
                tub_sel = ~8'b00000100;
                seg_in = p2;
            end
            3'b011: begin
                tub_sel = ~8'b00001000;
                seg_in = p3;
            end
            3'b100: begin
                tub_sel = ~8'b00010000;
                seg_in = p4;
            end
            3'b101: begin
                tub_sel = ~8'b00100000;
                seg_in = p5;
            end
            3'b110: begin
                tub_sel = ~8'b01000000;
                seg_in = p6;
            end
            3'b111: begin
                tub_sel = ~8'b10000000;
                seg_in = p7;
            end
            default: tub_sel = ~8'b00000000;
        endcase
    end

endmodule
