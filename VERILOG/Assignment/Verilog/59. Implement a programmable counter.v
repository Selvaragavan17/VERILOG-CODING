//design code
module pro_count(
  input clk,rst,load,
  input [7:0]load_value,
  input up_down,
  output reg [7:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      count<=0;
    else if(load)
      count<=load_value;
    else begin
      if(up_down)
        count<=count+1;
      else
        count<=count-1;
    end
  end
endmodule

//testbench code
module pro_count_tb;
  reg clk,rst,load;
  reg [7:0]load_value;
  reg up_down;
  wire [7:0]count;
  
  pro_count uut(clk,rst,load,load_value,up_down,count);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("pro_count.vcd");
    $dumpvars(1,pro_count_tb);
  end
  
  initial begin
    $monitor("time=%0t|clk=%b|rst=%b|load=%b|load_value=%d|up_down=%b|count=%d",$time,clk,rst,load,load_value,up_down,count);
  end
  
  initial begin
    rst=1;#10;
    rst=0;load=1;load_value=8'b01010101;#10;
    load=0;#10
    up_down=1;#20;
    up_down=0;#20
    
    rst=0;load=1;load_value=8'b11011111;#10;
    load=0;#10
    up_down=0;#20;
    up_down=1;#20 
    up_down=0;#20;
    up_down=1;#20
    $finish;    
  end
endmodule

//output
time=0|clk=0|rst=1|load=x|load_value=  x|up_down=x|count=  0
time=5|clk=1|rst=1|load=x|load_value=  x|up_down=x|count=  0
time=10|clk=0|rst=0|load=1|load_value= 85|up_down=x|count=  0
time=15|clk=1|rst=0|load=1|load_value= 85|up_down=x|count= 85
time=20|clk=0|rst=0|load=0|load_value= 85|up_down=x|count= 85
time=25|clk=1|rst=0|load=0|load_value= 85|up_down=x|count= 84
time=30|clk=0|rst=0|load=0|load_value= 85|up_down=1|count= 84
time=35|clk=1|rst=0|load=0|load_value= 85|up_down=1|count= 85
time=40|clk=0|rst=0|load=0|load_value= 85|up_down=1|count= 85
time=45|clk=1|rst=0|load=0|load_value= 85|up_down=1|count= 86
time=50|clk=0|rst=0|load=0|load_value= 85|up_down=0|count= 86
time=55|clk=1|rst=0|load=0|load_value= 85|up_down=0|count= 85
time=60|clk=0|rst=0|load=0|load_value= 85|up_down=0|count= 85
time=65|clk=1|rst=0|load=0|load_value= 85|up_down=0|count= 84
time=70|clk=0|rst=0|load=1|load_value=223|up_down=0|count= 84
time=75|clk=1|rst=0|load=1|load_value=223|up_down=0|count=223
time=80|clk=0|rst=0|load=0|load_value=223|up_down=0|count=223
time=85|clk=1|rst=0|load=0|load_value=223|up_down=0|count=222
time=90|clk=0|rst=0|load=0|load_value=223|up_down=0|count=222
time=95|clk=1|rst=0|load=0|load_value=223|up_down=0|count=221
time=100|clk=0|rst=0|load=0|load_value=223|up_down=0|count=221
time=105|clk=1|rst=0|load=0|load_value=223|up_down=0|count=220
time=110|clk=0|rst=0|load=0|load_value=223|up_down=1|count=220
time=115|clk=1|rst=0|load=0|load_value=223|up_down=1|count=221
time=120|clk=0|rst=0|load=0|load_value=223|up_down=1|count=221
time=125|clk=1|rst=0|load=0|load_value=223|up_down=1|count=222
time=130|clk=0|rst=0|load=0|load_value=223|up_down=0|count=222
time=135|clk=1|rst=0|load=0|load_value=223|up_down=0|count=221
time=140|clk=0|rst=0|load=0|load_value=223|up_down=0|count=221
time=145|clk=1|rst=0|load=0|load_value=223|up_down=0|count=220
time=150|clk=0|rst=0|load=0|load_value=223|up_down=1|count=220
time=155|clk=1|rst=0|load=0|load_value=223|up_down=1|count=221
time=160|clk=0|rst=0|load=0|load_value=223|up_down=1|count=221
time=165|clk=1|rst=0|load=0|load_value=223|up_down=1|count=222
