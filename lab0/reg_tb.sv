module stimulus ();

   logic  clock;
   logic  write;
   logic [4:0] ra1, ra2, wa3;
   logic [31:0] wd3;
   logic [31:0] rd1, rd2;
   
   integer handle3;
   integer desc3;
   
   // Instantiate reg
   regfile rg (clock, write, ra1, ra2, wa3, wd3, rd1, rd2);

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clock = 1'b1;
	forever #5 clock = ~clock;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("reg.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "w: %b ra1: %d ra2: %d wa: %d wv: %d rv1: %d rv2: %d", 
		     write, ra1, ra2, wa3, wd3, rd1, rd2);
     end   
   
   initial 
     begin      
        // Initialize values
        #0  write = 1'b0;
        #0  ra1 = 25;	
        #0  ra2 = 0;
        #0  wa3 = 12; // Write to register 12
        #0  wd3 = 69; // Write 69

        // Write
        #20 write = 1'b1;
        #20 write = 1'b0;

        // Read written register
        #20 ra1 = 12;

        // Write to $0
        #0  wa3 = 0;
        #0  write = 1'b1;
        #20 write = 1'b0;

     end

endmodule // FSM_tb

