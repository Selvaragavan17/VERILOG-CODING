//design code
module dpram #(parameter DATA_WIDTH=8,
              parameter ADDR_WIDTH=6)
  (input clk,
   input read_ena,
   input read_enb,
   input write_ena,
   input write_enb,
   input [DATA_WIDTH-1:0]write_a,
   input [DATA_WIDTH-1:0]write_b,
   input [ADDR_WIDTH-1:0]addr_a,
   input [ADDR_WIDTH-1:0]addr_b,
   output reg [DATA_WIDTH-1:0]read_a,
   output reg [DATA_WIDTH-1:0]read_b);
   reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
  
  always@(posedge clk)begin
    if(write_ena)begin
      mem[addr_a]<=write_a;
    end
    if(read_ena)begin
      read_a<=mem[addr_a];
    end
  end
  
   always@(posedge clk)begin
     if(write_enb)begin
       mem[addr_b]<=write_b;
    end
     if(read_enb)begin
       read_b<=mem[addr_b];
    end
  end
endmodule

//testbench code
module dpram_tb;

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 6;

  reg clk;
  reg read_ena, read_enb;
  reg write_ena, write_enb;
  reg [DATA_WIDTH-1:0] write_a, write_b;
  reg [ADDR_WIDTH-1:0] addr_a, addr_b;
  wire [DATA_WIDTH-1:0] read_a, read_b;

  dpram #(DATA_WIDTH, ADDR_WIDTH) uut (
    .clk(clk),
    .read_ena(read_ena),
    .read_enb(read_enb),
    .write_ena(write_ena),
    .write_enb(write_enb),
    .addr_a(addr_a),
    .addr_b(addr_b),
    .write_a(write_a),
    .write_b(write_b),
    .read_a(read_a),
    .read_b(read_b)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end


  initial begin

    read_ena = 0; read_enb = 0;
    write_ena = 0; write_enb = 0;
    addr_a = 0; addr_b = 0;
    write_a = 0; write_b = 0;


    $dumpfile("dpram_tb.vcd");
    $dumpvars(0, dpram_tb);
    $monitor("T=%0t | A: addr=%0d,read_ena=%d,write_ena=%d,write=%d,read=%d | B: addr=%0d,read_ena=%d,write_ena=%d,write=%d,read=%d",
             $time,addr_a,read_ena,write_ena,write_a,read_a,addr_b,read_enb,write_enb,write_b,read_b);

    #5 addr_a = 6'd5; write_a = 8'd98; write_ena = 1;
        addr_b = 6'd10; write_b = 8'd44; write_enb = 1;

    #5 addr_a = 6'd15; write_a = 8'd65;
        addr_b = 6'd10; write_b = 8'd54;

    #5 write_ena = 0; write_enb = 0;
        read_ena = 1; addr_a = 6'd5;
        read_enb = 1; addr_b = 6'd10;

    #5 addr_a = 6'd15;
        addr_b = 6'd5;

    #5 read_ena = 0; read_enb = 0;

    #50 $finish;
  end

endmodule

