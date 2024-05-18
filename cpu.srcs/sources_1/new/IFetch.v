`timescale 1ns / 1ps
// The PC updates according to the rising edge of the clock signal.
// Fetch the instruction from the program ROM according to the PC.
module IFetch (
    input clk,
    input rst,
    input branch,
    input zero,
    input [31:0] imm32,
    output [31:0] inst
);
    
    reg [31:0] next_pc=4,pc=0;

    prgrom urom (
        .clka(clk ),
        .addra(pc[13:0]),  // input wire [13:0] addr
        .douta(inst)  // output wire [31:0] dout
    );

    wire [31:0] pc_plus_4;
    assign pc_plus_4 = pc + 4;


    always @(negedge clk) begin
        if (branch && zero ) begin
            next_pc <= pc + imm32;
        end else begin
            next_pc <= pc_plus_4;
        end
        if (rst) begin
            pc <= 0;
        end else begin
            pc <= next_pc;
        end
    end

endmodule
