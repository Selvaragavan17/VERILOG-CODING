//design code
module full_adder #(parameter N=8)(
  input [N-1:0]a,
  input [N-1:0]b,
  input cin,
  output [N-1:0]sum,
  output cout);
  
  assign sum=a^b^cin;
  assign cout=(a&b)|(b&cin)|(cin&a);
endmodule 
