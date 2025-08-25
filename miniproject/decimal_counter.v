`timescale 1ns/1ps

module decimal_counter (
    input clk,
    input rst_n,
    input flag,      // 1 for up, 0 for down
    input ce,        // count enable
    input load,      // load control
    input [3:0] din, // data input
    output reg [3:0] q,
    output reg carry // carry/borrow flag
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 4'd0;
        carry <= 1'b0;
    end else if (load) begin
        q <= din;
        carry <= 1'b0;
    end else if (ce) begin
        if (flag) begin // UP count
            if (q == 4'd9) begin
                q <= 4'd0;
                carry <= 1'b1;
            end else begin
                q <= q + 1;
                carry <= 1'b0;
            end
        end else begin // DOWN count
            if (q == 4'd0) begin
                q <= 4'd9;
                carry <= 1'b1;
            end else begin
                q <= q - 1;
                carry <= 1'b0;
            end
        end
    end
end

endmodule

//testbench code
`timescale 1ns/1ps

module tb_decimal_counter;

  reg clk, rst_n, flag, ce, load;
  reg [3:0] din;
  wire [3:0] q;
  wire carry;

  decimal_counter dut (
    .clk(clk),
    .rst_n(rst_n),
    .flag(flag),
    .ce(ce),
    .load(load),
    .din(din),
    .q(q),
    .carry(carry)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $display("Decimal Counter Testbench Started...");
    $dumpfile("decimal_counter.vcd");
    $dumpvars(0, tb_decimal_counter);

    clk = 0;
    rst_n = 0;
    flag = 1; // Up
    ce = 0;
    load = 0;
    din = 4'd0;

    #10 rst_n = 1;

    // Load value 5
    load = 1;
    din = 4'd5;
    #10;
    load = 0;

    // Up count
    ce = 1;
    flag = 1;
    repeat (6) begin
      #10;
      $display("UP Count -> Q = %0d, Carry = %b", q, carry);
    end

    // Down count
    flag = 0;
    repeat (6) begin
      #10;
      $display("DOWN Count -> Q = %0d, Carry = %b", q, carry);
    end

    $display("Decimal Counter Testbench Completed.");
    $finish;
  end

endmodule

