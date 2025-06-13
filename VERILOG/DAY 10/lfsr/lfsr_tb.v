module lfsr_tb;
  reg clk, rst;
  wire [3:0]lfsr_out;

  
  lfsr  uut (.clk(clk),
             .rst(rst), 
             .lfsr_out(lfsr_out)
            );

  initial begin
    clk = 0;
    forever #10 clk = ~clk; 
  end

  initial begin
    $dumpfile("lfsr.vcd");
    $dumpvars;
    
    $monitor("time=%0t|lfsr_out=%b",$time,lfsr_out);
    rst = 1; #10; 
    rst = 0; #100;
    #200;
     $finish; 
  end
endmodule

//output
time=0|lfsr_out=0001
time=10|lfsr_out=0010
time=30|lfsr_out=0100
time=50|lfsr_out=1001
time=70|lfsr_out=0011
time=90|lfsr_out=0110
time=110|lfsr_out=1101
time=130|lfsr_out=1010
time=150|lfsr_out=0101
time=170|lfsr_out=1011
time=190|lfsr_out=0111
time=210|lfsr_out=1111
time=230|lfsr_out=1110
time=250|lfsr_out=1100
time=270|lfsr_out=1000
time=290|lfsr_out=0001
testbench.sv:26: $finish called at 310 (1s)
time=310|lfsr_out=0010
