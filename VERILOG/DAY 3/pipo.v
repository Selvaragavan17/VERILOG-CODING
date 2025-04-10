//design code
module pipo(
  input clk,rst,
  input [3:0]d,
  output reg [3:0]q);
  always@(posedge clk)begin
    if(rst)begin
      q<=4'b0000;
    end
    else begin
      q<=d;

    end
  end
endmodule

//testbench code
module pipo_tb;
  reg clk,rst;
  reg [3:0]d;
  wire [3:0]q;
  pipo uut(.clk(clk),.rst(rst),.d(d),.q(q));
  initial begin
    $dumpfile("pipo.vcd");
    $dumpvars(1,pipo_tb);
  end
  
  initial begin
    $monitor("Time=%0t clk=%b Rst=%b D=%b Q=%b",$time,clk,rst,d,q);
  end
  initial begin
    rst=1;d=4'b0000;#10;
    rst=0;#10;
    d=4'b0011;#10;
    d=4'b1101;#10;
    rst=1;#10;
    rst=0;#10;
    d=4'b1110;
    $finish;
  end
  initial begin
    clk=1;
    forever #5 clk=~clk;
  end
endmodule
