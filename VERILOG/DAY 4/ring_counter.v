//design code
module ring_counter (
    input clk,
    input reset,
    output reg [3:0]out);
  always @(posedge clk or posedge reset) 
    begin
    if (reset)
      out<=4'b1101;
    else
      out<={out[2:0], out[3]};
  end
endmodule

//tetbench code
module ring_counter_tb;
  reg clk,reset;
  wire [3:0]out;
  ring_counter uut(.clk(clk),.reset(reset),.out(out));
  
  initial begin
    clk = 0;
    forever #5clk = ~clk;
  end
  
  initial begin
    clk = 0;
    reset = 1; #10;
    reset = 0; #10;
    $finish;
  end
  
  initial begin
    $dumpfile("ring_counter.vcd");
    $dumpvars(1,ring_counter_tb);
  end
  
  initial begin
    $monitor("Time = %0t  Reset = %b  Out = %b", $time, reset, out);
  end

endmodule
