//design code
module d_flipflop(
   input clk ,d,
  output reg q);
  always@(posedge clk)begin
    if(clk)
      q<=d;
  end
endmodule

//testbench code
module d_flipflop_tb;
  reg clk,d;
  wire q;
  d_flipflop uut(clk,d,q);
  initial begin
    $dumpfile("d_flipflop.vcd");
    $dumpvars(1,d_flipflop_tb);
  end
  initial begin
    clk=0;
    forever #5 clk=~clk;  
  end
  initial begin
    clk=1;
    d= 0;#5;
    d= 1;#5;
    d= 0;#5;clk=0;#5;
    d= 1;#5;
    d= 1;#5;
    d= 0;#5;
    d= 1;#5;
    d= 0;#5;
    $finish;
  end
  initial begin
    $monitor("TIme=%0t clk=%b d=%b q=%b",$time,clk,d,q);
  end
