//design code
module dlatch_mux(
  input d,en,
  output reg q);
  always@(*)begin
  q = en?d:q;
  end
endmodule

//testbench code
module dlatch_mux_tb;
  reg d,en;
  wire q;
  dlatch_mux uut(.d(d),.en(en),.q(q));
  
  initial begin
    $monitor("Time=%0t|D=%b|En=%b|Q=%b",$time,d,en,q);
  end
  
  initial begin
    $dumpfile("dlatch_mux.vcd");
    $dumpvars(1,dlatch_mux_tb);
  end
  
  initial begin
    en=1;d=0;#10;
     en=0;d=1;#10;
     en=1;d=1;#10;
     en=1;d=0;#10;
     en=1;d=1;#10;
  end
endmodule
