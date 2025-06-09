//design code
module t_flipflop(
  input clk,rst,t,
  output reg q);
  always@(posedge clk)begin
    if(rst)
      q<=0
    else if(t)
      q<=~q;
    else
      q<=q;
  end
endmodule

//testbench code
module t_flipflop_tb;
  reg clk,rst,t;
  wire q;
  t_flipflop uut(.clk(clk),.rst(rst),.t(t),.q(q));
 
  initial begin
    $monitor("Time=%0t | ClK=%b RST=%b T=%b  Q=%b", $time, clk, rst, t, q);
  end
  initial begin
    $dumpfile("t_flipflop.vcd");
    $dumpvars(1, t_flipflop_tb);
  end
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
   rst = 1;       
  t = 0;
  #10;
  rst = 0;      
  t = 1; #10;
  t = 1; #10;
  t = 0; #10;
  rst = 1; #10;  
  rst = 0; t = 1; #10;
  t = 0; #10;
    $finish;
  end
