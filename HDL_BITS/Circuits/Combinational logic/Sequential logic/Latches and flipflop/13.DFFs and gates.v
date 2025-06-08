module top_module (
    input clk,
    input x,
    output z
);
    wire a,b,c;
    wire p,q,r;
    assign a=x^p;
    assign b=x&~q;
    assign c=x|~r;
    assign z=~(p|q|r);
    my_dff d1(a,clk,p);
    my_dff d2(b,clk,q);
    my_dff d3(c,clk,r);
endmodule


module my_dff(
    input d,clk,
    output reg q);
    always@(posedge clk)begin
      q<=d;
    end
endmodule
