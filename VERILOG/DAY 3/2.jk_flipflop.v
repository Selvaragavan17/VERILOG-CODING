//design code
module jk_flipflop(
  input clk, rst, j, k,
  output reg q);
  always @(posedge clk) begin
    if (rst == 0)begin
      case ({j, k})             
        2'b01: q <= 1'b0;    
        2'b10: q <= 1'b1;    
        2'b00: q <= 1'bx;
      endcase
    end
    else
      q<=0;
  end
endmodule

// testbench code
module jk_flipflop_tb;
  reg clk, rst, j, k;
  wire q;

  jk_flipflop uut (.clk(clk),.rst(rst),.j(j),.k(k),.q(q));

  initial begin
    $dumpfile("jk_flipflop.vcd");
    $dumpvars(1, jk_flipflop_tb);
  end

  initial begin
    $monitor("Time=%0t Clk=%b Rst=%b J=%b K=%b Q=%b", $time,clk,rst,j,k,q);
  end

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 0;
    j = 0; k = 0; #10;  
    j = 0; k = 1; #10;  
    j = 1; k = 0; #10;  
    j = 1; k = 1; #10;  
    $finish;
  end
endmodule
