module fir_treb (d_in, d_out, clk);

parameter FILTER_SIZE = 26, COEF_WIDTH = 16;

input clk;
input signed [31:0] d_in;
output reg signed [31:0] d_out = 0;

reg signed [COEF_WIDTH + 2 - 1:0] coef_all [FILTER_SIZE-1 : 0] = '{ 
-1,
-1,
1,
2,
0,
0,
4,
8,
6,
0,
4,
15,
11,
-9,
-15,
4,
7,
-33,
-67,
-40,
0,
-49,
-155,
-134,
97,
344
};


reg signed [31:0] shift_reg [FILTER_SIZE*2-2:0];

integer j;


always @ (posedge clk)
	begin
	
		shift_reg[0] <= d_in / 128;
		
		
		for (j = FILTER_SIZE*2-2; j > 0; j = j - 1)
			shift_reg[j] <= shift_reg[j-1];
		
end

always @(negedge clk)
	begin
			d_out <= (coef_all[25] * shift_reg[25]
			+ coef_all[24] * (shift_reg[26] + shift_reg[24])
			+ coef_all[23] * (shift_reg[27] + shift_reg[23])
			+ coef_all[22] * (shift_reg[28] + shift_reg[22])
			+ coef_all[21] * (shift_reg[29] + shift_reg[21])
			+ coef_all[20] * (shift_reg[30] + shift_reg[20])
			+ coef_all[19] * (shift_reg[31] + shift_reg[19])
			+ coef_all[18] * (shift_reg[32] + shift_reg[18])
			+ coef_all[17] * (shift_reg[33] + shift_reg[17])
			+ coef_all[16] * (shift_reg[34] + shift_reg[16])
			+ coef_all[15] * (shift_reg[35] + shift_reg[15])
			+ coef_all[14] * (shift_reg[36] + shift_reg[14])
			+ coef_all[13] * (shift_reg[37] + shift_reg[13])
			+ coef_all[12] * (shift_reg[38] + shift_reg[12])
			+ coef_all[11] * (shift_reg[39] + shift_reg[11])
			+ coef_all[10] * (shift_reg[40] + shift_reg[10])
			+ coef_all[9] * (shift_reg[41] + shift_reg[9])
			+ coef_all[8] * (shift_reg[42] + shift_reg[8])
			+ coef_all[7] * (shift_reg[43] + shift_reg[7])
			+ coef_all[6] * (shift_reg[44] + shift_reg[6])
			+ coef_all[5] * (shift_reg[45] + shift_reg[5])
			+ coef_all[4] * (shift_reg[46] + shift_reg[4])
			+ coef_all[3] * (shift_reg[47] + shift_reg[3])
			+ coef_all[2] * (shift_reg[48] + shift_reg[2])
			+ coef_all[1] * (shift_reg[49] + shift_reg[1])
			+ coef_all[0] * (shift_reg[50] + shift_reg[0]));

	end

endmodule
