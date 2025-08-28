`timescale 1ns/1ps

module half_subtractor (
input  a,      
input  b,      
output diff,    
output borrow  );

assign diff   = a ^ b;  
assign borrow = ~a & b;   

endmodule
`timescale 1ns/1ps

module tb_half_subtractor;

    reg a, b;
    wire diff, borrow;

half_subtractor uut (.a(a),.b(b),.diff(diff),.borrow(borrow) );

initial begin
$monitor("Time=%0t | a=%b b=%b | diff=%b borrow=%b", 
                  $time, a, b, diff, borrow);
a=0;b=0; #10;
a=0;b=1; #10;
a=1;b=0; #10;
a=1;b=1; #10;

$finish;
end

endmodule
----------------------------------------------------------------------
`timescale 1ns/1ps

module mux2x1 (
    input  a,      
    input  b,   
    input  sel,    
    output y );
assign y = (sel) ? b : a;

endmodule


`timescale 1ns/1ps

module tb_mux2x1;

reg a, b, sel;
wire y;

mux2x1 uut (.a(a),.b(b),.sel(sel),.y(y));

initial begin
$monitor("Time=%0t | a=%b b=%b sel=%b | y=%b", 
                  $time, a, b, sel, y);

a=0;b=0;sel=0;#10;
a=0;b=1;sel=0;#10;
a=0;b=1;sel=1;#10;
a=1;b=0;sel=1;#10;
a=1;b=1;sel=0;#10;
a=1;b=1;sel=1;#10;

$finish;
end

endmodule
---------------------------------------------------------------------------------------
module mux2x1 (
    input a,      
    input b,       
    input sel,      
    output y );
assign y=(sel)?b:a;  
endmodule


module mux4x1 (
    input  d0, d1, d2, d3,  
    input  [1:0]sel,        
    output y                
);

wire y0, y1;
mux2x1 m1 (.a(d0),.b(d1),.sel(sel[0]),.y(y0));
mux2x1 m2 (.a(d2),.b(d3),.sel(sel[0]),.y(y1));
    
mux2x1 m3 (.a(y0),.b(y1),.sel(sel[1]),.y(y));

endmodule


`timescale 1ns/1ps

module tb_mux4x1;

reg d0, d1, d2, d3;
reg [1:0] sel;
wire y1, y2;

mux4x1 dut1 (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(sel), .y(y1));

mux4x1_gate dut2 (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(sel), .y(y2));

initial begin
$monitor("Time=%0t | d0=%b d1=%b d2=%b d3=%b sel=%b | y1=%b y2=%b",
                  $time, d0, d1, d2, d3, sel, y1, y2);

d0=0; d1=1; d2=0; d3=1;

sel=2'b00;#10;
sel=2'b01;#10;
sel=2'b10;#10;
sel=2'b11;#10;

$finish;
  end

endmodule
----------------------------------------------------------------
`timescale 1ns/1ps

module encoder8x3(
    input  [7:0] din,   // 8 input lines
    output reg [2:0] dout // 3-bit output
);

always @(*) begin
case (din)
8'b00000001: dout = 3'b000;
8'b00000010: dout = 3'b001;
8'b00000100: dout = 3'b010;
8'b00001000: dout = 3'b011;
8'b00010000: dout = 3'b100;
8'b00100000: dout = 3'b101;
8'b01000000: dout = 3'b110;
8'b10000000: dout = 3'b111;
default: dout = 3'bxxx; 
endcase
end

endmodule

`timescale 1ns/1ps

module tb_encoder8x3;
    reg [7:0] din;
    wire [2:0] dout;

encoder8x3 uut (
.din(din),
.dout(dout));

initial begin
$monitor("Time=%0t | din=%b | dout=%b", $time, din, dout);

din = 8'b00000001; #10;
din = 8'b00000010; #10;
din = 8'b00000100; #10;
din = 8'b00001000; #10;
din = 8'b00010000; #10;
din = 8'b00100000; #10;
din = 8'b01000000; #10;
din = 8'b10000000; #10;


din = 8'b00001100; #10;

$finish;
end
endmodule
-------------------------------------------------------------------------
`timescale 1ns/1ps

module encoder_8x3 (
    input  [7:0] din,    
    input  en,      
    output reg [2:0] dout );

always @(*) begin
if (en) begin
case (din)
8'b0000_0001: dout = 3'b000;
8'b0000_0010: dout = 3'b001;
8'b0000_0100: dout = 3'b010;
8'b0000_1000: dout = 3'b011;
8'b0001_0000: dout = 3'b100;
8'b0010_0000: dout = 3'b101;
8'b0100_0000: dout = 3'b110;
8'b1000_0000: dout = 3'b111;
default: dout = 3'bxxx; 
endcase
end else begin
dout = 3'b000; 
end
end

endmodule

`timescale 1ns/1ps

module tb_encoder_8x3;

    reg [7:0] din;
    reg en;
    wire [2:0] dout;


encoder_8x3 uut (
.din(din),.en(en),.dout(dout));

initial begin
$dumpfile("encoder_8x3.vcd");
$dumpvars(0, tb_encoder_8x3);


en = 0; din = 8'b0000_1000; #10;
        
en = 1;
din = 8'b0000_0001; #10;
din = 8'b0000_0010; #10;
din = 8'b0000_0100; #10;
din = 8'b0000_1000; #10;
din = 8'b0001_0000; #10;
din = 8'b0010_0000; #10;
din = 8'b0100_0000; #10;
din = 8'b1000_0000; #10;

din = 8'b1010_0000; #10;

$display("Simulation finished");
$finish;
end
endmodule
-------------------------------------------------------------------------
`timescale 1ns/1ps

module encoder8x3_en (
    input [7:0] d,     
    input en_n,         
    output reg [2:0] y);

always @(*) begin
if (!en_n) begin  
case (d)
8'b00000001: y = 3'b000;
8'b00000010: y = 3'b001;
8'b00000100: y = 3'b010;
8'b00001000: y = 3'b011;
8'b00010000: y = 3'b100;
8'b00100000: y = 3'b101;
8'b01000000: y = 3'b110;
8'b10000000: y = 3'b111;
default:y = 3'bxxx; 
endcase
end 
else begin
y = 3'bzzz; 
end
end

endmodule

`timescale 1ns/1ps

module tb_encoder8x3_en;

reg [7:0] d;
reg en_n;
wire [2:0] y;


encoder8x3_en uut (.d(d),.en_n(en_n),.y(y));

initial begin
$monitor("Time=%0t en_n=%b d=%b -> y=%b", $time, en_n, d, y);

en_n = 1; d = 8'b00010000; #10;

en_n = 0; d = 8'b00000001; #10;
d=8'b00000010; #10;
d=8'b00000100; #10;
d=8'b00001000; #10;
d=8'b00010000; #10;
d=8'b00100000; #10;
d=8'b01000000; #10;
d=8'b10000000; #10;

d = 8'b11000000; #10;

$finish;
end

endmodule
------------------------------------------------------------------------

module priority_encoder_8x3 (
    input  [7:0]in,   
    output reg [2:0] out, 
    output reg valid      
);

always @(*) begin
valid = 1'b1;  
casex (in)
8'b1xxxxxxx: out = 3'b111; // I7
8'b01xxxxxx: out = 3'b110; // I6
8'b001xxxxx: out = 3'b101; // I5
8'b0001xxxx: out = 3'b100; // I4
8'b00001xxx: out = 3'b011; // I3
8'b000001xx: out = 3'b010; // I2
8'b0000001x: out = 3'b001; // I1
8'b00000001: out = 3'b000; // I0
default: begin
out   = 3'b000;  
valid = 1'b0;    
end
endcase
end
endmodule

`timescale 1ns/1ps

module tb_priority_encoder_8x3();

    reg  [7:0] in;
    wire [2:0] out;
    wire valid;


priority_encoder_8x3 uut (.in(in),.out(out),.valid(valid));

initial begin
$monitor("Time=%0t | in=%b | out=%b | valid=%b", $time, in, out, valid);

in = 8'b00000000; #10;  
in = 8'b00000001; #10;  
in = 8'b00000100; #10;  
in = 8'b00011000; #10;  
in = 8'b10000001; #10;  
in = 8'b01000000; #10; 
in = 8'b11111111; #10;  

$finish;
end
endmodule
-----------------------------------------------------------
`timescale 1ns/1ps

module low_priority_encoder8x3(
    input  [7:0] din,  
    output reg [2:0] dout);

always @(*) begin
casex(din)
8'bxxxxxxx1:dout=3'b000; 
8'bxxxxxx10:dout=3'b001;
8'bxxxxx100:dout=3'b010; 
8'bxxxx1000:dout=3'b011; 
8'bxxx10000:dout=3'b100; 
8'bxx100000:dout=3'b101;
8'bx1000000:dout=3'b110; 
8'b10000000:dout=3'b111;
default: dout=3'bxxx;
endcase
end

endmodule

`timescale 1ns/1ps

module tb_low_priority_encoder8x3();

reg  [7:0] din;
wire [2:0] dout;

low_priority_encoder8x3 uut (.din(din), .dout(dout));

initial begin
    $dumpfile("low_priority_encoder8x3.vcd");
    $dumpvars(0, tb_low_priority_encoder8x3);

din = 8'b00000001; #10; // I0 active
din = 8'b00000010; #10; // I1 active
din = 8'b00000100; #10; // I2 active
din = 8'b00001000; #10; // I3 active
din = 8'b00010000; #10; // I4 active
din = 8'b00100000; #10; // I5 active
din = 8'b01000000; #10; // I6 active
din = 8'b10000000; #10; // I7 active

din = 8'b10100000; #10; 
din = 8'b11111111; #10; 

$finish;
end

initial begin
    $monitor("Time=%0t | din=%b | dout=%b",$time,din,dout);
end

endmodule
-----------------------------------------------
`timescale 1ns/1ps

module mag_comp_4bit (
    input  [3:0] A,  
    input  [3:0] B,   
    output A_gt_B,
    output A_lt_B, 
    output A_eq_B  
);

assign A_gt_B = (A > B) ? 1'b1 : 1'b0;
assign A_lt_B = (A < B) ? 1'b1 : 1'b0;
assign A_eq_B = (A == B) ? 1'b1 : 1'b0;

endmodule

`timescale 1ns/1ps

module tb_mag_comp_4bit;

    reg  [3:0] A, B;
    wire A_gt_B, A_lt_B, A_eq_B;

mag_comp_4bit dut (.A(A),.B(B),.A_gt_B(A_gt_B),.A_lt_B(A_lt_B),.A_eq_B(A_eq_B));

initial begin
$monitor("Time=%0t | A=%b B=%b | A_gt_B=%b A_lt_B=%b A_eq_B=%b", 
                  $time, A, B, A_gt_B, A_lt_B, A_eq_B);

A=4'b0101;B=4'b0101; #10;  
A=4'b1001;B=4'b0110; #10;  
A=4'b0011;B=4'b1110; #10; 
A=4'b0000;B=4'b0001; #10;  
A=4'b1111;B=4'b1111; #10;  
A=4'b1010;B=4'b0101; #10;  

$finish;
end
endmodule
----------------------------------------------------------------
`timescale 1ns/1ps

module mag_comp_always (
    input  [3:0] A,
    input  [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_smaller
);

always @(*) begin
if (A > B) begin
A_greater = 1;
A_equal   = 0;
A_smaller = 0;
end 
else if (A == B) begin
A_greater = 0;
A_equal   = 1;
A_smaller = 0;
end 
else begin
A_greater = 0;
A_equal   = 0;
A_smaller = 1;
end
end

endmodule

`timescale 1ns/1ps

module tb_mag_comp_always;

reg  [3:0] A, B;
wire A_greater, A_equal, A_smaller;

mag_comp_always uut (.A(A),.B(B),.A_greater(A_greater),.A_equal(A_equal),.A_smaller(A_smaller));

initial begin
    $monitor("Time=%0t | A=%b (%0d) B=%b (%0d) | A>B=%b A==B=%b A<B=%b", 
              $time, A, A, B, B, A_greater, A_equal, A_smaller);

A=4'b0000;B=4'b0000; #10;  
A=4'b0101;B=4'b0011; #10; 
A=4'b0010;B=4'b1000; #10;  
A=4'b1111;B=4'b1111; #10;  
A=4'b1001;B=4'b0111; #10;  
A=4'b0011;B=4'b0100; #10;  

$finish;
end

endmodule
----------------------------
