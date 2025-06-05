//design code
module arth_op(
  input [3:0]a,b,
  output reg [3:0]add,sub);
  
  task add_t;
    input [3:0]x,y;
    output [3:0]add_t;
    add_t=x+y;
  endtask
  
  task sub_t;
    input [3:0]x,y;
    output [3:0]sub_t;
    sub_t=x-y;
  endtask
  
  always@(*)begin
    add_t(a,b,add);
    sub_t(a,b,sub);
  end
  
endmodule

//testbench code
module arth_op_tb;
  reg [3:0]a,b;
  wire [3:0]add,sub;
  
  arth_op uut(a,b,add,sub); 
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|ADD=%b|SUB=%b",$time,a,b,add,sub);
  end
  
  initial begin
    $dumpfile("arth_op.vcd");
    $dumpvars(1,arth_op_tb);
  end
  
  initial begin
    a=4'd10;b=4'd4;#10;
    a=4'd11;b=4'd8;#10;
    a=4'd5;b=4'd2;#10;

  end
endmodule
