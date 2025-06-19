module top_module(
    input clk,
    input in,
    input reset,
    output out); 
    parameter A=1,B=2,C=3,D=4;
    reg[2:0]state,nextstate;
    always@(posedge clk )begin
        if(reset)
            state<=A;
        else
            state<=nextstate;
    end
    
    always@(*)begin
        case(state)
            A:nextstate=(in)?B:A;
            B:nextstate=(in)?B:C;
            C:nextstate=(in)?D:A;
            D:nextstate=(in)?B:C;
        endcase
    end
    
    assign out=(state==D);

endmodule
