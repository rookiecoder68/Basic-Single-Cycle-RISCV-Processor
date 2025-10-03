module riscv_single_cycle (
    input wire clk,
    input wire rst
);
    wire [31:0] pc, instr, alu_result, mem_data, write_data;
    wire [31:0] imm, reg_data1, reg_data2;
    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jump;
    wire [3:0] alu_op;
    wire zero;

    datapath dp (
        .clk(clk), .rst(rst),
        .pc(pc), .instr(instr),
        .alu_result(alu_result), .mem_data(mem_data),
        .write_data(write_data), .imm(imm),
        .reg_data1(reg_data1), .reg_data2(reg_data2),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .branch(branch), .mem_read(mem_read),
        .mem_to_reg(mem_to_reg), .mem_write(mem_write),
        .alu_src(alu_src), .reg_write(reg_write),
        .alu_op(alu_op), .zero(zero), .jump(jump)
    );

    controller ctrl (
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .branch(branch), .mem_read(mem_read), .mem_to_reg(mem_to_reg),
        .alu_op(alu_op), .mem_write(mem_write),
        .alu_src(alu_src), .reg_write(reg_write), .jump(jump)
    );

endmodule
