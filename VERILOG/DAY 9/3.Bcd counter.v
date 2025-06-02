//design code
module bcd_counter(
  input clk,rst,
  output reg [3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      count<=4'b0000;
    end
    else begin
      case(count)
        4'd0:count<=4'd1;
        4'd1:count<=4'd2;
        4'd2:count<=4'd3;
        4'd3:count<=4'd4;
        4'd4:count<=4'd5;
        4'd5:count<=4'd6;
        4'd6:count<=4'd7;
        4'd7:count<=4'd8;
        4'd8:count<=4'd9;
        4'd9:count<=4'd0;
      endcase
    end
  end
endmodule

//testbench code
module bcd_counter_tb;
  reg clk;
  reg rst;
  wire [3:0]count;
  
  bcd_counter uut(clk,rst,count);
  
  initial begin
    $monitor("Time=%0t|clk=%d|rst=%d|Count=%d",$time,clk,rst,count);
  end
  
  initial begin
    $dumpfile("bcd_counter.vcd");
    $dumpvars(1,bcd_counter_tb);
  end

  
  always #5 clk = ~clk;

    initial begin
        clk = 0;
      rst=1;#10;
      rst=0;#100;
      rst=1;#10;
      rst=0;#50;
      rst=1;#10;
      $finish;

    end
endmodule
