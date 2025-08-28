module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output reg A_gt_B,
    output reg A_lt_B,
    output reg A_eq_B);

always @(*) begin
if (A > B) begin
A_gt_B = 1;
A_lt_B = 0;
A_eq_B = 0;
end
else if (A < B) begin
A_gt_B = 0;
A_lt_B = 1;
A_eq_B = 0;
end
else begin  // A == B
A_gt_B = 0;
A_lt_B = 0;
A_eq_B = 1;
end
end

endmodule


`timescale 1ns/1ps

module tb_comparator_4bit;

    reg  [3:0] A, B;
    wire A_gt_B, A_lt_B, A_eq_B;

comparator_4bit dut (
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B) );

initial begin
$display("Time\t A\t B\t A_gt_B A_lt_B A_eq_B");

$monitor("%0t\t %b\t %b\t   %b      %b      %b", 
                  $time, A, B, A_gt_B, A_lt_B, A_eq_B);

A = 4'b0000; B = 4'b0000; #10;  // equal
A = 4'b0101; B = 4'b0011; #10;  // A > B
A = 4'b0010; B = 4'b1001; #10;  // A < B
A = 4'b1111; B = 4'b1111; #10;  // equal
A = 4'b1000; B = 4'b0111; #10;  // A > B
A = 4'b0110; B = 4'b1000; #10;  // A < B

$finish;
end

endmodule
