//design code
module mac(
  input clk,rst,start,
  input [3:0]A,B,
  output reg[7:0]ACC,
  output reg done);
  
  always@(posedge clk)begin
    if(rst)begin
      done<=0;
      ACC<=0;
    end
    else if(start)begin
      ACC<=ACC+(A*B);
      done<=1;
    end
    else
      done<=0;
  end
endmodule

//testbench code
module mac_tb;
  reg clk,rst,start;
  reg [3:0]A,B;
  wire [7:0]ACC;
  wire done;
  
  mac uut(clk,rst,start,A,B,ACC,done);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("mac.vcd");
    $dumpvars(1,mac_tb);
  end
  
  initial begin
    $monitor("Time=%0t|clk=%b|start=%b|rst=%b|a=%d|b=%d|ACC=%d|Done=%b",$time,clk,start,rst,A,B,ACC,done);
  end
  
  initial begin
    rst=1; start=0;A=0;B=0;
    #10 rst = 0;

    // First  3 * 4 = 12
    A=4'd3;B=4'd4; start=1; #10;
    start = 0; #10;

    // Second: 2 * 5 = 10 → ACC = 22
    A=4'd2;B=4'd5;start=1; #10;
    start = 0; #10;

    // Third: 1 * 6 = 6 → ACC = 28
    A=4'd1;B=4'd6;start=1; #10;
    start = 0; #10;
    
    rst=1; #10;
    rst=0; #10;

    $finish;
  end
endmodule

//output
Time=0|clk=0|start=0|rst=1|a= 0|b= 0|ACC=  x|Done=x
Time=5|clk=1|start=0|rst=1|a= 0|b= 0|ACC=  0|Done=0
Time=10|clk=0|start=1|rst=0|a= 3|b= 4|ACC=  0|Done=0
Time=15|clk=1|start=1|rst=0|a= 3|b= 4|ACC= 12|Done=1
Time=20|clk=0|start=0|rst=0|a= 3|b= 4|ACC= 12|Done=1
Time=25|clk=1|start=0|rst=0|a= 3|b= 4|ACC= 12|Done=0
Time=30|clk=0|start=1|rst=0|a= 2|b= 5|ACC= 12|Done=0
Time=35|clk=1|start=1|rst=0|a= 2|b= 5|ACC= 22|Done=1
Time=40|clk=0|start=0|rst=0|a= 2|b= 5|ACC= 22|Done=1
Time=45|clk=1|start=0|rst=0|a= 2|b= 5|ACC= 22|Done=0
Time=50|clk=0|start=1|rst=0|a= 1|b= 6|ACC= 22|Done=0
Time=55|clk=1|start=1|rst=0|a= 1|b= 6|ACC= 28|Done=1
Time=60|clk=0|start=0|rst=0|a= 1|b= 6|ACC= 28|Done=1
Time=65|clk=1|start=0|rst=0|a= 1|b= 6|ACC= 28|Done=0
Time=70|clk=0|start=0|rst=1|a= 1|b= 6|ACC= 28|Done=0
Time=75|clk=1|start=0|rst=1|a= 1|b= 6|ACC=  0|Done=0
Time=80|clk=0|start=0|rst=0|a= 1|b= 6|ACC=  0|Done=0
Time=85|clk=1|start=0|rst=0|a= 1|b= 6|ACC=  0|Done=0
testbench.sv:44: $finish called at 90 (1s)
Time=90|clk=0|start=0|rst=0|a= 1|b= 6|ACC=  0|Done=0
