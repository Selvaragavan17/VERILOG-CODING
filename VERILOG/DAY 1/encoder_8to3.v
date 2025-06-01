//design code
module encoder_8to3(
  input [7:0]in,
  output reg [2:0]out);
  always@(*)begin
    case(in)
      8'b00000001:out=3'b000;
      8'b00000010:out=3'b001;
      8'b00000100:out=3'b010;
      8'b00001000:out=3'b011;
      8'b00010000:out=3'b100;
      8'b00100000:out=3'b101;
      8'b01000000:out=3'b110;
      8'b10000000:out=3'b111;
  // assign y[2]=d[4]|d[5]|d[6]|d[7];
  // assign y[1]=d[2]|d[3]|d[6]|d[7];
  // assign y[0]=d[1]|d[3]|d[5]|d[7];
      
      endcase
     end
endmodule


//testbench
module encoder_8to3_tb;
  reg [7:0]in;
  wire [2:0]out;

  encoder_8to3 uut (in,out);

  initial begin
    in=8'b00000001;#10;
    in=8'b00000010;#10;
    in=8'b00000100;#10;
    in=8'b00001000;#10;
    in=8'b00010000;#10;
    in=8'b00100000;#10;
    in=8'b01000000;#10;
    in=8'b10000000;#10;
    $finish;
  end

  initial begin
    $monitor("Time=%0t Input=%b output=%b ", $time,in,out);
  end

  initial begin
    $dumpfile("encoder_8to3.vcd");
    $dumpvars(1, encoder_8to3_tb);
  end
endmodule
