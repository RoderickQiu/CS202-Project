`timescale 1ns / 1ps
// The PC updates according to the rising edge of the clock signal.
// Fetch the instruction from the program ROM according to the PC.
module stage_if (
    input clk,
    input rst,
    input branch,
    input zero,
    input Jump,
    input [31:0]rs1,
    input JR,
    input [31:0] imm,
    output [31:0] instruct,
    output reg [31:0] pc,  // 4-based, so addr = pc[15:2]
    input upg_rst_i,  // UPG reset (Active High)
    input upg_clk_i,  // UPG clock (10MHz)
    input upg_wen_i,  // UPG write enable
    input [14:0] upg_adr_i,  // UPG write address
    input [31:0] upg_dat_i,  // UPG write data
    input upg_done_i  // 1 if program finish
);
    wire trans_clk;
    assign trans_clk = clk;
    reg [31:0] next_pc;
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

    prgrom urom (
        .clka(trans_clk),
        .wea(1'b0),  // write enable
        .addra(pc[15:2]),  // input wire [13:0] addr
        .dina(32'h0000_0000),  // input wire [31:0] din
        .douta(instruct)  // output wire [31:0] dout
    );

    wire [31:0] pc_plus_4;
    assign pc_plus_4 = pc + 4;


    // always @(posedge clk) begin
    //     if ((branch && zero) || Jump) begin
    //         next_pc <= pc + imm;
    //     end else begin
    //         next_pc <= pc_plus_4;
    //     end
    // end
    always @(*) begin
        if (JR) begin
            next_pc = rs1 + imm;
        end 
        else if ((branch && zero) || Jump) begin
            next_pc = pc + imm;
        end else begin
            next_pc = pc_plus_4;
        end
    end
    always @(negedge clk) begin
        if (rst) begin
            pc <= -4;
        end else begin
            pc <= next_pc;
        end
    end

endmodule
