module fft_wrapper(input reset,input dut_clk, output  startoftx, output compoftx, output wrap_toggle,output reg [3:0]real_out,output reg [3:0]imag_out, output [4:0] outp_bin);
wire clk,f_reset,main_start;
//reg reset = 0;
wire [31:0] r_inp;
wire [31:0] r_outp;
wire [31:0] i_inp;
wire [31:0] i_outp;
reg start;

wire fft_done;
wire fft_sot;
wire fft_toggle;
fft_dit fft_dit_dut (f_reset,clk,r_inp,i_inp,r_outp,i_outp,main_start,fft_sot,fft_done,fft_toggle);

reg [66:0] rom[150:0];
reg [66:0] romout;
reg [8:0] romaddr =0;
reg [31:0] store_r_output[31:0];
reg [31:0] store_i_output[31:0];
reg [31:0] mod_r_output[31:0];
reg [31:0] mod_i_output[31:0];
reg [31:0] real_imag_outp[31:0];
reg [7:0] small_real_imag_outp[31:0];
reg[7:0] threshold_comp;
reg [5:0] j =0;
reg [4:0] outp_j =0;
reg[3:0] count =0;
integer k = 0;
integer i;
reg init_val =0;
integer b =0;
always @(*) begin romout<= rom[romaddr]; // assigning output of rom from selected rom address
	end
always @(posedge dut_clk) begin
	if( romaddr < 150) begin
	romaddr <= romaddr +1; // if result is not ready then rom addr is getting incremented by 1
	end
end


always @(posedge romout[0]) begin
   if (fft_sot == 1 && fft_done == 0 ) begin
//			store_r_output[k] = r_outp;
//			store_i_output[k] = i_outp;
			if(r_outp[31] == 1) begin
				mod_r_output[k] = r_outp * -1;
				
			end else begin
				mod_r_output[k] = r_outp;
			end
			if(i_outp[31] == 1) begin
				mod_i_output[k] = i_outp * -1;
				
			end else begin
				mod_i_output[k] = i_outp;
			end
			k = k+1;
	end
	if (k == 32) begin
		if(j==0) begin
			for(j =0;j<32;j=j+1) begin
				real_imag_outp[j] = mod_i_output[j] + mod_r_output[j];
				small_real_imag_outp[j] = fp_mul(real_imag_outp[j],32'd2);	
			end
			end
	end
	
end
always @(posedge romout[0]) begin

	if (fft_done) begin
		
	for(b =0;b<32;b=b+1) begin
		threshold_comp = small_real_imag_outp[b];
		if(threshold_comp >20) init_val =1'b1;
		if (threshold_comp < 20 && b <16 && init_val == 0) begin
			count = count + 1;

			end
	end
end
outp_j <= count;
end
end
function reg[31:0] fp_mul;
    input reg[31:0] a;
    input reg[31:0] b;
    //output reg [31:0] fpmul
	 reg [31:0] result_mul;
	 begin
	 result_mul = a * b;
	 
	 fp_mul[31:21] = {11{result_mul[31]}};
	 fp_mul[20:0] = result_mul[31:11];
	 end
	 //return fp_mul;
	 
endfunction

assign clk = romout[0];
assign f_reset = romout[1];
assign main_start =romout[2];
assign r_inp = romout[66:35];
assign i_inp = romout[34:3];
assign startoftx = fft_sot;
assign compoftx = fft_done;
assign wrap_toggle = fft_toggle;
assign outp_bin = outp_j;
//assign store_r_output = r_outp;
//assign store_i_output = i_outp;
//assign real_out = r_outp[3:0];
//assign imag_out = i_outp[3:0];  	
initial
begin
//       in_real|in_imag|start|reset|clk
rom[0]= {32'd0,32'd0,1'b0,1'b0,1'b0};
rom[1]= {32'd0,32'd0,1'b0,1'b0,1'b1};
rom[2]= {32'd0,32'd0,1'b0,1'b0,1'b0};
rom[3]= {32'd0,32'd0,1'b0,1'b0,1'b1};

rom[4]= {32'd0,32'd0,1'b0,1'b1,1'b0};
rom[5]= {32'd0,32'd0,1'b0,1'b1,1'b1};
rom[6]= {32'd0,32'd0,1'b0,1'b1,1'b0};
rom[7]= {32'd0,32'd0,1'b0,1'b1,1'b1};

rom[8]= {32'd0,32'd1,1'b0,1'b0,1'b0};
rom[9]= {32'd0,32'd0,1'b0,1'b0,1'b1};
rom[10]={32'd0,32'd0,1'b0,1'b0,1'b0};
rom[11]={32'd0,32'd0,1'b0,1'b0,1'b1};

//uncomment for real world 2HZ signal sampled at 16HZ 
//rom[12] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[13] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[14] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[15] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[16] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[17] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[18] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[19] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[20] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[21] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[22] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[23] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[24] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[25] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[26] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[27] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b1};
//
//
//rom[28] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[29] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[30] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[31] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[32] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[33] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[34] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[35] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[36] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[37] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[38] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[39] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[40] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[41] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[42] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[43] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b1};
//
//rom[44] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[45] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[46] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[47] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[48] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[49] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[50] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[51] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[52] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[53] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[54] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[55] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[56] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[57] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[58] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[59] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b1};
//
//rom[60] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[61] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[62] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[63] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[64] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[65] = {32'd2048, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[66] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[67] = {32'd1448, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[68] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[69] = {32'd0, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[70] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[71] = {32'd1448* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[72] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[73] = {32'd2048* -1, 32'd0, 1'b1, 1'b0, 1'b1};
//rom[74] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b0};
//rom[75] = {32'd1448 * -1, 32'd0, 1'b1, 1'b0, 1'b1};



rom[12]={32'd0,32'd0,1'b1,1'b0,1'b0};
rom[13]={32'd0,32'd0,1'b1,1'b0,1'b1};

rom[14]={32'd205,32'd2048,1'b1,1'b0,1'b0};
rom[15]={32'd205,32'd2048,1'b1,1'b0,1'b1};

rom[16]={32'd410,32'd4096,1'b1,1'b0,1'b0};
rom[17]={32'd410,32'd4096,1'b1,1'b0,1'b1};

rom[18]={32'd614,32'd6144,1'b1,1'b0,1'b0};
rom[19]={32'd614,32'd6144,1'b1,1'b0,1'b1};

rom[20]={32'd819,32'd8192,1'b1,1'b0,1'b0};
rom[21]={32'd819,32'd8192,1'b1,1'b0,1'b1};

rom[22]={32'd1024,32'd10240,1'b1,1'b0,1'b0};
rom[23]={32'd1024,32'd10240,1'b1,1'b0,1'b1};

rom[24]={32'd1229,32'd12288,1'b1,1'b0,1'b0};
rom[25]={32'd1229,32'd12288,1'b1,1'b0,1'b1};

rom[26]={32'd1434,32'd14336,1'b1,1'b0,1'b0};
rom[27]={32'd1434,32'd14336,1'b1,1'b0,1'b1};

rom[28]={32'd1638,32'd16384,1'b1,1'b0,1'b0};
rom[29]={32'd1638,32'd16384,1'b1,1'b0,1'b1};

rom[30]={32'd1843,32'd18432,1'b1,1'b0,1'b0};
rom[31]={32'd1843,32'd18432,1'b1,1'b0,1'b1};

rom[32]={32'd2048,32'd20480,1'b1,1'b0,1'b0};
rom[33]={32'd2048,32'd20480,1'b1,1'b0,1'b1};

rom[34]={32'd2253,32'd22528,1'b1,1'b0,1'b0};
rom[35]={32'd2253,32'd22528,1'b1,1'b0,1'b1};

rom[36]={32'd2458,32'd24576,1'b1,1'b0,1'b0};
rom[37]={32'd2458,32'd24576,1'b1,1'b0,1'b1};

rom[38]={32'd2662,32'd26624,1'b1,1'b0,1'b0};
rom[39]={32'd2662,32'd26624,1'b1,1'b0,1'b1};

rom[40]={32'd2867,32'd28672,1'b1,1'b0,1'b0};
rom[41]={32'd2867,32'd28672,1'b1,1'b0,1'b1};

rom[42]={32'd3072,32'd30720,1'b1,1'b0,1'b0};
rom[43]={32'd3072,32'd30720,1'b1,1'b0,1'b1};

rom[44]={32'd3277,32'd32768,1'b1,1'b0,1'b0};
rom[45]={32'd3277,32'd32768,1'b1,1'b0,1'b1};

rom[46]={32'd3482,32'd34816,1'b1,1'b0,1'b0};
rom[47]={32'd3482,32'd34816,1'b1,1'b0,1'b1};

rom[48]={32'd3686,32'd36864,1'b1,1'b0,1'b0};
rom[49]={32'd3686,32'd36864,1'b1,1'b0,1'b1};

rom[50]={32'd3891,32'd38912,1'b1,1'b0,1'b0};
rom[51]={32'd3891,32'd38912,1'b1,1'b0,1'b1};

rom[52]={32'd4096,32'd40960,1'b1,1'b0,1'b0};
rom[53]={32'd4096,32'd40960,1'b1,1'b0,1'b1};

rom[54]={32'd4301,32'd43008,1'b1,1'b0,1'b0};
rom[55]={32'd4301,32'd43008,1'b1,1'b0,1'b1};

rom[56]={32'd4506,32'd45056,1'b1,1'b0,1'b0};
rom[57]={32'd4506,32'd45056,1'b1,1'b0,1'b1};

rom[58]={32'd4710,32'd47104,1'b1,1'b0,1'b0};
rom[59]={32'd4710,32'd47104,1'b1,1'b0,1'b1};

rom[60]={32'd4915,32'd49152,1'b1,1'b0,1'b0};
rom[61]={32'd4915,32'd49152,1'b1,1'b0,1'b1};

rom[62]={32'd5120,32'd51200,1'b1,1'b0,1'b0};
rom[63]={32'd5120,32'd51200,1'b1,1'b0,1'b1};

rom[64]={32'd5325,32'd53248,1'b1,1'b0,1'b0};
rom[65]={32'd5325,32'd53248,1'b1,1'b0,1'b1};

rom[66]={32'd5530,32'd55296,1'b1,1'b0,1'b0};
rom[67]={32'd5530,32'd55296,1'b1,1'b0,1'b1};

rom[68]={32'd5734,32'd57344,1'b1,1'b0,1'b0};
rom[69]={32'd5734,32'd57344,1'b1,1'b0,1'b1};

rom[70]={32'd5939,32'd59392,1'b1,1'b0,1'b0};
rom[71]={32'd5939,32'd59392,1'b1,1'b0,1'b1};

rom[72]={32'd6144,32'd61440,1'b1,1'b0,1'b0};
rom[73]={32'd6144,32'd61440,1'b1,1'b0,1'b1};

rom[74]={32'd6349,32'd63488,1'b1,1'b0,1'b0};
rom[75]={32'd6349,32'd63488,1'b1,1'b0,1'b1};
for(i=76;i<150;i=i+2)
			begin
			rom[i]={32'd1448 * -1, 32'd0,1'b1,1'b0,1'b0};
			rom[i+1]={32'd1448 * -1, 32'd0,1'b1,1'b0,1'b1};
			
end


end
endmodule