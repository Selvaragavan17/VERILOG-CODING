10.write a verilog code to generate random numbers between -100 to 100?

module random_gen;
  integer rand_val;
  integer i;
  initial begin
    for (i = 0; i < 10; i = i + 1) begin
      rand_val = ($urandom%201)-100;
      $display("Random number %0d: %0d", i, rand_val);
      #10;
    end
    $finish;
  end

endmodule
