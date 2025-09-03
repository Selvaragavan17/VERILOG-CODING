`timescale 1ns/1ps

module down_counter (
input clk,    
input rst_n,      
output reg [3:0] q );

always @(posedge clk or negedge rst_n) begin
if (!rst_n)
q<=4'b1111;  
else
q<=q-1;     
end
endmodule

`timescale 1ns/1ps

module tb_down_counter;
reg clk, rst_n;
wire [3:0] q;
down_counter dut (.clk(clk),.rst_n(rst_n),.q(q));

always #5 clk=~clk;

  initial begin
$dumpfile("down_counter.vcd");
$dumpvars(0, tb_down_counter);

clk=0;
rst_n=0;

#10 rst_n=1;  
#200;           
$finish;
end

initial begin
$monitor("Time=%0t | Counter = %b (%0d)", $time, q, q);
end

endmodule
-----------------------------------------
`timescale 1ns/1ps

module updown_counter_3bit (
    input clk,             
    input rst_n,           
    input load,          
    input [2:0] data_in,   
    input up_down,         
    output reg [2:0] q);

always @(posedge clk or negedge rst_n) begin
if (!rst_n)
q<=3'b000;                 
else if (load)
q<=data_in;             
else if (up_down)
q<=q+1;                  
else
q<=q-1;            
end

endmodule

`timescale 1ns/1ps

module tb_updown_counter_3bit;

reg clk, rst_n, load, up_down;
reg [2:0] data_in;
wire [2:0] q;

updown_counter_3bit dut (.clk(clk),.rst_n(rst_n),.load(load),.data_in(data_in),.up_down(up_down),.q(q));
always #5 clk =~clk;

initial begin
$dumpfile("updown_counter_3bit.vcd");
$dumpvars(0, tb_updown_counter_3bit);

clk=0;
rst_n=0; load=0; up_down=1; data_in=3'b000;

#10 rst_n=1;  
#10 load=1; data_in=3'b010;  
#10 load=0;
#50 up_down=1;
#50 up_down=0;
#50 $finish;
end

initial begin
$monitor("Time=%0t | load=%b up_down=%b data_in=%b | q=%b (%0d)",$time, load, up_down, data_in, q, q);
end

endmodule
----------------------------------------------
`timescale 1ns/1ps

module decimal_counter (
    input clk,           
    input rst_n,          
    input load,            
    input [3:0] data_in,   
    input up_down,         
    output reg [3:0] q );

always @(posedge clk or negedge rst_n) begin
if (!rst_n)
q <=4'd0;                         
else if (load)
q <=(data_in<=4'd9) ? data_in:4'd0; 
else if (up_down) begin
if (q==4'd9)
q<=4'd0;                     
else
q<=q+1;                  
end
else begin
if (q==4'd0)
q<=4'd9;                     
else
q<=q-1;                   
end
end

endmodule

`timescale 1ns/1ps

module tb_decimal_counter;

reg clk, rst_n, load, up_down;
reg [3:0] data_in;
wire [3:0] q;

decimal_counter dut (.clk(clk),.rst_n(rst_n),.load(load),.data_in(data_in),.up_down(up_down),.q(q));

always #5 clk=~clk;

initial begin
$dumpfile("decimal_counter.vcd");
$dumpvars(0, tb_decimal_counter);

clk=0;
rst_n=0; load=0; up_down=1; data_in=4'd0;

#10 rst_n=1;              
#10 load=1; data_in=4'd5; 
#10 load=0;
#60 up_down=1;             
#60 up_down=0;              
#50 $finish;
end

initial begin
$monitor("Time=%0t | load=%b up_down=%b data_in=%d | q=%d", $time, load, up_down, data_in, q);
end

endmodule
