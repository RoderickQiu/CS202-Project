module sim_if ();
    reg clk=0, rst=1;
    wire branch=0, zero=0, Jump=0;
    wire [31:0] imm=0;
    wire [31:0] instruct;
    wire [31:0] pc;
    wire upg_rst_i, upg_clk_i, upg_wen_i, upg_done_i;
    wire [14:0] upg_adr_i;
    wire [31:0] upg_dat_i;
    stage_if IF (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .zero(zero),
        .Jump(Jump),
        .imm(imm),
        .instruct(instruct),
        .pc(pc),
        .upg_rst_i(upg_rst_i),
        .upg_clk_i(upg_clk_i),
        .upg_wen_i(upg_wen_i),
        .upg_adr_i(upg_adr_i),
        .upg_dat_i(upg_dat_i),
        .upg_done_i(upg_done_i)
    );
    always begin
        #10 clk = !clk;
    end
    initial begin
        #100 begin
            rst = 0;
        end
    end
endmodule
