//design code
module mux2to1(
  input x1,x0,
  input s,
  output out);
  assign out=s?x1:x0;
endmodule

//testbench code
module  mux2to1_tb;
  reg x1,x0;
  reg s;
  wire out;
  
  mux2to1 uut(x1,x0,s,out);
  
  initial begin
    $monitor("X1=%b|X0=%b|SEL=%b|OUT=%b",x1,x0,s,out);
  end
  
  initial begin
    $dumpfile("mux2to1.vcd");
    $dumpvars(1,mux2to1_tb);
  end
  initial begin
    x1=0;x0=1;s=1;#10;
    x1=1;x0=1;s=0;#10;
    x1=1;x0=1;s=0;#10;
    x1=0;x0=0;s=1;#10;
    x1=1;x0=0;s=1;#10;
  end
endmodule
