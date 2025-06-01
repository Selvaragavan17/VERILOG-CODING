//design code
module comparator_8bit(
  input [7:0]a,
  input [7:0]b,
  output reg equal,
  output reg greater,
  output reg lesser);
  
  always@(*)begin
    if(a==b) begin
      equal=1;
      greater=0;
      lesser=0;
    end
    else if(a>b) begin
      equal=0;
      greater=1;
      lesser=0;
    end
    else begin
      equal=0;
      greater=0;
      lesser=1;      
    end
  end
endmodule

//testbench code
module comparator_8bit_tb;
  reg [7:0]a;
  reg [7:0]b;
  wire equal;
  wire greater;
  wire lesser;
  
  comparator_8bit uut (.a(a),.b(b),.equal(equal),.greater(greater),.lesser(lesser));
  
  initial begin
    $dumpfile("comparator_8bit.vcd");
    $dumpvars(1, comparator_8bit_tb);
  end

  initial begin
    a = 8'd0;    b = 8'd1;    #5;
    a = 8'd200;  b = 8'd100;  #5;
    a = 8'd255;  b = 8'd255;  #5;
    a = 8'd100;  b = 8'd150;  #5;
    a = 8'd75;   b = 8'd75;   #5;
    $finish;
  end

  always @(*) begin
    $monitor("Time=%0t A=%d B=%d Equal=%b Greater=%b Lesser=%b", 
             $time, a, b, equal, greater, lesser);
  end

endmodule

