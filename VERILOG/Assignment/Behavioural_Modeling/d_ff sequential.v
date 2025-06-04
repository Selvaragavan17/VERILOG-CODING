//design code
module dff(
  input clk,d,
  output reg q);
  
  always@(posedge clk)begin
    q<=d;
  end
endmodule

module seq(
  input x1,x2,x3,clk,
  output reg g,f);
  wire a,b;
  
  dff a1(.clk(clk),.d(a),.q(g));
  dff a2(.clk(clk),.d(b),.q(f));
  
  assign a=x3|f;
  assign b=x1&x2;
  
endmodule

//testbench code
module seq_tb;
  reg clk;
  reg x1, x2, x3;
  wire g, f;

  seq uut (.x1(x1),.x2(x2),.x3(x3),.clk(clk),.g(g),.f(f));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    x1=0; x2=0; x3=0; #10;  
    x1=1; x2=1; x3=0; #10;
    x1=0; x2=1; x3=1; #10;
    x1=1; x2=1; x3=0; #10;
    x1=1; x2=0; x3=1; #10;

    $finish;
  end

  initial begin
    $monitor("Time=%0t | x1=%b x2=%b x3=%b | g=%b|f=%b", $time, x1, x2, x3, g, f);
  end

  initial begin
    $dumpfile("seq.vcd");
    $dumpvars(1, seq_tb);
  end
endmodule
