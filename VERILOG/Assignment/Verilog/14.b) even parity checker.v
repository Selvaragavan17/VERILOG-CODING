//design code
module even_p_c(
input a,b,c,p,
output out);
assign out=~(a^b^c^p);
endmodule

//testbench code
module even_p_c_tb;
reg a,b,c,p;
wire out;

even_p_c uut(a,b,c,p,out);

initial begin
$dumpfile("even_p_c.vcd");
$dumpvars(1,even_p_c_tb);
end

initial begin
$monitor("Time=%0t|A=%b|B=%b|C=%b|P=%b|OUT=%b",$time,a,b,c,p,out);
end

initial begin
a=0;b=1;c=1;p=0;#10;
a=1;b=1;c=0;p=1;#10;
a=0;b=1;c=1;p=0;#10;
a=1;b=1;c=0;p=1;#10;
a=1;b=1;c=1;p=1;#10;
end
endmodule
