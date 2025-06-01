//design code
module even_parity_bit_generator(
  input a,b,c,
  output reg epbg);
  
  always@(*)begin
    assign epbg=(a^b^c);
  end
endmodule

//testbench codee
module even_parity_bit_generator_tb;
  reg a,b,c;
  wire epbg;
  
  even_parity_bit_generator uut(a,b,c,epbg);
  
  initial begin
    $dumpfile("even_parity_bit_generator.vcd");
    $dumpvars(1,even_parity_bit_generator_tb);
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
    $monitor("Time=%0t|A=%b|B=%b|C=%b|EPBG=%b",$time,a,b,c,epbg);
  end
  
endmodule
