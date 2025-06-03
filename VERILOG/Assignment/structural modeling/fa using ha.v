//design code
module ha (
  input a,b,
  output reg sum,carry);
  xor(sum,a,b);
  and(carry,a,b);
endmodule

module fa(
  input a,b,cin,
  output reg s,cout);
  wire x,y,z;
  
  ha ins1(.a(a),.b(b),.sum(x),.carry(y));
  ha ins2(.a(x),.b(cin),.sum(s),.carry(z));
  
  assign cout=y|z;
endmodule

//testbench code
module fa_tb;
  reg a,b,cin;
  wire s,cout;
  
  fa uut(a,b,cin,s,cout);

    initial begin
      $monitor("Time = %0d | a=%b, b=%b, cin=%b s=%b, cout=%b", $time, a, b, cin, s, cout);
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;
        $finish;
    end
  initial begin
    $dumpfile("fa.vcd");
    $dumpvars;
  end

endmodule
