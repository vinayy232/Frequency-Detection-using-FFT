`timescale 100ns/1ps //TIme frame 100ns with 1ps resolution
module fft_top_tb;
 reg CLOCK_50;
 reg [0:0] KEY;
 wire [7:0] LEDR;
 //wire [6:0] HEX0;
//wire [6:0] HEX1;
// wire [7:0] LEDG;
//fft_top_ent i1(CLOCK_50,KEY,LEDR, HEX0, HEX1);
fft_top_ent i1(CLOCK_50,KEY,LEDR);
 initial begin
		$dumpvars();
		//key pressing effect is mapped below
		CLOCK_50=0; KEY[0]=0 ;
		
//		@(posedge CLOCK_50);
//		@(negedge CLOCK_50) KEY[0]=0;
//		@(negedge CLOCK_50);
//		@(negedge CLOCK_50)
//		@(negedge CLOCK_50) KEY[0]=1;
//		#600;
//		@(posedge CLOCK_50);
//		@(negedge CLOCK_50); KEY[0]=0;
//		@(negedge CLOCK_50);
//		@(negedge CLOCK_50);
//		@(negedge CLOCK_50) KEY[0]=0;
		#10000;
		
		$finish;
end
	always #10 CLOCK_50=~CLOCK_50; //always every 10 ps clk_50 is getting toggled
endmodule