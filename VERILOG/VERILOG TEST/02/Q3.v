 2.Ripple carry adder using genvr 

module full_adder(
  input a,b,cin,
  output sum,cout);
  assign sum=a^b^cin;
  assign cout=(a&b)|(b&cin)|(a&cin);
endmodule

module ripple_carry_adder(
  input  [3:0]a,b,
  input cin,
  output [3:0]sum,
  output cout);
  
  wire [4:0]car;
  assign car[0]=cin;

  genvar i;
  
  generate
    for (i = 0; i < 4; i = i + 1) begin:adder
      full_adder fa (.a(a[i]),.b(b[i]),.cin(car[i]),.sum(sum[i]),.cout(car[i+1]));
    end
    
  endgenerate

  assign cout = car[4];
  
endmodule
