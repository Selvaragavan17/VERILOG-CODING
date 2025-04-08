//Design code
module demux_1to4 (
  input in,          
  input [1:0] sel,    
  output reg [3:0] out);
  always @(*) begin
    out = 4'b0000;        
    case (sel)
      2'b00:out[0] = in;
      2'b01:out[1] = in;
      2'b10:out[2] = in;
      2'b11:out[3] = in;
    endcase
  end
endmodule

//testbench
module demux_1to4_tb;
  reg in;
  reg [1:0]sel;
  wire [3:0]out;
  demux_1to4 uut(.in(in),.sel(sel),.out(out));
  initial begin
    in=1'b1;
    sel=2'b00;#5;
    sel=2'b01;#5;
    sel=2'b10;#5;
    sel=2'b11;#5;
    
    in=1'b0;
    sel=2'b00;#5;
    sel=2'b01;#5;
    sel=2'b10;#5;
    sel=2'b11;#5;
  end
  initial begin
    $dumpfile("demux_1to4.vcd");
    $dumpvars(1,demux_1to4_tb);
  end
  initial begin
    $monitor("Time=%0t input=%b selection=%b output=%b",$time,in,sel,out);
  end
endmodule
