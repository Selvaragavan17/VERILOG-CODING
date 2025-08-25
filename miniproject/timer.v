`timescale 1ns/1ps

module timer (
  input clk,
  input rst_n,
  input timer_enb,
  output reg tick
);

  reg [2:0] count; // 3-bit counter: 0 to 4

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tick <= 1'b0;
      count <= 3'd0;
    end
    else if (timer_enb) begin
      if (count == 3'd4) begin
        tick <= 1'b1;      // Generate tick every 5 clock cycles
        count <= 3'd0;
      end else begin
        tick <= 1'b0;
        count <= count + 1;
      end
    end else begin
      count <= 3'd0;
      tick <= 1'b0;
    end
  end

endmodule

//testbench code
`timescale 1ns/1ps

module tb_timer;

  reg clk;
  reg rst_n;
  reg timer_enb;
  wire tick;

  // Instantiate DUT
  timer uut (
    .clk(clk),
    .rst_n(rst_n),
    .timer_enb(timer_enb),
    .tick(tick)
  );

  // Clock Generation: 50MHz (period = 20ns)
  always #10 clk = ~clk;

  initial begin
    $dumpfile("timer.vcd");
    $dumpvars(0, tb_timer);
  end

  initial begin
    clk = 0;
    rst_n = 0;
    timer_enb = 0;

    #25 rst_n = 1;           // Deassert reset at 25ns
    #125 timer_enb = 1;      // Enable timer at 150ns

    #300 timer_enb = 0;      // Disable timer after 300ns
    #100 $finish;
  end

  always @(posedge clk) begin
    $display("Time=%0t | rst_n=%b | timer_enb=%b | tick=%b", $time, rst_n, timer_enb, tick);
  end

endmodule

