//design code
module mealy_101 (
  input clk,
  input rst,
  input in,
  output reg out);
  
   parameter S0=2'b00;
   parameter S1=2'b01;
   parameter S2=2'b10;
  
  reg[1:0]st,nxst;
  always @(posedge clk or posedge rst) begin
    if (rst)
      st <= S0;
    else
      st <= nxst;
  end

  always @(st or in) begin
    case (st)
      S0: nxst = (in) ? S1 : S0;
      S1: nxst = (in) ? S1 : S2;
      S2: nxst = (in) ? S1 : S0;
      default: nxst = S0;
    endcase
  end

  always @(*) begin
    case (st)
      S0: out = 0;
      S1: out = 0;
      S2: out = (in) ? 1 : 0;  
      default: out = 0;
    endcase
  end

endmodule

//testbench code
module mealy_101_tb;
  reg clk;
  reg rst;
  reg in;
  wire out;

  mealy_101 uut (.clk(clk),.rst(rst),.in(in),.out(out));


  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("mealy_101.vcd");       
    $dumpvars(1, mealy_101_tb);        
    $monitor("Time=%0t|clk=%b|rst=%b|in=%b|out=%b",$time,clk,rst,in,out);

   
    rst = 1; in = 0; #10;
    rst = 0;
    in = 1; #10;
    in = 0; #10;
    in = 1; #10;   
    in = 0; #10;
    in = 1; #10;  
    in = 1; #10;
    in = 0; #10;
    in = 1; #10;
    #10 $finish;
  end

endmodule

//output
Time=0|clk=0|rst=1|in=0|out=0
Time=5|clk=1|rst=1|in=0|out=0
Time=10|clk=0|rst=0|in=1|out=0
Time=15|clk=1|rst=0|in=1|out=0
Time=20|clk=0|rst=0|in=0|out=0
Time=25|clk=1|rst=0|in=0|out=0
Time=30|clk=0|rst=0|in=1|out=1
Time=35|clk=1|rst=0|in=1|out=0
Time=40|clk=0|rst=0|in=0|out=0
Time=45|clk=1|rst=0|in=0|out=0
Time=50|clk=0|rst=0|in=1|out=1
Time=55|clk=1|rst=0|in=1|out=0
Time=60|clk=0|rst=0|in=1|out=0
Time=65|clk=1|rst=0|in=1|out=0
Time=70|clk=0|rst=0|in=0|out=0
Time=75|clk=1|rst=0|in=0|out=0
Time=80|clk=0|rst=0|in=1|out=1
Time=85|clk=1|rst=0|in=1|out=0
Time=90|clk=0|rst=0|in=1|out=0
Time=95|clk=1|rst=0|in=1|out=0
testbench.sv:33: $finish called at 100 (1s)
Time=100|clk=0|rst=0|in=1|out=0
