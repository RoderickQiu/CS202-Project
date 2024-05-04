`timescale 1ns / 1ps

module instruct_mem (
    input clk,
    input rst,
    input branch,
    input zero,
    input [31:0] branch_target,
    output [31:0] instruct,
    output reg [31:0] pc,  // 4-based, so addr = pc[15:2]
    output reg [31:0] next_pc,
    output reg [31:0] pc_plus_4
);

    prgrom urom (
        .clka (clk),
        .addra(pc[15:2]),  // input wire [13:0] addr
        .douta(instruct)   // output wire [31:0] dout
    );

    assign pc_plus_4 = {pc[31:2] + 1'b1, pc[1:0]};

    always @(*) begin
        if (branch && zero) begin
            next_pc = branch_target;
        end else begin
            next_pc = pc_plus_4[31:2];
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'b0;
        end else begin
            pc <= next_pc << 2;
        end
    end

endmodule
