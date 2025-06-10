//design code
module unsr(
  input clk,rst,
  input [1:0]sel,
  input shiftleft,
  input rightshift,
  input [7:0]datain,
  output reg [7:0]dataout);
  
  always@(posedge clk)begin
    if(rst)begin
      dataout<=0;
    end
    else begin
      case(sel)
        2'b00:dataout<=dataout;
        2'b01:dataout<={datain[6:0],shiftleft};
        2'b10:dataout<={rightshift,datain[7:1]};
        2'b11:dataout<=datain;
      endcase
    end
  end
endmodule

//testbencch code'
module unsr_tb;
  reg clk,rst;
  reg [1:0]sel;
  reg shiftleft;
  reg rightshift;
  reg [7:0]datain;
  wire [7:0]dataout;
  
  unsr uut(clk,rst,sel,shiftleft,rightshift,datain,dataout);
  
  initial begin
    $dumpfile("unsr.vcd");
    $dumpvars;
  end
  
  initial begin
    clk=0;
  forever #5 clk=~clk;
  end
  
  initial begin
      $display("$time\tclk\trst\tsel\tdatain\tshiftleft\tshiftright\tdataout");
    $monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b",$time,clk,rst,sel,datain,shiftleft,rightshift,dataout);
end
    
    initial begin
      rst=1'b1 ; sel=00 ; datain=$random ; shiftleft=1'b0 ; rightshift=1'b1; #10;
      rst=1'b0 ; sel=01 ; datain=$random ; shiftleft=1'b1 ; rightshift=1'b0; #10;
      rst=1'b0 ; sel=10 ; datain=$random ; shiftleft=1'b0 ; rightshift=1'b0; #10;
      rst=1'b0 ; sel=11 ; datain=$random ; shiftleft=1'b1 ; rightshift=1'b1; #10;
      $finish;
    end
endmodule

//output 
$time	clk	rst	sel	datain	shiftleft	shiftright	dataout
 0	0	1	00	00100100	0	1	xxxxxxxx
 5	1	1	00	00100100	0	1	00000000
10	0	0	01	10000001	1	0	00000000
15	1	0	01	10000001	1	0	00000011
20	0	0	10	00001001	0	0	00000011
25	1	0	10	00001001	0	0	00000100
30	0	0	11	01100011	1	1	00000100
35	1	0	11	01100011	1	1	01100011
testbench.sv:33: $finish called at 40 (1s)
40	0	0	11	01100011	1	1	01100011
