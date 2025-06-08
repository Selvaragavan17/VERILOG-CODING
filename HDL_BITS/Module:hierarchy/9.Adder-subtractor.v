module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [15:0] sum0,sum1;
    wire cout0;
    wire [32:0]b_xor_sub;
    
    assign b_xor_sub={32{sub}}^b;
    
    add16 ins0(a[15:0],b_xor_sub[15:0],sub,sum0,cout0);
    add16 ins1(a[31:16],b_xor_sub[31:16],cout0,sum1);
    assign sum={sum1,sum0};

endmodule
