//design code
module priority_encoder(
  input [7:0] d,
  output reg [2:0]y
);
  
  always@(d)
    begin
      casex(d)
        8'b1xxxxxxx:y=3'b111;
        8'b01xxxxxx:y=3'b110;
        8'b001xxxxx:y=3'b101;
        8'b0001xxxx:y=3'b100;
        8'b00001xxx:y=3'b011;
        8'b000001xx:y=3'b010;
        8'b0000001x:y=3'b001;
        8'b00000001:y=3'b000;
       default:$display("Invalid Data");
        
      endcase
    end
endmodule

//testbench code
module priority_encoder_tb;
  reg [7:0] d;
  wire [2:0] y;

  priority_encoder uut (
    .d(d),
    .y(y)
  );

  initial begin
    $dumpfile("priority_encoder_tb.vcd");
    $dumpvars(0, priority_encoder_tb);
    
    d = 8'b00000001; #10;
    d = 8'b00000010; #10;
    d = 8'b00000100; #10;
    d = 8'b00001000; #10;
    d = 8'b00010000; #10;
    d = 8'b00100000; #10;
    d = 8'b01100000; #10;
    d = 8'b10000000; #10;
    d = 8'b10101010; #10;
    d = 8'b00000000; #10; // no '1', default case
    $finish;
  end

  initial begin
    $monitor("Time=%0t | Input=%b | Output=%b", $time, d, y);
  end
endmodule
