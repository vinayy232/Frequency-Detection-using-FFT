module fft_top_ent
(input wire CLOCK_50,
input wire[0:0] KEY,
output wire [7:0] LEDR
//output [6:0] HEX0, HEX1//,
//output wire [7:0] LEDG);
);

wire dut_clk,startoftx,compoftx,reset,top_toggle;
wire [3:0]top_real;
wire [3:0]top_imag;
wire [4:0]outp_bin;
// clk and result mapping is done from GCD wrapper
fft_wrapper  i0(reset,dut_clk,startoftx,compoftx,top_toggle,top_real,top_imag,outp_bin);
assign reset = KEY[0];
//assign LEDR[7:0] = dut_money[7:0]; // result is from LED 7 to LED1
assign LEDR[0] = dut_clk;
//assign LEDR[1] = top_toggle;
assign LEDR[1] = startoftx;
assign LEDR[2] = compoftx;
assign LEDR[7:3] = outp_bin;
//assign LEDR[7:4] = top_imag;
//assign LEDR[5] = top_real[1];
//assign LEDR[6] = top_real[2];
//assign LEDR[7] = top_real[3];
//localparam log2_slowdown_factor = 25;  // enable for FPGA
localparam log2_slowdown_factor = 1; //enable for modelsim
reg[log2_slowdown_factor - 1 : 0] k_bit_counter = 0;
assign dut_clk = k_bit_counter[log2_slowdown_factor-1];//dut_clk is taking change of MSB

always @(posedge CLOCK_50) begin
	k_bit_counter = k_bit_counter + 1;
	end
	
//function [6:0] fn_sevenseg_driver (input [3:0] in1);
//			reg [6:0] result;
//			begin
//			case(in1)
//				4'b0000: result=7'b1000000; //0
//				4'b0001: result=7'b1111001; //1
//				 
//				4'b0010: result=7'b0100100; //2
//				4'b0011: result=7'b0110000; //3
//				 
//				4'b0100: result=7'b0011001; //4
//				4'b0101: result=7'b0010010; //5
//				 
//				4'b0110: result=7'b0000010; //6
//				4'b0111: result=7'b1111000; //7
//				 
//				4'b1000: result=7'b0000000; //8
//				4'b1001: result=7'b0010000; //9
//				 
//				4'b1010: result=7'b0001000; //A
//				4'b1011: result=7'b0000011; //B
//				 
//				4'b1100: result=7'b1000110; //C
//				4'b1101: result=7'b0100001; //D
//				 
//				4'b1110: result=7'b0000110; //E
//				4'b1111: result=7'b0001110; //F
//			endcase
//			fn_sevenseg_driver=result;
//			end
//endfunction
//assign HEX0=fn_sevenseg_driver(top_real); assign HEX1=fn_sevenseg_driver(top_imag);
//At every posedge of CLK_50, k_bit_counter is incremented and effect of MSB is mapped to dut_clk
endmodule