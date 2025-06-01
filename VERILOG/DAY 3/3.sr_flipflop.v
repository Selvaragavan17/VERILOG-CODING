//design code
module sr_flipflop(
  input clk, rst, s, r,
  output reg q);
  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;
    else begin
      case ({s, r})             
        2'b01: q <= 1'b0;    
        2'b10: q <= 1'b1;    
        2'b11: q <= 1'bx;    
      endcase
    end
  end
endmodule

//testbench code
module sr_flipflop_tb;
  reg clk, rst, s, r;
  wire q;

  sr_flipflop uut (.clk(clk),.rst(rst),.s(s),.r(r),.q(q));

  initial begin
    $dumpfile("sr_flipflop.vcd");
    $dumpvars(1, sr_flipflop_tb);
  end

  initial begin
    $monitor("Time=%0t Clk=%b Rst=%b S=%b R=%b Q=%b", $time,clk,rst,s, r,q);
  end

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 0;
    s = 0; r = 0; #10;  
    s = 0; r = 1; #10;  
    s = 1; r = 0; #10;  
    s = 1; r = 1; #10;  
    $finish;
  end
endmodule
