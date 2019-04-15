module equalizer_ctrl(
	level,
	enter,
	band_select,

	d_in,
	d_out,
	
	clk
	);

input [9:0] level ;
input [1:0] band_select;
input [31:0] d_in;
input enter, clk;

reg [7:0] bass_out,mid_out,treble_out;

output reg signed[31:0] d_out;

wire signed [31:0] bass_atten_to_fir, mid_atten_to_fir, treb_atten_to_fir, bass_filtered, mid_filtered, treb_filtered; 

parameter BASS_BAND = 0;
parameter MID_BAND = 1;
parameter TREBLE_BAND = 2;

attenuator bass_atten(.d_in(bass_atten_to_fir), .d_out(bass_filtered), .val(bass_out));
attenuator mid_atten(.d_in(mid_atten_to_fir), .d_out(mid_filtered), .val(mid_out));
attenuator treb_atten(.d_in(treb_atten_to_fir), .d_out(treb_filtered), .val(treble_out));

fir_bass bass_filter(.d_in(d_in), .d_out(bass_atten_to_fir), .clk(clk));
fir_mid mid_filter(.d_in(d_in), .d_out(mid_atten_to_fir), .clk(clk));
fir_treb treb_filter(.d_in(d_in), .d_out(treb_atten_to_fir), .clk(clk));

always @ (posedge clk)
d_out <= (bass_filtered + mid_filtered + treb_filtered) / 4;

always @ (posedge enter) begin
	case (band_select)
		BASS_BAND: begin
			 bass_out <= level;
		end

		MID_BAND: begin
			 mid_out <= level;
		end
		
		TREBLE_BAND: begin
			treble_out <= level;
		end
		
	endcase
end

endmodule
