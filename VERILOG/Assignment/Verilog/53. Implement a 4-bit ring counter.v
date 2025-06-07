//design code
module ringcount(
  input clk,rst,
  output reg [3:0]q);

  always@(posedge clk or posedge rst)begin
    if(rst)
      q<=4'b0101;
    else
      q<={q[2:0],q[3]};
  end
endmodule

//   always@(posedge clk or posedge rst)begin
//     if(rst)
//       q<=4'b0000;
//     else begin
//       q[3]<=q[2];
//       q[2]<=q[1];
//       q[1]<=q[0];
//       q[0]<=q[3];
//     end
//   end
// endmodule

//testbennch code
module ringcount_tb;
  reg clk,rst;
  wire [3:0]q;
  
  ringcount uut (clk,rst,q);
  
  initial begin 
    $dumpfile("ringcount.vcd");
    $dumpvars(1,ringcount_tb);
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
  0	0	1	0101
  5	1	1	0101
10	0	0	0101
15	1	0	1010
20	0	0	1010
25	1	0	0101
30	0	0	0101
35	1	0	1010
40	0	0	1010
45	1	0	0101
50	0	0	0101
55	1	0	1010
60	0	0	1010
65	1	0	0101
70	0	0	0101
75	1	0	1010
80	0	0	1010
85	1	0	0101
