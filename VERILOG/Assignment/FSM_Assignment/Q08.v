//design code
module fsm_mealy_overlapp(
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
      a:nst=(in==1)?b:a;
      b:nst=(in==1)?c:a;
      c:nst=(in==1)?c:a;
    endcase
  end
      assign y=(st==c)&&(in==1); 
//    always@(*)begin
//     case(st)
//       a:y=1'b0;
//       b:y=1'b0;
//       c:y=1'b1;
//     endcase
//   end
endmodule

//testbench code
module fsm_mealy_overlapp_tb;
  reg clk;
  reg rst;
  reg in;
  wire y;
  fsm_mealy_overlapp uut(.clk(clk),.rst(rst),.in(in),.y(y));
  
  initial begin
    clk=0;
  forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("fsm_mealy_overlapp.vcd");
    $dumpvars(0,fsm_mealy_overlapp_tb);
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
