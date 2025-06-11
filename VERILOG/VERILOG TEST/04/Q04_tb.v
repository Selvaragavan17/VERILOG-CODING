//testbench code
module gates_tb;
  reg a,b,c,d,e;
  wire y;
  
  gates uut (a,b,c,d,e,y);
  
  initial begin
    $dumpfile("gates.vcd");
    $dumpvars(1,gates_tb);
  end
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|C=%b|D=%b|E=%b|Y=%b",$time,a,b,c,d,e,y);
  end
  
  initial begin
    a=1;b=0;c=1;d=0;e=1;#10;
    a=0;b=0;c=1;d=1;e=1;#10;
    a=1;b=1;c=1;d=1;e=1;#10;
  end
endmodule

//output
Time=0|A=1|B=0|C=1|D=0|E=1|Y=x
Time=9|A=1|B=0|C=1|D=0|E=1|Y=1
Time=10|A=0|B=0|C=1|D=1|E=1|Y=1
Time=20|A=1|B=1|C=1|D=1|E=1|Y=1
