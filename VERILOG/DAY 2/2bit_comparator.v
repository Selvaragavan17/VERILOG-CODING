// design code
module comparator(
  input [1:0]a,
  input [1:0]b,
  output reg equal,
  output reg greater,
  output reg less);
  always@(*)begin
    
    if(a==b)begin
      equal=1;
      greater=0;
      less=0;
    end
    
    else if(a>b)begin
      equal=0;
      greater=1;
      less=0;
    end 
    else
      begin
      equal=0;
      greater=0;
      less=1;
      end
  end
endmodule


//testbench
module comparator_tb;
  reg [1:0]a;
  reg [1:0]b;
  wire equal;
  wire greater;
  wire less;
  comparator uut(.a(a),.b(b),.equal(equal),.greater(greater),.less(less));
  
  initial begin
    $dumpfile("comparator.vcd");
    $dumpvars(1,comparator_tb);
  end
  
  initial begin
    a=00;b=01;#5;
    a=10;b=11;#5;
    a=11;b=01;#5;
    a=01;b=10;#5;
  end
  
  always@(*)begin
    $monitor("Time=%0t A=%b B=%b Equal=%b Greater=%b Less=%b", $time,a,b,equal,greater,less);
  end 
endmodule
    
