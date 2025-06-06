//design code
module barrelshift(
  input [3:0]in,
  input din,
  input [1:0]shift,
  output [3:0]out);
  
  assign out=din?(in>>shift):(in<<shift);
  
endmodule

//testtbench code
module barrelshift_tb;
  reg [3:0]in;
  reg din;
  reg [1:0]shift;
  wire [3:0]out;
  
  barrelshift uut(in,din,shift,out);
  
  initial begin 
    $dumpfile("barrelshift.vcd");
    $dumpvars(1,barrelshift_tb);
    $monitor("IN=%b|DIN=%b|SHIFT=%b|OUT=%b",in,din,shift,out);
  end
  
  initial begin
    in=4'b0001;din=1'b0;shift=2'b10;#10;
    in=4'b1101;din=1'b1;shift=2'b10;#10;
    in=4'b1011;din=1'b0;shift=2'b01;#10;
    in=4'b0101;din=1'b1;shift=2'b11;#10;
    in=4'b1000;din=1'b0;shift=2'b11;#10;
    in=4'b0111;din=1'b1;shift=2'b00;#10;
  end 
endmodule
