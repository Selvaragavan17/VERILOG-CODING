//design code
module dlatch(
  input en,
  input d,
  output reg q);
  
  assign q=en?d:q;
endmodule

//testbench code
module dlatch_tb;
  reg en;
  reg d;
  wire q;
  
  dlatch uut (en,d,q);
  
  initial begin
    $dumpfile("dlatch.vcd");
    $dumpvars(1,dlatch_tb);
    
    $monitor("Time=%0t|en=%b|d=%b|q=%b",$time,en,d,q);
  end
  
  initial begin
    #10 en=0;d=1;
    #10 en=1;d=1;
    #10 en=1;d=0;
    #10 en=1;d=1;
    #10 en=0;d=1;
    #10 en=1;d=0;
    $finish;
  end
endmodule

//output 
Time=0|en=x|d=x|q=x
Time=10|en=0|d=1|q=x
Time=20|en=1|d=1|q=1
Time=30|en=1|d=0|q=0
Time=40|en=1|d=1|q=1
Time=50|en=0|d=1|q=1
testbench.sv:24: $finish called at 60 (1s)
Time=60|en=1|d=0|q=0
