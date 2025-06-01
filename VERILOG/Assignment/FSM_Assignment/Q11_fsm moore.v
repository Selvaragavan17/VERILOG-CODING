//design code
module fsm_moore(
  input in,clk,rst,
  output reg y);
  
  parameter OFF=1'b0;
  parameter ON=1'b1;
  
  reg st,nst;
  
  always@(posedge clk)begin
    if(rst)
      st<=OFF;
    else
      st<=nst;
  end
  
  always@(in or st)begin
    case(st)
      OFF:nst=(in)?ON:OFF;
      ON:nst=(in)?OFF:ON;
      default:nst=OFF;
    endcase
  end
  
  always@(*)begin
    case(st)
      OFF:y=0;
      ON:y=1;
    endcase
  end
endmodule

//testbench code
module fsm_moore_tb;
  reg in,clk,rst;
  wire y;
  
  fsm_moore uut(in,clk,rst,y);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $monitor("Time=%0t|clk=%b|rst=%b|In=%b|Y=%b",$time,clk,rst,in,y);
  end
  
  initial begin
    $dumpfile("fsm_moore.vcd");
    $dumpvars(1,fsm_moore_tb);
  end
  
  initial begin
    rst=1'b1;in=1'b1;#10;
    rst=1'b1;in=1'b1;#10;  
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b0;#10;
    rst=1'b0;in=1'b1;#10; 
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b0;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b0;#10;
    rst=1'b0;in=1'b1;#10;
    #1;$finish;
  end
endmodule
