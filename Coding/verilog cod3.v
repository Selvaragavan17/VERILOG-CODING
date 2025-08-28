
module d_latch (
    input  wire d,     
    input  wire en,    
    output reg  q);

always @ (d or en) begin
if (en)          
q = d;
   
end

endmodule

`timescale 1ns/1ps
module tb_d_latch;

reg d, en;
wire q;

d_latch dut (.d(d),.en(en),.q(q));

initial begin

$monitor("Time=%0t | d=%b en=%b  q=%b", $time, d, en, q);
d=0; en=0;
#10 d=1; en=0;   
#10 d=1; en=1;   
#10 d=0; en=1;   
#10 d=1; en=0;   
#10 d=0; en=0;   
#10 d=1; en=1;  
        
#10 $finish;
end

endmodule
----------------------------------------------------------------

module d_latch_neg (
input  wire d,    
input  wire en,    
output reg  q);

always @ (d or en) begin
if (~en)           
q = d;
end

endmodule

`timescale 1ns/1ps
module tb_d_latch_neg;
reg d, en;
wire q;
d_latch_neg dut (.d(d),.en(en),.q(q));

initial begin
$monitor("Time=%0t | d=%b en=%b  q=%b", $time, d, en, q);
d=0; en=1;  // en=1  latch holds, q=0 (default)
        
#10 d=1; en=1;   
#10 d=1; en=0;   
#10 d=0; en=0;  
#10 d=1; en=1;
#10 d=0; en=1; 
#10 d=1; en=0;
#10 $finish;
end
endmodule
-------------------------------------------
// d_latch_pos_rst.v
module d_latch_pos_rst (
    input  wire d,      
    input  wire en,    
    input  wire rst, 
    output reg  q);

always @ (d or en or rst) begin
if (rst)           
q = 1'b0;
else if (en)        
q = d;
end

endmodule

`timescale 1ns/1ps
module tb_d_latch_pos_rst;
    reg d, en, rst;
    wire q;
d_latch_pos_rst dut (.d(d),.en(en),.rst(rst),.q(q) );

initial begin
$monitor("Time=%0t | rst=%b en=%b d=%b -> q=%b", $time, rst, en, d, q);


d=0; en=0; rst=0;
#5 rst=1;    
#5 rst=0;
#10 d=1; en=0; 
#10 en=1; d=1; 
#10 d=0;         

#10 en=0; d=1; 
#10 en=1; d=1; 
#5  rst=1;       
#5  rst=0;       
#10 d=0; en=1; 
#10 $finish;
end
endmodule
---------------------------------------------------------------------
`timescale 1ns/1ps

module dff_sync_reset (
    input  wire clk,     
    input  wire rst,     
    input  wire d,       
    output reg  q);

always @(posedge clk) begin
if (rst) 
q<=1'b0;  
else 
q<=d;     
end

endmodule

`timescale 1ns/1ps

module tb_dff_sync_reset;

reg clk, rst, d;
wire q;

dff_sync_reset uut (.clk(clk),.rst(rst),.d(d),.q(q));

initial begin
clk=0;
forever #5 clk=~clk; 
end

initial begin
$monitor("Time=%0t | clk=%b rst=%b d=%b q=%b", $time, clk, rst, d, q);
rst=0; d=0;
#7 rst=1;
#10 rst=0; 

#10 d=1;
#10 d=0;
#10 d=1;

#5  rst=1;
#10 rst=0;

#20 $finish;
end
endmodule
---------------------------------------------------------------------
`timescale 1ns/1ps

module dff_neg_sync_reset (
    input  wire clk,  
    input  wire rst,   
    input  wire d,     
    output reg  q);

always @(negedge clk) begin
if (rst)
q<=1'b0;   
else
q<=d;      
end

endmodule

`timescale 1ns/1ps

module tb_dff_neg_sync_reset;
reg clk, rst, d;
wire q;

dff_neg_sync_reset uut (.clk(clk),.rst(rst),.d(d),.q(q));

initial begin
clk=0;
forever #5 clk=~clk;  
end

 
initial begin
$monitor("Time=%0t | clk=%b rst=%b d=%b q=%b", $time, clk, rst, d, q);


rst=0; d=0;

#7  rst=1;   
#10 rst=0;   

#10 d=1;
#10 d=0;
#10 d=1;
#3  rst=1;
#10 rst=0;

#20 $finish;
    end

endmodule
------------------------------------------------------------------------------
`timescale 1ns/1ps

module dff_pos_sync_reset_n (
    input  wire clk,    
    input  wire rst_n, 
    input  wire d,
    output reg  q );

always @(posedge clk) begin
if (!rst_n)    
q<=1'b0;  
else
q<=d;  
end

endmodule
`timescale 1ns/1ps

module tb_dff_pos_sync_reset_n;

reg clk, rst_n, d;
wire q;

dff_pos_sync_reset_n uut (.clk(clk),.rst_n(rst_n),.d(d),.q(q));

initial begin
clk=0;
forever #5 clk=~clk; 
end

initial begin
$monitor("Time=%0t | clk=%b rst_n=%b d=%b q=%b", $time, clk, rst_n, d, q);
rst_n = 1; d = 0;
#7  rst_n=0;  
#10 rst_n=1;  
#10 d=1;
#10 d=0;
#10 d=1;
#3  rst_n=0;   
#10 rst_n=1;  
#20 $finish;
end
endmodule
-------------------------------------------------------------
module dff_async_reset (
    input  wire clk, 
    input  wire rst,
    input  wire d,    
    output reg  q );

always @(posedge clk or posedge rst) begin
if (rst) 
q<=1'b0; 
else 
q<=d; 
end
endmodule

`timescale 1ns/1ps

module tb_dff_async_reset;

reg clk, rst, d;
wire q;

dff_async_reset uut (.clk(clk),.rst(rst),.d(d),.q(q));
initial clk=0;
always #5 clk=~clk;

initial begin
     
rst=0; d=0;
#3 rst=1;    
#7 rst=0; 
#5 d=1;  
#10 d=0;
#10 d=1;
#7 rst=1; 
#5 rst=0;
#20 $finish;
end
initial begin
$monitor("Time=%0t | clk=%b rst=%b d=%b q=%b", $time, clk, rst, d, q);
end

endmodule
-----------------------------------------------------------
module upcounter_2bit (
    input  wire clk,    
    input  wire rst,     
    output reg [1:0] q );

always @(posedge clk) begin
if (rst)
q<=2'b00;   
else
q<=q+1'b1;  
end

endmodule

`timescale 1ns/1ps

module tb_upcounter_2bit;

reg clk, rst;
wire [1:0] q;
upcounter_2bit uut (.clk(clk),.rst(rst),.q(q));
initial clk=0;
always #5 clk=~clk;
initial begin
rst=1;   
#12 rst=0; 
#80;rst=1;
#10 rst=0;
#50 $finish;
end
initial begin
$monitor("Time=%0t | clk=%b rst=%b q=%b", $time, clk, rst, q);
end
endmodule
-------------------------------------------------------------------------------
module updown_counter_2bit (
    input  wire clk,    
    input  wire rst,      
    input  wire up_down, 
    output reg [1:0] q );

always @(posedge clk) begin
if (rst)
q<=2'b00;          
else if (up_down)
q<=q+1'b1;     
else
q<=q-1'b1; 
end

endmodule

`timescale 1ns/1ps

module tb_updown_counter_2bit;

reg clk, rst, up_down;
wire [1:0] q;

updown_counter_2bit uut (.clk(clk),.rst(rst),.up_down(up_down),.q(q));
initial clk=0;
always #5 clk=~clk;

initial begin
$monitor("Time=%0t | clk=%b rst=%b up_down=%b q=%b", $time, clk, rst, up_down, q);

rst=1; up_down=1; 
#12 rst=0;   
up_down=1;#40;
up_down=0;#40;
rst=1;
#10 rst=0;
up_down=1;#40;
$finish;
end

endmodule
-------------------------------------------------------------------
`timescale 1ns/1ps

module decimal_up_counter (
    input  wire clk,  
    input  wire rst,      
    input  wire load,     
    input  wire [3:0] data_in, 
    output reg  [3:0] count 
);

always @(posedge clk or posedge rst) begin
if (rst)
count <= 4'd0;                   
else if (load)
count <= data_in;               
else if (count == 4'd9)
count <= 4'd0;                
else
count <= count + 1'b1;   
end
endmodule

`timescale 1ns/1ps

module tb_decimal_up_counter;

    reg clk, rst, load;
    reg [3:0] data_in;
    wire [3:0] count;

 decimal_up_counter dut (.clk(clk),.rst(rst),.load(load),.data_in(data_in),.count(count));

always #5 clk = ~clk; 

initial begin
$monitor($time, " clk=%b rst=%b load=%b data_in=%d count=%d", clk, rst, load, data_in, count);
clk = 0; rst = 0; load = 0; data_in = 0;
#2 rst = 1;
#10 rst = 0;
#50;
load = 1; data_in = 4'd5;
#10 load = 0;
#60;
rst = 1;
#10 rst = 0;
#50;
$finish;
end
endmodule
-----------------------------------------------------------------
module decimal_counter (
    input  wire clk,         
    input  wire rst,         
    input  wire load,       
    input  wire up_down,    
    input  wire [3:0] data_in, 
    output reg  [3:0] count  
);

always @(posedge clk) begin
if (rst) begin
count<=4'd0;                  
end else if (load) begin
if (data_in<=4'd9)              
count<=data_in;  
else
count<=4'd0;               
end else if (up_down) begin
if (count==4'd9)                
count<=4'd0;
else
count<=count+ 1;
end else begin
    if (count==4'd0)          
count<=4'd9;
else
count<=count - 1;
end
end

endmodule

`timescale 1ns/1ps

module tb_decimal_counter;

    reg clk, rst, load, up_down;
    reg [3:0] data_in;
    wire [3:0] count;
decimal_counter uut (.clk(clk),.rst(rst),.load(load),.up_down(up_down),.data_in(data_in),.count(count));

initial clk=0;
  always #5 clk=~clk;

initial begin
$monitor("T=%0t | rst=%b load=%b up_down=%b data_in=%d count=%d",
                 $time, rst, load, up_down, data_in, count);
rst=1; load=0; up_down=1; data_in=4'd0;
#12 rst=0;
up_down=1;
#50;

up_down=0;
#50;
load=1; data_in=4'd5;
#10 load=0;
#40;
load=1; data_in=4'd12;
#10 load=0;
#30;
$finish;
end

endmodule

