//design codee
module comp_4b(
  input [3:0]a,b,
  output reg greater,
  output reg lesser,
  output reg equal);
  
  always@(*)begin
    if(a==b)begin
      greater=0;
      lesser=0;
      equal=1;
    end
    else if(a<b)begin
      greater=0;
      lesser=1;
      equal=0;
    end
    else if(a>b)begin
      greater=1;
      lesser=0;
      equal=0;
    end
  end
endmodule

module comp_8b(
  input [7:0]a,b,
  output reg greater,lesser,equal);
  wire gt_hi,ls_hi,eq_hi;
  wire gt_lo,ls_lo,eq_lo;
  
  comp_4b high(.a(a[7:4]),.b(b[7:4]),.greater(gt_hi),.lesser(ls_hi),.equal(eq_hi));
  comp_4b low(.a(a[3:0]),.b(b[3:0]),.greater(gt_lo),.lesser(ls_lo),.equal(eq_lo));
  
  always@(*)begin
    if(gt_hi)begin
      greater=1;
      lesser=0;
      equal=0;
    end
    else if(ls_hi)begin
      greater=0;
      lesser=1;
      equal=0;
    end
    else begin
      if(gt_lo)begin
        greater=1;
        lesser=0;
        equal=0;
      end
      else if(ls_lo)begin
        greater=0;
        lesser=1;
        equal=0;
      end
      else if(eq_lo)begin
        greater=0;
        lesser=0;
        equal=1;
      end
    end
  end
endmodule

//testbench code
module comp_8b_tb;
  reg [7:0] a, b;
  wire greater, lesser, equal;

  comp_8b uut (.a(a),.b(b),.greater(greater),.lesser(lesser),.equal(equal));

  initial begin
    $dumpfile("comp_8b.vcd");
    $dumpvars(1, comp_8b_tb);
    $monitor("Time=%0t|a=%b|b=%b|greater=%b|lesser=%b| equal=%b",$time,a,b,greater,lesser,equal);

    a = 8'b00010010; b = 8'b00010010; #10; 
    a = 8'b10100000; b = 8'b10010000; #10; 
    a = 8'b01101100; b = 8'b10000000; #10; 
    a = 8'b11000000; b = 8'b11000001; #10; 
    a = 8'b11000010; b = 8'b11000001; #10; 
    a = 8'b11111111; b = 8'b00000000; #10; 
    a = 8'b00000000; b = 8'b11111111; #10; 
    a = 8'b10000000; b = 8'b10000000; #10; 

    $finish;
  end
endmodule
