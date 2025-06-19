module top_module(
    input clk,
    input in,
    input areset,
    output out); 
    parameter A=0,B=1,C=2,D=4;
    reg[2:0]state, nextstate;

    // State transition logic
     // State flip-flops with asynchronous reset
    always@(posedge clk or posedge areset)begin
        if(areset)
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
