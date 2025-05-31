module mealy_overlapp(
  input clk,
  input rst,
  input in,
  output reg y);

  parameter a = 2'b00;
  parameter b = 2'b01;
  parameter c = 2'b10;

  reg [1:0]st,nst;
  
  always@(posedge clk)begin
    if (rst)
      st<=a;
    else
      st<=nst;
  end
  
  always@(st or in)begin
    case(st)
      a:begin
        if(in)
          nst<=b;
        else
          nst<=a;
      end
      b:begin
        if(in)
          nst<=c;
        else
          nst<=a;
      end
      c:begin
        if(in)
          nst<=c;
        else
          nst<=a;
      end
    endcase
  end
  //     assign y=(st==c)&&(in==1); 
   always@(*)begin
    case(st)
      a:y=1'b0;
      b:y=1'b0;
      c:y=1'b1;
    endcase
  end
endmodule
     

//testbench
module mealy_overlapp_tb;
  reg clk;
  reg rst;
  reg in;
  wire y;
  mealy_overlapp uut(.clk(clk),.rst(rst),.in(in),.y(y));
  
  initial begin
    clk=0;
  forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("mealy_overlapp.vcd");
    $dumpvars(0,mealy_overlapp_tb);
  end
  
  initial begin
    rst=1; in=1; #10;
    rst=0;#10;
    in=1'b1;#10;
    in=1'b0;#10;
    in=1'b1;#10;
    in=1'b1;#10;
    in=1'b1;#10;
    in=1'b1;#10;
    in=1'b0;#10;
    in=1'b1;#10;
    in=1'b0;#10;
    $finish;
  end
  
  initial  begin
    $monitor("Time=%0t | clk=%b | rst=%b | input=%b | output=%b",$time,clk,rst,in,y);
  end
  
endmodule
