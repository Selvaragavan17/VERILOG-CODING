//Design code
module tlatch(
  input en,t,
   output reg q);
  always @ (*) begin
    if (en) begin
      if (t)
        q = ~q;         // Toggle
      else
        q = q;          // Hold state
    end
  end
endmodule

//Testbench code
module tlatch_tb;
reg en,t;                                                                     
wire q;                                                                         
  tlatch uut(.en(en),.t(t),.q(q));                                              
  initial begin                                                               
    en=0;#5;                                                                    
    t=1;#5;                                                                   
    en=1;#5;                                                                    
    t=0;#5;                                                                    
    t=0;#5;                                                                    
    en=1;#5;
    t=1;#5;
    t=0;#5;
  end                                                                          
  initial begin                                                               
    $monitor("time=%0t EN=%b T=%b Q=%b",$time,en,t,q);                          
  end                                                                          
  initial begin                                                               
    $dumpfile("tlatch.vcd");                                                   
    $dumpvars(1,tlatch_tb);                                                   
  end                                                                         
endmodule 
