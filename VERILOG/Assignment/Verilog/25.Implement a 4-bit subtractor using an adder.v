//design code
module sub_1adder(
  input [3:0]a,b,
  output [3:0]diff,
  output bout);
  
  wire b_comp,cout;
  
  assign b_comp=~b;
  assign {cout,diff}=a+b_comp+1'b1;
  
  assign bout=cout;
  
endmodule

//testbencch code
module sub_1adder_tb;
  reg [3:0]a,b;
  wire [3:0]diff;
  wire bout;
  
  sub_1adder uut(a,b,diff,bout);
  
  initial begin
    $dumpfile("sub_1adder.vcd");
    $dumpvars(1,sub_1adder_tb);
    $monitor("A=%b|B=%b|DIFF=%b|BOUT=%b",a,b,diff,bout);
    
    a=4'b0000;b=4'b0010;#10;
    a=4'b1010;b=4'b1000;#10;
    a=4'b0110;b=4'b0011;#10;
    a=4'b1011;b=4'b1100;#10;
    a=4'b1111;b=4'b1111;#10;
    
  end
endmodule
