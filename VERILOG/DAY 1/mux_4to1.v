//design code
module mux_4to1(
  input [3:0]in,
  input  [1:0]sel,
  output reg out);
  always@(*)begin
    case(sel)
      2'b00:out=in[0];
      2'b01:out=in[1];
      2'b10:out=in[2];
      2'b11:out=in[3];
      default:out=1'b0;
      endcase
     end
endmodule

//testbench
module mux_4to1_tb;
  reg [3:0]in;
  reg [1:0]sel;
  wire out;

  mux_4to1 uut (.in(in),.sel(sel),.out(out));

  initial begin
    in=4'b1010;#5;
    sel=2'b00;#5;
    sel=2'b01;#5;
    sel=2'b10;#5;
    sel=2'b11;#5;
    $finish;
  end

  initial begin
    $monitor("Time=%0t Input=%b selection=%b output=%b ",$time,in,sel,out);
  end

  initial begin
    $dumpfile("mux_4to1.vcd");
    $dumpvars(1, mux_4to1_tb);
  end
endmodule
