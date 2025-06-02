//design code
module alu_operation(
  input [3:0]a,b,
  input [1:0]sel,
  output reg [3:0]alu_out);
  wire [3:0]out1,out2,out3,out4;
  
  andg inst1(a,b,out1);
  org inst2(a,b,out2);
  nandg inst3(a,b,out3);
  norg inst4(a,b,out4);
  
  always@(*)begin
    case(sel)
      2'b00:alu_out=out1;
      2'b01:alu_out=out2;
      2'b10:alu_out=out3;
      2'b11:alu_out=out4;
      default:alu_out=4'b0000;
    endcase
  end
endmodule

module andg(
  input [3:0]x1,y1,
  output [3:0]out1);
  assign out1=x1&y1;
endmodule

module org(
  input [3:0]x2,y2,
  output [3:0]out2);
  assign out2=x2|y2;
endmodule

module nandg(
  input [3:0]x3,y3,
  output [3:0]out3);
  assign out3=~(x3&y3);
endmodule

module norg(
  input [3:0]x4,y4,
  output [3:0]out4);
  assign out4=~(x4|y4);
endmodule

//testbench code
module alu_operation_tb;
  reg [3:0]a,b;
  reg [1:0]sel;
  wire [3:0]alu_out;
  alu_operation uut(a,b,sel,alu_out);
  initial begin
    a=4'b0101;b=4'b0100;
    sel=2'b00;#5;
    sel=2'b01;#5;
    sel=2'b10;#5;
    sel=2'b11;#5;
    $finish;
  end
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|sel=%b|alu_out=%b",$time,a,b,sel,alu_out);
  end
endmodule
