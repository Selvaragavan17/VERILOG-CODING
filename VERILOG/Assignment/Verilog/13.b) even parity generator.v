//design code
module even_p_g(
input a,b,c,
output p);
assign p=(a^b^c);
endmodule

//testbench code
module  even_p_g_tb;
reg a,b,c;
wire p;
even_p_g uut(a,b,c,p);
initial begin
$dumpfile("even_p_g.vcd");
$dumpvars(1,even_p_g_tb);
end

initial begin
$monitor("Time=%0t|A=%b|B=%b|C=%b|P=%b",$time,a,b,c,p);
end

initial begin
a=0;b=1;c=1;#10;
a=1;b=1;c=1;#10;
a=0;b=0;c=1;#10;
a=1;b=1;c=1;#10;
a=1;b=0;c=0;#10;
a=1;b=0;c=1;#10;
end
endmodule
