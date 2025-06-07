//design code
module johnsoncount(
  input clk,rst,
  output reg [3:0]q);

 //anotherr method 
//   always@(posedge clk or posedge rst)begin
//     if(rst)
//       q<=4'b0000;
//     else
//       q<={~q[0],q[3:1]};
//   end
// endmodule

  always@(posedge clk or posedge rst)begin
    if(rst)
      q<=4'b0000;
    else begin
      q[3]<=~q[0];
      q[2]<=q[3];
      q[1]<=q[2];
      q[0]<=q[1];
    end
  end
endmodule

//testbench code
module johnsoncount_tb;
  reg clk,rst;
  wire [3:0]q;
  
  johnsoncount uut (clk,rst,q);
  
  initial begin 
    $dumpfile("johnsoncount.vcd");
    $dumpvars(1,johnsoncount_tb);
    $display("Time\tClk\tRst\tQ");
    $monitor("%0t\t%b\t%d\t%b",$time,clk,rst,q);
    
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rst=1;#10;
    rst=0;#80;
    $finish;
  end
endmodule

//output
Time	Clk	Rst	Q
  0	0	1	0000
  5	1	1	0000
10	0	0	0000
15	1	0	1000
20	0	0	1000
25	1	0	1100
30	0	0	1100
35	1	0	1110
40	0	0	1110
45	1	0	1111
50	0	0	1111
55	1	0	0111
60	0	0	0111
65	1	0	0011
70	0	0	0011
75	1	0	0001
80	0	0	0001
85	1	0	0000
