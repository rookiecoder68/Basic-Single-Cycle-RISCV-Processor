`timescale 1ns / 1ps

module tb_riscv;

    reg clk;
    reg rst;

    // Instantiate the top-level module
    riscv_single_cycle uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initial setup and program loading
    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_riscv);

        rst = 1;
        #10 rst = 0;

        // Load program into instruction memory manually
        // Example program: adds two numbers and stores result
        // addi x1, x0, 5
        // addi x2, x0, 10
        // add  x3, x1, x2
        // sw   x3, 0(x0)
        // lw   x4, 0(x0)
        uut.dp.instr_mem[0] = 32'h00500093;  // addi x1, x0, 5
        uut.dp.instr_mem[1] = 32'h00a00113;  // addi x2, x0, 10
        uut.dp.instr_mem[2] = 32'h002081b3;  // add x3, x1, x2
        uut.dp.instr_mem[3] = 32'h00302023;  // sw x3, 0(x0)
        uut.dp.instr_mem[4] = 32'h00002283;  // lw x5, 0(x0)
        uut.dp.instr_mem[5] = 32'h00000013;  // nop (addi x0, x0, 0)

        // Wait some cycles to execute
        #100;

        // Print final register values
        $display("x1 = %d", uut.dp.regfile[1]);
        $display("x2 = %d", uut.dp.regfile[2]);
        $display("x3 = %d", uut.dp.regfile[3]);
        $display("x5 = %d", uut.dp.regfile[5]);  // loaded value

        $finish;
    end
endmodule
