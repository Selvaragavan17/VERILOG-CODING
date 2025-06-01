//design code
module odd_parity_bit_generator(
  input a,b,c,
  output reg opg);
  
  always@(*)begin
    assign opg=~(a^b^c);
  end
endmodule

//testbench code
module odd_parity_bit_generator_tb;
  reg a,b,c;
  wire opg;
  
  odd_parity_bit_generator uut(a,b,c,opg);
  
  initial begin
    $dumpfile("odd_parity_bit_generator.vcd");
    $dumpvars(1,odd_parity_bit_generator_tb);
  end
  
  initial begin
    a=0; b=0; c=0;
	#5a=0; b=0; c=0;
	#5a=0; b=0; c=1;
	#5a=0; b=1; c=0;
	#5a=0; b=1; c=1;
	#5a=1; b=0; c=0;
	#5a=1; b=0; c=1;
	#5a=1; b=1; c=0;
	#5a=1; b=1; c=1;
  end
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|C=%b|OPG=%b",$time,a,b,c,opg);
  end
  
endmodule
