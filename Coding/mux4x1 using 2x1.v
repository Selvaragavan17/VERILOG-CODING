`timescale 1ns/1ps
module mux2x1 (
    input a, b,  
    input sel,    
  output y); 
    assign y = (sel) ? b : a;  
endmodule

module mux4x1 (
    input [3:0] d,    
    input [1:0] sel,
    output y );

wire y0, y1;  
mux2x1 m1 (
.a(d[0]),
.b(d[1]),
.sel(sel[0]),
.y(y0));
mux2x1 m2 (
.a(d[2]),
.b(d[3]),
.sel(sel[0]),
.y(y1));

mux2x1 m3 (
.a(y0),
.b(y1),
.sel(sel[1]),
.y(y));

endmodule


//testbench code
`timescale 1ns/1ps

module tb_mux4x1;

    reg [3:0] d;    
    reg [1:0] sel;     
    wire y;           
mux4x1 uut (
.d(d),
.sel(sel),
.y(y));

initial begin
$dumpfile("tb_mux4x1.vcd"); 
$dumpvars(0, tb_mux4x1);
d = 4'b1010;   
sel = 2'b00; #10;
$display("sel=%b, y=%b (expected %b)", sel, y, d[0]);

sel = 2'b01; #10;
$display("sel=%b, y=%b (expected %b)", sel, y, d[1]);

sel = 2'b10; #10;
$display("sel=%b, y=%b (expected %b)", sel, y, d[2]);
sel = 2'b11; #10;
$display("sel=%b, y=%b (expected %b)", sel, y, d[3]);

        $finish;
    end
endmodule

