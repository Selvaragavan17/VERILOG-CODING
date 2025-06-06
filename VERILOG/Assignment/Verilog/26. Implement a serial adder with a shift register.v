//design code
module serialadder(
  input clk,rst,load,
  input [3:0]a,b,
  output reg[3:0]sum,
  output reg done);
  
  reg [3:0]reg_a,reg_b;
  reg carry;
  reg [2:0]count;
  reg [1:0]temp_sum;
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      sum<=0;
      done<=0;
      reg_a<=0;
      reg_b<=0;
      carry<=0;
      count<=0;
      
    end
    else if(load)begin
      reg_a<=a;
      reg_b<=b;
      sum<=0;
      done<=0;
      carry<=0;
      count<=0;
    end
    else if(count<4)begin
      temp_sum=reg_a[0]+reg_b[0]+carry;
      sum={temp_sum[0],sum[3:1]};
      carry=temp_sum[1];
      
      reg_a<=reg_a>>1;
      reg_b<=reg_b>>1;
      count<=count+1;
      
      if(count==3)
        done<=1;
    end
  end
endmodule

//testbench code
module serialadder_tb;
  reg clk,rst,load;
  reg [3:0]a,b;
  wire [3:0]sum;
  wire done;
  
  serialadder uut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .a(a),
    .b(b),
    .sum(sum),
    .done(done)
  );
  
  initial begin
    $dumpfile("serialadder.vcd");
    $dumpvars(1,serialadder_tb);
    $monitor("Time=%0t|Load=%b|A=%b|B=%b|Sum=%b|Done=%b",$time,load,a,b,sum,done);
  end
  
  initial begin
    clk=0;
    forever #5clk=~clk;
  end
  
  initial begin

        rst = 1;
        load = 0;
        a = 4'b0000;
        b = 4'b0000;

        #10 rst = 0;

        #5  load = 1;
        a = 4'b0101;  // A = 5
        b = 4'b0011;  // B = 3
        #10 load = 0; 

        #50;

        #10 rst = 1; #10 rst = 0;
        load = 1;
        a = 4'b1111;  // A = 15
        b = 4'b0001;  // B = 1
        #10 load = 0;
        #50;

        $finish;
    end
endmodule
