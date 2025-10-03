module controller (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg branch, mem_read, mem_to_reg,
    output reg [3:0] alu_op,
    output reg mem_write, alu_src, reg_write, jump
);
    always @(*) begin
        // Default values
        branch = 0; mem_read = 0; mem_to_reg = 0;
        alu_op = 4'b0000;
        mem_write = 0; alu_src = 0; reg_write = 0; jump = 0;

        case (opcode)
            7'b0110011: begin // R-type
                alu_src = 0; reg_write = 1;
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_op = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_op = 4'b0001; // SUB
                    {7'b0000000, 3'b111}: alu_op = 4'b0010; // AND
                    {7'b0000000, 3'b110}: alu_op = 4'b0011; // OR
                    {7'b0000000, 3'b100}: alu_op = 4'b0100; // XOR
                endcase
            end
            7'b0010011: begin // I-type (addi)
                alu_src = 1; reg_write = 1; alu_op = 4'b0000;
            end
            7'b0000011: begin // LW
                alu_src = 1; mem_to_reg = 1;
                mem_read = 1; reg_write = 1; alu_op = 4'b0000;
            end
            7'b0100011: begin // SW
                alu_src = 1; mem_write = 1; alu_op = 4'b0000;
            end
            7'b1100011: begin // BEQ
                alu_src = 0; branch = 1; alu_op = 4'b0001;
            end
            7'b1101111: begin // JAL
                jump = 1; reg_write = 1;
            end
            7'b1100111: begin // JALR
                jump = 1; reg_write = 1; alu_src = 1;
            end
            7'b0110111: begin // LUI
                reg_write = 1; alu_op = 4'b0111;
            end
            7'b0010111: begin // AUIPC
                reg_write = 1; alu_op = 4'b1000;
            end
        endcase
    end
endmodule
