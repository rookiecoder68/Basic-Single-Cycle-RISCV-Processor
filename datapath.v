module datapath (
    input wire clk, rst,
    output reg [31:0] pc,
    output wire [31:0] instr,
    output wire [31:0] alu_result,
    input wire [31:0] mem_data,
    output wire [31:0] write_data,
    output wire [31:0] imm,
    output wire [31:0] reg_data1, reg_data2,
    output wire [4:0] rs1, rs2, rd,
    output wire [6:0] opcode,
    output wire [2:0] funct3,
    output wire [6:0] funct7,
    input wire branch, mem_read, mem_to_reg,
    input wire mem_write, alu_src, reg_write, jump,
    input wire [3:0] alu_op,
    output wire zero
);

    reg [31:0] instr_mem [0:255];
    reg [31:0] data_mem [0:255];
    reg [31:0] regfile [0:31];
    wire [31:0] alu_in2;
    wire [31:0] pc_next;

    assign instr = instr_mem[pc[9:2]];

    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    assign reg_data1 = regfile[rs1];
    assign reg_data2 = regfile[rs2];

    assign imm = (opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b1100111) ? 
                    {{20{instr[31]}}, instr[31:20]} :  // I-type
                 (opcode == 7'b0100011) ?
                    {{20{instr[31]}}, instr[31:25], instr[11:7]} : // S-type
                 (opcode == 7'b1100011) ?
                    {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} : // B-type
                 (opcode == 7'b1101111) ?
                    {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0} : // JAL
                 (opcode == 7'b0110111 || opcode == 7'b0010111) ?
                    {instr[31:12], 12'b0} : 32'b0;

    assign alu_in2 = alu_src ? imm : reg_data2;

    alu my_alu (
        .a(reg_data1), .b(alu_in2), .op(alu_op),
        .result(alu_result), .zero(zero)
    );

    assign write_data = mem_to_reg ? mem_data : alu_result;

    always @(posedge clk) begin
        if (rst) begin
            pc <= 0;
            regfile[0] <= 0; // x0 is always zero
        end else begin
            if (branch && zero) pc <= pc + imm;
            else if (jump) pc <= reg_data1 + imm; // for jalr
            else pc <= pc + 4;
        end

        if (reg_write && rd != 0)
            regfile[rd] <= write_data;

        if (mem_write)
            data_mem[alu_result[9:2]] <= reg_data2;

        regfile[0] <= 0; // I made x0 to always be zero
        
    end
endmodule
