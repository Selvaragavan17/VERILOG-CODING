//design code
module moore(clk,rst,in,out);
  input wire in,clk,rst;
  output reg out;
  
  parameter a=3'b000;
  parameter b=3'b001;
  parameter c=3'b010;
  parameter d=3'b011;
  parameter e=3'b100;
  
  reg [2:0]state,next_state;
  
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
          next_state<=e;
        end
      e:begin
        if(in==0)
          next_state<=a;
        else
          next_state<=c;
        end
      default:next_state<=a;
    endcase
  end
  always@(*)begin
    case(state)
      a:out=0;
      b:out=0;
      c:out=0;
      d:out=0;
      e:out=1;
    endcase
  end
endmodule

//testbench code
module moore_tb();
  reg in,rst,clk;
  wire out;
  moore uut(.in(in),.rst(rst),.clk(clk),.out(out));
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  initial begin
    rst=1'b1;in=1'b1;#10;
    rst=1'b1;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b0;#10;
    rst=1'b0;in=1'b1;#10; 
    rst=1'b0;in=1'b1;#10;

    #1;$finish;
  end
  initial begin
    $dumpfile("moore.vcd");
    $dumpvars(1,moore_tb);
  end
  initial begin
    $monitor("$Time=%0t| RST=%b| CLK=%b| IN=%b| OUT=%b",$time,rst,clk,in,out);
  end
endmodule
