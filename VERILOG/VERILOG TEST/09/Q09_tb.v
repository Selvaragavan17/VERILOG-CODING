//teestbench code
module fsm111_tb;
   reg clk;
   reg reset;
   reg in;
   wire out;
   
   fsm111 uut(.clk(clk),.reset(reset),.in(in),.out(out));
   
   initial begin
        clk = 0;
        forever #5 clk = ~clk;
   end
   
   initial begin
        reset = 1;#10;
        reset = 0; in = 0 ;#10;
        in = 0 ;#10;
        in = 1 ;#10;
        in = 1 ;#10;
        in = 1 ;#10;
        in = 0 ;#10;
        in = 0 ;#10;
        in = 1 ;#10;
        in = 1 ;#10;
        in = 1 ;#10;
     $finish;

   end  
  
  initial begin
    $dumpfile("fsm111.vcd");
    $dumpvars(1,fsm111_tb);
  end
  
  initial begin 
    $monitor("|Time=%0t|CLOCK=%b|RESET=%b|INPUT=%b|OUTPUT =%b|",$time,clk,reset,in,out);
  end
    
endmodule

//output
|Time=0|CLOCK=0|RESET=1|INPUT=x|OUTPUT =0|
|Time=5000|CLOCK=1|RESET=1|INPUT=x|OUTPUT =0|
|Time=10000|CLOCK=0|RESET=0|INPUT=0|OUTPUT =0|
|Time=15000|CLOCK=1|RESET=0|INPUT=0|OUTPUT =0|
|Time=20000|CLOCK=0|RESET=0|INPUT=0|OUTPUT =0|
|Time=25000|CLOCK=1|RESET=0|INPUT=0|OUTPUT =0|
|Time=30000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =0|
|Time=35000|CLOCK=1|RESET=0|INPUT=1|OUTPUT =0|
|Time=40000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =0|
|Time=45000|CLOCK=1|RESET=0|INPUT=1|OUTPUT =0|
|Time=50000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =0|
|Time=55000|CLOCK=1|RESET=0|INPUT=1|OUTPUT =1|
|Time=60000|CLOCK=0|RESET=0|INPUT=0|OUTPUT =1|
|Time=65000|CLOCK=1|RESET=0|INPUT=0|OUTPUT =0|
|Time=70000|CLOCK=0|RESET=0|INPUT=0|OUTPUT =0|
|Time=75000|CLOCK=1|RESET=0|INPUT=0|OUTPUT =0|
|Time=80000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =0|
|Time=85000|CLOCK=1|RESET=0|INPUT=1|OUTPUT =0|
|Time=90000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =0|
|Time=95000|CLOCK=1|RESET=0|INPUT=1|OUTPUT =0|
|Time=100000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =0|
|Time=105000|CLOCK=1|RESET=0|INPUT=1|OUTPUT =1|
testbench.sv:30: $finish called at 110000 (1ps)
|Time=110000|CLOCK=0|RESET=0|INPUT=1|OUTPUT =1|
