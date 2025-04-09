//design code
module gray_to_binary (
  input  [3:0] gray,
  output [3:0] bin);
  assign bin[3] = gray[3];                     
  assign bin[2] = gray[2] ^ bin[3];
  assign bin[1] = gray[1] ^ bin[2];
  assign bin[0] = gray[0] ^ bin[1];      
endmodule

//testbench
module gray_to_binary_tb;
  reg [3:0] gray;
  wire [3:0] bin;
  gray_to_binary uut (.gray(gray),.bin(bin));
  initial begin
    $monitor("TIME=%0t GRAY=%b BINARY=%b",$time,gray,bin);
  end

  initial begin
    gray = 4'b0000;#10;
    gray = 4'b0001;#10;
    gray = 4'b0011;#10;
    gray = 4'b0010;#10;
    gray = 4'b0110;#10;
    gray = 4'b0111;#10;
    gray = 4'b0101;#10;
    gray = 4'b0100;#10;
    gray = 4'b1100;#10;
    gray = 4'b1101;#10;
    gray = 4'b1111;#10;
    gray = 4'b1110;#10;
    gray = 4'b1010;#10;
    gray = 4'b1011;#10;
    gray = 4'b1001;#10;
    gray = 4'b1000;#10;
  end
  initial begin
    $dumpfile("gray_to_binary.vcd");
    $dumpvars(1,gray_to_binary_tb);
  end

endmodule
