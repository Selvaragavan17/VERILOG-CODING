//design code
module full_adder(
  input a, b, cin,
   output sum, cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b)|(b & cin)|(a & cin);

endmodule

module ripple_carry_adder_4bit(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout);
  
  wire c1, c2, c3;

  
  full_adder fa0(.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]),.cout(c1));
  full_adder fa1(.a(a[1]),.b(b[1]),.cin(c1),.sum(sum[1]),.cout(c2));
  full_adder fa2(.a(a[2]),.b(b[2]),.cin(c2),.sum(sum[2]),.cout(c3));
  full_adder fa3(.a(a[3]),.b(b[3]),.cin(c3),.sum(sum[3]),.cout(cout));


endmodule
//testbench
module ripple_carry_adder_4bit_tb;
  reg [3:0] a;
  reg [3:0] b;
  reg cin;
  wire [3:0] sum;
  wire cout;
  
  ripple_carry_adder_4bit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
  initial begin
    a = 4'b0001; b = 4'b0010; cin = 0; #10;
    a = 4'b0111; b = 4'b1010; cin = 0; #10;
    a = 4'b1101; b = 4'b1010; cin = 0; #10;
    a = 4'b1001; b = 4'b0110; cin = 0; #10;
  end
 
  initial begin
    $monitor("Time=%t A=%b B=%b Cin=%b Sum=%b Cout=%b",$time,a,b,cin,sum,cout);
  end
  
  initial begin
    $dumpfile("ripple_carry_adder_4bit.vcd");
    $dumpvars(1,ripple_carry_adder_4bit_tb);
  end

endmodule
