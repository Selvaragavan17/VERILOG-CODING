//design code
module mealy(clk,rst,in,out);
  input wire in,clk,rst;
  output reg out;
  
  parameter a=4'b0001;
  parameter b=4'b0010;
  parameter c=4'b0100;
  parameter d=4'b1000;
  
  reg [3:0]state,next_state;
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      state<=a;
    else
      state<=next_state;
  end
  always@(state or in)begin
    case(state)
      a:begin
        if(in==0)
          next_state<=a;
        else
          next_state<=b;
        end
      b:begin
        if(in==0)
          next_state<=a;
        else
          next_state<=c;
        end
      c:begin
        if(in==0)
          next_state<=d;
        else
          next_state<=c;
        end
      d:begin
        if(in==0)
          next_state<=a;
        else
          next_state<=a;
        end
      default:next_state<=a;
    endcase
  end
  always@(*)begin
    case(state)
      a:out=0;
      b:out=0;
      c:out=0;
      d:out=1;
    endcase
  end
endmodule


// testbench code
module mealy_tb();
  wire out;
  reg in,rst,clk;
  mealy uut(.in(in),.rst(rst),.clk(clk),.out(out));
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  initial begin
    rst=1'b1;in=1'b1;#10;
    rst=1'b1;in=1'b1;#10;  
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;

    #1;$finish;
  end
  initial begin
    $dumpfile("mealy.vcd");
    $dumpvars(1,mealy_tb);
  end
  initial begin
    $monitor("$Time=%0t||rst=%b||clk=%b||IN=%b||OUT=%b",$time,rst,clk,in,out);
  end
endmodule
