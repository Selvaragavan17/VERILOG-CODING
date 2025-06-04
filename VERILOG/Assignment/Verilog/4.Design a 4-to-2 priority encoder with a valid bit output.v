//design codee
module pri_en(
  input [3:0]in,
  output reg[1:0]out,
  output reg valid);
  always@(*)begin
    case(in)
      4'b0001:begin
        out=2'b00;
        valid=1'b1;
      end
       4'b0010:begin
        out=2'b01;
        valid=1'b1;
      end
       4'b0100:begin
        out=2'b10;
        valid=1'b1;
      end
       4'b1000:begin
        out=2'b11;
        valid=1'b1;
      end
      default:begin
        out=2'bxx;
        valid=1'b0;
      end
    endcase
  end
endmodule

//testbench code
module pri_en_tb;
  reg [3:0]in;
  wire [1:0]out;
  wire valid;
  
  pri_en uut(in,out,valid);
  
  initial begin
    $dumpfile("pri_en.vcd");
    $dumpvars(1,pri_en_tb);
  end
  
  initial begin
    $monitor("Time=%0t|IN=%b|OUT=%b|valid=%b",$time,in,out,valid);
  end
  
  initial begin
    in=4'b0010;#10;
    in=4'b1110;#10;
    in=4'b0101;#10;
    in=4'b0001;#10;
    in=4'b1000;#10;
    in=4'b0100;#10;
    in=4'b0001;#10;
  end
endmodule
