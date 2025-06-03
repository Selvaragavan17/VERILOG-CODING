//design code
module siso(
  input clk,rst,
  input si,
  output reg so);
  always@(posedge clk)begin
    if(rst==0)
      so<=si;
    else
      so<=0;
  end
endmodule

//testbench code
module siso_tb;
  reg clk,rst,si;
  wire so;
  siso uut(.clk(clk),.rst(rst),.si(si),.so(so));
  initial begin
    $dumpfile("siso.vcd");
    $dumpvars(1,siso_tb);
  end
  initial begin
    $monitor("Tme=%0t Clk=%b Rst=%b Si=%b So=%b",$time,clk,rst,si,so);
  end
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  initial begin
    rst=0;#10;
    si=1;#10;
    si=0;#10;
    rst=1;si=1;#10;
    si=1;#10;
    si=0;#10;
    $finish;
  end
endmodule
