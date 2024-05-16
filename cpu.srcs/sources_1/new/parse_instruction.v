`include "define.v"
module parse_instruction (
    input [31:0] instruction,
    output wire [6:0] opcode,
    output reg [31:0] imm,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [6:0] func7,
    output reg [2:0] func3
);

    assign opcode = instruction[6:0];

    always @* begin
        rd = 5'b0;
        func3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        func7 = 7'b0;
        imm = 32'b0;
        case (opcode)
            `R_TYPE: begin  // R-type
                rd = instruction[11:7];
                func3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                func7 = instruction[31:25];
            end
            `I_TYPE_1: begin  // I-type 1
                rd = instruction[11:7];
                func3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            `I_TYPE_2: begin  // I-type 2
                rd = instruction[11:7];
                func3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            `S_TYPE: begin  // S-type
                func3 = instruction[14:12];
                rs1   = instruction[19:15];
                rs2   = instruction[24:20];
                imm   = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            `B_TYPE: begin  // B-type
                func3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {
                    {19{instruction[31]}},
                    instruction[31],
                    instruction[7],
                    instruction[30:25],
                    instruction[11:8],
                    1'b0
                };
            end
            `J_TYPE: begin // J-type
                rd = instruction[11:7];
                imm = {
                    {11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21], 1'b0
                };
            end
            `U_TYPE_LUI: begin  // U-type lui
                rd = instruction[11:7];
                imm = {
                    12'b0,instruction[31:12]
                };
            end
            `U_TYPE_AUIPC: begin  // U-type auipc
                rd = instruction[11:7];
                imm = {
                    12'b0,instruction[31:12]
                };
            end
            `ECALL: begin  //ecall
                func3 = 3'b000;
                imm   = 0;
            end
        endcase
    end

endmodule
