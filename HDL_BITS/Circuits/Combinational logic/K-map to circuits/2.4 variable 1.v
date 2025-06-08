module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    assign out=(~a&~d)|(~c&~b)|(c&d&a)|(c&d&b);

endmodule
