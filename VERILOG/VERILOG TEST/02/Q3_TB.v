//testbench code
module ripple_carry_adder_tb;
  reg [3:0]a,b;
  reg cin;
  wire [3:0]sum;
  wire cout;
  
  ripple_carry_adder uut (a,b,cin,sum,cout);
  
  initial begin
    $dumpfile("ripple_carry_adder.vcd");
    $dumpvars(1,ripple_carry_adder_tb);
  end
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|CIN=%b|SUM=%b|COUT=%b",$time,a,b,cin,sum,cout);
  end
  
  initial begin
    a=4'b0010;b=4'b1010;cin=1;#10;
    a=4'b1010;b=4'b0010;cin=0;#10;
    a=4'b0011;b=4'b1100;cin=1;#10;
    a=4'b1010;b=4'b0001;cin=1;#10;
    a=4'b0010;b=4'b1000;cin=0;#10;
  end
endmodule

//output
Time=0|A=0010|B=1010|CIN=1|SUM=1101|COUT=0
Time=10|A=1010|B=0010|CIN=0|SUM=1100|COUT=0
Time=20|A=0011|B=1100|CIN=1|SUM=0000|COUT=1
Time=30|A=1010|B=0001|CIN=1|SUM=1100|COUT=0
Time=40|A=0010|B=1000|CIN=0|SUM=1010|COUT=0
