module alu (
    input wire [31:0] a, b,
    input wire [3:0] op,
    output reg [31:0] result,
    output wire zero
);
    always @(*) begin
        case (op)
            4'b0000: result = a + b;   // add
            4'b0001: result = a - b;   // sub
            4'b0010: result = a & b;   // and
            4'b0011: result = a | b;   // or
            4'b0100: result = a ^ b;   // xor
            4'b0111: result = b;       // lui
            4'b1000: result = a + b;   // auipc
            default: result = 0;
        endcase
    end
    assign zero = (result == 0);
endmodule
