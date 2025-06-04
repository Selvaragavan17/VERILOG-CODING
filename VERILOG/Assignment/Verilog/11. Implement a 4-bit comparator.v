//design codee
module comp_5b(
input [3:0]a,b,
output reg equal,
output reg greater,
output reg lesser);

always@(*)begin
if(a==b)begin
equal=1;
greater=0;
lesser=0;
end
else if(a<b)begin
equal=0;
greater=1;
lesser=0;
end
else if(a<b)begin
equal=0;
greater=0;
lesser=1;
end
end
endmodule

//testbench code
module comp_4b_tb;
  reg [3:0]a,b;
  wire equal,greater,lesser;
  comp_4b uut(.a(a),.b(b),.equal(equal),.greater(greater),.lesser(lesser));
  initial begin
	  a=4'b0010;b=4'b1010;#10;
	  a=4'b1010;b=4'b1010;#10;
	  a=4'b0011;b=4'b1110;#10;
	  a=4'b1110;b=4'b1011;#10;

    $finish;
  end
  initial begin
    $monitor("$time=%0t,a=%b,b=%b,greater=%b,lesser=%b,equal=%b",$time,a,b,greater,lesser,equal);
  end
initial begin
$dumpfile("comp_4b.vcd");
$dumpvars(1,comp_4b_tb);
end
endmodule
