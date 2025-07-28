//design codee
module sipo (
  input clk, rst,
  input si,
  output reg [3:0] q
);
  always @(posedge clk) begin
    if (rst)
      q <= 4'b0000;
    else
      q <= {q[2:0], si};  // Correct shifting: left shift with new bit at LSB
  end
endmodule


//testbench code
`timescale 1ns / 1ps

module tb_sipo;

  // Inputs
  reg clk;
  reg rst;
  reg si;

  // Outputs
  wire [3:0] q;

  // Instantiate the SIPO module
  sipo uut (
    .clk(clk),
    .rst(rst),
    .si(si),
    .q(q)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  initial begin
    // Initial values
    clk = 0;
    rst = 1;
    si = 0;

    // Hold reset for 2 cycles
    #10;
    rst = 0;

    // Shift in 1, 0, 1, 1
    si = 1; #10;
    si = 0; #10;
    si = 1; #10;
    si = 1; #10;

    // Hold input low
    si = 0; #20;

    // Apply reset again
    rst = 1; #10;
    rst = 0;

    // Shift in 1, 1, 0, 0
    si = 1; #10;
    si = 1; #10;
    si = 0; #10;
    si = 0; #10;

    // Finish simulation
    #20;
    $finish;
  end

  // Monitor the output
  initial begin
    $monitor("Time=%0t | rst=%b | si=%b | q=%b", $time, rst, si, q);
  end

endmodule

