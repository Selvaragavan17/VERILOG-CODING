//Design code
module full_subtractor (
    input A,     
    input B,     
    input Cin,   
    output Diff,   
    output Cout );

    assign Diff  = A ^ B ^ Cin;               
  assign Cout = (~A & B) | (B & Cin) | (~A & Cin); 

endmodule

//Testbench code
module full_subtractor_tb;
  reg A,B,Cin;
  wire Diff,Cout;
  full_subtractor uut(A,B,Cin,Diff,Cout);
  initial begin
    A=0;B=0;Cin=0;#10;
    A=0;B=0;Cin=1;#10;
    A=0;B=1;Cin=0;#10;
    A=0;B=1;Cin=1;#10;
    A=1;B=0;Cin=0;#10;
    A=1;B=0;Cin=1;#10;
    A=1;B=1;Cin=0;#10;
    A=1;B=1;Cin=1;#10;
    
  end
  initial begin
    $dumpfile("full_subtractor.vcd");
    $dumpvars(1,full_subtractor_tb);
  end
    
  always@(*)
    $monitor("TIme=%0t Input A=%b B=%b Cin=%b Difference=%b Borrow=%b",$time,A,B,Cin,Diff,Cout);
endmodule
