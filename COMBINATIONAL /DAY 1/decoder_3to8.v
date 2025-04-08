// Design Code 
module decoder_3to8(
  input A0,A1,A2,
  input EN,
  output reg D0,D1,D2,D3,D4,D5,D6,D7);
  always@(*)begin
    if(EN==1'b0)
       {D0,D1,D2,D3,D4,D5,D6,D7}=8'b00000000;
     else begin
       case({A0,A1,A2})
         3'b000:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b10000000;
         3'b001:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b01000000;
         3'b010:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b00100000;
         3'b011:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b00010000;
         3'b100:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b00001000;
         3'b101:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b00000100;
         3'b110:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b00000010;
         3'b111:{D0,D1,D2,D3,D4,D5,D6,D7}=8'b00000001;

      endcase
     end
  end
endmodule

//testbench code
module decoder_3to8_tb;
  reg A0,A1,A2;
  reg EN;
  wire D0,D1,D2,D3,D4,D5,D6,D7;

  decoder_3to8 uut (A0,A1,A2,en,D0,D1,D2,D3,D4,D5,D6,D7
  );

  initial begin
    A0 = 0; A1 = 0; A2 = 0; EN = 0;#5;
    A0 = 0; A1 = 0; A2 = 1; EN = 0;#5;
    A0 = 0; A1 = 1; A2 = 0; EN = 0;#5;
    A0 = 0; A1 = 1; A2 = 1; EN = 0;#5;
    A0 = 1; A1 = 0; A2 = 0; EN = 0;#5;
    A0 = 1; A1 = 0; A2 = 1; EN = 0;#5;
    A0 = 1; A1 = 1; A2 = 0; EN = 0;#5;
    A0 = 1; A1 = 1; A2 = 1; EN = 0;#5;
    
    A0 = 0; A1 = 0; A2 = 0; EN = 1;#5;
    A0 = 0; A1 = 0; A2 = 1; EN = 1;#5;
    A0 = 0; A1 = 1; A2 = 0; EN = 1;#5;
    A0 = 0; A1 = 1; A2 = 1; EN = 1;#5;
    A0 = 1; A1 = 0; A2 = 0; EN = 1;#5;
    A0 = 1; A1 = 0; A2 = 1; EN = 1;#5;
    A0 = 1; A1 = 1; A2 = 0; EN = 1;#5;
    A0 = 1; A1 = 1; A2 = 1; EN = 1;#5;    

    $finish;
  end

  initial begin
    $monitor("Time=%0t A0=%d A1=%b A2=%b EN=%d D0=%b D1=%b D2=%d D3=%b D4=%b D5=%b D6=%d D7=%b ", $time,A0,A1,A2,EN,D0,D1,D2,D3,D4,D5,D6,D7);
  end

  initial begin
    $dumpfile("decoder_3to8.vcd");
    $dumpvars(1, decoder_3to8_tb);
  end
endmodule

 
