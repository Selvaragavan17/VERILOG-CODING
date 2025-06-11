3.Design configurable full adder using parameter construct (Test it for 8 bit and 16 bit full adder). Use $Strobe for Displaying result on transcript 

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
