//design code
module comp_2b(
  input [1:0]a,b,
  output reg x,y,z);
  
  assign x= (a==b);
  assign y= (a>b);
  assign z= (a<b);
  
endmodule

//testbench code
module comp_2b_tb;
  reg [1:0]a,b;
  wire x,y,z;
  
  comp_2b uut(a,b,x,y,z);
  
  initial begin 
    $monitor("Time=%0t|A=%b|B=%b|X=%b|Y=%b|Z=%b",$time,a,b,x,y,z);
  end
  
  initial begin
    $dumpfile("comp_2b.vcd");
    $dumpvars(1,comp_2b_tb);
  end
  
  initial begin
    a=2'b00;b=2'b00;#5;
    a=2'b01;b=2'b10;#5;
    a=2'b01;b=2'b10;#5;
    a=2'b00;b=2'b11;#5;
  end
  
endmodule
