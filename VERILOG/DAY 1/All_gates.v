//Design Code
module all_gates(
  input a,b,
  output reg and_gate,or_gate,nand_gate,nor_gate,xor_gate,xnor_gate,not_gate); 
  
  assign and_gate = a&b;
  assign or_gate = a|b;
  assign nand_gate = ~(a&b);
  assign nor_gate = ~(a|b);
  assign xor_gate = (a^b);
  assign xnor_gate = ~(a^b);
  assign not_gate = ~a;
  
endmodule

// Code your testbench here
module all_gates_tb();
  reg a,b;
  wire and_gate,or_gate,nand_gate,nor_gate,xor_gate,xnor_gate,not_gate;
  
  all_gates uut(a,b,and_gate,or_gate,nand_gate,nor_gate,xor_gate,xnor_gate,not_gate);
  
  initial begin
    a=0;b=0;
    #10;a=0;b=1;
    #10;a=1;b=0;
    #10;a=1;b=1;
    #10;
  end
  
  initial begin
    $dumpfile("all_gates.vcd");
    $dumpvars(1,all_gates_tb);
  end
  
  always@(*)
    
    $monitor("Time=%0t \t A=%b B=%b AND=%b OR=%b NAND=%b NOR=%b XOR=%b XNOR=%b NOT=%b",$time,a,b,and_gate,or_gate,nand_gate,nor_gate,xor_gate,xnor_gate,not_gate);
  
  
endmodule
  
  
