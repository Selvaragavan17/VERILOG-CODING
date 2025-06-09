//design code
module jk_ff (
    input clk,
    input reset,     
    input j,
    input k,
    output reg q);

always @(posedge clk) begin
    if (reset)
        q<=1'b0;                      
    else begin
        case ({j, k})
            2'b00:q<=q;            
            2'b01:q<=1'b0;          
            2'b10:q<=1'b1;          
            2'b11:q<=~q;            
        endcase
    end
end

endmodule

//testbench code
module jk_ff_tb;
    reg clk;
    reg reset;
    reg j, k;
    wire q;

    jk_ff uut (.clk(clk),.reset(reset),.j(j),.k(k),.q(q));
  
  initial begin
    $dumpfile("jk_ff.vcd");
    $dumpvars(1,jk_ff_tb);
  end

    always #5 clk = ~clk; 

    initial begin
        clk = 0;
        reset = 0;
        j = 0;
        k = 0;
        $monitor("Time=%0t|clk=%b|reset=%b|j=%b|k=%b|q=%b",$time,clk,reset,j, k,q);

        #2 reset = 1;
        #10 reset = 0;
        #10 j = 0; k = 0; 
        #10 j = 0; k = 1;
        #10 j = 1; k = 0;
        #10 j = 1; k = 1;
        #10 j = 1; k = 1;
        #10 j = 0; k = 0;
        #10 $finish;
    end
endmodule

//output
Time=0|clk=0|reset=0|j=0|k=0|q=x
Time=2|clk=0|reset=1|j=0|k=0|q=x
Time=5|clk=1|reset=1|j=0|k=0|q=0
Time=10|clk=0|reset=1|j=0|k=0|q=0
Time=12|clk=0|reset=0|j=0|k=0|q=0
Time=15|clk=1|reset=0|j=0|k=0|q=0
Time=20|clk=0|reset=0|j=0|k=0|q=0
Time=25|clk=1|reset=0|j=0|k=0|q=0
Time=30|clk=0|reset=0|j=0|k=0|q=0
Time=32|clk=0|reset=0|j=0|k=1|q=0
Time=35|clk=1|reset=0|j=0|k=1|q=0
Time=40|clk=0|reset=0|j=0|k=1|q=0
Time=42|clk=0|reset=0|j=1|k=0|q=0
Time=45|clk=1|reset=0|j=1|k=0|q=1
Time=50|clk=0|reset=0|j=1|k=0|q=1
Time=52|clk=0|reset=0|j=1|k=1|q=1
Time=55|clk=1|reset=0|j=1|k=1|q=0
Time=60|clk=0|reset=0|j=1|k=1|q=0
Time=65|clk=1|reset=0|j=1|k=1|q=1
Time=70|clk=0|reset=0|j=1|k=1|q=1
Time=72|clk=0|reset=0|j=0|k=0|q=1
Time=75|clk=1|reset=0|j=0|k=0|q=1
Time=80|clk=0|reset=0|j=0|k=0|q=1
