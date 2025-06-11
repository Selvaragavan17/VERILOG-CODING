9.Design a finite state machine that has an input x and output y. The output should be asserted whenever x = 1 or x = 0 for three consecutive clock pulses. 
  In other words, the FSM should detect the sequences 111 or 000. Overlapping sequences are allowed, so a sequence of four or five Os or 1s should also output 1. 

//design code
    module fsm111(
       input clk,
       input reset,
       input in,
       output reg out);
  parameter s0 = 3'b000;
  parameter s1 = 3'b001;
  parameter s2 = 3'b010;
  parameter s3 = 3'b011;
  parameter s4 = 3'b100;
  parameter s5 = 3'b101;
  parameter s6 = 3'b110;
                       
    
  reg [1:0]state,next;
    
  always @ ( posedge clk or posedge reset ) begin
      if(reset) begin
            state <= s0;
        end
        else
            state <= next;
    
    end
    
  always @(*) begin
        case(state)
            s0:next=in?s1:s4;
            s1:next=in?s2:s4;
            s2:next=in?s3:s4;
            s3:next=in?s3:s4;
            s4:next=in?s1:s5;
            s5:next=in?s1:s6;
            s6:next=in?s1:s6;
          default:next=s0;
        endcase
        
    end
  always@(*)
    begin
      case(state)
        s3 : out = 1;
        s6 : out = 1;
        default : out = 0;
      endcase
    end

endmodule
