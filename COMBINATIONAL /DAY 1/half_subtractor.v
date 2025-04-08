//Design code
module half_Subtractor (
    input A,     
    input B,       
    output Diff,   
    output Bor);

  assign Diff  = A^B ;
  assign Bor = (~A) & B ; 

endmodule

//Testbench
module half_Subtractor_tb();
  reg A,B;
  wire Diff,Bor;
  half_Subtractor uut(.A(A),.B(B),.Diff(Diff),.Bor(Bor));
  
  initial begin
    A=0;B=0;#10
    A=0;B=1;#10;
    A=1;B=0;#10;
    A=1;B=1;#10;
  end
  
  initial begin
    $dumpfile("half_Subtractor.vcd");
    $dumpvars(1,half_Subtractor_tb);
  end
  
  always@(*)
    
    $monitor("Time=%0t \t A=%b B=%b Difference=%b Borrow=%b",$time,A,B,Diff,Bor);
  
endmodule
  
