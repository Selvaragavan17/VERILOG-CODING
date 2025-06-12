1 22 333 4444 55555 4444 333 22 1 display this sequence in diamond shape ?
  /////code//////

module diamond_pattern_tb;
  integer i, j, k;
  initial begin
    // Upper half of the diamond (1 to 5)
    for (i = 1; i <= 5; i = i + 1) begin
      
      for (j = 5; j > i; j = j - 1)          // Print spaces
        $write(" ");
     
      for (k = 1; k <= i; k = k + 1)         // Print digits
        $write("%0d", i);
      $display("");  // Newline
    end

    // Lower half of the diamond (4 to 1)
    for (i = 4; i >= 1; i = i - 1) begin
    
      for (j = 5; j > i; j = j - 1)          // Print spaces
        $write(" ");
     
      for (k = 1; k <= i; k = k + 1)      // Print digits
        $write("%0d", i);
      $display("");  // Newline
    end

    $finish;
  end

endmodule

  //output//
    1
   22
  333
 4444
55555
 4444
  333
   22
    1


