//design code
module pri_en8(
  input [7:0]in,
  output reg[2:0]out);
  always@(*)begin
    casez(in)
      8'bzzzzzzz1:out=3'b000;
      8'bzzzzzz10:out=3'b001;
      8'bzzzzz100:out=3'b010;
      8'bzzzz1000:out=3'b011;
      8'bzzz10000:out=3'b100;
      8'bzz100000:out=3'b101;
      8'bz1000000:out=3'b110;
      8'b10000000:out=3'b111;
      default:out=3'bzzz;
    endcase
  end
endmodule


//testbench code
module pri_en8_tb;
  reg [7:0]in;
  wire [2:0]out;
  
  pri_en8 uut(in,out);
  
  initial begin
    $dumpfile("pri_en8.vcd");
    $dumpvars(1,pri_en8_tb);
  end
  
  initial begin
    $monitor("Time=%0t|IN=%b|OUT=%b",$time,in,out);
  end
  
  initial begin
    in=8'b00100010;#10;
    in=8'b00101000;#10;
    in=8'b00000010;#10;
    in=8'b01001000;#10;
    in=8'b00001000;#10;
    in=8'b00100000;#10;
    in=8'b00010000;#10;
    in=8'b00100000;#10;
    in=8'b00000000;#10;

  end
endmodule
