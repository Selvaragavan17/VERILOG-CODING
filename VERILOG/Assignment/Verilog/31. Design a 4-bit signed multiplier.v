//design code
module signed_multi_4bit (
  input  signed [3:0]a,b,     
    output signed [7:0]product );
  
    assign product = a*b;
endmodule

//testbench code
module signed_multi_4bit_tb;
    reg  signed [3:0] a, b;
    wire signed [7:0] product;

    signed_multi_4bit uut (.a(a),.b(b),.product(product));
  initial begin
    $dumpfile("signed_multi_4bit.vcd");
    $dumpvars(1,signed_multi_4bit_tb);
  end

    initial begin
        $display("Time\t a\t b\t product");
        $monitor("%0t\t%d\t%d\t%d", $time, a, b, product);
        a=4'sd3;b=4'sd2;#10;
        a=-4'sd3;b=4'sd2;#10;
        a=4'sd3;b=-4'sd2;#10;
        a=-4'sd3;b=-4'sd2;#10;
        a=4'sd7;b=4'sd4;#10;
        a=-4'sd8;b=4'sd1;#10;
        a=4'sd5;b=-4'sd2;#10;
        $finish;
    end
endmodule

//output 
Time	 a	 b	 product
0	 3	 2	   6
10	-3	 2	  -6
20	 3	-2	  -6
30	-3	-2	   6
40	 7	 4	  28
50	-8	 1	  -8
60	 5	-2	 -10
