//design code
module demux_1to8(
  input in,
  input [2:0]sel,
  output reg [7:0]out);
always@(*)begin
  out=8'b00000000;
  case(sel)
    3'b000:out[0]=in;
    3'b001:out[1]=in;
    3'b010:out[2]=in;
    3'b011:out[3]=in;
    3'b100:out[4]=in;
    3'b101:out[5]=in;
    3'b110:out[6]=in;
    3'b111:out[7]=in;
  endcase
end 
endmodule

//testbench
// Code your testbench here
// or browse Examples
module demux_1to8_tb;
  reg in;
  reg [2:0]sel;
  wire [7:0]out;
  demux_1to8 uut(.in(in),.sel(sel),.out(out));
  initial begin
    in=1'b1;
    sel=3'b000;#5;
    sel=3'b001;#5;
    sel=3'b010;#5;
    sel=3'b011;#5;
    sel=3'b100;#5;
    sel=3'b101;#5;
    sel=3'b110;#5;
    sel=3'b111;#5;
    

  end
  initial begin
    $dumpfile("demux_1to8.vcd");
    $dumpvars(1,demux_1to8_tb);
  end
  initial begin
    $monitor("Time=%0t input=%b selection=%b output=%b",$time,in,sel,out);
  end
endmodule
