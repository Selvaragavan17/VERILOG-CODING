//design code
module alu(
  input [15:0]a,b,
  input [3:0]alu_in,
  output reg [15:0]alu_out);
  
  always@(alu_in)begin
    case(alu_in)
      4'b0000 : alu_out = a+b; 
		4'b0001 : alu_out = a-b; 
		4'b0010 : alu_out = a/b; 
		4'b0011 : alu_out = a*b; 
		4'b0100 : alu_out = a>>1; // right shift 
		4'b0101 : alu_out = a<<1; // left shift
      4'b0110 : alu_out = {a[0],a[7:1]}; //rotate left (Its 8bit rotation)
      4'b0111 : alu_out =  {a[6:0],a[7]}; //rotate right(Its 8bit rotation)
		4'b1001 : alu_out = a&b;
		4'b1010 : alu_out = a|b; 
		4'b1011 : alu_out = a^b;  
		4'b1100 : alu_out = ~(a^b); 
		4'b1101 : alu_out = ~(a&b);
		4'b1110 : alu_out = (a<b); 
        4'b1111 : alu_out = (a>b);
    endcase
  end
endmodule

//testbench code
module alu_tb;
  reg [15:0] a, b;
  reg [3:0] alu_in;
  wire [15:0] alu_out;
  alu uut (
    .a(a),
    .b(b),
    .alu_in(alu_in),
    .alu_out(alu_out));
  
  initial  begin
    $dumpfile("alu.vcd");
    $dumpvars(1,alu_tb);
  end

  initial begin
    $display("Time|ALU_IN|  A  |  B  |ALU_OUT");
    $monitor("%4t|%b|%d|%d|%d|", $time, alu_in, a, b, alu_out);

    a = 16'd25; b = 16'd10;

    alu_in = 4'b0000; #10; 
    alu_in = 4'b0001; #10; 
    alu_in = 4'b0010; #10; 
    alu_in = 4'b0011; #10; 
    alu_in = 4'b0100; #10; 
    alu_in = 4'b0101; #10; 
    alu_in = 4'b0110; #10; 
    alu_in = 4'b0111; #10; 
    alu_in = 4'b1001; #10;
    alu_in = 4'b1010; #10; 
    alu_in = 4'b1011; #10;
    alu_in = 4'b1100; #10; 
    alu_in = 4'b1101; #10; 
    alu_in = 4'b1110; #10; 
    alu_in = 4'b1111; #10; 

    $finish;
  end

endmodule
