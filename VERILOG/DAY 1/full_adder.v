//design code
module full_adder (
    input A,     
    input B,     
    input Cin,   
    output Sum,   
    output Cout );

    assign Sum  = A ^ B ^ Cin;               
    assign Cout = (A & B) | (B & Cin) | (A & Cin); 

endmodule

// testbench here
module full_adder_tb();
  reg A,B,Cin;
  wire Sum,Cout;
  full_adder uut(.A(A),.B(B),.Cin(Cin),.Sum(Sum),.Cout(Cout));
  
  initial begin
    A=0;B=0;Cin=0;
    #10;A=0;B=0;Cin=1;
    #10;A=0;B=1;Cin=0;
    #10;A=0;B=1;Cin=1;
    #10;A=1;B=0;Cin=0;
    #10;A=1;B=0;Cin=1;
    #10;A=1;B=1;Cin=0;
    #10;A=1;B=1;Cin=1; 
  end
  
  initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(1,full_adder_tb);
  end
  
  always@(*)
    
    $monitor("Time=%0t \t A=%b B=%b Cin=%b Sum=%b Cout=%b",$time,A,B,Cin,Sum,Cout);
  
endmodule
