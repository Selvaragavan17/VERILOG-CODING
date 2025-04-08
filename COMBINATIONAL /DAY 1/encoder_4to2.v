//Design code
module encoder_4to2(
  input [3:0]in,
  output reg [1:0]out);
  always@(*)begin
    case(in)
      4'b0001:out=2'b00;
      4'b0010:out=2'b01;
      4'b0100:out=2'b10;
      4'b1000:out=2'b11;
      endcase
     end
endmodule


//testbench
module encoder_4to2_tb;
  reg [3:0]in;
  wire [1:0]out;

  encoder_4to2 uut (in,out);

  initial begin
    in=4'b0001;#10;
    in=4'b0010;#10;
    in=4'b0100;#10;
    in=4'b1000;#10;
    $finish;
  end

  initial begin
    $monitor("Time=%0t Input=%b output=%b ", $time,in,out);
  end

  initial begin
    $dumpfile("encoder_4to2.vcd");
    $dumpvars(1, encoder_4to2_tb);
  end
endmodule

 
