`timescale 1ns/1ps

module alu1 (
    input  [1:0] A, B,
    input  [1:0] sel,
    output reg [1:0] y);

always @(*) begin
case (sel)
2'b00:y=A + B;   
2'b01:y=A - B;   
2'b10:y=A & B;   
2'b11:y=A | B;   
default:y=2'b00;
endcase
end

endmodule

`timescale 1ns/1ps

module tb_alu1;

reg [1:0] A, B;
reg [1:0] sel;
wire [1:0] y;

alu1 uut (.A(A), .B(B), .sel(sel), .y(y));

initial begin
  $dumpfile("alu1.vcd");
  $dumpvars(0, tb_alu1);
$monitor("time=%0t | A=%b | B=%b | sel=%b | y=%b", $time, A, B, sel, y);

A = 2'b01; B = 2'b10;

sel=2'b00; #10; // Add
sel=2'b01; #10; // Subtract
sel=2'b10; #10; // AND
sel=2'b11; #10; // OR

A = 2'b11; B = 2'b01;

sel=2'b00; #10; 
sel=2'b01; #10; 
sel=2'b10; #10; 
sel=2'b11; #10; 

$finish;
end

endmodule
-------------------------------------------------------------
`timescale 1ns/1ps

module alu2 (
    input  [1:0] A, B,
    input  [2:0] sel,
    output reg [1:0] y);

always @(*) begin
case (sel)

3'b000:y=A + B;       // Add
3'b001:y=A - B;       // Subtract
3'b010:y=A * B;       // Multiply
3'b011:y=(B != 0) ? (A / B) : 2'b00;  // Division (avoid /0)

3'b100:y=A & B;       // AND
3'b101:y=~A;          // NOT (on A)
3'b110:y=A | B;       // OR
3'b111:y=A ^ B;       // XOR

default: y = 2'b00;
endcase
end

endmodule
`timescale 1ns/1ps

module tb_alu2;

reg [1:0] A, B;
reg [2:0] sel;
wire [1:0] y;


alu2 uut (.A(A),.B(B),.sel(sel),.y(y));

initial begin
  $dumpfile("alu2.vcd");
  $dumpvars(0, tb_alu2);
$monitor("time=%0t | A=%b | B=%b | sel=%b | y=%b", $time, A, B, sel, y);

A=2'b01; B=2'b10;
sel=3'b000; #10; // Add
sel=3'b001; #10; // Sub
sel=3'b010; #10; // Mul
sel=3'b011; #10; // Div
sel=3'b100; #10; // AND
sel=3'b101; #10; // NOT A
sel=3'b110; #10; // OR
sel=3'b111; #10; // XOR

A=2'b11; B=2'b01;
sel=3'b000; #10;
sel=3'b001; #10;
sel=3'b010; #10;
sel=3'b011; #10;
sel=3'b100; #10;
sel=3'b101; #10;
sel=3'b110; #10;
sel=3'b111; #10;

$finish;
end

endmodule
------------------------------------------------------------
`timescale 1ns/1ps

module alu3 (
    input  [2:0] A, B,
    input  [2:0] sel,
    output reg [2:0] y);

always @(*) begin
case (sel)
3'b000:y=A + B;                
3'b001:y=A - B;               
3'b010:y=A * B;                
3'b011:y=(B != 0) ? (A / B) : 3'b000;

3'b100:y=A & B;           
3'b101:y=~A;               
3'b110:y=A | B;        
3'b111:y=A ^ B;           

default: y = 3'b000;
endcase
end

endmodule

`timescale 1ns/1ps

module tb_alu3;

reg [2:0] A, B;
reg [2:0] sel;
wire [2:0] y;


alu3 uut (
    .A(A), .B(B), .sel(sel), .y(y));

initial begin
  $dumpfile("alu3.vcd");
  $dumpvars(0, tb_alu3);
$monitor("time=%0t | A=%b | B=%b | sel=%b | y=%b", $time, A, B, sel, y);

A=3'b011; B=3'b010;   // A=3, B=2
sel=3'b000; #10; // Add
sel=3'b001; #10; // Sub
sel=3'b010; #10; // Mul
sel=3'b011; #10; // Div
sel=3'b100; #10; // AND
sel=3'b101; #10; // NOT A
sel=3'b110; #10; // OR
sel=3'b111; #10; // XOR


A=3'b111;B=3'b001;   // A=7, B=1
sel=3'b000; #10;
sel=3'b001; #10;
sel=3'b010; #10;
sel=3'b011; #10;
sel=3'b100; #10;
sel=3'b101; #10;
sel=3'b110; #10;
sel=3'b111; #10;

$finish;
end

endmodule
--------------------------------------------------------------------------
`timescale 1ns/1ps

module alu4 (
    input  [2:0] A, B,
    input  [2:0] sel,
    output reg [2:0] y);

always @(*) begin
case (sel)
3'b000:y=A + B;       
3'b001:y=A - B;          
3'b010:y=A * B;            


3'b100:y=A & B;        
3'b101:y=~A;                
3'b110:y=A | B;          
3'b111:y=A ^ B;             

default: y = (B != 0) ? (A / B) : 3'b000;
endcase
end

endmodule
`timescale 1ns/1ps

module tb_alu4;

reg [2:0] A, B;
reg [2:0] sel;
wire [2:0] y;


alu4 uut (.A(A), .B(B), .sel(sel), .y(y));

initial begin
  $dumpfile("alu4.vcd");
  $dumpvars(0, tb_alu4);
$monitor("time=%0t | A=%b | B=%b | sel=%b | y=%b", $time, A, B, sel, y);

A=3'b101; B=3'b010;   // A=5, B=2

sel=3'b000; #10; 
sel=3'b001; #10; 
sel=3'b010; #10; 
sel=3'b011; #10; 
sel=3'b100; #10; 
sel=3'b101; #10; 
sel=3'b110; #10; 
sel=3'b111; #10; 

$finish;
end

endmodule
------------------------------------------------------------------
`timescale 1ns/1ps

module alu5 (
    input  [2:0] A, B,
    input  [2:0] sel,
    output reg [2:0] y);

always @(*) begin
case (sel)

3'b000: y = A + B;           
3'b001: y = A - B;             
3'b010: y = A * B;             

3'b100: y = A & B;            
3'b101: y = ~A;               
3'b110: y = A | B;             
3'b111: y = A ^ B;         

default: y = (B != 0) ? (A / B) : 3'b000;  
endcase
end

endmodule


`timescale 1ns/1ps

module tb_alu5;

reg [2:0] A, B;
reg [2:0] sel;
wire [2:0] y;

alu5 uut (.A(A), .B(B), .sel(sel), .y(y));

initial begin
  $dumpfile("alu5.vcd");
  $dumpvars(0, tb_alu5);
$monitor("time=%0t | A=%b | B=%b | sel=%b | y=%b", $time, A, B, sel, y);

A = 3'b101; B = 3'b010;

sel = 3'b000; #10; 
sel = 3'b001; #10; 
sel = 3'b010; #10; 
sel = 3'b011; #10; 
sel = 3'b100; #10; 
sel = 3'b101; #10; 
sel = 3'b110; #10; 
sel = 3'b111; #10; 

A = 3'b111; B = 3'b011;
sel = 3'b000; #10; 
sel = 3'b001; #10; 
sel = 3'b010; #10; 
sel = 3'b011; #10; 
sel = 3'b100; #10; 
sel = 3'b101; #10; 
sel = 3'b110; #10; 
sel = 3'b111; #10; 
$finish;
end

endmodule

    $finish;
end

endmodule
