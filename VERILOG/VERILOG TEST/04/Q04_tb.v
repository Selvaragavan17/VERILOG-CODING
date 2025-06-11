//testbench code
module logic_expression_tb;

  reg A, B, C, D, E;
  wire Y;

  logic_expression uut (.A(A), .B(B), .C(C), .D(D), .E(E), .Y(Y));

  initial begin
    $dumpfile("logic_expression.vcd");
    $dumpvars(0, logic_expression_tb);
  end

  // Input stimulus
  initial begin
    A=0; B=0; C=0; D=0; E=0;
    #10 A=1;
    #10 B=1;
    #10 C=1;
    #10 D=1;
    #10 E=1;
    #10 A=0; B=1; C=0; D=1; E=0;
    #10 A=1; B=0; C=1; D=0; E=1;
    #10 $finish;
  end

  // Monitor output after 50ns
  initial begin
    #50;
    $monitor("Time=%0t | A=%b B=%b C=%b D=%b E=%b | Y=%b", $time, A, B, C, D, E, Y);
  end

endmodule


//output
Time=50000 | A=1 B=1 C=1 D=1 E=1 | Y=1
Time=51000 | A=1 B=1 C=1 D=1 E=1 | Y=0
Time=57000 | A=1 B=1 C=1 D=1 E=1 | Y=1
Time=60000 | A=0 B=1 C=0 D=1 E=0 | Y=1
Time=67000 | A=0 B=1 C=0 D=1 E=0 | Y=0
Time=70000 | A=1 B=0 C=1 D=0 E=1 | Y=0
