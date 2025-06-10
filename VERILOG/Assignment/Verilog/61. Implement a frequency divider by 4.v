//design code
module freq_div4(
  input clk,
  input rst,
  output reg out);
  
  reg count;
  always@(posedge clk)begin
    if(rst)begin
      count<=0;
      out<=0;
    end
    else begin
      count<=count+1;
      if(count==1)
        out<=~out;
      
    end
//     $display("display count=%0d",count);
  end
endmodule

//testbench code
module freq_div4_tb;
  reg clk;
  reg rst;
  wire out;

  freq_div4 uut (.clk(clk),.rst(rst),.out(out));

  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  initial begin
    $dumpfile("freq_div4.vcd");
    $dumpvars(0, freq_div4_tb);
    $monitor("Time=%0t|clk=%b|rst=%b|out=%b",$time,clk,rst,out);

    rst = 1; #10;
    rst = 0;

    #100; 
    $finish;
  end

endmodule

//output
Time=0|clk=0|rst=1|out=x
Time=5|clk=1|rst=1|out=0
Time=10|clk=0|rst=0|out=0
Time=15|clk=1|rst=0|out=0
Time=20|clk=0|rst=0|out=0
Time=25|clk=1|rst=0|out=1
Time=30|clk=0|rst=0|out=1
Time=35|clk=1|rst=0|out=1
Time=40|clk=0|rst=0|out=1
Time=45|clk=1|rst=0|out=0
Time=50|clk=0|rst=0|out=0
Time=55|clk=1|rst=0|out=0
Time=60|clk=0|rst=0|out=0
Time=65|clk=1|rst=0|out=1
Time=70|clk=0|rst=0|out=1
Time=75|clk=1|rst=0|out=1
Time=80|clk=0|rst=0|out=1
Time=85|clk=1|rst=0|out=0
Time=90|clk=0|rst=0|out=0
Time=95|clk=1|rst=0|out=0
Time=100|clk=0|rst=0|out=0
Time=105|clk=1|rst=0|out=1
testbench.sv:24: $finish called at 110 (1s)
Time=110|clk=0|rst=0|out=1
