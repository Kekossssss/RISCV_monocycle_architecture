//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : Adder module that doesn't take carry flags in input

`timescale 1ns/1ps

module half_adder (
	input logic a_i, b_i,
	output logic s_o, c_o
);
	assign s_o = (a_i ^ b_i);
	assign c_o = (a_i & b_i);
endmodule : half_adder
