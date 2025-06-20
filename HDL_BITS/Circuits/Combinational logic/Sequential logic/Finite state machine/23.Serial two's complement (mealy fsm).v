module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    parameter A=0,B=1;
    reg [1:0]state,nextstate;
    
    always@(posedge clk or posedge areset)begin
        if(areset)
            state<=A;
        else
            state<=nextstate;
    end
    
    always@(*)begin
        case(state)
            A:begin
                if(x)begin
                    nextstate=B;
                    z=1;
                end
                else begin
                    nextstate=A;
                z=0;
            end
            end
            B:begin
                if(x)begin
                    nextstate=B;
                    z=0;
                end
                else begin
                    nextstate=B;
                    z=1;
                end
            end
        endcase
    end

endmodule
