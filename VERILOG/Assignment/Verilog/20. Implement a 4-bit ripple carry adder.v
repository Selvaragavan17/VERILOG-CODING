//design code
module fa(
  input a,b,cin,
  output sum,cout);
  
  assign sum=a^b^cin;
  assign cout=(a&b)|(b&cin)|(cin&a);
endmodule

module rca(
  input [3:0]a,b,
  input cin,
  output [3:0]sum,
  output cout);
  wire c1,c2,c3;
  
  fa f1(.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]),.cout(c1));
  fa f2(.a(a[1]),.b(b[1]),.cin(c1),.sum(sum[1]),.cout(c2));
  fa f3(.a(a[2]),.b(b[2]),.cin(c2),.sum(sum[2]),.cout(c3));
  fa f4(.a(a[3]),.b(b[3]),.cin(c3),.sum(sum[3]),.cout(cout));
endmodule

//testbench code
module rca_tb;
  reg [3:0]a,b;
  reg cin;
  wire [3:0]sum;
  wire cout;
  
  rca uut(a,b,cin,sum,cout);
  
  initial begin
    $monitor("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);
    $dumpfile("rca.vcd");
    $dumpvars(1,rca_tb);

    a=4'b0001;b=4'b0010;cin=0;#10;
    a=4'b1111;b=4'b0001;cin=0;#10;
    a=4'b1010;b=4'b0101;cin=1;#10;
    a=4'b0000;b=4'b0000;cin=1;#10;
    $finish;
  end
  
endmodule
