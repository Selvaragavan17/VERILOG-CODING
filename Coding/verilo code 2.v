`timescale 1ns/1ps

module mux8x1 (
input  [7:0] d,    
input  [2:0] sel,   
output reg y );

always @(*) begin
case (sel)
3'b000: y = d[0];
3'b001: y = d[1];
3'b010: y = d[2];
3'b011: y = d[3];
3'b100: y = d[4];
3'b101: y = d[5];
3'b110: y = d[6];
3'b111: y = d[7];
default: y = 1'b0;
endcase
end

endmodule

`timescale 1ns/1ps

module tb_mux8x1;

    reg  [7:0] d;
    reg  [2:0] sel;
    wire y;


mux8x1 dut (.d(d),.sel(sel),.y(y));

initial begin
$dumpfile("tb_mux8x1.vcd");
$dumpvars(0, tb_mux8x1);

d = 8'b10101010;
sel = 3'b000;

#10 sel = 3'b000;  
#10 sel = 3'b001;  
#10 sel = 3'b010;  
#10 sel = 3'b011;  
#10 sel = 3'b100;  
#10 sel = 3'b101; 
#10 sel = 3'b110; 
#10 sel = 3'b111;  

#20 $finish;
end

initial begin
$monitor("Time=%0t | sel=%b | y=%b", $time, sel, y);
end

endmodule
----------------------------------------------------------------------------------------------------
// 16x1 MUX using conditional operator
module mux16x1 (
    input  [15:0] d,
    input  [3:0]  sel,
    output y);

assign y = (sel == 4'd0)  ? d[0]  :
           (sel == 4'd1)  ? d[1]  :
           (sel == 4'd2)  ? d[2]  :
           (sel == 4'd3)  ? d[3]  :
           (sel == 4'd4)  ? d[4]  :
           (sel == 4'd5)  ? d[5]  :
           (sel == 4'd6)  ? d[6]  :
           (sel == 4'd7)  ? d[7]  :
           (sel == 4'd8)  ? d[8]  :
           (sel == 4'd9)  ? d[9]  :
           (sel == 4'd10) ? d[10] :
           (sel == 4'd11) ? d[11] :
           (sel == 4'd12) ? d[12] :
           (sel == 4'd13) ? d[13] :
           (sel == 4'd14) ? d[14] :
                            0;
endmodule

`timescale 1ns/1ps
module tb_mux16x1;

reg [15:0] d;
reg [3:0]  sel;
wire y;

mux16x1 uut (.d(d), .sel(sel), .y(y));

initial begin
$dumpfile("mux16x1_tb.vcd");
$dumpvars(0, tb_mux16x1);

d = 16'b1010_1100_1111_0001;

sel = 4'd0;  #10;
sel = 4'd1;  #10;
sel = 4'd5;  #10;
sel = 4'd10; #10;
sel = 4'd15; #10;

$finish;
end

initial begin
$monitor("Time=%0t | sel=%d | y=%b", $time, sel, y);
end

endmodule
-------------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

module demux1x2 (
input din,        
input sel,      
output reg y0,    
output reg y1);

always @(*) begin
case (sel)
1'b0: begin
y0 = din;
y1 = 0;
end
1'b1: begin
y0 = 0;
y1 = din;
end
endcase
end
endmodule


`timescale 1ns/1ps

module tb_demux1x2;

reg din, sel;
wire y0, y1;


demux1x2 dut (.din(din),.sel(sel),.y0(y0),.y1(y1));

initial begin
$monitor("Time=%0t | din=%b sel=%b | y0=%b y1=%b", $time, din, sel, y0, y1);


din =0; sel =0; #10;
din =1; sel =0; #10;
din =1; sel =1; #10;
din =0; sel =1; #10;

$finish;
end

endmodule
------------------------------------------------------------
`timescale 1ns/1ps

module demux1x4 (
input din,       
input [1:0] sel,    
output reg y0,    
output reg y1,     
output reg y2,     
output reg y3);

always @(*) begin
  y0 = 0; y1 = 0; y2 = 0; y3 = 0;

case (sel)
2'b00:y0=din;
2'b01:y1=din;
2'b10:y2=din;
2'b11:y3=din;
endcase
end

endmodule


`timescale 1ns/1ps

module tb_demux1x4;

reg din;
reg [1:0] sel;
wire y0, y1, y2, y3;


demux1x4 dut (
.din(din),.sel(sel),.y0(y0),.y1(y1),.y2(y2),.y3(y3));

initial begin
    $monitor("Time=%0t | din=%b sel=%b | y0=%b y1=%b y2=%b y3=%b",
              $time, din, sel, y0, y1, y2, y3);
din = 1; sel = 2'b00; #10;
din = 1; sel = 2'b01; #10;
din = 1; sel = 2'b10; #10;
din = 1; sel = 2'b11; #10;

din = 0; sel = 2'b00; #10;
din = 0; sel = 2'b01; #10;
din = 0; sel = 2'b10; #10;
din = 0; sel = 2'b11; #10;

$finish;
end

endmodule
------------------------------------------------------------------------------------
`timescale 1ns/1ps
module decoder3x8 (
input [2:0] in,       
output reg [7:0] out);

always @(*) begin
case (in)
3'b000: out = 8'b00000001;
3'b001: out = 8'b00000010;
3'b010: out = 8'b00000100;
3'b011: out = 8'b00001000;
3'b100: out = 8'b00010000;
3'b101: out = 8'b00100000;
3'b110: out = 8'b01000000;
3'b111: out = 8'b10000000;
default: out = 8'b00000000; 
endcase
end
endmodule

`timescale 1ns/1ps
module tb_decoder3x8;

reg [2:0] in;
wire [7:0] out;

   
decoder3x8 uut (.in(in),.out(out));

initial begin
$monitor("Time=%0t | in=%b | out=%b", $time, in, out);
in = 3'b000; #10;
in = 3'b001; #10;
in = 3'b010; #10;
in = 3'b011; #10;
in = 3'b100; #10;
in = 3'b101; #10;
in = 3'b110; #10;
in = 3'b111; #10;

$finish;
end
endmodule
-----------------------------------------------------------------------
`timescale 1ns/1ps

module decoder3x8 (
    input [2:0] in,      
    input en,            
    output reg [7:0] out);

always @(*) begin
if (en) begin
case (in)
3'b000: out = 8'b0000_0001;
3'b001: out = 8'b0000_0010;
3'b010: out = 8'b0000_0100;
3'b011: out = 8'b0000_1000;
3'b100: out = 8'b0001_0000;
3'b101: out = 8'b0010_0000;
3'b110: out = 8'b0100_0000;
3'b111: out = 8'b1000_0000;
default: out = 8'b0000_0000;
endcase
end else begin
out = 8'b0000_0000; 
end
    end

endmodule
`timescale 1ns/1ps

module tb_decoder3x8;

reg [2:0] in;
reg en;
wire [7:0] out;


decoder3x8 uut (.in(in),.en(en),.out(out));

initial begin
$monitor("Time=%0t | en=%b in=%b -> out=%b", $time, en, in, out);
en = 0; in = 3'b000; #10;
in = 3'b111; #10;

en = 1; 
in = 3'b000; #10;
in = 3'b001; #10;
in = 3'b010; #10;
in = 3'b011; #10;
in = 3'b100; #10;
in = 3'b101; #10;
in = 3'b110; #10;
in = 3'b111; #10;

$finish;
end

endmodule
-----------------------------------------------------------------------
