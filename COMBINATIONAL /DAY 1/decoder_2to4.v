//design code
module decoder_2to4(
  input [1:0]in,
  input en,
  output reg[3:0]out);
  always@(*)begin
    if(en)begin
      case(in)
        2'b00:out=4'b0001;
        2'b01:out=4'b0010;
        2'b10:out=4'b0100;
        2'b11:out=4'b1000;
      endcase
    end
        else
          out=4'b0000;
  end
endmodule

//testbench code
module decoder_2to4_tb;
  reg [1:0] in;
  reg en;
  wire [3:0] out;

  decoder_2to4 uut (
    .in(in),
    .en(en),
    .out(out)
  );

  initial begin
    en = 0; in = 2'b00; #10;
    in = 2'b01; #10;
    in = 2'b10; #10;
    in = 2'b11; #10;

    en = 1; in = 2'b00; #10;
    in = 2'b01; #10;
    in = 2'b10; #10;
    in = 2'b11; #10;

    $finish;
  end

  initial begin
    $monitor("Time=%0t EN=%d IN=%b OUT=%b", $time, en, in, out);
  end

  initial begin
    $dumpfile("decoder_2to4.vcd");
    $dumpvars(1, decoder_2to4_tb);
  end
endmodule
  
