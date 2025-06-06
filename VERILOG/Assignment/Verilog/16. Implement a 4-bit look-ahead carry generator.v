//design code
module clad(
  input [3:0]a,b,//input a b
  input c0,//carryin
  output [3:0]p,//propagate
  output [3:0]g,//generate
  output [3:0]sum,//sum
  output c1,c2,c3,c4);//carry out
  
  assign p=a^b;
  assign g=a&b;
  
  assign sum[0]=p[0]^c0;
  assign sum[1]=p[1]^c1;
  assign sum[2]=p[2]^c2;
  assign sum[3]=p[3]^c3;
  
  assign c1=g[0]|(p[0]&c0);
  assign c2=g[1]|(p[1]&c1);
  assign c3=g[2]|(p[2]&c2);
  assign c4=g[3]|(p[3]&c3);
  
endmodule

//testbench code
module clad_tb;
  reg [3:0]a,b;
  reg c0;
  wire [3:0]p;
  wire [3:0]g;
  wire [3:0]sum;
  wire c1,c2,c3,c4;
  
  clad uut(a,b,c0,p,g,sum,c1,c2,c3,c4);
  
  initial begin 
    $dumpfile("clad.vcd");
    $dumpvars(1,clad_tb);
    $monitor("A=%b|B=%b|C0=%b|Propagate=%b|Generate=%b|Sum=%b|C1=%b|C2=%b|C3=%b|C4=%b",a,b,c0,p,g,sum,c1,c2,c3,c4);
  end
  
  initial begin
    a=4'b0000;b=4'b0000;c0=1'b0; #10;
    a=4'b0101;b=4'b0011;c0=1'b0; #10;
    a=4'b1111;b=4'b0001;c0=1'b0; #10;
    a=4'b1010;b=4'b0101;c0=1'b1; #10;
    a=4'b1001;b=4'b0110;c0=1'b0; #10;
    a=4'b1111;b=4'b1111;c0=1'b1; #10;

    $finish;
  end

endmodule
