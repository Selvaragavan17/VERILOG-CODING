`timescale 1ns / 1ps

module tb_top;

  // Inputs
  reg clk;
  reg rst_n;
  reg async_in;
  reg mode;

  // Outputs
  wire [6:0] out1;
  wire [6:0] out2;

  // Internal probe to see counter value
  wire [7:0] count_val;

  // Instantiate DUT
  top dut (
    .clk(clk),
    .rst_n(rst_n),
    .async_in(async_in),
    .mode(mode),
    .out1(out1),
    .out2(out2)
  );

  // Tap the counter output directly
  assign count_val = dut.u_counter.cout;

  // Clock generation: 50MHz -> 20ns period
  always #10 clk = ~clk;

  initial begin
    $display("Starting top module testbench...");
    $dumpfile("tb_top.vcd");
    $dumpvars(0, tb_top);

    // Initialize
    clk = 0;
    rst_n = 0;
    async_in = 0;
    mode = 1; // Common Cathode mode

    // Apply reset
    #25 rst_n = 1;

    // Wait some cycles
    #100;

    // Start stopwatch: async_in high
    async_in = 1;
    #2000;   // keep high long enough to count a few digits
    async_in = 0;

    // Let the counter freeze
    #500;

    // Switch to Common Anode mode
    mode = 0;
    #1000;

    $display("Simulation completed.");
    $finish;
  end

  // Console monitor
  initial begin
    $monitor("T=%0t | rst_n=%b async_in=%b mode=%b | COUNT=%0d | out1=%b out2=%b",
             $time, rst_n, async_in, mode, count_val, out1, out2);
  end

endmodule
