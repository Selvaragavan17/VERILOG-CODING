8. To design a Finite State Machine (FSM) in Verilog that detects more than one "1"in the last three samples
//design code
module fsm_more_1(
  input clk,
  input rst,
  input in,
  output reg out);
  
  parameter s0=2'b00;
  parameter s1=2'b01;
  parameter s2=2'b10;
  
  reg[1:0]state,next;
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      state<=s0;
    else
      state<=next;
  end
  
  always@(*)begin
    case(state)
      s0:next=in?s1:s0;
      s1:next=in?s2:s1;
      s2:next=in?s2:s2;
    endcase
  end
  always@(*)begin
    case(state)
      s2:out=1;
      default:out=0;
    endcase
  end
  
//   assign out=(state==s2);
endmodule
