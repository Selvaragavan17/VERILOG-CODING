//design code
module func_call(
  input [3:0]a,b,
  output reg [7:0]result);
  
  function [7:0]sum_func;
    input [7:0]x,y;
    sum_func=x+y;
  endfunction
  
  function [7:0]squa_func;
    input [3:0]p;
    squa_func=p*p;
  endfunction
  
  always@(*)begin
    result=sum_func(squa_func(a),b);
  end
endmodule

//testbench code
module func_call_tb;
  reg [3:0]a,b;
  wire [7:0]result;
  
  func_call uut(.a(a),.b(b),.result(result));

  initial begin
    $dumpfile("func_call.vcd");
    $dumpvars(1, func_call_tb);
    $monitor("Time=%0t|A=%0d|B=%0d|Result=%0d",$time,a,b,result);
  end

  initial begin
    a=4'd3;b=4'd2;#10;  
    a=4'd5;b=4'd4;#10;  
    a=4'd7;b=4'd1;#10;  
    a=4'd0;b=4'd0;#10;  
    a=4'd8;b=4'd7;#10;  
    $finish;
  end
  
endmodule

  
  
