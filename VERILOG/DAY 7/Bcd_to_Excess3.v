//design code
module bcd_to_excess(
  input [3:0]bcd,
  output reg [3:0]excess);
  
  always@(*)begin
    case(bcd)
        4'b0000: excess = 4'b0011; // 0 + 3 = 3
        4'b0001: excess = 4'b0100; // 1 + 3 = 4
        4'b0010: excess = 4'b0101; 
        4'b0011: excess = 4'b0110; 
        4'b0100: excess = 4'b0111; 
        4'b0101: excess = 4'b1000; 
        4'b0110: excess = 4'b1001; 
        4'b0111: excess = 4'b1010; 
        4'b1000: excess = 4'b1011; 
        4'b1001: excess = 4'b1100; 
        default: excess = 4'b0000; // For invalid BCD inputs (1010 to 1111)
    endcase
  end
endmodule

//testbench code
module bcd_to_excess_tb;
  reg [3:0]bcd;
  wire [3:0]excess;
  
  bcd_to_excess uut(.bcd(bcd),.excess(excess));
  
  initial begin
    $dumpfile("bcd_to_excess.vcd");
    $dumpvars(1,bcd_to_excess_tb);
  end
  
  initial begin
    bcd=4'b0000;
    #5 bcd=4'b0001;
    #5 bcd=4'b0010;
    #5 bcd=4'b0011;
    #5 bcd=4'b0100;
    #5 bcd=4'b0101;
    #5 bcd=4'b0110;
    #5 bcd=4'b0111;
    #5 bcd=4'b1000;
	#5 bcd=4'b1001;
	#5 bcd=4'b1010;
	#5 bcd=4'b1011;
	#5 bcd=4'b1100;
	#5 bcd=4'b1101;
	#5 bcd=4'b1110;
	#5 bcd=4'b1111;
  end
  
  initial begin
    $monitor("TIme=%0t|bcd=%b|excess3=%b",$time,bcd,excess);
  end
endmodule
