//design code
module mux4to1(
  input [3:0]in,
  input [1:0]s,
  output reg out);
  
  always@(*)begin
    case(s)
      2'b00:out=in[0];
      2'b01:out=in[1];
      2'b10:out=in[2];
      2'b11:out=in[3];
    endcase
  end
endmodule

//testbench
module mux4to1_tb;
  reg [3:0]in;
  reg [1:0]s;
  wire out;
  
  mux4to1 uut(in,s,out);
  
  initial begin
    $dumpfile("mux4to1.vcd");
    $dumpvars(1,mux4to1_tb);
  end
  
  initial begin
    $monitor("IN=%b|SEL=%b|OUT=%b",in,s,out);
  end
  
  initial begin
    in=4'b1010;
    s=2'b00;#10;
    s=2'b01;#10;
    s=2'b10;#10;
    s=2'b11;#10;
    
    in=4'b0111;
    s=2'b00;#10;
    s=2'b01;#10;
    s=2'b10;#10;
    s=2'b11;#10;
    
  end
endmodule
