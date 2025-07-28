//design code
module piso(
    input wire clk,
    input wire rst,         
    input wire load,         
    input wire [3:0] data_in,
    output wire serial_out);
  reg [3:0] shift_reg;
  always @(posedge clk or posedge rst)
    begin
      if (rst)
            shift_reg <= 0;
        else if (load)
            shift_reg <= data_in;         
        else
            shift_reg <= shift_reg << 1;  
    end

  assign serial_out = shift_reg[3];
endmodule


//testbench code
module piso_tb;
    reg clk,rst, load;
  reg [3:0] data_in;
    wire serial_out;

    piso uut (.clk(clk),.rst(rst),.load(load),.data_in(data_in),.serial_out(serial_out));
    
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        load = 0;
        data_in = 4'b1010;
        #10 rst = 0;
        #10 load = 1;       
        #10 load = 0;    
        #100 $finish;
    end
  initial begin
    $dumpfile("piso.vcd");
    $dumpvars(1,piso_tb);
  end
  initial begin
    $monitor("Time=%0t clk=%b rst=%b load=%b data_in=%b serial_out=%b",$time,clk,rst,load,data_in,serial_out);
  end
endmodule
