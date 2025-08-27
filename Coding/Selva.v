`timescale 1ns/1ps

module half_adder (
input  a, b,
output reg sum, carry);

always @(*) begin
sum   = a ^ b;  // XOR operation
carry = a & b;  // AND operation
end

endmodule

`timescale 1ns/1ps

module tb_half_adder;

reg a, b;
wire sum, carry;

 
half_adder uut (
.a(a), .b(b),
.sum(sum), .carry(carry));

initial begin
$dumpfile("tb_half_adder.vcd");
$dumpvars(0, tb_half_adder);

a=0; b=0; #10;
$display("a=%b b=%b => sum=%b carry=%b (Expected: 0 0)", a, b, sum, carry);

a=0; b=1; #10;
$display("a=%b b=%b => sum=%b carry=%b (Expected: 1 0)", a, b, sum, carry);

a=1; b=0; #10;
$display("a=%b b=%b => sum=%b carry=%b (Expected: 1 0)", a, b, sum, carry);

a=1; b=1; #10;
$display("a=%b b=%b => sum=%b carry=%b (Expected: 0 1)", a, b, sum, carry);

        $finish;
    end

endmodule
