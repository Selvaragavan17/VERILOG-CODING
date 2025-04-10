//design codee
module sipo(
  input clk,rst,
  input si,
  output reg [3:0]q);
  always@(posedge clk)begin
    if(rst)begin
      q<=4'b0000;
    end
    else begin
      q[3]<=si;
      q[2]<=q[3];
      q[1]<=q[2];
      q[0]<=q[1];

    end
  end
endmodule

//testbench code
module sipo_tb;
  reg clk,rst;
  reg si;
  wire [3:0]q;
  sipo uut(.clk(clk),.rst(rst),.si(si),.q(q));
  initial begin
    $dumpfile("sipo.vcd");
    $dumpvars(1,sipo_tb);
  end
  
  initial begin
    $monitor("Time=%0t clk=%b Rst=%b Series=%b Q=%b",$time,clk,rst,si,q);
  end
  initial begin
    rst=1;si=4'b0000;#10;
    rst=0;#10;
    si=4'b0011;#10;
    si=4'b1101;#10;
    rst=1;#10;
    rst=0;#10;
    si=4'b1110;
    $finish;
  end
  initial begin
    clk=1;
    forever #5 clk=~clk;
  end
endmodule
