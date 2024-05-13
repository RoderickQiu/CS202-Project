module sim_id ();

    /*
    module stage_id (
        input clk,
        input rst,
        input [31:0] Instruction,
        input [31:0] Reg_con,
        output Branch,
        output Memread,
        output Memtoreg,
        output [3:0] ALUop,
        output Memwrite,
        output ALUSRC,
        output RegWrite,
        output OIread,
        output OIwrite,
        output [31:0] Reg_out1,
        output [31:0] Reg_out2,
        output [31:0] Imm,
        output [6:0] func7,
        output [2:0] func3
    ); 

    00100c63,
    00000033,
    00004033,
    00002297,
    ff428293,
    00028083,
    fff07013,
    ffe00013,
    00129023,
    fddff06f,
    0000006f,
    */

    reg clk = 0, rst = 1;
    reg [31:0] Instruction, Reg_con;
    wire Branch, Memread, Memtoreg, Memwrite, ALUSRC, RegWrite, OIread, OIwrite;
    wire [3:0] ALUop;
    wire [31:0] Reg_out1, Reg_out2, Imm;
    wire [6:0] func7;
    wire [2:0] func3;
    wire oi;
    wire [6:0] opcode;
    wire [4:0] Reg_id1, Reg_id2, Reg_idwr;

    stage_id ID (
        .clk(clk),
        .rst(rst),
        .Instruction(Instruction),
        .Reg_con(Reg_con),
        .Branch(Branch),
        .Memread(Memread),
        .Memtoreg(Memtoreg),
        .ALUop(ALUop),
        .Memwrite(Memwrite),
        .ALUSRC(ALUSRC),
        .RegWrite(RegWrite),
        .OIread(OIread),
        .OIwrite(OIwrite),
        .Reg_out1(Reg_out1),
        .Reg_out2(Reg_out2),
        .Imm(Imm),
        .func7(func7),
        .func3(func3)
    );

    always begin
        #10 clk = !clk;
    end
    initial begin
        begin
            rst = 0;
            Instruction = 32'h00000000;
            Reg_con = 32'h00000000;
        end
        #150 Instruction = 32'h00100c63;
        #200 Instruction = 32'h00000033;
        #250 Instruction = 32'h00004033;
        #300 Instruction = 32'h00002297;
        #350 Instruction = 32'hff428293;
        #400 Instruction = 32'h00028083;
        #450 Instruction = 32'hfff07013;
        #500 Instruction = 32'hffe00013;
        #550 Instruction = 32'h00129023;
        #600 Instruction = 32'hfddff06f;
        #650 Instruction = 32'h0000006f;
    end

endmodule
