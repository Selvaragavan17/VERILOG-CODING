//design code
module shift(
  input [3:0]a,
  input [1:0]sh,
  output reg[3:0]result);
  
  function [3:0]shift_f;
    input [3:0]x;
    input [1:0]s;
    shift_f=x>>s;
  endfunction
  
  always@(*)begin
    result=shift_f(a,sh);
  end
  
endmodule

//testbench code
module shift_tb;
  reg [3:0] a;
  reg [1:0] sh;
  wire [3:0] result;
  
  shift uut(.a(a),.sh(sh),.result(result));

  initial begin
    $dumpfile("shift.vcd");
    $dumpvars(1, shift_tb);
    $monitor("Time=%0t|a=%b|shift=%0d|result=%b", $time, a, sh, result);
  end

  initial begin
    a=4'b1101;sh=2'b00; #10;  
    a=4'b1101;sh=2'b01; #10;  
    a=4'b1101;sh=2'b10; #10;  
    a=4'b1101;sh=2'b11; #10;  
    a=4'b1000;sh=2'b10; #10;  

    $finish;
  end
endmodule
