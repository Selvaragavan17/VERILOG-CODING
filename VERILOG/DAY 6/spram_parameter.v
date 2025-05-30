//design code
module spram #(parameter DATA_WIDTH=8,
               parameter ADDR_WIDTH=6)
  (input clk,
   input rst,
   input write_en,
   input read_en,
   input[ADDR_WIDTH-1:0]addr,
   input[DATA_WIDTH-1:0]write_data,
   output reg [DATA_WIDTH-1:0] read_data);
  
  reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
  
  always@(posedge clk)begin
    if(rst)begin
      read_data<=0;
    end
    else begin
      if(write_en) begin
        mem[addr]<=write_data;
      end
      if(read_en) begin
          read_data<=mem[addr];
        end 
    end
  end
endmodule



//testbench code
module spram_tb;
  parameter DATA_WIDTH=8;
  parameter ADDR_WIDTH=6;
  
  reg clk;
  reg rst;
  reg write_en;
  reg read_en;
  reg [ADDR_WIDTH-1:0]addr;
  reg [DATA_WIDTH-1:0]write_data;
  wire [DATA_WIDTH-1:0]read_data;
   
  spram #(DATA_WIDTH,ADDR_WIDTH) uut(clk,rst,write_en,read_en,addr,write_data,read_data);
  
  initial begin
    clk=0;
    forever#5 clk=~clk;
  end
  
  initial begin
    $dumpfile("spram_tb.v");
    $dumpvars(0,spram_tb);
  end
  
  initial begin
    $monitor("$Time=%0t | clk=%b |rst=%b |write_en=%b |read_en=%b |addr=%d |write_data=%d |read_data=%d",$time,clk,rst,write_en,read_en,addr,write_data,read_data);
  end
  
  initial begin
    clk = 0;
    rst = 1;
    write_en = 0;
    read_en = 0;
    addr = 0;
    write_data = 0;

    #10 rst = 0;  

    #10 addr = 6'd2;
         write_data = 155;
         write_en = 1;
         read_en = 0;

    #10 addr = 6'd5;
         write_data = 60;

    #10 write_en = 0;

    #10 addr = 6'd2;
         read_en = 1;

    #10 addr = 6'd5;

    #10 read_en = 0;

    #10 $finish;
  end
endmodule

