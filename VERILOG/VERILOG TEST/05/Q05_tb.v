//testbench code
module clk_display_tb;
  reg clk;
  reg rst;
  wire out_clk;


  clk_display uut (.clk(clk),.rst(rst),.out_clk(out_clk));


  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end


  initial begin
    $monitor("Time=%0t|clk=%b|rst=%b|out_clk=%b",$time,clk,rst,out_clk);
  end

  initial begin
  $dumpfile("clk_display.vcd");
  $dumpvars(0, clk_display_tb);

  rst = 1; #50;
  rst = 0;

  #20000000;  
  $finish;
end


endmodule
