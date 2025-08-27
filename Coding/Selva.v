module half_adder (
    input  a, b,
    output sum, carry);
assign sum   = a ^ b; // XOR
assign carry = a & b; // AND
endmodule
module full_adder (
input  a, b, cin,
output sum, carry);

wire s1, c1, c2;

half_adder HA1 (
.a(a),
.b(b),
.sum(s1),
.carry(c1));

half_adder HA2 (
.a(s1),
.b(cin),
.sum(sum),
.carry(c2)
);

or (carry, c1, c2);

endmodule


`timescale 1ns/1ps
module tb_full_adder;

    reg a, b, cin;
    wire sum, carry;

    full_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .carry(carry));

    initial begin
        $monitor("time=%0t | a=%b b=%b cin=%b -> sum=%b carry=%b",
                  $time, a, b, cin, sum, carry);

        a=0; b=0; cin=0; #10;
        a=0; b=0; cin=1; #10;
        a=0; b=1; cin=0; #10;
        a=0; b=1; cin=1; #10;
        a=1; b=0; cin=0; #10;
        a=1; b=0; cin=1; #10;
        a=1; b=1; cin=0; #10;
        a=1; b=1; cin=1; #10;

        $finish;
    end
endmodule
