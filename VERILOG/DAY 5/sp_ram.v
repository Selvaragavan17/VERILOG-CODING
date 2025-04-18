//design code
module sp_ram(
  input clk,
  input w,
  input [9:0]add,
  input [7:0]din,
  output reg [7:0]dout);
  reg[7:0]ram[0:1023];
  always@(posedge clk)begin
    if(w)
      ram[add]<= din;
    else
      dout<=ram[add];
  end
endmodule

//testbench code
module sp_ram_tb();
  reg clk;
  reg w;
  reg [9:0]add;
  reg [7:0]din;
  wire [7:0]dout;
  wire [7:0]ram[1023:0];
  sp_ram uut(clk,w,add,din,dout);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("sp_ram.vcd");
    $dumpvars(1,sp_ram_tb);
  end
  
  initial begin
    w=1;add=32;din=8'b00001001;#10;
    w=0;add=32;din=8'b00001001;#10;
    w=1;add=55;din=8'b00001111;#10;
    w=0;add=55;din=8'b00001001;#10;
    $finish;
  end
 
  initial begin
    $monitor("$Time=%0t clk=%b w_en=%b address=%d din=%b dout=%b " ,$time,clk,w,add,din,dout);
  
  end
endmodule
