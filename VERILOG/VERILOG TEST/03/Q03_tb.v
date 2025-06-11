//testbench code
module full_adder_tb;
  parameter N=8;
  reg [N-1:0]a;
  reg [N-1:0]b;
  reg cin;
  wire [N-1:0]sum;
  wire cout;
  
  full_adder #(N) uut(a,b,cin,sum,cout);
  
  initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(1,full_adder_tb);
  end
  
  initial begin
    $strobe("Time=%0t|A=%b|B=%b|CIN=%b|SUM=%b|COUT=%b",$time,a,b,cin,sum,cout);
  end
  
  initial begin
    a=8'b00001001;b=8'b10101010;cin=1'b0;#10;
    a=8'b00000001;b=8'b00001000;cin=1'b0;#10;
    a=8'b01101001;b=8'b01000000;cin=1'b0;#10;
    a=8'b00001000;b=8'b00010100;cin=1'b0;#10;
  end
endmodule

//output
Time=0|A=00001001|B=10101010|CIN=0|SUM=10100011|COUT=0
