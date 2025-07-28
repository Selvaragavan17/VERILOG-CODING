//design code
module mux_8to1(
  input [7:0]in,
  input  [2:0]sel,
  output reg out);
  always@(*)begin
    case(sel)
      3'b000:out=in[0];
      3'b001:out=in[1];
      3'b010:out=in[2];
      3'b011:out=in[3];
      3'b100:out=in[4];
      3'b101:out=in[5];
      3'b110:out=in[6];
      3'b111:out=in[7];
      default:out=1'b0;
      endcase
     end
endmodule


//Testbench
module mux_8to1_tb;
  reg [7:0]in;
  reg [2:0]sel;
  wire out;

  mux_8to1 uut (.in(in),.sel(sel),.out(out));

  initial begin
    in=8'b10101010;#5;
    sel=3'b000;#5;
    sel=3'b001;#5;
    sel=3'b010;#5;
    sel=3'b011;#5;
    sel=3'b100;#5;
    sel=3'b101;#5;
    sel=3'b110;#5;
    sel=3'b111;#5;
    $finish;
  end

  initial begin
    $monitor("Time=%0t Input=%b selection=%b output=%b ",$time,in,sel,out);
  end

  initial begin
    $dumpfile("mux_8to1.vcd");
    $dumpvars(1, mux_8to1_tb);
  end
endmodule
