module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);
    wire [7:0]str1,str2;
    assign str1=(a<b)?a:b;
    assign str2=(c<d)?c:d;
    assign min=(str1<str2)?str1:str2;

    // assign intermediate_result1 = compare? true: false;

endmodule
