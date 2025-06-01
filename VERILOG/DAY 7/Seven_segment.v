//design code
module seven_segment(
  input [3:0]bcd,
  output reg [6:0]seg);
  
  always@(bcd)begin
    case(bcd)
        4'd0: seg = 7'b1111110; 
        4'd1: seg = 7'b0110000; 
        4'd2: seg = 7'b1101101; 
        4'd3: seg = 7'b1111001; 
        4'd4: seg = 7'b0110011; 
        4'd5: seg = 7'b1011011; 
        4'd6: seg = 7'b1011111; 
        4'd7: seg = 7'b1110000; 
        4'd8: seg = 7'b1111111; 
        4'd9: seg = 7'b1111011;  
        default: seg = 7'b0000001; // Display 'dash' 
    endcase
  end
endmodule

//testbench code
module seven_segment_tb;
  reg [3:0]bcd;
  wire [6:0]seg;
  
  seven_segment uut(.bcd(bcd),.seg(seg));
  
  initial  begin
    bcd = 4'd0; #10;
    bcd = 4'd1; #10;
    bcd = 4'd2; #10;
    bcd = 4'd3; #10;
    bcd = 4'd4; #10;
    bcd = 4'd5; #10;
    bcd = 4'd6; #10;
    bcd = 4'd7; #10;
    bcd = 4'd8; #10;
    bcd = 4'd9; #10;

    // Optional: test invalid input
    bcd = 4'd10; #10;
    bcd = 4'd15; #10;
  end
  
  initial begin
    $display("Time\tBCD\tSegment Output");
    $monitor("%0t\t%0d\t%b", $time, bcd, seg);
  end
  
  initial begin
    $dumpfile("seven_segment.vcd");
    $dumpvars(1,seven_segment_tb);
  end
endmodule
