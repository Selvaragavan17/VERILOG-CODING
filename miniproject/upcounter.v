`timescale 1ns/1ps

module upcounter(
    input clk,
    input rst_n,
    input ce,
    input out_init,
    output [7:0] cout
);

    wire [3:0] lsb, msb;

    // ones digit counter
    decimal_counter lsb_counter (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .load(out_init),
        .flag(1'b1),
        .din(4'd0),
        .q(lsb),
        .carry()
    );

    // tens digit tick when lsb == 9 and counting enabled
    wire msb_tick = ce & ~out_init & (lsb == 4'd9);

    // tens digit counter
    decimal_counter msb_counter (
        .clk(clk),
        .rst_n(rst_n),
        .ce(msb_tick),
        .load(out_init),
        .flag(1'b1),
        .din(4'd0),
        .q(msb),
        .carry()
    );

    assign cout = (msb * 8'd10) + lsb;

  //testbench
  `timescale 1ns/1ps

module tb_upcounter;

    reg clk;
    reg rst_n;
    reg ce;
    reg out_init;
    wire [7:0] cout;

    // Instantiate the DUT
    upcounter uut (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .out_init(out_init),
        .cout(cout)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Monitor console output
    initial begin
        $dumpfile("upcounter.vcd");
        $dumpvars(0, tb_upcounter);
        $monitor("Time = %0t | rst_n = %b | ce = %b | out_init = %b | cout = %d",
                  $time, rst_n, ce, out_init, cout);
    end

    // Stimulus
    initial begin
        clk = 0;
        rst_n = 0;
        ce = 0;
        out_init = 0;

        #12 rst_n = 1;
        #10 out_init = 1;
        #10 out_init = 0;
            ce = 1;

        #1200 ce = 0;
        #20 $finish;
    end

endmodule


endmodule
