//design codee
module half_adder(
  input a, b,
  output sum, carry);
  assign sum = a ^ b;
  assign carry = a & b;
endmodule

module full_adder_using_ha(
  input a, b, cin,
  output sum, cout);
  wire sum1, carry1, carry2;
  
  
  half_adder ha1 (.a(a),.b(b),.sum(sum1),.carry(carry1));
  half_adder ha2 (.a(sum1),.b(cin),.sum(sum),.carry(carry2));

  assign cout = carry1|carry2;

endmodule

//testbench code
module full_adder_using_ha_tb;
  reg a, b, cin;
  wire sum, cout;

  full_adder_using_ha uut (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));

  initial begin
    
    $dumpfile("full_adder_using_ha.vcd");
    $dumpvars(0, full_adder_using_ha_tb);
    
    $monitor("A=%b|B=%b|CIN=%b|SUM=%b|COUT=%b",a,b,cin,sum,cout);

    a=0;b=0;cin=0;#10;
    a=0;b=0;cin=1;#10;
    a=0;b=1;cin=0;#10;
    a=0;b=1;cin=1;#10;
    a=1;b=0;cin=0;#10;
    a=1;b=0;cin=1;#10;
    a=1;b=1;cin=0;#10;
    a=1;b=1;cin=1;#10;

    $finish;
  end
endmodule
