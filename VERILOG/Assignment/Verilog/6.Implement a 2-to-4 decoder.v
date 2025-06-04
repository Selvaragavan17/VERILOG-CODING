//design code
module decoder2to4(
  input [1:0]in,
  output reg[3:0]out);
  always@(*)begin
    case(in)
      2'b00:out=4'b0001;
      2'b01:out=4'b0010;
      2'b10:out=4'b0100;
      2'b11:out=4'b1000;
    endcase
  end
endmodule

//teestbench code
module decoder2to4_tb;
  reg [1:0] in;
  wire [3:0] out;

  decoder2to4 uut (.in(in),.out(out));

  initial begin
    $monitor("IN=%b|OUT=%b",in,out);
    in = 2'b00; #10;
    in = 2'b01; #10;
    in = 2'b10; #10;
    in = 2'b11; #10;
    $finish;
  end
  
  initial begin
    $dumpfile("decoder2to4.vcd");
    $dumpvars(1,decoder2to4_tb);
  end

endmodule
