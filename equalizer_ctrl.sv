module equalizer_ctrl(
	enter,
	
	bass_level,
	mid_level,
	treble_level,

	d_in,
	d_out,
	
	clk
	);

input signed [32:1] d_in;
input enter, clk;

input signed [4:0] bass_level,mid_level,treble_level;

output reg signed[32:1] d_out;

reg signed [17:0] coef_bass [25:0] = '{
2,
2,
3,
3,
4,
5,
6,
8,
10,
11,
14,
16,
18,
21,
23,
26,
28,
31,
33,
35,
37,
39,
40,
41,
42,
42
};

reg signed [17:0] coef_mid [25:0] = '{
-1,
-1,
-2,
-3,
-4,
-6,
-9,
-11,
-14,
-16,
-18,
-19,
-19,
-17,
-13,
-7,
1,
11,
22,
34,
47,
58,
69,
78,
84,
87
};

reg signed [17:0] coef_treb [25:0] = '{
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

reg signed [17:0] coef_final [25:0];
reg signed [31:0] shift_reg [50:0];
integer i;
integer j;

always @(negedge enter)begin

	for (i = 25; i > -1; i = i - 1)
		coef_final[i] <= (coef_bass[i]*bass_level + coef_mid[i]*mid_level + coef_treb[i]*treble_level)/3;	
	
end

always @ (posedge clk)
	begin
	
		shift_reg[0] <= d_in/128;
		
		
		for (j = 50; j > 0; j = j - 1)
			shift_reg[j] <= shift_reg[j-1];
		
end

always @(negedge clk)
	begin
			d_out <= (coef_final[25] * shift_reg[25]
			+ coef_final[24] * (shift_reg[26] + shift_reg[24])
			+ coef_final[23] * (shift_reg[27] + shift_reg[23])
			+ coef_final[22] * (shift_reg[28] + shift_reg[22])
			+ coef_final[21] * (shift_reg[29] + shift_reg[21])
			+ coef_final[20] * (shift_reg[30] + shift_reg[20])
			+ coef_final[19] * (shift_reg[31] + shift_reg[19])
			+ coef_final[18] * (shift_reg[32] + shift_reg[18])
			+ coef_final[17] * (shift_reg[33] + shift_reg[17])
			+ coef_final[16] * (shift_reg[34] + shift_reg[16])
			+ coef_final[15] * (shift_reg[35] + shift_reg[15])
			+ coef_final[14] * (shift_reg[36] + shift_reg[14])
			+ coef_final[13] * (shift_reg[37] + shift_reg[13])
			+ coef_final[12] * (shift_reg[38] + shift_reg[12])
			+ coef_final[11] * (shift_reg[39] + shift_reg[11])
			+ coef_final[10] * (shift_reg[40] + shift_reg[10])
			+ coef_final[9] * (shift_reg[41] + shift_reg[9])
			+ coef_final[8] * (shift_reg[42] + shift_reg[8])
			+ coef_final[7] * (shift_reg[43] + shift_reg[7])
			+ coef_final[6] * (shift_reg[44] + shift_reg[6])
			+ coef_final[5] * (shift_reg[45] + shift_reg[5])
			+ coef_final[4] * (shift_reg[46] + shift_reg[4])
			+ coef_final[3] * (shift_reg[47] + shift_reg[3])
			+ coef_final[2] * (shift_reg[48] + shift_reg[2])
			+ coef_final[1] * (shift_reg[49] + shift_reg[1])
			+ coef_final[0] * (shift_reg[50] + shift_reg[0]));

	end

endmodule
