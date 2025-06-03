//design code
module clk_gen(
  output reg clk);
  initial begin
    forever #5 clk=~clk;
  end
endmodule

//testbench code
module clk_gen_tb;
  wire clk;
  clk_gen uut(.clk(clk));
  initial begin
    $dumpfile("clk_gen.vcd");
    $dumpvars(1,clk_gen_tb);
  end
  initial begin
    $monitor("Time=%0t|clk=%b",$time,clk);
  end
endmodule
