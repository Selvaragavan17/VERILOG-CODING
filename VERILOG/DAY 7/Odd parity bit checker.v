//design code
module odd_parity_bit_checker(
  input a,b,c,p,
  output reg out);
  
  always@(*)begin
    assign out=~(a^b^c^p);
  end
endmodule

//testbench code
module odd_parity_bit_checker_tb;
  reg a,b,c,p;
  wire out;
  
  odd_parity_bit_checker uut(a,b,c,p,out);
  
  initial begin
    $dumpfile("odd_parity_bit_checker.vcd");
    $dumpvars(1,odd_parity_bit_checker_tb);
  end
  
  initial begin
    a=0; b=0; c=0; p=0;
	#5a=0; b=0; c=0; p=0;
	#5a=0; b=0; c=1; p=1;
	#5a=0; b=1; c=0; p=1;
	#5a=0; b=1; c=1; p=1;
	#5a=1; b=0; c=0; p=1;
	#5a=1; b=0; c=1; p=0;
	#5a=1; b=1; c=0; p=1;
	#5a=1; b=1; c=1; p=0;
  end
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|C=%b|P=%b|OUT=%b",$time,a,b,c,p,out);
  end
  
endmodule
