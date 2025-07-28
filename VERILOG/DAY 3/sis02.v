module siso (
  input clk,          // Clock
  input rst,          // Synchronous Reset
  input si,           // Serial input
  output reg so       // Serial output (LSB of shift register)
);
  reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (rst)
      shift_reg <= 4'b0000;
    else
      shift_reg <= {si, shift_reg[3:1]}; // Right shift, insert SI at MSB
  end

  always @(*) begin
    so = shift_reg[0]; // LSB is the serial output
  end
endmodule


`timescale 1ns / 1ps

module siso_tb;

  // Inputs
  reg clk;
  reg rst;
  reg si;

  // Output
  wire so;

  // Instantiate the SISO module
  siso uut (
    .clk(clk),
    .rst(rst),
    .si(si),
    .so(so)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    si = 0;

    // Hold reset for 2 clock cycles
    #12;
    rst = 0;

    // Apply serial inputs: 1, 0, 1, 1
    si = 1; #10;
    si = 0; #10;
    si = 1; #10;
    si = 1; #10;

    // Hold SI low after that
    si = 0; #50;

    // Finish simulation
    $finish;
  end

  // Monitor values
  initial begin
    $monitor("Time=%0t | rst=%b | si=%b | so=%b", $time, rst, si, so);
  end

endmodule
