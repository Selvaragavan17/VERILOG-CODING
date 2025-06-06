//design code
module full_adder_1bit (
    input a, b, cin,
    output sum, cout);
  
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module full_adder_4bit (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout);
  
    wire c1, c2, c3;

    full_adder_1bit FA0 (a[0],b[0],cin,sum[0],c1);
    full_adder_1bit FA1 (a[1],b[1],c1,sum[1],c2);
    full_adder_1bit FA2 (a[2],b[2],c2,sum[2],c3);
    full_adder_1bit FA3 (a[3],b[3],c3,sum[3],cout);
endmodule

//testbench code
module full_adder_4bit_tb;
    reg [3:0]a, b;
    reg cin;
    wire [3:0]sum;
    wire cout;

    full_adder_4bit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));

    initial begin
      $dumpfile("full_adder_4bit.vcd");
      $dumpvars(1,full_adder_4bit_tb);
      $monitor("Time=%4t|A=%b|B=%b|CIN=%b|SUM=%b|COUT=%b",$time,a,b,cin,sum,cout);
        
        a = 4'b0000; b = 4'b0000;cin=0; #10;
        a = 4'b0001; b = 4'b0010;cin=0; #10;
        a = 4'b0101; b = 4'b0011;cin=0; #10;
        a = 4'b1111; b = 4'b0001;cin=0; #10;
        a = 4'b1111; b = 4'b1111;cin=1; #10;

        $finish;
    end
endmodule
