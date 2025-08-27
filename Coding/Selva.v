module half_subtractor (
    input a, b,
    output diff, borrow);
    assign diff   = a ^ b;
    assign borrow = (~a) & b;
endmodule

module full_subtractor (
input a, b, bin,    
output diff, bout);

wire d1, b1, b2;  

half_subtractor hs1 (
.a(a),
.b(b),
.diff(d1),
.borrow(b1));
half_subtractor hs2 (
.a(d1),
.b(bin),
.diff(diff),
.borrow(b2));

or(bout, b1, b2);

endmodule


`timescale 1ns/1ps

module tb_full_subtractor;

reg a, b, bin;
wire diff, bout;

full_subtractor dut (
.a(a), .b(b), .bin(bin),
.diff(diff), .bout(bout) );

initial begin
$monitor("Time=%0t | a=%b b=%b bin=%b -> diff=%b bout=%b",
$time, a, b, bin, diff, bout);

a=0; b=0; bin=0; #10;
a=0; b=0; bin=1; #10;
a=0; b=1; bin=0; #10;
a=0; b=1; bin=1; #10;
a=1; b=0; bin=0; #10;
a=1; b=0; bin=1; #10;
a=1; b=1; bin=0; #10;
a=1; b=1; bin=1; #10;

$finish;
end
endmodule
