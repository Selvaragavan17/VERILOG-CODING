//design code
module dff(
  input clk,reset,d,
  output reg q);
  
  always@(posedge clk or posedge reset)begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule

//testbench code
module dff_tb;
    reg clk;
    reg reset;
    reg d;
    wire q;

    dff uut(.clk(clk),.reset(reset),.d(d),.q(q));
  initial begin
    clk=0;
    forever #5 clk=~clk;
    $dumpfile("dff.vcd");
    $dumpvars(1,dff_tb);
  end



    initial begin
        reset = 0;
        d = 0;
        $monitor("Time=%0t|reset=%b|d=%b|q=%b",$time,reset,d,q);

        #3  reset = 1;        
        #10 reset = 0; d = 1; 
        #10 d = 0;
        #10 d = 1;
        #10 reset = 1;       
        #5  reset = 0;
        #10 d = 0;
        #10;

        $finish;
    end

endmodule
