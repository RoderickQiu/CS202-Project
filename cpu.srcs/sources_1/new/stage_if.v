`timescale 1ns / 1ps
// The PC updates according to the rising edge of the clock signal.
// Fetch the instruction from the program ROM according to the PC.
module stage_if (
    input clk,
    input rst,
    input branch,
    input zero,
    input [31:0] imm,
    output [31:0] instruct,
    output reg [31:0] pc  // 4-based, so addr = pc[15:2]
);
    reg [31:0] next_pc;
    wire [31:0] pc_plus_4;

    prgrom urom (
        .clka (clk),
        .addra(pc[15:2]),  // input wire [13:0] addr
        .douta(instruct)   // output wire [31:0] dout
    );

    assign pc_plus_4 = {pc[31:2] + 1'b1, pc[1:0]};

    always @(posedge !clk) begin
        if (branch && zero) begin
            next_pc = pc+imm;
        end else begin
            next_pc = pc_plus_4;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'b0;
        end else begin
            pc <= next_pc;
        end
    end

endmodule