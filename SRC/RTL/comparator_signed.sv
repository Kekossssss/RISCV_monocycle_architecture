//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : Comparator module for signed values, configurable in input data lengths, default to single bit operations

`timescale 1ns/1ps

module comparator_signed #(
	parameter nb_bits = 32
)(
	input logic [nb_bits-1:0] A_i, B_i,
	output logic greater_o, equal_o, lesser_o
);
	//Internal connection declaration
	logic neg_s, equal_s;
	//Module declaration
	substract #(nb_bits) SUB (
		.A_i(A_i),
		.B_i(B_i),
		.Bin_i(0),
		.Bout_o(neg_s)
	);
	comparator_unsigned #(32) COMP_U (
		.A_i(A_i),
		.B_i(B_i),
		.equal_o(equal_s)
	);
	and_gate #(0,1) AND_GREATER (
		.a_i(~neg_s),
		.b_i(~equal_s),
		.s_o(greater_o)
	);
	and_gate #(0,1) AND_LESSER (
		.a_i(neg_s),
		.b_i(~equal_s),
		.s_o(lesser_o)
	);
	//Output value assignation
	assign equal_o = equal_s;
endmodule : comparator_signed
