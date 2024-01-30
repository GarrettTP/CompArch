module stimulus ();

  logic  clock;
  logic  write;
  logic [4:0] ra1, ra2, wa3;
  logic [31:0] wd3;
  logic [31:0] rd1, rd2;

  logic reset;
  logic [31:0] vectornum, errors;
  logic [123:0] testvectors[1000:0];
  logic [31:0] rd1_exp, rd2_exp;

  // 32 bits: wd3, rd1, rd2
  // 8 bits:  ra1, ra2, wa3
  // 4 bits:  write
  // Total: 124 bits
   
  integer handle3;
  integer desc3;
   
  // Instantiate reg
  regfile rg (clock, write, ra1, ra2, wa3, wd3, rd1, rd2);

  // Setup the clock to toggle every 5 time units 
  initial begin	
	  clock = 1'b1;
	  forever #5 clock = ~clock;
  end

  // Read test vectors
  initial begin
    $readmemh("reg.tv", testvectors);
    vectornum = 0;
    errors = 0;
    reset = 1;
    #6 reset = 0;
  end

  // Apply test vectors on rising edge of clock
  always @(posedge clock) begin
    #1;
    write = testvectors[vectornum][0:0];
    ra1 = testvectors[vectornum][8:4];
    ra2 = testvectors[vectornum][16:12];
    wa3 = testvectors[vectornum][24:20];
    wd3 = testvectors[vectornum][59:28];
    rd1_exp = testvectors[vectornum][91:60];
    rd2_exp = testvectors[vectornum][123:92];
    // $display("Read: %b", testvectors[vectornum]);
  end

  // Self-checking/errors
  always @(negedge clock) begin
    if (~reset) begin
      vectornum = vectornum + 1;
      if (rd1 !== rd1_exp | rd2 !== rd2_exp) begin
        $display("Error: line = %d", vectornum);
        $display("Outputs: %d %d Expected: %d %d", rd1, rd2, rd1_exp, rd2_exp);
        errors = errors + 1;
      end
      if (testvectors[vectornum] === 'bx) begin
        $display("%d tests completed with %d errors", vectornum, errors);
        $stop;
      end
    end
  end

endmodule // FSM_tb

