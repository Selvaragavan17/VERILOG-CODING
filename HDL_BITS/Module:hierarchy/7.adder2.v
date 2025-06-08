module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] sum0,sum1;
    wire cout0;
    
    add16 ins0(a[15:0],b[15:0],1'b0,sum0,cout0);
    add16 ins1(a[31:16],b[31:16],cout0,sum1);
    assign sum={sum1,sum0};

endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );

// Full adder module here
    assign sum=a^b^cin;
    assign cout=a&b|b&cin|cin&a;

endmodule
