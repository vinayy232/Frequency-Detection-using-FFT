module fft_dit(reset,clk,r_in_value,i_in_value,r_out_value,i_out_value,start,sot,done,clk_toggle);
	input reset;
	input clk;
	input start;
	input [31:0] r_in_value;
	input [31:0] i_in_value;
	output reg [31:0] r_out_value;
	output reg [31:0] i_out_value;
	//uncomment below lines to make output zero when no output	
	//output reg [31:0] r_out_value = 32'd0;
	//output reg [31:0] i_out_value = 32'd0;
	reg[31:0] r_output_value[31:0];
	reg [31:0] r_input_value[31:0];
	reg[31:0] i_output_value[31:0];
	reg [31:0] i_input_value[31:0];
	reg[31:0] r_stg1_op_value[31:0];
	reg[31:0] i_stg1_op_value[31:0];
	reg[31:0] r_stg2_op_value[31:0];
	reg[31:0] i_stg2_op_value[31:0];
	reg[31:0] r_stg3_op_value[31:0];
	reg[31:0] i_stg3_op_value[31:0];
	reg[31:0] r_stg4_op_value[31:0];
	reg[31:0] i_stg4_op_value[31:0];
	reg[31:0] r_stg5_op_value[31:0];
	reg[31:0] i_stg5_op_value[31:0];
	//reg[31:0] w8_int_value[31:0];
	reg [4:0] indices_value [31:0];
	reg [4:0] var_temp;
	integer i,j,k,l,m,n,o,p,z,r = 0;
	output reg done = 0;
	output reg sot = 0;
	output reg clk_toggle = 0;
	//reg [5:0]j;
	reg [31:0]real_twiddle_4[1:0]; 
	reg [31:0]imag_twiddle_4[1:0];
	reg [31:0]real_twiddle_8[3:0]; 
	reg [31:0]imag_twiddle_8[3:0];
	reg [31:0]real_twiddle_16[7:0]; 
	reg [31:0]imag_twiddle_16[7:0];
	reg [31:0]real_twiddle_32[15:0]; 
	reg [31:0]imag_twiddle_32[15:0];
	//reg [31:0] zero_inp;
	reg comp_complete = 0;
initial begin
    indices_value[0]  = 5'd0;
    indices_value[1]  = 5'd16;
    indices_value[2]  = 5'd8;
    indices_value[3]  = 5'd24;
    indices_value[4]  = 5'd4;
    indices_value[5]  = 5'd20;
    indices_value[6]  = 5'd12;
    indices_value[7]  = 5'd28;
    indices_value[8]  = 5'd2;
    indices_value[9]  = 5'd18;
    indices_value[10] = 5'd10;
    indices_value[11] = 5'd26;
    indices_value[12] = 5'd6;
    indices_value[13] = 5'd22;
    indices_value[14] = 5'd14;
    indices_value[15] = 5'd30;
    indices_value[16] = 5'd1;
    indices_value[17] = 5'd17;
    indices_value[18] = 5'd9;
    indices_value[19] = 5'd25;
    indices_value[20] = 5'd5;
    indices_value[21] = 5'd21;
    indices_value[22] = 5'd13;
    indices_value[23] = 5'd29;
    indices_value[24] = 5'd3;
    indices_value[25] = 5'd19;
    indices_value[26] = 5'd11;
    indices_value[27] = 5'd27;
    indices_value[28] = 5'd7;
    indices_value[29] = 5'd23;
    indices_value[30] = 5'd15;
    indices_value[31] = 5'd31;
	 
	 real_twiddle_4[0] = 32'd1;
	 imag_twiddle_4[0] = 32'd0;
	 real_twiddle_4[1] = 32'd0;
	 imag_twiddle_4[1] = 32'd1*-1;
	 
	 real_twiddle_8[0] = 32'd2048;
	 imag_twiddle_8[0] = 32'd0;
	 real_twiddle_8[1] = 32'd1448;
	 imag_twiddle_8[1] = 32'd1448*-1;
	 real_twiddle_8[2] = 32'd0;
	 imag_twiddle_8[2] = 32'd2048*-1;
	 real_twiddle_8[3] = 32'd1448*-1;
	 imag_twiddle_8[3] = 32'd1448*-1;
	 
	 //real_twiddle_16 = {
    real_twiddle_16[0] = 32'd2048;           // 2048
    real_twiddle_16[1]=32'd1892;           // 1892.105283
    real_twiddle_16[2]=32'd1448;           // 1448.154688
    real_twiddle_16[3]=32'd783;            // 783.7356695
    real_twiddle_16[4]=32'd0;              // 0
    real_twiddle_16[5]=32'd783*-1;           // -783.7356695
    real_twiddle_16[6]=32'd1448*-1;          // -1448.154688
    real_twiddle_16[7]=32'd1892*-1;           // -1892.105283
	 //};
	 
	 //imag_twiddle_16 = {
   imag_twiddle_16[0]=32'd0;              // 0
    imag_twiddle_16[1]=32'd783 * -1;       // -783.7356695
    imag_twiddle_16[2]=32'd1448 * -1;      // -1448.154688
    imag_twiddle_16[3]=32'd1892 * -1;      // -1892.105283
    imag_twiddle_16[4]=32'd2048 * -1;     // -2048
    imag_twiddle_16[5]=32'd1892 * -1;     // -1892.105283
    imag_twiddle_16[6]=32'd1448 * -1;     // -1448.154688
    imag_twiddle_16[7]=32'd783 * -1 ;       // -783.7356695
//};
	 real_twiddle_32[0] = 32'd2048;
		real_twiddle_32[1] = 32'd2009;
		real_twiddle_32[2] = 32'd1892;
		real_twiddle_32[3] = 32'd1703;
		real_twiddle_32[4] = 32'd1448;
		real_twiddle_32[5] = 32'd1138;
		real_twiddle_32[6] = 32'd784;
		real_twiddle_32[7] = 32'd400;
		real_twiddle_32[8] = 32'd0;
		real_twiddle_32[9] = 32'd400* -1;
		real_twiddle_32[10] = 32'd784* -1;
		real_twiddle_32[11] = 32'd1138* -1;
		real_twiddle_32[12] = 32'd1448* -1;
		real_twiddle_32[13] = 32'd1703* -1;
		real_twiddle_32[14] = 32'd1892* -1;
		real_twiddle_32[15] = 32'd2009* -1;
	   
		imag_twiddle_32[0] = 32'd0;
		imag_twiddle_32[1] = 32'd400* -1;
		imag_twiddle_32[2] = 32'd784* -1;
		imag_twiddle_32[3] = 32'd1138* -1;
		imag_twiddle_32[4] = 32'd1448* -1;
		imag_twiddle_32[5] = 32'd1703* -1;
		imag_twiddle_32[6] = 32'd1892* -1;
		imag_twiddle_32[7] = 32'd2009* -1;
		imag_twiddle_32[8] = 32'd2048* -1;
		imag_twiddle_32[9] = 32'd2009* -1;
		imag_twiddle_32[10] = 32'd1892* -1;
		imag_twiddle_32[11] = 32'd1703* -1;
		imag_twiddle_32[12] = 32'd1448* -1;
		imag_twiddle_32[13] = 32'd1138* -1;
		imag_twiddle_32[14] = 32'd784* -1;
		imag_twiddle_32[15] = 32'd400* -1;
		//zero_inp = 32'hFFFFFFFF;
//	 for(i=0;i<32;i=i+1)
//				begin
//				input_value[i] <= i*10;
//	end
	j = 0;
	i=0;
	
end
//always@(posedge clk) begin
//	if ( reset == 1) begin 
//		zero_inp = 32'hFFFFFFFF;
//	end else begin
//	end
////		for (r=0;r<32;r=r+1) begin	
////			r_input_value[i] <= 0;
////			i_input_value[i] <= 0;
////		end
//		
//		
//
//end
always @(posedge clk) begin
	clk_toggle=~clk_toggle;
end
//assign clk_toggle = clk;

always @(posedge clk) begin
		if ( reset == 1) begin 
			for (r=0;r<32;r=r+1) begin
				r_input_value[r] = 32'd0;
				i_input_value[r] = 32'd0;
				
				//i = 0;
			end
//			r_out_value = 32'h00000000;
//			i_out_value = 32'h00000000;
		end else begin
		if (i<32 && (start == 1) && reset == 0 ) begin
			r_input_value[i] = r_in_value;
			i_input_value[i] = i_in_value;
			i = i+1;
		end
	end
end

		

always @(posedge clk) begin
	if (i == 32) begin
		for(k=0;k<32;k=k+1)
					begin
					var_temp = indices_value[k];
					r_output_value[k] = r_input_value[var_temp];
					i_output_value[k] = i_input_value[var_temp];
		end
		
	end
//uncomment below to give output to out_value line	
//	if (k == 32) begin	
//		out_value <= output_value[j];
//		j <= j+1;
//	end
end
//2 pt butterfly
always @(posedge clk) begin
	if (k == 32) begin
		for(l=0;l<32;l=l+2)
					begin
					r_stg1_op_value[l] = r_output_value[l] + (r_output_value[l + 1] * real_twiddle_4[0]) - (i_output_value[l + 1] * imag_twiddle_4[0]);
					i_stg1_op_value[l] = i_output_value[l] + (r_output_value[l + 1] * imag_twiddle_4[0]) + (i_output_value[l + 1] * real_twiddle_4[0]);

					r_stg1_op_value[l + 1] = r_output_value[l] - (r_output_value[l + 1] * real_twiddle_4[0]) + (i_output_value[l + 1] * imag_twiddle_4[0]);
					i_stg1_op_value[l+1] = i_output_value[l] - (r_output_value[l + 1] * imag_twiddle_4[0]) - (i_output_value[l + 1] * real_twiddle_4[0]);
		end
		
	end
end

always @(posedge clk) begin
	if (l == 32) begin
			for(m=0;m<32;m=m+4)
						begin
						
						r_stg2_op_value[m]= r_stg1_op_value[m] + (r_stg1_op_value[m + 2] * real_twiddle_4[0]) - (i_stg1_op_value[m + 2] * imag_twiddle_4[0]);
						i_stg2_op_value[m] = i_stg1_op_value[m] + (r_stg1_op_value[m + 2] * imag_twiddle_4[0]) + (i_stg1_op_value[m + 2] * real_twiddle_4[0]);

							 // Butterfly 1
						r_stg2_op_value[m+1] = r_stg1_op_value[m + 1] + (r_stg1_op_value[m + 3] * real_twiddle_4[1]) - (i_stg1_op_value[m + 3] * imag_twiddle_4[1]);
						i_stg2_op_value[m+1] = i_stg1_op_value[m + 1] + (r_stg1_op_value[m + 3] * imag_twiddle_4[1]) + (i_stg1_op_value[m + 3] * real_twiddle_4[1]);

							 // Butterfly 2
						r_stg2_op_value[m+2] = r_stg1_op_value[m] - (r_stg1_op_value[m + 2] * real_twiddle_4[0]) + (i_stg1_op_value[m + 2] * imag_twiddle_4[0]);
						i_stg2_op_value[m+2] = i_stg1_op_value[m] - (r_stg1_op_value[m + 2] * imag_twiddle_4[0]) - (i_stg1_op_value[m + 2] * real_twiddle_4[0]);

							 // Butterfly 3
						r_stg2_op_value[m+3] = r_stg1_op_value[m+1] - (r_stg1_op_value[m + 3] * real_twiddle_4[1]) + (i_stg1_op_value[m + 3] * imag_twiddle_4[1]);
						i_stg2_op_value[m+3] = i_stg1_op_value[m+1] - (r_stg1_op_value[m + 3] * imag_twiddle_4[1]) - (i_stg1_op_value[m + 3] * real_twiddle_4[1]);

						
			end
		
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

always @(posedge clk) begin
	if (m == 32) begin
			for(n=0;n<32;n=n+8)
						begin
						r_stg3_op_value[n] = r_stg2_op_value[n] + fp_mul(r_stg2_op_value[n+4], real_twiddle_8[0]) - fp_mul(i_stg2_op_value[n+4], imag_twiddle_8[0]);
						i_stg3_op_value[n] = i_stg2_op_value[n] + fp_mul(r_stg2_op_value[n+4], imag_twiddle_8[0]) + fp_mul(i_stg2_op_value[n+4], real_twiddle_8[0]);
						r_stg3_op_value[n + 4] = r_stg2_op_value[n] - fp_mul(r_stg2_op_value[n+4], real_twiddle_8[0]) + fp_mul(i_stg2_op_value[n+4], imag_twiddle_8[0]);
						i_stg3_op_value[n + 4] = i_stg2_op_value[n] - fp_mul(r_stg2_op_value[n+4], imag_twiddle_8[0]) - fp_mul(i_stg2_op_value[n+4], real_twiddle_8[0]);
//
						r_stg3_op_value[n + 1] = r_stg2_op_value[n+1] + fp_mul(r_stg2_op_value[n+5], real_twiddle_8[1]) - fp_mul(i_stg2_op_value[n+5], imag_twiddle_8[1]);
						i_stg3_op_value[n + 1] = i_stg2_op_value[n+1] + fp_mul(r_stg2_op_value[n+5], imag_twiddle_8[1]) + fp_mul(i_stg2_op_value[n+5], real_twiddle_8[1]);
						r_stg3_op_value[n + 5] = r_stg2_op_value[n+1] - fp_mul(r_stg2_op_value[n+5], real_twiddle_8[1]) + fp_mul(i_stg2_op_value[n+5], imag_twiddle_8[1]);
						i_stg3_op_value[n + 5] = i_stg2_op_value[n+1] - fp_mul(r_stg2_op_value[n+5], imag_twiddle_8[1]) - fp_mul(i_stg2_op_value[n+5], real_twiddle_8[1]);
//
						r_stg3_op_value[n + 2] = r_stg2_op_value[n+2] + fp_mul(r_stg2_op_value[n+6], real_twiddle_8[2]) - fp_mul(i_stg2_op_value[n+6], imag_twiddle_8[2]);
						i_stg3_op_value[n + 2] = i_stg2_op_value[n+2] + fp_mul(r_stg2_op_value[n+6], imag_twiddle_8[2]) + fp_mul(i_stg2_op_value[n+6], real_twiddle_8[2]);
						r_stg3_op_value[n + 6] = r_stg2_op_value[n+2] - fp_mul(r_stg2_op_value[n+6], real_twiddle_8[2]) + fp_mul(i_stg2_op_value[n+6], imag_twiddle_8[2]);
						i_stg3_op_value[n + 6] = i_stg2_op_value[n+2] - fp_mul(r_stg2_op_value[n+6], imag_twiddle_8[2]) - fp_mul(i_stg2_op_value[n+6], real_twiddle_8[2]);
//
						r_stg3_op_value[n + 3] = r_stg2_op_value[n+3] + fp_mul(r_stg2_op_value[n+7], real_twiddle_8[3]) - fp_mul(i_stg2_op_value[n+7], imag_twiddle_8[3]);
						i_stg3_op_value[n + 3] = i_stg2_op_value[n+3] + fp_mul(r_stg2_op_value[n+7], imag_twiddle_8[3]) + fp_mul(i_stg2_op_value[n+7], real_twiddle_8[3]);
						r_stg3_op_value[n + 7] = r_stg2_op_value[n+3] - fp_mul(r_stg2_op_value[n+7], real_twiddle_8[3]) + fp_mul(i_stg2_op_value[n+7], imag_twiddle_8[3]);
						i_stg3_op_value[n + 7] = i_stg2_op_value[n+3] - fp_mul(r_stg2_op_value[n+7], imag_twiddle_8[3]) - fp_mul(i_stg2_op_value[n+7], real_twiddle_8[3]);
						
			end
		
	end
end

always @(posedge clk) begin
	if (n == 32) begin
			for(o=0;o<32;o=o+16)
						begin
						for(z=0;z<8;z=z+1)
						begin
						r_stg4_op_value[o + z] = r_stg3_op_value[o + z] + fp_mul(r_stg3_op_value[o+z+8], real_twiddle_16[z]) - fp_mul(i_stg3_op_value[o+z+8], imag_twiddle_16[z]);
						i_stg4_op_value[o + z] = i_stg3_op_value[o + z] + fp_mul(r_stg3_op_value[o+z+8], imag_twiddle_16[z]) + fp_mul(i_stg3_op_value[o+z+8], real_twiddle_16[z]);
						r_stg4_op_value[o + z +8] = r_stg3_op_value[o + z] - fp_mul(r_stg3_op_value[o+z+8], real_twiddle_16[z]) + fp_mul(i_stg3_op_value[o+z+8], imag_twiddle_16[z]);
						i_stg4_op_value[o + z + 8] = i_stg3_op_value[o + z] - fp_mul(r_stg3_op_value[o+z+8], imag_twiddle_16[z]) - fp_mul(i_stg3_op_value[o+z+8], real_twiddle_16[z]);
					
						end
			end
		
	end
end

always @(posedge clk) begin
	if (o == 32) begin
			for(p=0;p<32;p=p+32)
						begin
					for(z=0;z<16;z=z+1)
						begin
						r_stg5_op_value[p+z] = r_stg4_op_value[p+z] + fp_mul(r_stg4_op_value[p+z+16], real_twiddle_32[z]) - fp_mul(i_stg4_op_value[p+z+16], imag_twiddle_32[z]);
						i_stg5_op_value[p+z] = i_stg4_op_value[p+z] + fp_mul(r_stg4_op_value[p+z+16], imag_twiddle_32[z]) + fp_mul(i_stg4_op_value[p+z+16], real_twiddle_32[z]);
						r_stg5_op_value[p+z+16] = r_stg4_op_value[p+z] - fp_mul(r_stg4_op_value[p+z+16], real_twiddle_32[z]) + fp_mul(i_stg4_op_value[p+z+16], imag_twiddle_32[z]);
						i_stg5_op_value[p+z+16] = i_stg4_op_value[p+z] - fp_mul(r_stg4_op_value[p+z+16], imag_twiddle_32[z]) - fp_mul(i_stg4_op_value[p+z+16], real_twiddle_32[z]);
					
					end
			
			end
		comp_complete <= 1'b1;
		
	end
end
 
always @(posedge clk) begin
	
	if (p == 32 && comp_complete == 1 && done == 0) begin
		//soc <= 1;
		//comp_complete <= 1'b1;
		r_out_value = r_stg5_op_value[j];
		i_out_value = i_stg5_op_value[j];
		j <= j+1;
		if(j == 32 && reset == 0) done <= 1;
		else done <= 0;
//uncomment below lines to make output zero when no output		
//	end else begin
//		r_out_value = 32'h00000000;
//		i_out_value = 32'h00000000;
		//if ( reset == 1) done <= 0;  
	end	
end
always @(posedge clk) begin
	//if ( reset == 1) sot <= 0; 
	if (comp_complete) sot <= 1;
	else sot <= 0;
	//if (done) r_out_value = 32'h00000000;i_out_value = 32'h00000000;
end		


endmodule

