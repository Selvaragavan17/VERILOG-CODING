
//design code

module piso_register (
  input  wire       clk,     // Clock
  input  wire       rst,     // Synchronous active-high reset
  input  wire       load,    // Load control signal
  input  wire [3:0] D,       // 4-bit parallel input
  output reg        Q        // Serial output (MSB first)
);

  reg [3:0] shift_reg;       // Internal register

  always @(posedge clk) begin
    if (rst)
      shift_reg <= 4'b0000;
    else if (load)
      shift_reg <= D;        // Load parallel input
    else
      shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
  end

  always @(posedge clk) begin
    Q <= shift_reg[3];       // Output MSB (before shift)
  end

endmodule





//testbench code
module tb_piso_register;
  reg clk, rst, load;
  reg [3:0] D;
  wire Q;

  piso_register uut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .D(D),
    .Q(Q)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $monitor("Time=%0t | D=%b load=%b rst=%b Q=%b", $time, D, load, rst, Q);

    rst = 1; load = 0; D = 4'b0000; #10;
    rst = 0; D = 4'b1011; load = 1; #10; // Load input
    load = 0; #40;                      // Start shifting
    $finish;
  end
endmodule
