//design code
module excess_to_bcd(
  input [3:0]excess,
  output reg [3:0]bcd);
  
  always@(excess)begin
    case(excess)
        4'b0011: bcd = 4'b0000; // 3 -> 0
        4'b0100: bcd = 4'b0001;
        4'b0101: bcd = 4'b0010; 
        4'b0110: bcd = 4'b0011; 
        4'b0111: bcd = 4'b0100; 
        4'b1000: bcd = 4'b0101; 
        4'b1001: bcd = 4'b0110; 
        4'b1010: bcd = 4'b0111; 
        4'b1011: bcd = 4'b1000; 
        4'b1100: bcd = 4'b1001; 
        default: bcd = 4'b0000; // Invalid excess-3 input
    endcase
  end
endmodule

//testbench code
module excess_to_bcd_tb;
  reg [3:0]excess;
  wire [3:0]bcd;
  
  excess_to_bcd uut(.excess(excess),.bcd(bcd));
  
  initial begin
    $monitor("Time=%0t|excess=%b|bcd=%b",$time,excess,bcd);
  end
  
  initial begin
    $dumpfile("excess_to_bcd.vcd");
    $dumpvars(1,excess_to_bcd_tb);
  end
  
  initial begin
    	   excess = 4'b0000;
          #2 excess = 4'b0011;
          #2 excess = 4'b0100;
          #2 excess = 4'b0101;
          #2 excess = 4'b0110;
          #2 excess = 4'b0111;
          #2 excess = 4'b1000;
          #2 excess = 4'b1001;
          #2 excess = 4'b1010;
          #2 excess = 4'b1011;
          #2 excess = 4'b1100;
          #2 excess = 4'b1101;
          #2 excess = 4'b1110;
          #2 excess = 4'b1111;
          #2 excess = 4'b0000;
          #2 excess = 4'b0001;
          #2 excess = 4'b0010;
  end
endmodule
    
    
  
