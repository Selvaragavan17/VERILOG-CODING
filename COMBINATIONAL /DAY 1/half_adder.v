//Design code
module half_adder (
    input A,     
    input B,       
    output Sum,   
    output Carry );

    assign Sum  = A ^ B ;
    assign Carry = (A & B); 

endmodule

//testbench code
module half_adder_tb();
  reg A,B;
  wire Sum,Carry;
  half_adder uut(.A(A),.B(B),.Sum(Sum),.Carry(Carry));
  
  initial begin
    A=0;B=0;
    #10;A=0;B=1;
    #10;A=1;B=0;
    #10;A=1;B=1;  
  end
  
  initial begin
    $dumpfile("half_adder.vcd");
    $dumpvars(1,half_adder_tb);
  end
  
  always@(*)
    
    $monitor("Time=%0t \t A=%b B=%b Sum=%b Carry=%b",$time,A,B,Sum,Carry);
  
endmodule
  
  
