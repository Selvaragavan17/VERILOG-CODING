module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    wire c1,c2,c3;
    
    bcd_fadd fa1(.a(a[3:0]),.b(b[3:0]),.cin(cin),.sum(sum[3:0]),.cout(c1));
    bcd_fadd fa2(.a(a[7:4]),.b(b[7:4]),.cin(c1),.sum(sum[7:4]),.cout(c2));
    bcd_fadd fa3(.a(a[11:8]),.b(b[11:8]),.cin(c2),.sum(sum[11:8]),.cout(c3));
    bcd_fadd fa4(.a(a[15:12]),.b(b[15:12]),.cin(c3),.sum(sum[15:12]),.cout(cout));

endmodule
