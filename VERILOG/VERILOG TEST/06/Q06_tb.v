//testbench code
module priority_en_tb;
  reg [7:0]d;
  wire [2:0]q;
  
  priority_en uut (d,q);
  
  initial begin
    $dumpfile("priority_en.vcd");
    $dumpvars(1,priority_en_tb);
  end
  
  initial begin
    $monitor("Time=%0t|D=%b|Q=%b",$time,d,q);
  end
  
  initial begin
    d=8'b10000001; #10;
    d=8'b00000010; #10;
    d=8'b00000100; #10;
    d=8'b00001000; #10;
    d=8'b00000000; #10;
    d=8'b00100000; #10;
    d=8'b01100000; #10;
    d=8'b10000000; #10;
    d=8'b10101010; #10;
    d=8'b00000000; #10;
    $finish;
  end
endmodule

//output
Time=0|D=10000001|Q=111
Time=10|D=00000010|Q=001
Time=20|D=00000100|Q=010
Time=30|D=00001000|Q=011
Time=40|D=00000000|Q=xxx
Time=50|D=00100000|Q=101
Time=60|D=01100000|Q=110
Time=70|D=10000000|Q=111
Time=80|D=10101010|Q=111
Time=90|D=00000000|Q=xxx
