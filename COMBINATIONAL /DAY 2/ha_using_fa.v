//design code
module half_adder (
  input a,
  input b,
  output sum,
  output carry);
  
  assign sum = a ^ b;
  assign carry = a & b;
endmodule


module full_adder (
  input a, b, Cin,
  output sum, carry);
  
  wire sum1, c1, c2;

  half_adder ha1(.a(a), .b(b), .sum(sum1), .carry(c1));
  half_adder ha2(.a(sum1), .b(Cin), .sum(sum), .carry(c2));

  assign carry = c1 | c2;

endmodule

//testbench code
module full_adder_tb;
  reg a, b, Cin;
  wire sum, carry;

  full_adder uut(.a(a), .b(b), .Cin(Cin), .sum(sum), .carry(carry));
  initial begin
    a = 0; b = 0; Cin = 0; #10;
    a = 0; b = 0; Cin = 1; #10;
    a = 0; b = 1; Cin = 0; #10;
    a = 0; b = 1; Cin = 1; #10;
    a = 1; b = 0; Cin = 0; #10;
    a = 1; b = 0; Cin = 1; #10;
    a = 1; b = 1; Cin = 0; #10;
    a = 1; b = 1; Cin = 1; #10;
    $finish;
  end

  initial begin
    $monitor("Time=%0t A=%b B=%b Cin=%b Sum=%b Carry=%b", $time, a, b, Cin, sum, carry);
  end
  
endmodule
